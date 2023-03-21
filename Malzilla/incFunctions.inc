function GetFileSize(sFileToExamine: string): longint;
var
  SearchRec: TSearchRec;
  inRetval, I1: Integer;
begin
  try
    inRetval := FindFirst(ExpandFileName(sFileToExamine), faAnyFile, SearchRec);
    if inRetval = 0 then
      I1 := SearchRec.Size
    else
      I1 := -1;
  finally
    SysUtils.FindClose(SearchRec);
  end;
  Result := I1;
end;

function DecorateURLs(const AText: string; output: TStringList;
  AFlags: TDecorateURLsFlagSet = [durlAddr, durlPath]
  ): integer;
const
  URLTemplate =
    '(?i)'
    + '('
    + '(FTP|HTTP)://' // Protocol
  + '|www\.)' // trick to catch links without
  // protocol - by detecting of starting 'www.'
  + '([\w\d\-]+(\.[\w\d\-]+)+)' // TCP addr or domain name
  + '(:\d\d?\d?\d?\d?)?' // port number
  + '(((/[%+\w\d\-\\\.]*)+)*)' // unix path
  + '(\?[^\s=&]+=[^\s=&]+(&[^\s=&]+=[^\s=&]+)*)?'
    // request (GET) params
  + '(#[\w\d\-%+]+)?'; // bookmark
var
  PrevPos: integer;
  s, Proto, Addr, HRef: string;
begin
  PrevPos := 1;
  with TRegExpr.Create do
  try
    Expression := URLTemplate;
    if Exec(AText) then
      repeat
        s := '';
        if AnsiCompareText(Match[1], 'www.') = 0 then
        begin
          Proto := 'http://';
          Addr := Match[1] + Match[3];
          HRef := Proto + Match[0];
        end
        else
        begin
          Proto := Match[1];
          Addr := Match[3];
          HRef := Match[0];
        end;
        if durlProto in AFlags then
          s := s + Proto;
        if durlAddr in AFlags then
          s := s + Addr;
        if durlPort in AFlags then
          s := s + Match[5];
        if durlPath in AFlags then
          s := s + Match[6];
        if durlParam in AFlags then
          s := s + Match[9];
        if durlBMark in AFlags then
          s := s + Match[11];
        output.Add(s);
        PrevPos := MatchPos[0] + MatchLen[0];
      until not ExecNext;
  finally Free;
    Result := 1;
  end;
end;

function KalimeroS1(const AText, ARegEx: string; output: TStringGrid): integer;
const
  RegExTemplate =
    '(?i)(id="?''?([\w]+)"?''?>([\w]+)<)';
var
  PrevPos: integer;
  RRow: Integer;
  RName, RValue: string;
begin
  PrevPos := 1;
  RRow := 0;
  with TRegExpr.Create do
  try
    Expression := ARegEx;
    if Exec(AText) then
      repeat
        RName := Match[1];
        RValue := Match[2];
        output.RowCount := output.RowCount + 1;
        Output.Cells[0, RRow] := RName;
        Output.Cells[1, RRow] := RValue;
        Inc(RRow);
        PrevPos := MatchPos[0] + MatchLen[0];
      until not ExecNext;
  finally Free;
    Result := 1;
  end;
end;

function EscapeCorrection(AIn: WideString): WideString;
begin
  Result := WideStringReplace(AIn, '\', '\\', [rfReplaceAll]);
  Result := WideStringReplace(Result, '"', '\"', [rfReplaceAll]);
end;

function EscapeCorrection_old(AIn: WideString): WideString;
var
  i: Integer;
begin
  i := 1;
  Result := '';
  while i <= Length(AIn) do
  begin
    if AIn[i] = '\' then
    begin
      if (i = 1) then
      begin
        if (AIn[i + 1] <> '\') then
          Result := Result + '\\';
      end
      else if i > 1 then
      begin
        if AIn[i - 1] <> '\' then
          Result := Result + '\\';
      end;
    end
    else if AIn[i] = '"' then
    begin
      if i = 1 then
        Result := Result + '\"'
      else if AIn[i - 1] <> '\' then
        Result := Result + '\"'
      else
        Result := Result + AIn[i];
    end
    else if AIn[i] = '''' then
    begin
      if i = 1 then
        Result := Result + '\'''
      else if AIn[i - 1] <> '\' then
        Result := Result + '\'''
      else
        Result := Result + AIn[i];
    end
    else
    begin
      Result := Result + AIn[i];
    end;
    Inc(i);
  end;
  Result := WideStringReplace(Result, #13, '', [rfReplaceAll]);
  Result := WideStringReplace(Result, #10, '', [rfReplaceAll]);
end;

function FindFilesW(Directory: widestring; const Files: TWideStrings):
  Integer;
var
  SearchRec: TSearchRecW;
begin
  Directory := WideIncludeTrailingPathDelimiter(Directory);
  FillChar(SearchRec, SizeOf(SearchRec), 0);
  if WideFindFirst(Directory + '*.*', faAnyFile or $00000080, SearchRec) = 0
    then
  begin
    try
      repeat
        Application.ProcessMessages;
        if (SearchRec.Name <> '.') and (SearchRec.Name <> '..') then
        begin
          Files.Add(Directory + SearchRec.Name);
          if SearchRec.Attr and faDirectory <> 0 then
            FindFilesW(Directory + SearchRec.Name, Files);
        end;
      until
        WideFindNext(SearchRec) <> 0;
    finally
      WideFindClose(SearchRec);
    end;
  end;
  Result := Files.Count;
end;

function FindFiles(Directory: string; InclAttr, ExclAttr: Integer;
  const SubDirs: Boolean; const Files: TStrings): Integer;
var
  SearchRec: TSearchRec;
begin
  cancelOP := False;
  InclAttr := InclAttr or $00000080;
  Directory := IncludeTrailingPathDelimiter(Directory);
  FillChar(SearchRec, SizeOf(SearchRec), 0);
  if FindFirst(Directory + '*.*', faAnyFile or $00000080, SearchRec) = 0 then
  begin
    try
      repeat
        application.ProcessMessages;
        if cancelOP then
          break;
        if (SearchRec.Name <> '.') and (SearchRec.Name <> '..') then
        begin
          if cancelOP then
            break;
          Files.Add(Directory + SearchRec.Name);
          if SubDirs then
            if SearchRec.Attr and faDirectory <> 0 then
              FindFiles(Directory + SearchRec.Name, InclAttr, ExclAttr,
                SubDirs, Files);
        end;
        if cancelOP then
          break;
      until
        FindNext(SearchRec) <> 0;
    finally
      FindClose(SearchRec);
    end;
  end;
  Result := Files.Count;
  cancelOp := false;
end;

function CleanFileName(FileName: string): string;
var
  sForbiddenCharacters: string;
  i: Longint;
begin
  if Pos('?', FileName) > 0 then
    FileName := Copy(FileName, 1, Pos('?', FileName) - 1);
  if Pos('&', FileName) > 0 then
    FileName := Copy(FileName, 1, Pos('&', FileName) - 1);

  sForbiddenCharacters := '\:*?"<>|'; // put the illegal characters here
  FileName := StringReplace(Filename, '/', '.', [rfReplaceAll]);
  for i := 1 to Length(sForbiddenCharacters) do
  begin
    FileName := StringReplace(Filename, sForbiddenCharacters[i], '',
      [rfReplaceAll]);
  end;
  if Length(FileName) > 200 then
    FileName := Copy(FileName, 1, 200);
  Result := FileName;
end;

function Padding(nr: string; pad: integer): string;
var
  i: integer;
begin
  if pad > length(nr) then
  begin
    for i := length(nr) to pad - 1 do
    begin
      nr := '0' + nr;
    end;
    result := nr;
  end
  else
    result := nr;
end;

function WideStringToUCS2(const Value: WideString): AnsiString;
begin
  if Length(Value) = 0 then
    Result := ''
  else
    SetString(Result, PAnsiChar(@Value[1]), Length(Value) * SizeOf(WideChar))
end;

function RemoveNulls(s: widestring): widestring;
begin
  Result := WideStringReplace(s, #00, '', [rfReplaceAll]);
end;

function RemoveWhitespaceAll(s: Widestring): WideString;
var
  a: WideString;
begin
  a := s;
  a := WideStringReplace(a, #32, ' ', [rfReplaceAll]);
  a := WideStringReplace(a, #10, '', [rfReplaceAll]);
  a := WideStringReplace(a, #13, '', [rfReplaceAll]);
  a := WideStringReplace(a, #09, '', [rfReplaceAll]);
  Result := a;
end;

function RemoveWhitespace(s: Widestring): WideString;
var
  a: WideString;
begin
  a := s;
  while (Pos(#32#32, a) > 0) do
  begin
    a := WideStringReplace(a, #32#32, ' ', [rfReplaceAll]);
    a := WideStringReplace(a, #10, '', [rfReplaceAll]);
    a := WideStringReplace(a, #13, '', [rfReplaceAll]);
    a := WideStringReplace(a, #09, '', [rfReplaceAll]);
  end;
  Result := a;
end;

function OctToInt(Value: string): string;
var
  i: Integer;
  int: Integer;
begin
  int := 0;
  for i := 1 to Length(Value) do
  begin
    int := int * 8 + StrToInt(Copy(Value, i, 1));
  end;
  Result := IntToStr(int);
end;

function hex2strNoDelimiter(const s: string): string;

  function HexValue(c: Char): Integer;
  begin
    if (c >= '0') and (c <= '9') then
      Result := Ord(c) - Ord('0')
    else if (c >= 'A') and (c <= 'F') then
      Result := Ord(c) - Ord('A') + 10
    else if (c >= 'a') and (c <= 'f') then
      Result := Ord(c) - Ord('a') + 10
    else
      Result := 0;
  end;

begin
  Result := IntToStr(HexValue(s[1]) shl 4 or HexValue(s[2]));
end;

function hex2str(const s: string; delim: string): string;

  function HexValue(c: Char): Integer;
  begin
    if (c >= '0') and (c <= '9') then
      Result := Ord(c) - Ord('0')
    else if (c >= 'A') and (c <= 'F') then
      Result := Ord(c) - Ord('A') + 10
    else if (c >= 'a') and (c <= 'f') then
      Result := Ord(c) - Ord('a') + 10
    else
      Result := 0;
  end;

var
  i, RealLength: Integer;
begin
  SetLength(Result, Length(s));
  i := 1;
  RealLength := 0;
  while i <= Length(s) do
  begin
    Inc(RealLength);
    if s[i] = delim then
    begin
      Result[RealLength] := Chr(HexValue(s[i + 1]) shl 4 or HexValue(s[i + 2]));
      Inc(i, 3);
    end
    else
    begin
      Result[RealLength] := s[i];
      Inc(i);
    end;
  end;
  SetLength(Result, RealLength);
end;

function hex2str2(InString: Widestring; delim: string; preDelimiter: Boolean):
  WideString;
var
  NumString: string;
  i: integer;
  CharNum: integer;
begin
  if preDelimiter then
  begin
    if (Pos(delim, InString) < 1) or (Length(InString) < 1) then
    begin
      Result := InString;
      Exit;
    end;
    i := 1;
    while i <= Length(InString) do
    begin
      if Copy(InString, i, Length(delim)) = delim then
      begin
        NumString := Copy(InString, i + Length(delim), 2);
        CharNum := StrToIntDef('$' + NumString, 63);
        if CharNum < $FF then
          Result := Result + Char(CharNum);
        i := i + 2 + Length(delim);
      end
      else
      begin
        Result := Result + InString[i];
        inc(i);
      end;
    end;
  end
  else
  begin
    if (Pos(delim, InString) < 1) or (Length(InString) < 1) then
    begin
      Result := InString;
      Exit;
    end;
    i := 1;
    while i <= Length(InString) do
    begin
      if Copy(InString, i + 2, Length(delim)) = delim then
      begin
        NumString := Copy(InString, i, 2);
        CharNum := StrToIntDef('$' + NumString, 63);
        if CharNum < $FF then
          Result := Result + Char(CharNum);
        i := i + 2 + Length(delim);
      end
      else
      begin
        Result := Result + InString[i];
        inc(i);
      end;
    end;
  end;
end;

function Hex2strNoDelimiterLoop(s: string): widestring;
var
  i: Integer;
  o: widestring;
begin
  i := 1;
  o := '';
  while i < Length(s) do
  begin
    o := o + hex2str('x' + Copy(s, i, 2), 'x');
    i := i + 2;
  end;
  Result := o;
end;

function dec2str(s: string; delim: string; preDelimiter: Boolean): string;
var
  j, i, last_portion: Integer;
  tmp, wrd: string;
  valid: Boolean;
begin
  result := '';
  if not preDelimiter then
  begin
    j := pos(delim, s);
    Result := '';
    while j <> 0 do
    begin
      tmp := '';
      wrd := '';
      last_portion := 0;
      valid := True;
      //j := pos(delim, s);
      if ((j - Length(delim)) - 3) = 0 then
        wrd := Copy(s, ((j - Length(delim)) - 3), 3)
      else if ((j - Length(delim)) - 2) = 0 then
        wrd := Copy(s, ((j - Length(delim)) - 2), 2)
      else if ((j - Length(delim)) - 1) = 0 then
        wrd := Copy(s, ((j - Length(delim)) - 1), 1);

      for i := 1 to Length(wrd) do
        if (wrd[i] < '0') or (wrd[i] > '9') then
          Valid := False;
      if Length(wrd) = 0 then
        valid := False;

      if valid then
      begin
        //ShowMessage('valid: ' + wrd);
        Result := Result + Copy(s, 1, Pos(wrd, s) - 1) + Chr(StrToIntDef(wrd,
          63));
        Delete(s, 1, Length(wrd) + Length(delim));
      end
      else
      begin
        Result := Result + Copy(s, 1, j);
        Delete(s, 1, j);
      end;

      j := pos(delim, s);
    end;
    wrd := Copy(s, 1, 3);
    j := 1;
    while j <= Length(wrd) do
      if (wrd[j] < '0') or (wrd[j] > '9') then
      begin
        SetLength(wrd, j - 1);
        Break;
      end
      else
        Inc(j);
    if Length(wrd) <> 0 then
    begin
      Result := Result + Chr(StrToIntDef(wrd, 63));
      Delete(s, 1, Length(wrd));
    end;
    Result := Result + s;
  end
  else
  begin
    j := pos(delim, s);
    while j <> 0 do
    begin
      tmp := '';
      last_portion := 0;
      wrd := Copy(s, j, Length(delim) + 3);
      if (wrd[Length(delim) + 3] < '0') or (wrd[Length(delim) + 3] > '9') then
        SetLength(wrd, Length(wrd) - 1);
      last_portion := j + Length(wrd) - 1;
      Result := Result + Copy(s, 1, Pos(delim, s) - 1);
      wrd := Copy(wrd, Length(delim) + 1, Length(wrd));
      Result := Result + Chr(strToIntDef(wrd, 63));
      Delete(s, 1, last_portion);
      j := Pos(delim, s);
    end;
    Result := Result + s;
  end;
end;

function FourHex2WideChar(s: string; bigEndian: boolean): WideString;
  function HexValue(c: Char): Integer;
  begin
    if (c >= '0') and (c <= '9') then
      Result := Ord(c) - Ord('0')
    else if (c >= 'A') and (c <= 'F') then
      Result := Ord(c) - Ord('A') + 10
    else if (c >= 'a') and (c <= 'f') then
      Result := Ord(c) - Ord('a') + 10
    else
      Result := -1;
  end;
var
  lo1, lo2: Byte;
  hi1, hi2: Byte;
  lo: Integer;
  hi: Integer;
begin
  if Length(s) = 4 then
  begin
    if not (HexValue(s[1]) = -1) or (HexValue(s[2]) = -1) or (HexValue(s[3]) = -1)
      or (HexValue(s[4]) = -1) then
    begin
      lo1 := HexValue(s[1]);
      lo2 := HexValue(s[3]);
      hi1 := HexValue(s[2]);
      hi2 := HexValue(s[4]);
      lo := (lo1 shl 4) + hi1;
      hi := (lo2 shl 4) + hi2;
      if bigEndian then
      begin
        Result := WideChar((hi shl 8) + lo);
      end
      else
      begin
        Result := WideChar((lo shl 8) + hi);
      end;
    end
    else
      Result := s
  end
  else
    Result := s;
end;

function uni2str(InString: string; delim: string; preDelimiter: Boolean):
  WideString;
var
  NumString: string;
  i: integer;
  CharNum: integer;
begin
  if preDelimiter then
  begin
    if (Pos(delim, InString) < 1) or (Length(InString) < 1) then
    begin
      Result := InString;
      Exit;
    end;
    i := 1;
    while i <= Length(InString) do
    begin
      if Copy(InString, i, Length(delim)) = delim then
      begin
        NumString := Copy(InString, i + Length(delim), 4);
        Result := Result + FourHex2WideChar(NumString, false);
        i := i + Length(delim) + 2 * SizeOf(WideChar);
      end
      else
      begin
        Result := Result + InString[i];
        inc(i);
      end;
    end;
  end
  else
  begin
    if (Pos(delim, InString) < 1) or (Length(InString) < 1) then
    begin
      Result := InString;
      Exit;
    end;
    i := 1;
    while i <= Length(InString) do
    begin
      if Copy(InString, i + 4, Length(delim)) = delim then
      begin
        NumString := Copy(InString, i, 4);
        Result := Result + FourHex2WideChar(NumString, false);
        i := i + Length(delim) + 2 * SizeOf(WideChar);
      end
      else
      begin
        Result := Result + InString[i];
        inc(i);
      end;
    end;
  end;
  //result := WideStringToUCS2(result);
  //result := WideStringReplace(result, #00, #160, [rfReplaceAll]);
end;

function Uni2strNoDelimiterLoop(s: string): Widestring;
var
  i, c: Integer;
  o: String;
begin
  i := 1;
  while i <= Length(s) do
  begin
    o := Copy(s, i, 4);
    Result := Result + FourHex2WideChar(o, false);
    Inc(i, 2 * SizeOf(WideChar));
  end;
end;

function uni2byte(InString: Widestring; delim: string): WideString;
var
  NumString: string;
  NumString2: string;
  i: integer;
begin
  if (Pos(delim, InString) < 1) or (Length(InString) < 1) then
  begin
    Result := InString;
    Exit;
  end;
  i := 1;
  while i <= Length(InString) do
  begin
    if Copy(InString, i, 2) = delim then
    begin
      NumString := Copy(InString, i + 4, 2);
      NumString2 := Copy(InString, i + 2, 2);
      result := result + NumString + NumString2;
      i := i + 6;
    end
    else
    begin
      Result := Result + InString[i];
      inc(i);
    end;
  end;
end;

function UCS2HexStr(s: WideString):string;
var
  i: LongInt;
begin
  for i := 1 to Length(s) do
  begin
    Result := Result + IntToHex(Ord(s[i]), 4);
  end;
end;

function HexToInt(s: string): Longword;
var
  b: Byte;
  c: Char;
begin
  Result := 0;
  s := UpperCase(s);
  for b := 1 to Length(s) do
  begin
    Result := Result * 16;
    c := s[b];
    case c of
      '0'..'9': Inc(Result, Ord(c) - Ord('0'));
      'A'..'F': Inc(Result, Ord(c) - Ord('A') + 10);
    else
      raise EConvertError.Create('No Hex-Number');
    end;
  end;
end;

function FindNextAvailableName(folder, file_name: string): string;
var
  fn: string;
  fe: string;
  fa: string;
  i, j: Integer;
  found: Boolean;
begin
  i := Pos('.', file_name);
  j := 1;
  found := False;
  Result := folder + '\' + file_name;
  if FileExists(folder + '\' + file_name) then
  begin
    fn := Copy(file_name, 1, i - 1);
    fe := Copy(file_name, i + 1, Length(file_name));
    while not found do
    begin
      fa := fn + '(' + IntToStr(j) + ').' + fe;
      if not FileExists(folder + '\' + fa) then
      begin
        Result := folder + '\' + fa;
        found := True;
      end
      else
        Inc(j);
    end;
  end;
end;

function GetShiftState: TShiftState;
begin
  Result := [];
  if GetAsyncKeyState(VK_SHIFT) < 0 then
    Include(Result, ssShift);
  if GetAsyncKeyState(VK_CONTROL) < 0 then
    Include(Result, ssCtrl);
  if GetAsyncKeyState(VK_MENU) < 0 then
    Include(Result, ssAlt);
end;

function Concatenate(inString: WideString): WideString;
var
  t1: WideString;
  t2: WideString;
  t3: WideString;
  i1: Integer;
  i2: Integer;
  q1: Integer;
  q2: Integer;
  d1: Integer;
  d2: Integer;
  zPlus: Integer;
  zAnd: Integer;
  zZnak: Integer;
  Position: Integer;
  l: Integer;
begin
  t3 := inString;
  zZnak := 0;
  Position := 1;
  if RPos('+', t3) < RPos('&', t3) then
    l := RPos('&', t3)
  else
    l := RPos('+', t3);

  while Position < (l + 1) do
  begin
    zPlus := PosEx('+', t3, Position);
    zAnd := PosEx('&', t3, Position);
    if (zPlus > 0) and (zAnd > 0) then
      if zPlus < zAnd then
        zZnak := zPlus
      else
        zZnak := zAnd;
    if (zPlus = 0) and (zAnd > 0) then
      zZnak := zAnd;
    if (zPlus > 0) and (zAnd = 0) then
      zZnak := zPlus;
    if (zPlus = 0) and (zAnd = 0) then
      Break;

    if (zZnak > 0) then
    begin
      q1 := RPosEx('''', t3, zZnak);
      d1 := RPosEx('"', t3, zZnak);
      if (q1 > 0) and (d1 > 0) then
      begin
        if q1 > d1 then
          i1 := q1
        else
          i1 := d1;
      end;
      if (q1 > 0) and (d1 = 0) then
        i1 := q1;
      if (d1 > 0) and (q1 = 0) then
        i1 := d1;

      q2 := PosEx('''', t3, zZnak);
      d2 := PosEx('"', t3, zZnak);
      if (q2 > 0) and (d2 > 0) then
      begin
        if q2 < d2 then
          i2 := q2
        else
          i2 := d2;
      end;
      if (q2 > 0) and (d2 = 0) then
        i2 := q2;
      if (d2 > 0) and (q2 = 0) then
        i2 := d2;

      t1 := Copy(t3, i1, i2 - i1);
      t1 := WideStringReplace(t1, ' ', '', [rfReplaceAll]);
      if (Pos('+', t1) = 2) or (Pos('&', t1) = 2) then
      begin
        t2 := Copy(t3, 1, i1 - 1)
          + Copy(t3, i2 + 1, Length(t3));
        t3 := t2;
        Position := zZnak;
      end
      else
        Position := zZnak + 1;
    end
    else
      Break;
  end;
  Result := t3;
end;

function StripHTMLTags(const strHTML: string): string;
var
  P: PChar;
  InTag: Boolean;
begin
  P := PChar(strHTML);
  Result := '';

  InTag := False;
  repeat
    case P^ of
      '<': InTag := True;
      '>': InTag := False;
      //#13, #10: ; {do nothing}
    else
      if not InTag then
      begin
        if (P^ in [#9, #32]) and ((P + 1)^ in [#10, #13, #32, #9, '<']) then
        else
          Result := Result + P^;
      end;
    end;
    Inc(P);
  until (P^ = #0);

  {convert system characters}
  Result := StringReplace(Result, '&quot;', '"', [rfReplaceAll]);
  Result := StringReplace(Result, '&apos;', '''', [rfReplaceAll]);
  Result := StringReplace(Result, '&gt;', '>', [rfReplaceAll]);
  Result := StringReplace(Result, '&lt;', '<', [rfReplaceAll]);
  Result := StringReplace(Result, '&amp;', '&', [rfReplaceAll]);
  Result := StringReplace(Result, '&nbsp;', ' ', [rfReplaceAll]);
  {here you may add another symbols from RFC if you need}
end;

procedure AutoSizeGrid(Grid: TStringGrid);
const
  ColWidthMin = 10;
var
  C, R, W, ColWidthMax: integer;
begin
  for C := 0 to Grid.ColCount - 1 do
  begin
    ColWidthMax := ColWidthMin;
    for R := 0 to (Grid.RowCount - 1) do
    begin
      W := Grid.Canvas.TextWidth(Grid.Cells[C, R]);
      if W > ColWidthMax then
        ColWidthMax := W;
    end;
    Grid.ColWidths[C] := ColWidthMax + 5;
  end;
end;

function Str2Hex(inStr: string): string;
var
  s: string;
  i: integer;
begin
  s := '';
  for i := 1 to length(inStr) do
  begin
    s := s + IntToHex(ord(inStr[i]), 2);
  end;
  result := s;
end;

