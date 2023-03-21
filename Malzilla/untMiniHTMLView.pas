unit untMiniHTMLView;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, HtmlPars, ExtCtrls, StdCtrls, Buttons, ComCtrls;

type
  TfrmMiniHTMLView = class(TForm)
  private
    { Private declarations }
    procedure OnHTMLParseError(const Info, Raw: string);
    procedure LabelClick(Sender: TObject);
  public
    { Public declarations }

    procedure SetHTML(txt: string);
    procedure Update;
  end;

var
  frmMiniHTMLView: TfrmMiniHTMLView;
  HTMLTxt: string;
implementation

{$R *.dfm}

procedure TfrmMiniHTMLView.SetHTML(txt: string);
begin
  HTMLTxt := txt;
end;

procedure TfrmMiniHTMLView.OnHTMLParseError(const Info, Raw: string);
begin
  MessageBox(Handle, PChar(Raw), PChar(Info), MB_OK);
end;

procedure TfrmMiniHTMLView.Update;
var
  s: string;
  j, i: integer;
  obj: TObject;
  HTMLTag: THTMLTag;
  HTMLParam: THTMLParam;
  HTMLParser: THTMLParser;
  CurrentFont: TFont;
  label1: TLabel;
  x, y: integer;
  OldFont: TFont;
  ignore: boolean;
  isTitle: boolean;
  isLink: boolean;
  Link: string;
  lastHeight: integer;
  Shape: TShape;
  PreFont: Boolean;

begin
  if HTMLParser = nil then
    HTMLParser := THTMLParser.Create;
  HTMLParser.OnHTMLParseError := OnHTMLParseError;
  HTMLParser.Memory.LoadFromFile(HTMLTxt);
  try
    HTMLParser.Execute;
  except on e: Exception do
      ShowMessage('HTML Parser could not parse this document');
  end;

  isTitle := false;
  isLink := false;
  PreFont := false;
  //ShowMessage('Debug point');
  // Clear Page
  for i := frmMiniHTMLView.ComponentCount downto 1 do
    frmMiniHTMLView.Components[i - 1].Free;

  // set Default font
  CurrentFont := TFont.Create;
  CurrentFont.Name := 'Times New Roman';
  CurrentFont.Size := 12;
  OldFont := TFont.Create;
  frmMiniHTMLView.Color := clWhite;
  LastHeight := abs(CurrentFont.Height);

  x := 2;
  y := 2;
  ignore := True;

  for i := 0 to HTMLParser.parsed.count - 1 do
  begin
    obj := HTMLParser.parsed[i];

    if obj.classtype = THTMLTag then
    begin
      HTMLTag := THTMLTag(obj);

      if SameText(HTMLTag.Name, 'H1') then
      begin
        OldFont.assign(CurrentFont);
        CurrentFont.Size := 24;
        CurrentFont.Style := [fsBold];
        LastHeight := abs(CurrentFont.Height);
      end;
      if SameText(HTMLTag.Name, '/H1') then
      begin
        y := y + LastHeight;
        x := 2;
        CurrentFont.assign(OldFont);
        y := y + abs(CurrentFont.Height);
        lastHeight := abs(CurrentFont.Height);
      end;

      if SameText(HTMLTag.Name, 'H2') then
      begin
        OldFont.assign(CurrentFont);
        CurrentFont.Size := 22;
        CurrentFont.Style := [fsBold];
        LastHeight := abs(CurrentFont.Height);
      end;
      if SameText(HTMLTag.Name, '/H2') then
      begin
        y := y + LastHeight;
        x := 2;
        CurrentFont.assign(OldFont);
        y := y + abs(CurrentFont.Height);
        lastHeight := abs(CurrentFont.Height);
      end;

      if SameText(HTMLTag.Name, 'H3') then
      begin
        OldFont.assign(CurrentFont);
        CurrentFont.Size := 20;
        CurrentFont.Style := [fsBold];
        LastHeight := abs(CurrentFont.Height);
      end;
      if SameText(HTMLTag.Name, '/H3') then
      begin
        y := y + LastHeight;
        x := 2;
        CurrentFont.assign(OldFont);
        y := y + abs(CurrentFont.Height);
        lastHeight := abs(CurrentFont.Height);
      end;

      if SameText(HTMLTag.Name, 'H4') then
      begin
        OldFont.assign(CurrentFont);
        CurrentFont.Size := 18;
        CurrentFont.Style := [fsBold];
        LastHeight := abs(CurrentFont.Height);
      end;
      if SameText(HTMLTag.Name, '/H4') then
      begin
        y := y + LastHeight;
        x := 2;
        CurrentFont.assign(OldFont);
        y := y + abs(CurrentFont.Height);
        lastHeight := abs(CurrentFont.Height);
      end;

      if SameText(HTMLTag.Name, 'H5') then
      begin
        OldFont.assign(CurrentFont);
        CurrentFont.Size := 16;
        CurrentFont.Style := [fsBold];
        LastHeight := abs(CurrentFont.Height);
      end;
      if SameText(HTMLTag.Name, '/H5') then
      begin
        y := y + LastHeight;
        x := 2;
        CurrentFont.assign(OldFont);
        y := y + abs(CurrentFont.Height);
        lastHeight := abs(CurrentFont.Height);
      end;

      if SameText(HTMLTag.Name, 'H6') then
      begin
        OldFont.assign(CurrentFont);
        CurrentFont.Size := 14;
        CurrentFont.Style := [fsBold];
        LastHeight := abs(CurrentFont.Height);
      end;
      if SameText(HTMLTag.Name, '/H6') then
      begin
        y := y + LastHeight;
        x := 2;
        CurrentFont.assign(OldFont);
        y := y + abs(CurrentFont.Height);
        lastHeight := abs(CurrentFont.Height);
      end;

      if SameText(HTMLTag.Name, 'BR') then
      begin
        y := y + LastHeight;
        lastHeight := abs(CurrentFont.Height);
        x := 2;
      end;

      if SameText(HTMLTag.Name, 'B') then
        CurrentFont.style := CurrentFont.style + [fsBold];
      if SameText(HTMLTag.Name, '/B') then
        CurrentFont.style := CurrentFont.style - [fsBold];

      if SameText(HTMLTag.Name, 'TITLE') then
        isTitle := true;
      if SameText(HTMLTag.Name, '/TITLE') then
        isTitle := false;

      if SameText(HTMLTag.Name, 'HR') then
      begin
        y := y + LastHeight + Lastheight div 2;
        x := 2;
        LastHeight := abs(CurrentFont.Height);
        Shape := TShape.Create(frmMiniHTMLView);
        Shape.Top := y;
        Shape.Parent := frmMiniHTMLView;
        shape.Left := x;
        Shape.Height := 3;
        Shape.Width := frmMiniHTMLView.clientwidth - 20;
        Shape.Pen.Color := clGray;
        y := y + SHape.Height + Lastheight div 2;
      end;

      if SameText(HTMLTag.Name, 'BODY') then
      begin
        ignore := false;
        {if HTMLTag.Params <> nil then
          for j := 0 to HTMLTag.Params.count - 1 do
          begin
            HTMLParam := HTMLTag.Params[j];
            if SameText(HTMLParam.Key, 'BGCOLOR') then
            begin
              s := HTMLParam.Value;
              if s[1] = '#' then
                s[1] := '$';
              frmMiniHTMLView.Color := StrToIntDef(s, clWhite);
            end;
          end; }
      end;

      if SameText(HTMLTag.Name, 'PRE') then
      begin
        x := 2;
        y := y + LastHeight;
        PreFont := true;
      end;

      if SameText(HTMLTag.Name, '/PRE') then
      begin
        x := 2;
        y := y + LastHeight;
        LastHeight := abs(CurrentFont.Height);
        PreFont := false;
      end;

      if SameText(HTMLTag.Name, 'SCRIPT') then
        ignore := True;

      if SameText(HTMLTag.Name, '/SCRIPT') then
        ignore := False;

      if SameText(HTMLTag.Name, 'STYLE') then
        ignore := True;

      if SameText(HTMLTag.Name, '/STYLE') then
        ignore := False;

      if SameText(HTMLTag.Name, 'A') then
      begin
        isLink := true;
        Link := '';
        if HTMLTag.Params <> nil then
          for j := 0 to HTMLTag.Params.count - 1 do
          begin
            HTMLParam := HTMLTag.Params[j];
            if SameText(HTMLParam.Key, 'HREF') then
              Link := HTMLParam.Value;
          end;
      end;

      if SameText(HTMLTag.Name, '/A') then
        isLink := false;

      if SameText(HTMLTag.Name, 'FONT') then
      begin
        OldFont.assign(CurrentFont);
        for j := 0 to HTMLTag.Params.count - 1 do
        begin
          HTMLParam := HTMLTag.Params[j];
          if SameText(HTMLParam.Key, 'FACE') then
            CurrentFont.Name := HTMLParam.Value;
        end;
      end;

      if SameText(HTMLTag.Name, '/FONT') then
      begin
        CurrentFont.assign(OldFont);
      end;

      if SameText(HTMLTag.Name, '/TR') then
      begin
        y := y + lastHeight;
        x := 2;
      end;

      if SameText(HTMLTag.Name, 'TH') then
      begin
        CurrentFont.style := CurrentFont.style + [fsBold];
      end;

      if SameText(HTMLTag.Name, '/TH') then
      begin
        x := x + 10;
        CurrentFont.style := CurrentFont.Style - [fsBold];
      end;

      if SameText(HTMLTag.Name, '/TD') then
      begin
        x := x + 10;
      end;

      if SameText(HTMLTag.Name, '/TABLE') then
      begin
        y := y + lastHeight;
        x := 2;
      end;

    end;

    if obj.classtype = THTMLText then
      if (not ignore) then
      begin
        try
          Label1 := TLabel.Create(frmMiniHTMLView);
          Label1.Parent := frmMiniHTMLView;
          Label1.WordWrap := true;
          Label1.Top := y;
          Label1.Left := x;
          Label1.Autosize := false;
          Label1.Width := frmMiniHTMLView.ClientWidth - 18;
          Label1.Caption := THTMLText(obj).Text;
          Label1.Font.assign(CurrentFont);
          //label1.Color:=clgreen;

          if PreFont then
          begin
            Label1.Font.Name := 'Courier';
            Label1.Font.Size := 10;
            Label1.Caption := THTMLText(obj).Text;
            Label1.WordWrap := false;
          end;

          if isLink then
          begin
            Label1.Font.Color := clBlue;
            Label1.Font.Style := [fsUnderline];
            Label1.OnClick := LabelClick;
            Label1.Cursor := crHandPoint;
            Label1.Hint := Link;
          end;

          s := Label1.Caption;
          (*while pos('&',s)>0 do s[pos('&',s)]:=#1;
          while pos(#1,s)>0 do begin
                                insert('&&',s,pos(#1,s));
                                delete(s,pos(#1,s),1);
                               end;   *)
          Label1.Caption := s;

          Label1.Autosize := true;
          x := x + Label1.Width;
          LastHeight := Label1.Height;
        except on e: Exception do
            ShowMessage('Wrong');
        end;
      end

      else if isTitle then
        frmMiniHTMLView.Caption := THTMLText(obj).Text;
  end;
  HTMLParser.Free;
  DeleteFile(HTMLTxt);
end;

procedure TfrmMiniHTMLView.LabelClick(Sender: TObject);
begin
  ShowMessage('Linking to "' + TLabel(Sender).Hint + '"');
end;
end.
