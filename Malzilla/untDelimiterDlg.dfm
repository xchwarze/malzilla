object frmDelimiterDlg: TfrmDelimiterDlg
  Left = 552
  Top = 292
  BorderStyle = bsDialog
  Caption = 'Choose delimiter'
  ClientHeight = 152
  ClientWidth = 257
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poMainFormCenter
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object lbExampleDelimited: TTntLabel
    Left = 12
    Top = 96
    Width = 233
    Height = 17
    AutoSize = False
  end
  object comboDelimiter: TTntComboBox
    Left = 8
    Top = 16
    Width = 145
    Height = 21
    ItemHeight = 13
    ItemIndex = 0
    TabOrder = 0
    Text = '%u'
    OnChange = comboDelimiterChange
    Items.Strings = (
      '%u'
      '\u'
      '%'
      '0x'
      ',')
  end
  object rbPreDelimiter: TTntRadioButton
    Left = 8
    Top = 48
    Width = 233
    Height = 17
    Caption = 'Delimiter before the data member'
    Checked = True
    TabOrder = 1
    TabStop = True
    OnClick = rbPreDelimiterClick
  end
  object rbPostDelimiter: TTntRadioButton
    Left = 8
    Top = 72
    Width = 241
    Height = 17
    Caption = 'Delimiter after the data member'
    TabOrder = 2
    OnClick = rbPostDelimiterClick
  end
  object btDelimitDlgOK: TTntButton
    Left = 91
    Top = 120
    Width = 75
    Height = 21
    Caption = 'OK'
    TabOrder = 3
    OnClick = btDelimitDlgOKClick
  end
end
