program prInnoBF;

uses
  Forms,
  untMain in 'untMain.pas' {frmMain},
  untParse in 'untParse.pas',
  srchThread in 'srchThread.pas',
  Main in 'Main.pas',
  Extract in 'Extract.pas',
  Extract4000 in 'Extract4000.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.Title := 'Inno BF';
  Application.CreateForm(TfrmMain, frmMain);
  Application.Run;
end.

