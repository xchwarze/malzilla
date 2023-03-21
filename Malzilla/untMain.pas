unit untMain;

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
 * The Original Code is untMain for Malzilla.
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
  Dialogs,
  //JVCL
  JvBaseDlg, JvSelectDirectory, hkClipboardMonitor, JvSpin,
  JvComponent, JvTrayIcon, JvExExtCtrls, JvRollOut, JvExMask,
  //Indy
  IdBaseComponent, IdCoder, IdCoder3to4,
  IdCoderMIME,
  //SynEdit and SynWeb
  SynMemo,
  SynEdit,
  SynURIOpener,
  SynHighlighterURI,
  SynHighlighterWeb,
  SynHighlighterPas,
  SynEditHighlighter,
  SynUnicode,
  SynTokenMatch,
  SynEditTypes,
  SynHighlighterWebData,
  SynHighlighterWebMisc,
  //RemObjects
  uPSComponent,
  uPSCompiler,
  //Synapse http://www.ararat.cz/synapse/
  HTTPSend,
  blcksock,
  Synautil,
  //Tnt  - not available as freeware anymore
  TntSysUtils,
  TntDialogs,
  TntClasses,
  TntSystem,
  TntMenus,
  TntStdCtrls,
  TntExtCtrls,
  TntComCtrls,
  //Delphi 7
  ExtCtrls, Grids, Mask, StdCtrls, ComCtrls,
  StrUtils, ClipBrd, IniFiles, Menus,
  //misc
  HyperParse, //http://www.wakproductions.com/
  IpUtils, //TurboPower Internet Professional (iPRO)
  RegExpr, //http://RegExpStudio.com
  MD5, //http://www.fichtner.net/delphi/md5/
  DosCommand, //www.torry.net
  HREFParser, //iedComp http://iedcomp.nm.ru
  MPHexEditor, //www.mirkes.de
  untJSBrowserProxy, SynEditMiscClasses, SynEditSearch, JwaWinsock2;

type

  TDownloaderTab = class(TObject)
  private
    VHTML: WideString;
    VURL: WideString;
    VUA: WideString;
    VReferrer: WideString;
    VCookies: WideString;
    VHTTPHeaders: WideString;
    VHex: WideString;
    VCookiesBox: WideString;
    VURIBase: WideString;
    VLinks: WideString;
    VIFrames: WideString;
    VStatusDownload: WideString;
    VStatusHTTP: WideString;
    //VUseUA: Boolean;
    //VUseCookies: Boolean;
    //VUseProxy: Boolean;
  public
    UseUA: Boolean;
    UseCookies: Boolean;
    UseProxy: Boolean;
    constructor Create;
    procedure SetHTML(s: WideString);
    procedure SetURL(s: WideString);
    procedure SetUA(s: WideString);
    procedure SetReferrer(s: WideString);
    procedure SetCookies(s: WideString);
    procedure SetHTTPHeaders(s: WideString);
    procedure SetHex(s: WideString);
    procedure SetCookieBox(s: WideString);
    procedure SetURIBase(s: WideString);
    procedure SetLinks(s: WideString);
    procedure SetIFrames(s: WideString);
    procedure SetStatusDownload(s: WideString);
    procedure SetStatusHTTP(s: WideString);
    function GetHTML: WideString;
    function GetURL: WideString;
    function GetUA: WideString;
    function GetReferrer: WideString;
    function GetCookies: WideString;
    function GetHTTPHeaders: WideString;
    function GetHex: WideString;
    function GetCookieBox: WideString;
    function GetURI: WideString;
    function GetLinks: WideString;
    function GetIFrames: WideString;
    function GetStatusDownload: WideString;
    function GetStatusHTTP: WideString;
  end;

  TDecoderTab = class(TObject)
  private
    VSrc: WideString;
    VTrg: WideString;
    VHighlighter: integer;
  public
    constructor Create;
    procedure SetSrc(s: WideString);
    procedure SetTrg(s: WideString);
    procedure SetHighlighter(s: integer);
    function GetSrc: WideString;
    function GetTrg: WideString;
    function GetHighlighter: integer;
  end;

  TDecorateURLsFlags = (
    // describes, which parts of hyper-link must be included
    // into VISIBLE part of the link:
    durlProto, // Protocol (like 'ftp://' or 'http://')
    durlAddr, // TCP address or domain name (like 'RegExpStudio.com')
    durlPort, // Port number if specified (like ':8080')
    durlPath, // Path to document (like 'index.html')
    durlBMark, // Book mark (like '#mark')
    durlParam // URL params (like '?ID=2&User=13')
    );

  TDecorateURLsFlagSet = set of TDecorateURLsFlags;

  TfrmMain = class(TForm)
    PageControl1: TTntPageControl;
    tsDownloader: TTntTabSheet;
    tsDecoder: TTntTabSheet;
    Panel2: TPanel;
    Panel3: TPanel;
    btRunScript: TTntButton;
    btWide2UCS2: TTntButton;
    Panel1: TPanel;
    tsNotes: TTntTabSheet;
    Panel5: TPanel;
    Splitter1: TSplitter;
    mmHTTP: TTntMemo;
    Splitter2: TSplitter;
    SaveDialog1: TSaveDialog;
    OpenDialog1: TOpenDialog;
    SaveDialog2: TSaveDialog;
    stbrStatus: TStatusBar;
    Panel11: TPanel;
    stbrStatusDownload: TStatusBar;
    mmScript: TSynMemo;
    SynURISyn1: TSynURISyn;
    mmResult: TSynMemo;
    SynURIOpener2: TSynURIOpener;
    mmNotes: TSynMemo;
    PopUpMnu: TPopupMenu;
    mnuCopy: TMenuItem;
    mnuPaste: TMenuItem;
    N1: TMenuItem;
    mnuSelectAll: TMenuItem;
    N2: TMenuItem;
    mnuUndo: TMenuItem;
    mnuRedo: TMenuItem;
    mnuDelete: TMenuItem;
    mnuCut: TMenuItem;
    tsMiscDecoders: TTntTabSheet;
    Panel12: TPanel;
    Panel13: TPanel;
    mmMiscDec: TSynMemo;
    edDelimiter: TTntEdit;
    btDecodeDec: TTntButton;
    btDecodeHex: TTntButton;
    btDecodeUCS2: TTntButton;
    IdDecoderMIME1: TIdDecoderMIME;
    btDecodeMIME: TTntButton;
    Label4: TTntLabel;
    btIncrease: TTntButton;
    btDecrease: TTntButton;
    btUCS2ToHex: TTntButton;
    edSearch: TTntEdit;
    btHexToFile: TTntButton;
    edReplace: TTntEdit;
    btReplace: TTntButton;
    Label5: TTntLabel;
    Label6: TTntLabel;
    btTextToFile: TTntButton;
    btDecodeJSEncode: TTntButton;
    N3: TMenuItem;
    mnuSaveToFile: TMenuItem;
    mnuLoadFromFile: TMenuItem;
    OpenDialog2: TOpenDialog;
    tsHexView: TTntTabSheet;
    MPHexEditor1: TMPHexEditor;
    PopUpMnuHex: TPopupMenu;
    mnuHexCopyClipText: TMenuItem;
    mnuHexCopyClipHex: TMenuItem;
    N4: TMenuItem;
    mnuHexPasteClipText: TMenuItem;
    mnuHexPasteClipHex: TMenuItem;
    N5: TMenuItem;
    mnuHexSave: TMenuItem;
    mnuHexLoad: TMenuItem;
    mnuClear: TMenuItem;
    N6: TMenuItem;
    mnuWordWrap: TMenuItem;
    JvTrayIcon1: TJvTrayIcon;
    PopUpTray: TPopupMenu;
    mnuTrayShow: TMenuItem;
    mnuTrayHide: TMenuItem;
    N7: TMenuItem;
    mnuTrayClose: TMenuItem;
    hkClipboardMonitor1: ThkClipboardMonitor;
    N8: TMenuItem;
    Panel18: TPanel;
    cbHexUnicode: TTntCheckBox;
    cbHexUnicodeBig: TTntCheckBox;
    cbHexSwapNibbles: TTntCheckBox;
    tsListDownloader: TTntTabSheet;
    Panel19: TPanel;
    Panel20: TPanel;
    Panel21: TPanel;
    Splitter4: TSplitter;
    mmListDownloaderFinished: TSynMemo;
    JvSelectDirectory1: TJvSelectDirectory;
    stbrListDownloader: TStatusBar;
    mnuTrayClipMonitorList: TMenuItem;
    mmListDownloaderPending: TListBox;
    Button1: TTntButton;
    Button2: TTntButton;
    tsHTMLParser: TTntTabSheet;
    Panel22: TPanel;
    edURIBase: TTntEdit;
    Label22: TTntLabel;
    N9: TMenuItem;
    mnuLoadFromBuffer: TMenuItem;
    mnuSaveToBuffer: TMenuItem;
    Slot12: TMenuItem;
    Slot22: TMenuItem;
    Slot32: TMenuItem;
    Slot42: TMenuItem;
    Slot52: TMenuItem;
    HREFParser1: THREFParser;
    PageControl2: TTntPageControl;
    tsHTMLRemote: TTntTabSheet;
    mmHTMLRemote: TSynMemo;
    tsIFrames: TTntTabSheet;
    mmIFrames: TSynMemo;
    Label24: TTntLabel;
    tsPScript: TTntTabSheet;
    Panel23: TPanel;
    Panel24: TPanel;
    Panel25: TPanel;
    PSScript1: TPSScript;
    btCompilePScript: TTntButton;
    mmPScriptDebug: TSynMemo;
    SynPasSyn1: TSynPasSyn;
    Panel26: TPanel;
    Splitter5: TSplitter;
    Panel27: TPanel;
    Splitter6: TSplitter;
    Panel28: TPanel;
    Panel29: TPanel;
    mmPScriptEditor: TSynMemo;
    mmPSInputData: TSynMemo;
    mmPSOutputData: TSynMemo;
    Label25: TTntLabel;
    Label26: TTntLabel;
    tsTools: TTntTabSheet;
    tsAbout: TTntTabSheet;
    btAbortDownloadAll: TTntButton;
    btListDownloadThreaded: TTntButton;
    stbrHTTP: TStatusBar;
    mmAbout: TTntMemo;
    PageControl4: TTntPageControl;
    tsBrowserASCII: TTntTabSheet;
    mmBrowser: TSynMemo;
    tsBrowserHex: TTntTabSheet;
    MPHexEditor2: TMPHexEditor;
    tsCookies: TTntTabSheet;
    mmCookies: TSynMemo;
    SynWebEngine1: TSynWebEngine;
    SynWebEsSyn1: TSynWebEsSyn;
    SynWebHtmlSyn1: TSynWebHtmlSyn;
    PopUpMnuDownloadHex: TTntPopupMenu;
    mnuSaveDownloadHex: TTntMenuItem;
    tsI1: TTntPageControl;
    tsEdEx: TTntTabSheet;
    Panel32: TPanel;
    Label23: TTntLabel;
    edEdExInput: TTntEdit;
    mmEdEx: TSynMemo;
    tsListMaker: TTntTabSheet;
    Splitter3: TSplitter;
    Label20: TTntLabel;
    Label21: TTntLabel;
    Panel15: TPanel;
    Label10: TTntLabel;
    Label11: TTntLabel;
    Label12: TTntLabel;
    Label13: TTntLabel;
    Label14: TTntLabel;
    Label15: TTntLabel;
    edFrom: TTntEdit;
    edWith: TTntEdit;
    edWithEnd: TTntEdit;
    cbPad: TTntCheckBox;
    seMin: TJvSpinEdit;
    seMax: TJvSpinEdit;
    sePad: TJvSpinEdit;
    btMakeList: TTntButton;
    mmListMakerOut: TSynMemo;
    mmListMakerIn: TSynMemo;
    tsTemplate: TTntTabSheet;
    Label27: TTntLabel;
    Label28: TTntLabel;
    Splitter7: TSplitter;
    Panel33: TPanel;
    Label29: TTntLabel;
    mmTemplatedListMakerTemplate: TSynMemo;
    btTemplatedListMakerGO: TTntButton;
    mmTemplatedListMakerIn: TSynMemo;
    mmTemplatedListMakerOut: TSynMemo;
    btFind2: TTntButton;
    edFind2: TTntEdit;
    btDebug: TTntButton;
    tbDownloaderTabs: TTntTabControl;
    PopUpMnuDownloaderTabs: TTntPopupMenu;
    mnuNewDownloaderTab: TTntMenuItem;
    N10: TTntMenuItem;
    mnuCloseDownloaderTab: TTntMenuItem;
    FontDialog1: TFontDialog;
    N11: TMenuItem;
    mnuLog: TMenuItem;
    tsLog: TTntTabSheet;
    mmLog: TSynMemo;
    TntPanel1: TTntPanel;
    tbDecoderTabs: TTntTabControl;
    PopUpMnuDecoderTabs: TTntPopupMenu;
    mnuNewDecoderTab: TTntMenuItem;
    N12: TTntMenuItem;
    mnuCloseDecoderTab: TTntMenuItem;
    tsSettings: TTntTabSheet;
    tsSettings2: TTntPageControl;
    tsSettingsGeneral: TTntTabSheet;
    tsSettingsDownl: TTntTabSheet;
    cbAutoParseLinksOnGET: TTntCheckBox;
    cbMalzillaProject: TTntCheckBox;
    cbAutoFocusDecoder: TTntCheckBox;
    cbAutoCompleteURL: TTntCheckBox;
    cbURLHistory: TTntCheckBox;
    Panel14: TPanel;
    Label7: TTntLabel;
    Label8: TTntLabel;
    Label9: TTntLabel;
    Label16: TTntLabel;
    Label17: TTntLabel;
    edProxyAddress: TTntEdit;
    edProxyPort: TTntEdit;
    cbHideProxyData: TTntCheckBox;
    edProxyUser: TMaskEdit;
    edProxyPass: TMaskEdit;
    Panel17: TPanel;
    btClearURLHist: TTntButton;
    btClearCache: TTntButton;
    Panel7: TPanel;
    btLoadUA: TTntButton;
    btSaveUA: TTntButton;
    Panel8: TPanel;
    Label3: TTntLabel;
    mmUserAgentsEditor: TTntMemo;
    cbClipboardClear: TTntCheckBox;
    cbClearCacheOnExit: TTntCheckBox;
    cbClearHistoryOnExit: TTntCheckBox;
    cbHighlight: TTntCheckBox;
    btFontSelect: TTntButton;
    Panel16: TPanel;
    Label19: TTntLabel;
    mmClipMonTrig: TTntMemo;
    btCheckUpdate: TTntButton;
    PopUpMnuClipMon: TTntPopupMenu;
    mnuClipMonPaste: TTntMenuItem;
    btConcatenate: TTntButton;
    edReplaceEval: TTntEdit;
    cbReplaceEval: TTntRadioButton;
    cbOverrideEval: TTntRadioButton;
    cbDoNotReplEval: TTntRadioButton;
    cbDontBotherMe: TTntCheckBox;
    btFormatText: TTntButton;
    btShowEvalResults: TTntButton;
    N13: TMenuItem;
    mnuScriptInternal: TMenuItem;
    JvRollOut1: TJvRollOut;
    btSendScript: TTntButton;
    btFindNextObject: TTntButton;
    btSendAllToDecoder: TTntButton;
    btAddSelectionToDecoder: TTntButton;
    btSendToHTMLParser: TTntButton;
    edFind: TTntEdit;
    btFind: TTntButton;
    btFormatHTML: TTntButton;
    JvRollOut2: TJvRollOut;
    lblURL: TTntLabel;
    edURL: TTntComboBox;
    lblUA: TTntLabel;
    comboUserAgent: TTntComboBox;
    lblReferre: TTntLabel;
    edReferrer: TTntEdit;
    lblCookies: TTntLabel;
    edCookies: TTntEdit;
    btGetThreaded: TTntButton;
    btGetToFile: TTntButton;
    cbUserAgent: TTntCheckBox;
    cbUseCookies: TTntCheckBox;
    btAbort: TTntButton;
    btLoadFromCache: TTntButton;
    cbUseProxy: TTntCheckBox;
    cbUseReferrer: TTntCheckBox;
    cbAutoReferrer: TTntCheckBox;
    btLinkParserSort: TTntButton;
    mnuNewDownloaderTabAuto: TTntMenuItem;
    cbAutoRedirect: TTntCheckBox;
    rbEdExNormal: TTntRadioButton;
    rbEdExLine: TTntRadioButton;
    rbEdExColumn: TTntRadioButton;
    TntLabel2: TTntLabel;
    edEdExInput2: TTntEdit;
    comboEdExAction: TTntComboBox;
    btEdExGO: TTntButton;
    btMiniHTMLView: TButton;
    seIncrementStep: TJvSpinEdit;
    PopUpMnuIncrement: TPopupMenu;
    mnuIncrementDec: TMenuItem;
    mnuIncrementHex: TMenuItem;
    mnuScriptConcatenate: TTntMenuItem;
    mnuScriptDBase64: TTntMenuItem;
    mnuScriptDUCS2: TTntMenuItem;
    mnuScriptDHex: TTntMenuItem;
    mnuScriptDDec: TTntMenuItem;
    mnuRemoveWhitespace: TTntMenuItem;
    mnuRemoveNULLs: TTntMenuItem;
    Slot51: TTntMenuItem;
    Slot41: TTntMenuItem;
    Slot31: TTntMenuItem;
    Slot21: TTntMenuItem;
    Slot11: TTntMenuItem;
    btTemplate: TTntButton;
    mmTemplates: TTntListBox;
    splTemplate: TTntSplitter;
    tsIPConvert: TTntTabSheet;
    edObfURL: TTntEdit;
    TntLabel3: TTntLabel;
    btDeobfuscateURL: TTntButton;
    mmDeobfURL: TSynMemo;
    rbPreDelim: TRadioButton;
    rbPostdelim: TRadioButton;
    tsMiscText: TTntTabSheet;
    tsMixHex: TTntTabSheet;
    MPHexEditor3: TMPHexEditor;
    Panel4: TPanel;
    cbMiscHexUnicode: TTntCheckBox;
    cbMiscHexUnicodeBigEndian: TTntCheckBox;
    cbMiscHexSwapNibbles: TTntCheckBox;
    PageControl6: TTntPageControl;
    tsKalimeroProcessor: TTntTabSheet;
    Panel6: TPanel;
    Panel9: TPanel;
    mmKalimero: TSynMemo;
    Panel10: TPanel;
    Splitter8: TSplitter;
    sgKalimeroArray: TStringGrid;
    btKalimeroStep1: TTntButton;
    btKalimeroStep2: TTntButton;
    tsLibEmu: TTntTabSheet;
    Panel30: TPanel;
    Panel31: TPanel;
    Panel34: TPanel;
    Splitter9: TSplitter;
    btRunLibEmu: TTntButton;
    emulator: TDosCommand;
    mmLibEmuOutput: TMemo;
    btLibEmuAbort: TButton;
    hexLibEmuInput: TMPHexEditor;
    cbLibEmuGetPC: TTntCheckBox;
    edKalimeroRegEx: TTntEdit;
    edKalimeroReplace: TTntEdit;
    cbKalimeroEscapeCorrection: TTntCheckBox;
    cbCaseSensitive: TTntCheckBox;
    cbCaseSensitive2: TTntCheckBox;
    edXOR: TTntEdit;
    btXOR: TTntButton;
    TntLabel1: TTntLabel;
    TntPanel2: TTntPanel;
    mmXORStrings: TTntMemo;
    TntLabel4: TTntLabel;
    TntLabel5: TTntLabel;
    btBFXOR: TTntButton;
    TntLabel6: TTntLabel;
    edXORKey: TTntEdit;
    btApplyXor: TTntButton;
    mnuHexCopyClipTextSel: TMenuItem;
    mnuHexCopyClipHexSel: TMenuItem;
    TntLabel7: TTntLabel;
    edXORKeyMAX: TTntEdit;
    lbXORString: TTntLabel;
    lbXORKey: TTntLabel;
    cbXORTurbo: TTntCheckBox;
    Panel35: TPanel;
    btHexDisasm: TTntButton;
    mmDisasm: TSynMemo;
    Splitter10: TSplitter;
    dlgSearch: TSynEditSearch;
    mnuScriptDUCS2NoDel: TTntMenuItem;
    mnuScriptDHexNoDel: TTntMenuItem;
    mnuRemovewhitespaceall1: TTntMenuItem;
    cbUseExtendedInfo: TTntCheckBox;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure btRunScriptClick(Sender: TObject);
    procedure btWide2UCS2Click(Sender: TObject);
    procedure btGetToFileClick(Sender: TObject);
    procedure comboUserAgentEnter(Sender: TObject);
    procedure btLoadUAClick(Sender: TObject);
    procedure btSaveUAClick(Sender: TObject);
    procedure btSendScriptClick(Sender: TObject);
    procedure mnuCopyClick(Sender: TObject);
    procedure mnuPasteClick(Sender: TObject);
    procedure mnuSelectAllClick(Sender: TObject);
    procedure mnuUndoClick(Sender: TObject);
    procedure mnuRedoClick(Sender: TObject);
    procedure mnuCutClick(Sender: TObject);
    procedure mnuDeleteClick(Sender: TObject);
    procedure btDecodeDecClick(Sender: TObject);
    procedure btDecodeHexClick(Sender: TObject);
    procedure btDecodeUCS2Click(Sender: TObject);
    procedure btDecodeMIMEClick(Sender: TObject);
    procedure btIncreaseClick(Sender: TObject);
    procedure btDecreaseClick(Sender: TObject);
    procedure btUCS2ToHexClick(Sender: TObject);
    procedure btReplaceClick(Sender: TObject);
    procedure btHexToFileClick(Sender: TObject);
    procedure btTextToFileClick(Sender: TObject);
    procedure mmBrowserChange(Sender: TObject);
    procedure btMakeListClick(Sender: TObject);
    procedure edURLKeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure btDecodeJSEncodeClick(Sender: TObject);
    procedure mnuLoadFromFileClick(Sender: TObject);
    procedure mnuSaveToFileClick(Sender: TObject);
    procedure mnuHexCopyClipTextClick(Sender: TObject);
    procedure mnuHexCopyClipHexClick(Sender: TObject);
    procedure mnuHexPasteClipTextClick(Sender: TObject);
    procedure mnuHexPasteClipHexClick(Sender: TObject);
    procedure btClearURLHistClick(Sender: TObject);
    procedure mnuHexSaveClick(Sender: TObject);
    procedure mnuHexLoadClick(Sender: TObject);
    procedure mnuClearClick(Sender: TObject);
    procedure cbHighlightClick(Sender: TObject);
    procedure mnuWordWrapClick(Sender: TObject);
    procedure PopUpMnuPopup(Sender: TObject);
    procedure mnuTrayShowClick(Sender: TObject);
    procedure mnuTrayHideClick(Sender: TObject);
    procedure mnuTrayCloseClick(Sender: TObject);
    procedure hkClipboardMonitor1Change(Sender: TObject);
    //procedure mnuTrayClipMonitorClick(Sender: TObject);
    procedure JvTrayIcon1DblClick(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure SockCallBack(Sender: TObject; Reason: THookSocketReason; const
      Value: string);
    procedure SockCallBack1(Sender: TObject; Reason: THookSocketReason; const
      Value: string);
    procedure cbHexUnicodeClick(Sender: TObject);
    procedure cbHexUnicodeBigClick(Sender: TObject);
    procedure cbHexSwapNibblesClick(Sender: TObject);
    procedure mnuTrayClipMonitorListClick(Sender: TObject);
    procedure btFindClick(Sender: TObject);
    procedure edFindChange(Sender: TObject);
    procedure btGetThreadedClick(Sender: TObject);
    procedure btAbortClick(Sender: TObject);
    procedure btLoadFromCacheClick(Sender: TObject);
    procedure btClearCacheClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure edFindKeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure mmListDownloaderPendingExit(Sender: TObject);
    procedure mmListDownloaderPendingDblClick(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure btSendToHTMLParserClick(Sender: TObject);
    procedure Slot11Click(Sender: TObject);
    procedure Slot12Click(Sender: TObject);
    procedure Slot22Click(Sender: TObject);
    procedure Slot32Click(Sender: TObject);
    procedure Slot42Click(Sender: TObject);
    procedure Slot52Click(Sender: TObject);
    procedure Slot21Click(Sender: TObject);
    procedure Slot31Click(Sender: TObject);
    procedure Slot41Click(Sender: TObject);
    procedure Slot51Click(Sender: TObject);
    procedure HREFParser1FoundHyperlink(Sender: TObject;
      Hyperlink: string);
    procedure mmScriptMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure btCompilePScriptClick(Sender: TObject);
    procedure PSScript1Compile(Sender: TPSScript);
    procedure mmListDownloaderPendingKeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure btTemplatedListMakerGOClick(Sender: TObject);
    procedure btAbortDownloadAllClick(Sender: TObject);
    procedure btListDownloadThreadedClick(Sender: TObject);
    procedure downloadThreadStatusCallBack(status: Integer; strStatus: string;
      URL: string);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure btCheckUpdateClick(Sender: TObject);
    procedure ParseCookies;
    procedure mmScriptPaintTransient(Sender: TObject; Canvas: TCanvas;
      TransientType: TTransientType);
    procedure mnuSaveDownloadHexClick(Sender: TObject);
    procedure btFind2Click(Sender: TObject);
    procedure edFind2KeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure edFind2Change(Sender: TObject);
    procedure btDebugClick(Sender: TObject);
    procedure UpdateDownloadTabCallback(cachedFile: string);
    procedure edURLDblClick(Sender: TObject);
    procedure mnuNewDownloaderTabClick(Sender: TObject);
    procedure tbDownloaderTabsChange(Sender: TObject);
    procedure tbDownloaderTabsChanging(Sender: TObject; var AllowChange:
      Boolean);
    procedure edURLExit(Sender: TObject);
    procedure mnuCloseDownloaderTabClick(Sender: TObject);
    procedure PopUpMnuDownloaderTabsPopup(Sender: TObject);
    procedure btFontSelectClick(Sender: TObject);
    procedure mnuLogClick(Sender: TObject);
    procedure AddToLog(s1: string; s2: TStringList);
    procedure tbDecoderTabsChange(Sender: TObject);
    procedure tbDecoderTabsChanging(Sender: TObject;
      var AllowChange: Boolean);
    procedure mnuNewDecoderTabClick(Sender: TObject);
    procedure mnuCloseDecoderTabClick(Sender: TObject);
    procedure PopUpMnuDecoderTabsPopup(Sender: TObject);
    procedure cbHideProxyDataClick(Sender: TObject);
    procedure btAddSelectionToDecoderClick(Sender: TObject);
    procedure btSendAllToDecoderClick(Sender: TObject);
    procedure btFindNextObjectClick(Sender: TObject);
    procedure cbAutoCompleteURLClick(Sender: TObject);
    procedure mnuClipMonPasteClick(Sender: TObject);
    procedure btConcatenateClick(Sender: TObject);
    procedure btFormatTextClick(Sender: TObject);
    procedure btFormatHTMLClick(Sender: TObject);
    procedure DecoderCallback(compiled: Boolean);
    procedure btShowEvalResultsClick(Sender: TObject);
    procedure mnuScriptConcatenateClick(Sender: TObject);
    procedure mnuScriptDDecClick(Sender: TObject);
    procedure mnuScriptDHexClick(Sender: TObject);
    procedure mnuScriptDUCS2Click(Sender: TObject);
    procedure mnuScriptDBase64Click(Sender: TObject);
    procedure btLinkParserSortClick(Sender: TObject);
    procedure mnuNewDownloaderTabAutoClick(Sender: TObject);
    procedure cbAutoRedirectClick(Sender: TObject);
    procedure cbAutoReferrerClick(Sender: TObject);
    procedure rbEdExNormalClick(Sender: TObject);
    procedure rbEdExLineClick(Sender: TObject);
    procedure rbEdExColumnClick(Sender: TObject);
    procedure btEdExGOClick(Sender: TObject);
    procedure edReferrerKeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure btMiniHTMLViewClick(Sender: TObject);
    procedure mnuRemoveNULLsClick(Sender: TObject);
    procedure mnuIncrementDecClick(Sender: TObject);
    procedure mnuIncrementHexClick(Sender: TObject);
    procedure mnuRemoveWhitespaceClick(Sender: TObject);
    procedure btTemplateClick(Sender: TObject);
    procedure mmTemplatesDblClick(Sender: TObject);
    procedure btDeobfuscateURLClick(Sender: TObject);
    procedure edObfURLKeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure mnuRemovewhitespaceall1Click(Sender: TObject);
    procedure tbChange(Sender: TObject);
    procedure cbMiscHexUnicodeClick(Sender: TObject);
    procedure cbMiscHexUnicodeBigEndianClick(Sender: TObject);
    procedure cbMiscHexSwapNibblesClick(Sender: TObject);
    procedure btKalimeroStep1Click(Sender: TObject);
    procedure btKalimeroStep2Click(Sender: TObject);
    procedure btRunLibEmuClick(Sender: TObject);
    procedure btLibEmuAbortClick(Sender: TObject);
    procedure emulatorTerminated(Sender: TObject; ExitCode: Cardinal);
    procedure edXORKeyPress(Sender: TObject; var Key: Char);
    procedure btXORClick(Sender: TObject);
    procedure btBFXORClick(Sender: TObject);
    procedure edXORKeyKeyPress(Sender: TObject; var Key: Char);
    procedure btApplyXorClick(Sender: TObject);
    procedure mnuHexCopyClipTextSelClick(Sender: TObject);
    procedure mnuHexCopyClipHexSelClick(Sender: TObject);
    procedure edXORKeyMAXKeyPress(Sender: TObject; var Key: Char);
    procedure btHexDisasmClick(Sender: TObject);
    procedure mmDisasmGutterGetText(Sender: TObject; aLine: Integer;
      var aText: WideString);
    procedure mnuScriptDHexNoDelClick(Sender: TObject);
    procedure mnuScriptDUCS2NoDelClick(Sender: TObject);

  private
    { Private declarations }
    DownloaderTabList: TList;
    DecoderTabList: TList;
    LisTTntEdit: TTntEdit;
    DecoderThread: TJSBrowserProxy;
    procedure OnStatus(Sender: TObject);
    procedure Flash;
    procedure LisTTntEditKeyPress(Sender: TObject; var Key: Char);
    procedure GetOpenDialogParam(cpnName: string);
    procedure SetOpenDialogParam(cpnName: string);
    procedure GetSaveDialogParam(cpnName: string);
    procedure SetSaveDialogParam(cpnName: string);
    procedure SetMalzillaProject(cpnName: string);
    procedure GetMalzillaProject(cpnName: string);
    procedure AddDownloaderTab;
    procedure AddDownloaderTabAuto;
    procedure UpdateDownloaderTab(i: Integer);
    procedure ShowDownloaderTab(i: Integer);
    procedure DeleteDownloaderTab(i: Integer);
    procedure AddDecoderTab;
    procedure UpdateDecoderTab(i: Integer);
    procedure ShowDecoderTab(i: Integer);
    procedure DeleteDecoderTab(i: Integer);
    function FixURLline(input: string): string;
    function parseTemplate(s: WideString): WideString;

  public
    { Public declarations }
    FPaintUpdating: Boolean;
    procedure cacheListsChanged;
  end;

const
  current_version = 1.20;

var
  frmMain: TfrmMain;
  cancelOP: Boolean;
  cacheMD5: TStringList;
  cacheURL: TStringList;
  cacheDate: TStringList;
  cacheOther: TStringList;
  cacheMD5Current: string;
  cacheURLCurrent: string;
  cacheDateCurrent: string;
  cacheOtherCurrent: string;
  cacheOtherReferrerCurrent: string;
  script_pos: integer;
  script_pos_object: Integer;
  downloaded: int64;
  content_length: int64;
  bar_selected: boolean;
  //my_clipboard: integer;
  find_pos: Integer;
  find_pos2: Integer;
  DownloaderBoxItemIndex: Integer;
  bufSlot1: WideString;
  bufSlot2: WideString;
  bufSlot3: WideString;
  bufSlot4: WideString;
  bufSlot5: WideString;
  cookiesList: TStringList;
  //language: string;
  MyDownloaderTab: TDownloaderTab;
  deletingDownloaderTabAction: Boolean;
  deletingDecoderTabAction: Boolean;
  LogActions: Boolean;
  MyDecoderTab: TDecoderTab;
  DownloaderTabNr: Integer;
  DecoderTabNr: Integer;
  Busy: Boolean;
  redirectionURL: string;
  opcodeSize: array of Integer;
  opcodeCounter: Integer;

implementation

{$R *.dfm}

uses untDownloadThread, untListDownloaderThread, untCacheList,
  untHTMLObjects, untEvalResults,
  untDelimiterDlg, untMiniHTMLView, untFTPThread, DisAsm32;

{$I incFunctions.Inc}
{$I incPasScriptFunctions.Inc}
{$I incMessages.inc}
{$I incXOR.Inc}

constructor TDownloaderTab.Create;
begin
  inherited;
end;

procedure TDownloaderTab.SetHTML(s: Widestring);
begin
  VHTML := s;
end;

procedure TDownloaderTab.SetURL(s: WideString);
begin
  VURL := s;
end;

procedure TDownloaderTab.SetUA(s: WideString);
begin
  VUA := s;
end;

procedure TDownloaderTab.SetReferrer(s: WideString);
begin
  VReferrer := s;
end;

procedure TDownloaderTab.SetCookies(s: WideString);
begin
  VCookies := s;
end;

procedure TDownloaderTab.SetHTTPHeaders(s: WideString);
begin
  VHTTPHeaders := s;
end;

procedure TDownloaderTab.SetHex(s: WideString);
begin
  VHex := s;
end;

procedure TDownloaderTab.SetCookieBox(s: WideString);
begin
  VCookiesBox := s;
end;

procedure TDownloaderTab.SetURIBase(s: WideString);
begin
  VURIBase := s;
end;

procedure TDownloaderTab.SetLinks(s: WideString);
begin
  VLinks := s;
end;

procedure TDownloaderTab.SetIFrames(s: WideString);
begin
  VIFrames := s;
end;

procedure TDownloaderTab.SetStatusDownload(s: WideString);
begin
  VStatusDownload := s;
end;

procedure TDownloaderTab.SetStatusHTTP(s: WideString);
begin
  VStatusHTTP := s;
end;

function TDownloaderTab.GetHTML: WideString;
begin
  Result := VHTML;
end;

function TDownloaderTab.GetURL: WideString;
begin
  Result := VURL;
end;

function TDownloaderTab.GetUA: WideString;
begin
  Result := VUA;
end;

function TDownloaderTab.GetReferrer: WideString;
begin
  Result := VReferrer;
end;

function TDownloaderTab.GetCookies: WideString;
begin
  Result := VCookies;
end;

function TDownloaderTab.GetHTTPHeaders: WideString;
begin
  Result := VHTTPHeaders;
end;

function TDownloaderTab.GetHex: WideString;
begin
  Result := VHex;
end;

function TDownloaderTab.GetCookieBox: WideString;
begin
  Result := VCookiesBox;
end;

function TDownloaderTab.GetURI: WideString;
begin
  Result := VURIBase;
end;

function TDownloaderTab.GetLinks: WideString;
begin
  Result := VLinks;
end;

function TDownloaderTab.GetIFrames: WideString;
begin
  Result := VIFrames;
end;

function TDownloaderTab.GetStatusDownload: WideString;
begin
  Result := VStatusDownload;
end;

function TDownloaderTab.GetStatusHTTP: WideString;
begin
  Result := VStatusHTTP;
end;

constructor TDecoderTab.Create;
begin
  inherited;
end;

procedure TDecoderTab.SetSrc(s: widestring);
begin
  VSrc := s;
end;

procedure TDecoderTab.SetTrg(s: widestring);
begin
  VTrg := s;
end;

procedure TDecoderTab.SetHighlighter(s: integer);
begin
  VHighlighter := s;
end;

function TDecoderTab.GetSrc: WideString;
begin
  Result := VSrc;
end;

function TDecoderTab.GetTrg: WideString;
begin
  Result := VTrg;
end;

function TDecoderTab.GetHighlighter: integer;
begin
  Result := VHighlighter;
end;

procedure TfrmMain.AddDecoderTab;
begin
  Inc(DecoderTabNr);
  MyDecoderTab := TDecoderTab.Create;
  MyDecoderTab.SetSrc('');
  MyDecoderTab.SetTrg('');
  MyDecoderTab.SetHighlighter(1);
  DecoderTabList.Add(MyDecoderTab);
end;

procedure TfrmMain.AddDownloaderTab;
begin
  MyDownloaderTab := TDownloaderTab.Create;
  Inc(DownloaderTabNr);
  MyDownloaderTab.SetURL('');
  MyDownloaderTab.SetHTML('');
  MyDownloaderTab.SetReferrer('');
  MyDownloaderTab.SetCookies('');
  MyDownloaderTab.SetHTTPHeaders('');
  MyDownloaderTab.SetHex('');
  MyDownloaderTab.SetCookieBox('');
  MyDownloaderTab.SetURIBase('');
  MyDownloaderTab.SetLinks('');
  MyDownloaderTab.SetIFrames('');
  MyDownloaderTab.SetUA(comboUserAgent.Text);
  MyDownloaderTab.SetStatusDownload('');
  MyDownloaderTab.SetStatusHTTP('');
  MyDownloaderTab.UseUA := cbUserAgent.Checked;
  MyDownloaderTab.UseCookies := cbUseCookies.Checked;
  MyDownloaderTab.UseProxy := cbUseProxy.Checked;
  DownloaderTabList.Add(MyDownloaderTab);
end;

procedure TfrmMain.AddDownloaderTabAuto;
var
  cookie: WideString;
  i: Integer;
begin
  cookie := '';
  for i := 0 to mmCookies.Lines.Count - 1 do
  begin
    cookie := cookie + mmCookies.Lines[i];
    if i < mmCookies.Lines.Count - 1 then
      cookie := cookie + ';';
  end;
  MyDownloaderTab := TDownloaderTab.Create;
  Inc(DownloaderTabNr);
  if redirectionURL <> '' then
    MyDownloaderTab.SetURL(redirectionURL)
  else
    MyDownloaderTab.SetURL('');
  MyDownloaderTab.SetHTML('');
  MyDownloaderTab.SetReferrer(edURL.Text);
  MyDownloaderTab.SetCookies(cookie);
  MyDownloaderTab.SetHTTPHeaders('');
  MyDownloaderTab.SetHex('');
  MyDownloaderTab.SetCookieBox('');
  MyDownloaderTab.SetURIBase('');
  MyDownloaderTab.SetLinks('');
  MyDownloaderTab.SetIFrames('');
  MyDownloaderTab.SetUA(comboUserAgent.Text);
  MyDownloaderTab.SetStatusDownload('');
  MyDownloaderTab.SetStatusHTTP('');
  MyDownloaderTab.UseUA := cbUserAgent.Checked;
  MyDownloaderTab.UseCookies := cbUseCookies.Checked;
  MyDownloaderTab.UseProxy := cbUseProxy.Checked;
  DownloaderTabList.Add(MyDownloaderTab);
end;

procedure TfrmMain.UpdateDecoderTab(i: integer);
begin
  MyDecoderTab := TDecoderTab.Create;
  MyDecoderTab.SetSrc(mmScript.Text);
  MyDecoderTab.SetTrg(mmResult.Text);
  if mmResult.Highlighter = SynWebEsSyn1 then
    MyDecoderTab.SetHighlighter(1)
  else
    MyDecoderTab.SetHighlighter(2);
  DecoderTabList[i] := MyDecoderTab;
end;

procedure TfrmMain.UpdateDownloaderTab(i: integer);
begin
  MyDownloaderTab := TDownloaderTab.Create;
  MyDownloaderTab.SetHTML(mmBrowser.Text);
  MyDownloaderTab.SetURL(edURL.Text);
  MyDownloaderTab.SetUA(comboUserAgent.Text);
  MyDownloaderTab.SetReferrer(edReferrer.Text);
  MyDownloaderTab.SetCookies(edCookies.Text);
  MyDownloaderTab.SetHTTPHeaders(mmHTTP.Text);
  MyDownloaderTab.SetHex(MPHexEditor2.AsHex);
  MyDownloaderTab.SetCookieBox(mmCookies.Text);
  MyDownloaderTab.SetURIBase(edURIBase.Text);
  MyDownloaderTab.SetLinks(mmHTMLRemote.Text);
  MyDownloaderTab.SetIFrames(mmIFrames.Text);
  MyDownloaderTab.SetStatusDownload(stbrStatusDownload.SimpleText);
  MyDownloaderTab.SetStatusHTTP(stbrHTTP.SimpleText);
  MyDownloaderTab.UseUA := cbUserAgent.Checked;
  MyDownloaderTab.UseCookies := cbUseCookies.Checked;
  MyDownloaderTab.UseProxy := cbUseProxy.Checked;
  DownloaderTabList[i] := (MyDownloaderTab);
end;

procedure TfrmMain.ShowDecoderTab(i: integer);
begin
  mmScript.Text := TDecoderTab(DecoderTabList[i]).GetSrc;
  mmResult.Text := TDecoderTab(DecoderTabList[i]).GetTrg;
  if TDecoderTab(DecoderTabList[i]).GetHighlighter = 1 then
    mmResult.Highlighter := SynWebEsSyn1
  else
    mmResult.Highlighter := SynWebHtmlSyn1;
end;

procedure TfrmMain.ShowDownloaderTab(i: Integer);
begin
  mmBrowser.Text := TDownloaderTab(DownloaderTabList[i]).GetHTML;
  edURL.Text := TDownloaderTab(DownloaderTabList[i]).GetURL;
  comboUserAgent.Text := TDownloaderTab(DownloaderTabList[i]).GetUA;
  edReferrer.Text := TDownloaderTab(DownloaderTabList[i]).GetReferrer;
  edCookies.Text := TDownloaderTab(DownloaderTabList[i]).GetCookies;
  mmHTTP.Text := TDownloaderTab(DownloaderTabList[i]).GetHTTPHeaders;
  mmCookies.Text := TDownloaderTab(DownloaderTabList[i]).GetCookieBox;
  mmHTMLRemote.Text := TDownloaderTab(DownloaderTabList[i]).GetLinks;
  mmIFrames.Text := TDownloaderTab(DownloaderTabList[i]).GetIFrames;
  edURIBase.Text := TDownloaderTab(DownloaderTabList[i]).GetURI;
  MPHexEditor2.AsHex := TDownloaderTab(DownloaderTabList[i]).GetHex;
  cbUserAgent.Checked := TDownloaderTab(DownloaderTabList[i]).UseUA;
  cbUseProxy.Checked := TDownloaderTab(DownloaderTabList[i]).UseProxy;
  cbUseCookies.Checked := TDownloaderTab(DownloaderTabList[i]).UseCookies;
  stbrStatusDownload.SimpleText :=
    TDownloaderTab(DownloaderTabList[i]).GetStatusDownload;
  stbrHTTP.SimpleText := TDownloaderTab(DownloaderTabList[i]).GetStatusHTTP;
end;

procedure TfrmMain.DeleteDecoderTab(i: Integer);
begin
  DecoderTabList.Delete(i);
end;

procedure TfrmMain.DeleteDownloaderTab(i: integer);
begin
  DownloaderTabList.Delete(i);
end;

procedure TfrmMain.UpdateDownloadTabCallback(cachedFile: string);
begin
  mmBrowser.Lines.LoadFromFile(cachedFile);
  MPHexEditor2.LoadFromFile(cachedFile);
  if cbAutoParseLinksOnGET.Checked then
    btSendToHTMLParser.Click;
  cancelOP := False;
end;

procedure TfrmMain.DecoderCallback(compiled: Boolean);
var
  DecoderCachefolder: string;
  cacheName: string;
  s1: TStringList;
  //i: Integer;
begin
  mmResult.WordWrap := True;
  if compiled then
  begin
    //stbrStatus.SimpleText := 'Script compiled';
    AddToLog('  Script compiled', nil);
  end
  else
  begin
    //stbrStatus.SimpleText := 'Script can''t be compiled';
    AddToLog('  Script can''t be compiled', nil);
  end;
  if not cbDontBotherMe.Checked then
    if (AnsiContainsText(mmResult.Text, 'document.write')) or
      (AnsiContainsText(mmResult.Text, 'eval')) then
    begin
      WideShowMessage('Compiled script is also a script');
      AddToLog(' Compiled script is also a script', nil);
    end;
  mmResult.Repaint;
  mmScript.Repaint;

  if compiled and (mmResult.Lines.Count > 0) then
  begin
    DecoderCachefolder := ExtractFilePath(application.ExeName) +
      'Decoder_Cache\';
    ForceDirectories(DecoderCacheFolder);
    mmScript.Lines.SaveToFile(DecoderCacheFolder + 'temp.file');
    cacheName := MD5Print(MD5File(DecoderCacheFolder + 'temp.file'));
    if not (RenameFile(DecoderCacheFolder + 'temp.file', DecoderCacheFolder +
      cacheName)) then
      DeleteFile(DecoderCacheFolder + 'temp.file')
    else
      AddToLog('  Source script saved as: ' + DecoderCacheFolder +
        cacheName, nil);
    mmResult.Lines.SaveToFile(DecoderCacheFolder + 'temp.file');
    cacheName := MD5Print(MD5File(DecoderCacheFolder + 'temp.file'));
    if not (RenameFile(DecoderCacheFolder + 'temp.file', DecoderCacheFolder +
      cacheName)) then
      DeleteFile(DecoderCacheFolder + 'temp.file')
    else
      AddToLog('  Compiled script saved as: ' + DecoderCacheFolder +
        cacheName, nil);
  end;
  if AnsiContainsText(mmResult.Text, 'document.write') then
    mmResult.Highlighter := SynWebEsSyn1;
  if AnsiContainsText(mmResult.Text, 'eval') then
    mmResult.Highlighter := SynWebEsSyn1;
  if AnsiContainsText(mmResult.Text, '<script') then
    mmResult.Highlighter := SynWebHtmlSyn1;

  s1 := TStringList.Create;
  try
    FindFiles(ExtractFilePath(Application.ExeName) +
      '\eval_temp\',
      faDirectory or
      faAnyFile, 0, false, s1);
    if s1.Count > 0 then
    begin
      frmEvalResults.lbEvalResults.Clear;
      frmEvalResults.lbEvalResults.Items.AddStrings(s1);
      frmEvalResults.Show;
    end;
  finally
    s1.Free;
  end;
  btRunScript.Enabled := True;
  btDebug.Enabled := True;
  Busy := False;
end;

procedure TfrmMain.cacheListsChanged;
begin
  if cacheMD5.IndexOf(cacheMD5Current) = -1 then
  begin
    cacheMD5.Add(cacheMD5Current);
    cacheURL.Add(cacheURLCurrent);
    cacheDate.Add(DateTimeToStr(Now));
    cacheMD5.SaveToFile(ExtractFilePath(application.exename) + 'CacheMD5.dat');
    cacheURL.SaveToFile(ExtractFilePath(application.exename) + 'CacheURL.dat');
    cacheDate.SaveToFile(ExtractFilePath(application.exename) +
      'CacheDate.dat');
  end;
end;

procedure TfrmMain.SockCallBack(Sender: TObject; Reason: THookSocketReason; const
  Value: string);
begin
  if Reason = HR_ReadCount then
    downloaded := downloaded + StrToIntDef(Value, -1);
  stbrStatusDownload.SimpleText := 'Downloaded ' + intToStr(downloaded) + '/' +
    IntToStr(Content_length) + ' bytes';
  application.ProcessMessages;
end;

procedure TfrmMain.SockCallBack1(Sender: TObject; Reason: THookSocketReason;
  const Value: string);
begin
  if Reason = HR_ReadCount then
    downloaded := downloaded + StrToIntDef(Value, -1);
  stbrListDownloader.SimpleText := 'Downloaded ' + intToStr(downloaded) + '/' +
    IntToStr(Content_length) + ' bytes';
  application.ProcessMessages;
end;

procedure TfrmMain.downloadThreadStatusCallBack(status: Integer; strStatus:
  string; URL: string);
var
  DlgMsg: WideString;
begin
  redirectionURL := '';
  if (status >= 300) and (status < 400) then
  begin
    redirectionURL := URL;
    stbrHTTP.SimpleText := IntToStr(status) + ' ' + strStatus + ' ' + URL;
    if not cbAutoRedirect.Checked then
    begin
      DlgMsg := 'Redirection to ' + URL + ' detected.' + #13#10 +
        'Follow redirection?';
      if WideMessageDlg(DlgMsg, mtConfirmation, [mbYes, mbNo], 0) =
        mrYes then
      begin
        edReferrer.Text := edURL.Text;
        edURL.Text := URL;
        btGetThreaded.Click;
      end;
    end
    else
    begin
      edReferrer.Text := edURL.Text;
      edURL.Text := URL;
      btGetThreaded.Click;
    end;
  end
  else if status = 0 then
    stbrHTTP.SimpleText := 'Time out'
  else if status = 1000 then
    stbrHTTP.SimpleText := strStatus + ' :: ' + URL
  else
    stbrHTTP.SimpleText := IntToStr(status) + ' ' + strStatus;
  if cbAutoReferrer.Checked then
  begin
    cacheOtherReferrerCurrent := edReferrer.Text;
    edReferrer.Text := edURL.Text;
  end;
end;

procedure TfrmMain.Flash;
var
  FWinfo: TFlashWInfo;
begin
  FWinfo.cbSize := 20;
  FWinfo.hwnd := Application.Handle; // Handle of Window to flash
  FWinfo.dwflags := FLASHW_ALL;
  FWinfo.ucount := 1; // number of times to flash
  FWinfo.dwtimeout := 0; // speed in ms, 0 default blink cursor rate
  FlashWindowEx(FWinfo); // make it flash!
end;

procedure TfrmMain.AddToLog(s1: string; s2: TStringList);
begin
  if LogActions then
  begin
    if s1 <> null then
      mmLog.Lines.Add(s1);
    if s2 <> nil then
    begin
      mmLog.Lines.Add(' ');
      mmLog.Lines.AddStrings(s2);
    end;
  end;
end;

procedure TfrmMain.GetOpenDialogParam(cpnName: string);
var
  Ini: TIniFile;
begin
  Ini := TIniFile.Create(ExtractFilePath(application.exename) + 'Folders.txt');
  try
    if cpnName = 'mmBrowser' then
    begin
      OpenDialog2.InitialDir := Ini.ReadString('mmBrowser', 'dir', '');
      OpenDialog2.Filter := Ini.ReadString('mmBrowser', 'Filter',
        '*.htm|*.htm|*.html|*.html|*.*|*.*');
      OpenDialog2.FilterIndex := 0;
      script_pos := 0;
      script_pos_object := 0;
    end;
    if cpnName = 'mmHTMLRemote' then
    begin
      OpenDialog2.InitialDir := Ini.ReadString('mmHTMLRemote', 'dir', '');
      OpenDialog2.Filter := Ini.ReadString('mmHTMLRemote', 'Filter',
        '*.lst|*.lst|*.*|*.*');
      OpenDialog2.FilterIndex := 0;
    end;
    if cpnName = 'mmIFrames' then
    begin
      OpenDialog2.InitialDir := Ini.ReadString('mmIFrames', 'dir', '');
      OpenDialog2.Filter := Ini.ReadString('mmIFrames', 'Filter',
        '*.lst|*.lst|*.*|*.*');
      OpenDialog2.FilterIndex := 0;
    end;
    if cpnName = 'mmScript' then
    begin
      OpenDialog2.InitialDir := Ini.ReadString('mmScript', 'dir', '');
      OpenDialog2.Filter := Ini.ReadString('mmScript', 'Filter',
        '*.js|*.js|*.*|*.*');
      OpenDialog2.FilterIndex := 0;
    end;
    if cpnName = 'mmResult' then
    begin
      OpenDialog2.InitialDir := Ini.ReadString('mmResult', 'dir', '');
      OpenDialog2.Filter := Ini.ReadString('mmResult', 'Filter',
        '*.js|*.js|*.vbs|*.vbs|*.html|*.html|*.*|*.*');
      OpenDialog2.FilterIndex := 0;
    end;
    if cpnName = 'mmMiscDec' then
    begin
      OpenDialog2.InitialDir := Ini.ReadString('mmMiscDec', 'dir', '');
      OpenDialog2.Filter := Ini.ReadString('mmMiscDec', 'Filter',
        '*.misc|*.misc|*.*|*.*');
      OpenDialog2.FilterIndex := 0;
    end;
    if cpnName = 'mmKalimero' then
    begin
      OpenDialog2.InitialDir := Ini.ReadString('mmKalimero', 'dir', '');
      OpenDialog2.Filter := Ini.ReadString('mmKalimero', 'Filter',
        '*.htm|*.htm|*.html|*.html|*.*|*.*');
      OpenDialog2.FilterIndex := 0;
    end;
    if cpnName = 'mmNotes' then
    begin
      OpenDialog2.InitialDir := Ini.ReadString('mmNotes', 'dir', '');
      OpenDialog2.Filter := Ini.ReadString('mmNotes', 'Filter',
        '*.txt|*.txt|*.*|*.*');
      OpenDialog2.FilterIndex := 0;
    end;
    if cpnName = 'mmPScriptEditor' then
    begin
      OpenDialog2.InitialDir := Ini.ReadString('mmPScriptEditor', 'dir', '');
      OpenDialog2.Filter := Ini.ReadString('mmPScriptEditor', 'Filter',
        '*.pscript|*.pscript|*.*|*.*');
      OpenDialog2.FilterIndex := 0;
    end;
    if cpnName = 'mmPSInputData' then
    begin
      OpenDialog2.InitialDir := Ini.ReadString('mmPSInputData', 'dir', '');
      OpenDialog2.Filter := Ini.ReadString('mmPSInputData', 'Filter',
        '*.data|*.data|*.*|*.*');
      OpenDialog2.FilterIndex := 0;
    end;
    if cpnName = 'mmPSOutputData' then
    begin
      OpenDialog2.InitialDir := Ini.ReadString('mmPSOutputData', 'dir', '');
      OpenDialog2.Filter := Ini.ReadString('mmPSOutputData', 'Filter',
        '*.data|*.data|*.*|*.*');
      OpenDialog2.FilterIndex := 0;
    end;
  finally
    Ini.Free;
  end;
end;

procedure TfrmMain.SetOpenDialogParam(cpnName: string);
var
  Ini: TIniFile;
begin
  Ini := TIniFile.Create(ExtractFilePath(application.exename) + 'Folders.txt');
  try
    if cpnName = 'mmBrowser' then
    begin
      Ini.WriteString('mmBrowser', 'dir', ExtractFileDir(OpenDialog2.FileName));
      Ini.WriteString('mmBrowser', 'Filter', OpenDialog2.Filter);
    end;
    if cpnName = 'mmHTMLRemote' then
    begin
      Ini.WriteString('mmHTMLRemote', 'dir',
        ExtractFileDir(OpenDialog2.FileName));
      Ini.WriteString('mmHTMLRemote', 'Filter', OpenDialog2.Filter);
    end;
    if cpnName = 'mmIFrames' then
    begin
      Ini.WriteString('mmIFrames', 'dir', ExtractFileDir(OpenDialog2.FileName));
      Ini.WriteString('mmIFrames', 'Filter', OpenDialog2.Filter);
    end;
    if cpnName = 'mmScript' then
    begin
      Ini.WriteString('mmScript', 'dir', ExtractFileDir(OpenDialog2.FileName));
      Ini.WriteString('mmScript', 'Filter', OpenDialog2.Filter);
    end;
    if cpnName = 'mmResult' then
    begin
      Ini.WriteString('mmResult', 'dir', ExtractFileDir(OpenDialog2.FileName));
      Ini.WriteString('mmResult', 'Filter', OpenDialog2.Filter);
    end;
    if cpnName = 'mmMiscDec' then
    begin
      Ini.WriteString('mmMiscDec', 'dir', ExtractFileDir(OpenDialog2.FileName));
      Ini.WriteString('mmMiscDec', 'Filter', OpenDialog2.Filter);
    end;
    if cpnName = 'mmKalimero' then
    begin
      Ini.WriteString('mmKalimero', 'dir',
        ExtractFileDir(OpenDialog2.FileName));
      Ini.WriteString('mmKalimero', 'Filter', OpenDialog2.Filter);
    end;
    if cpnName = 'mmNotes' then
    begin
      Ini.WriteString('mmNotes', 'dir', ExtractFileDir(OpenDialog2.FileName));
      Ini.WriteString('mmNotes', 'Filter', OpenDialog2.Filter);
    end;
    if cpnName = 'mmPScriptEditor' then
    begin
      Ini.WriteString('mmPScriptEditor', 'dir',
        ExtractFileDir(OpenDialog2.FileName));
      Ini.WriteString('mmPScriptEditor', 'Filter', OpenDialog2.Filter);
    end;
    if cpnName = 'mmPSInputData' then
    begin
      Ini.WriteString('mmPSInputData', 'dir',
        ExtractFileDir(OpenDialog2.FileName));
      Ini.WriteString('mmPSInputData', 'Filter', OpenDialog2.Filter);
    end;
    if cpnName = 'mmPSOutputData' then
    begin
      Ini.WriteString('mmPSOutputData', 'dir',
        ExtractFileDir(OpenDialog2.FileName));
      Ini.WriteString('mmPSOutputData', 'Filter', OpenDialog2.Filter);
    end;
  finally
    Ini.Free;
  end;
end;

procedure TfrmMain.GetSaveDialogParam(cpnName: string);
var
  Ini: TIniFile;
begin
  Ini := TIniFile.Create(ExtractFilePath(application.exename) + 'Folders.txt');
  try
    if cpnName = 'mmBrowser' then
    begin
      SaveDialog1.InitialDir := Ini.ReadString('mmBrowserS', 'dir', '');
      SaveDialog1.Filter := Ini.ReadString('mmBrowserS', 'Filter',
        '*.htm|*.htm|*.html|*.html|*.*|*.*');
      SaveDialog1.FilterIndex := 0;
      SaveDialog1.DefaultExt := 'html';
    end;
    if cpnName = 'mmHTMLRemote' then
    begin
      SaveDialog1.InitialDir := Ini.ReadString('mmHTMLRemoteS', 'dir', '');
      SaveDialog1.Filter := Ini.ReadString('mmHTMLRemoteS', 'Filter',
        '*.lst|*.lst|*.*|*.*');
      SaveDialog1.FilterIndex := 0;
      SaveDialog1.DefaultExt := 'lst';
    end;
    if cpnName = 'mmIFrames' then
    begin
      SaveDialog1.InitialDir := Ini.ReadString('mmIFramesS', 'dir', '');
      SaveDialog1.Filter := Ini.ReadString('mmIFramesS', 'Filter',
        '*.lst|*.lst|*.*|*.*');
      SaveDialog1.FilterIndex := 0;
      SaveDialog1.DefaultExt := 'lst';
    end;
    if cpnName = 'mmScript' then
    begin
      SaveDialog1.InitialDir := Ini.ReadString('mmScriptS', 'dir', '');
      SaveDialog1.Filter := Ini.ReadString('mmScriptS', 'Filter',
        '*.js|*.js|*.*|*.*');
      SaveDialog1.FilterIndex := 0;
      SaveDialog1.DefaultExt := 'js';
    end;
    if cpnName = 'mmResult' then
    begin
      SaveDialog1.InitialDir := Ini.ReadString('mmResultS', 'dir', '');
      SaveDialog1.Filter := Ini.ReadString('mmResultS', 'Filter',
        '*.js|*.js|*.vbs|*.vbs|*.html|*.html|*.*|*.*');
      SaveDialog1.FilterIndex := 0;
      SaveDialog1.DefaultExt := 'js';
    end;
    if cpnName = 'mmMiscDec' then
    begin
      SaveDialog1.InitialDir := Ini.ReadString('mmMiscDecS', 'dir', '');
      SaveDialog1.Filter := Ini.ReadString('mmMiscDecS', 'Filter',
        '*.misc|*.misc|*.*|*.*');
      SaveDialog1.FilterIndex := 0;
      SaveDialog1.DefaultExt := 'misc';
    end;
    if cpnName = 'mmKalimero' then
    begin
      SaveDialog1.InitialDir := Ini.ReadString('mmKalimeroS', 'dir', '');
      SaveDialog1.Filter := Ini.ReadString('mmKalimeroS', 'Filter',
        '*.htm|*.htm|*.html|*.html|*.*|*.*');
      SaveDialog1.FilterIndex := 0;
      SaveDialog1.DefaultExt := 'html';
    end;
    if cpnName = 'mmNotes' then
    begin
      SaveDialog1.InitialDir := Ini.ReadString('mmNotesS', 'dir', '');
      SaveDialog1.Filter := Ini.ReadString('mmNotesS', 'Filter',
        '*.txt|*.txt|*.*|*.*');
      SaveDialog1.FilterIndex := 0;
      SaveDialog1.DefaultExt := 'txt';
    end;
    if cpnName = 'mmPScriptEditor' then
    begin
      SaveDialog1.InitialDir := Ini.ReadString('mmPScriptEditorS', 'dir',
        '');
      SaveDialog1.Filter := Ini.ReadString('mmPScriptEditorS', 'Filter',
        '*.pscript|*.pscript|*.*|*.*');
      SaveDialog1.FilterIndex := 0;
      SaveDialog1.DefaultExt := 'pscript';
    end;
    if cpnName = 'mmPSInputData' then
    begin
      SaveDialog1.InitialDir := Ini.ReadString('mmPSInputDataS', 'dir', '');
      SaveDialog1.Filter := Ini.ReadString('mmPSInputDataS', 'Filter',
        '*.data|*.data|*.*|*.*');
      SaveDialog1.FilterIndex := 0;
      SaveDialog1.DefaultExt := 'data';
    end;
    if cpnName = 'mmPSOutputData' then
    begin
      SaveDialog1.InitialDir := Ini.ReadString('mmPSOutputDataS', 'dir', '');
      SaveDialog1.Filter := Ini.ReadString('mmPSOutputDataS', 'Filter',
        '*.data|*.data|*.*|*.*');
      SaveDialog1.FilterIndex := 0;
      SaveDialog1.DefaultExt := 'data';
    end;
  finally
    Ini.Free;
  end;
end;

procedure TfrmMain.SetSaveDialogParam(cpnName: string);
var
  Ini: TIniFile;
begin
  Ini := TIniFile.Create(ExtractFilePath(application.exename) + 'Folders.txt');
  try
    if cpnName = 'mmBrowser' then
    begin
      Ini.WriteString('mmBrowserS', 'dir',
        ExtractFileDir(SaveDialog1.FileName));
      Ini.WriteString('mmBrowserS', 'Filter', SaveDialog1.Filter);
    end;
    if cpnName = 'mmHTMLRemote' then
    begin
      Ini.WriteString('mmHTMLRemoteS', 'dir',
        ExtractFileDir(SaveDialog1.FileName));
      Ini.WriteString('mmHTMLRemoteS', 'Filter', SaveDialog1.Filter);
    end;
    if cpnName = 'mmIFrames' then
    begin
      Ini.WriteString('mmIFramesS', 'dir',
        ExtractFileDir(SaveDialog1.FileName));
      Ini.WriteString('mmIFramesS', 'Filter', SaveDialog1.Filter);
    end;
    if cpnName = 'mmScript' then
    begin
      Ini.WriteString('mmScriptS', 'dir', ExtractFileDir(SaveDialog1.FileName));
      Ini.WriteString('mmScriptS', 'Filter', SaveDialog1.Filter);
    end;
    if cpnName = 'mmResult' then
    begin
      Ini.WriteString('mmResultS', 'dir', ExtractFileDir(SaveDialog1.FileName));
      Ini.WriteString('mmResultS', 'Filter', SaveDialog1.Filter);
    end;
    if cpnName = 'mmMiscDec' then
    begin
      Ini.WriteString('mmMiscDecS', 'dir',
        ExtractFileDir(SaveDialog1.FileName));
      Ini.WriteString('mmMiscDecS', 'Filter', SaveDialog1.Filter);
    end;
    if cpnName = 'mmKalimero' then
    begin
      Ini.WriteString('mmKalimeroS', 'dir',
        ExtractFileDir(SaveDialog1.FileName));
      Ini.WriteString('mmKalimeroS', 'Filter', SaveDialog1.Filter);
    end;
    if cpnName = 'mmNotes' then
    begin
      Ini.WriteString('mmNotesS', 'dir', ExtractFileDir(SaveDialog1.FileName));
      Ini.WriteString('mmNotesS', 'Filter', SaveDialog1.Filter);
    end;
    if cpnName = 'mmPScriptEditor' then
    begin
      Ini.WriteString('mmPScriptEditorS', 'dir',
        ExtractFileDir(SaveDialog1.FileName));
      Ini.WriteString('mmPScriptEditorS', 'Filter', SaveDialog1.Filter);
    end;
    if cpnName = 'mmPSInputData' then
    begin
      Ini.WriteString('mmPSInputDataS', 'dir',
        ExtractFileDir(SaveDialog1.FileName));
      Ini.WriteString('mmPSInputDataS', 'Filter', SaveDialog1.Filter);
    end;
    if cpnName = 'mmPSOutputData' then
    begin
      Ini.WriteString('mmPSOutputDataS', 'dir',
        ExtractFileDir(SaveDialog1.FileName));
      Ini.WriteString('mmPSOutputDataS', 'Filter', SaveDialog1.Filter);
    end;
  finally
    Ini.Free;
  end;
end;

procedure TfrmMain.SetMalzillaProject(cpnName: string);
var
  params: TStringList;
  cookie: WideString;
  i: Integer;
begin
  cookie := '';
  for i := 0 to mmCookies.Lines.Count - 1 do
  begin
    cookie := cookie + mmCookies.Lines[i];
    if i < mmCookies.Lines.Count - 1 then
      cookie := cookie + ';';
  end;
  if cpnName = 'mmBrowser' then
  begin
    if Pos('<!-- Malzilla Project', mmBrowser.Text) = 0 then
    begin
      params := TStringList.Create;
      params.Add('<!-- Malzilla Project v.1 -->');
      params.Add('<!-- DAT: ' + DateTimeToStr(Now) + ' -->');
      params.Add('<!-- URL: ' + edURL.Text + ' -->');
      params.Add('<!-- REF: ' + cacheOtherReferrerCurrent + ' -->');
      if cbUserAgent.Checked then
        params.Add('<!-- UAS: ' + comboUserAgent.Text + ' -->');
      params.Add('<!-- CCK: ' + cookie + ' -->');
      mmBrowser.Text := params.Text + mmBrowser.Text;
      params.Free;
    end;
  end;
end;

procedure TfrmMain.GetMalzillaProject(cpnName: string);
var
  temp: string;
  l1: Integer;
  l2: Integer;
begin
  if cpnName = 'mmBrowser' then
  begin
    if Pos('<!-- Malzilla Project v.1 -->', mmBrowser.Text) <> 0 then
    begin
      l1 := Pos('<!-- URL: ', mmBrowser.Text) + 10;
      l2 := PosEx(' -->', mmBrowser.Text, l1);
      temp := copy(mmBrowser.Text, l1, l2 - l1);
      edURL.Text := Trim(temp);
      l1 := Pos('<!-- REF: ', mmBrowser.Text) + 10;
      l2 := PosEx(' -->', mmBrowser.Text, l1);
      temp := copy(mmBrowser.Text, l1, l2 - l1);
      edReferrer.Text := Trim(temp);
      l1 := Pos('<!-- UAS: ', mmBrowser.Text) + 10;
      l2 := PosEx(' -->', mmBrowser.Text, l1);
      temp := copy(mmBrowser.Text, l1, l2 - l1);
      comboUserAgent.Text := Trim(temp);
      l1 := Pos('<!-- CCK: ', mmBrowser.Text) + 10;
      l2 := PosEx(' -->', mmBrowser.Text, l1);
      temp := copy(mmBrowser.Text, l1, l2 - l1);
      edCookies.Text := Trim(temp);
    end;
  end;
end;

procedure TfrmMain.ParseCookies;
var
  i: Integer;
  c: string;
begin
  c := '';
  mmCookies.Lines.AddStrings(cookiesList);
  for i := 0 to cookiesList.Count - 1 do
    c := c + cookiesList[i] + ';';
  cacheOtherCurrent := cacheMD5Current + '**' + edURL.Text + '**' +
    DateTimeToStr(Now)
    + '**' + comboUserAgent.Text + '**' + cacheOtherReferrerCurrent + '**' + c;
  cacheOther.Add(cacheOtherCurrent);
  cacheOther.SaveToFile(ExtractFilePath(application.exename) +
    'CacheOther.dat');
end;

procedure TfrmMain.FormCreate(Sender: TObject);
var
  Ini: TIniFile;
  i: integer;
  a: string;
  emu_present: Boolean;
begin
  //InstallTntSystemUpdates;
  //create folders
  a := ExtractFilePath(Application.ExeName);
  ForceDirectories(a + '\eval_temp');
  ForceDirectories(a + '\decoder_cache');
  ForceDirectories(a + '\cache');

  //emu_present
  emu_present := True;
  if not (FileExists(ExtractFileDir(Application.ExeName) +
    '\libemu\cygemu-2.dll')) then
    emu_present := False;
  if not (FileExists(ExtractFileDir(Application.ExeName) +
    '\libemu\cygwin1.dll')) then
    emu_present := False;
  if not (FileExists(ExtractFileDir(Application.ExeName) + '\libemu\sctest.exe'))
    then
    emu_present := False;
  if not emu_present then
    tsLibEmu.TabVisible := False;

  if Win32Platform = VER_PLATFORM_WIN32_NT then
    Font.Name := 'MS Shell Dlg 2'
  else
    Font.Name := 'MS Shell Dlg';
  bar_selected := False;
  Busy := False;

  Ini := TIniFile.Create(ExtractFilePath(application.exename) + 'Settings.txt');
  try
    cbUserAgent.Checked := Ini.ReadBool('Downloader', 'UseUserAgent', false);
    comboUserAgent.Text := Ini.ReadString('Downloader', 'UserAgentString', '');
    cbUseProxy.Checked := Ini.ReadBool('Downloader', 'UseProxy', false);
    cbUseCookies.Checked := Ini.ReadBool('Downloader', 'UseCookies', false);
    cbUseReferrer.Checked := Ini.ReadBool('Downloader', 'UseReferrer', false);
    cbAutoRedirect.Checked := Ini.ReadBool('Downloader', 'AutoRedirect', false);
    cbAutoReferrer.Checked := Ini.ReadBool('Downloader', 'AutoReferrer', false);
    cbAutoParseLinksOnGET.Checked := Ini.ReadBool('Downloader',
      'AutoParseLinks', false);
    cbMalzillaProject.Checked := Ini.ReadBool('Downloader', 'SaveAsProject',
      false);
    cbAutoCompleteURL.Checked := Ini.ReadBool('Downloader', 'AutoComplete',
      true);
    edURL.AutoComplete := cbAutoCompleteURL.Checked;
    cbURLHistory.Checked := Ini.ReadBool('Downloader', 'URLHistory', true);
    cbUseExtendedInfo.Checked := Ini.ReadBool('Downloader', 'ExtendedInfo', True);
    cbHideProxyData.Checked := Ini.ReadBool('Proxy', 'Hidden', false);
    edProxyAddress.Text := Ini.ReadString('Proxy', 'Address', '');
    edProxyPort.Text := Ini.ReadString('Proxy', 'Port', '');
    if not cbHideProxyData.Checked then
    begin
      edProxyUser.Text := Ini.ReadString('Proxy', 'User', '');
      edProxyPass.Text := Ini.ReadString('Proxy', 'Pass', '');
    end;
    mnuTrayClipMonitorList.Checked := Ini.ReadBool('Monitor', 'Multi', false);
    cbClipBoardClear.Checked := Ini.ReadBool('Misc', 'ClearClipboard', false);
    cbClearCacheOnExit.Checked := Ini.ReadBool('Misc', 'ClearCache', false);
    cbClearHistoryOnExit.Checked := Ini.ReadBool('Misc', 'ClearHistory', false);
    cbReplaceEval.Checked := Ini.ReadBool('Decoder', 'ReplaceEval', false);
    edReplaceEval.Text := Ini.ReadString('Decoder', 'ReplaceEvalWith', '');
    cbOverrideEval.Checked := Ini.ReadBool('Decoder', 'OverrideEval', false);
    cbDontBotherMe.Checked := Ini.ReadBool('Decoder', 'AutoReplaceEval', false);
    cbHighlight.Checked := Ini.ReadBool('Display', 'Highlight', true);
    frmMain.Font.Name := Ini.ReadString('Display', 'FontName',
      'MS Shell Dlg 2');
    frmMain.Font.Size := Ini.ReadInteger('Display', 'FontSize', 8);
    cbAutoFocusDecoder.Checked := Ini.ReadBool('Display', 'AutoFocusDecoder',
      False);
    mmScript.Highlighter.Enabled := cbHighlight.Checked;
    mmResult.Highlighter.Enabled := cbHighlight.Checked;
    mmBrowser.Highlighter.Enabled := cbHighlight.Checked;
    //language := Ini.ReadString('Display', 'Language', '');
    if mnuTrayClipMonitorList.Checked then
    begin
      hkClipboardMonitor1.Enabled := true;
      if cbClipBoardClear.Checked then
        Clipboard.Clear;
    end;
  finally
    Ini.Free;
  end;
  for i := 0 to mmUserAgentsEditor.Lines.Count - 1 do
  begin
    mmUserAgentsEditor.Lines[i] := trim(mmUserAgentsEditor.Lines[i]);
  end;
  if cbURLHistory.Checked then
  begin
    if FileExists(ExtractFilePath(application.exename) + 'URL_history.txt') then
      edURL.Items.LoadFromFile(ExtractFilePath(application.exename) +
        'URL_history.txt');
  end;
  if FileExists(ExtractFilePath(application.exename) + 'User_agents.txt') then
    mmUserAgentsEditor.Lines.LoadFromFile(ExtractFilePath(application.exename) +
      'User_agents.txt');
  if FileExists(ExtractFilePath(application.exename) + 'HTTP_triggers.txt') then
    mmClipMonTrig.Lines.LoadFromFile(ExtractFilePath(application.exename) +
      'HTTP_triggers.txt');
  comboUserAgent.Items := mmUserAgentsEditor.Lines;
  find_pos := 0;
  find_pos2 := 0;
  opcodeCounter := 0;
  SetLength(opcodeSize, 0);
  SetLength(opcodeSize, 1);
  cancelOP := False;
  script_pos := 0;
  script_pos_object := 0;
  cacheMD5 := TStringList.Create;
  cacheURL := TStringLIst.Create;
  cacheDate := TStringList.Create;
  cacheOther := TStringList.Create;
  cacheURL.CaseSensitive := false;
  cacheMD5.CaseSensitive := false;
  cacheOther.CaseSensitive := False;
  if FileExists(ExtractFilePath(application.exename) + 'CacheMD5.dat') then
  begin
    cacheMD5.LoadFromFile(ExtractFilePath(application.exename) +
      'CacheMD5.dat');
    if FileExists(ExtractFilePath(application.exename) + 'CacheURL.dat') then
      cacheURL.LoadFromFile(ExtractFilePath(application.exename) +
        'CacheURL.dat');
    if FileExists(ExtractFilePath(application.exename) + 'CacheDate.dat') then
      cacheDate.LoadFromFile(ExtractFilePath(application.exename) +
        'CacheDate.dat');
    if FileExists(ExtractFilePath(application.exename) + 'CacheOther.dat') then
      cacheOther.LoadFromFile(ExtractFilePath(application.exename) +
        'CacheOther.dat');
  end;
  //create TTntEdit for editing listboxes
  LisTTntEdit := TTntEdit.Create(self);
  LisTTntEdit.Visible := false;
  LisTTntEdit.Ctl3D := false;
  LisTTntEdit.BorderStyle := bsNone;
  LisTTntEdit.Parent := mmListDownloaderPending;
  LisTTntEdit.Width := mmListDownloaderPending.ClientWidth;
  LisTTntEdit.OnKeyPress := LisTTntEditKeyPress;
  cookiesList := TStringList.Create;
  FPaintUpdating := False;
  MyDownloaderTab := TDownloaderTab.Create;
  DownloaderTabList := TList.Create;
  DecoderTabList := TList.Create;
  DownloaderTabNr := 0;
  DecoderTabNr := 0;
  AddDownloaderTab;
  AddDecoderTab;
  deletingDownloaderTabAction := False;
  deletingDecoderTabAction := False;
  //cmd arguments
  if ParamCount > 1 then
  begin
    if LowerCase(ParamStr(1)) = '-url' then
    begin
      edURL.Text := FixURLLine(ParamStr(2));
    end
    else if LowerCase(ParamStr(1)) = '-html' then
    begin
      if FileExists(ParamStr(2)) then
        mmBrowser.Lines.LoadFromFile(ParamStr(2));
    end
    else if LowerCase(ParamStr(1)) = '-js' then
    begin
      if FileExists(ParamStr(2)) then
        mmScript.Lines.LoadFromFile(ParamStr(2));
      PageControl1.ActivePage := tsDecoder;
    end
    else
      ShowMessage('Wrong arguments passed' + #13#10 + ParamStr(1) + #13#10 +
        ParamStr(2));
  end;
end;

procedure TfrmMain.FormDestroy(Sender: TObject);
begin
  cacheMD5.Free;
  cacheURL.Free;
  cacheDate.Free;
  cacheOther.Free;
  LisTTntEdit.Free;
  cookiesList.Free;
  DownloaderTabList.Free;
  DecoderTabList.Free;
end;

procedure TfrmMain.LisTTntEditKeyPress(Sender: TObject; var Key: Char);
var
  ii: Integer;
begin
  if Key = #13 then
  begin
    ii := DownloaderBoxItemIndex;
    mmListDownloaderPending.Items.Delete(ii);
    mmListDownloaderPending.Items.Insert(ii, LisTTntEdit.Text);
    LisTTntEdit.Visible := False;
    Key := #0;
  end;
end;

procedure TfrmMain.btRunScriptClick(Sender: TObject);
var
  //DecoderThread: TJSBrowserProxy;           //premestam u globalne varijable
  script_buff: WideString;
begin
  if mmScript.Text <> '' then
  begin
    Busy := True;
    mmResult.Lines.BeginUpdate;
    mmScript.Lines.BeginUpdate;
    //mmResult.Enabled := False;
    //mmScript.Enabled := False;
    mmResult.Visible := False;
    mmScript.Visible := False;
    mmResult.WordWrap := False;
    btRunScript.Enabled := False;
    btDebug.Enabled := False;

    AddToLog('====================', nil);
    AddToLog('Decoder:', nil);
    if pos('arguments.callee.toString(', mmScript.Text) > 0 then
    begin
      if WideMessageDlg('Script contains arguments.callee.toString() function.'
        +
        #13#10 +
        'Please referr to the tutorial on Malzilla''s website on how to replace this function',
        mtConfirmation, [mbAbort, mbIgnore], 0) =
        mrAbort then
      begin
        btRunScript.Enabled := True;
        btDebug.Enabled := True;
        Exit;
      end;
    end;
    stbrStatus.SimpleText := 'Working...';
    mmResult.Clear;

    DecoderThread := TJSBrowserProxy.Create(true);
    DecoderThread.FreeOnTerminate := True;
    DecoderThread.tEvalReplace := False;
    DecoderThread.tExeFolder := ExtractFilePath(Application.ExeName);

    script_buff := mmScript.Text;
    if cbReplaceEval.Checked and (edReplaceEval.Text <> '') then
    begin
      if pos('eval', mmScript.Text) > 0 then
      begin
        if cbDontBotherMe.Checked then
        begin
          script_buff := StringReplace(mmScript.Text, 'eval',
            edReplaceEval.Text,
            [rfReplaceAll]);
          DecoderThread.tEval := edReplaceEval.Text;
          DecoderThread.tEvalReplace := True;
          AddToLog('  Automatically replace eval() with ' + edReplaceEval.Text,
            nil);
        end
        else
        begin
          if WideMessageDlg('Script contains eval() function.' + #13#10 +
            'Replace with ' + edReplaceEval.Text + '() ?', mtConfirmation,
            [mbYes,
            mbNo], 0) =
            mrYes then
          begin
            script_buff := StringReplace(mmScript.Text, 'eval',
              edReplaceEval.Text, [rfReplaceAll]);

            DecoderThread.tEval := edReplaceEval.Text;
            DecoderThread.tEvalReplace := True;
            AddToLog('  Replace eval() with ' + edReplaceEval.Text, nil);
          end
          else
            script_buff := mmScript.Text;
        end;
      end;
    end;
    if cbOverrideEval.Checked then
    begin
      if pos('eval', mmScript.Text) > 0 then
      begin
        if cbDontBotherMe.Checked then
        begin
          script_buff := 'function eval(a) {document.write(a)};' + #13#10 +
            mmScript.Text;
          AddToLog('  Automatically override eval()', nil);
        end
        else
        begin
          if WideMessageDlg('Script contains eval() function.' + #13#10 +
            'Override it?', mtConfirmation,
            [mbYes,
            mbNo], 0) =
            mrYes then
          begin
            script_buff := 'function eval(a) {document.write(a)};' + #13#10 +
              mmScript.Text;
            AddToLog('  Override eval()', nil);
          end
          else
            script_buff := mmScript.Text;
        end;
      end;
    end;

    DecoderThread.tScript := script_buff;
    DecoderThread.tDebug := False;
    DecoderThread.tEvalFolder := ExtractFilePath(Application.ExeName) +
      '\eval_temp\';
    DecoderThread.Resume;
  end;
end;

procedure TfrmMain.OnStatus(Sender: TObject);
begin
  //stbrStatus.SimpleText := Brws.Status;
end;

procedure TfrmMain.btWide2UCS2Click(Sender: TObject);
begin
  mmResult.Text := WideStringToUCS2(mmResult.Text);
end;

procedure TfrmMain.btGetToFileClick(Sender: TObject);
var
  HTTP: THTTPSend;
begin
  if edURL.Text <> '' then
  begin
    find_pos := 0;
    bar_selected := false;
    edUrl.SelStart := 0;
    edUrl.SelLength := 0;
    edURL.Items.Add(edURL.Text);
    stbrStatusDownload.SimpleText := 'Working...';
    if rpos('/', edURL.Text) < (length(edURL.Text)) then
    begin
      SaveDialog1.FileName := copy(edURL.Text, rpos('/', edURL.Text) + 1,
        length(edURL.Text));
      SaveDialog1.DefaultExt :=
        StringReplace(ExtractFileExt(SaveDialog1.FileName), '.', '', []);
    end
    else
      SaveDialog1.FileName := 'index.html';
    if SaveDialog1.Execute then
    begin
      HTTP := THTTPSend.Create;
      HTTP.Sock.OnStatus := SockCallBack;
      try
        if cbUseProxy.Checked and (edProxyAddress.Text <> '') and
          (edProxyPort.Text <> '') then
        begin
          HTTP.ProxyHost := edProxyAddress.Text;
          HTTP.ProxyPort := edProxyPort.Text;
          if edProxyUser.Text <> '' then
          begin
            HTTP.ProxyUser := edProxyUser.Text;
            HTTP.ProxyPass := edProxyPass.Text;
          end;
        end;
        if cbUseReferrer.Checked and (edReferrer.Text <> '') then
          HTTP.Headers.Add('Referer: ' + edReferrer.Text);
        if cbUserAgent.Checked and (comboUserAgent.Text <> '') then
          HTTP.UserAgent := comboUserAgent.Text;
        if HTTP.HTTPMethod('GET', edURL.text) then
          HTTP.Document.SaveToFile(SaveDialog1.FileName);
        mmHTTP.Lines.Assign(HTTP.Headers);
        mmBrowser.Lines.LoadFromStream(HTTP.Document);
      finally
        HTTP.Free;
      end;
    end;
  end;
  stbrStatusDownload.SimpleText := '';
  script_pos := 0;
  script_pos_object := 0;
end;

procedure TfrmMain.comboUserAgentEnter(Sender: TObject);
var
  i: integer;
begin
  for i := 0 to mmUserAgentsEditor.Lines.Count - 1 do
  begin
    mmUserAgentsEditor.Lines[i] := trim(mmUserAgentsEditor.Lines[i]);
  end;
  comboUserAgent.Items := mmUserAgentsEditor.Lines;
end;

procedure TfrmMain.btLoadUAClick(Sender: TObject);
begin
  if OpenDialog1.Execute then
    mmUserAgentsEditor.Lines.LoadFromFile(OpenDialog1.FileName);
end;

procedure TfrmMain.btSaveUAClick(Sender: TObject);
begin
  if SaveDialog2.Execute then
    mmUserAgentsEditor.Lines.SaveToFile(SaveDialog2.FileName);
end;

procedure TfrmMain.btSendScriptClick(Sender: TObject);
var
  i1, j1: integer;
begin
  if mmBrowser.Text <> '' then
  begin
    if GetShiftState = [ssCtrl] then
    begin
      AddDecoderTab;
      tbDecoderTabs.Tabs.Add('New Tab (' + IntToStr(DecoderTabNr) + ')');
      if (tbDecoderTabs.TabIndex > -1) and (deletingDecoderTabAction = False)
        then
        UpdateDecoderTab(tbDecoderTabs.TabIndex);
      deletingDecoderTabAction := False;
      tbDecoderTabs.TabIndex := tbDecoderTabs.Tabs.Count - 1;
      ShowDecoderTab(tbDecoderTabs.TabIndex);
    end;
    if posEx('<script', LowerCase(mmBrowser.Text), script_pos) = 0 then
      script_pos := 0;
    i1 := posEx('>', LowerCase(mmBrowser.Text), posEx('<script',
      LowerCase(mmBrowser.Text), script_pos));
    if i1 > 0 then
    begin
      mmBrowser.SelStart := i1;
      j1 := posEx('</script>', LowerCase(mmBrowser.Text), i1) - i1 - 1;
      if j1 > 0 then
      begin
        if Trim(Copy(mmBrowser.Text, i1, j1)) <> '' then
          mmBrowser.SelLength := j1;
        script_pos := j1 + i1;
        //ShowMessage(IntToStr(i1) + ' : ' + IntToStr(j1));  //debug
      end
      else
      begin
        //mmBrowser.SelLength := length(mmBrowser.Text);
        //script_pos := length(mmBrowser.Text);
        // patch for <script src=""something.js" language="JavaScript"></script>
        mmBrowser.SelLength := 0;
        script_pos := i1;
      end;
      mmScript.Text := Copy(mmBrowser.Text, mmBrowser.SelStart + 1,
        mmBrowser.SelLength);
      if cbAutoFocusDecoder.Checked then
        PageControl4.ActivePage := tsDecoder;
    end;
  end;
end;

procedure TfrmMain.mnuCopyClick(Sender: TObject);
begin
  //Clipboard.Clear;
  //My_clipboard := 1;
  TSynMemo(PopUpMnu.PopupComponent).CopyToClipboard;
end;

procedure TfrmMain.mnuPasteClick(Sender: TObject);
begin
  TSynMemo(PopUpMnu.PopupComponent).PasteFromClipboard;
  find_pos := 0;
end;

procedure TfrmMain.mnuSelectAllClick(Sender: TObject);
begin
  TSynMemo(PopUpMnu.PopupComponent).SelectAll;
end;

procedure TfrmMain.mnuUndoClick(Sender: TObject);
begin
  TSynMemo(PopUpMnu.PopupComponent).Undo;
end;

procedure TfrmMain.mnuRedoClick(Sender: TObject);
begin
  TSynMemo(PopUpMnu.PopupComponent).Redo;
end;

procedure TfrmMain.mnuCutClick(Sender: TObject);
begin
  //Clipboard.Clear;
  //My_clipboard := 1;
  TSynMemo(PopUpMnu.PopupComponent).CutToClipboard;
  find_pos := 0;
end;

procedure TfrmMain.mnuDeleteClick(Sender: TObject);
begin
  TSynMemo(PopUpMnu.PopupComponent).ClearSelection;
  find_pos := 0;
end;

procedure TfrmMain.btDecodeDecClick(Sender: TObject);
begin
  if edDelimiter.Text <> '' then
    mmMiscDec.Text := dec2str(trim(mmMiscDec.Text), edDelimiter.Text,
      rbPreDelim.Checked)
  else
    mmMiscDec.Text := dec2str(trim(mmMiscDec.Text), ',', rbPreDelim.Checked)
end;

procedure TfrmMain.btDecodeHexClick(Sender: TObject);
begin
  if edDelimiter.Text <> '' then
    mmMiscDec.Text := hex2str2(trim(mmMiscDec.Text), edDelimiter.Text,
      rbPreDelim.Checked)
  else
    mmMiscDec.Text := hex2str2(trim(mmMiscDec.Text), '%', rbPreDelim.Checked)
end;

procedure TfrmMain.btDecodeUCS2Click(Sender: TObject);
begin
  if edDelimiter.Text <> '' then
    mmMiscDec.Text := uni2str(trim(mmMiscDec.Text), edDelimiter.Text,
      rbPreDelim.Checked)
  else
    mmMiscDec.Text := uni2str(trim(mmMiscDec.Text), '%u', rbPreDelim.Checked)
end;

procedure TfrmMain.btDecodeMIMEClick(Sender: TObject);
var
  temp: string;
begin
  temp := StringReplace(mmMiscDec.Text, #13#10, '', [rfReplaceAll]);
  if (length(temp) mod 4) = 0 then
  try
    mmMiscDec.Text := IdDecoderMIME1.DecodeToString(temp);
  except on e: exception do
      WideShowMessage(e.Message);
  end;
end;

procedure TfrmMain.btIncreaseClick(Sender: TObject);
var
  i, j: integer;
  tmpStr: WideString;
begin
  tmpStr := '';
  for i := 1 to length(mmMiscDec.Text) do
  begin
    j := ord(mmMiscDec.Text[i]);
    inc(j, seIncrementStep.AsInteger);
    tmpStr := tmpStr + widechar(j);
  end;
  mmMiscDec.Text := tmpStr;
end;

procedure TfrmMain.btDecreaseClick(Sender: TObject);
var
  i, j: integer;
  tmpStr: widestring;
begin
  tmpStr := '';
  for i := 1 to length(mmMiscDec.Text) do
  begin
    j := ord(mmMiscDec.Text[i]);
    dec(j, seIncrementStep.AsInteger);
    tmpStr := tmpStr + widechar(j);
  end;
  mmMiscDec.Text := tmpStr;
end;

procedure TfrmMain.btUCS2ToHexClick(Sender: TObject);
begin
  if edDelimiter.Text <> '' then
    mmMiscDec.Text := uni2byte(trim(mmMiscDec.Text), edDelimiter.Text)
  else
    mmMiscDec.Text := uni2byte(trim(mmMiscDec.Text), '%u')
end;

procedure TfrmMain.btReplaceClick(Sender: TObject);
begin
  mmMiscDec.Text := StringReplace(mmMiscDec.Text, edSearch.Text, edReplace.Text,
    [rfReplaceAll]);
end;

procedure TfrmMain.btHexToFileClick(Sender: TObject);
var
  memStr: TMemoryStream;
  tmp: integer;
  i: integer;
begin
  SaveDialog1.FileName := 'hexfile.bin';
  SaveDialog1.DefaultExt := 'bin';
  if SaveDialog1.Execute then
  begin
    memStr := TMemoryStream.Create;
    i := 1;
    while i <= length(mmMiscDec.Text) do
    begin
      tmp := HexToInt(copy(mmMiscDec.Text, i, 2));
      memStr.Write(tmp, 1);
      inc(i, 2);
    end;
    memStr.SaveToFile(SaveDialog1.FileName);
    memStr.Free;
  end;
end;

procedure TfrmMain.btTextToFileClick(Sender: TObject);
begin
  SaveDialog1.FileName := 'textfile.txt';
  SaveDialog1.DefaultExt := 'txt';
  if SaveDialog1.Execute then
    mmMiscDec.Lines.SaveToFile(SaveDialog1.FileName);
end;

procedure TfrmMain.mmBrowserChange(Sender: TObject);
begin
  script_pos := 0;
  script_pos_object := 0;
end;

procedure TfrmMain.btMakeListClick(Sender: TObject);
var
  i: integer;
  cMin: integer;
  cMax: integer;
  j: integer;
  c: integer;
  cc: integer;
  countStr: string;
begin
  cMin := round(seMin.Value);
  cMax := round(seMax.Value);
  j := cMax - cMin;
  c := mmListMakerIn.Lines.Count - 1;
  for i := 0 to c do
  begin
    if mmListMakerIn.Lines[i] <> '' then
      for cc := 0 to j do
      begin
        countStr := IntToStr(cMin + cc);
        if cbPad.Checked then
          countStr := Padding(countStr, round(sePad.Value));
        if j <> 0 then
          mmListMakerOut.Lines.Add(StringReplace(mmListMakerIn.Lines[c],
            edFrom.Text,
            edWith.Text + countStr + edWithEnd.Text, [rfReplaceAll]))
        else
          mmListMakerOut.Lines.Add(StringReplace(mmListMakerIn.Lines[c],
            edFrom.Text,
            edWith.Text, [rfReplaceAll]))
      end;
  end;
end;

procedure TfrmMain.edURLKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key = vk_return then
  begin
    btGetThreaded.SetFocus;
    btGetThreaded.Click;
  end;
end;

procedure TfrmMain.btDecodeJSEncodeClick(Sender: TObject);
//http://archives.neohapsis.com/archives/fulldisclosure/2003-q3/3985.html
const
  itab: array[0..63] of byte =
  (
    $00, $02, $01, $00, $02, $01, $02, $01, $01, $02, $01, $02, $00, $01, $02,
    $01,
    $00, $01, $02, $01, $00, $00, $02, $01, $01, $02, $00, $01, $02, $01, $01,
    $02,
    $00, $00, $01, $02, $01, $02, $01, $00, $01, $00, $00, $02, $01, $00, $01,
    $02,
    $00, $01, $02, $01, $00, $00, $02, $01, $01, $00, $00, $02, $01, $00, $01,
    $02);
  {(1, 2, 0, 1, 2, 0, 2, 0, 0, 2, 0, 2, 1, 0, 2, 0, 1, 0, 2, 0, 1, 1, 2, 0,
   0, 2, 1, 0, 2, 0, 0, 2, 1, 1, 0, 2, 0, 2, 0, 1, 0, 1, 1, 2, 0, 1, 0, 2,
   1, 0, 2, 0, 1, 1, 2, 0, 0, 1, 1, 2, 0, 1, 0, 2);}

  dectab: array[0..2, 0..$7F] of byte = ({table to decrypt}
    ($00, $01, $02, $03, $04, $05, $06, $07, $08, $57, $0A, $0B, $0C, $0D, $0E,
    $0F,
    $10, $11, $12, $13, $14, $15, $16, $17, $18, $19, $1A, $1B, $1C, $1D, $1E,
    $1F,
    $2E, $47, $7A, $56, $42, $6A, $2F, $26, $49, $41, $34, $32, $5B, $76, $72,
    $43,
    $38, $39, $70, $45, $68, $71, $4F, $09, $62, $44, $23, $75, $3C, $7E, $3E,
    $5E,
    $FF, $77, $4A, $61, $5D, $22, $4B, $6F, $4E, $3B, $4C, $50, $67, $2A, $7D,
    $74,
    $54, $2B, $2D, $2C, $30, $6E, $6B, $66, $35, $25, $21, $64, $4D, $52, $63,
    $3F,
    $7B, $78, $29, $28, $73, $59, $33, $7F, $6D, $55, $53, $7C, $3A, $5F, $65,
    $46,
    $58, $31, $69, $6C, $5A, $48, $27, $5C, $3D, $24, $79, $37, $60, $51, $20,
    $36),

    ($00, $01, $02, $03, $04, $05, $06, $07, $08, $7B, $0A, $0B, $0C, $0D, $0E,
    $0F,
    $10, $11, $12, $13, $14, $15, $16, $17, $18, $19, $1A, $1B, $1C, $1D, $1E,
    $1F,
    $32, $30, $21, $29, $5B, $38, $33, $3D, $58, $3A, $35, $65, $39, $5C, $56,
    $73,
    $66, $4E, $45, $6B, $62, $59, $78, $5E, $7D, $4A, $6D, $71, $3C, $60, $3E,
    $53,
    $FF, $42, $27, $48, $72, $75, $31, $37, $4D, $52, $22, $54, $6A, $47, $64,
    $2D,
    $20, $7F, $2E, $4C, $5D, $7E, $6C, $6F, $79, $74, $43, $26, $76, $25, $24,
    $2B,
    $28, $23, $41, $34, $09, $2A, $44, $3F, $77, $3B, $55, $69, $61, $63, $50,
    $67,
    $51, $49, $4F, $46, $68, $7C, $36, $70, $6E, $7A, $2F, $5F, $4B, $5A, $2C,
    $57),

    ($00, $01, $02, $03, $04, $05, $06, $07, $08, $6E, $0A, $0B, $0C, $06, $0E,
    $0F,
    $10, $11, $12, $13, $14, $15, $16, $17, $18, $19, $1A, $1B, $1C, $1D, $1E,
    $1F,
    $2D, $75, $52, $60, $71, $5E, $49, $5C, $62, $7D, $29, $36, $20, $7C, $7A,
    $7F,
    $6B, $63, $33, $2B, $68, $51, $66, $76, $31, $64, $54, $43, $3C, $3A, $3E,
    $7E,
    $FF, $45, $2C, $2A, $74, $27, $37, $44, $79, $59, $2F, $6F, $26, $72, $6A,
    $39,
    $7B, $3F, $38, $77, $67, $53, $47, $34, $78, $5D, $30, $23, $5A, $5B, $6C,
    $48,
    $55, $70, $69, $2E, $4C, $21, $24, $4E, $50, $09, $56, $73, $35, $61, $4B,
    $58,
    $3B, $57, $22, $6D, $4D, $25, $28, $46, $4A, $32, $41, $3D, $5F, $4F, $42,
    $65));

var
  pos1, res, res2: byte;
  tempStrW: string;
  tempStr: string;
  start, stop: integer;
  i: integer;
begin
  tempStr := (mmMiscDec.Text);
  start := pos('#@~^', tempStr);
  start := posEx('==', tempStr, start);
  start := start + 2;
  stop := pos('==^#~@', tempStr) - 6; // last 6 bytes are checksumm
  tempStrW := '';
  pos1 := 0;
  i := start;
  while i < stop do
  begin
    res := ord(tempStr[i]);
    if res < $80 then
    begin
      res2 := dectab[itab[pos1], res];
      if res2 = $FF then
      begin
        res := ord(tempStr[i + 1]);
        case res of
          $26: res2 := $0A;
          $23: res2 := $0D;
          $2A: res2 := $3E;
          $21: res2 := $3C;
          $24: res2 := $40;
        end;
        inc(i);
      end;
      tempStrW := tempStrW + chr(res2);
    end;
    pos1 := (pos1 + 1) mod 64;
    inc(i);
  end;
  mmMiscDec.Text := tempStrW;
end;

procedure TfrmMain.mnuLoadFromFileClick(Sender: TObject);
var
  cpnName: string;
begin
  cpnName := TSynMemo(PopUpMnu.PopupComponent).Name;
  GetOpenDialogParam(cpnName);
  OpenDialog2.FileName := '';
  if OpenDialog2.Execute then
  begin
    TSynMemo(PopUpMnu.PopupComponent).Lines.LoadFromFile(OpenDialog2.FileName);
    if cpnName = 'mmBrowser' then
      MPHexEditor2.LoadFromFile(OpenDialog2.FileName);
    SetOpenDialogParam(cpnName);
    GetMalzillaProject(cpnName);
  end;
end;

procedure TfrmMain.mnuSaveToFileClick(Sender: TObject);
var
  cpnName: string;
begin
  cpnName := TSynMemo(PopUpMnu.PopupComponent).Name;
  GetSaveDialogParam(cpnName);
  if SaveDialog1.Execute then
  begin
    if cbMalzillaProject.Checked then
      SetMalzillaProject(cpnName);
    TSynMemo(PopUpMnu.PopupComponent).Lines.SaveToFile(SaveDialog1.FileName);
    SetSaveDialogParam(cpnName);
  end;
end;

procedure TfrmMain.mnuHexCopyClipTextClick(Sender: TObject);
begin
  Clipboard.AsText := TMPHexEditor(PopUpMnuHex.PopupComponent).AsText;
end;

procedure TfrmMain.mnuHexCopyClipHexClick(Sender: TObject);
begin
  Clipboard.AsText := TMPHexEditor(PopUpMnuHex.PopupComponent).AsHex;
end;

procedure TfrmMain.mnuHexPasteClipTextClick(Sender: TObject);
begin
  TMPHexEditor(PopUpMnuHex.PopupComponent).AsText := Clipboard.AsText;
  //MPHexEditor1.AsText := Clipboard.AsText;
end;

procedure TfrmMain.mnuHexPasteClipHexClick(Sender: TObject);
begin
  TMPHexEditor(PopUpMnuHex.PopupComponent).AsHex := Clipboard.AsText;
end;

procedure TfrmMain.btClearURLHistClick(Sender: TObject);
begin
  edURL.Clear;
end;

procedure TfrmMain.mnuHexSaveClick(Sender: TObject);
begin
  SaveDialog1.FileName := 'Hex_view_file.bin';
  SaveDialog1.DefaultExt := 'bin';
  if SaveDialog1.Execute then
    TMPHexEditor(PopUpMnuHex.PopupComponent).SaveToFile(SaveDialog1.FileName);
end;

procedure TfrmMain.mnuHexLoadClick(Sender: TObject);
begin
  if OpenDialog2.Execute then
    TMPHexEditor(PopUpMnuHex.PopupComponent).LoadFromFile(OpenDialog2.FileName);
end;

procedure TfrmMain.mnuClearClick(Sender: TObject);
begin
  TSynMemo(PopUpMnu.PopupComponent).Clear;
  find_pos := 0;
end;

procedure TfrmMain.cbHighlightClick(Sender: TObject);
begin
  mmScript.Highlighter.Enabled := cbHighlight.Checked;
  mmResult.Highlighter.Enabled := cbHighlight.Checked;
  //mmResult.ShowHint := cbHighlight.Checked;
  mmBrowser.Highlighter.Enabled := cbHighlight.Checked;
end;

procedure TfrmMain.mnuWordWrapClick(Sender: TObject);
begin
  TSynMemo(PopUpMnu.PopupComponent).WordWrap := not
    TSynMemo(PopUpMnu.PopupComponent).WordWrap;
end;

procedure TfrmMain.PopUpMnuPopup(Sender: TObject);
begin
  mnuWordWrap.Checked := TSynMemo(PopUpMnu.PopupComponent).WordWrap;
  if (TSynMemo(PopUpMnu.PopupComponent).Name = 'mmBrowser')
    or (TSynMemo(PopUpMnu.PopupComponent).Name = 'mmScript')
    or (TSynMemo(PopUpMnu.PopupComponent).Name = 'mmMiscDec')
    or (TSynMemo(PopUpMnu.PopupComponent).Name = 'mmResult') then
  begin
    mnuLoadFromBuffer.Visible := True;
    mnuSaveToBuffer.Visible := True;
  end
  else
  begin
    mnuLoadFromBuffer.Visible := False;
    mnuSaveToBuffer.Visible := False;
  end;
  if TSynMemo(PopUpMnu.PopupComponent).CanUndo then
    mnuUndo.Enabled := True
  else
    mnuUndo.Enabled := False;
  if TSynMemo(PopUpMnu.PopupComponent).CanRedo then
    mnuRedo.Enabled := True
  else
    mnuRedo.Enabled := False;
end;

procedure TfrmMain.mnuTrayShowClick(Sender: TObject);
begin
  JvTrayIcon1.ShowApplication;
end;

procedure TfrmMain.mnuTrayHideClick(Sender: TObject);
begin
  JvTrayIcon1.HideApplication;
end;

procedure TfrmMain.mnuTrayCloseClick(Sender: TObject);
begin
  Close;
end;

procedure TfrmMain.hkClipboardMonitor1Change(Sender: TObject);
var
  posComma, i, j: integer;
  strLine: string;
  strFrom, strTo: string;
  downList: TStringList;
begin
  downList := TStringList.Create;
  //downList.Sorted := True;
  downList.Duplicates := dupIgnore;
  //my_clipboard := 0;
  with Clipboard do
  begin
    if (FormatCount <> 0) and HasFormat(CF_TEXT) then
      //if my_clipboard <> 1 then
    begin
      downList.Text := AsText;
      for j := 0 to downList.Count - 1 do
        for i := 0 to mmClipMonTrig.Lines.Count - 1 do
        begin
          strLine := mmClipMonTrig.Lines[i];
          posComma := pos(';', strLine);
          if posComma > 0 then
          begin
            strFrom := copy(strLine, 1, posComma - 1);
            strTo := copy(strLine, posComma + 1, length(strLine));
            if AnsiStartsText(strFrom, downList[j]) then
            begin
              downList[j] := StringReplace(downList[j], strFrom, strTo, []);
              if mnuTrayClipMonitorList.Checked then
                mmListDownloaderPending.Items.Add(downList[j]);
              //Clipboard.Clear;
              Flash;
            end;
          end;
        end;
      //my_clipboard := 0;
    end;
  end;
  downList.Free;
end;

procedure TfrmMain.JvTrayIcon1DblClick(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  if IsWindowVisible(Handle) then
  begin
    JvTrayIcon1.HideApplication;
  end
  else
  begin
    JvTrayIcon1.ShowApplication;
  end;
end;

procedure TfrmMain.cbHexUnicodeClick(Sender: TObject);
begin
  try
    MPHexEditor1.UnicodeChars := cbHexUnicode.Checked;
  except
    on e: exception do
    begin
      WideShowMessage('Odd-byte file size, cannot be Unicode');
      cbHexUnicode.Checked := MPHexEditor1.UnicodeChars;
    end;
  end;
end;

procedure TfrmMain.cbHexUnicodeBigClick(Sender: TObject);
begin
  MPHexEditor1.UnicodeBigEndian := cbHexUnicodeBig.Checked;
end;

procedure TfrmMain.cbHexSwapNibblesClick(Sender: TObject);
begin
  MPHexEditor1.SwapNibbles := cbHexSwapNIbbles.Checked;
end;

procedure TfrmMain.mnuTrayClipMonitorListClick(Sender: TObject);
begin
  mnuTrayClipMonitorList.Checked := not mnuTrayClipMonitorList.Checked;
  hkClipboardMonitor1.Enabled := mnuTrayClipMonitorList.Checked;
  //if hkClipboardMonitor1.Enabled then
  //  Clipboard.Clear;
end;

procedure TfrmMain.btFindClick(Sender: TObject);
var
  found: integer;
begin
  if length(edFind.Text) > 0 then
  begin
    if cbCaseSensitive.Checked then
      found := PosEx(edFind.Text, mmBrowser.Text, find_pos + 1)
    else
      found := posEx(LowerCase(edFind.Text), LowerCase(mmBrowser.Text), find_pos
        + 1);
    if found > 0 then
    begin
      mmBrowser.SelStart := found - 1;
      mmBrowser.SelLength := length(edFind.Text);
      find_pos := found;
      stbrStatusDownload.SimpleText := '';
    end
    else
    begin
      find_pos := 0;
      stbrStatusDownload.SimpleText := 'String not found';
    end;
  end;
end;

procedure TfrmMain.edFindChange(Sender: TObject);
begin
  find_pos := 0;
end;

procedure TfrmMain.btGetThreadedClick(Sender: TObject);
var
  downThread: TDownloadThread;
  FTPThread: TFTPThread;
  validHTTPURL: Boolean;
begin
  cancelOP := False;
  validHTTPURL := true;
  if not (ssShift in GetShiftState) then
    edURL.Text := trim(edURL.Text);

  if edURL.Text <> '' then
  begin
    if AnsiStartsText('ftp://', edURL.Text) then
      validHTTPURL := false;
    //if AnsiStartsText('https://', edURL.Text) then
    //  validHTTPURL := false;

    if validHTTPURL then
    begin
      AddToLog('====================', nil);
      AddToLog('Download parameters:', nil);
      AddToLog(' ', nil);
      AddToLog('  URL: ' + edURL.Text, nil);
      AddToLog('  User Agent:  ' + comboUserAgent.Text, nil);
      AddToLog('  Referrer:  ' + edReferrer.Text, nil);
      AddToLog('  Cookies:  ' + edCookies.Text, nil);
      AddToLog(' ', nil);
      downThread := TDownloadThread.Create(true);
      downThread.FreeOnTerminate := True;
      find_pos := 0;
      bar_selected := false;
      edUrl.SelStart := 0;
      edUrl.SelLength := 0;
      if cbURLHistory.Checked then
      begin
        if edURL.Items.IndexOf(edURL.Text) = -1 then
          edURL.Items.Insert(0, edURL.Text)
        else
          edURL.Items.Move(edURL.Items.IndexOf(edURL.Text), 0);
        edURL.ItemIndex := 0;
      end;
      stbrStatusDownload.SimpleText := 'Working...';
      mmBrowser.Clear;
      mmHTTP.Clear;
      mmCookies.Clear;
      MPHexEditor2.AsText := '';
      mmHTMLRemote.Clear;
      mmIFrames.Clear;

      //downThread.swListDownloader := False;
      downThread.tURL := edURL.Text;
      downThread.tAppFolder := ExtractFilePath(application.exename);
      downThread.tCacheFolder := ExtractFilePath(application.ExeName) +
        'Cache\';
      if cbUseProxy.Checked and (edProxyAddress.Text <> '') and (edProxyPort.Text
        <> '') then
      begin
        downThread.tProxyAddress := edProxyAddress.Text;
        downThread.tProxyPort := edProxyPort.Text;
        downThread.tUseProxy := true;
        if edProxyUser.Text <> '' then
        begin
          downThread.tProxyUserName := edProxyUser.Text;
          downThread.tProxyPassword := edProxyPass.Text;
        end;
      end;
      if cbUseReferrer.Checked and (edReferrer.Text <> '') then
        downThread.tReferrer := edReferrer.Text;
      if cbUseCookies.Checked and (edCookies.Text <> '') then
        downThread.tCookies := edCookies.Text;
      if cbUserAgent.Checked and (comboUserAgent.Text <> '') then
      begin
        downThread.tUserAgent := comboUserAgent.Text;
        downThread.tUseUserAgent := true;
      end
      else
        downThread.tUseUserAgent := false;
      if cbUseExtendedInfo.Checked then
        downThread.tUseExtendedInfo := True;
      downThread.Resume;
    end
    else
    begin
      AddToLog('====================', nil);
      AddToLog('Download parameters:', nil);
      AddToLog(' ', nil);
      AddToLog('  URL: ' + edURL.Text, nil);
      AddToLog(' ', nil);
      FTPThread := TFTPThread.Create(true);
      FTPThread.FreeOnTerminate := True;
      if (ssCtrl in GetShiftState) then
        FTPThread.tCMDList := True
      else
        FTPThread.tCMDList := False;
      FTPThread.tAppFolder := ExtractFilePath(application.exename);
      FTPThread.tCacheFolder := ExtractFilePath(application.ExeName) +
        'Cache\';
      find_pos := 0;
      bar_selected := false;
      edUrl.SelStart := 0;
      edUrl.SelLength := 0;
      if cbURLHistory.Checked then
      begin
        if edURL.Items.IndexOf(edURL.Text) = -1 then
          edURL.Items.Insert(0, edURL.Text)
        else
          edURL.Items.Move(edURL.Items.IndexOf(edURL.Text), 0);
        edURL.ItemIndex := 0;
      end;
      stbrStatusDownload.SimpleText := 'Working...';
      mmBrowser.Clear;
      mmHTTP.Clear;
      mmCookies.Clear;
      MPHexEditor2.AsText := '';
      mmHTMLRemote.Clear;
      mmIFrames.Clear;
      FTPThread.tURL := edURL.Text;
      FTPThread.Resume;
    end;
    cancelOP := False;
    if cbAutoParseLinksOnGET.Checked then
      btSendToHTMLParser.Click;
    stbrStatusDownload.SimpleText := '';
    script_pos := 0;
    script_pos_object := 0;
  end;
end;

procedure TfrmMain.btAbortClick(Sender: TObject);
begin
  CancelOP := true;
end;

procedure TfrmMain.btLoadFromCacheClick(Sender: TObject);
begin
  frmCacheList.appFolder := ExtractFilePath(application.exename);
  frmCacheList.Show;
end;

procedure TfrmMain.btClearCacheClick(Sender: TObject);
var
  sl: TStringList;
  i: integer;
begin
  cacheMD5.Clear;
  cacheURL.Clear;
  cacheDate.Clear;
  cacheOther.Clear;
  cacheMD5.SaveToFile(ExtractFilePath(application.exename) + 'CacheMD5.dat');
  cacheURL.SaveToFile(ExtractFilePath(application.exename) + 'CacheURL.dat');
  cacheDate.SaveToFile(ExtractFilePath(application.exename) + 'CacheDate.dat');
  cacheOther.SaveToFile(ExtractFilePath(application.exename) +
    'CacheOther.dat');
  sl := TStringList.Create;
  try
    FindFiles(ExtractFilePath(application.exename) + 'Cache\', faDirectory or
      faAnyFile, 0, false, sl);
    for i := 0 to sl.Count - 1 do
      DeleteFile(sl[i]);
  finally
    sl.Free;
  end;
  sl := TStringList.Create;
  try
    FindFiles(ExtractFilePath(application.exename) + 'Decoder_Cache\',
      faDirectory or
      faAnyFile, 0, false, sl);
    for i := 0 to sl.Count - 1 do
      DeleteFile(sl[i]);
  finally
    sl.Free;
  end;
end;

procedure TfrmMain.FormShow(Sender: TObject);
begin
  if not ((cacheURL.Count = cacheMD5.Count) and (cacheMD5.Count =
    cacheDate.Count)) then
  begin
    WideShowMessage('Cache index is corrupted. Please save your files and clear the cache');
    PageControl1.ActivePage := tsSettings;
    btClearCache.SetFocus;
  end;
end;

procedure TfrmMain.edFindKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key = vk_return then
  begin
    btFind.Click;
  end;
end;

procedure TfrmMain.mmListDownloaderPendingExit(Sender: TObject);
begin
  LisTTntEdit.Visible := false;
end;

procedure TfrmMain.mmListDownloaderPendingDblClick(Sender: TObject);
var
  ii: integer;
  lRect: TRect;
begin
  ii := mmListDownloaderPending.ItemIndex;
  if ii = -1 then
    exit;
  lRect := mmListDownloaderPending.ItemRect(ii);
  LisTTntEdit.Top := lRect.Top + 1;
  LisTTntEdit.Left := lRect.Left + 1;
  LisTTntEdit.Height := (lRect.Bottom - lRect.Top) + 1;

  LisTTntEdit.Text := mmListDownloaderPending.Items.Strings[ii];
  //mmListDownloaderPending.Selected[ii] := False;
  DownloaderBoxItemIndex := ii;
  LisTTntEdit.Visible := True;
  //my_clipboard := LisTTntEdit.Text;
  //my_clipboard := 1;
  //LisTTntEdit.SelectAll;
  //LisTTntEdit.SetFocus;
end;

procedure TfrmMain.Button1Click(Sender: TObject);
begin
  if mmListDownloaderPending.Items.Count > 0 then
  begin
    edURL.Text := mmListDownloaderPending.Items[0];
    mmListDownloaderFinished.Lines.Add(mmListDownloaderPending.Items[0]);
    mmListDownloaderPending.Items.Delete(0);
    stbrListDownloader.SimpleText := 'Item sent to Downloader tab';
  end;
end;

procedure TfrmMain.Button2Click(Sender: TObject);
begin
  if mmListDownloaderPending.Items.Count > 0 then
  begin
    edURL.Text := mmListDownloaderPending.Items[0];
    mmListDownloaderFinished.Lines.Add(mmListDownloaderPending.Items[0]);
    mmListDownloaderPending.Items.Delete(0);
    stbrListDownloader.SimpleText := 'Item sent to Downloader tab';
    btGetThreaded.Click;
  end;
end;

procedure TfrmMain.btSendToHTMLParserClick(Sender: TObject);
var
  URIbase: string;
  Parser: THyperParse;
  i: Integer;
begin
  mmHTMLRemote.Clear;
  URIbase := '';
  Parser := THyperParse.Create;
  Parser.FileName := mmBrowser.Text;
  Parser.Execute;
  for i := 0 to Parser.Count - 1 do
  begin
    if Parser[i].IsTag = true then
    begin
      if LowerCase(Parser[i].TagName) = 'base' then
        URIbase := Parser[i].FindParamValue('href');
      if LowerCase(Parser[i].TagName) = 'iframe' then
        mmIFrames.Lines.Add(Parser[i].Text);
    end;
  end;
  Parser.Free;
  if URIbase = '' then
  begin
    URIbase := edURL.Text;
    Label22.Caption := 'URI base (not detected):';
  end
  else
    Label22.Caption := 'URI base (detected):';
  edURIBase.Text := URIbase;
  HREFParser1.Document.HTML.Clear;
  HREFParser1.Document.HTML.Add(mmBrowser.Text);
  HREFParser1.Document.Parse;
end;

procedure TfrmMain.Slot12Click(Sender: TObject);
begin
  bufSlot1 := TSynMemo(PopUpMnu.PopupComponent).Text;
  Slot12.Caption := 'Slot 1 (loaded)';
  Slot11.Caption := 'Slot 1 (loaded)';
end;

procedure TfrmMain.Slot22Click(Sender: TObject);
begin
  bufSlot2 := TSynMemo(PopUpMnu.PopupComponent).Text;
  Slot22.Caption := 'Slot 2 (loaded)';
  Slot21.Caption := 'Slot 2 (loaded)';
end;

procedure TfrmMain.Slot32Click(Sender: TObject);
begin
  bufSlot3 := TSynMemo(PopUpMnu.PopupComponent).Text;
  Slot32.Caption := 'Slot 3 (loaded)';
  Slot31.Caption := 'Slot 3 (loaded)';
end;

procedure TfrmMain.Slot42Click(Sender: TObject);
begin
  bufSlot4 := TSynMemo(PopUpMnu.PopupComponent).Text;
  Slot42.Caption := 'Slot 4 (loaded)';
  Slot41.Caption := 'Slot 4 (loaded)';
end;

procedure TfrmMain.Slot52Click(Sender: TObject);
begin
  bufSlot5 := TSynMemo(PopUpMnu.PopupComponent).Text;
  Slot52.Caption := 'Slot 5 (loaded)';
  Slot51.Caption := 'Slot 5 (loaded)';
end;

procedure TfrmMain.Slot11Click(Sender: TObject);
begin
  if bufSlot1 <> '' then
    TSynMemo(PopUpMnu.PopupComponent).Text := bufSlot1;
end;

procedure TfrmMain.Slot21Click(Sender: TObject);
begin
  if bufSlot2 <> '' then
    TSynMemo(PopUpMnu.PopupComponent).Text := bufSlot2;
end;

procedure TfrmMain.Slot31Click(Sender: TObject);
begin
  if bufSlot3 <> '' then
    TSynMemo(PopUpMnu.PopupComponent).Text := bufSlot3;
end;

procedure TfrmMain.Slot41Click(Sender: TObject);
begin
  if bufSlot4 <> '' then
    TSynMemo(PopUpMnu.PopupComponent).Text := bufSlot4;
end;

procedure TfrmMain.Slot51Click(Sender: TObject);
begin
  if bufSlot5 <> '' then
    TSynMemo(PopUpMnu.PopupComponent).Text := bufSlot5;
end;

procedure TfrmMain.HREFParser1FoundHyperlink(Sender: TObject;
  Hyperlink: string);
var
  sURL: string;
begin
  sURL := Trim(Hyperlink);
  sURL := BuildURL(edURIBase.Text, sURL);
  mmHTMLRemote.Lines.Add(sURL);
end;

procedure TfrmMain.mmScriptMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
var
  temp_str: WideString;
begin
  temp_str := Copy(mmScript.Text, mmScript.SelStart + 1, mmScript.SelLength);
  temp_str := StringReplace(temp_str, ' ', '', [rfReplaceAll]);
  Label24.Caption := 'Selection length: ' + IntToStr(mmScript.SelLength) + ' ('
    + IntToStr(Length(temp_str)) + ')';
end;

procedure TfrmMain.btCompilePScriptClick(Sender: TObject);
  procedure OutputMessages;
  var
    l: Longint;
    b: Boolean;
  begin
    b := False;

    for l := 0 to PSScript1.CompilerMessageCount - 1 do
    begin
      mmPScriptDebug.Lines.Add('Compiler: ' + PSScript1.CompilerErrorToStr(l));
      if (not b) and (PSScript1.CompilerMessages[l] is TIFPSPascalCompilerError)
        then
      begin
        b := True;
        mmPScriptEditor.SelStart := PSScript1.CompilerMessages[l].Pos;
      end;
    end;
  end;
begin
  mmPScriptDebug.Lines.Clear;
  PSScript1.Script.Assign(mmPScriptEditor.Lines);
  mmPScriptDebug.Lines.Add('Compiling');
  if PSScript1.Compile then
  begin
    OutputMessages;
    mmPScriptDebug.Lines.Add('Compiled succesfully');
    if not PSScript1.Execute then
    begin
      mmPScriptEditor.SelStart := PSScript1.ExecErrorPosition;
      mmPScriptDebug.Lines.Add(PSScript1.ExecErrorToString + ' at ' +
        Inttostr(PSScript1.ExecErrorProcNo) + '.' +
        Inttostr(PSScript1.ExecErrorByteCodePosition));
    end
    else
      mmPScriptDebug.Lines.Add('Succesfully executed');
  end
  else
  begin
    OutputMessages;
    mmPScriptDebug.Lines.Add('Compiling failed');
  end;
end;

procedure TfrmMain.PSScript1Compile(Sender: TPSScript);
begin
  Sender.AddFunction(@WriteDoc, 'function WriteDoc(s: string): boolean;');
  Sender.AddFunction(@ReadDoc, 'function ReadDoc: string;');
end;

procedure TfrmMain.mmListDownloaderPendingKeyUp(Sender: TObject;
  var Key: Word; Shift: TShiftState);
var
  i: Integer;
begin
  if Key = vk_return then
  begin
    if mmListDownloaderPending.ItemIndex <> -1 then
    begin
      edURL.Text :=
        mmListDownloaderPending.Items[mmListDownloaderPending.ItemIndex];
      edURL.SelectAll;
    end;
  end
  else if Key = vk_delete then
  begin
    if mmListDownloaderPending.ItemIndex <> -1 then
    begin
      i := 0;
      while i < mmListDownloaderPending.Items.Count do
      begin
        if mmListDownloaderPending.Selected[i] then
        begin
          mmListDownloaderFinished.Lines.Add(mmListDownloaderPending.Items[i]);
          mmListDownloaderPending.Items.Delete(i);
        end
        else
          Inc(i);
      end;
    end;
  end;
end;

procedure TfrmMain.btTemplatedListMakerGOClick(Sender: TObject);
var
  i, j: Integer;
begin
  for i := 0 to mmTemplatedListMakerIn.Lines.Count - 1 do
  begin
    for j := 0 to mmTemplatedListMakerTemplate.Lines.Count - 1 do
    begin
      if (mmTemplatedListMakerIn.Lines[i] <> '') and
        (mmTemplatedListMakerTemplate.Lines[j] <> '') then
        mmTemplatedListMakerOut.Lines.Add(mmTemplatedListMakerIn.Lines[i]
          + mmTemplatedListMakerTemplate.Lines[j]);
    end;
  end;
end;

procedure TfrmMain.btAbortDownloadAllClick(Sender: TObject);
begin
  cancelOP := True;
end;

procedure TfrmMain.btListDownloadThreadedClick(Sender: TObject);
var
  downThread: TListDownloaderThread;

begin
  if JvSelectDirectory1.Execute then
  begin
    cancelOP := False;
    JvSelectDirectory1.Title := 'Select where to save files';
    bar_selected := false;
    stbrListDownloader.SimpleText := 'Working...';

    downThread := TListDownloaderThread.Create(true);
    downThread.FreeOnTerminate := true;
    downThread.tList := TStringList.Create;
    downThread.tList.AddStrings(mmListDownloaderPending.Items);

    find_pos := 0;
    bar_selected := False;
    mmBrowser.Clear;
    mmHTTP.Clear;
    downThread.tListDownloaderFolder := JvSelectDirectory1.Directory;
    if cbUseProxy.Checked and (edProxyAddress.Text <> '') and
      (edProxyPort.Text
      <> '') then
    begin
      downThread.tProxyAddress := edProxyAddress.Text;
      downThread.tProxyPort := edProxyPort.Text;
      downThread.tUseProxy := true;
      if edProxyUser.Text <> '' then
      begin
        downThread.tProxyUserName := edProxyUser.Text;
        downThread.tProxyPassword := edProxyPass.Text;
      end;
    end;
    if edReferrer.Text <> '' then
      downThread.tReferrer := edReferrer.Text;
    if cbUserAgent.Checked and (comboUserAgent.Text <> '') then
    begin
      downThread.tUserAgent := comboUserAgent.Text;
      downThread.tUseUserAgent := true;
    end
    else
      downThread.tUseUserAgent := false;
    downThread.Resume;
  end;
end;

procedure TfrmMain.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
var
  Ini: TIniFile;
begin
  if not Busy then
  begin
    if cbClearCacheOnExit.Checked then
      btClearCache.Click;
    if cbClearHistoryOnExit.Checked then
      btClearURLHist.Click;
    edURL.Items.SaveToFile(ExtractFilePath(application.exename) +
      'URL_history.txt');
    mmUserAgentsEditor.Lines.SaveToFile(ExtractFilePath(application.exename) +
      'User_agents.txt');
    mmClipMonTrig.Lines.SaveToFile(ExtractFilePath(application.exename) +
      'HTTP_triggers.txt');
    Ini := TIniFile.Create(ExtractFilePath(application.exename) +
      'Settings.txt');
    try
      Ini.WriteBool('Downloader', 'UseUserAgent', cbUserAgent.Checked);
      Ini.WriteString('Downloader', 'UserAgentString', comboUserAgent.Text);
      Ini.WriteBool('Downloader', 'UseProxy', cbUseProxy.Checked);
      Ini.WriteBool('Downloader', 'UseCookies', cbUseCookies.Checked);
      Ini.WriteBool('Downloader', 'UseReferrer', cbUseReferrer.Checked);
      Ini.WriteBool('Downloader', 'AutoRedirect', cbAutoRedirect.Checked);
      Ini.WriteBool('Downloader', 'AutoReferrer', cbAutoReferrer.Checked);
      Ini.WriteBool('Downloader', 'AutoParseLinks',
        cbAutoParseLinksOnGET.Checked);
      Ini.WriteBool('Downloader', 'SaveAsProject', cbMalzillaProject.Checked);
      Ini.WriteBool('Downloader', 'AutoComplete', cbAutoCompleteURL.Checked);
      Ini.WriteBool('Downloader', 'URLHistory', cbURLHistory.Checked);
      Ini.WriteBool('Downloader', 'ExtendedInfo', cbUseExtendedInfo.Checked);
      Ini.WriteBool('Proxy', 'Hidden', cbHideProxyData.Checked);
      Ini.WriteString('Proxy', 'Address', edProxyAddress.Text);
      Ini.WriteString('Proxy', 'Port', edProxyPort.Text);
      if not cbHideProxyData.Checked then
      begin
        Ini.WriteString('Proxy', 'User', edProxyUser.Text);
        Ini.WriteString('Proxy', 'Pass', edProxyPass.Text);
      end;
      Ini.WriteBool('Monitor', 'Multi', mnuTrayClipMonitorList.Checked);
      Ini.WriteBool('Misc', 'ClearClipboard', cbClipBoardClear.Checked);
      Ini.WriteBool('Misc', 'ClearCache', cbClearCacheOnExit.Checked);
      Ini.WriteBool('Misc', 'ClearHistory', cbClearHistoryOnExit.Checked);
      Ini.WriteBool('Decoder', 'ReplaceEval', cbReplaceEval.Checked);
      Ini.WriteString('Decoder', 'ReplaceEvalWith', edReplaceEval.Text);
      Ini.WriteBool('Decoder', 'OverrideEval', cbOverrideEval.Checked);
      Ini.WriteBool('Decoder', 'AutoReplaceEval', cbDontBotherMe.Checked);
      Ini.WriteBool('Display', 'Highlight', cbHighlight.Checked);
      Ini.WriteString('Display', 'FontName', frmMain.Font.Name);
      Ini.WriteInteger('Display', 'FontSize', frmMain.Font.Size);
      Ini.WriteBool('Display', 'AutoFocusDecoder', cbAutoFocusDecoder.Checked);
    finally
      Ini.Free;
    end;
    cacheMD5.SaveToFile(ExtractFilePath(application.exename) + 'CacheMD5.dat');
    cacheURL.SaveToFile(ExtractFilePath(application.exename) + 'CacheURL.dat');
    cacheDate.SaveToFile(ExtractFilePath(application.exename) +
      'CacheDate.dat');
    cacheOther.SaveToFile(ExtractFilePath(application.exename) +
      'CacheOther.dat');
  end
  else
  begin
    if MessageDlg('Malzilla is busy' + #13#10 + 'Do you really want to quit?',
      mtConfirmation, [mbOk, mbCancel], 0) = mrCancel then
      CanClose := False;
  end;
end;

procedure TfrmMain.btCheckUpdateClick(Sender: TObject);
var
  HTTP: THTTPSend;
  buff: string;
  ver: extended;
begin
  HTTP := THTTPSend.Create;
  try
    if cbUseProxy.Checked and (edProxyAddress.Text <> '') and
      (edProxyPort.Text <> '') then
    begin
      HTTP.ProxyHost := edProxyAddress.Text;
      HTTP.ProxyPort := edProxyPort.Text;
      if edProxyUser.Text <> '' then
      begin
        HTTP.ProxyUser := edProxyUser.Text;
        HTTP.ProxyPass := edProxyPass.Text;
      end;
    end;
    if edReferrer.Text <> '' then
      HTTP.Headers.Add('Referer: ' + edReferrer.Text);
    if cbUserAgent.Checked and (comboUserAgent.Text <> '') then
      HTTP.UserAgent := comboUserAgent.Text;
    if HTTP.HTTPMethod('GET', 'http://malzilla.sourceforge.net/version') then
    begin
      SetLength(buff, HTTP.Document.Size);
      HTTP.Document.Read(buff[1], HTTP.Document.Size);
      ver := StrToFloatDef(buff, 0);
      if ver > current_version then
        WideShowMessage('Newer version is available (' + buff + ')')
      else if ver < current_version then
        WideShowMessage('You seems to know bobby, as you have some unofficial test version :)')
      else if ver = current_version then
        WideShowMessage('You have the newest version (' + buff + ')');
    end;
  finally
    HTTP.Free;
  end;
end;

procedure TfrmMain.mmScriptPaintTransient(Sender: TObject; Canvas: TCanvas;
  TransientType: TTransientType);
const
  Tokens: array[0..2] of TSynTokenMatch = (
    (OpenToken: '('; CloseToken: ')'; TokenKind: Integer(stkEsSymbol)),
    (OpenToken: '{'; CloseToken: '}'; TokenKind: Integer(stkEsSymbol)),
    (OpenToken: '['; CloseToken: ']'; TokenKind: Integer(stkEsSymbol)));

var
  Editor: TSynEdit;
  Pix: TPoint;
  Match: TSynTokenMatched;
  I: Integer;

  function CharToPixels(P: TBufferCoord): TPoint;
  begin
    Result := Editor.RowColumnToPixels(Editor.BufferToDisplayPos(P));
  end;

  function TryMatch: Integer;
  begin
    Result := SynEditGetMatchingTagEx(Editor, Editor.CaretXY, Match);
    if Result = 0 then
      Result := SynEditGetMatchingTokenEx(Editor, Editor.CaretXY, Tokens,
        Match);
  end;

begin
  if mmScript.Enabled then
    if FPaintUpdating then
      Exit;
  Editor := TSynEdit(Sender);
  if TransientType = ttBefore then
  begin
    I := TryMatch;
    if I = 0 then
      Exit;
    FPaintUpdating := True;
    if I <> -1 then
      Editor.InvalidateLines(Match.OpenTokenPos.Line, Match.OpenTokenPos.Line);
    if I <> 1 then
      Editor.InvalidateLines(Match.CloseTokenPos.Line,
        Match.CloseTokenPos.Line);
    FPaintUpdating := False;
    Exit;
  end;
  if Editor.SelAvail then
    Exit;
  I := TryMatch;
  if I = 0 then
    Exit;
  Canvas.Brush.Style := bsSolid;
  if Abs(I) = 2 then
    Canvas.Brush.Color := clAqua // matched color
  else
    Canvas.Brush.Color := clYellow; // unmatched color
  if I <> -1 then
  begin
    Pix := CharToPixels(Match.OpenTokenPos);
    Canvas.Font.Color := Editor.Font.Color;
    Canvas.Font.Style := Match.TokenAttri.Style;
    Canvas.TextOut(Pix.X, Pix.Y, Match.OpenToken);
  end;
  if I <> 1 then
  begin
    Pix := CharToPixels(Match.CloseTokenPos);
    Canvas.Font.Color := Editor.Font.Color;
    Canvas.Font.Style := Match.TokenAttri.Style;
    Canvas.TextOut(Pix.X, Pix.Y, Match.CloseToken);
  end;
end;

procedure TfrmMain.mnuSaveDownloadHexClick(Sender: TObject);
begin
  SaveDialog1.FileName := 'Hex_view_file.bin';
  SaveDialog1.DefaultExt := 'bin';
  if SaveDialog1.Execute then
    MPHexEditor2.SaveToFile(SaveDialog1.FileName);
end;

procedure TfrmMain.btFind2Click(Sender: TObject);
var
  found: integer;
begin
  if length(edFind2.Text) > 0 then
  begin
    if cbCaseSensitive2.Checked then
      found := PosEx(edFind2.Text, mmScript.Text, find_pos2 + 1)
    else
      found := posEx(LowerCase(edFind2.Text), LowerCase(mmScript.Text), find_pos2
        + 1);
    if found > 0 then
    begin
      mmScript.SelStart := found - 1;
      mmScript.SelLength := length(edFind2.Text);
      find_pos2 := found;
      stbrStatus.SimpleText := '';
    end
    else
    begin
      find_pos2 := 0;
      stbrStatus.SimpleText := 'String not found';
    end;
  end;
end;

procedure TfrmMain.edFind2KeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key = vk_return then
  begin
    btFind2.Click;
  end;
end;

procedure TfrmMain.edFind2Change(Sender: TObject);
begin
  find_pos2 := 0;
end;

procedure TfrmMain.btDebugClick(Sender: TObject);
var
  DecoderThread: TJSBrowserProxy;
  script_buff: WideString;
begin
  if mmScript.Text <> '' then
  begin
    Busy := True;
    mmResult.Lines.BeginUpdate;
    mmResult.WordWrap := False;
    btRunScript.Enabled := False;
    btDebug.Enabled := False;
    AddToLog('====================', nil);
    AddToLog('Decoder:', nil);
    if pos('arguments.callee.toString(', mmScript.Text) > 0 then
    begin
      if WideMessageDlg('Script contains arguments.callee.toString() function.'
        +
        #13#10 +
        'Please referr to the tutorial on Malzilla''s website on how to replace this function',
        mtConfirmation, [mbAbort, mbIgnore], 0) =
        mrAbort then
        Exit;
    end;
    stbrStatus.SimpleText := 'Working...';
    mmResult.Clear;

    DecoderThread := TJSBrowserProxy.Create(true);
    DecoderThread.FreeOnTerminate := True;
    DecoderThread.tEvalReplace := False;
    DecoderThread.tExeFolder := ExtractFilePath(Application.ExeName);

    script_buff := mmScript.Text;
    if cbReplaceEval.Checked and (edReplaceEval.Text <> '') then
    begin
      if pos('eval', mmScript.Text) > 0 then
      begin
        if cbDontBotherMe.Checked then
        begin
          script_buff := StringReplace(mmScript.Text, 'eval',
            edReplaceEval.Text,
            [rfReplaceAll]);
          DecoderThread.tEval := edReplaceEval.Text;
          DecoderThread.tEvalReplace := True;
          AddToLog('  Automatically replace eval() with ' + edReplaceEval.Text,
            nil);
        end
        else
        begin
          if WideMessageDlg('Script contains eval() function.' + #13#10 +
            'Replace with ' + edReplaceEval.Text + '() ?', mtConfirmation,
            [mbYes,
            mbNo], 0) =
            mrYes then
          begin
            script_buff := StringReplace(mmScript.Text, 'eval',
              edReplaceEval.Text, [rfReplaceAll]);

            DecoderThread.tEval := edReplaceEval.Text;
            DecoderThread.tEvalReplace := True;
            AddToLog('  Replace eval() with ' + edReplaceEval.Text, nil);
          end
          else
            script_buff := mmScript.Text;
        end;
      end;
    end;
    if cbOverrideEval.Checked then
    begin
      if pos('eval', mmScript.Text) > 0 then
      begin
        if cbDontBotherMe.Checked then
        begin
          script_buff := 'function eval(a) {document.write(a)};' + #13#10 +
            mmScript.Text;
          AddToLog('  Automatically override eval()', nil);
        end
        else
        begin
          if WideMessageDlg('Script contains eval() function.' + #13#10 +
            'Override it?', mtConfirmation,
            [mbYes,
            mbNo], 0) =
            mrYes then
          begin
            script_buff := 'function eval(a) {document.write(a)};' + #13#10 +
              mmScript.Text;
            AddToLog('  Override eval()', nil);
          end
          else
            script_buff := mmScript.Text;
        end;
      end;
    end;

    DecoderThread.tScript := script_buff;
    DecoderThread.tDebug := True;
    DecoderThread.tEvalFolder := ExtractFilePath(Application.ExeName) +
      '\eval_temp\';
    DecoderThread.Resume;
  end;
end;

procedure TfrmMain.edURLDblClick(Sender: TObject);
begin
  if not bar_selected then
  begin
    edURL.SelectAll;
    bar_selected := true;
  end;
end;

procedure TfrmMain.mnuNewDownloaderTabClick(Sender: TObject);
begin
  AddDownloaderTab;
  tbDownloaderTabs.Tabs.Add('New Tab (' + IntToStr(DownloaderTabNr) +
    ')');
  //tbDownloaderTabs.TabIndex := tbDownloaderTabs.Tabs.Count -1;
end;

procedure TfrmMain.tbDownloaderTabsChange(Sender: TObject);
begin
  ShowDownloaderTab(tbDownloaderTabs.TabIndex);
end;

procedure TfrmMain.tbDownloaderTabsChanging(Sender: TObject;
  var AllowChange: Boolean);
begin
  if (tbDownloaderTabs.TabIndex > -1) and (deletingDownloaderTabAction = False)
    then
    UpdateDownloaderTab(tbDownloaderTabs.TabIndex);
  deletingDownloaderTabAction := False;
end;

function TfrmMain.FixURLline(input: string): string;
var
  s: string;
begin
  if input <> '' then
  begin
    s := StringReplace(input, 'hxxp://', 'http://', [rfReplaceAll,
      rfIgnoreCase]);
    s := StringReplace(s, 'fxp://', 'ftp://', [rfReplaceAll, rfIgnoreCase]);
    result := s;
    s := StringReplace(s, 'http://', '', [rfReplaceAll, rfIgnoreCase]);
    s := StringReplace(s, 'ftp://', '', [rfReplaceAll, rfIgnoreCase]);
    s := StringReplace(s, 'https://', '', [rfReplaceAll,
      rfIgnoreCase]);
    s := StringReplace(s, 'www.', '', [rfReplaceAll, rfIgnoreCase]);
    if Pos('/', s) > 0 then
      s := Copy(s, 1, Pos('/', s) - 1);
    tbDownloaderTabs.Tabs[tbDownloaderTabs.TabIndex] := s;
  end
  else
    Result := input;
end;

procedure TfrmMain.edURLExit(Sender: TObject);
begin
  edURL.Text := FixURLline(edURL.Text);
end;

procedure TfrmMain.mnuCloseDownloaderTabClick(Sender: TObject);
var
  a: Integer;
begin
  if (tbDownloaderTabs.Tabs.Count > 1) and (tbDownloaderTabs.TabIndex >= 0) then
  begin
    a := tbDownloaderTabs.TabIndex;
    DeleteDownloaderTab(a);
    tbDownloaderTabs.Tabs.Delete(a);
    if a = 0 then
    begin
      tbDownloaderTabs.TabIndex := a;
      ShowDownloaderTab(a);
    end
    else if (a < tbDownloaderTabs.Tabs.Count) and (a > 0) then
    begin
      tbDownloaderTabs.TabIndex := a;
      ShowDownloaderTab(a);
    end
    else
    begin
      tbDownloaderTabs.TabIndex := a - 1;
      ShowDownloaderTab(a - 1);
    end;
  end;
  deletingDownloaderTabAction := True;
end;

procedure TfrmMain.PopUpMnuDownloaderTabsPopup(Sender: TObject);
begin
  if tbDownloaderTabs.Tabs.Count > 1 then
    mnuCloseDownloaderTab.Visible := True
  else
    mnuCloseDownloaderTab.Visible := False;
end;

procedure TfrmMain.btFontSelectClick(Sender: TObject);
begin
  FontDialog1.Font := frmMain.Font;
  if FontDialog1.Execute then
    frmMain.Font := FontDialog1.Font;
end;

procedure TfrmMain.mnuLogClick(Sender: TObject);
var
  i: Integer;
  srcFile: string;
  trgFile: string;
begin
  mnuLog.Checked := not (mnuLog.Checked);
  LogActions := mnuLog.Checked;
  if LogActions = True then
    mmLog.Clear; //start logging
  if LogActions = False then //finished logging, save results
  begin
    JvSelectDirectory1.Title := 'Select where to save log';
    if mmLog.Text <> '' then
      if JvSelectDirectory1.Execute then
      begin
        if FileExists(JvSelectDirectory1.Directory + '\log.txt') then
        begin
          WideShowMessage('Please select another folder. This one already contains a log.');
          mnuLog.Checked := True;
        end
        else
        begin
          mmLog.Lines.SaveToFile(JvSelectDirectory1.Directory + '\log.txt');
          ForceDirectories(JvSelectDirectory1.Directory + '\Decoder');
          ForceDirectories(JvSelectDirectory1.Directory + '\Downloader');
          for i := 0 to mmLog.Lines.Count - 1 do
          begin
            if AnsiContainsText(mmLog.Lines[i], 'Downloaded content: ') then
            begin
              srcFile := Trim(Copy(mmLog.Lines[i], Pos(':', mmLog.Lines[i]) + 1,
                Length(mmLog.Lines[i])));
              trgFile := JvSelectDirectory1.Directory + '\Downloader\' +
                ExtractFileName(srcFile);
              CopyFile(PChar(srcFile), PChar(trgFile), False);
            end;
            if AnsiContainsText(mmLog.Lines[i], 'Source script saved as: ') then
            begin
              srcFile := Trim(Copy(mmLog.Lines[i], Pos(':', mmLog.Lines[i]) + 1,
                Length(mmLog.Lines[i])));
              trgFile := JvSelectDirectory1.Directory + '\Decoder\' +
                ExtractFileName(srcFile);
              CopyFile(PChar(srcFile), PChar(trgFile), False);
            end;
            if AnsiContainsText(mmLog.Lines[i], 'Compiled script saved as: ')
              then
            begin
              srcFile := Trim(Copy(mmLog.Lines[i], Pos(':', mmLog.Lines[i]) + 1,
                Length(mmLog.Lines[i])));
              trgFile := JvSelectDirectory1.Directory + '\Decoder\' +
                ExtractFileName(srcFile);
              CopyFile(PChar(srcFile), PChar(trgFile), False);
            end;
          end;
        end;
      end;
  end;
end;

procedure TfrmMain.tbDecoderTabsChange(Sender: TObject);
begin
  ShowDecoderTab(tbDecoderTabs.TabIndex);
end;

procedure TfrmMain.tbDecoderTabsChanging(Sender: TObject;
  var AllowChange: Boolean);
begin
  if (tbDecoderTabs.TabIndex > -1) and (deletingDecoderTabAction = False) then
    UpdateDecoderTab(tbDecoderTabs.TabIndex);
  deletingDecoderTabAction := False;
end;

procedure TfrmMain.mnuNewDecoderTabClick(Sender: TObject);
begin
  AddDecoderTab;
  tbDecoderTabs.Tabs.Add('New Tab (' + IntToStr(DecoderTabNr) + ')');
  //tbDecoderTabs.TabIndex := tbDecoderTabs.Tabs.Count -1;
end;

procedure TfrmMain.mnuCloseDecoderTabClick(Sender: TObject);
var
  a: Integer;
begin
  if (tbDecoderTabs.Tabs.Count > 1) and (tbDecoderTabs.TabIndex >= 0) then
  begin
    a := tbDecoderTabs.TabIndex;
    DeleteDecoderTab(a);
    tbDecoderTabs.Tabs.Delete(a);
    if a = 0 then
    begin
      tbDecoderTabs.TabIndex := a;
      ShowDecoderTab(a);
    end
    else if (a < tbDecoderTabs.Tabs.Count) and (a > 0) then
    begin
      tbDecoderTabs.TabIndex := a;
      ShowDecoderTab(a);
    end
    else
    begin
      tbDecoderTabs.TabIndex := a - 1;
      ShowDecoderTab(a - 1);
    end;
  end;
  deletingDecoderTabAction := True;
end;

procedure TfrmMain.PopUpMnuDecoderTabsPopup(Sender: TObject);
begin
  if tbDecoderTabs.Tabs.Count > 1 then
    mnuCloseDecoderTab.Visible := True
  else
    mnuCloseDecoderTab.Visible := False;
end;

procedure TfrmMain.cbHideProxyDataClick(Sender: TObject);
begin
  if cbHideProxyData.Checked then
  begin
    edProxyUser.PasswordChar := #42;
    edProxyPass.PasswordChar := #42;
  end
  else
  begin
    edProxyUser.PasswordChar := #0;
    edProxyPass.PasswordChar := #0;
  end;
end;

procedure TfrmMain.btAddSelectionToDecoderClick(Sender: TObject);
begin
  mmScript.Text := mmScript.Text + Copy(mmBrowser.Text, mmBrowser.SelStart + 1,
    mmBrowser.SelLength);
end;

procedure TfrmMain.btSendAllToDecoderClick(Sender: TObject);
var
  i1, j1: integer;
  script_pos_local: Integer;
begin
  if mmBrowser.Text <> '' then
  begin
    if GetShiftState = [ssCtrl] then
    begin
      AddDecoderTab;
      tbDecoderTabs.Tabs.Add('New Tab (' + IntToStr(DecoderTabNr) + ')');
      if (tbDecoderTabs.TabIndex > -1) and (deletingDecoderTabAction = False)
        then
        UpdateDecoderTab(tbDecoderTabs.TabIndex);
      deletingDecoderTabAction := False;
      tbDecoderTabs.TabIndex := tbDecoderTabs.Tabs.Count - 1;
      ShowDecoderTab(tbDecoderTabs.TabIndex);
    end;
    script_pos_local := 1;
    while script_pos_local < Length(mmBrowser.Text) do
    begin
      if posEx('<script', LowerCase(mmBrowser.Text), script_pos_local) = 0 then
        Exit;
      i1 := posEx('>', LowerCase(mmBrowser.Text), posEx('<script',
        LowerCase(mmBrowser.Text), script_pos_local));
      if i1 > 0 then
      begin
        mmBrowser.SelStart := i1;
        j1 := posEx('</script>', LowerCase(mmBrowser.Text), i1) - i1 - 1;
        if j1 > 0 then
        begin
          mmBrowser.SelLength := j1;
          script_pos_local := j1 + i1;
        end
        else
        begin
          //mmBrowser.SelLength := length(mmBrowser.Text);
          //script_pos := length(mmBrowser.Text);
          // patch for <script src=""something.js" language="JavaScript"></script>
          mmBrowser.SelLength := 0;
          script_pos_local := i1;
        end;
        mmScript.Text := mmScript.Text + #13#10 + Copy(mmBrowser.Text,
          mmBrowser.SelStart + 1,
          mmBrowser.SelLength);
        if cbAutoFocusDecoder.Checked then
          PageControl4.ActivePage := tsDecoder;
      end;
    end;
  end;
end;

procedure TfrmMain.btFindNextObjectClick(Sender: TObject);
var
  i1, j1: Integer;
  posComma: Integer;
  strLine: string;
  s1, s2, s3: string;
  HTMLObjectList: TStringList;
  i: Integer;
  buff: WideString;
  Position: Integer;
begin
  HTMLObjectList := TStringList.Create;
  if FileExists(ExtractFilePath(application.exename) + 'HTML_Obj_list.txt') then
  begin
    HTMLObjectList.LoadFromFile(ExtractFilePath(application.exename) +
      'HTML_Obj_list.txt');
    i := 0;
    frmHTMLObjects.sgHTMLObjects.RowCount := 1;
    frmHTMLObjects.sgHTMLObjects.Cells[0, 0] := 'Object';
    frmHTMLObjects.sgHTMLObjects.Cells[1, 0] := 'Start';
    frmHTMLObjects.sgHTMLObjects.Cells[2, 0] := 'End';
    while i < HTMLObjectList.Count do
    begin
      strLine := HTMLObjectList[i];
      buff := LowerCase(mmBrowser.Text);
      posComma := Pos(';', strLine);
      if posComma > 0 then
      begin
        s1 := LowerCase(Copy(strLine, 1, posComma - 1));
        Delete(strLine, 1, posComma);
        posComma := Pos(';', strLine);
        s2 := LowerCase(Copy(strLine, 1, posComma - 1));
        Delete(strLine, 1, posComma);
        s3 := LowerCase(Copy(strLine, 1, Length(strLine)));
      end;
      Position := 0;
      if Pos(s1, buff) > 0 then
        repeat
          if Pos(s1, buff) > 0 then
          begin
            i1 := posEx(s2, buff, pos(s1, buff));
            if i1 > 0 then
            begin
              j1 := posEx(s3, buff, i1 + 1);
              if j1 > 0 then
              begin
                with frmHTMLObjects.sgHTMLObjects do
                begin
                  ColCount := 3;
                  RowCount := RowCount + 1;
                  Cells[0, RowCount - 1] := s1 + s2 + s3;
                  Cells[1, RowCount - 1] := IntToStr(i1 + Position);
                  Cells[2, RowCount - 1] := IntToStr(j1 + Position);
                end;
                Delete(buff, 1, j1);
                Inc(Position, j1);
              end
              else
                Break;
            end
            else
              Break;
          end
          else
            Break;
        until i1 = 0;
      Inc(i);
    end;
  end;
  if frmHTMLObjects.sgHTMLObjects.RowCount > 1 then
  begin
    frmHTMLObjects.sgHTMLObjects.FixedRows := 1;
    frmHTMLObjects.Show;
    frmHTMLObjects.SortHTMLObjects;
  end;
  HTMLObjectList.Free;
end;

procedure TfrmMain.cbAutoCompleteURLClick(Sender: TObject);
begin
  edURL.AutoComplete := cbAutoCompleteURL.Checked;
end;

procedure TfrmMain.mnuClipMonPasteClick(Sender: TObject);
var
  posComma, i, j: integer;
  strLine: string;
  strFrom, strTo: string;
  downList: TStringList;
begin
  downList := TStringList.Create;
  downList.Duplicates := dupIgnore;
  with Clipboard do
  begin
    if (FormatCount <> 0) and HasFormat(CF_TEXT) then
    begin
      downList.Text := AsText;
      for j := 0 to downList.Count - 1 do
        for i := 0 to mmClipMonTrig.Lines.Count - 1 do
        begin
          strLine := mmClipMonTrig.Lines[i];
          posComma := pos(';', strLine);
          if posComma > 0 then
          begin
            strFrom := copy(strLine, 1, posComma - 1);
            strTo := copy(strLine, posComma + 1, length(strLine));
            if AnsiStartsText(strFrom, downList[j]) then
            begin
              downList[j] := StringReplace(downList[j], strFrom, strTo, []);
              mmListDownloaderPending.Items.Add(downList[j]);
            end;
          end;
        end;
    end;
  end;
  downList.Free;
end;

procedure TfrmMain.btConcatenateClick(Sender: TObject);
begin
  mmMiscDec.Text := Concatenate(mmMiscDec.Text);
end;

procedure TfrmMain.btFormatTextClick(Sender: TObject);
var
  indent: Integer;
  output: WideString;
  i: Integer;
  j: Integer;
  quotCount: Integer;
  dblQuotCount: Integer;
  forLoop: Boolean;
  temp: widestring;
begin
  indent := 0;
  output := '';
  quotCount := 0;
  dblQuotCount := 0;
  j := 1;
  forLoop := False;

  for i := 1 to mmScript.Lines.Count - 1 do
    mmScript.Lines[i] := Trim(mmScript.Lines[i]);

  temp := mmScript.Text;
  for i := 1 to Length(temp) do
  begin
    if temp[i] = '''' then
      Inc(quotCount);
    if temp[i] = '"' then
      Inc(dblQuotCount);

    if PosEx('for', temp, i) = i then
      forLoop := True;
    if forLoop and (temp[i] = ')') then
      forLoop := False;

    if (quotCount mod 2 = 0) and (dblQuotCount mod 2 = 0) then
      if temp[i] = '{' then
      begin
        if i <> 1 then
        begin
          begin
            if (temp[i + 1] <> #10)
              and (temp[i + 1] <> #13)
              and (temp[i + 2] <> #10)
              and (temp[i + 2] <> #13)
              and (temp[i - 1] <> #10)
              and (temp[i - 1] <> #13)
              and (temp[i - 2] <> #10)
              and (temp[i - 2] <> #13) then
            begin
              Output := Output + Copy(temp, j, i - j) + #13#10 + '{' +
                #13#10;
              j := i + 1;
            end
            else if (temp[i - 1] <> #10)
              and (temp[i - 1] <> #13)
              and (temp[i - 2] <> #10)
              and (temp[i - 2] <> #13) then
            begin
              Output := Output + Copy(temp, j, i - j) + #13#10 + '{';
              j := i + 1;
            end
            else if (temp[i + 1] <> #10)
              and (temp[i + 1] <> #13)
              and (temp[i + 2] <> #10)
              and (temp[i + 2] <> #13) then
            begin
              Output := Output + Copy(temp, j, i - j) + '{' + #13#10;
              j := i + 1;
            end;
          end;
        end;
      end
      else if temp[i] = '}' then
      begin
        if i <> Length(temp) then
        begin
          if (temp[i + 1] <> #10)
            and (temp[i + 1] <> #13)
            and (temp[i + 2] <> #10)
            and (temp[i + 2] <> #13)
            and (temp[i - 1] <> #10)
            and (temp[i - 1] <> #13)
            and (temp[i - 2] <> #10)
            and (temp[i - 2] <> #13) then
          begin
            Output := Output + Copy(temp, j, i - j) + #13#10 + '}' +
              #13#10;
            j := i + 1;
          end
          else if (temp[i - 1] <> #10)
            and (temp[i - 1] <> #13)
            and (temp[i - 2] <> #10)
            and (temp[i - 2] <> #13) then
          begin
            Output := Output + Copy(temp, j, i - j) + #13#10 + '}';
            j := i + 1;
          end
          else if (temp[i + 1] <> #10)
            and (temp[i + 1] <> #13)
            and (temp[i + 2] <> #10)
            and (temp[i + 2] <> #13) then
          begin
            Output := Output + Copy(temp, j, i - j) + '}' + #13#10;
            j := i + 1;
          end;
        end;
      end
      else if (temp[i] = ';') and (not forLoop) then
      begin
        if (temp[i + 1] <> #10) and (temp[i + 1] <> #13)
          //and (mmScript.Text[i - 1] <> '}')
        and (temp[i + 1] <> '}') then
        begin
          Output := Output + Copy(temp, j, i - j) + ';' + #13#10;
          j := i + 1;
        end;
      end;
  end;
  Output := output + Copy(temp, j, Length(temp));
  mmScript.Clear;
  mmScript.Text := output;
  for i := 0 to mmScript.Lines.Count - 1 do
  begin
    output := Trim(mmScript.Lines[i]);
    if Pos('}', output) > 0 then
    begin
      if indent <> 0 then
        for j := 0 to (indent - 2) do
          output := ' ' + output;
    end
    else
    begin
      for j := 0 to indent do
        output := ' ' + output;
    end;
    if Pos('{', output) > 0 then
      Inc(indent, 2);
    if Pos('}', output) > 0 then
      Dec(indent, 2);
    mmScript.Lines[i] := output;
  end;
  i := 0;
  while i < mmScript.Lines.Count - 1 do
    if Trim(mmScript.Lines[i]) = '' then
      mmScript.Lines.Delete(i)
    else
      Inc(i);
  i := 0;
  while i < mmScript.Lines.Count - 1 do
    if Trim(mmScript.Lines[i]) = ';' then
    begin
      if i > 0 then
      begin
        mmScript.Lines[i - 1] := mmScript.Lines[i - 1] + ';';
        mmScript.Lines.Delete(i);
      end;
    end
    else
      Inc(i);
end;

procedure TfrmMain.btFormatHTMLClick(Sender: TObject);
var
  indent: Integer;
  output: WideString;
  i: Integer;
  j: Integer;
begin
  indent := 0;
  output := '';
  j := 1;
  for i := 1 to mmBrowser.Lines.Count - 1 do
    mmBrowser.Lines[i] := Trim(mmBrowser.Lines[i]);

  for i := 1 to Length(mmBrowser.Text) do
  begin
    if mmBrowser.Text[i] = '{' then
    begin
      if i <> 1 then
      begin
        begin
          if (mmBrowser.Text[i + 1] <> #10)
            and (mmBrowser.Text[i + 1] <> #13)
            and (mmBrowser.Text[i + 2] <> #10)
            and (mmBrowser.Text[i + 2] <> #13)
            and (mmBrowser.Text[i - 1] <> #10)
            and (mmBrowser.Text[i - 1] <> #13)
            and (mmBrowser.Text[i - 2] <> #10)
            and (mmBrowser.Text[i - 2] <> #13) then
          begin
            Output := Output + Copy(mmBrowser.Text, j, i - j) + #13#10 + '{' +
              #13#10;
            j := i + 1;
          end
          else if (mmBrowser.Text[i - 1] <> #10)
            and (mmBrowser.Text[i - 1] <> #13)
            and (mmBrowser.Text[i - 2] <> #10)
            and (mmBrowser.Text[i - 2] <> #13) then
          begin
            Output := Output + Copy(mmBrowser.Text, j, i - j) + #13#10 + '{';
            j := i + 1;
          end
          else if (mmBrowser.Text[i + 1] <> #10)
            and (mmBrowser.Text[i + 1] <> #13)
            and (mmBrowser.Text[i + 2] <> #10)
            and (mmBrowser.Text[i + 2] <> #13) then
          begin
            Output := Output + Copy(mmBrowser.Text, j, i - j) + '{' + #13#10;
            j := i + 1;
          end;
        end;
      end;
    end
    else if mmBrowser.Text[i] = '}' then
    begin
      if i <> Length(mmBrowser.Text) then
      begin
        if (mmBrowser.Text[i + 1] <> #10)
          and (mmBrowser.Text[i + 1] <> #13)
          and (mmBrowser.Text[i + 2] <> #10)
          and (mmBrowser.Text[i + 2] <> #13)
          and (mmBrowser.Text[i - 1] <> #10)
          and (mmBrowser.Text[i - 1] <> #13)
          and (mmBrowser.Text[i - 2] <> #10)
          and (mmBrowser.Text[i - 2] <> #13) then
        begin
          Output := Output + Copy(mmBrowser.Text, j, i - j) + #13#10 + '}' +
            #13#10;
          j := i + 1;
        end
        else if (mmBrowser.Text[i - 1] <> #10)
          and (mmBrowser.Text[i - 1] <> #13)
          and (mmBrowser.Text[i - 2] <> #10)
          and (mmBrowser.Text[i - 2] <> #13) then
        begin
          Output := Output + Copy(mmBrowser.Text, j, i - j) + #13#10 + '}';
          j := i + 1;
        end
        else if (mmBrowser.Text[i + 1] <> #10)
          and (mmBrowser.Text[i + 1] <> #13)
          and (mmBrowser.Text[i + 2] <> #10)
          and (mmBrowser.Text[i + 2] <> #13) then
        begin
          Output := Output + Copy(mmBrowser.Text, j, i - j) + '}' + #13#10;
          j := i + 1;
        end;
      end;
    end
    else if mmBrowser.Text[i] = ';' then
    begin
      if (mmBrowser.Text[i + 1] <> #10) and (mmBrowser.Text[i + 1] <> #13)
        and (mmBrowser.Text[i - 1] <> '}')
        and (mmBrowser.Text[i + 1] <> '}') then
      begin
        Output := Output + Copy(mmBrowser.Text, j, i - j) + ';' + #13#10;
        j := i + 1;
      end;
    end;
  end;
  Output := output + Copy(mmBrowser.Text, j, Length(mmBrowser.Text));
  mmBrowser.Clear;
  mmBrowser.Text := output;
  for i := 0 to mmBrowser.Lines.Count - 1 do
  begin
    output := Trim(mmBrowser.Lines[i]);
    if Pos('}', output) > 0 then
    begin
      if indent <> 0 then
        for j := 0 to (indent - 2) do
          output := ' ' + output;
    end
    else
    begin
      for j := 0 to indent do
        output := ' ' + output;
    end;
    if Pos('{', output) > 0 then
      Inc(indent, 2);
    if Pos('}', output) > 0 then
      Dec(indent, 2);
    mmBrowser.Lines[i] := output;
  end;
end;

procedure TfrmMain.btShowEvalResultsClick(Sender: TObject);
begin
  frmEvalResults.Show;
end;

procedure TfrmMain.mnuScriptConcatenateClick(Sender: TObject);
var
  t1: WideString;
begin
  if TSynMemo(PopUpMnu.PopupComponent).SelLength = 0 then
    TSynMemo(PopUpMnu.PopupComponent).Text :=
      Concatenate(TSynMemo(PopUpMnu.PopupComponent).Text)
  else
  begin
    t1 := Copy(TSynMemo(PopUpMnu.PopupComponent).Text,
      TSynMemo(PopUpMnu.PopupComponent).SelStart,
      TSynMemo(PopUpMnu.PopupComponent).SelLength);
    t1 := Concatenate(t1);
    TSynMemo(PopUpMnu.PopupComponent).Text :=
      Copy(TSynMemo(PopUpMnu.PopupComponent).Text, 1,
      TSynMemo(PopUpMnu.PopupComponent).SelStart - 1) + t1 +
      Copy(TSynMemo(PopUpMnu.PopupComponent).Text,
      TSynMemo(PopUpMnu.PopupComponent).SelEnd,
      Length(TSynMemo(PopUpMnu.PopupComponent).Text));
  end;
end;

procedure TfrmMain.mnuScriptDDecClick(Sender: TObject);
var
  preDelimiter: Boolean;
  delimiter: WideString;
  t1: WideString;
begin
  frmDelimiterDlg.ShowModal;
  preDelimiter := frmDelimiterDlg.preDelimiter;
  delimiter := frmDelimiterDlg.delimiter;

  if TSynMemo(PopUpMnu.PopupComponent).SelLength = 0 then
    TSynMemo(PopUpMnu.PopupComponent).Text :=
      dec2str(TSynMemo(PopUpMnu.PopupComponent).Text, delimiter, preDelimiter)
  else
  begin
    t1 := Copy(TSynMemo(PopUpMnu.PopupComponent).Text,
      TSynMemo(PopUpMnu.PopupComponent).SelStart,
      TSynMemo(PopUpMnu.PopupComponent).SelLength);
    t1 := dec2str(t1, delimiter, preDelimiter);
    TSynMemo(PopUpMnu.PopupComponent).Text :=
      Copy(TSynMemo(PopUpMnu.PopupComponent).Text, 1,
      TSynMemo(PopUpMnu.PopupComponent).SelStart - 1) + t1 +
      Copy(TSynMemo(PopUpMnu.PopupComponent).Text,
      TSynMemo(PopUpMnu.PopupComponent).SelEnd,
      Length(TSynMemo(PopUpMnu.PopupComponent).Text));
  end;
end;

procedure TfrmMain.mnuScriptDHexClick(Sender: TObject);
var
  preDelimiter: Boolean;
  delimiter: WideString;
  t1: WideString;
begin
  frmDelimiterDlg.ShowModal;
  preDelimiter := frmDelimiterDlg.preDelimiter;
  delimiter := frmDelimiterDlg.delimiter;

  if TSynMemo(PopUpMnu.PopupComponent).SelLength = 0 then
    TSynMemo(PopUpMnu.PopupComponent).Text :=
      hex2str2(TSynMemo(PopUpMnu.PopupComponent).Text, delimiter, preDelimiter)
  else
  begin
    t1 := Copy(TSynMemo(PopUpMnu.PopupComponent).Text,
      TSynMemo(PopUpMnu.PopupComponent).SelStart,
      TSynMemo(PopUpMnu.PopupComponent).SelLength);
    t1 := hex2str2(t1, delimiter, preDelimiter);
    TSynMemo(PopUpMnu.PopupComponent).Text :=
      Copy(TSynMemo(PopUpMnu.PopupComponent).Text, 1,
      TSynMemo(PopUpMnu.PopupComponent).SelStart - 1) + t1 +
      Copy(TSynMemo(PopUpMnu.PopupComponent).Text,
      TSynMemo(PopUpMnu.PopupComponent).SelEnd,
      Length(TSynMemo(PopUpMnu.PopupComponent).Text));
  end;
end;

procedure TfrmMain.mnuScriptDUCS2Click(Sender: TObject);
var
  preDelimiter: Boolean;
  delimiter: WideString;
  t1: WideString;
begin
  frmDelimiterDlg.ShowModal;
  preDelimiter := frmDelimiterDlg.preDelimiter;
  delimiter := frmDelimiterDlg.delimiter;

  if TSynMemo(PopUpMnu.PopupComponent).SelLength = 0 then
    TSynMemo(PopUpMnu.PopupComponent).Text :=
      uni2str(TSynMemo(PopUpMnu.PopupComponent).Text, delimiter, preDelimiter)
  else
  begin
    t1 := Copy(TSynMemo(PopUpMnu.PopupComponent).Text,
      TSynMemo(PopUpMnu.PopupComponent).SelStart,
      TSynMemo(PopUpMnu.PopupComponent).SelLength);
    t1 := uni2str(t1, delimiter, preDelimiter);
    TSynMemo(PopUpMnu.PopupComponent).Text :=
      Copy(TSynMemo(PopUpMnu.PopupComponent).Text, 1,
      TSynMemo(PopUpMnu.PopupComponent).SelStart - 1) + t1 +
      Copy(TSynMemo(PopUpMnu.PopupComponent).Text,
      TSynMemo(PopUpMnu.PopupComponent).SelEnd,
      Length(TSynMemo(PopUpMnu.PopupComponent).Text));
  end;
end;

procedure TfrmMain.mnuScriptDBase64Click(Sender: TObject);
var
  temp: string;
begin
  if TSynMemo(PopUpMnu.PopupComponent).SelLength = 0 then
  begin
    temp := TSynMemo(PopUpMnu.PopupComponent).Text;
    temp := StringReplace(temp, #13#10, '', [rfReplaceAll]);
    if (length(temp) mod 4) = 0 then
    try
      temp := IdDecoderMIME1.DecodeToString(temp);
    except on e: exception do
        WideShowMessage(e.Message);
    end;
    TSynMemo(PopUpMnu.PopupComponent).Text := temp;
  end
  else
  begin
    temp := Copy(TSynMemo(PopUpMnu.PopupComponent).Text,
      TSynMemo(PopUpMnu.PopupComponent).SelStart,
      TSynMemo(PopUpMnu.PopupComponent).SelLength);
    temp := StringReplace(temp, #13#10, '', [rfReplaceAll]);
    if (length(temp) mod 4) = 0 then
    try
      temp := IdDecoderMIME1.DecodeToString(temp);
    except on e: exception do
        WideShowMessage(e.Message);
    end;
    TSynMemo(PopUpMnu.PopupComponent).Text :=
      Copy(TSynMemo(PopUpMnu.PopupComponent).Text, 1,
      TSynMemo(PopUpMnu.PopupComponent).SelStart - 1) + temp +
      Copy(TSynMemo(PopUpMnu.PopupComponent).Text,
      TSynMemo(PopUpMnu.PopupComponent).SelEnd,
      Length(TSynMemo(PopUpMnu.PopupComponent).Text));
  end;
end;

{procedure TfrmMain.mmBrowserPaint(Sender: TObject; ACanvas: TCanvas);
begin
  Canvas.Draw( 0, 0, FBckgrnd );
end;}

procedure TfrmMain.btLinkParserSortClick(Sender: TObject);
var
  sl: TWideStringList;
begin
  sl := TWideStringList.Create;
  sl.Sorted := True;
  sl.Duplicates := dupIgnore;
  sl.AddStrings(mmHTMLRemote.Lines);
  mmHTMLRemote.Clear;
  mmHTMLRemote.Lines.AddStrings(sl);
  sl.Clear;
  sl.AddStrings(mmIFrames.Lines);
  mmIFrames.Clear;
  mmIFrames.Lines.AddStrings(sl);
  sl.Free;
end;

procedure TfrmMain.mnuNewDownloaderTabAutoClick(Sender: TObject);
begin
  AddDownloaderTabAuto;
  tbDownloaderTabs.Tabs.Add('New Tab (' + IntToStr(DownloaderTabNr) +
    ')');
end;

procedure TfrmMain.cbAutoRedirectClick(Sender: TObject);
begin
  if cbAutoRedirect.Checked then
    cbAutoReferrer.Checked := True;
end;

procedure TfrmMain.cbAutoReferrerClick(Sender: TObject);
begin
  if cbAutoReferrer.Checked = False then
    cbAutoRedirect.Checked := False;
end;

procedure TfrmMain.rbEdExNormalClick(Sender: TObject);
begin
  mmEdEx.SelectionMode := smNormal;
end;

procedure TfrmMain.rbEdExLineClick(Sender: TObject);
begin
  mmEdEx.SelectionMode := smLine;
end;

procedure TfrmMain.rbEdExColumnClick(Sender: TObject);
begin
  mmEdEx.SelectionMode := smColumn;
end;

procedure TfrmMain.btEdExGOClick(Sender: TObject);
var
  sel: Integer;
  i: Integer;
begin
  sel := comboEdExAction.ItemIndex;
  case sel of
    0:
      begin
        for i := 0 to mmEdEx.Lines.Count - 1 do
          mmEdEx.Lines[i] := edEdExInput.Text + mmEdEx.Lines[i];
      end;
    1:
      begin
        i := 0;
        while i < mmEdEx.Lines.Count do
        begin
          if Pos(edEdExInput.Text, mmEdEx.Lines[i]) > 0 then
            mmEdEx.Lines.Delete(i)
          else
            Inc(i);
        end;
      end;
    2:
      begin
        i := 0;
        while i < mmEdEx.Lines.Count do
        begin
          if Pos(edEdExInput.Text, mmEdEx.Lines[i]) = 0 then
            mmEdEx.Lines.Delete(i)
          else
            Inc(i);
        end;
      end;
    3:
      begin
        mmEdEx.Text := StringReplace(mmEdEx.Text, edEdExInput.Text,
          edEdExInput2.Text, [rfReplaceAll, rfIgnoreCase]);
      end;
    4:
      begin
        i := 0;
        while i < mmEdEx.Lines.Count do
        begin
          if mmEdEx.Lines[i] = '' then
            mmEdEx.Lines.Delete(i)
          else
            Inc(i);
        end;
      end;
  end;

end;

procedure TfrmMain.edReferrerKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key = vk_return then
  begin
    btGetThreaded.SetFocus;
  end;
end;

procedure TfrmMain.btMiniHTMLViewClick(Sender: TObject);
var
  s: string;
  t1: WideString;
  t2: WideString;
begin
  s := ExtractFilePath(Application.ExeName) + '/Cache/tempview';
  t1 := mmBrowser.Text;
  t2 := mmBrowser.Text;
  t1 := StringReplace(t1, '&quot;', '"', [rfReplaceAll]);
  t1 := StringReplace(t1, '&apos;', '''', [rfReplaceAll]);
  t1 := StringReplace(t1, '&gt;', '>', [rfReplaceAll]);
  t1 := StringReplace(t1, '&lt;', '<', [rfReplaceAll]);
  t1 := StringReplace(t1, '&amp;', '&', [rfReplaceAll]);
  t1 := StringReplace(t1, '&nbsp;', ' ', [rfReplaceAll]);
  t1 := StringReplace(t1, '&raquo;', '»', [rfReplaceAll]);
  t1 := StringReplace(t1, '&laquo;', '«', [rfReplaceAll]);
  t1 := StringReplace(t1, '&copy;', '©', [rfReplaceAll]);
  t1 := StringReplace(t1, '&#9660;', #32, [rfReplaceAll]);
  mmBrowser.Text := t1;
  mmBrowser.Lines.SaveToFile(s);
  mmBrowser.Text := t2;
  if GetFileSize(s) > 10000 then
    if WideMessageDlg('Looks like a lot of data to parse. Are you sure?',
      mtConfirmation, [mbYes, mbNo], 0) =
      mrNo then
      Exit;

  frmMiniHTMLView.SetHTML(s);
  frmMiniHTMLView.Update;
  frmMiniHTMLView.Show;

end;

procedure TfrmMain.mnuRemoveNULLsClick(Sender: TObject);
var
  t1: WideString;
begin
  if TSynMemo(PopUpMnu.PopupComponent).SelLength = 0 then
    TSynMemo(PopUpMnu.PopupComponent).Text :=
      RemoveNulls(TSynMemo(PopUpMnu.PopupComponent).Text)
  else
  begin
    t1 := Copy(TSynMemo(PopUpMnu.PopupComponent).Text,
      TSynMemo(PopUpMnu.PopupComponent).SelStart,
      TSynMemo(PopUpMnu.PopupComponent).SelLength);
    t1 := RemoveNulls(t1);
    TSynMemo(PopUpMnu.PopupComponent).Text :=
      Copy(TSynMemo(PopUpMnu.PopupComponent).Text, 1,
      TSynMemo(PopUpMnu.PopupComponent).SelStart - 1) + t1 +
      Copy(TSynMemo(PopUpMnu.PopupComponent).Text,
      TSynMemo(PopUpMnu.PopupComponent).SelEnd,
      Length(TSynMemo(PopUpMnu.PopupComponent).Text));
  end;
end;

procedure TfrmMain.mnuIncrementDecClick(Sender: TObject);
begin
  mnuIncrementDec.Checked := True;
  mnuIncrementHex.Checked := False;
  seIncrementStep.ValueType := vtInteger;
end;

procedure TfrmMain.mnuIncrementHexClick(Sender: TObject);
begin
  mnuIncrementHex.Checked := True;
  mnuIncrementDec.Checked := False;
  seIncrementStep.ValueType := vtHex;
end;

procedure TfrmMain.mnuRemoveWhitespaceClick(Sender: TObject);
var
  t1: WideString;
begin
  if TSynMemo(PopUpMnu.PopupComponent).SelLength = 0 then
    TSynMemo(PopUpMnu.PopupComponent).Text :=
      RemoveWhitespace(TSynMemo(PopUpMnu.PopupComponent).Text)
  else
  begin
    t1 := Copy(TSynMemo(PopUpMnu.PopupComponent).Text,
      TSynMemo(PopUpMnu.PopupComponent).SelStart,
      TSynMemo(PopUpMnu.PopupComponent).SelLength);
    t1 := RemoveWhitespace(t1);
    TSynMemo(PopUpMnu.PopupComponent).Text :=
      Copy(TSynMemo(PopUpMnu.PopupComponent).Text, 1,
      TSynMemo(PopUpMnu.PopupComponent).SelStart - 1) + t1 +
      Copy(TSynMemo(PopUpMnu.PopupComponent).Text,
      TSynMemo(PopUpMnu.PopupComponent).SelEnd,
      Length(TSynMemo(PopUpMnu.PopupComponent).Text));
  end;
end;

procedure TfrmMain.btTemplateClick(Sender: TObject);
var
  templates_folder: WideString;
  sl: TStringList;
  i: Integer;
begin
  mmTemplates.Clear;
  templates_folder := WideExtractFilePath(Application.ExeName) + '\Templates\';
  if WideDirectoryExists(templates_folder) then
  begin
    sl := TStringList.Create;
    FindFiles(templates_folder, faAnyFile, 0, False, sl);
    for i := 0 to sl.Count - 1 do
    begin
      mmTemplates.Items.Add(WideExtractFileName(sl[i]));
    end;
    sl.Free;
  end;
  mmTemplates.Visible := not (mmTemplates.Visible);
  splTemplate.Visible := mmTemplates.Visible;
end;

procedure TfrmMain.mmTemplatesDblClick(Sender: TObject);
var
  file_path: string;
  i: Integer;
  t: TStringList;
begin
  file_path := WideExtractFilePath(Application.ExeName) + '\Templates\';
  for i := 0 to mmTemplates.Items.Count - 1 do
    if mmTemplates.Selected[i] then
      file_path := file_path + mmTemplates.Items[i];
  if WideFileExists(file_path) then
  begin
    t := TStringList.Create;
    t.LoadFromFile(file_path);
    mmScript.Text := parseTemplate(t.Text) + #13#10 + mmScript.Text;
    t.Free;
  end;
end;

function TfrmMain.parseTemplate(s: WideString): WideString;
var
  Prot, User, Pass, Host, Port, Path, Para: string;
begin
  ParseURL(edURL.Text, Prot, User, Pass, Host, Port, Path, Para);
  if Pos('#', edURL.Text) > 0 then
    s := WideStringReplace(s, 'malzilla.location.hash', Copy(edURL.Text,
      Pos('#', edURL.Text), Length(edURL.Text)), [rfReplaceAll, rfIgnoreCase])
  else
    s := WideStringReplace(s, 'malzilla.location.hash', '', [rfReplaceAll,
      rfIgnoreCase]);
  s := WideStringReplace(s, 'malzilla.location.host', Host + ':' + Port,
    [rfReplaceAll, rfIgnoreCase]);
  s := WideStringReplace(s, 'malzilla.location.hostname', Host, [rfReplaceAll,
    rfIgnoreCase]);
  s := WideStringReplace(s, 'malzilla.location.href', edURL.Text, [rfReplaceAll,
    rfIgnoreCase]);
  s := WideStringReplace(s, 'malzilla.location.pathname', Path, [rfReplaceAll,
    rfIgnoreCase]);
  s := WideStringReplace(s, 'malzilla.location.port', Port, [rfReplaceAll,
    rfIgnoreCase]);
  s := WideStringReplace(s, 'malzilla.location.protocol', Prot, [rfReplaceAll,
    rfIgnoreCase]);
  if Pos('?', edURL.Text) > 0 then
    s := WideStringReplace(s, 'malzilla.location.search', Copy(edURL.Text,
      Pos('?', edURL.Text), Length(edURL.Text)), [rfReplaceAll, rfIgnoreCase])
  else
    s := WideStringReplace(s, 'malzilla.location.search', '', [rfReplaceAll,
      rfIgnoreCase]);
  s := WideStringReplace(s, 'malzilla.navigator.userAgent', comboUserAgent.Text,
    [rfReplaceAll, rfIgnoreCase]);
  s := WideStringReplace(s, 'malzilla.document.cookie', edCookies.Text,
    [rfReplaceAll, rfIgnoreCase]);
  s := WideStringReplace(s, 'malzilla.document.domain', Host, [rfReplaceAll,
    rfIgnoreCase]);
  s := WideStringReplace(s, 'malzilla.document.referrer', edReferrer.Text,
    [rfReplaceAll, rfIgnoreCase]);
  s := WideStringReplace(s, 'malzilla.document.URL', edURL.Text, [rfReplaceAll,
    rfIgnoreCase]);
  Result := s;
end;

procedure TfrmMain.btDeobfuscateURLClick(Sender: TObject);
var
  Prot, User, Pass, Host, Port, Path, Para: string;
  a: array of string;
  nr_dots: Integer;
  i, j: Integer;
  temp: string;
  t1, t2, t3, t4: string;
  g: Int64;
  r: string;
begin
  if edObfURL.Text <> '' then
  begin
    temp := hex2str2(edObfURL.Text, '%', true);
    ParseURL(temp, Prot, User, Pass, Host, Port, Path, Para);
    mmDeobfURL.Clear;
    mmDeobfURL.Lines.Add('*********** Parsing data ***********');
    mmDeobfURL.Lines.Add('Protocol: ' + Prot);
    mmDeobfURL.Lines.Add('User: ' + User);
    mmDeobfURL.Lines.Add('Pass: ' + Pass);
    mmDeobfURL.Lines.Add('Host: ' + Host);
    mmDeobfURL.Lines.Add('Port: ' + Port);
    mmDeobfURL.Lines.Add('Path: ' + Path);
    mmDeobfURL.Lines.Add('Parameters: ' + Para);
    mmDeobfURL.Lines.Add('');
    mmDeobfURL.Lines.Add('********** Analyzing data **********');

    //deobfuscating host
    nr_dots := 1;
    for i := 0 to Length(Host) do
      if Host[i] = '.' then
        Inc(nr_dots);
    SetLength(a, nr_dots);
    for i := 0 to nr_dots - 1 do
    begin
      if Pos('.', Host) > 0 then
      begin
        a[i] := Copy(Host, 1, Pos('.', Host) - 1);
        Delete(Host, 1, Pos('.', Host));
      end
      else
        a[i] := Host;
    end;
    for i := 0 to Length(a) - 1 do
    begin
      //mmDeobfURL.Lines.Add('Host part(' + IntToStr(i) + '): ' + a[i]);
      //detect hex
      if Pos('0x', a[i]) = 1 then
      begin
        //0xFE
        if Length(a[i]) = 4 then
        begin
          mmDeobfURL.Lines.Add('Host part(' + IntToStr(i) + ') is hex: ' +
            a[i]);
          a[i] := hex2strnoDelimiter(Copy(a[i], 3, 2))
        end
        else if Length(a) = 1 then
        begin
          //0x9A3F0800CE9F2802
          if Length(a[i]) >= 10 then
          begin
            a[i] := Copy(a[i], Length(a[i]) - 7, Length(a[i]));
            mmDeobfURL.Lines.Add('Host part(' + IntToStr(i) + ') is long hex: '
              + a[i]);
            for j := 0 to 3 do
            begin
              t1 := hex2strnoDelimiter(Copy(a[i], 1, 2));
              t2 := hex2strnoDelimiter(Copy(a[i], 3, 2));
              t3 := hex2strnoDelimiter(Copy(a[i], 5, 2));
              t4 := hex2strnoDelimiter(Copy(a[i], 7, 2));
            end;
            a[i] := t1 + '.' + t2 + '.' + t3 + '.' + t4;
          end;
        end;
      end
      else if Pos('0', a[i]) = 1 then //detect octal
      begin
        mmDeobfURL.Lines.Add('Host part(' + IntToStr(i) + ') is octal: ' +
          a[i]);
        a[i] := OctToInt(a[i]);
      end
      else if (StrToInt64Def(a[i], -1) <> -1) and (StrToInt64Def(a[i], -1) > 255)
        and (nr_dots = 1) then // detect dword
      begin
        mmDeobfURL.Lines.Add('Host part(' + IntToStr(i) + ') is DWORD: ' +
          a[i]);
        g := StrToInt64(a[i]);
        a[i] := IntToHex(g, 4);
        a[i] := Copy(a[i], Length(a[i]) - 7, Length(a[i]));
        for j := 0 to 3 do
        begin
          t1 := hex2strnoDelimiter(Copy(a[i], 1, 2));
          t2 := hex2strnoDelimiter(Copy(a[i], 3, 2));
          t3 := hex2strnoDelimiter(Copy(a[i], 5, 2));
          t4 := hex2strnoDelimiter(Copy(a[i], 7, 2));
        end;
        a[i] := t1 + '.' + t2 + '.' + t3 + '.' + t4;
      end
      else if (StrToInt64Def(a[i], -1) <> -1) and (StrToInt64Def(a[i], -1) > 255)
        and (nr_dots = 4) then // detect word
      begin
        mmDeobfURL.Lines.Add('Host part(' + IntToStr(i) + ') is WORD: ' + a[i]);
        g := StrToInt64(a[i]);
        a[i] := IntToHex(g, 1);
        a[i] := hex2strnoDelimiter(Copy(a[i], Length(a[i]) - 1, 2));
      end;
    end;
    temp := '';
    for i := 0 to Length(a) - 1 do
      temp := temp + a[i] + '.';
    SetLength(temp, Length(temp) - 1);
    mmDeobfURL.Lines.Add('Host (deobfuscated): ' + temp);

    //deobfuscating path
    Path := hex2str2(Path, '%', true);
    mmDeobfURL.Lines.Add('Path (deobfuscated): ' + Path);

    //print results
    mmDeobfURL.Lines.Add('');
    mmDeobfURL.Lines.Add('********** Results **********');
    r := Prot + '://' + temp;
    if Port <> '80' then
      r := r + ':' + Port;
    r := r + Path + Para;
    mmDeobfURL.Lines.Add('URL (no LogIn):');
    mmDeobfURL.Lines.Add(r);

    if User <> '' then
    begin
      r := Prot + '://' + User;
      if Pass <> '' then
        r := r + ':' + Pass;
      r := r + '@' + temp;
      if Port <> '80' then
        r := r + ':' + Port;
      r := r + Path + Para;
      mmDeobfURL.Lines.Add('URL (with LogIn):');
      mmDeobfURL.Lines.Add(r);
    end;
  end;
end;

procedure TfrmMain.edObfURLKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key = vk_return then
  begin
    btDeobfuscateURL.SetFocus;
    btDeobfuscateURL.Click;
  end;
end;

procedure TfrmMain.mnuRemovewhitespaceall1Click(Sender: TObject);
var
  t1: WideString;
begin
  if TSynMemo(PopUpMnu.PopupComponent).SelLength = 0 then
    TSynMemo(PopUpMnu.PopupComponent).Text :=
      RemoveWhitespaceAll(TSynMemo(PopUpMnu.PopupComponent).Text)
  else
  begin
    t1 := Copy(TSynMemo(PopUpMnu.PopupComponent).Text,
      TSynMemo(PopUpMnu.PopupComponent).SelStart,
      TSynMemo(PopUpMnu.PopupComponent).SelLength);
    t1 := RemoveWhitespaceAll(t1);
    TSynMemo(PopUpMnu.PopupComponent).Text :=
      Copy(TSynMemo(PopUpMnu.PopupComponent).Text, 1,
      TSynMemo(PopUpMnu.PopupComponent).SelStart - 1) + t1 +
      Copy(TSynMemo(PopUpMnu.PopupComponent).Text,
      TSynMemo(PopUpMnu.PopupComponent).SelEnd,
      Length(TSynMemo(PopUpMnu.PopupComponent).Text));
  end;
end;

procedure TfrmMain.tbChange(Sender: TObject);
begin
  if PageControl6.ActivePage = tsMixHex then
  begin
    if IsWideStringMappableToAnsi(mmMiscDec.Text) then
    begin
      MPHexEditor3.UnicodeChars := False;
      cbMiscHexUnicode.Checked := False;
      cbMiscHexUnicodeBigEndian.Checked := False;
      MPHexEditor3.AsText := mmMiscDec.Text;
    end
    else
    begin
      mmMiscDec.Lines.SaveUnicode := True;
      MPHexEditor3.UnicodeChars := True;
      MPHexEditor3.UnicodeBigEndian := True;
      cbMiscHexUnicode.Checked := True;
      cbMiscHexUnicodeBigEndian.Checked := True;
      //ShowMessage('Unicode');  //debug
      MPHexEditor3.AsHex := UCS2HexStr(mmMiscDec.Text);
    end;
  end
  else
  begin
    if cbMiscHexUnicode.Checked then
    begin
      mmMiscDec.Text := Uni2strNoDelimiterLoop(MPHexEditor3.AsHex);
    end
    else
    begin
      mmMiscDec.Text := MPHexEditor3.AsText;
    end;
  end;
end;

procedure TfrmMain.cbMiscHexUnicodeClick(Sender: TObject);
begin
  try
    MPHexEditor3.UnicodeChars := cbMiscHexUnicode.Checked;
  except
    on e: exception do
    begin
      WideShowMessage('Odd-byte file size, cannot be Unicode');
      cbMiscHexUnicode.Checked := MPHexEditor3.UnicodeChars;
    end;
  end;
end;

procedure TfrmMain.cbMiscHexUnicodeBigEndianClick(Sender: TObject);
begin
  MPHexEditor3.UnicodeBigEndian := cbMiscHexUnicodeBigEndian.Checked;
end;

procedure TfrmMain.cbMiscHexSwapNibblesClick(Sender: TObject);
begin
  MPHexEditor3.SwapNibbles := cbMiscHexSwapNibbles.Checked;
end;

procedure TfrmMain.btKalimeroStep1Click(Sender: TObject);
var
  i: Integer;
begin
  if mmKalimero.Text <> '' then
  begin
    for i := 0 to sgKalimeroArray.RowCount - 1 do
    begin
      sgKalimeroArray.Cells[0, i] := '';
      sgKalimeroArray.Cells[1, i] := '';
    end;
    sgKalimeroArray.RowCount := 0;
    KalimeroS1(mmKalimero.Text, edKalimeroRegEx.Text, sgKalimeroArray);
    AutoSizeGrid(sgKalimeroArray);
    i := 0;
    while i < sgKalimeroArray.RowCount do
    begin
      if sgKalimeroArray.Cells[0, i] = '' then
      begin
        sgKalimeroArray.RowCount := i;
        Break;
      end
      else
        Inc(i);
    end;
  end;
end;

procedure TfrmMain.btKalimeroStep2Click(Sender: TObject);
var
  i: Integer;
  x: string;
  y: string;
begin
  mmKalimero.Clear;
  for i := 0 to sgKalimeroArray.RowCount - 1 do
  begin
    y := WideStringReplace(sgKalimeroArray.Cells[0, i], '"', '',
      [rfReplaceAll]);
    y := WideStringReplace(y, '''', '', [rfReplaceAll]);
    x := WideStringReplace(edKalimeroReplace.Text, 'KalimeroName', y,
      [rfReplaceAll]);
    if cbKalimeroEscapeCorrection.Checked then
      x := WideStringReplace(x, 'KalimeroValue',
        EscapeCorrection(sgKalimeroArray.Cells[1, i]), [rfReplaceAll])
    else
      x := WideStringReplace(x, 'KalimeroValue', sgKalimeroArray.Cells[1, i],
        [rfReplaceAll]);
    mmKalimero.Lines.Add(x);
  end;
end;

procedure TfrmMain.btRunLibEmuClick(Sender: TObject);
var
  libEmuPath: string;
  s: string;
begin
  libEmuPath := ExtractFileDir(Application.ExeName) + '\libemu\';
  if cbLibEmuGetPC.Checked then
    s := '"' + libEmuPath + 'sctest.exe" -Sgs 1000000 < "' + libEmuPath +
      'shellcode.dat" > "' + libEmuPath + 'output.log"'
  else
    s := '"' + libEmuPath + 'sctest.exe" -Ss 1000000 < "' + libEmuPath +
      'shellcode.dat" > "' + libEmuPath + 'output.log"';
  mmLibEmuOutput.Text := s;
  mmLibEmuOutput.Lines.SaveToFile(libEmuPath + 'emulate.bat');
  mmLibEmuOutput.Lines.Clear;
  hexLibEmuInput.SaveToFile(libEmuPath + 'shellcode.dat');
  emulator.CommandLine := '"' + libEmuPath + 'emulate.bat"';
  emulator.Execute;
end;

procedure TfrmMain.btLibEmuAbortClick(Sender: TObject);
begin
  emulator.Stop;
end;

procedure TfrmMain.emulatorTerminated(Sender: TObject; ExitCode: Cardinal);
begin
  if FileExists(ExtractFileDir(Application.ExeName) + '\libemu\output.log') then
    mmLibEmuOutput.Lines.LoadFromFile(ExtractFileDir(Application.ExeName) +
      '\libemu\output.log');
  if FileExists(ExtractFileDir(Application.ExeName) + '\libemu\emulate.bat')
    then
    DeleteFile(ExtractFileDir(Application.ExeName) + '\libemu\emulate.bat');
  if FileExists(ExtractFileDir(Application.ExeName) + '\libemu\output.log') then
    DeleteFile(ExtractFileDir(Application.ExeName) + '\libemu\output.log');
  if FileExists(ExtractFileDir(Application.ExeName) + '\libemu\shellcode.dat')
    then
    DeleteFile(ExtractFileDir(Application.ExeName) + '\libemu\shellcode.dat');
  mmLibEmuOutput.Lines.Add('');
  mmLibEmuOutput.Lines.Add('Finished');
end;

procedure TfrmMain.edXORKeyPress(Sender: TObject; var Key: Char);
begin
  if not (Key in [#8, '0'..'9', 'A'..'F', 'a'..'f']) then
    Key := #0;
end;

procedure TfrmMain.btXORClick(Sender: TObject);
var
  HexMap: string;
  i: Integer;
begin
  i := 1;
  HexMap := '';
  while i <= Length(mmMiscDec.Text) do
  begin
    HexMap := HexMap + edXOR.Text;
    Inc(i);
  end;
  mmMiscDec.Text := BFxorit(mmMiscDec.Text, HexMap);
end;

procedure TfrmMain.btBFXORClick(Sender: TObject);
var
  sourceStr: string;
  findList: TStringList;
  counter: Integer;
  i: Integer;
  j: Integer;
  currentXOR: string;
  maxXOR: string;
  HexMap: string;
  xored: string;
begin
  if btBFXOR.Caption = 'Cancel' then
  begin
    btBFXOR.Caption := 'Find';
    cancelOP := True;
  end
  else
  begin
    if mmXORStrings.Text <> '' then
    begin
      btBFXOR.Caption := 'Cancel';
      findList := TStringList.Create;
      sourceStr := MPHexEditor1.AsHex;
      for i := 0 to mmXORStrings.Lines.Count - 1 do
        findList.Add(Str2Hex(mmXORStrings.Lines[i]));
      if edXORKeyMAX.Text <> '' then
        maxXOR := incHexStr(edXORKeyMAX.Text)
      else
        maxXOR := '0100';
      counter := 0;
      while counter < findList.Count do
      begin
        j := 1;
        currentXOR := '00';
        lbXORString.Caption := 'Current string: ' + mmXorStrings.Lines[counter];
        Application.ProcessMessages;
        while currentXOR <> maxXOR do
        begin
          {if not(cbXORTurbo.Checked) then
          begin
            lbXORKey.Caption := 'Current key: ' + currentXOR;
            Application.ProcessMessages;
          end;}
          i := 1;
          HexMap := '';
          while i <= Length(sourceStr) do
          begin
            HexMap := HexMap + currentXor;
            Inc(i);
          end;
          xored := BFxorit(sourceStr, HexMap);
          if AnsiContainsText(xored, findList[counter]) then
          begin
            edXORKey.Text := currentXOR;
            counter := findList.Count;
            Break;
          end;
          currentXOR := incHexStr(currentXOR);
          if j = 256 then
          begin
            lbXORKey.Caption := 'Current key: ' + currentXOR;
            Application.ProcessMessages;
            j := 0;
          end;
          Inc(j);
          if cancelOP then
          begin
            counter := findList.Count;
            Break;
          end;
        end;
        Inc(counter);
      end;
      findList.Free;
      ShowMessage('Finished');
    end
    else
      ShowMessage('Enter strings to find, one per line');
    cancelOP := False;
    btBFXOR.Caption := 'Find';
  end;
end;

procedure TfrmMain.edXORKeyKeyPress(Sender: TObject; var Key: Char);
begin
  if not (Key in [#8, '0'..'9', 'A'..'F', 'a'..'f']) then
    Key := #0;
end;

procedure TfrmMain.btApplyXorClick(Sender: TObject);
var
  HexMap: string;
  i: Integer;
begin
  if edXORKey.Text <> '' then
  begin
    i := 1;
    HexMap := '';
    while i <= Length(MPHexEditor1.AsHex) do
    begin
      HexMap := HexMap + edXORKey.Text;
      Inc(i);
    end;
    MPHexEditor1.AsHex := BFxorit(MPHexEditor1.AsHex, HexMap);
  end;
end;

procedure TfrmMain.mnuHexCopyClipTextSelClick(Sender: TObject);
begin
  Clipboard.AsText := TMPHexEditor(PopUpMnuHex.PopupComponent).SelectionAsText;
end;

procedure TfrmMain.mnuHexCopyClipHexSelClick(Sender: TObject);
begin
  Clipboard.AsText := TMPHexEditor(PopUpMnuHex.PopupComponent).SelectionAsHex;
end;

procedure TfrmMain.edXORKeyMAXKeyPress(Sender: TObject; var Key: Char);
begin
  if not (Key in [#8, '0'..'9', 'A'..'F', 'a'..'f']) then
    Key := #0;
end;

procedure TfrmMain.btHexDisasmClick(Sender: TObject);
var
  daCode: TDisAsm;
  dwCount: Integer;
  memStream: TMemoryStream;
  opcodeCode: string;
  lenDiff: Integer;
begin
  daCode := TDisAsm.Create;
  memStream := TMemoryStream.Create;
  MPHexEditor1.SaveToStream(memStream);
  //ShowMessage(IntToStr(memStream.size));
  daCode.Disassemble(memStream.Memory, memStream.Size);
  mmDisasm.Clear;
  opcodeCounter := 0;
  SetLength(opcodeSize, daCode.Count + 1);
  //uradi proveru da li je daCode.size manji od memStream.Size pa uradi while petlju
  for dwCount := 0 to Pred(daCode.Count) do
  begin
    opcodeCode := Copy(MPHexEditor1.AsHex, (opcodeCounter * 2) + 1,
      daCode[dwCount].Code.Size * 2);
    while Length(opcodeCode) < 21 do
      opcodeCode := opcodeCode + ' ';
    mmDisasm.Lines.Add({IntToStr(daCode[dwCount].Code.Size) + #9 + }opcodeCode
      + daCode[dwCount].Code.szText);
    opcodeSize[dwCount + 1] := opcodeCounter;
    Inc(opcodeCounter, daCode[dwCount].Code.Size);
  end;
  lenDiff := memStream.Size - daCode.Size;
  if lenDiff <> 0 then
  begin
    mmDisasm.Lines.Add('===================  ===================');
    mmDisasm.Lines.Add('Error: unexpected byte at ' + IntToHex(daCode.Size, 6));
    mmDisasm.Lines.Add('The rest of the code contains ' + IntToStr(lenDiff) +
      ' bytes');
  end;
  opcodeCounter := 0;
  mmDisasm.Refresh;
  memStream.Free;
  daCode.Free;
end;

procedure TfrmMain.mmDisasmGutterGetText(Sender: TObject; aLine: Integer;
  var aText: WideString);
begin
  if Length(opcodeSize) > 0 then
    if aLine < Length(opcodeSize) then
      aText := IntToHex(opcodeSize[aLine], 6)
    else
      aText := '';
end;

procedure TfrmMain.mnuScriptDHexNoDelClick(Sender: TObject);
var
  t1: WideString;
begin
  if TSynMemo(PopUpMnu.PopupComponent).SelLength = 0 then
    TSynMemo(PopUpMnu.PopupComponent).Text :=
      Hex2strNoDelimiterLoop(TSynMemo(PopUpMnu.PopupComponent).Text)
  else
  begin
    t1 := Copy(TSynMemo(PopUpMnu.PopupComponent).Text,
      TSynMemo(PopUpMnu.PopupComponent).SelStart,
      TSynMemo(PopUpMnu.PopupComponent).SelLength);
    t1 := Hex2strNoDelimiterLoop(t1);
    TSynMemo(PopUpMnu.PopupComponent).Text :=
      Copy(TSynMemo(PopUpMnu.PopupComponent).Text, 1,
      TSynMemo(PopUpMnu.PopupComponent).SelStart - 1) + t1 +
      Copy(TSynMemo(PopUpMnu.PopupComponent).Text,
      TSynMemo(PopUpMnu.PopupComponent).SelEnd,
      Length(TSynMemo(PopUpMnu.PopupComponent).Text));
  end;
end;

procedure TfrmMain.mnuScriptDUCS2NoDelClick(Sender: TObject);
var
  t1: WideString;
begin
  if TSynMemo(PopUpMnu.PopupComponent).SelLength = 0 then
    TSynMemo(PopUpMnu.PopupComponent).Text :=
      Uni2strNoDelimiterLoop(TSynMemo(PopUpMnu.PopupComponent).Text)
  else
  begin
    t1 := Copy(TSynMemo(PopUpMnu.PopupComponent).Text,
      TSynMemo(PopUpMnu.PopupComponent).SelStart,
      TSynMemo(PopUpMnu.PopupComponent).SelLength);
    t1 := uni2strNoDelimiterLoop(t1);
    TSynMemo(PopUpMnu.PopupComponent).Text :=
      Copy(TSynMemo(PopUpMnu.PopupComponent).Text, 1,
      TSynMemo(PopUpMnu.PopupComponent).SelStart - 1) + t1 +
      Copy(TSynMemo(PopUpMnu.PopupComponent).Text,
      TSynMemo(PopUpMnu.PopupComponent).SelEnd,
      Length(TSynMemo(PopUpMnu.PopupComponent).Text));
  end;
end;

end.

