unit untJSBrowserProxy;

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
 * The Original Code is untJSBrowserProxy for Malzilla.
 *
 * The Initial Developer of the Original Code is
 * Boban Spasic <spasic@gmail.com>.
 *
 * Portions created by the Initial Developer are Copyright (C) 2008
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
  untJSBrowser, SynUnicode;

type
  TJSBrowserProxy = class(TThread)
  private
  protected
    uBuffer: TWideStrings;
    uBrws: TBrowserBase;
    uStatus: string;
    uCompiled: Boolean;
    killed: Boolean;
    procedure Execute; override;
    procedure UpdateMain;
    procedure UpdateStatus;
    procedure ReleaseMemos;

  public
    tScript: WideString;
    tEval: WideString;
    tEvalReplace: Boolean;
    tDebug: Boolean;
    tEvalFolder: string;
    tExeFolder: string;
  end;

implementation

uses untMain, MD5;

function FindFiles(Directory: string; InclAttr, ExclAttr: Integer;
  const SubDirs: Boolean; const Files: TStrings): Integer;
var
  SearchRec: TSearchRec;
begin
  InclAttr := InclAttr or $00000080;
  Directory := IncludeTrailingPathDelimiter(Directory);
  FillChar(SearchRec, SizeOf(SearchRec), 0);
  if FindFirst(Directory + '*.*', faAnyFile or $00000080, SearchRec) = 0 then
  begin
    try
      repeat
        if (SearchRec.Name <> '.') and (SearchRec.Name <> '..') then
        begin
          Files.Add(Directory + SearchRec.Name);
          if SubDirs then
            if SearchRec.Attr and faDirectory <> 0 then
              FindFiles(Directory + SearchRec.Name, InclAttr, ExclAttr,
                SubDirs, Files);
        end;
      until
        FindNext(SearchRec) <> 0;
    finally
      FindClose(SearchRec);
    end;
  end;
  Result := Files.Count;
end;

procedure TJSBrowserProxy.UpdateStatus;
begin
  frmMain.stbrStatus.SimpleText := uStatus;
end;

procedure TJSBrowserProxy.UpdateMain;
begin
  frmMain.DecoderCallback(uCompiled);
end;

procedure TJSBrowserProxy.ReleaseMemos;
begin
  frmMain.mmScript.Visible := True;
  frmMain.mmResult.Visible := True;
  //frmMain.mmResult.Enabled := True;
  //frmMain.mmScript.Enabled := True;
  frmMain.btRunScript.Enabled := True;
  frmMain.btDebug.Enabled := True;
  untMain.Busy := False;
  frmMain.mmResult.Lines.EndUpdate;
  frmMain.mmScript.Lines.EndUpdate;
end;

procedure TJSBrowserProxy.Execute;
var
  sl: TStringList;
  i: Integer;
  tmpName: string;
begin
  killed := False;
  uStatus := 'Preparing temp folder';
  ForceDirectories(tEvalFolder);
  Synchronize(UpdateStatus);
  sl := TStringList.Create;
  try
    FindFiles(tEvalFolder,
      faDirectory or
      faAnyFile, 0, false, sl);
    for i := 0 to sl.Count - 1 do
      DeleteFile(sl[i]);
  finally
    sl.Free;
  end;

  uStatus := 'Working...';
  Synchronize(UpdateStatus);
  //uBuffer := TWideStrings.Create;
  SetCurrentDir(tExeFolder);
  uBrws := TBrowserBase.Create;
  uBrws.WriteObj := frmMain.mmResult.Lines;
  if tEvalReplace then
    uBrws.SetEvalReplace(tEval);
  if tDebug then
    uBrws.DoDebug;
  uBrws.CreateObjects;
  if uBrws.RunScript(tScript) then
  begin
    uCompiled := True;
    uStatus := 'Script compiled';
    Synchronize(ReleaseMemos);
    Synchronize(UpdateStatus);
    Synchronize(UpdateMain);
  end
  else
  begin
    uCompiled := False;
    uStatus := 'Collecting garbage';
    Synchronize(UpdateStatus);
    sl := TStringList.Create;
    try
      FindFiles(tEvalFolder,
        faAnyFile, 0, false, sl);
      if sl.Count > 0 then
        for i := 0 to sl.Count - 1 do
        begin
          tmpName := MD5Print(MD5File(sl[i]));
          if not (FileExists(tEvalFolder + tmpName)) then
            RenameFile(sl[i], tEvalFolder + tmpName)
          else
            DeleteFile(sl[i]);
        end;
      if sl.Count > 0 then
        uStatus := 'Script can''t be compiled, but it produced evaluation results'
      else
        uStatus := 'Script can''t be compiled';
      Synchronize(UpdateStatus);
      Synchronize(UpdateMain);
      Synchronize(ReleaseMemos);
    finally
      sl.Free;
    end;
  end;
  uBrws.Free;
end;

end.
