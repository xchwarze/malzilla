object frmHTMLObjects: TfrmHTMLObjects
  Left = 739
  Top = 155
  Width = 312
  Height = 620
  Caption = 'HTML Objects'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  FormStyle = fsStayOnTop
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object sgHTMLObjects: TTntStringGrid
    Left = 0
    Top = 0
    Width = 304
    Height = 552
    Align = alClient
    ColCount = 3
    FixedCols = 0
    RowCount = 2
    Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goRangeSelect, goRowSelect]
    TabOrder = 0
    OnClick = sgHTMLObjectsClick
    OnDblClick = sgHTMLObjectsDblClick
  end
  object TntPanel1: TTntPanel
    Left = 0
    Top = 552
    Width = 304
    Height = 41
    Align = alBottom
    TabOrder = 1
    object TntLabel1: TTntLabel
      Left = 39
      Top = 16
      Width = 225
      Height = 13
      Alignment = taCenter
      Caption = 'Click to find, double-click to append to Decoder'
    end
  end
end
