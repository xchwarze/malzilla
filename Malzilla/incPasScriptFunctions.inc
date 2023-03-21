{doDownload(url: string): boolean;
doSaveDownloaded(filename: string): boolean;
doSendToDecoder(): boolean;
doSendToLinksParser(): boolean;
doRunScript(): boolean;
doSaveDecoded(filename: string): boolean;

setUA(UA: string): boolean;
setUAIndex(I: integer): boolean;
setReferrer(R: string): boolean;

getUACount(): integer;
getAppFolder(): string;
}

function ReadDoc: string;
begin
  Result := frmMain.mmPSInputData.Text;
end;

function WriteDoc(s: string): Boolean;
begin
  frmMain.mmPSOutputData.Lines.Add(s);
  Result := True;
end;