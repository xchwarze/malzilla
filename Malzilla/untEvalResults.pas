unit untEvalResults;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, TntStdCtrls, ExtCtrls;

type
  TfrmEvalResults = class(TForm)
    Panel1: TPanel;
    lbEvalResults: TTntListBox;
    procedure lbEvalResultsDblClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmEvalResults: TfrmEvalResults;

implementation

uses untMain;
{$R *.dfm}

procedure TfrmEvalResults.lbEvalResultsDblClick(Sender: TObject);
begin
  if FileExists(lbEvalResults.Items[lbEvalResults.ItemIndex]) then
    frmMain.mmResult.Lines.LoadFromFile(lbEvalResults.Items[lbEvalResults.ItemIndex]);
end;

end.

