unit untCacheList;

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
 * The Original Code is untCacheList for Malzilla.
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
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, TntStdCtrls;

type
  TfrmCacheList = class(TForm)
    lbCacheList: TListBox;
    Panel1: TPanel;
    cbStayOnTop: TTntCheckBox;
    procedure lbCacheListDblClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure cbStayOnTopClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    appFolder: string;
  end;

var
  frmCacheList: TfrmCacheList;

implementation

{$R *.dfm}

uses untMain;

procedure TfrmCacheList.lbCacheListDblClick(Sender: TObject);
var
  i, j: integer;
  AMD5: string;
  AURL: string;
  ADate: TDateTime;
  AReferrer: string;
  AUserAgent: string;
  ACookie: string;
  AOccurences: Integer;
  parser: Integer;
  parserString: string;
begin
  i := lbCacheList.ItemIndex;
  if FileExists(ExtractFilePath(application.ExeName) + 'Cache\' +
    untMain.cacheMD5[i]) then
    frmMain.mmBrowser.Lines.LoadFromFile(ExtractFilePath(application.ExeName) +
      'Cache\' + untMain.cacheMD5[i])
  else
    ShowMessage('File is missing from the cache');

  AMD5 := '';
  AURL := '';
  AReferrer := '';
  AUserAgent := '';
  ACookie := '';
  AOccurences := 0;
  for j := 0 to untMain.cacheOther.Count - 1 do
  begin
    AMD5 := Copy(untMain.cacheOther[j], 1, Pos('*', untMain.cacheOther[j]) - 1);
    if AMD5 = untMain.cacheMD5[i] then
      Inc(AOccurences);
  end;
  if AOccurences = 1 then
  begin
    j := 0;
    while j < untMain.cacheOther.Count do
    begin
      AMD5 := Copy(untMain.cacheOther[j], 1, Pos('*', untMain.cacheOther[j]) -
        1);
      if AMD5 = untMain.cacheMD5[i] then
      begin
        parserString := untMain.cacheOther[j];
        parser := Pos('**', parserString);
        if parser > 0 then
        begin
          AMD5 := Copy(parserString, 1, parser - 1);
          Delete(parserString, 1, parser + 1);
          parser := Pos('**', parserString);
          AURL := Copy(parserString, 1, parser - 1);
          Delete(parserString, 1, parser + 1);
          parser := Pos('**', parserString);
          ADate := StrToDateTime(Copy(parserString, 1, parser - 1));
          Delete(parserString, 1, parser + 1);
          parser := Pos('**', parserString);
          AUserAgent := Copy(parserString, 1, parser - 1);
          Delete(parserString, 1, parser + 1);
          parser := Pos('**', parserString);
          AReferrer := Copy(parserString, 1, parser - 1);
          Delete(parserString, 1, parser + 1);
          ACookie := parserString;
          Break;
        end;
      end
      else
        Inc(j);
    end;
  end
  else if AOccurences > 1 then
    ShowMessage('Sorry, error occured. For one cache file more than one index data found');
  frmMain.edURL.Text := AURL;
  frmMain.comboUserAgent.Text := AUserAgent;
  frmMain.edReferrer.Text := AReferrer;
  frmMain.edCookies.Text := ACookie;
end;

procedure TfrmCacheList.FormShow(Sender: TObject);
var
  i: integer;
begin
  try
    lbCacheList.Items.Clear;
    for i := 0 to untMain.cacheURL.Count - 1 do
      lbCacheList.Items.Add(untMain.cacheURL[i] + '    (' + untMain.cacheDate[i]
        + ')    File: ' + untMain.cacheMD5[i]);
  except
    on exception do
      ShowMessage('Cache index is corrupted');
  end;
end;

procedure TfrmCacheList.cbStayOnTopClick(Sender: TObject);
begin
  if cbStayOnTop.Checked then
    frmCacheList.FormStyle := fsStayOnTop
  else
    frmCacheList.FormStyle := fsNormal;
end;

end.

