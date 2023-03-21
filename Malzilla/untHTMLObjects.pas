unit untHTMLObjects;

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
 * The Original Code is untHTMLObjects for Malzilla.
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
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Grids, TntGrids, StdCtrls, TntStdCtrls, ExtCtrls, TntExtCtrls;

type
  TfrmHTMLObjects = class(TForm)
    sgHTMLObjects: TTntStringGrid;
    TntPanel1: TTntPanel;
    TntLabel1: TTntLabel;
    procedure SortHTMLObjects;
    procedure sgHTMLObjectsDblClick(Sender: TObject);
    procedure sgHTMLObjectsClick(Sender: TObject);
    procedure AutoSizeGrid(Grid: TStringGrid);
  private
    { Private declarations }
  public
    { Public declarations }

  end;

var
  frmHTMLObjects: TfrmHTMLObjects;

implementation

{$R *.dfm}

uses untMain;
//ovde smo stali

procedure TfrmHTMLObjects.AutoSizeGrid(Grid: TStringGrid);
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

procedure TfrmHTMLObjects.SortHTMLObjects;
var
  i, j: integer;
  temp: TStringList;
begin
  temp := TStringList.create;
  with sgHTMLObjects do
    for i := FixedRows to RowCount - 2 do {because last row has no next row}
      for j := i + 1 to rowcount - 1 do {from next row to end}
        if StrToIntDef(Cells[2, i], 0) > StrToIntDef(Cells[2, j], 0) then
        begin
          temp.assign(rows[j]);
          rows[j].assign(rows[i]);
          rows[i].assign(temp);
        end;
  temp.Free;
  AutoSizeGrid(sgHTMLObjects);
end;

procedure TfrmHTMLObjects.sgHTMLObjectsDblClick(Sender: TObject);
var
  i: Integer;
  i1, j1: Integer;
  gridRect: TGridRect;
begin
  gridRect := sgHTMLObjects.Selection;
  i := gridRect.Top;
  i1 := StrToIntDef(sgHTMLObjects.Cells[1, i], 0);
  j1 := StrToIntDef(sgHTMLObjects.Cells[2, i], 0);

  if (i1 <> 0) and (j1 <> 0) then
  begin
    frmMain.mmBrowser.SelStart := i1;
    frmMain.mmBrowser.SelEnd := j1 - 1;
    frmMain.btAddSelectionToDecoder.Click;
  end;
end;

procedure TfrmHTMLObjects.sgHTMLObjectsClick(Sender: TObject);
var
  i: Integer;
  i1, j1: Integer;
  gridRect: TGridRect;
begin
  gridRect := sgHTMLObjects.Selection;
  i := gridRect.Top;
  i1 := StrToIntDef(sgHTMLObjects.Cells[1, i], 0);
  j1 := StrToIntDef(sgHTMLObjects.Cells[2, i], 0);

  if (i1 <> 0) and (j1 <> 0) then
  begin
    frmMain.mmBrowser.SelStart := i1;
    frmMain.mmBrowser.SelEnd := j1 - 1;
  end;
end;

end.
