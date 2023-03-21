program malzilla;

{%ToDo 'malzilla.todo'}
{%File 'incFunctions.inc'}
{%File 'incPasScriptFunctions.inc'}

uses
  Forms,
  untMain in 'untMain.pas' {frmMain},
  untJSBrowser in 'untJSBrowser.pas',
  untDownloadThread in 'untDownloadThread.pas',
  untCacheList in 'untCacheList.pas' {frmCacheList},
  untListDownloaderThread in 'untListDownloaderThread.pas',
  jsdebugger_win in 'used_units\jsdebugger_win.pas' {DebugMain},
  untHTMLObjects in 'untHTMLObjects.pas' {frmHTMLObjects},
  untJSBrowserProxy in 'untJSBrowserProxy.pas',
  untEvalResults in 'untEvalResults.pas' {frmEvalResults},
  untDelimiterDlg in 'untDelimiterDlg.pas' {frmDelimiterDlg},
  untMiniHTMLView in 'untMiniHTMLView.pas' {frmMiniHTMLView},
  untFTPThread in 'untFTPThread.pas';

{$R *.res}

begin

  Application.Initialize;
  Application.Title := 'Malzilla';
  Application.CreateForm(TfrmMain, frmMain);
  Application.CreateForm(TfrmCacheList, frmCacheList);
  Application.CreateForm(TDebugMain, DebugMain);
  Application.CreateForm(TfrmHTMLObjects, frmHTMLObjects);
  Application.CreateForm(TfrmEvalResults, frmEvalResults);
  Application.CreateForm(TfrmDelimiterDlg, frmDelimiterDlg);
  Application.CreateForm(TfrmMiniHTMLView, frmMiniHTMLView);
  Application.Run;
end.

