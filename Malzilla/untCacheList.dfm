object frmCacheList: TfrmCacheList
  Left = 340
  Top = 183
  Width = 500
  Height = 545
  Caption = 'Cache list'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object lbCacheList: TListBox
    Left = 0
    Top = 0
    Width = 492
    Height = 488
    Align = alClient
    ItemHeight = 13
    TabOrder = 0
    OnDblClick = lbCacheListDblClick
  end
  object Panel1: TPanel
    Left = 0
    Top = 488
    Width = 492
    Height = 30
    Align = alBottom
    TabOrder = 1
    DesignSize = (
      492
      30)
    object cbStayOnTop: TTntCheckBox
      Left = 8
      Top = 5
      Width = 97
      Height = 17
      Anchors = [akLeft, akBottom]
      Caption = 'Stay on top'
      TabOrder = 0
      OnClick = cbStayOnTopClick
    end
  end
end
