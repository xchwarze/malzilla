unit untDelimiterDlg;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, TntStdCtrls;

type
  TfrmDelimiterDlg = class(TForm)
    comboDelimiter: TTntComboBox;
    rbPreDelimiter: TTntRadioButton;
    rbPostDelimiter: TTntRadioButton;
    lbExampleDelimited: TTntLabel;
    btDelimitDlgOK: TTntButton;
    procedure rbPreDelimiterClick(Sender: TObject);
    procedure rbPostDelimiterClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure comboDelimiterChange(Sender: TObject);
    procedure btDelimitDlgOKClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    delimiter: WideString;
    preDelimiter: Boolean;
  end;

var
  frmDelimiterDlg: TfrmDelimiterDlg;

implementation

{$R *.dfm}

procedure TfrmDelimiterDlg.rbPreDelimiterClick(Sender: TObject);
begin
  preDelimiter := True;
  lbExampleDelimited.Caption := comboDelimiter.Text + '34' + comboDelimiter.Text
    + '56';
end;

procedure TfrmDelimiterDlg.rbPostDelimiterClick(Sender: TObject);
begin
  preDelimiter := False;
  lbExampleDelimited.Caption := '34' + comboDelimiter.Text + '56' +
    comboDelimiter.Text;
end;

procedure TfrmDelimiterDlg.FormCreate(Sender: TObject);
begin
  preDelimiter := True;
  delimiter := '%';
end;

procedure TfrmDelimiterDlg.comboDelimiterChange(Sender: TObject);
begin
  delimiter := comboDelimiter.Text;
  if preDelimiter then
    lbExampleDelimited.Caption := comboDelimiter.Text + '34' +
      comboDelimiter.Text + '56'
  else
    lbExampleDelimited.Caption := '34' + comboDelimiter.Text + '56' +
      comboDelimiter.Text;
end;

procedure TfrmDelimiterDlg.btDelimitDlgOKClick(Sender: TObject);
begin
  delimiter := comboDelimiter.Text;
  preDelimiter := rbPreDelimiter.Checked;
  Close;
end;

end.

