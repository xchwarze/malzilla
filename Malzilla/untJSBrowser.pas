unit untJSBrowser;

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
 * The Original Code is JavaScript Bridge Demo1.
 *
 * The Initial Developer of the Original Code is
 * Theo Lustenberger <theo@theo.ch>.
 * Portions created by the Initial Developer are Copyright (C) 2003
 * the Initial Developer. All Rights Reserved.
 *
 * Contributor(s):
 *   Dave Murray <irongut@vodafone.net>
 *   Dominique Louis <dominique@savagesoftware.com.au>
 *   Spasic Boban <spasic@gmail.com>
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
 * ***** END LICENSE BLOCK ***** *)}

interface

{$J+}

uses
  js15decl, jsintf, Classes, SynUnicode, Messages, Windows, Forms;

var
  GlobWriteObj: TWideStrings;

type
  TBrowserBase = class
  private
    fengine: TJSEngine;
    fStatus: widestring;
    fDebuger: Boolean;
    fOnStatus: TNotifyEvent;
    eval_replace: WideString;
    procedure setWriteObj(Strings: TWideStrings);
  protected
  public
    constructor Create;
    destructor Destroy; override;
    procedure CreateObjects;
    procedure GarbageCollect;
    procedure DoDebug;
    function RunScript(Script: widestring): boolean;
    procedure SetStatus(StatusText: widestring);
    procedure SetEvalReplace(s: WideString);
    property Status: widestring read fStatus;
    property WriteObj: TWideStrings write setWriteObj;
    property OnStatus: TNotifyEvent read fOnStatus write fOnStatus;
  published
  end;

type
  TMyShowMessage = class
  private
    FMessage: WideString;
  public
    property Message: WideString read FMessage write FMessage;
    procedure ShowTheMessage;
  end;

var
  GlobBrowserBase: TBrowserBase;
  eval_replace: WideString;
const
  my_def: JSClass = (name: 'my'; flags: JSCLASS_HAS_PRIVATE; addProperty:
    JS_PropertyStub;
    delProperty: JS_PropertyStub; getProperty: JS_PropertyStub; setProperty:
    JS_PropertyStub;
    enumerate: JS_EnumerateStub; resolve: JS_ResolveStub; convert:
    JS_ConvertStub;
    finalize: JS_FinalizeStub);

function BR_write(cx: PJSContext; obj: PJSObject; argc: uintN; argv, rval:
  pjsval): JSBool; cdecl;
function BR_writeln(cx: PJSContext; obj: PJSObject; argc: uintN; argv, rval:
  pjsval): JSBool; cdecl;
function BR_open(cx: PJSContext; obj: PJSObject; argc: uintN; argv, rval:
  pjsval): JSBool; cdecl;
function BR_alert(cx: PJSContext; obj: PJSObject; argc: uintN; argv, rval:
  pjsval): JSBool; cdecl;
function BR_prompt(cx: PJSContext; obj: PJSObject; argc: uintN; argv, rval:
  pjsval): JSBool; cdecl;
function BR_Set_Status(cx: PJSContext; obj: PJSObject; id: jsval; vp: pjsval):
  JSBool; cdecl;
function BR_Get_Status(cx: PJSContext; obj: PJSObject; id: jsval; vp: pjsval):
  JSBool; cdecl;

implementation

uses
  Dialogs, SysUtils;

function BooleanToStr(Value: Boolean): string;
begin
  if Value then
    Result := 'true'
  else
    Result := 'false';
end;

procedure TMyShowMessage.ShowTheMessage;
begin
  Windows.MessageBoxW(0, PWideChar(FMessage),
    PWideChar(WideString(Application.Title)),
    MB_OK or MB_ICONWARNING);
end;

constructor TBrowserBase.Create;
begin
  fEngine := TJSEngine.Create(400000);
  GlobBrowserBase := Self;
  eval_replace := '';
  fDebuger := False;
end;

destructor TBrowserBase.Destroy;
begin
  fEngine.Free;
  inherited;
end;

procedure TBrowserBase.DoDebug;
begin
  fDebuger := True;
end;

function TBrowserBase.RunScript(Script: widestring): boolean;
var
  MyShowMessage: TMyShowMessage;
begin
  try
    if fDebuger then
    begin
      fengine.StartDebugger;
      fEngine.Debugger.Initialize;
      fEngine.Debugger.SetCode(Script);
    end;
    result := fEngine.global.Evaluate(Script);
  except on e: exception do
    begin
      MyShowMessage := TMyShowMessage.Create;
      try
        MyShowMessage.Message := ('Some violation occured' + #13#10 +
          'in SpiderMonkey engine');
        TThread.Synchronize(nil, MyShowMessage.ShowTheMessage);
      finally
        MyShowMessage.Free;
      end;
      Result := False;
    end;
  end;
end;

procedure TBrowserBase.SetEvalReplace(s: WideString);
begin
  eval_replace := s;
end;

procedure TBrowserBase.setWriteObj(Strings: TWideStrings);
begin
  GlobWriteObj := Strings;
end;

procedure TBrowserBase.CreateObjects;
var
  doc, wind: TJSObject;
  myfuncs: TJSFunctionSpecArray;
  myprops: TJSPropertySpecArray;
  global: TJSObject;
begin
  global := fEngine.Global;

  if eval_replace <> '' then
    //if frmMain.cbReplaceEval.Checked and (frmMain.edReplaceEval.Text <> '') then
    global.AddMethod(eval_replace, BR_write, 1);
  // 0.9.2 replace all eval() with evla() function,
  // which will redirect to the same effect like document.write()

  doc := global.AddObject(my_def, 'document');
  SetLength(myfuncs, 3);
  myfuncs[0].name := 'writeln';
  myfuncs[0].call := BR_writeln;
  myfuncs[0].nargs := 1;
  myfuncs[1].name := 'write';
  myfuncs[1].call := BR_write;
  myfuncs[1].nargs := 1;
  myfuncs[2].name := 'open';
  myfuncs[2].call := BR_open;
  myfuncs[2].nargs := 0;
  doc.AddMethods(myfuncs);

  wind := global.AddObject(my_def, 'window');
  SetLength(myprops, 1);
  myprops[0].name := 'status';
  myprops[0].setter := BR_Set_Status;
  myprops[0].tinyid := 0;
  myprops[0].getter := BR_Get_Status;
  wind.AddProperties(myprops);

  SetLength(myfuncs, 2);
  myfuncs[0].name := 'alert';
  myfuncs[0].call := BR_alert;
  myfuncs[0].nargs := 1;
  myfuncs[1].name := 'prompt';
  myfuncs[1].call := BR_prompt;
  myfuncs[1].nargs := 2;
  wind.AddMethods(myfuncs);
end;

procedure TBrowserBase.GarbageCollect;
begin
  fEngine.GarbageCollect;
end;

procedure TBrowserBase.SetStatus(StatusText: widestring);
begin
  fStatus := StatusText;
  if assigned(onStatus) then
    onStatus(self);
end;

function BR_Set_Status(cx: PJSContext; obj: PJSObject; id: jsval; vp: pjsval):
  JSBool; cdecl;
begin
  GlobBrowserBase.SetStatus(JSStringToString(JSValToJSString(vp^)));
  Result := JS_TRUE;
end;

function BR_Get_Status(cx: PJSContext; obj: PJSObject; id: jsval; vp: pjsval):
  JSBool; cdecl;
begin
  vp^ := StringToJSVal(cx, Pwidechar(GlobBrowserBase.fStatus));
  Result := JS_TRUE;
end;

function BR_writeln(cx: PJSContext; obj: PJSObject; argc: uintN; argv, rval:
  pjsval): JSBool; cdecl;
begin
  rval^ := JSVAL_VOID;
  if Assigned(GlobWriteObj) then
  begin
    if JSValIsNull(argv^) then
      GlobWriteObj.Add('null')
    else if JSValIsVoid(argv^) then
      GlobWriteObj.Add('undefined')
    else if JSValIsString(argv^) then
      GlobWriteObj.Add(JSStringToString(JSValToJSString(argv^)))
    else if JSValIsInt(argv^) then
      GlobWriteObj.Add(IntToStr(JSValToInt(argv^)))
    else if JSValIsDouble(argv^) then
      GlobWriteObj.Add(FloatToStr(JSValToDouble(cx, argv^)))
    else if JSValIsBoolean(argv^) then
      GlobWriteObj.Add(BooleanToStr(JSValToBoolean(argv^)));
  end;
  Result := JS_TRUE;
end;

function BR_write(cx: PJSContext; obj: PJSObject; argc: uintN; argv, rval:
  pjsval): JSBool; cdecl;
begin
  rval^ := JSVAL_VOID;
  if Assigned(GlobWriteObj) then
  begin
    if JSValIsNull(argv^) then
      GlobWriteObj.Text := GlobWriteObj.Text + 'null';
    if JSValIsVoid(argv^) then
      GlobWriteObj.Text := GlobWriteObj.Text + 'undefined';
    if JSValIsString(argv^) then
      GlobWriteObj.Text := GlobWriteObj.Text +
        JSStringToString(JSValToJSString(argv^));
    if JSValIsInt(argv^) then
      GlobWriteObj.Text := GlobWriteObj.Text + IntToStr(JSValToInt(argv^));
    //if JSValIsNumber(argv^) then  //not finished
    if JSValIsDouble(argv^) then
      GlobWriteObj.Text := GlobWriteObj.Text + FloatToStr(JSValToDouble(cx,
        argv^));
    if JSValIsBoolean(argv^) then
      GlobWriteObj.Text := GlobWriteObj.Text +
        BooleanToStr(JSValToBoolean(argv^));
  end;
  Result := JS_TRUE;
end;

function BR_open(cx: PJSContext; obj: PJSObject; argc: uintN; argv, rval:
  pjsval): JSBool; cdecl;
begin
  rval^ := JSVAL_VOID;
  if Assigned(GlobWriteObj) then
    GlobWriteObj.clear;
  Result := JS_TRUE;
end;

function BR_alert(cx: PJSContext; obj: PJSObject; argc: uintN; argv, rval:
  pjsval): JSBool; cdecl;
var
  MyShowMessage: TMyShowMessage;
begin
  rval^ := JSVAL_VOID;
  MyShowMessage := TMyShowMessage.Create;
  try
    MyShowMessage.Message := (JSStringToString(JSValToJSString(argv^)));
    TThread.Synchronize(nil, MyShowMessage.ShowTheMessage);
  finally
    MyShowMessage.Free;
  end;
  Result := JS_TRUE;
end;

function BR_prompt(cx: PJSContext; obj: PJSObject; argc: uintN; argv, rval:
  pjsval): JSBool; cdecl;
var
  ResString, Mesg, Deflt: widestring;
  //strval: PJSString;
begin
  if (argc >= 1) and JSValIsString(argv^) then
  begin
    Mesg := JSStringToString(JSValToJSString(argv^));
    inc(argv);
  end;
  if (argc >= 2) and (not JSValIsNumber(argv^)) then
  begin
    Deflt := JSStringToString(JSValToJSString(argv^));
  end;
  ResString := InputBox('[JavaScript Application]', Mesg, Deflt);
  rval^ := jsval(JS_NewStringCopyZ(cx, PChar(ResString))) or JSVAL_STRING;
  Result := JS_TRUE;
end;
end.

