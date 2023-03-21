unit untMain;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Menus, StdCtrls, ComCtrls, ExtCtrls, srchThread, IniFiles;

type
  TfrmMain = class(TForm)
    OpenDialog1: TOpenDialog;
    MainMenu1: TMainMenu;
    mnuFile: TMenuItem;
    mnuOpenFile: TMenuItem;
    N1: TMenuItem;
    mnuClose: TMenuItem;
    GroupBox1: TGroupBox;
    Label2: TLabel;
    Edit1: TEdit;
    UpDown1: TUpDown;
    Label3: TLabel;
    Edit2: TEdit;
    UpDown2: TUpDown;
    btStart: TButton;
    btStop: TButton;
    Memo1: TMemo;
    GroupBox2: TGroupBox;
    cbNumbers: TCheckBox;
    cbUppercase: TCheckBox;
    cbLower: TCheckBox;
    cbAll: TCheckBox;
    cbTurbo: TCheckBox;
    GroupBox3: TGroupBox;
    Edit3: TEdit;
    GroupBox4: TGroupBox;
    Label5: TLabel;
    GroupBox5: TGroupBox;
    Edit4: TEdit;
    UpDown3: TUpDown;
    procedure mnuOpenFileClick(Sender: TObject);
    procedure mnuCloseClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure btStopClick(Sender: TObject);
    procedure btStartClick(Sender: TObject);
    procedure UpDown1Click(Sender: TObject; Button: TUDBtnType);
    procedure UpDown2Click(Sender: TObject; Button: TUDBtnType);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure UpDown3Click(Sender: TObject; Button: TUDBtnType);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmMain: TfrmMain;
  FileName: string;
  CancelOP: boolean;
  FirstThread: MyThread;

implementation

{$R *.dfm}
uses untParse;

procedure TfrmMain.mnuOpenFileClick(Sender: TObject);
begin
  if OpenDialog1.Execute then
  begin
    FileName := OpenDialog1.FileName;
    btStart.Enabled := true;
    btStop.Enabled := false;
    Memo1.Lines.Add('Application loaded: ');
    Memo1.Lines.Add(OpenDialog1.FileName);
  end;
end;

procedure TfrmMain.mnuCloseClick(Sender: TObject);
begin
  Close;
end;

procedure TfrmMain.FormCreate(Sender: TObject);
var
  Ini: TIniFile;
begin
  FileName := '';
  CancelOP := false;
  Ini := TIniFile.Create(ExtractFileDir(Application.ExeName) + '\InnoBF.conf');
  try
    Edit3.Text := Ini.ReadString('Last', 'word', '');
    UpDown1.Position := Ini.ReadInteger('Last', 'min', 1);
    UpDown2.Position := Ini.ReadInteger('Last', 'max', 3);
    cbAll.Checked := Ini.ReadBool('Last', 'All', false);
    cbLower.Checked := Ini.ReadBool('Last', 'Lowercase', true);
    cbUppercase.Checked := Ini.ReadBool('Last', 'Uppercase', true);
    cbNumbers.Checked := Ini.ReadBool('Last', 'Numbers', true);
  finally
    Ini.Free;
  end;
end;

procedure TfrmMain.btStopClick(Sender: TObject);
begin
  CancelOP := true;
  cbTurbo.Checked := false;
  sleep(10);
  btStart.Enabled := true;
  btStop.Enabled := false;
  Edit3.Text := Label5.Caption;
  FirstThread.Cancel;
  FirstThread.Terminate;
  Edit3.Text := Label5.Caption;
  //UpDown3.Enabled := false;
end;

procedure TfrmMain.btStartClick(Sender: TObject);
var
  L: integer;
  I: integer;
  S: string;
  alphabet: string;
  counter: integer;
  alphLength: integer;
  ResumeAttack: boolean;
  ResumeWord: string;
const
  nrs: array[0..9] of char = (#48, #49, #50, #51, #52, #53, #54, #55, #56, #57);
  up: array[0..25] of char = (#65, #66, #67, #68, #69, #70, #71, #72, #73, #74,
    #75, #76, #77, #78, #79, #80, #81, #82, #83, #84, #85, #86, #87, #88, #89, #90);
  low: array[0..25] of char = (#97, #98, #99, #100, #101, #102, #103, #104, #105, #106, #107,
    #108, #109, #110, #111, #112, #113, #114, #115, #116, #117, #118, #119, #120, #121, #122);
begin
  //UpDown3.Enabled := true;
  alphabet := '';
  alphLength := 0;
  ResumeAttack := false;
  if cbNumbers.Checked then
  begin
    for counter := 0 to 9 do
      alphabet := alphabet + nrs[counter];
    alphLength := alphLength + 10;
    SetLength(alphabet, alphLength);
  end;
  if cbUppercase.Checked then
  begin
    for counter := 0 to 25 do
      alphabet := alphabet + up[counter];
    alphLength := alphLength + 26;
    SetLength(alphabet, alphLength);
  end;
  if cbLower.Checked then
  begin
    for counter := 0 to 25 do
      alphabet := alphabet + low[counter];
    alphLength := alphLength + 26;
    SetLength(alphabet, alphLength);
  end;
  if cbAll.Checked then
  begin
    alphabet := '';
    for counter := 32 to 126 do
      alphabet := alphabet + chr(counter);
    alphLength := length(alphabet);
    SetLength(alphabet, alphLength);
  end;
  FirstThread := MyThread.Create(true);
  FirstThread.FreeOnTerminate := true;
  FirstThread.UnCancel;
  FirstThread.SetAlphabet(alphabet);

  if length(Edit3.Text) > 0 then
  begin
    ResumeAttack := true;
    ResumeWord := Edit3.Text;
    UpDown1.Position := length(ResumeWord);
    if UpDown2.Position < UpDown1.Position then UpDown2.Position := UpDown1.Position;
  end;
  FirstThread.SetResume(ResumeAttack, ResumeWord);
  FirstThread.SetBounds(UpDown1.Position, UpDown2.Position);
  FirstThread.Resume;

end;

procedure TfrmMain.UpDown1Click(Sender: TObject; Button: TUDBtnType);
begin
  if UpDown1.Position > UpDown2.Position then
    UpDown2.Position := UpDown1.Position;
end;

procedure TfrmMain.UpDown2Click(Sender: TObject; Button: TUDBtnType);
begin
  if UpDown2.Position < UpDown1.Position then
    UpDown1.Position := UpDown2.Position;
end;

procedure TfrmMain.FormClose(Sender: TObject; var Action: TCloseAction);
var
  Ini: TIniFile;
begin
  if btStop.Enabled then btStop.Click;
  Ini := TIniFile.Create(ExtractFileDir(Application.ExeName) + '\InnoBF.conf');
  try
    Ini.WriteString('Last', 'word', Edit3.Text);
    Ini.WriteInteger('Last', 'min', UpDown1.Position);
    Ini.WriteInteger('Last', 'max', UpDown2.Position);
    Ini.WriteBool('Last', 'All', cbAll.Checked);
    Ini.WriteBool('Last', 'Lowercase', cbLower.Checked);
    Ini.WriteBool('Last', 'Uppercase', cbUppercase.Checked);
    Ini.WriteBool('Last', 'Numbers', cbNumbers.Checked);
  finally
    Ini.Free;
  end;
end;

procedure TfrmMain.UpDown3Click(Sender: TObject; Button: TUDBtnType);
begin
  case UpDown3.Position of
    0: FirstThread.Priority:=tpIdle;
    1: FirstThread.Priority:=tpLowest;
    2: FirstThread.Priority:=tpNormal;
    3: FirstThread.Priority:=tpHighest;
    4: FirstThread.Priority:=tpTimeCritical;
  end;
  case UpDown3.Position of
    0: SetPriorityClass(GetCurrentProcess, IDLE_PRIORITY_CLASS);
    1: SetPriorityClass(GetCurrentProcess, NORMAL_PRIORITY_CLASS);
    2: SetPriorityClass(GetCurrentProcess, HIGH_PRIORITY_CLASS);
    3: SetPriorityClass(GetCurrentProcess, REALTIME_PRIORITY_CLASS);
  end;
end;

end.

