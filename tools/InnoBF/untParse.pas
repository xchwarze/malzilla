unit untParse;
interface
uses
{$IFDEF EUREKALOG}
  ExceptionLog,
{$ENDIF}
  Windows, SysUtils, Classes, StructJoin, MyTypes, Struct, ZLib, Msgs, MsgIds, PathFunc,
  {VerInfo,}CmnFunc2, BZlib, SetupEnt, Extract, Main, Int64Em, InstFunc, LZMA, Compress,
  Extract4000, RestoreScript, FileClass,
{$I CompressList.inc}
  ;

type
  TCompresssedBlockReaderClass = class of TAbstractBlockReader;
procedure startAttack(SetupFName: string);
function testPass(Pass: string): boolean;
function readCryptKey: string;

var
  TestID: TSetupID;
  TheBlockReader: TCompresssedBlockReaderClass;
  SetupFileName: string;
  FileMasks: array of string;
//  CodeFileName:string;
  ReconstructedScript: string;
  Password: string;
  WarnOnMod: boolean = false;
  IsUnknownVersion: boolean = false;
  tmpVer: integer;
//  logf:TextFile; logj:integer;

implementation


procedure SetupCorruptError;
begin
  raise EMessage.Create(SSetupFileCorrupt);
end;

function AddFakeFile(FileName, FileContents: string): integer;
var
  pFileEntry: PSetupFileEntry;
  pFileLocationEntry: PSetupFileLocationEntry;
  SystemTime: TSystemTime;
  i: integer;
begin
  pFileLocationEntry := AllocMem(sizeof(TSetupFileLocationEntry));
  with pFileLocationEntry^ do begin
    Contents := FileContents;
    Int64(OriginalSize) := length(FileContents);
    DateTimeToSystemTime(Now, SystemTime);
    SystemTimeToFileTime(SystemTime, TimeStamp);
  end;
  i := Entries[seFileLocation].Add(pFileLocationEntry);
  pFileEntry := AllocMem(sizeof(TSetupFileEntry));
  with pFileEntry^ do begin
    FileType := ftFakeFile;
    DestName := FileName; // RenameFiles() will split this
    LocationEntry := i;
  end;
  Result := Entries[seFile].Add(pFileEntry);
end;

function IsCompatibleVersion: boolean;
const
  SignBegin = 'Inno Setup Setup Data (';
  SignBeginIsx = 'My Inno Setup Extensions Setup Data (';
  Digits = ['0'..'9'];
var
  s: string;
  i, j: integer;
  Ver1, Ver2, Ver3: integer;
begin
  s := TestID; Result := false;
  if pos(SignBegin, s) = 1 then i := length(SignBegin) + 1
  else if pos(SignBeginIsx, s) = 1 then i := length(SignBeginIsx) + 1
  else exit;
  if not (s[i] in ['3', '4', '5']) or (s[i + 1] <> '.') then exit;
  j := i; while (j <= sizeof(TSetupID)) and (s[j] <> ')') do inc(j);
  if (j > sizeof(TSetupID)) then exit;
  FileVersion := copy(s, i, j - i);
  if FileVersion = '3.0.6.1' then FileVersion := '3.0.8'; // ugly hack to support ISX 3.0.6.1 at low cost
  if not ((FileVersion[1] in Digits) and (FileVersion[2] = '.')) then exit;
  Val(copy(FileVersion, 1, 1), Ver1, i); if i <> 0 then exit;
  Val(copy(FileVersion, 3, 1), Ver2, i); if i <> 0 then exit;
  if FileVersion[4] <> '.' then exit;
  j := 5; while (j <= length(FileVersion)) and (FileVersion[j] in Digits) do inc(j);
  Val(copy(FileVersion, 5, j - 5), Ver3, i); if i <> 0 then exit;
  if (j <= length(FileVersion)) then WarnOnMod := true;
  Ver := Ver1 * 1000 + Ver2 * 100 + Ver3;

  // compress.pas support
  if (Ver >= 3000) and (Ver <= 4008) then TheBlockReader := TZlibBlockReader4008
  else if (Ver >= 4009) and (Ver <= 4105) then TheBlockReader := TZlibBlockReader4107
  // version mismatch (4105 vs. 4107) is ok
  else if (Ver > 4105) then TheBlockReader := Compress.TCompressedBlockReader;

  if AttemptUnpackUnknown then begin
    IsUnknownVersion := true; tmpVer := 0;
    for i := 0 to High(VerList) do with VerList[i] do begin
        if VerSupported <= Ver then begin Result := true; if VerSupported > tmpVer then tmpVer := VerSupported; end;
        if VerSupported = Ver then IsUnknownVersion := false;
      end;
  end else
    for i := 0 to High(VerList) do if VerList[i].VerSupported = Ver then begin Result := true; break end;
end;

function IsVersionSuspicious: boolean;
begin
  if (Ver = 3003) or (Ver = 4203) then Result := true else Result := false;
end;

// if the function returns false, the current position in the input stream
// is undefined

function TryStr(Source: TCacheReader; StringCount, MaxSize: Cardinal): boolean;
var
  i, len: cardinal;
begin
  Result := false;
  for i := 1 to StringCount do begin
    Source.Read(len, sizeof(len));
    if len > MaxSize then exit;
    Source.Skip(len);
  end;
  Result := true;
end;

function TryInt(Source: TCacheReader; IntCount, MaxValue: Cardinal): boolean;
var
  i, int: Cardinal;
begin
  Result := false;
  for i := 1 to IntCount do begin
    Source.Read(int, sizeof(int));
    if int > MaxValue then exit;
  end;
  Result := true;
end;

procedure HeuristicVersionFinder(Cache: TCacheReader);
const
  OfsPrivs3004 = 216; SzOpts3004 = 5; Str3004 = 21;
  Str4203 = 23; MoreStr4204 = 27 - 23; Entries4203 = 16;
var
  b: byte;
  bmk, bmk2: Cardinal;
  TryVer: integer;
begin
  with Cache do begin
    CacheEnabled := true; bmk := Bookmark;
    if Ver = 3003 then begin
      SECompressedBlockSkip(Cache, OfsPrivs3004, Str3004);
      Read(b, 1);
      if b > 2 then Ver := 3003 else begin
        Cache.Skip(SzOpts3004);
        if TryStr(Cache, 5, 100) then Ver := 3004 else Ver := 3003;
      end;
    end else if Ver = 4203 then begin
      SECompressedBlockSkip(Cache, Str4203 * 4, Str4203);
      bmk2 := Bookmark;
      if TryStr(Cache, MoreStr4204, 256) then TryVer := 4204
      else begin TryVer := 4203; Seek(bmk2); end;
      Cache.Skip(32);
      if TryInt(Cache, Entries4203, 10000) then Ver := TryVer;
    end;
    Seek(bmk); CacheEnabled := false;
  end;
end;

procedure CreateEntryLists;
var
  I: TEntryType;
begin
  for I := Low(I) to High(I) do
    Entries[I] := TList.Create;
end;

function GetVersionBySetupId(const pSetupId): boolean;
var
  i: integer;
  aSetupId: array[1..12] of char absolute pSetupId;
begin
  VerObject := nil;
  for i := 0 to high(VerList) do
    if VerList[i].SetupID = aSetupID then begin VerObject := VerList[i]; break end;
  Result := VerObject <> nil;
end;

function CheckCrc(SourceF: TFile; RawOffsetTable: pointer; const OffsetTable: TSetupLdrOffsetTable): boolean;
begin
  if OffsetTable.TableCRCUsed and
    (GetCRC32(RawOffsetTable^, VerObject.OfsTabSize - sizeof(OffsetTable.TableCRC)) <> OffsetTable.TableCRC)
    then SetupCorruptError;
  if (SourceF.CappedSize < longword(OffsetTable.TotalSize)) then SetupCorruptError;
  Result := true;
end;

function GetSetupLdrOffsetTableFromResource(Filename: string; SourceF: TFile; var OffsetTable: TSetupLdrOffsetTable): boolean;
var
  hMod: HMODULE;
  Rsrc: HRSRC;
  ResData: HGLOBAL;
//  ResSize: integer;
  p: pointer;
begin
  Result := false;
  hMod := LoadLibraryEx(PChar(Filename), 0, LOAD_LIBRARY_AS_DATAFILE);
  if hMod = 0 then exit;
  repeat
    Rsrc := FindResource(hMod, MAKEINTRESOURCE(SetupLdrOffsetTableResID), RT_RCDATA);
    if Rsrc = 0 then break;
//    ResSize := SizeofResource(hMod, Rsrc);
    ResData := LoadResource(hMod, Rsrc);
    if ResData = 0 then break;
    p := LockResource(ResData);
    if p = nil then break;
    Result := GetVersionBySetupId(PSetupLdrOffsetTable(p)^.Id);
    if not Result then break;
    VerObject.UnifySetupLdrOffsetTable(p^, OffsetTable);
    Result := CheckCrc(SourceF, p, OffsetTable);
  until true;
  FreeLibrary(hMod);
end;

function GetSetupLdrOffsetTableFromFile(SourceF: TFile; var OffsetTable: TSetupLdrOffsetTable): boolean;
var
  aSetupID: array[1..12] of char;
  SizeOfFile, SizeDif: integer;
  ExeHeader: TSetupLdrExeHeader;
  RawOffsetTable: pointer;
begin
  Result := false;
  SizeOfFile := SourceF.CappedSize;
  SourceF.Seek(SetupLdrExeHeaderOffset);
  SourceF.ReadBuffer(ExeHeader, SizeOf(ExeHeader));
  if (ExeHeader.ID <> SetupLdrExeHeaderID) or
    (ExeHeader.OffsetTableOffset <> not ExeHeader.NotOffsetTableOffset) then exit;
  SizeDif := (ExeHeader.OffsetTableOffset + SizeOf(TSetupLdrOffsetTable4010) - SizeOfFile);
  if SizeDif > 4 then exit; // other info might be appended after the offset table
  // assume that TSetupLdrOffsetTable.ID is the same size (12 bytes) for all versions
  SourceF.Seek(ExeHeader.OffsetTableOffset);
  SourceF.ReadBuffer(aSetupID, sizeof(aSetupID));
  SourceF.Seek(ExeHeader.OffsetTableOffset);
  if not GetVersionBySetupId(aSetupId) then SetupCorruptError;
  GetMem(RawOffsetTable, VerObject.OfsTabSize);
  SourceF.ReadBuffer(RawOffsetTable^, VerObject.OfsTabSize);
  VerObject.UnifySetupLdrOffsetTable(RawOffsetTable^, OffsetTable);
  Result := CheckCrc(SourceF, RawOffsetTable, OffsetTable);
end;

procedure SetupLdr;
var
  SelfFilename: string;
  SourceF: TFile;
  OffsetTable: TSetupLdrOffsetTable;
  IsCompatible: boolean;
begin
  SelfFilename := ExpandFileName(SetupFileName);
  SetupLdrOriginalFilename := SelfFilename;
  SourceDir := PathExtractDir(SetupLdrOriginalFilename);
  try
    SourceF := TFile.Create(SelfFilename, fdOpenExisting, faRead, fsRead);
    try
      if not (GetSetupLdrOffsetTableFromFile(SourceF, OffsetTable) or
        GetSetupLdrOffsetTableFromResource(SelfFilename, SourceF, OffsetTable)) then
      begin
        if SourceF.CappedSize < sizeof(TestID) then SetupCorruptError;
        OffsetTable.Offset0 := 0;
        OffsetTable.Offset1 := 0;
        SetupLdrMode := false;
      end;
      SourceF.Seek(OffsetTable.Offset0);
      SourceF.ReadBuffer(TestID, SizeOf(TestID));

      IsCompatible := IsCompatibleVersion();
      if AttemptUnpackUnknown and IsUnknownVersion and IsCompatible then begin
        writeln('Signature detected: ' + TestID);
        writeln('This is not directly supported, but i''ll try to unpack it as version ' + IntToStr(tmpVer));
      end;
      if not IsCompatible then begin
        if not SetupLdrMode then SetupCorruptError;
        writeln('Signature detected: ' + TestID + '. This is not a supported version.');
        raise EFatalError.Create('1');
      end else if IsVersionSuspicious then
        writeln('; Version specified: ' + IntToStr(Ver))
      else
        writeln('; Version detected: ' + IntToStr(Ver));
      if WarnOnMod then writeln('Signature: ' + TestID);

// Extract the embedded setup exe      // causes problems. disabled for now.
      {if ExtractEmbedded then begin
        SourceF.Seek(OffsetTable.OffsetEXE);
        P := nil;

        try
          GetMem(P, OffsetTable.UncompressedSizeEXE);
          FillChar(P^, OffsetTable.UncompressedSizeEXE, 0);
          try
            Reader := TCompressedBlockReader.Create(SourceF, TLZMADecompressor);
            try
              Reader.Read(P^, OffsetTable.UncompressedSizeEXE);
            finally
              Reader.Free;
            end;
          except
            on ECompressDataError do
              SetupCorruptError;
          end;
          TransformCallInstructions(P^, OffsetTable.UncompressedSizeEXE, False);
          if GetCRC32(P^, OffsetTable.UncompressedSizeEXE) <> OffsetTable.CRCEXE then
            SetupCorruptError;
        finally
          SetLength(s,OffsetTable.UncompressedSizeEXE);
          Move(p^,s[1],OffsetTable.UncompressedSizeEXE);
          FreeMem(P);
          AddFakeFile('embedded\setup.exe',s);
        end;
      end;}
{
      Seek(SourceF, OffsetTable.OffsetEXE);

      TempFile := 'embedded_setup.exe';

      AssignFile(DestF, TempFile);
//      try
        P := nil;
        FileMode := fmOpenWrite or fmShareExclusive;  Rewrite(DestF, 1);
        try
          GetMem(P, OffsetTable.UncompressedSizeEXE);
          FillChar(P^, OffsetTable.UncompressedSizeEXE, 0);
          try
            if not InflateData(SourceF, OffsetTable.CompressedSizeEXE, True,
               P^, OffsetTable.UncompressedSizeEXE, False, Adler) then
              SetupCorruptError;
          except
            on EZlibDataError do
              SetupCorruptError;
          end;
          TransformCallInstructions(P^, OffsetTable.UncompressedSizeEXE, False);
          if GetCRC32(P^, OffsetTable.UncompressedSizeEXE) <> OffsetTable.CRCEXE then
            SetupCorruptError;
          BlockWrite(DestF, P^, OffsetTable.UncompressedSizeEXE);
        finally
          FreeMem(P);
          CloseFile(DestF);
        end;}
    finally
      FreeAndNil(SourceF);
//      if SourceFOpened then CloseFile(SourceF);
    end;
    SetupLdrOffset0 := OffsetTable.Offset0;
    SetupLdrOffset1 := OffsetTable.Offset1;
  except
    on E: Exception do begin
      if E is EMessage then raise;
      write('Can not open or read the specified file: "' + SelfFileName + '"');
      if E is EInOutError then writeln('". ' + SysErrorMessage(EInOutError(E).ErrorCode))
      else if E is EFileError then writeln('". ' + SysErrorMessage(EFileError(E).ErrorCode))
      else writeln('');
      writeln('Exception class ' + E.ClassName + ' with message: ' + E.Message);
      raise EFatalError.Create('1');
    end;
  end;
end;

procedure AbortInit(const Msg: TSetupMessageID);
begin
  writeln('Critical error: ' + SetupMessages[Msg]);
//  MsgBox(SetupMessages[Msg], '', mbCriticalError, MB_OK);
  Abort;
end;

procedure AbortInitFmt1(const Msg: TSetupMessageID; const Arg1: string);
begin
  writeln('Critical error: ' + FmtSetupMessage(Msg, [Arg1]));
//  MsgBox(FmtSetupMessage(Msg, [Arg1]), '', mbCriticalError, MB_OK);
  Abort;
end;

procedure InitializeSetup;
var
//  TempInstallDir : String;
//  DecompressorDLL: TMemoryStream;
//  SetupFilename: String;
  SetupFile: TFile;
  pFileEntry: PSetupFileEntry;
  pFileLocationEntry: PSetupFileLocationEntry;
  pRegistryEntry: PSetupRegistryEntry;
  pRunEntry: PSetupRunEntry;
  pIconEntry: PSetupIconEntry;
  pTaskEntry: PSetupTaskEntry;
  pComponentEntry: PSetupComponentEntry;
  RealReader: TAbstractBlockReader;
  Reader: TCacheReader;
  p: pointer;
  i: integer;

(*  procedure SaveStreamToTempFile(const Strm: TCustomMemoryStream;
    const Filename: String);
  var
    ErrorCode: DWORD;
  begin
    try
      Strm.SaveToFile(Filename);
    except
      { Display more useful error message than 'Stream write error' etc. }
      on EStreamError do begin
        ErrorCode := GetLastError;
        raise Exception.Create(FmtSetupMessage(msgLastErrorMessage,
          [SetupMessages[msgLdrCannotCreateTemp], IntToStr(ErrorCode),
           SysErrorMessage(ErrorCode)]));
      end;
    end;
  end;*)

  procedure ReadFileIntoStream(const Stream: TStream; const R: TAbstractBlockReader);
  type
    PBuffer = ^TBuffer;
    TBuffer = array[0..8191] of Byte;
  var
    Buf: PBuffer;
    BytesLeft, Bytes: Longint;
  begin
    (Stream as TMemoryStream).SetSize(0);
    New(Buf);
    try
      R.Read(BytesLeft, SizeOf(BytesLeft));
      while BytesLeft > 0 do begin
        Bytes := BytesLeft;
        if Bytes > SizeOf(Buf^) then Bytes := SizeOf(Buf^);
        R.Read(Buf^, Bytes);
        Stream.WriteBuffer(Buf^, Bytes);
        Dec(BytesLeft, Bytes);
      end;
    finally
      Dispose(Buf);
    end;
    Stream.Seek(0, soFromBeginning);
  end;

(*  procedure ReadWizardImage({var WizardImage: TBitmap;} const R: TCompressedBlockReader);
  var
    MemStream: TMemoryStream;
  begin
    MemStream := TMemoryStream.Create;
    try
      ReadFileIntoStream(MemStream, R);
      MemStream.Seek(0, soFromBeginning);
    finally
      MemStream.Free;
    end;
  end;*)

{  procedure LoadDecompressorDLL;
  var
    Filename: String;
  begin
    Filename := AddBackslash(TempInstallDir) + 'embedded_isdecmp.dll';
    if ExtractEmbedded and (CommandAction=caExtractFiles) then SaveStreamToTempFile(DecompressorDLL, Filename);
    FreeAndNil(DecompressorDLL);
  end;}

  procedure SkipEntries(const Count, Size, Strings: Integer);
  var
    i: integer;
  begin
    for i := 0 to Count - 1 do
      SECompressedBlockSkip(Reader, Size, Strings);
  end;

  procedure ReadWizardAndBzipDll;
  var
    Stream: TMemoryStream;
  begin
    Stream := TMemoryStream.Create;
    { Wizard image }
    ReadFileIntoStream(Stream, Reader);
    SetLength(WizardImage, Stream.Size); Stream.ReadBuffer((@WizardImage[1])^, Stream.Size);
    ReadFileIntoStream(Stream, Reader);
    SetLength(WizardSmallImage, Stream.Size); Stream.ReadBuffer((@WizardSmallImage[1])^, Stream.Size);
//    ReadWizardImage({WizardImage,} Reader);
//    ReadWizardImage({WizardSmallImage,} Reader);
    { Decompressor DLL }
    DecompDll := '';
    if (SetupHeader.CompressMethod = cmBzip) or
      ((SetupHeader.CompressMethod = cmLZMA) and (Ver = 4105)) or
      ((SetupHeader.CompressMethod = cmZip) and (Ver >= 4206)) then
    begin
//      DecompressorDLL := TMemoryStream.Create;
      ReadFileIntoStream(Stream, Reader);
      SetLength(DecompDll, Stream.Size); Stream.ReadBuffer((@DecompDll[1])^, Stream.Size);
    end;
    Stream.Free;
  end;
var
  tmp: integer;
begin
  { Read SETUP.0, or from EXE }
//  SourceDir := PathExtractDir(SetupLdrOriginalFilename);

  // If SetupLdrMode=false, we're running on setup.0 (whatever the actual name is}
  // because the 'real' setup.exe (i.e. not the SetupLdr exe) would not pass the check
  // in SetupLdr proc
  // As a bonus, since 4.1.7 setup.0 must have the same base name as setup.exe
//  SetupFilename := SetupLdrOriginalFilename;

  SetupFile := TFile.Create(SetupFilename, fdOpenExisting, faRead, fsRead);
//  AssignFile(SetupFile, SetupFilename);
//  FileMode := fmOpenRead or fmShareDenyWrite;  Reset(SetupFile, 1);
  try
    SetupFile.Seek(SetupLdrOffset0);
//    Seek(SetupFile, SetupLdrOffset0);
//    BlockRead(SetupFile, TestID, SizeOf(TestID));
    if SetupFile.Read(TestID, SizeOf(TestID)) <> SizeOf(TestID) then
      AbortInit(msgSetupFileCorruptOrWrongVer);
    try
      RealReader := TheBlockReader.Create(SetupFile, TLZMADecompressor);
      Reader := TCacheReader.CreateCache(RealReader);
      if IsVersionSuspicious then begin
        HeuristicVersionFinder(Reader);
        writeln('; Version detected: ' + IntToStr(Ver));
      end;
      VerObject := nil;
      tmp := 0;
      if AttemptUnpackUnknown then begin
        for i := 0 to High(VerList) do with VerList[i] do
            if (VerSupported <= Ver) and (VerSupported >= tmp) then begin
              VerObject := VerList[i]; tmp := VerSupported;
            end;
      end else
        for i := 0 to High(VerList) do if VerList[i].VerSupported = Ver then VerObject := VerList[i];
//      if VerObject=nil then exit; // that should not happen
      VerObject.SetupSizes;
      try
        { Header }
        p := AllocMem(SetupHeaderSize);
        SECompressedBlockRead(Reader, p^, SetupHeaderSize, SetupHeaderStrings);
        VerObject.UnifySetupHeader(p^, SetupHeader);
        FreeMem(p);
        if Ver < 4000 then begin // language options, wizard images and compressor dll are stored here in 3.x
          SECompressedBlockSkip(Reader, SetupLanguageEntrySize, SetupLanguageEntryStrings);
          ReadWizardAndBzipDll;
        end;
        { Language entries }
        if Ver >= 4000 then
          SkipEntries(SetupHeader.NumLanguageEntries, SetupLanguageEntrySize, SetupLanguageEntryStrings);
        { CustomMessage entries }
        if Ver >= 4201 then
          SkipEntries(SetupHeader.NumCustomMessageEntries, SetupCustomMessageEntrySize, SetupCustomMessageEntryStrings);
        { Permission entries }
        if Ver >= 4100 then
          SkipEntries(SetupHeader.NumPermissionEntries, SetupPermissionEntrySize, SetupPermissionEntryStrings);
        { Type entries }
        SkipEntries(SetupHeader.NumTypeEntries, SetupTypeEntrySize, SetupTypeEntryStrings);
        { Component entries }
        p := AllocMem(SetupComponentEntrySize);
        for i := 0 to SetupHeader.NumComponentEntries - 1 do begin
          SECompressedBlockRead(Reader, p^, SetupComponentEntrySize, SetupComponentEntryStrings);
          pComponentEntry := AllocMem(sizeof(TSetupComponentEntry));
          VerObject.UnifyComponentEntry(p^, pComponentEntry^);
          Entries[seComponent].Add(pComponentEntry);
        end;
        FreeMem(p);
//        SkipEntries(SetupHeader.NumComponentEntries, SetupComponentEntrySize, SetupComponentEntryStrings);
        { Task entries }
        p := AllocMem(SetupTaskEntrySize);
        for i := 0 to SetupHeader.NumTaskEntries - 1 do begin
          SECompressedBlockRead(Reader, p^, SetupTaskEntrySize, SetupTaskEntryStrings);
          pTaskEntry := AllocMem(sizeof(TSetupTaskEntry));
          VerObject.UnifyTaskEntry(p^, pTaskEntry^);
          Entries[seTask].Add(pTaskEntry);
        end;
        FreeMem(p);
//        SkipEntries(SetupHeader.NumTaskEntries, SetupTaskEntrySize, SetupTaskEntryStrings);
        { Dir entries }
        SkipEntries(SetupHeader.NumDirEntries, SetupDirEntrySize, SetupDirEntryStrings);
        { File entries }
        p := AllocMem(SetupFileEntrySize);
        for i := 0 to SetupHeader.NumFileEntries - 1 do begin
          SECompressedBlockRead(Reader, p^, SetupFileEntrySize, SetupFileEntryStrings);
          pFileEntry := AllocMem(sizeof(TSetupFileEntry));
          VerObject.UnifyFileEntry(p^, pFileEntry^);
          Entries[seFile].Add(pFileEntry);
        end;
        FreeMem(p);
        { Icon entries }
//        SkipEntries(SetupHeader.NumIconEntries, SetupIconEntrySize, SetupIconEntryStrings);
        p := AllocMem(SetupIconEntrySize);
        for i := 0 to SetupHeader.NumIconEntries - 1 do begin
          SECompressedBlockRead(Reader, p^, SetupIconEntrySize, SetupIconEntryStrings);
          pIconEntry := AllocMem(sizeof(TSetupIconEntry));
          VerObject.UnifyIconEntry(p^, pIconEntry^);
          Entries[seIcon].Add(pIconEntry);
        end;
        FreeMem(p);
        { INI entries }
        SkipEntries(SetupHeader.NumIniEntries, SetupIniEntrySize, SetupIniEntryStrings);
        { Registry entries }
        p := AllocMem(SetupRegistryEntrySize);
        for i := 0 to SetupHeader.NumRegistryEntries - 1 do begin
          SECompressedBlockRead(Reader, p^, SetupRegistryEntrySize, SetupRegistryEntryStrings);
          pRegistryEntry := AllocMem(sizeof(TSetupRegistryEntry));
          VerObject.UnifyRegistryEntry(p^, pRegistryEntry^);
          Entries[seRegistry].Add(pRegistryEntry);
        end;
        FreeMem(p);
        { InstallDelete entries }
        SkipEntries(SetupHeader.NumInstallDeleteEntries, SetupDeleteEntrySize, SetupDeleteEntryStrings);
        { UninstallDelete entries }
        SkipEntries(SetupHeader.NumUninstallDeleteEntries, SetupDeleteEntrySize, SetupDeleteEntryStrings);
        { Run entries }
        p := AllocMem(SetupRunEntrySize);
        for i := 0 to SetupHeader.NumRunEntries - 1 do begin
          SECompressedBlockRead(Reader, p^, SetupRunEntrySize, SetupRunEntryStrings);
          pRunEntry := AllocMem(sizeof(TSetupRunEntry));
          VerObject.UnifyRunEntry(p^, pRunEntry^);
          Entries[seRun].Add(pRunEntry);
        end;
        FreeMem(p);
        { UninstallRun entries }
        p := AllocMem(SetupRunEntrySize);
        for i := 0 to SetupHeader.NumUninstallRunEntries - 1 do begin
          SECompressedBlockRead(Reader, p^, SetupRunEntrySize, SetupRunEntryStrings);
          pRunEntry := AllocMem(sizeof(TSetupRunEntry));
          VerObject.UnifyRunEntry(p^, pRunEntry^);
          Entries[seUninstallRun].Add(pRunEntry);
        end;
        FreeMem(p);

        if Ver >= 4000 then ReadWizardAndBzipDll;

        RealReader.Free; Reader.Free;

        RealReader := TheBlockReader.Create(SetupFile, TLZMADecompressor);
        Reader := TCacheReader.CreateCache(RealReader);

        { File location entries }
        p := AllocMem(SetupFileLocationEntrySize);
        for i := 0 to SetupHeader.NumFileLocationEntries - 1 do begin
          SECompressedBlockRead(Reader, p^, SetupFileLocationEntrySize, SetupFileLocationEntryStrings);
          pFileLocationEntry := AllocMem(sizeof(TSetupFileLocationEntry));
          VerObject.UnifyFileLocationEntry(p^, pFileLocationEntry^);
          if Ver < 4000 then with pFileLocationEntry^ do begin
              Dec(FirstSlice);
              Dec(LastSlice);
            end;
          Entries[seFileLocation].Add(pFileLocationEntry);
        end;
        FreeMem(p);
      finally
        Reader.Free; RealReader.Free;
      end;
    except
      on ECompressDataError do
        AbortInit(msgSetupFileCorrupt);
    end;
  finally
    FreeAndNil(SetupFile);
//    CloseFile(SetupFile);
  end;
  { Extract "_shfoldr.dll" to TempInstallDir, and load it }
//  LoadSHFolderDLL;

  { Extract "_isdecmp.dll" to TempInstallDir, and load it }
//  if (SetupHeader.CompressMethod = cmBzip) or
//     ((SetupHeader.CompressMethod = cmLZMA) and (Ver=4105))
//  then LoadDecompressorDLL;
end;

function MakeDir(Dir: string; const Flags: TMakeDirFlags): Boolean;
{ Returns True if a new directory was created }
const
  DeleteDirFlags: array[Boolean] of Longint = (0, 0); //utDeleteDirOrFiles_CallChangeNotify);
var
  ErrorCode: DWORD;
begin
  Result := False;
  Dir := RemoveBackslash(ExpandFilename(Dir));
  if (Dir = '') or (AnsiLastChar(Dir)^ = ':') or (ExtractFilePath(Dir) = Dir) then
    Exit;
  if DirExists(Dir) then begin
    if not (mdAlwaysUninstall in Flags) then
      Exit;
  end
  else begin
    MakeDir(ExtractFilePath(Dir), Flags - [mdAlwaysUninstall]);
    if not CreateDirectory(PChar(Dir), nil) then begin
      ErrorCode := GetLastError;
      raise Exception.Create(FmtSetupMessage(msgLastErrorMessage,
        [FmtSetupMessage1(msgErrorCreatingDir, Dir), IntToStr(ErrorCode),
        SysErrorMessage(ErrorCode)]));
    end;
    Result := True;
  end;
end;

procedure ExtractorProgressProc(Bytes: Cardinal);
begin
end;

procedure ProcessFileEntry(const CurFile: PSetupFileEntry;
  ASourceFile, ADestName: string; const FileLocationFilenames: TStringList;
  const AExternalSize: Integer64);

  procedure SetFileLocationFilename(const LocationEntry: Integer;
    Filename: string);
  var
    LowercaseFilename: string;
    Hash: Longint;
    I: Integer;
  begin
//      Filename := ExpandFilename(Filename);
    LowercaseFilename := AnsiLowercaseFileName(Filename);
    Hash := GetCRC32(LowercaseFilename[1], Length(LowercaseFilename));
    { If Filename was already associated with another LocationEntry,
      disassociate it. If we *don't* do this, then this script won't
      produce the expected result:
        [Files]
        Source: "fileA"; DestName: "file2"
        Source: "fileB"; DestName: "file2"
        Source: "fileA"; DestName: "file1"
      1. It extracts fileA under the name "file2"
      2. It extracts fileB under the name "file2"
      3. It copies file2 to file1, thinking a copy of fileA was still
         stored in file2.
    }
    for I := 0 to FileLocationFilenames.Count - 1 do
      if (Longint(FileLocationFilenames.Objects[I]) = Hash) and
        (AnsiLowercaseFileName(FileLocationFilenames[I]) = LowercaseFilename) then begin
        FileLocationFilenames[I] := '';
        FileLocationFilenames.Objects[I] := nil;
        Break;
      end;
    FileLocationFilenames[LocationEntry] := Filename;
    FileLocationFilenames.Objects[LocationEntry] := Pointer(Hash);
  end;

var
  CurFileLocation: PSetupFileLocationEntry;
  SourceFile, DestFile, TempFile: string;
  DestF: TFile;
  LastOperation: string;
  CurFileDate: TFileTime;

begin
  if CurFile^.LocationEntry <> -1 then
    CurFileLocation := PSetupFileLocationEntry(Entries[seFileLocation][CurFile^.LocationEntry])
  else CurFileLocation := nil;
  DestFile := CurFile^.SourceFileName;

  if length(BaseDirToStrip) > 0 then delete(DestFile, 1, length(BaseDirToStrip));

  if StripPaths then DestFile := ExtractFileName(DestFile);

  SourceFile := ASourceFile;
//        DestFile:=ExpandFilename(DestFile);
  TempFile := GenerateUniqueName(ExtractFilePath(ExpandFilename(DestFile)), '.tmp');
  MakeDir(ExtractFilePath(TempFile), []);
  DestF := TFile.Create(TempFile, fdCreateAlways, faWrite, fsNone);
  try
//          TempFileLeftOver := True;
    try
      LastOperation := SetupMessages[msgErrorReadingSource];
      if SourceFile = '' then begin
        if CurFile^.FileType <> ftFakeFile then begin
          { Decompress a file }
          FileExtractor.SeekTo(CurFileLocation^);
          LastOperation := SetupMessages[msgErrorCopying];
          FileExtractor.DecompressFile(CurFileLocation^, DestF, ExtractorProgressProc);
        end else begin
          DestF.WriteBuffer(CurFileLocation^.Contents[1], length(CurFileLocation^.Contents));
        end;
      end;
    { Set time/date stamp }
      CurFileDate := CurFileLocation^.TimeStamp;
      SetFileTime(DestF.Handle, @CurFileDate, nil, @CurFileDate);
//          SetFileTime(TFileRec(DestF).Handle, @CurFileDate, nil, @CurFileDate);
    finally
      FreeAndNil(DestF);
//            CloseFile(DestF);
    end;
    DeleteFile(DestFile);

    if not MoveFile(PChar(TempFile), PChar(DestFile)) then
      Win32ErrorMsg('MoveFile');
  finally
    DeleteFile(TempFile);
  end;
end;

function ShouldProcessFileEntry(AFile: PSetupFileEntry): boolean;
var
  i: integer;
  FilePath, MaskPath, FileName, MaskName: string;
begin
  Result := false;
  if not ExtractEmbedded and (AFile^.FileType in [ftUninstExe, ftRegSvrExe]) then exit;
  if length(BaseDirToStrip) > 0 then
    if pos(BaseDirToStrip, AnsiLowercase(AFile^.SourceFileName)) <> 1 then exit;
  if length(FileMasks) > 0 then begin
    for i := 0 to High(FileMasks) do begin
      MaskPath := AnsiLowercase(PathExtractPath(FileMasks[i]));
      FilePath := AnsiLowercase(PathExtractPath(AFile^.SourceFileName)); //AFile^.DestDir));
      FileName := AnsiLowercase(PathExtractName(AFile^.SourceFileName));
//      if AFile^.DestName<>'' then FileName:=AnsiLowercase(PathExtractName(AFile^.DestName));
      MaskName := AnsiLowercase(PathExtractName(FileMasks[i]));
      if MaskPath = '' then
        Result := WildcardMatch(PChar(FileName), PChar(AnsiLowercase(FileMasks[i])))
      else if pos(MaskPath, FilePath) = 1 then
        Result := WildcardMatch(PChar(FileName), PChar(MaskName));
//      else Result:=false;
      if Result then break;
    end;
  end else Result := true;
end;

procedure CopyFiles;
{ Copies all the application's files }
var
  FileLocationFilenames: TStringList;
  I: Integer;
  CurFileNumber: Integer;
  CurFile: PSetupFileEntry;
  ExternalSize: Integer64;
begin
  FileLocationFilenames := TStringList.Create;
  try
    for I := 0 to Entries[seFileLocation].Count - 1 do
      FileLocationFilenames.Add('');
    for CurFileNumber := 0 to Entries[seFile].Count - 1 do begin
      CurFile := PSetupFileEntry(Entries[seFile][CurFileNumber]);
      if not ShouldProcessFileEntry(CurFile) then continue;
      with CurFile^ do
        if not QuietExtract then
          writeln('#' + IntToStr(CurFileNumber) + ' ' + SourceFilename);

      if CurFile^.LocationEntry <> -1 then begin
        ExternalSize.Hi := 0; { not used... }
        ExternalSize.Lo := 0;
        ProcessFileEntry(CurFile, '', '', FileLocationFilenames, ExternalSize);
      end;
    end;
  finally
    FileLocationFilenames.Free;
  end;
end;

procedure Usage;
begin
  writeln('innounp, the Inno Setup Unpacker. Version 0.17');
{$IFDEF EUREKALOG}writeln('Debug release'); {$ENDIF}
  writeln('Usage: innounp [command] [options] <setup.exe or setup.0> [@filelist] [filemask ...]');
  writeln('Commands:');
  writeln('  (no)   display general installation info');
  writeln('  -v     verbosely list the files (with sizes and timestamps)');
  writeln('  -x     extract the files from the installation (to the current directory, also see -d)');
  writeln('  -e     extract files without paths');
  writeln('Options:');
  writeln('  -b     batch (non-interactive) mode - will not prompt for password or disk changes');
  writeln('  -q     do not indicate progress while extracting');
  writeln('  -m     extract internal embedded files (such as license and uninstall.exe)');
  writeln('  -pPASS decrypt the installation with a password');
  writeln('  -dDIR  extract the files into DIR (can be absolute or relative path)');
  writeln('  -cDIR  specifies that DIR is the current directory in the installation');
  writeln('  -n     don''t attempt to unpack new versions');
end;

function ParseCommandLine: boolean;
var
  InstallNameParsed: boolean;
  i: integer;
  f: TextFile;
  s: string;
begin
  Result := false; InstallNameParsed := false;
  if (ParamCount < 1) then exit;
  for i := 1 to ParamCount do
    if (ParamStr(i)[1] = '-') and (length(ParamStr(i)) >= 2) then
      Password := copy(ParamStr(i), 2, length(ParamStr(i)) - 1)
    else if not InstallNameParsed then begin SetupFileName := ExpandFileName(ParamStr(i)); InstallNameParsed := true; end;
  Result := true;
end;

procedure CreateFileExtractor;
const
  DecompClasses: array[TSetupCompressMethod] of TCustomDecompressorClass =
  (TStoredDecompressor, TZDecompressor, TBZDecompressor, TLZMADecompressor);
begin
  if (Ver >= 3000) and (Ver <= 4000) then FFileExtractor := TFileExtractor4000.Create(TZDecompressor)
  else FFileExtractor := TFileExtractor.Create(DecompClasses[SetupHeader.CompressMethod]);
  if SetupHeader.EncryptionUsed and (Password <> '') and not TestPassword(Password) then
    writeln('Warning: incorrect password');
  FFileExtractor.CryptKey := Password;
end;

// Redistributes file name parameters to how they are in the iss script (DestName => Source,DestDir(,DestName))
// Also handles the duplicate names

procedure RenameFiles;
var
  list: TStringList;
  i, j, k: integer;
  pfe: PSetupFileEntry;
begin
  // append numbers to duplicate file names
  list := TStringList.Create;
  list.Sorted := true;
  for i := 0 to Entries[seFile].Count - 1 do begin
    pfe := PSetupFileEntry(Entries[seFile][i]);
    with pfe^ do begin
      if FileType = ftUninstExe then DestName := 'embedded\uninstall.exe'
      else if FileType = ftRegSvrExe then DestName := 'embedded\regsvr.exe';
      j := list.IndexOf(DestName);
      if j >= 0 then list.Objects[j] := pointer(integer(list.Objects[j]) + 1)
      else begin
        j := list.Add(DestName);
        list.Objects[j] := pointer(1);
      end;
    end;
  end;
  for i := 0 to list.Count - 1 do
    if integer(list.Objects[i]) = 1 then list.Objects[i] := pointer(0);
  for i := Entries[seFile].Count - 1 downto 0 do begin
    pfe := PSetupFileEntry(Entries[seFile][i]);
    with pfe^ do begin
      j := list.IndexOf(DestName);
      k := integer(list.Objects[j]);
      DestDir := PathExtractPath(DestName); SourceFileName := DestName;
      DestName := PathExtractName(DestName);
      if k > 0 then begin
        SourceFileName := DestDir + PathChangeExt(DestName, '') + ',' + IntToStr(k) + PathExtractExt(DestName);
        list.Objects[j] := pointer(k - 1);
      end;
      if DestName = PathExtractName(SourceFileName) then DestName := '';
      // Filter out the inappropriate characters
      for j := 1 to length(SourceFileName) do // '/' and '\' are valid since
        if SourceFileName[j] in [':', '*', '?', '"', '<', '>', '|'] then // they work as path delimiters
          SourceFileName[j] := '_'; // even inside brace constants
    end;
  end;
  list.Free;
end;

function testPass(Pass: string): boolean;
begin
  Password := Pass;
  if TestPassword(Password) then result := true else result := false;
end;

function readCryptKey: string;
begin
  result := FFileExtractor.CryptKey;
end;

procedure startAttack(SetupFName: string);
var
  i: integer;
  systime: TSystemTime;
  loc: PSetupFileLocationEntry;
  s: string;
  TotalFileSize: Integer64;
  TotalFiles, TotalEncryptedFiles, MaxSlice: integer;
begin
  SetupFileName := SetupFName;
  StdOutputHandle := GetStdHandle(STD_OUTPUT_HANDLE);
  CreateEntryLists;
  try
    if OutDir <> '' then begin MakeDir(OutDir, []); SetCurrentDir(OutDir) end;
    SetupLdr;
    InitializeSetup;
    CreateFileExtractor;
  except
    on E: Exception do
      if IsUnknownVersion then begin
        writeln('Unpacking failed. This version is not supported.'); halt(1);
      end else if E.Message = SSetupFileCorrupt then begin
        writeln('The setup files are corrupted or made by incompatible version. Maybe it''s not an Inno Setup installation at all.');
        writeln('(' + inttohex(cardinal(ExceptAddr), 8) + ')');
{$IFDEF EUREKALOG}raise; {$ELSE}halt(1); {$ENDIF}
      end else if E.Message = '' then begin //SetupMessages[msgSourceIsCorrupted] then
        writeln('Setup files are corrupted.');
        writeln('(' + inttohex(cardinal(ExceptAddr), 8) + ')');
{$IFDEF EUREKALOG}raise; {$ELSE}halt(1); {$ENDIF}
      end else begin
        writeln('Error (' + E.ClassName + ') "' + E.Message + '" at address ' + inttohex(cardinal(ExceptAddr), 8));
{$IFDEF EUREKALOG}raise; {$ELSE}halt(1); {$ENDIF}
      end;
  end;
end;
end.
