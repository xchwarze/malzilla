unit untFTPThread;

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
 * The Original Code is untFTPThread for Malzilla.
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
  blcksock, Dialogs, md5, ftpsend, synautil;

type
  TFTPThread = class(TThread)
  private
  protected
    uCookies: TStringList;
    uURL: string;
    temp_res: string;
    uCacheName: string;
    uFTPStatus: Integer;
    uStrFTPStatus: string;
    FTP: TFTPSend;
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
    tCMDList: Boolean;
    tURL: string;
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

procedure TFTPThread.UpdateHeaders;
begin
  frmMain.mmHTTP.Lines.AddStrings(tHeaders);
  frmMain.AddToLog('====================', nil);
  frmMain.AddToLog('FTP response:', tHeaders);
end;

procedure TFTPThread.UpdateBrowser;
begin
  frmMain.UpdateDownloadTabCallback(tCachedFile);
  frmMain.AddToLog('====================', nil);
  frmMain.AddToLog('Downloaded content: ' + tCachedFile, nil);
  frmMain.AddToLog(' ', nil);
end;

procedure TFTPThread.UpdateHTTPStatus;
begin
  frmMain.downloadThreadStatusCallBack(1000, uStrFTPStatus,
    temp_res);
end;

procedure TFTPThread.UpdateCache;
begin
  untMain.cacheMD5Current := uCacheName;
  untMain.cacheURLCurrent := uURL;
  untMain.frmMain.cacheListsChanged;
end;

procedure TFTPThread.UpdateCookies;
begin
  untMain.cookiesList.Clear;
  untMain.cookiesList.AddStrings(uCookies);
  untMain.frmMain.ParseCookies;
end;

procedure TFTPThread.SaveToFile;
begin
  frmMain.SaveDialog1.FileName := tFileName;
  frmMain.SaveDialog1.DefaultExt := StringReplace(ExtractFileExt(tFileName),
    '.',
    '', []);
  if frmMain.SaveDialog1.Execute then
    tDocument.SaveToFile(frmMain.SaveDialog1.FileName);
end;

procedure TFTPThread.UpdateMain;
begin
  frmMain.stbrStatusDownload.SimpleText := tStatus;
end;

procedure TFTPThread.SockCallBack(Sender: TObject; Reason:
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
      ftp.Abort;
    end;
  end;
end;

procedure TFTPThread.Execute;
var
  file_name: string;
  cacheName: string;
  locprot: string;
  locURL: string;
  locHost: string;
  locPort: string;
  locUser: string;
  locPass: string;
  locParam: string;
begin
  tHeaders := TStringList.Create;
  uCookies := TStringList.Create;
  tDocument := TMemoryStream.Create;
  tDownloaded := 0;
  uFTPStatus := 0;
  uStrFTPStatus := '';
  if tURL <> '' then
  begin
    file_name := '';
    tDownloaded := 0;
    tContentLength := 0;
    FTP := TFTPSend.Create;
    FTP.Sock.OnStatus := SockCallBack;
    try
      ParseURL(tURL, locProt, locUser, locPass,
        locHost, locPort, locURL, locPAram);
      if locUser = '' then
        locUser := 'Anonymous';
      if locPass = '' then
        locPass := 'aa@aa.aa';
      if locPort = '' then
        locPort := '21';
      FTP.TargetHost := locHost;
      FTP.TargetPort := locPort;
      FTP.UserName := locUser;
      FTP.Password := locPass;
      FTP.PassiveMode := True;

      if FTP.Login then
      begin
        FTP.ChangeWorkingDir(Copy(locURL, 1, RPos('/', locURL) - 1));
        tFileName := Copy(locURL, RPos('/', locURL) + 1, Length(locURL));
        temp_res := Copy(locURL, 1, RPos('/', locURL) - 1) + ' :: ' + tFileName;
        if tCMDList then
          FTP.List(locURL, false)
        else
        begin
          FTP.FTPCommand('TYPE I');
          FTP.FTPCommand('PASV');
          FTP.RetrieveFile(tFileName, false);
        end;

        tHeaders.Assign(FTP.FullResult);
        uFTPStatus := FTP.ResultCode;
        uStrFTPStatus := FTP.ResultString;

        Synchronize(UpdateHTTPStatus);
        Synchronize(UpdateHeaders);
        ForceDirectories(tCacheFolder);
        if tCMDList then
          FTP.FtpList.Lines.SaveToFile(tCacheFolder + 'temp.file')
        else
          FTP.DataStream.SaveToFile(tCacheFolder + 'temp.file');
        cacheName := MD5Print(MD5File(tCacheFolder + 'temp.file'));
        if not (RenameFile(tCacheFolder + 'temp.file', tCacheFolder + cacheName))
          then
          DeleteFile(tCacheFolder + 'temp.file');
        tCachedFile := tCacheFolder + cacheName;
        uUrl := tUrl;
        uCacheName := cacheName;
        Synchronize(UpdateCache);

        //file_name;
        tDocument.LoadFromStream(FTP.DataStream);
        if not tCMDList then
          if not untMain.cancelOP then
            if tDocument.Size > 0 then
              Synchronize(SaveToFile);
        FTP.Logout;
        Synchronize(UpdateBrowser);
        Synchronize(UpdateCookies);
      end
      else
      begin
        uStrFTPStatus := FTP.ResultString;
        ;
        Synchronize(UpdateHTTPStatus);
      end;
    finally
      FTP.Free;
    end;
  end;
  tStatus := '';
  Synchronize(UpdateMain);
  uCookies.Free;
  tHeaders.Free;
  tDocument.Free;
end;

end.

