unit untListDownloaderThread;

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
 * The Original Code is untDownloadThread for Malzilla.
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

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls,
  HTTPSend, strUtils, Dialogs, IpUtils, AbGzTyp,
  AbUtils, ssl_openssl, synautil;

type
  TListDownloaderThread = class(TThread)
  private
  protected
    uURL: string;
    currentItem: Integer;
    uHTTPStatus: Integer;
    uStrHTTPStatus: string;
    uList: TStringList;
    HTTP: THTTPSend;
    procedure Execute; override;
    procedure SaveListDownloader;
    procedure UpdateMain;
    procedure Finished;

  public
    {put Set methods here}
    tURL: string;
    tUserAgent: string;
    tUseUserAgent: boolean;
    tReferrer: string;
    tProxyAddress: string;
    tProxyPort: string;
    tProxyUserName: string;
    tProxyPassword: string;
    tUseProxy: boolean;
    tDownloaded: longint;
    tContentLength: longint;
    tStatus: string;
    tHeaders: TStringList;
    tDocument: TMemoryStream;
    tFileName: string;
    tListDownloaderFolder: string;
    tList: TStringList;
  end;

implementation

uses untMain;

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

procedure TListDownloaderThread.SaveListDownloader;
begin
  tDocument.SaveToFile(tFileName);
end;

procedure TListDownloaderThread.UpdateMain;
begin
  if (uHTTPStatus >= 200) and (uHTTPStatus < 300) then
    frmMain.mmListDownloaderFinished.Lines.Add(frmMain.mmListDownloaderPending.Items[0] +
      '  Saved as: ' + tFileName)
  else
    frmMain.mmListDownloaderFinished.Lines.Add(frmMain.mmListDownloaderPending.Items[0] +
      '  Status: ' + IntToStr(uHTTPStatus));
  frmMain.mmListDownloaderPending.Items.Delete(0);
end;

procedure TListDownloaderThread.Finished;
begin
  frmMain.stbrListDownloader.SimpleText := 'Finished';
end;

procedure TListDownloaderThread.Execute;
var
  file_name_line: string;
  i: Integer;
  downloadable: boolean;
  file_name: string;
  redirection: string;
  j: Integer;
  gziped: Boolean;
  aGz: TAbGzipStreamHelper;
  aType: TAbArchiveType;
  oGZ: TMemoryStream;
begin
  j := 0;
  tHeaders := TStringList.Create;
  tDocument := TMemoryStream.Create;
  while j < tList.Count do
  begin
    if tList[j] <> '' then
    begin
      gziped := False;
      tDownloaded := 0;
      uHTTPStatus := 0;
      uStrHTTPStatus := '';
      tUrl := tList[j];
      tUrl := trim(tURL);
      file_name := '';
      tDownloaded := 0;
      tContentLength := 0;
      HTTP := THTTPSend.Create;
      try
        if tUseProxy and (tProxyAddress <> '') and (tProxyPort <> '') then
        begin
          HTTP.ProxyHost := tProxyAddress;
          HTTP.ProxyPort := tProxyPort;
          if tProxyUserName <> '' then
          begin
            HTTP.ProxyUser := tProxyUserName;
            HTTP.ProxyPass := tProxyPassword;
          end;
        end;
        if tReferrer <> '' then
          HTTP.Headers.Add('Referer: ' + tReferrer);
        if tUseUserAgent and (tUserAgent <> '') then
          HTTP.UserAgent := tUserAgent;

        HTTP.HTTPMethod('GET', tURL); // MPack patch
        tHeaders.Assign(HTTP.Headers); // MPack patch
        uHTTPStatus := HTTP.ResultCode;
        uStrHTTPStatus := HTTP.ResultString;
        if (HTTP.ResultCode >= 300) and (HTTP.ResultCode < 400) then
        begin
          redirection := '';
          for i := 0 to HTTP.Headers.Count - 1 do
            if AnsiContainsText(HTTP.Headers[i], 'Location:') then
              redirection := trim(copy(HTTP.Headers[i], pos(':',
                HTTP.Headers[i])
                + 1, length(HTTP.Headers[i])));

          tURL := BuildURL(tURL, redirection);
        end;

        //get filename
        file_name_line := '';
        File_Name := Copy(tList[j], RPos('/', tList[j]) + 1, Length(tList[j]));
        downloadable := False;

        for i := 0 to HTTP.Headers.Count - 1 do
        begin
          if AnsiContainsText(HTTP.Headers[i], 'Location:') then
            file_name_line := HTTP.Headers[i];
          if AnsiContainsText(HTTP.Headers[i], 'Content-Type: application') then
          begin
            file_name := copy(tURL, rpos('/', tURL) + 1, length(tURL));
            downloadable := true;
          end;
          if AnsiContainsText(HTTP.Headers[i], 'Content-Disposition:') then
          begin
            file_name_line := HTTP.Headers[i];
            downloadable := true;
          end;
          if AnsiContainsText(HTTP.Headers[i], 'Content-Length:') then
          begin
            tContentLength := StrToIntDef(trim(copy(HTTP.Headers[i], pos(':',
              HTTP.Headers[i]) + 1, length(HTTP.Headers[i]))), 1);
          end;
          if AnsiContainsText(HTTP.Headers[i], 'Content-Encoding: gzip') then
          begin
            gziped := True;
          end;
        end;
        if file_name_line <> '' then
        begin
          if downloadable then
          begin
            file_name := copy(file_name_line, pos('filename=', file_name_line)
              +
              9, length(file_name_line));
          end
          else
          begin
            file_name := copy(file_name_line, pos(':', file_name_line) + 1,
              length(file_name_line));
            file_name := trim(file_name);
            if rpos('/', file_name) < (length(file_name)) then
            begin
              file_name := copy(file_name, rpos('/', file_name) + 1,
                length(file_name));
            end;
          end;
        end;
        file_name := CleanFileName(file_name);

        if gziped then
        begin
          oGz := TMemoryStream.Create;
          aType := VerifyGZip(HTTP.Document);
          Assert(aType = atGzip);
          aGz := TAbGzipStreamHelper.Create(HTTP.Document);
          try
            aGz.ExtractItemData(oGz);
            HTTP.Document.LoadFromStream(oGz);
          finally
            aGz.Free;
            oGZ.Free;
          end;
        end;

        uUrl := tURL;
        if file_name <> '' then
          tFileName := file_name
        else
          tFileName := 'unknown.bin';
        tFileName := FindNextAvailableName(tListDownloaderFolder, tFileName);
        tDocument.LoadFromStream(HTTP.Document);
        if not untMain.cancelOP then
          if (uHTTPStatus >= 200) and (uHTTPStatus < 300) then
            Synchronize(SaveListDownloader);
      finally
        HTTP.Free;
      end;
      tStatus := '';

    end;
    if untMain.CancelOP then
      Break;
    currentItem := j;
    Synchronize(UpdateMain);
    inc(j);
  end;
  tHeaders.Free;
  tDocument.Free;
  tList.Free;
  Synchronize(Finished);
end;
end.
