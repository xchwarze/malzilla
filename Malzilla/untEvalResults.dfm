object frmEvalResults: TfrmEvalResults
  Left = 430
  Top = 236
  Width = 500
  Height = 545
  Caption = 'eval() results'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  PixelsPerInch = 96
  TextHeight = 13
  object Panel1: TPanel
    Left = 0
    Top = 477
    Width = 492
    Height = 41
    Align = alBottom
    TabOrder = 0
  end
  object lbEvalResults: TTntListBox
    Left = 0
    Top = 0
    Width = 492
    Height = 477
    Align = alClient
    ItemHeight = 13
    TabOrder = 1
    OnDblClick = lbEvalResultsDblClick
  end
end
