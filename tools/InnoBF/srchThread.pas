unit srchThread;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ComCtrls;

type
  MyThread = class(TThread)
  private

  protected
    procedure Execute; override;
    //procedure UpdateMain;
    procedure working;
    procedure stopped;
    procedure UpdateStatus;
  public
    procedure SetAlphabet(alph: string);
    procedure SetBounds(min, max: integer);
    procedure SetResume(flag: boolean; rWord: string);
    procedure Cancel;
    procedure UnCancel;
    procedure readKey;
  end;


implementation

{ Important: Methods and properties of objects in visual components can only be
  used in a method called using Synchronize, for example,

      Synchronize(UpdateCaption);

  and UpdateCaption could look like,

    procedure MyThread.UpdateCaption;
    begin
      Form1.Caption := 'Updated in a thread';
    end; }

{ MyThread }
uses untMain, untParse;

var
  alphabet: string;
  minBound: integer;
  maxBound: integer;
  resumeFlag: boolean;
  resumeWord: string;
  alphLength: integer;
  CancelOp: boolean;
  currPass: string;

procedure MyThread.SetAlphabet(alph: string);
begin
  alphabet := alph;
  alphLength := length(alphabet);
end;

procedure MyThread.SetBounds(min, max: integer);
begin
  minBound := min;
  maxBound := max;
end;

procedure MyThread.readKey;
var
  temp: string;
begin
  temp := untParse.readCryptKey;
  frmMain.Memo1.Lines.Add(temp);
end;

procedure MyThread.SetResume(flag: boolean; rWord: string);
begin
  resumeFlag := flag;
  resumeWord := rWord;
end;

procedure MyThread.Cancel;
begin
  CancelOp := true;
end;

procedure MyThread.UnCancel;
begin
  CancelOp := false;
end;

procedure MyThread.working;
begin
  frmMain.btStop.Enabled := true;
  frmMain.btStart.Enabled := false;
  frmMain.UpDown3.Enabled := true;
end;

procedure MyThread.stopped;
begin
  frmMain.btStop.Enabled := false;
  frmMain.btStart.Enabled := true;
  frmMain.Label5.Caption := currPass;
  frmMain.Edit3.Text := frmMain.Label5.Caption;
  frmMain.UpDown3.Enabled := false;
end;

procedure MyThread.UpdateStatus;
begin
  frmMain.Label5.Caption := currPass;
end;

procedure MyThread.execute;
var
  L: integer;
  I: integer;
  S: string;
  counter: integer;
  //priority: integer;
begin
  if alphLength > 0 then
  begin
    CancelOP := false;
    Synchronize(working);
    untParse.startAttack(FileName);
    for L := minBound to maxBound do // L is the length
    begin
      if CancelOP then break;
      SetLength(S, L); // S is the string
      for I := 1 to L do
        S[I] := alphabet[1];
      if ResumeFlag then
      begin
        SetLength(S, L); // S is the string
        for I := 1 to L do
          S[I] := ResumeWord[I];
        I := L;
        ResumeFlag := false;
      end;
      I := L;
      while (I >= 1) do
      begin
        case frmMain.UpDown3.Position of
          0: SetPriorityClass(GetCurrentProcess, IDLE_PRIORITY_CLASS);
          1: SetPriorityClass(GetCurrentProcess, NORMAL_PRIORITY_CLASS);
          2: SetPriorityClass(GetCurrentProcess, HIGH_PRIORITY_CLASS);
          3: SetPriorityClass(GetCurrentProcess, REALTIME_PRIORITY_CLASS);
        end;
        // Do something with the string
        currPass := S;
        if not (frmMain.cbTurbo.Checked) then
          Synchronize(UpdateStatus);
        //if frmMain.cbDebug.Checked then frmMain.Memo1.Lines.Add(S);
        if untParse.testPass(S) then
        begin
          frmMain.Memo1.Lines.Add('Password is: ' + S);
          CancelOp := true;
          Synchronize(Stopped);
        end;
        if CancelOP then break;
        // Find next one
        I := L;
        while ((I > 0) and (S[I] = alphabet[alphLength])) do
        begin
          S[I] := alphabet[1];
          Dec(I);
        end;
        if (I >= 1) then S[I] := alphabet[(pos(S[I], alphabet) + 1)];
      end;
    end;
    Synchronize(stopped);
    Synchronize(readKey);
  end;
end;

{procedure MyThread.Execute;
begin
  Synchronize(UpdateMain);
end;}
end.

