program xorer;

{$APPTYPE CONSOLE}

{(* ***** BEGIN LICENSE BLOCK *****
 * Version: MPL 1.1/GPL 2.0/LGPL 2.1
 *
 * The contents of this file are subject to the Mozilla Public License Version
 * 1.1 (the "License"); you may not use this file except in compliance with
 * the License. You may obtain a copy of the License at
 * http://www.mozilla.org/MPL/
 *
 * Software distributed under the License is distributed on an "AS IS" basis,
 * WITHOUT WARRANTY OF ANY KIND, either express or implied. See the License
 * for the specific language governing rights and limitations under the
 * License.
 *
 * The Original Code is application XORer.
 *
 * The Initial Developer of the Original Code is
 * Boban Spasic <spasic@gmail.com>.
 *
 * Portions created by the Initial Developer are Copyright (C) 2007
 * the Initial Developer. All Rights Reserved.
 *
 * Alternatively, the contents of this file may be used under the terms of
 * either the GNU General Public License Version 2 or later (the "GPL"), or
 * the GNU Lesser General Public License Version 2.1 or later (the "LGPL"),
 * in which case the provisions of the GPL or the LGPL are applicable instead
 * of those above. If you wish to allow use of your version of this file only
 * under the terms of either the GPL or the LGPL, and not to allow others to
 * use your version of this file under the terms of the MPL, indicate your
 * decision by deleting the provisions above and replace them with the notice
 * and other provisions required by the GPL or the LGPL. If you do not delete
 * the provisions above, a recipient may use your version of this file under
 * the terms of any one of the MPL, the GPL or the LGPL.
 *
 * ***** END LICENSE BLOCK ***** *) }

uses
  SysUtils, Classes, StrUtils;

var
  in_file: string;
  out_file: string;
  key_file: string;
  sKey: string;
  sOffset: string;
  iOffset: Int64;
  fKey_file: TextFile;
  in_stream: TMemoryStream;
  out_stream: TMemoryStream;
  key_stream: TMemoryStream;
  counter_key: Int64;
  sKey_byte: string;
  tmp: byte;
  buffer1: byte;
  buffer2: Byte;
  error_status: Boolean;

begin

  if (ParamCount > 2) and (ParamCount < 5) then
  begin
    in_file := '';
    out_file := '';
    key_file := '';
    sKey := '';
    sOffset := '';
    iOffset := 0;

    if ParamStr(1) <> '' then in_file := ParamStr(1);
    if ParamStr(2) <> '' then out_file := ParamStr(2);
    if ParamStr(3) <> '' then
    begin
      if FileExists(ParamStr(3)) then //check if key is file or string
      begin
        key_file := ParamStr(3);
        AssignFile(fKey_file, key_file);
        reset(fKey_file);
        while not Eof(fKey_file) do
          Read(fKey_file, sKey);
        closefile(fKey_file);
      end
      else begin
        sKey := ParamStr(3);
      end;
    end;
    if ParamStr(4) <> '' then sOffset := ParamStr(4);
  end
  else
  begin
    WriteLn('');
    WriteLn('');
    WriteLn('XORer by bobby (bobby@mycity.co.yu)');
    WriteLn('');
    WriteLn('');
    WriteLn('Usage: xorer <input_file> <output_file> <key|key_file> [offset]');
    WriteLn('');
    WriteLn('Key and Offset parameters need to be in the form of hex numbers');
    WriteLn('Use quotation marks if the parameter contains spaces');
    WriteLn('');
    WriteLn('');
    WriteLn('Examples:');
    WriteLn('');
    WriteLn('xorer "c:\temp folder\input.txt" "c:\temp folder\output.txt" "7f 6b 48"');
    WriteLn('xorer in.txt d:\out.bin "c:\xor key.txt" 4c56');
    WriteLn('');
    exit;
  end;
  in_stream := TMemoryStream.Create;
  key_stream := TMemoryStream.Create;
  out_stream := TMemoryStream.Create;

  error_status := False;

  sKey := AnsiReplaceText(sKey, ' ', '');
  sOffset := AnsiReplaceText(sOffset, ' ', '');
  if sOffset <> '' then
  begin
    try iOffset := StrToInt64('$' + sOffset)
    except
      on e: Exception do
      begin
        WriteLn('Something is wrong with offset parameter');
        error_status := True;
      end;
    end;
  end
  else iOffset := 0;


  if not error_status then
  begin
    if FileExists(in_file) then
    begin
      in_stream.LoadFromFile(in_file);
    end else
    begin
      WriteLn('Input file ' + in_file + ' does not exists');
      error_status := True;
    end;
  end;

  if not error_status then
  begin
    if iOffset > in_stream.Size then
    begin
      WriteLn('Offset is greater than file size');
      error_status := True;
    end;
  end;

  if not error_status then
  begin
    try
      while key_stream.Size <= in_stream.Size do
      begin
        counter_key := 1;
        while counter_key <= Length(sKey) do
        begin
          sKey_byte := Copy(sKey, counter_key, 2);
          tmp := StrToInt('$' + sKey_byte);
          key_stream.Write(tmp, SizeOf(tmp));
          Inc(counter_key, 2);
        end;
      end;
    except
      on e: Exception do
      begin
        WriteLn('Error in key parameter');
        error_status := True;
      end;
    end;
  end;

  if not error_status then
  begin
    in_stream.Position := iOffset;
    out_stream.Position := 0;
    key_stream.Position := 0;
    while in_stream.Position < in_stream.Size do
    begin
      in_stream.Read(buffer1, sizeOf(buffer1));
      key_stream.Read(buffer2, sizeOf(buffer2));
      tmp := buffer1 xor buffer2;
      out_stream.Write(tmp, sizeOf(tmp));
    end;
    try
      out_stream.SaveToFile(out_file);
    except
      on e: Exception do
      begin
        WriteLn('Error writing to output file');
        Writeln(e.message);
        error_status := True;
      end;
    end;
  end;
  //key_stream.SaveToFile(out_file + '.key');   //debug

  in_stream.Free;
  key_stream.Free;
  out_stream.Free;

  if error_status then
    WriteLn('Not done because of errors')
  else WriteLn('Done.');
end.

