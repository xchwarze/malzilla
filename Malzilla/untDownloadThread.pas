unit untDownloadThread;

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
  HTTPSend, blcksock, strUtils, Dialogs, md5, IpUtils, AbGzTyp,
  AbUtils, ssl_openssl;

type
  TDownloadThread = class(TThread)
  private
  protected
    uCookies: TStringList;
    uURL: string;
    uCacheName: string;
    uHTTPStatus: Integer;
    uStrHTTPStatus: string;
    HTTP: THTTPSend;
    procedure Execute; override;
    procedure UpdateMain;
    procedure UpdateHeaders;
    procedure UpdateBrowser;
    procedure UpdateHTTPStatus;
    procedure UpdateCache;
    procedure SaveToFile;
    procedure SockCallBack(Sender: TObject; Reason: THookSocketReason; const
      Value: string);
    procedure UpdateCookies;

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
    tCacheFolder: string;
    tAppFolder: string;
    tCachedFile: string;
    tCookies: string;
  end;

implementation

uses untMain;

function CleanFileName(FileName: string): string;
var
  sForbiddenCharacters: string;
  i: LongInt;
begin
  sForbiddenCharacters := '\:*?"<>|'; // put the illegal characters here
  FileName := StringReplace(Filename, '/', '.', [rfReplaceAll]);
  for i := 1 to Length(sForbiddenCharacters) do
  begin
    FileName := StringReplace(Filename, sForbiddenCharacters[i], '',
      [rfReplaceAll]);
  end;
  Result := FileName;
end;

procedure TDownloadThread.UpdateHeaders;
begin
  frmMain.mmHTTP.Lines.AddStrings(tHeaders);
  //frmMain.mmHTTP.Lines.Add(TraceRouteHost(tURL));
  frmMain.AddToLog('====================', nil);
  frmMain.AddToLog('HTTP headers:', tHeaders);
end;

procedure TDownloadThread.UpdateBrowser;
begin
  frmMain.UpdateDownloadTabCallback(tCachedFile);
  frmMain.AddToLog('====================', nil);
  frmMain.AddToLog('Downloaded content: ' + tCachedFile, nil);
  frmMain.AddToLog(' ', nil);
end;

procedure TDownloadThread.UpdateHTTPStatus;
begin
  frmMain.downloadThreadStatusCallBack(uHTTPStatus, uStrHTTPStatus, tUrl);
end;

procedure TDownloadThread.UpdateCache;
begin
  untMain.cacheMD5Current := uCacheName;
  untMain.cacheURLCurrent := uURL;
  untMain.frmMain.cacheListsChanged;
end;

procedure TDownloadThread.UpdateCookies;
begin
  untMain.cookiesList.Clear;
  untMain.cookiesList.AddStrings(uCookies);
  untMain.frmMain.ParseCookies;
end;

procedure TDownloadThread.SaveToFile;
begin
  frmMain.SaveDialog1.FileName := tFileName;
  frmMain.SaveDialog1.DefaultExt := StringReplace(ExtractFileExt(tFileName),
    '.',
    '', []);
  if frmMain.SaveDialog1.Execute then
    tDocument.SaveToFile(frmMain.SaveDialog1.FileName);
end;

procedure TDownloadThread.UpdateMain;
begin
  frmMain.stbrStatusDownload.SimpleText := tStatus;
end;

procedure TDownloadThread.SockCallBack(Sender: TObject; Reason:
  THookSocketReason; const Value: string);
begin
  if Reason = HR_ReadCount then
  begin
    tDownloaded := tDownloaded + StrToIntDef(Value, -1);
    tStatus := 'Downloaded ' + intToStr(tDownloaded) + '/' +
      IntToStr(tContentLength) + ' bytes';
    Synchronize(UpdateMain);
    if untMain.cancelOP then
    begin
      tStatus := 'Canceled';
      Synchronize(UpdateMain);
      Terminate;
      HTTP.Abort;
    end;
  end;
end;

procedure TDownloadThread.Execute;
var
  file_name_line: string;
  i: Integer;
  downloadable: boolean;
  file_name: string;
  redirection: string;
  cacheName: string;
  gziped: Boolean;
  aGz: TAbGzipStreamHelper;
  aType: TAbArchiveType;
  oGZ: TMemoryStream;
begin
  //prototype
  tHeaders := TStringList.Create;
  uCookies := TStringList.Create;
  tDocument := TMemoryStream.Create;
  tDownloaded := 0;
  uHTTPStatus := 0;
  uStrHTTPStatus := '';
  if tURL <> '' then
  begin
    file_name := '';
    tDownloaded := 0;
    tContentLength := 0;
    gziped := False;
    HTTP := THTTPSend.Create;
    HTTP.Sock.OnStatus := SockCallBack;
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

      if tCookies <> '' then
        HTTP.Headers.Add('Cookie: ' + tCookies);

      //experimental
      //HTTP.Headers.Add('Accept-Encoding: gzip,deflate');
      HTTP.Headers.Add('Accept-Encoding: gzip');

      //HTTP.HTTPMethod('HEAD', tURL);
      HTTP.HTTPMethod('GET', tURL); // MPack patch
      tHeaders.Assign(HTTP.Headers); // MPack patch
      uHTTPStatus := HTTP.ResultCode;
      uStrHTTPStatus := HTTP.ResultString;
      if (HTTP.ResultCode >= 300) and (HTTP.ResultCode < 400) then
      begin
        redirection := '';
        for i := 0 to HTTP.Headers.Count - 1 do
          if AnsiContainsText(HTTP.Headers[i], 'Location:') then
            redirection := trim(copy(HTTP.Headers[i], pos(':', HTTP.Headers[i])
              + 1, length(HTTP.Headers[i])));

        tURL := BuildURL(tURL, redirection);
        //if not AnsiStartsText('/', redirection) then tURL := redirection
        //else tURL := copy(tURL, 1, RPos('/', tURL) - 1) + redirection;
      end;
      if (HTTP.ResultCode = 200) then
      begin
        if AnsiContainsText(HTTP.Headers.Text, 'Refresh:') then
        begin
          redirection := '';
          for i := 0 to HTTP.Headers.Count - 1 do
            if AnsiContainsText(HTTP.Headers[i], 'Refresh:') then
              redirection := trim(copy(HTTP.Headers[i], pos(';', HTTP.Headers[i])
                + 1, length(HTTP.Headers[i])));
          tURL := BuildURL(tURL, redirection);
        end;
      end;
      Synchronize(UpdateHTTPStatus);
      tHeaders.Assign(HTTP.Headers);
      Synchronize(UpdateHeaders);
      uCookies.Assign(HTTP.Cookies);

      //get filename
      file_name_line := '';
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
        {if AnsiContainsText(HTTP.Headers[i], 'Content-Encoding: deflate') then
        begin
          deflated := True;
        end; }
      end;
      if file_name_line <> '' then
      begin
        if downloadable then
        begin
          file_name := copy(file_name_line, pos('filename=', file_name_line) +
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

      //Patch for MPack and eCard malware
      ForceDirectories(tCacheFolder);
      HTTP.Document.SaveToFile(tCacheFolder + 'temp.file');
      cacheName := MD5Print(MD5File(tCacheFolder + 'temp.file'));

      if not (RenameFile(tCacheFolder + 'temp.file', tCacheFolder + cacheName))
        then
        DeleteFile(tCacheFolder + 'temp.file');
      tCachedFile := tCacheFolder + cacheName;

      uUrl := tUrl;
      uCacheName := cacheName;
      Synchronize(UpdateCache);

      if not downloadable then
        tDocument.LoadFromStream(HTTP.Document)
      else
      begin
        tFileName := file_name;
        tDocument.LoadFromStream(HTTP.Document);
        if not untMain.cancelOP then
          Synchronize(SaveToFile);
      end;
    finally
      HTTP.Free;
    end;
  end;
  tStatus := '';
  Synchronize(UpdateMain);
  Synchronize(UpdateBrowser);
  Synchronize(UpdateCookies);
  uCookies.Free;
  tHeaders.Free;
  tDocument.Free;
end;

end.

