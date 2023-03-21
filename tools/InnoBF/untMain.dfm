object frmMain: TfrmMain
  Left = 192
  Top = 107
  BorderStyle = bsSingle
  Caption = 'Inno BF'
  ClientHeight = 391
  ClientWidth = 326
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  Menu = MainMenu1
  OldCreateOrder = False
  OnClose = FormClose
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object GroupBox1: TGroupBox
    Left = 8
    Top = 8
    Width = 153
    Height = 65
    Caption = 'Word length'
    TabOrder = 0
    object Label2: TLabel
      Left = 16
      Top = 16
      Width = 26
      Height = 13
      Caption = 'From:'
    end
    object Label3: TLabel
      Left = 80
      Top = 16
      Width = 16
      Height = 13
      Caption = 'To:'
    end
    object Edit1: TEdit
      Left = 16
      Top = 32
      Width = 41
      Height = 21
      AutoSelect = False
      ReadOnly = True
      TabOrder = 0
      Text = '1'
    end
    object UpDown1: TUpDown
      Left = 57
      Top = 32
      Width = 15
      Height = 21
      Associate = Edit1
      Min = 1
      Position = 1
      TabOrder = 1
      OnClick = UpDown1Click
    end
    object Edit2: TEdit
      Left = 80
      Top = 32
      Width = 41
      Height = 21
      AutoSelect = False
      ReadOnly = True
      TabOrder = 2
      Text = '3'
    end
    object UpDown2: TUpDown
      Left = 121
      Top = 32
      Width = 15
      Height = 21
      Associate = Edit2
      Min = 1
      Position = 3
      TabOrder = 3
      OnClick = UpDown2Click
    end
  end
  object btStart: TButton
    Left = 8
    Top = 224
    Width = 153
    Height = 25
    Caption = 'Start'
    Enabled = False
    TabOrder = 1
    OnClick = btStartClick
  end
  object btStop: TButton
    Left = 168
    Top = 224
    Width = 153
    Height = 25
    Caption = 'Stop'
    Enabled = False
    TabOrder = 2
    OnClick = btStopClick
  end
  object Memo1: TMemo
    Left = 8
    Top = 253
    Width = 313
    Height = 132
    ScrollBars = ssVertical
    TabOrder = 3
  end
  object GroupBox2: TGroupBox
    Left = 168
    Top = 8
    Width = 153
    Height = 121
    Caption = 'Char set'
    TabOrder = 4
    object cbNumbers: TCheckBox
      Left = 16
      Top = 24
      Width = 97
      Height = 17
      Caption = 'Numbers'
      TabOrder = 0
    end
    object cbUppercase: TCheckBox
      Left = 16
      Top = 48
      Width = 97
      Height = 17
      Caption = 'UPPERCASE'
      Checked = True
      State = cbChecked
      TabOrder = 1
    end
    object cbLower: TCheckBox
      Left = 16
      Top = 72
      Width = 97
      Height = 17
      Caption = 'lowercase'
      Checked = True
      State = cbChecked
      TabOrder = 2
    end
    object cbAll: TCheckBox
      Left = 16
      Top = 96
      Width = 97
      Height = 17
      Caption = 'All (incl. symbols)'
      TabOrder = 3
    end
  end
  object cbTurbo: TCheckBox
    Left = 8
    Top = 192
    Width = 57
    Height = 17
    Caption = 'Turbo'
    TabOrder = 5
  end
  object GroupBox3: TGroupBox
    Left = 8
    Top = 80
    Width = 153
    Height = 49
    Caption = 'First word'
    TabOrder = 6
    object Edit3: TEdit
      Left = 16
      Top = 20
      Width = 121
      Height = 21
      TabOrder = 0
    end
  end
  object GroupBox4: TGroupBox
    Left = 8
    Top = 136
    Width = 153
    Height = 49
    Caption = 'Current word'
    TabOrder = 7
    object Label5: TLabel
      Left = 16
      Top = 20
      Width = 121
      Height = 21
      AutoSize = False
    end
  end
  object GroupBox5: TGroupBox
    Left = 168
    Top = 136
    Width = 153
    Height = 49
    Caption = 'Priority (0..2)'
    TabOrder = 8
    object Edit4: TEdit
      Left = 16
      Top = 20
      Width = 41
      Height = 21
      AutoSelect = False
      ReadOnly = True
      TabOrder = 0
      Text = '1'
    end
    object UpDown3: TUpDown
      Left = 57
      Top = 20
      Width = 15
      Height = 21
      Associate = Edit4
      Enabled = False
      Max = 2
      Position = 1
      TabOrder = 1
      OnClick = UpDown3Click
    end
  end
  object OpenDialog1: TOpenDialog
    Filter = 'Executables (*.exe)|*.exe'
    Left = 392
    Top = 8
  end
  object MainMenu1: TMainMenu
    Left = 432
    Top = 8
    object mnuFile: TMenuItem
      Caption = 'File'
      object mnuOpenFile: TMenuItem
        Caption = 'Open File'
        OnClick = mnuOpenFileClick
      end
      object N1: TMenuItem
        Caption = '-'
      end
      object mnuClose: TMenuItem
        Caption = 'Close'
        OnClick = mnuCloseClick
      end
    end
  end
end
