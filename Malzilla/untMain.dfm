object frmMain: TfrmMain
  Left = 218
  Top = 107
  Width = 1017
  Height = 801
  Caption = 'Malzilla by bobby'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnCloseQuery = FormCloseQuery
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object PageControl1: TTntPageControl
    Left = 0
    Top = 0
    Width = 1009
    Height = 774
    ActivePage = tsDownloader
    Align = alClient
    TabOrder = 0
    object tsDownloader: TTntTabSheet
      Caption = 'Download'
      object Splitter1: TSplitter
        Left = 0
        Top = 445
        Width = 1001
        Height = 3
        Cursor = crVSplit
        Align = alBottom
      end
      object PageControl4: TTntPageControl
        Left = 0
        Top = 27
        Width = 1001
        Height = 418
        ActivePage = tsBrowserASCII
        Align = alClient
        TabOrder = 0
        object tsBrowserASCII: TTntTabSheet
          Caption = 'Text'
          object mmBrowser: TSynMemo
            Left = 0
            Top = 0
            Width = 993
            Height = 307
            Align = alClient
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -13
            Font.Name = 'Courier New'
            Font.Style = []
            PopupMenu = PopUpMnu
            TabOrder = 0
            Gutter.Font.Charset = DEFAULT_CHARSET
            Gutter.Font.Color = clWindowText
            Gutter.Font.Height = -11
            Gutter.Font.Name = 'Courier New'
            Gutter.Font.Style = []
            Gutter.Visible = False
            Highlighter = SynWebHtmlSyn1
            Options = [eoAutoIndent, eoEnhanceEndKey, eoGroupUndo, eoRightMouseMovesCursor, eoShowScrollHint, eoSmartTabDelete, eoSmartTabs, eoTabsToSpaces, eoTrimTrailingSpaces]
            RightEdge = 0
            WordWrap = True
            OnChange = mmBrowserChange
          end
          object stbrStatusDownload: TStatusBar
            Left = 0
            Top = 369
            Width = 993
            Height = 21
            Panels = <>
            SimplePanel = True
          end
          object JvRollOut1: TJvRollOut
            Left = 0
            Top = 307
            Width = 993
            Height = 62
            Align = alBottom
            ButtonHeight = 5
            TabOrder = 2
            DesignSize = (
              993
              62)
            FAWidth = 993
            FAHeight = 62
            FCWidth = 22
            FCHeight = 7
            object btSendScript: TTntButton
              Left = 17
              Top = 8
              Width = 145
              Height = 21
              Hint = 'Hold CTRL to send to new Decoder tab'
              Caption = 'Send script to Decoder'
              ParentShowHint = False
              ShowHint = True
              TabOrder = 0
              OnClick = btSendScriptClick
            end
            object btFindNextObject: TTntButton
              Left = 17
              Top = 36
              Width = 145
              Height = 21
              Caption = 'Find objects'
              TabOrder = 1
              OnClick = btFindNextObjectClick
            end
            object btSendAllToDecoder: TTntButton
              Left = 193
              Top = 8
              Width = 145
              Height = 21
              Hint = 'Hold CTRL to send to new Decoder tab'
              Caption = 'Send all scripts to Decoder'
              ParentShowHint = False
              ShowHint = True
              TabOrder = 2
              OnClick = btSendAllToDecoderClick
            end
            object btAddSelectionToDecoder: TTntButton
              Left = 193
              Top = 36
              Width = 145
              Height = 21
              Caption = 'Append selection to Decoder'
              TabOrder = 3
              OnClick = btAddSelectionToDecoderClick
            end
            object btSendToHTMLParser: TTntButton
              Left = 369
              Top = 8
              Width = 145
              Height = 21
              Caption = 'Send to Links Parser'
              TabOrder = 4
              OnClick = btSendToHTMLParserClick
            end
            object edFind: TTntEdit
              Left = 693
              Top = 8
              Width = 140
              Height = 21
              Anchors = [akTop, akRight]
              TabOrder = 5
              OnChange = edFindChange
              OnKeyUp = edFindKeyUp
            end
            object btFind: TTntButton
              Left = 865
              Top = 8
              Width = 100
              Height = 21
              Anchors = [akTop, akRight]
              Caption = 'Find'
              TabOrder = 6
              OnClick = btFindClick
            end
            object btFormatHTML: TTntButton
              Left = 865
              Top = 36
              Width = 100
              Height = 21
              Anchors = [akTop, akRight]
              Caption = 'Format code'
              TabOrder = 7
              OnClick = btFormatHTMLClick
            end
            object btMiniHTMLView: TButton
              Left = 368
              Top = 36
              Width = 145
              Height = 21
              Caption = 'Mini HTML view'
              TabOrder = 8
              OnClick = btMiniHTMLViewClick
            end
            object cbCaseSensitive: TTntCheckBox
              Left = 693
              Top = 32
              Width = 97
              Height = 17
              Anchors = [akTop, akRight]
              Caption = 'Case sensitive'
              TabOrder = 9
            end
          end
        end
        object tsBrowserHex: TTntTabSheet
          Caption = 'Hex'
          ImageIndex = 1
          object MPHexEditor2: TMPHexEditor
            Left = 0
            Top = 0
            Width = 993
            Height = 390
            Cursor = crIBeam
            Align = alClient
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -15
            Font.Name = 'Courier New'
            Font.Style = []
            ParentFont = False
            PopupMenu = PopUpMnuHex
            TabOrder = 0
            BytesPerRow = 16
            Translation = tkAsIs
            OffsetFormat = '-!10:0x|'
            Colors.Background = clWindow
            Colors.ChangedBackground = 11075583
            Colors.ChangedText = clMaroon
            Colors.CursorFrame = clNavy
            Colors.Offset = clBlack
            Colors.OddColumn = clBlue
            Colors.EvenColumn = clNavy
            Colors.CurrentOffsetBackground = clBtnShadow
            Colors.OffsetBackGround = clBtnFace
            Colors.CurrentOffset = clBtnHighlight
            Colors.Grid = clBtnFace
            Colors.NonFocusCursorFrame = clAqua
            Colors.ActiveFieldBackground = clWindow
            FocusFrame = True
            DrawGridLines = False
            Version = 'May 24, 2006; '#169' markus stephany, vcl[at]mirkes[dot]de'
          end
        end
        object tsCookies: TTntTabSheet
          Caption = 'Cookies'
          ImageIndex = 2
          object mmCookies: TSynMemo
            Left = 0
            Top = 0
            Width = 993
            Height = 390
            Align = alClient
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -13
            Font.Name = 'Courier New'
            Font.Style = []
            PopupMenu = PopUpMnu
            TabOrder = 0
            Gutter.Font.Charset = DEFAULT_CHARSET
            Gutter.Font.Color = clWindowText
            Gutter.Font.Height = -11
            Gutter.Font.Name = 'Courier New'
            Gutter.Font.Style = []
            Gutter.Visible = False
            Options = [eoAutoIndent, eoDragDropEditing, eoEnhanceEndKey, eoGroupUndo, eoShowScrollHint, eoSmartTabDelete, eoSmartTabs, eoTabsToSpaces]
            RightEdge = 0
            WordWrap = True
          end
        end
        object tsHTMLParser: TTntTabSheet
          Caption = 'Links Parser'
          ImageIndex = 8
          object Panel22: TPanel
            Left = 0
            Top = 336
            Width = 993
            Height = 54
            Align = alBottom
            TabOrder = 1
            DesignSize = (
              993
              54)
            object Label22: TTntLabel
              Left = 17
              Top = 8
              Width = 48
              Height = 13
              Caption = 'URI base:'
            end
            object edURIBase: TTntEdit
              Left = 17
              Top = 26
              Width = 608
              Height = 21
              Anchors = [akLeft, akTop, akRight]
              TabOrder = 0
            end
            object btLinkParserSort: TTntButton
              Left = 654
              Top = 26
              Width = 100
              Height = 21
              Caption = 'Sort'
              TabOrder = 1
              OnClick = btLinkParserSortClick
            end
          end
          object PageControl2: TTntPageControl
            Left = 0
            Top = 0
            Width = 993
            Height = 336
            ActivePage = tsHTMLRemote
            Align = alClient
            TabOrder = 0
            object tsHTMLRemote: TTntTabSheet
              Caption = 'Links'
              object mmHTMLRemote: TSynMemo
                Left = 0
                Top = 0
                Width = 985
                Height = 308
                Align = alClient
                Font.Charset = DEFAULT_CHARSET
                Font.Color = clWindowText
                Font.Height = -13
                Font.Name = 'Courier New'
                Font.Style = []
                PopupMenu = PopUpMnu
                TabOrder = 0
                Gutter.Font.Charset = DEFAULT_CHARSET
                Gutter.Font.Color = clWindowText
                Gutter.Font.Height = -11
                Gutter.Font.Name = 'Courier New'
                Gutter.Font.Style = []
                Gutter.Visible = False
                Options = [eoAutoIndent, eoEnhanceEndKey, eoGroupUndo, eoRightMouseMovesCursor, eoShowScrollHint, eoSmartTabDelete, eoSmartTabs, eoTabsToSpaces, eoTrimTrailingSpaces]
                RightEdge = 0
                SelectionMode = smLine
              end
            end
            object tsIFrames: TTntTabSheet
              Caption = 'IFrames'
              ImageIndex = 2
              object mmIFrames: TSynMemo
                Left = 0
                Top = 0
                Width = 985
                Height = 308
                Align = alClient
                Font.Charset = DEFAULT_CHARSET
                Font.Color = clWindowText
                Font.Height = -13
                Font.Name = 'Courier New'
                Font.Style = []
                PopupMenu = PopUpMnu
                TabOrder = 0
                Gutter.Font.Charset = DEFAULT_CHARSET
                Gutter.Font.Color = clWindowText
                Gutter.Font.Height = -11
                Gutter.Font.Name = 'Courier New'
                Gutter.Font.Style = []
                Gutter.Visible = False
                Options = [eoAutoIndent, eoEnhanceEndKey, eoGroupUndo, eoRightMouseMovesCursor, eoShowScrollHint, eoSmartTabDelete, eoSmartTabs, eoTabsToSpaces, eoTrimTrailingSpaces]
                RightEdge = 0
                SelectionMode = smLine
              end
            end
          end
        end
      end
      object Panel5: TPanel
        Left = 0
        Top = 448
        Width = 1001
        Height = 298
        Align = alBottom
        TabOrder = 1
        object mmHTTP: TTntMemo
          Left = 1
          Top = 1
          Width = 999
          Height = 154
          Align = alClient
          ScrollBars = ssVertical
          TabOrder = 0
        end
        object stbrHTTP: TStatusBar
          Left = 1
          Top = 155
          Width = 999
          Height = 21
          Panels = <>
        end
        object JvRollOut2: TJvRollOut
          Left = 1
          Top = 176
          Width = 999
          Height = 121
          Align = alBottom
          ButtonHeight = 5
          TabOrder = 2
          FAWidth = 145
          FAHeight = 121
          FCWidth = 22
          FCHeight = 7
          object lblURL: TTntLabel
            Left = 69
            Top = 12
            Width = 25
            Height = 13
            Alignment = taRightJustify
            Caption = 'URL:'
          end
          object lblUA: TTntLabel
            Left = 39
            Top = 42
            Width = 56
            Height = 13
            Alignment = taRightJustify
            Caption = 'User Agent:'
          end
          object lblReferre: TTntLabel
            Left = 53
            Top = 71
            Width = 41
            Height = 13
            Alignment = taRightJustify
            Caption = 'Referrer:'
          end
          object lblCookies: TTntLabel
            Left = 53
            Top = 101
            Width = 41
            Height = 13
            Alignment = taRightJustify
            Caption = 'Cookies:'
          end
          object edURL: TTntComboBox
            Left = 102
            Top = 8
            Width = 530
            Height = 21
            ItemHeight = 13
            TabOrder = 0
            OnDblClick = edURLDblClick
            OnExit = edURLExit
            OnKeyUp = edURLKeyUp
          end
          object comboUserAgent: TTntComboBox
            Left = 102
            Top = 37
            Width = 530
            Height = 21
            ItemHeight = 13
            TabOrder = 1
            OnEnter = comboUserAgentEnter
          end
          object edReferrer: TTntEdit
            Left = 102
            Top = 66
            Width = 530
            Height = 21
            TabOrder = 2
            OnKeyUp = edReferrerKeyUp
          end
          object edCookies: TTntEdit
            Left = 102
            Top = 96
            Width = 530
            Height = 21
            TabOrder = 3
          end
          object btGetThreaded: TTntButton
            Left = 654
            Top = 8
            Width = 100
            Height = 21
            Hint = 
              'Hold CTRL for FTP LIST Command. Hold SHIFT if URL ends with whit' +
              'espace'
            Caption = 'Get'
            ParentShowHint = False
            ShowHint = True
            TabOrder = 4
            OnClick = btGetThreadedClick
          end
          object btGetToFile: TTntButton
            Left = 654
            Top = 37
            Width = 100
            Height = 21
            Caption = 'Get to file'
            TabOrder = 5
            OnClick = btGetToFileClick
          end
          object cbUserAgent: TTntCheckBox
            Left = 654
            Top = 69
            Width = 102
            Height = 19
            Caption = 'Use User Agent'
            TabOrder = 6
          end
          object cbUseCookies: TTntCheckBox
            Left = 654
            Top = 98
            Width = 102
            Height = 19
            Caption = 'Use Cookies'
            TabOrder = 7
          end
          object btAbort: TTntButton
            Left = 789
            Top = 8
            Width = 100
            Height = 21
            Caption = 'Abort'
            TabOrder = 8
            OnClick = btAbortClick
          end
          object btLoadFromCache: TTntButton
            Left = 789
            Top = 37
            Width = 100
            Height = 21
            Caption = 'Load from Cache'
            TabOrder = 9
            OnClick = btLoadFromCacheClick
          end
          object cbUseProxy: TTntCheckBox
            Left = 789
            Top = 69
            Width = 102
            Height = 19
            Caption = 'Use Proxy'
            TabOrder = 10
          end
          object cbUseReferrer: TTntCheckBox
            Left = 789
            Top = 98
            Width = 92
            Height = 17
            Caption = 'Use Referrer'
            TabOrder = 11
          end
          object cbAutoReferrer: TTntCheckBox
            Left = 877
            Top = 69
            Width = 108
            Height = 19
            Caption = 'Auto-set Referrer'
            TabOrder = 12
            OnClick = cbAutoReferrerClick
          end
          object cbAutoRedirect: TTntCheckBox
            Left = 877
            Top = 98
            Width = 102
            Height = 19
            Caption = 'Auto-redirect'
            TabOrder = 13
            OnClick = cbAutoRedirectClick
          end
        end
      end
      object tbDownloaderTabs: TTntTabControl
        Left = 0
        Top = 0
        Width = 1001
        Height = 27
        Align = alTop
        ParentShowHint = False
        PopupMenu = PopUpMnuDownloaderTabs
        ShowHint = False
        TabOrder = 2
        Tabs.Strings = (
          'New Tab (1)')
        TabIndex = 0
        OnChange = tbDownloaderTabsChange
        OnChanging = tbDownloaderTabsChanging
      end
    end
    object tsDecoder: TTntTabSheet
      Caption = 'Decoder'
      ImageIndex = 1
      object Splitter2: TSplitter
        Left = 0
        Top = 440
        Width = 1001
        Height = 3
        Cursor = crVSplit
        Align = alBottom
      end
      object Panel2: TPanel
        Left = 0
        Top = 27
        Width = 1001
        Height = 413
        Align = alClient
        TabOrder = 0
        object splTemplate: TTntSplitter
          Left = 876
          Top = 1
          Height = 330
          Align = alRight
          Visible = False
        end
        object Panel3: TPanel
          Left = 1
          Top = 331
          Width = 999
          Height = 81
          Align = alBottom
          TabOrder = 1
          DesignSize = (
            999
            81)
          object Label24: TTntLabel
            Left = 562
            Top = 55
            Width = 3
            Height = 13
            Anchors = [akTop, akRight]
          end
          object btRunScript: TTntButton
            Left = 17
            Top = 8
            Width = 100
            Height = 21
            Caption = 'Run script'
            TabOrder = 0
            OnClick = btRunScriptClick
          end
          object btWide2UCS2: TTntButton
            Left = 875
            Top = 8
            Width = 100
            Height = 21
            Anchors = [akTop, akRight]
            Caption = 'Wide 2 UCS2'
            TabOrder = 1
            OnClick = btWide2UCS2Click
          end
          object btFind2: TTntButton
            Left = 458
            Top = 8
            Width = 100
            Height = 21
            Anchors = [akTop, akRight]
            Caption = 'Find'
            TabOrder = 2
            OnClick = btFind2Click
          end
          object edFind2: TTntEdit
            Left = 562
            Top = 8
            Width = 140
            Height = 21
            Anchors = [akTop, akRight]
            TabOrder = 3
            OnChange = edFind2Change
            OnKeyUp = edFind2KeyUp
          end
          object btDebug: TTntButton
            Left = 17
            Top = 44
            Width = 100
            Height = 21
            Caption = 'Debug'
            TabOrder = 4
            OnClick = btDebugClick
          end
          object edReplaceEval: TTntEdit
            Left = 287
            Top = 8
            Width = 140
            Height = 21
            TabOrder = 5
          end
          object cbReplaceEval: TTntRadioButton
            Left = 169
            Top = 9
            Width = 118
            Height = 19
            Caption = 'Replace eval() with'
            TabOrder = 6
          end
          object cbOverrideEval: TTntRadioButton
            Left = 169
            Top = 32
            Width = 118
            Height = 19
            Caption = 'Override eval()'
            TabOrder = 7
          end
          object cbDoNotReplEval: TTntRadioButton
            Left = 169
            Top = 55
            Width = 118
            Height = 19
            Caption = 'Leave as is'
            Checked = True
            TabOrder = 8
            TabStop = True
          end
          object cbDontBotherMe: TTntCheckBox
            Left = 287
            Top = 55
            Width = 194
            Height = 19
            Caption = 'Do not bother me with messages'
            TabOrder = 9
          end
          object btFormatText: TTntButton
            Left = 736
            Top = 44
            Width = 100
            Height = 21
            Anchors = [akTop, akRight]
            Caption = 'Format code'
            TabOrder = 10
            OnClick = btFormatTextClick
          end
          object btShowEvalResults: TTntButton
            Left = 875
            Top = 44
            Width = 100
            Height = 21
            Anchors = [akTop, akRight]
            Caption = 'Show eval() results'
            TabOrder = 11
            OnClick = btShowEvalResultsClick
          end
          object btTemplate: TTntButton
            Left = 736
            Top = 8
            Width = 100
            Height = 21
            Anchors = [akTop, akRight]
            Caption = 'Templates'
            TabOrder = 12
            OnClick = btTemplateClick
          end
          object cbCaseSensitive2: TTntCheckBox
            Left = 562
            Top = 32
            Width = 97
            Height = 17
            Anchors = [akTop, akRight]
            Caption = 'Case sensitive'
            TabOrder = 13
          end
        end
        object mmScript: TSynMemo
          Left = 1
          Top = 1
          Width = 875
          Height = 330
          Align = alClient
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -13
          Font.Name = 'Courier New'
          Font.Style = []
          PopupMenu = PopUpMnu
          TabOrder = 0
          OnMouseUp = mmScriptMouseUp
          Gutter.Font.Charset = DEFAULT_CHARSET
          Gutter.Font.Color = clWindowText
          Gutter.Font.Height = -11
          Gutter.Font.Name = 'Courier New'
          Gutter.Font.Style = []
          Gutter.Visible = False
          Highlighter = SynWebEsSyn1
          MaxScrollWidth = 4096
          Options = [eoAutoIndent, eoAutoSizeMaxScrollWidth, eoEnhanceEndKey, eoGroupUndo, eoRightMouseMovesCursor, eoShowScrollHint, eoSmartTabDelete, eoSmartTabs, eoTabsToSpaces]
          RightEdge = 0
          WordWrap = True
          OnPaintTransient = mmScriptPaintTransient
        end
        object mmTemplates: TTntListBox
          Left = 879
          Top = 1
          Width = 121
          Height = 330
          Align = alRight
          ItemHeight = 13
          TabOrder = 2
          Visible = False
          OnDblClick = mmTemplatesDblClick
        end
      end
      object Panel1: TPanel
        Left = 0
        Top = 443
        Width = 1001
        Height = 303
        Align = alBottom
        TabOrder = 1
        object stbrStatus: TStatusBar
          Left = 1
          Top = 281
          Width = 999
          Height = 21
          Panels = <>
          SimplePanel = True
        end
        object mmResult: TSynMemo
          Left = 1
          Top = 1
          Width = 999
          Height = 280
          Align = alClient
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -13
          Font.Name = 'Courier New'
          Font.Style = []
          ParentShowHint = False
          PopupMenu = PopUpMnu
          ShowHint = False
          TabOrder = 0
          Gutter.Font.Charset = DEFAULT_CHARSET
          Gutter.Font.Color = clWindowText
          Gutter.Font.Height = -11
          Gutter.Font.Name = 'Courier New'
          Gutter.Font.Style = []
          Gutter.Visible = False
          Highlighter = SynWebHtmlSyn1
          Options = [eoAutoIndent, eoEnhanceEndKey, eoGroupUndo, eoShowScrollHint, eoSmartTabDelete, eoSmartTabs, eoTabsToSpaces]
          RightEdge = 0
          WordWrap = True
        end
      end
      object tbDecoderTabs: TTntTabControl
        Left = 0
        Top = 0
        Width = 1001
        Height = 27
        Align = alTop
        PopupMenu = PopUpMnuDecoderTabs
        TabOrder = 2
        Tabs.Strings = (
          'New Tab (1)')
        TabIndex = 0
        OnChange = tbDecoderTabsChange
        OnChanging = tbDecoderTabsChanging
      end
    end
    object tsMiscDecoders: TTntTabSheet
      Caption = 'Misc Decoders'
      ImageIndex = 4
      object Panel12: TPanel
        Left = 0
        Top = 592
        Width = 1001
        Height = 154
        Align = alBottom
        TabOrder = 1
        object Label4: TTntLabel
          Left = 153
          Top = 8
          Width = 116
          Height = 13
          Caption = 'Override default delimiter'
        end
        object Label5: TTntLabel
          Left = 700
          Top = 8
          Width = 37
          Height = 13
          Caption = 'Search:'
        end
        object Label6: TTntLabel
          Left = 700
          Top = 53
          Width = 43
          Height = 13
          Caption = 'Replace:'
        end
        object TntLabel1: TTntLabel
          Left = 840
          Top = 8
          Width = 46
          Height = 13
          Caption = 'XOR key:'
        end
        object edDelimiter: TTntEdit
          Left = 153
          Top = 26
          Width = 115
          Height = 21
          TabOrder = 3
        end
        object btDecodeDec: TTntButton
          Left = 17
          Top = 26
          Width = 110
          Height = 21
          Caption = 'Decode Dec (,)'
          TabOrder = 0
          OnClick = btDecodeDecClick
        end
        object btDecodeHex: TTntButton
          Left = 17
          Top = 62
          Width = 110
          Height = 21
          Caption = 'Decode Hex (%)'
          TabOrder = 1
          OnClick = btDecodeHexClick
        end
        object btDecodeUCS2: TTntButton
          Left = 17
          Top = 97
          Width = 110
          Height = 21
          Caption = 'Decode UCS2 (%u)'
          TabOrder = 2
          OnClick = btDecodeUCS2Click
        end
        object btDecodeMIME: TTntButton
          Left = 295
          Top = 62
          Width = 110
          Height = 21
          Caption = 'Decode Base64'
          TabOrder = 5
          OnClick = btDecodeMIMEClick
        end
        object btIncrease: TTntButton
          Left = 431
          Top = 25
          Width = 110
          Height = 21
          Caption = 'Increase'
          TabOrder = 6
          OnClick = btIncreaseClick
        end
        object btDecrease: TTntButton
          Left = 431
          Top = 61
          Width = 110
          Height = 21
          Caption = 'Decrease'
          TabOrder = 7
          OnClick = btDecreaseClick
        end
        object btUCS2ToHex: TTntButton
          Left = 566
          Top = 26
          Width = 110
          Height = 21
          Caption = 'UCS2 To Hex'
          TabOrder = 8
          OnClick = btUCS2ToHexClick
        end
        object edSearch: TTntEdit
          Left = 700
          Top = 26
          Width = 115
          Height = 21
          TabOrder = 11
        end
        object btHexToFile: TTntButton
          Left = 566
          Top = 62
          Width = 110
          Height = 21
          Caption = 'Hex To File'
          TabOrder = 9
          OnClick = btHexToFileClick
        end
        object edReplace: TTntEdit
          Left = 700
          Top = 71
          Width = 115
          Height = 21
          TabOrder = 12
        end
        object btReplace: TTntButton
          Left = 700
          Top = 106
          Width = 115
          Height = 21
          Caption = 'Replace'
          TabOrder = 13
          OnClick = btReplaceClick
        end
        object btTextToFile: TTntButton
          Left = 566
          Top = 97
          Width = 110
          Height = 21
          Caption = 'Text to file'
          TabOrder = 10
          OnClick = btTextToFileClick
        end
        object btDecodeJSEncode: TTntButton
          Left = 295
          Top = 26
          Width = 110
          Height = 21
          Caption = 'Decode JS.encode'
          TabOrder = 4
          OnClick = btDecodeJSEncodeClick
        end
        object btConcatenate: TTntButton
          Left = 295
          Top = 97
          Width = 110
          Height = 21
          Caption = 'Concatenate'
          TabOrder = 14
          OnClick = btConcatenateClick
        end
        object seIncrementStep: TJvSpinEdit
          Left = 429
          Top = 97
          Width = 110
          Height = 21
          Hint = 'Increment/Decrement step'
          Alignment = taRightJustify
          Decimal = 0
          MaxValue = 255.000000000000000000
          MinValue = -255.000000000000000000
          Value = 1.000000000000000000
          ParentShowHint = False
          PopupMenu = PopUpMnuIncrement
          ShowHint = True
          TabOrder = 15
        end
        object rbPreDelim: TRadioButton
          Left = 152
          Top = 62
          Width = 113
          Height = 17
          Caption = 'Predelimiter'
          Checked = True
          TabOrder = 16
          TabStop = True
        end
        object rbPostdelim: TRadioButton
          Left = 152
          Top = 97
          Width = 113
          Height = 17
          Caption = 'Postdelimiter'
          TabOrder = 17
        end
        object edXOR: TTntEdit
          Left = 840
          Top = 26
          Width = 115
          Height = 21
          TabOrder = 18
          OnKeyPress = edXORKeyPress
        end
        object btXOR: TTntButton
          Left = 840
          Top = 71
          Width = 115
          Height = 21
          Caption = 'XOR'
          TabOrder = 19
          OnClick = btXORClick
        end
      end
      object Panel13: TPanel
        Left = 0
        Top = 0
        Width = 1001
        Height = 592
        Align = alClient
        TabOrder = 0
        object PageControl6: TTntPageControl
          Left = 1
          Top = 1
          Width = 999
          Height = 590
          ActivePage = tsMiscText
          Align = alClient
          TabOrder = 0
          OnChange = tbChange
          object tsMiscText: TTntTabSheet
            Caption = 'Text'
            object mmMiscDec: TSynMemo
              Left = 0
              Top = 0
              Width = 991
              Height = 562
              Align = alClient
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -13
              Font.Name = 'Courier New'
              Font.Style = []
              PopupMenu = PopUpMnu
              TabOrder = 0
              Gutter.Font.Charset = DEFAULT_CHARSET
              Gutter.Font.Color = clWindowText
              Gutter.Font.Height = -11
              Gutter.Font.Name = 'Courier New'
              Gutter.Font.Style = []
              Gutter.Visible = False
              Options = [eoAutoIndent, eoEnhanceEndKey, eoGroupUndo, eoRightMouseMovesCursor, eoShowScrollHint, eoSmartTabDelete, eoSmartTabs]
              RightEdge = 0
              WordWrap = True
            end
          end
          object tsMixHex: TTntTabSheet
            Caption = 'Hex'
            object MPHexEditor3: TMPHexEditor
              Left = 0
              Top = 0
              Width = 991
              Height = 521
              Cursor = crIBeam
              Align = alClient
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -15
              Font.Name = 'Courier New'
              Font.Style = []
              ParentFont = False
              PopupMenu = PopUpMnuHex
              TabOrder = 0
              BytesPerRow = 16
              Translation = tkAsIs
              OffsetFormat = '-!10:0x|'
              Colors.Background = clWindow
              Colors.ChangedBackground = 11075583
              Colors.ChangedText = clMaroon
              Colors.CursorFrame = clNavy
              Colors.Offset = clBlack
              Colors.OddColumn = clBlue
              Colors.EvenColumn = clNavy
              Colors.CurrentOffsetBackground = clBtnShadow
              Colors.OffsetBackGround = clBtnFace
              Colors.CurrentOffset = clBtnHighlight
              Colors.Grid = clBtnFace
              Colors.NonFocusCursorFrame = clAqua
              Colors.ActiveFieldBackground = clWindow
              FocusFrame = True
              DrawGridLines = False
              Version = 'May 24, 2006; '#169' markus stephany, vcl[at]mirkes[dot]de'
            end
            object Panel4: TPanel
              Left = 0
              Top = 521
              Width = 991
              Height = 41
              Align = alBottom
              TabOrder = 1
              object cbMiscHexUnicode: TTntCheckBox
                Left = 17
                Top = 8
                Width = 80
                Height = 19
                Caption = 'Unicode'
                TabOrder = 0
                OnClick = cbMiscHexUnicodeClick
              end
              object cbMiscHexUnicodeBigEndian: TTntCheckBox
                Left = 109
                Top = 8
                Width = 132
                Height = 19
                Caption = 'Unicode Big Endian'
                TabOrder = 1
                OnClick = cbMiscHexUnicodeBigEndianClick
              end
              object cbMiscHexSwapNibbles: TTntCheckBox
                Left = 252
                Top = 8
                Width = 102
                Height = 19
                Caption = 'Swap Nibbles'
                TabOrder = 2
                OnClick = cbMiscHexSwapNibblesClick
              end
            end
          end
        end
      end
    end
    object tsKalimeroProcessor: TTntTabSheet
      Caption = 'Kalimero Processor'
      object Splitter8: TSplitter
        Left = 657
        Top = 0
        Height = 632
      end
      object Panel6: TPanel
        Left = 0
        Top = 632
        Width = 1001
        Height = 114
        Align = alBottom
        TabOrder = 0
        object btKalimeroStep1: TTntButton
          Left = 16
          Top = 16
          Width = 100
          Height = 21
          Caption = 'Detect'
          TabOrder = 0
          OnClick = btKalimeroStep1Click
        end
        object btKalimeroStep2: TTntButton
          Left = 664
          Top = 16
          Width = 100
          Height = 21
          Caption = 'Make'
          TabOrder = 1
          OnClick = btKalimeroStep2Click
        end
        object edKalimeroRegEx: TTntEdit
          Left = 16
          Top = 56
          Width = 289
          Height = 21
          TabOrder = 2
          Text = 'id=("?'#39'?[\w]+"?'#39'?)>((.)*?)<'
        end
        object edKalimeroReplace: TTntEdit
          Left = 664
          Top = 56
          Width = 329
          Height = 21
          TabOrder = 3
          Text = 'KalimeroName = new element("KalimeroName","KalimeroValue");'
        end
        object cbKalimeroEscapeCorrection: TTntCheckBox
          Left = 784
          Top = 16
          Width = 113
          Height = 17
          Caption = 'Escape correction'
          Checked = True
          State = cbChecked
          TabOrder = 4
        end
      end
      object Panel9: TPanel
        Left = 0
        Top = 0
        Width = 657
        Height = 632
        Align = alLeft
        TabOrder = 1
        object mmKalimero: TSynMemo
          Left = 1
          Top = 1
          Width = 655
          Height = 630
          Align = alClient
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -13
          Font.Name = 'Courier New'
          Font.Style = []
          PopupMenu = PopUpMnu
          TabOrder = 0
          Gutter.Font.Charset = DEFAULT_CHARSET
          Gutter.Font.Color = clWindowText
          Gutter.Font.Height = -11
          Gutter.Font.Name = 'Courier New'
          Gutter.Font.Style = []
          Gutter.Visible = False
          Highlighter = SynWebHtmlSyn1
          Options = [eoAutoIndent, eoEnhanceEndKey, eoGroupUndo, eoRightMouseMovesCursor, eoShowScrollHint, eoSmartTabDelete, eoSmartTabs, eoTabsToSpaces, eoTrimTrailingSpaces]
          RightEdge = 0
          WordWrap = True
        end
      end
      object Panel10: TPanel
        Left = 660
        Top = 0
        Width = 341
        Height = 632
        Align = alClient
        TabOrder = 2
        object sgKalimeroArray: TStringGrid
          Left = 1
          Top = 1
          Width = 339
          Height = 630
          Align = alClient
          ColCount = 2
          FixedCols = 0
          FixedRows = 0
          TabOrder = 0
        end
      end
    end
    object tsLibEmu: TTntTabSheet
      Caption = 'Shellcode analyzer'
      object Splitter9: TSplitter
        Left = 0
        Top = 453
        Width = 1001
        Height = 3
        Cursor = crVSplit
        Align = alBottom
      end
      object Panel30: TPanel
        Left = 0
        Top = 456
        Width = 1001
        Height = 290
        Align = alBottom
        TabOrder = 0
        object mmLibEmuOutput: TMemo
          Left = 1
          Top = 1
          Width = 999
          Height = 288
          Align = alClient
          ScrollBars = ssBoth
          TabOrder = 0
        end
      end
      object Panel31: TPanel
        Left = 0
        Top = 389
        Width = 1001
        Height = 64
        Align = alBottom
        TabOrder = 1
        DesignSize = (
          1001
          64)
        object btRunLibEmu: TTntButton
          Left = 17
          Top = 22
          Width = 110
          Height = 21
          Caption = 'Run emulation'
          TabOrder = 0
          OnClick = btRunLibEmuClick
        end
        object btLibEmuAbort: TButton
          Left = 880
          Top = 22
          Width = 100
          Height = 21
          Anchors = [akTop, akRight]
          Caption = 'Cancel'
          TabOrder = 1
          OnClick = btLibEmuAbortClick
        end
        object cbLibEmuGetPC: TTntCheckBox
          Left = 144
          Top = 24
          Width = 73
          Height = 17
          Caption = 'GetPC'
          TabOrder = 2
        end
      end
      object Panel34: TPanel
        Left = 0
        Top = 0
        Width = 1001
        Height = 389
        Align = alClient
        TabOrder = 2
        object hexLibEmuInput: TMPHexEditor
          Left = 1
          Top = 1
          Width = 999
          Height = 387
          Cursor = crIBeam
          Align = alClient
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -15
          Font.Name = 'Courier New'
          Font.Style = []
          ParentFont = False
          PopupMenu = PopUpMnuHex
          TabOrder = 0
          BytesPerRow = 16
          Translation = tkAsIs
          OffsetFormat = '-!10:0x|'
          Colors.Background = clWindow
          Colors.ChangedBackground = 11075583
          Colors.ChangedText = clMaroon
          Colors.CursorFrame = clNavy
          Colors.Offset = clBlack
          Colors.OddColumn = clBlue
          Colors.EvenColumn = clNavy
          Colors.CurrentOffsetBackground = clBtnShadow
          Colors.OffsetBackGround = clBtnFace
          Colors.CurrentOffset = clBtnHighlight
          Colors.Grid = clBtnFace
          Colors.NonFocusCursorFrame = clAqua
          Colors.ActiveFieldBackground = clWindow
          FocusFrame = True
          DrawGridLines = False
          Version = 'May 24, 2006; '#169' markus stephany, vcl[at]mirkes[dot]de'
        end
      end
    end
    object tsLog: TTntTabSheet
      Caption = 'Log'
      object mmLog: TSynMemo
        Left = 0
        Top = 0
        Width = 1001
        Height = 673
        Align = alClient
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'Courier New'
        Font.Style = []
        PopupMenu = PopUpMnu
        TabOrder = 0
        Gutter.Font.Charset = DEFAULT_CHARSET
        Gutter.Font.Color = clWindowText
        Gutter.Font.Height = -11
        Gutter.Font.Name = 'Courier New'
        Gutter.Font.Style = []
        Gutter.Visible = False
        Options = [eoAutoIndent, eoDragDropEditing, eoEnhanceEndKey, eoGroupUndo, eoShowScrollHint, eoSmartTabDelete, eoSmartTabs, eoTabsToSpaces]
        RightEdge = 0
        WordWrap = True
      end
      object TntPanel1: TTntPanel
        Left = 0
        Top = 673
        Width = 1001
        Height = 73
        Align = alBottom
        TabOrder = 1
      end
    end
    object tsListDownloader: TTntTabSheet
      Caption = 'Clipboard Monitor'
      ImageIndex = 7
      object Splitter4: TSplitter
        Left = 0
        Top = 442
        Width = 1001
        Height = 3
        Cursor = crVSplit
        Align = alBottom
      end
      object Panel19: TPanel
        Left = 0
        Top = 701
        Width = 1001
        Height = 45
        Align = alBottom
        TabOrder = 2
        DesignSize = (
          1001
          45)
        object Button1: TTntButton
          Left = 25
          Top = 8
          Width = 185
          Height = 21
          Caption = 'Send to Download tab'
          TabOrder = 0
          OnClick = Button1Click
        end
        object Button2: TTntButton
          Left = 234
          Top = 8
          Width = 185
          Height = 21
          Caption = 'Send to Download tab and get'
          TabOrder = 1
          OnClick = Button2Click
        end
        object btAbortDownloadAll: TTntButton
          Left = 789
          Top = 8
          Width = 145
          Height = 21
          Anchors = [akTop, akRight]
          Caption = 'Abort'
          TabOrder = 3
          OnClick = btAbortDownloadAllClick
        end
        object btListDownloadThreaded: TTntButton
          Left = 445
          Top = 8
          Width = 185
          Height = 21
          Caption = 'Download all'
          TabOrder = 2
          OnClick = btListDownloadThreadedClick
        end
      end
      object Panel20: TPanel
        Left = 0
        Top = 466
        Width = 1001
        Height = 235
        Align = alBottom
        TabOrder = 1
        object mmListDownloaderFinished: TSynMemo
          Left = 1
          Top = 1
          Width = 999
          Height = 233
          Align = alClient
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -13
          Font.Name = 'Courier New'
          Font.Style = []
          PopupMenu = PopUpMnu
          TabOrder = 0
          Gutter.Font.Charset = DEFAULT_CHARSET
          Gutter.Font.Color = clWindowText
          Gutter.Font.Height = -11
          Gutter.Font.Name = 'Courier New'
          Gutter.Font.Style = []
          Gutter.Visible = False
          Options = [eoAutoIndent, eoEnhanceEndKey, eoGroupUndo, eoRightMouseMovesCursor, eoShowScrollHint, eoSmartTabDelete, eoSmartTabs, eoTabsToSpaces, eoTrimTrailingSpaces]
          RightEdge = 0
          WordWrap = True
        end
      end
      object Panel21: TPanel
        Left = 0
        Top = 0
        Width = 1001
        Height = 442
        Align = alClient
        TabOrder = 0
        object mmListDownloaderPending: TListBox
          Left = 1
          Top = 1
          Width = 999
          Height = 440
          AutoComplete = False
          Align = alClient
          ItemHeight = 13
          MultiSelect = True
          PopupMenu = PopUpMnuClipMon
          TabOrder = 0
          OnDblClick = mmListDownloaderPendingDblClick
          OnExit = mmListDownloaderPendingExit
          OnKeyUp = mmListDownloaderPendingKeyUp
        end
      end
      object stbrListDownloader: TStatusBar
        Left = 0
        Top = 445
        Width = 1001
        Height = 21
        Panels = <>
        SimplePanel = True
      end
    end
    object tsNotes: TTntTabSheet
      Caption = 'Notes'
      ImageIndex = 2
      object Panel11: TPanel
        Left = 0
        Top = 0
        Width = 1001
        Height = 746
        Align = alClient
        TabOrder = 0
        object mmNotes: TSynMemo
          Left = 1
          Top = 1
          Width = 999
          Height = 744
          Align = alClient
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -13
          Font.Name = 'Courier New'
          Font.Style = []
          PopupMenu = PopUpMnu
          TabOrder = 0
          Gutter.Font.Charset = DEFAULT_CHARSET
          Gutter.Font.Color = clWindowText
          Gutter.Font.Height = -11
          Gutter.Font.Name = 'Courier New'
          Gutter.Font.Style = []
          Gutter.Visible = False
          Options = [eoAutoIndent, eoDragDropEditing, eoEnhanceEndKey, eoGroupUndo, eoShowScrollHint, eoSmartTabDelete, eoSmartTabs, eoTabsToSpaces]
          RightEdge = 0
          WordWrap = True
        end
      end
    end
    object tsHexView: TTntTabSheet
      Caption = 'Hex view'
      ImageIndex = 6
      object Splitter10: TSplitter
        Left = 0
        Top = 572
        Width = 1001
        Height = 4
        Cursor = crVSplit
        Align = alBottom
      end
      object MPHexEditor1: TMPHexEditor
        Left = 0
        Top = 0
        Width = 816
        Height = 531
        Cursor = crIBeam
        Align = alClient
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -15
        Font.Name = 'Courier New'
        Font.Style = []
        ParentFont = False
        PopupMenu = PopUpMnuHex
        TabOrder = 0
        BytesPerRow = 16
        Translation = tkAsIs
        OffsetFormat = '-!10:0x|'
        Colors.Background = clWindow
        Colors.ChangedBackground = 11075583
        Colors.ChangedText = clMaroon
        Colors.CursorFrame = clNavy
        Colors.Offset = clBlack
        Colors.OddColumn = clBlue
        Colors.EvenColumn = clNavy
        Colors.CurrentOffsetBackground = clBtnShadow
        Colors.OffsetBackGround = clBtnFace
        Colors.CurrentOffset = clBtnHighlight
        Colors.Grid = clBtnFace
        Colors.NonFocusCursorFrame = clAqua
        Colors.ActiveFieldBackground = clWindow
        FocusFrame = True
        DrawGridLines = False
        Version = 'May 24, 2006; '#169' markus stephany, vcl[at]mirkes[dot]de'
      end
      object Panel18: TPanel
        Left = 0
        Top = 531
        Width = 1001
        Height = 41
        Align = alBottom
        TabOrder = 1
        object cbHexUnicode: TTntCheckBox
          Left = 17
          Top = 8
          Width = 102
          Height = 19
          Caption = 'Unicode'
          TabOrder = 0
          OnClick = cbHexUnicodeClick
        end
        object cbHexUnicodeBig: TTntCheckBox
          Left = 109
          Top = 8
          Width = 168
          Height = 19
          Caption = 'Unicode Big Endian'
          TabOrder = 1
          OnClick = cbHexUnicodeBigClick
        end
        object cbHexSwapNibbles: TTntCheckBox
          Left = 252
          Top = 8
          Width = 102
          Height = 19
          Caption = 'Swap Nibbles'
          TabOrder = 2
          OnClick = cbHexSwapNibblesClick
        end
        object btHexDisasm: TTntButton
          Left = 400
          Top = 8
          Width = 100
          Height = 21
          Caption = 'Disassemble'
          TabOrder = 3
          OnClick = btHexDisasmClick
        end
      end
      object TntPanel2: TTntPanel
        Left = 816
        Top = 0
        Width = 185
        Height = 531
        Align = alRight
        TabOrder = 2
        object TntLabel4: TTntLabel
          Left = 8
          Top = 48
          Width = 67
          Height = 13
          Caption = 'Strings to find:'
        end
        object TntLabel5: TTntLabel
          Left = 56
          Top = 8
          Width = 66
          Height = 13
          Caption = 'Find XOR key'
        end
        object TntLabel6: TTntLabel
          Left = 8
          Top = 424
          Width = 21
          Height = 13
          Caption = 'Key:'
        end
        object TntLabel7: TTntLabel
          Left = 8
          Top = 272
          Width = 88
          Height = 13
          Caption = 'Max key to check:'
        end
        object lbXORString: TTntLabel
          Left = 8
          Top = 352
          Width = 65
          Height = 13
          Caption = 'Current string:'
        end
        object lbXORKey: TTntLabel
          Left = 8
          Top = 376
          Width = 57
          Height = 13
          Caption = 'Current key:'
        end
        object mmXORStrings: TTntMemo
          Left = 8
          Top = 64
          Width = 169
          Height = 201
          TabOrder = 0
        end
        object btBFXOR: TTntButton
          Left = 8
          Top = 320
          Width = 100
          Height = 21
          Caption = 'Find'
          TabOrder = 1
          OnClick = btBFXORClick
        end
        object edXORKey: TTntEdit
          Left = 8
          Top = 440
          Width = 121
          Height = 21
          TabOrder = 2
          OnKeyPress = edXORKeyKeyPress
        end
        object btApplyXor: TTntButton
          Left = 8
          Top = 472
          Width = 100
          Height = 21
          Caption = 'Apply XOR'
          TabOrder = 3
          OnClick = btApplyXorClick
        end
        object edXORKeyMAX: TTntEdit
          Left = 8
          Top = 288
          Width = 121
          Height = 21
          TabOrder = 4
          OnKeyPress = edXORKeyMAXKeyPress
        end
        object cbXORTurbo: TTntCheckBox
          Left = 8
          Top = 400
          Width = 97
          Height = 17
          Caption = 'Turbo'
          TabOrder = 5
          Visible = False
        end
      end
      object Panel35: TPanel
        Left = 0
        Top = 576
        Width = 1001
        Height = 170
        Align = alBottom
        TabOrder = 3
        object mmDisasm: TSynMemo
          Left = 1
          Top = 1
          Width = 999
          Height = 168
          Align = alClient
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -13
          Font.Name = 'Courier New'
          Font.Style = []
          TabOrder = 0
          Gutter.AutoSize = True
          Gutter.DigitCount = 6
          Gutter.Font.Charset = DEFAULT_CHARSET
          Gutter.Font.Color = clWindowText
          Gutter.Font.Height = -11
          Gutter.Font.Name = 'Courier New'
          Gutter.Font.Style = []
          Gutter.LeadingZeros = True
          Gutter.ShowLineNumbers = True
          Gutter.ZeroStart = True
          Gutter.LineNumberStart = 0
          RightEdge = 20
          ScrollBars = ssVertical
          OnGutterGetText = mmDisasmGutterGetText
        end
      end
    end
    object tsPScript: TTntTabSheet
      Caption = 'PScript'
      ImageIndex = 9
      object Panel25: TPanel
        Left = 0
        Top = 0
        Width = 1001
        Height = 636
        Align = alClient
        TabOrder = 0
        object Splitter5: TSplitter
          Left = 487
          Top = 1
          Height = 634
          Align = alRight
        end
        object Panel26: TPanel
          Left = 490
          Top = 1
          Width = 510
          Height = 634
          Align = alRight
          TabOrder = 1
          object Splitter6: TSplitter
            Left = 1
            Top = 338
            Width = 508
            Height = 3
            Cursor = crVSplit
            Align = alBottom
          end
          object Panel27: TPanel
            Left = 1
            Top = 341
            Width = 508
            Height = 292
            Align = alBottom
            TabOrder = 1
            object Label26: TTntLabel
              Left = 1
              Top = 1
              Width = 506
              Height = 13
              Align = alTop
              Alignment = taCenter
              Caption = 'Output data'
            end
            object mmPSOutputData: TSynMemo
              Left = 1
              Top = 14
              Width = 506
              Height = 277
              Align = alClient
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -13
              Font.Name = 'Courier New'
              Font.Style = []
              PopupMenu = PopUpMnu
              TabOrder = 0
              Gutter.Font.Charset = DEFAULT_CHARSET
              Gutter.Font.Color = clWindowText
              Gutter.Font.Height = -11
              Gutter.Font.Name = 'Courier New'
              Gutter.Font.Style = []
              Gutter.Visible = False
              Options = [eoAutoIndent, eoEnhanceEndKey, eoGroupUndo, eoRightMouseMovesCursor, eoShowScrollHint, eoSmartTabDelete, eoSmartTabs, eoTabsToSpaces, eoTrimTrailingSpaces]
              RightEdge = 0
              WordWrap = True
            end
          end
          object Panel28: TPanel
            Left = 1
            Top = 1
            Width = 508
            Height = 337
            Align = alClient
            TabOrder = 0
            object Label25: TTntLabel
              Left = 1
              Top = 1
              Width = 506
              Height = 13
              Align = alTop
              Alignment = taCenter
              Caption = 'Input data'
            end
            object mmPSInputData: TSynMemo
              Left = 1
              Top = 14
              Width = 506
              Height = 322
              Align = alClient
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -13
              Font.Name = 'Courier New'
              Font.Style = []
              PopupMenu = PopUpMnu
              TabOrder = 0
              Gutter.Font.Charset = DEFAULT_CHARSET
              Gutter.Font.Color = clWindowText
              Gutter.Font.Height = -11
              Gutter.Font.Name = 'Courier New'
              Gutter.Font.Style = []
              Gutter.Visible = False
              Options = [eoAutoIndent, eoEnhanceEndKey, eoGroupUndo, eoRightMouseMovesCursor, eoShowScrollHint, eoSmartTabDelete, eoSmartTabs, eoTabsToSpaces, eoTrimTrailingSpaces]
              RightEdge = 0
              WordWrap = True
            end
          end
        end
        object Panel29: TPanel
          Left = 1
          Top = 1
          Width = 486
          Height = 634
          Align = alClient
          TabOrder = 0
          object mmPScriptEditor: TSynMemo
            Left = 1
            Top = 1
            Width = 484
            Height = 632
            Align = alClient
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -13
            Font.Name = 'Courier New'
            Font.Style = []
            PopupMenu = PopUpMnu
            TabOrder = 0
            Gutter.Font.Charset = DEFAULT_CHARSET
            Gutter.Font.Color = clWindowText
            Gutter.Font.Height = -11
            Gutter.Font.Name = 'Courier New'
            Gutter.Font.Style = []
            Gutter.Visible = False
            Highlighter = SynPasSyn1
            Lines.WideStrings = 
              '{'#13#10'available functions:'#13#10'ReadDoc: string - read from Input data'#13 +
              #10'WriteDoc(s: string) - write (append) to Output data'#13#10'}'#13#10#13#10'//var' +
              #13#10#13#10'begin'#13#10'  {insert your code here}'#13#10'end.'
            Options = [eoAutoIndent, eoEnhanceEndKey, eoGroupUndo, eoRightMouseMovesCursor, eoShowScrollHint, eoSmartTabDelete, eoSmartTabs, eoTabsToSpaces, eoTrimTrailingSpaces]
            RightEdge = 0
            WordWrap = True
          end
        end
      end
      object Panel23: TPanel
        Left = 0
        Top = 677
        Width = 1001
        Height = 69
        Align = alBottom
        TabOrder = 2
        object mmPScriptDebug: TSynMemo
          Left = 1
          Top = 1
          Width = 999
          Height = 67
          Align = alClient
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -13
          Font.Name = 'Courier New'
          Font.Style = []
          PopupMenu = PopUpMnu
          TabOrder = 0
          Gutter.Font.Charset = DEFAULT_CHARSET
          Gutter.Font.Color = clWindowText
          Gutter.Font.Height = -11
          Gutter.Font.Name = 'Courier New'
          Gutter.Font.Style = []
          Gutter.Visible = False
          Options = [eoAutoIndent, eoEnhanceEndKey, eoGroupUndo, eoRightMouseMovesCursor, eoShowScrollHint, eoSmartTabDelete, eoSmartTabs, eoTabsToSpaces, eoTrimTrailingSpaces]
          RightEdge = 0
          WordWrap = True
        end
      end
      object Panel24: TPanel
        Left = 0
        Top = 636
        Width = 1001
        Height = 41
        Align = alBottom
        TabOrder = 1
        object btCompilePScript: TTntButton
          Left = 17
          Top = 8
          Width = 100
          Height = 21
          Caption = 'Run'
          TabOrder = 0
          OnClick = btCompilePScriptClick
        end
      end
    end
    object tsTools: TTntTabSheet
      Caption = 'Tools'
      ImageIndex = 10
      object tsI1: TTntPageControl
        Left = 0
        Top = 0
        Width = 1001
        Height = 746
        ActivePage = tsEdEx
        Align = alClient
        TabOrder = 0
        object tsEdEx: TTntTabSheet
          Caption = 'EdEx'
          ImageIndex = 1
          object Panel32: TPanel
            Left = 0
            Top = 608
            Width = 993
            Height = 110
            Align = alBottom
            TabOrder = 1
            DesignSize = (
              993
              110)
            object Label23: TTntLabel
              Left = 17
              Top = 8
              Width = 33
              Height = 13
              Caption = 'Text 1:'
            end
            object TntLabel2: TTntLabel
              Left = 17
              Top = 56
              Width = 33
              Height = 13
              Caption = 'Text 2:'
            end
            object edEdExInput: TTntEdit
              Left = 17
              Top = 26
              Width = 152
              Height = 21
              TabOrder = 0
            end
            object rbEdExNormal: TTntRadioButton
              Left = 816
              Top = 24
              Width = 113
              Height = 17
              Anchors = [akTop, akRight]
              Caption = 'Normal select'
              Checked = True
              TabOrder = 1
              TabStop = True
              OnClick = rbEdExNormalClick
            end
            object rbEdExLine: TTntRadioButton
              Left = 816
              Top = 48
              Width = 113
              Height = 17
              Anchors = [akTop, akRight]
              Caption = 'Line select'
              TabOrder = 2
              OnClick = rbEdExLineClick
            end
            object rbEdExColumn: TTntRadioButton
              Left = 816
              Top = 72
              Width = 113
              Height = 17
              Anchors = [akTop, akRight]
              Caption = 'Column select'
              TabOrder = 3
              OnClick = rbEdExColumnClick
            end
            object edEdExInput2: TTntEdit
              Left = 17
              Top = 74
              Width = 152
              Height = 21
              TabOrder = 4
            end
            object comboEdExAction: TTntComboBox
              Left = 208
              Top = 26
              Width = 225
              Height = 21
              ItemHeight = 13
              TabOrder = 5
              Text = 'Add TEXT 1 at begining of every line'
              Items.Strings = (
                'Add TEXT 1 at begining of every line'
                'Remove lines containing TEXT 1'
                'Leave just lines containing TEXT 1'
                'Replace TEXT 1 with TEXT 2'
                'Remove empty lines')
            end
            object btEdExGO: TTntButton
              Left = 208
              Top = 74
              Width = 100
              Height = 21
              Caption = 'GO'
              TabOrder = 6
              OnClick = btEdExGOClick
            end
          end
          object mmEdEx: TSynMemo
            Left = 0
            Top = 0
            Width = 993
            Height = 608
            Align = alClient
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -13
            Font.Name = 'Courier New'
            Font.Style = []
            PopupMenu = PopUpMnu
            TabOrder = 0
            Gutter.Font.Charset = DEFAULT_CHARSET
            Gutter.Font.Color = clWindowText
            Gutter.Font.Height = -11
            Gutter.Font.Name = 'Courier New'
            Gutter.Font.Style = []
            Gutter.Visible = False
            Options = [eoAutoIndent, eoEnhanceEndKey, eoGroupUndo, eoRightMouseMovesCursor, eoShowScrollHint, eoSmartTabDelete, eoSmartTabs, eoTabsToSpaces, eoTrimTrailingSpaces]
            RightEdge = 0
          end
        end
        object tsListMaker: TTntTabSheet
          Caption = 'Numbered List Maker'
          ImageIndex = 5
          object Splitter3: TSplitter
            Left = 0
            Top = 297
            Width = 993
            Height = 3
            Cursor = crVSplit
            Align = alBottom
          end
          object Label20: TTntLabel
            Left = 0
            Top = 0
            Width = 993
            Height = 13
            Align = alTop
            Caption = 'Input (enter one known URL):'
          end
          object Label21: TTntLabel
            Left = 0
            Top = 300
            Width = 993
            Height = 13
            Align = alBottom
            Caption = 'Output:'
          end
          object Panel15: TPanel
            Left = 0
            Top = 580
            Width = 993
            Height = 138
            Align = alBottom
            TabOrder = 2
            object Label10: TTntLabel
              Left = 8
              Top = 18
              Width = 43
              Height = 13
              Caption = 'Replace:'
            end
            object Label11: TTntLabel
              Left = 25
              Top = 62
              Width = 25
              Height = 13
              Caption = 'With:'
            end
            object Label12: TTntLabel
              Left = 176
              Top = 62
              Width = 68
              Height = 13
              Caption = '+ counter from'
            end
            object Label13: TTntLabel
              Left = 372
              Top = 62
              Width = 9
              Height = 13
              Caption = 'to'
            end
            object Label14: TTntLabel
              Left = 505
              Top = 62
              Width = 6
              Height = 13
              Caption = '+'
            end
            object Label15: TTntLabel
              Left = 234
              Top = 106
              Width = 24
              Height = 13
              Caption = 'digits'
            end
            object edFrom: TTntEdit
              Left = 67
              Top = 8
              Width = 105
              Height = 21
              TabOrder = 0
            end
            object edWith: TTntEdit
              Left = 67
              Top = 53
              Width = 105
              Height = 21
              TabOrder = 1
            end
            object edWithEnd: TTntEdit
              Left = 520
              Top = 53
              Width = 105
              Height = 21
              TabOrder = 6
            end
            object cbPad: TTntCheckBox
              Left = 67
              Top = 102
              Width = 102
              Height = 19
              Caption = 'Use padding to:'
              TabOrder = 2
            end
            object seMin: TJvSpinEdit
              Left = 261
              Top = 53
              Width = 105
              Height = 23
              Decimal = 0
              TabOrder = 4
            end
            object seMax: TJvSpinEdit
              Left = 395
              Top = 53
              Width = 105
              Height = 23
              Decimal = 0
              TabOrder = 5
            end
            object sePad: TJvSpinEdit
              Left = 167
              Top = 97
              Width = 60
              Height = 23
              Decimal = 0
              TabOrder = 3
            end
            object btMakeList: TTntButton
              Left = 713
              Top = 53
              Width = 100
              Height = 21
              Caption = 'Go!'
              TabOrder = 7
              OnClick = btMakeListClick
            end
          end
          object mmListMakerOut: TSynMemo
            Left = 0
            Top = 313
            Width = 993
            Height = 267
            Align = alBottom
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -13
            Font.Name = 'Courier New'
            Font.Style = []
            PopupMenu = PopUpMnu
            TabOrder = 1
            Gutter.Font.Charset = DEFAULT_CHARSET
            Gutter.Font.Color = clWindowText
            Gutter.Font.Height = -11
            Gutter.Font.Name = 'Courier New'
            Gutter.Font.Style = []
            Gutter.Visible = False
            Options = [eoAutoIndent, eoEnhanceEndKey, eoGroupUndo, eoRightMouseMovesCursor, eoShowScrollHint, eoSmartTabDelete, eoSmartTabs, eoTabsToSpaces, eoTrimTrailingSpaces]
            RightEdge = 0
            WordWrap = True
          end
          object mmListMakerIn: TSynMemo
            Left = 0
            Top = 13
            Width = 993
            Height = 284
            Align = alClient
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -13
            Font.Name = 'Courier New'
            Font.Style = []
            PopupMenu = PopUpMnu
            TabOrder = 0
            Gutter.Font.Charset = DEFAULT_CHARSET
            Gutter.Font.Color = clWindowText
            Gutter.Font.Height = -11
            Gutter.Font.Name = 'Courier New'
            Gutter.Font.Style = []
            Gutter.Visible = False
            Options = [eoAutoIndent, eoEnhanceEndKey, eoGroupUndo, eoRightMouseMovesCursor, eoShowScrollHint, eoSmartTabDelete, eoSmartTabs, eoTabsToSpaces, eoTrimTrailingSpaces]
            RightEdge = 0
            WordWrap = True
          end
        end
        object tsTemplate: TTntTabSheet
          Caption = 'Templated List Maker'
          ImageIndex = 3
          object Label27: TTntLabel
            Left = 0
            Top = 317
            Width = 993
            Height = 13
            Align = alBottom
            Caption = 'Output:'
          end
          object Label28: TTntLabel
            Left = 0
            Top = 0
            Width = 993
            Height = 13
            Align = alTop
            Caption = 'Input:'
          end
          object Splitter7: TSplitter
            Left = 0
            Top = 330
            Width = 993
            Height = 3
            Cursor = crVSplit
            Align = alBottom
          end
          object Panel33: TPanel
            Left = 0
            Top = 600
            Width = 993
            Height = 118
            Align = alBottom
            TabOrder = 2
            object Label29: TTntLabel
              Left = 1
              Top = 1
              Width = 991
              Height = 13
              Align = alTop
              Caption = 'Template:'
            end
            object mmTemplatedListMakerTemplate: TSynMemo
              Left = 1
              Top = 18
              Width = 512
              Height = 100
              Align = alCustom
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -13
              Font.Name = 'Courier New'
              Font.Style = []
              PopupMenu = PopUpMnu
              TabOrder = 0
              Gutter.Font.Charset = DEFAULT_CHARSET
              Gutter.Font.Color = clWindowText
              Gutter.Font.Height = -11
              Gutter.Font.Name = 'Courier New'
              Gutter.Font.Style = []
              Gutter.Visible = False
              Options = [eoAutoIndent, eoEnhanceEndKey, eoGroupUndo, eoRightMouseMovesCursor, eoShowScrollHint, eoSmartTabDelete, eoSmartTabs, eoTabsToSpaces, eoTrimTrailingSpaces]
              RightEdge = 0
              WordWrap = True
            end
            object btTemplatedListMakerGO: TTntButton
              Left = 696
              Top = 44
              Width = 100
              Height = 21
              Caption = 'GO!'
              TabOrder = 1
              OnClick = btTemplatedListMakerGOClick
            end
          end
          object mmTemplatedListMakerIn: TSynMemo
            Left = 0
            Top = 13
            Width = 993
            Height = 304
            Align = alClient
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -13
            Font.Name = 'Courier New'
            Font.Style = []
            PopupMenu = PopUpMnu
            TabOrder = 0
            Gutter.Font.Charset = DEFAULT_CHARSET
            Gutter.Font.Color = clWindowText
            Gutter.Font.Height = -11
            Gutter.Font.Name = 'Courier New'
            Gutter.Font.Style = []
            Gutter.Visible = False
            Options = [eoAutoIndent, eoEnhanceEndKey, eoGroupUndo, eoRightMouseMovesCursor, eoShowScrollHint, eoSmartTabDelete, eoSmartTabs, eoTabsToSpaces, eoTrimTrailingSpaces]
            RightEdge = 0
            WordWrap = True
          end
          object mmTemplatedListMakerOut: TSynMemo
            Left = 0
            Top = 333
            Width = 993
            Height = 267
            Align = alBottom
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -13
            Font.Name = 'Courier New'
            Font.Style = []
            PopupMenu = PopUpMnu
            TabOrder = 1
            Gutter.Font.Charset = DEFAULT_CHARSET
            Gutter.Font.Color = clWindowText
            Gutter.Font.Height = -11
            Gutter.Font.Name = 'Courier New'
            Gutter.Font.Style = []
            Gutter.Visible = False
            Options = [eoAutoIndent, eoEnhanceEndKey, eoGroupUndo, eoRightMouseMovesCursor, eoShowScrollHint, eoSmartTabDelete, eoSmartTabs, eoTabsToSpaces, eoTrimTrailingSpaces]
            RightEdge = 0
            WordWrap = True
          end
        end
        object tsIPConvert: TTntTabSheet
          Caption = 'IP converter'
          DesignSize = (
            993
            718)
          object TntLabel3: TTntLabel
            Left = 16
            Top = 8
            Width = 83
            Height = 13
            Caption = 'Obfuscated URL:'
          end
          object edObfURL: TTntEdit
            Left = 16
            Top = 32
            Width = 961
            Height = 21
            Anchors = [akLeft, akTop, akRight]
            TabOrder = 0
            OnKeyUp = edObfURLKeyUp
          end
          object btDeobfuscateURL: TTntButton
            Left = 16
            Top = 72
            Width = 105
            Height = 25
            Caption = ' Deobfuscate'
            TabOrder = 1
            OnClick = btDeobfuscateURLClick
          end
          object mmDeobfURL: TSynMemo
            Left = 16
            Top = 112
            Width = 961
            Height = 430
            Align = alCustom
            Anchors = [akLeft, akTop, akRight]
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -13
            Font.Name = 'Courier New'
            Font.Style = []
            PopupMenu = PopUpMnu
            TabOrder = 2
            Gutter.Font.Charset = DEFAULT_CHARSET
            Gutter.Font.Color = clWindowText
            Gutter.Font.Height = -11
            Gutter.Font.Name = 'Courier New'
            Gutter.Font.Style = []
            Gutter.Visible = False
            Options = [eoAutoIndent, eoEnhanceEndKey, eoGroupUndo, eoRightMouseMovesCursor, eoShowScrollHint, eoSmartTabDelete, eoSmartTabs, eoTabsToSpaces, eoTrimTrailingSpaces]
            RightEdge = 0
            SelectionMode = smLine
          end
        end
      end
    end
    object tsSettings: TTntTabSheet
      Caption = 'Settings'
      object tsSettings2: TTntPageControl
        Left = 0
        Top = 0
        Width = 1001
        Height = 746
        ActivePage = tsSettingsGeneral
        Align = alClient
        MultiLine = True
        TabOrder = 0
        object tsSettingsGeneral: TTntTabSheet
          Caption = 'General'
          object cbClipboardClear: TTntCheckBox
            Left = 8
            Top = 14
            Width = 168
            Height = 19
            Caption = 'Clear Clipboard at startup'
            TabOrder = 0
          end
          object cbClearCacheOnExit: TTntCheckBox
            Left = 8
            Top = 41
            Width = 152
            Height = 19
            Caption = 'Clear Cache on exit'
            TabOrder = 1
          end
          object cbClearHistoryOnExit: TTntCheckBox
            Left = 8
            Top = 68
            Width = 168
            Height = 19
            Caption = 'Clear URL History on exit'
            TabOrder = 2
          end
          object cbHighlight: TTntCheckBox
            Left = 8
            Top = 95
            Width = 127
            Height = 19
            Caption = 'Syntax Highlighting'
            TabOrder = 3
            OnClick = cbHighlightClick
          end
          object btFontSelect: TTntButton
            Left = 8
            Top = 127
            Width = 100
            Height = 21
            Caption = 'Adjust font'
            TabOrder = 4
            OnClick = btFontSelectClick
          end
          object Panel16: TPanel
            Left = 0
            Top = 546
            Width = 993
            Height = 172
            Align = alBottom
            TabOrder = 5
            object Label19: TTntLabel
              Left = 1
              Top = 1
              Width = 126
              Height = 13
              Align = alTop
              Caption = 'Clipboard Monitor Triggers:'
            end
            object mmClipMonTrig: TTntMemo
              Left = 1
              Top = 14
              Width = 991
              Height = 157
              Align = alClient
              ScrollBars = ssVertical
              TabOrder = 0
            end
          end
          object btCheckUpdate: TTntButton
            Left = 8
            Top = 156
            Width = 100
            Height = 21
            Caption = 'Check for updates'
            TabOrder = 6
            OnClick = btCheckUpdateClick
          end
        end
        object tsSettingsDownl: TTntTabSheet
          Caption = 'Download'
          object cbAutoParseLinksOnGET: TTntCheckBox
            Left = 13
            Top = 33
            Width = 185
            Height = 19
            Caption = 'Auto-parse links on GET'
            TabOrder = 0
          end
          object cbMalzillaProject: TTntCheckBox
            Left = 233
            Top = 6
            Width = 168
            Height = 19
            Caption = 'Add project info to saved files'
            TabOrder = 1
          end
          object cbAutoFocusDecoder: TTntCheckBox
            Left = 233
            Top = 33
            Width = 129
            Height = 17
            Caption = 'Auto-focus Decoder'
            TabOrder = 2
          end
          object cbAutoCompleteURL: TTntCheckBox
            Left = 480
            Top = 33
            Width = 121
            Height = 17
            Caption = 'Auto-complete URL'
            TabOrder = 3
            OnClick = cbAutoCompleteURLClick
          end
          object cbURLHistory: TTntCheckBox
            Left = 480
            Top = 8
            Width = 97
            Height = 17
            Caption = 'URL history'
            TabOrder = 4
          end
          object Panel14: TPanel
            Left = 0
            Top = 438
            Width = 993
            Height = 58
            Align = alBottom
            TabOrder = 5
            object Label7: TTntLabel
              Left = 1
              Top = 1
              Width = 29
              Height = 13
              Align = alTop
              Caption = 'Proxy:'
            end
            object Label8: TTntLabel
              Left = 17
              Top = 23
              Width = 41
              Height = 13
              Caption = 'Address:'
            end
            object Label9: TTntLabel
              Left = 340
              Top = 23
              Width = 22
              Height = 13
              Caption = 'Port:'
            end
            object Label16: TTntLabel
              Left = 512
              Top = 23
              Width = 25
              Height = 13
              Caption = 'User:'
            end
            object Label17: TTntLabel
              Left = 688
              Top = 23
              Width = 26
              Height = 13
              Caption = 'Pass:'
            end
            object edProxyAddress: TTntEdit
              Left = 67
              Top = 18
              Width = 262
              Height = 21
              TabOrder = 0
            end
            object edProxyPort: TTntEdit
              Left = 369
              Top = 18
              Width = 127
              Height = 21
              TabOrder = 1
            end
            object cbHideProxyData: TTntCheckBox
              Left = 856
              Top = 23
              Width = 102
              Height = 19
              Caption = 'Hide proxy data'
              TabOrder = 2
              OnClick = cbHideProxyDataClick
            end
            object edProxyUser: TMaskEdit
              Left = 545
              Top = 18
              Width = 127
              Height = 21
              TabOrder = 3
            end
            object edProxyPass: TMaskEdit
              Left = 721
              Top = 18
              Width = 127
              Height = 21
              TabOrder = 4
            end
          end
          object Panel17: TPanel
            Left = 0
            Top = 397
            Width = 993
            Height = 41
            Align = alBottom
            TabOrder = 6
            object btClearURLHist: TTntButton
              Left = 17
              Top = 8
              Width = 100
              Height = 21
              Caption = 'Clear URL history'
              TabOrder = 0
              OnClick = btClearURLHistClick
            end
            object btClearCache: TTntButton
              Left = 151
              Top = 8
              Width = 100
              Height = 21
              Caption = 'Clear Cache'
              TabOrder = 1
              OnClick = btClearCacheClick
            end
          end
          object Panel7: TPanel
            Left = 0
            Top = 496
            Width = 993
            Height = 41
            Align = alBottom
            TabOrder = 7
            object btLoadUA: TTntButton
              Left = 17
              Top = 8
              Width = 100
              Height = 21
              Caption = 'Load User Agents'
              TabOrder = 0
              OnClick = btLoadUAClick
            end
            object btSaveUA: TTntButton
              Left = 151
              Top = 8
              Width = 100
              Height = 21
              Caption = 'Save User Agents'
              TabOrder = 1
              OnClick = btSaveUAClick
            end
          end
          object Panel8: TPanel
            Left = 0
            Top = 537
            Width = 993
            Height = 181
            Align = alBottom
            TabOrder = 8
            object Label3: TTntLabel
              Left = 1
              Top = 1
              Width = 91
              Height = 13
              Align = alTop
              Caption = 'User Agents Editor:'
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -11
              Font.Name = 'MS Sans Serif'
              Font.Style = []
              ParentFont = False
            end
            object mmUserAgentsEditor: TTntMemo
              Left = 1
              Top = 14
              Width = 991
              Height = 166
              Align = alClient
              ScrollBars = ssVertical
              TabOrder = 0
            end
          end
        end
      end
    end
    object tsAbout: TTntTabSheet
      Caption = 'About'
      ImageIndex = 11
      object mmAbout: TTntMemo
        Left = 0
        Top = 0
        Width = 1001
        Height = 746
        Align = alClient
        Alignment = taCenter
        Lines.Strings = (
          'Malzilla by Boban (bobby) Spasic'
          ''
          'Contact:'
          'bobby@mycity.co.yu'
          ''
          'Malzilla'#39's homepage:'
          'http://malzilla.sourceforge.net'
          ''
          ''
          'People who helped my with code, suggestions or bug-reports:'
          'Ant (aka Antnet)'
          'Micha Pekrul'
          'TJS'
          'Andreas Marx from www.av-test.org'
          'Karl from www.HijackThis.de'
          'xJSTx from CastleCops forum'
          'jimmyleo - www.jimmyleo.com'
          'MysteryFCM - it-mate.co.uk / hosts-file.net'
          'delfiphan from www.delphi-forum.de'
          '  '
          
            'Special thanks to JohnC and sowhat-x for hosting the discussion ' +
            'about Malzilla'
          'on Malware Domain List forums:'
          'www.malwaredomainlist.com/forums/'
          ''
          ''
          'Shellcode analyzer is based on libemu project:'
          'http://libemu.mwcollect.org/'
          ''
          'Disassembler is based on Delphi port of libdisasm:'
          'http://bastard.sourceforge.net/libdisasm.html'
          'Pascal/Delphi port by Russell Libby')
        ReadOnly = True
        TabOrder = 0
      end
    end
  end
  object SaveDialog1: TSaveDialog
    Filter = 'All files (*.*)|*.*'
    Options = [ofOverwritePrompt, ofEnableSizing, ofForceShowHidden]
    OptionsEx = [ofExNoPlacesBar]
    Left = 928
    Top = 120
  end
  object OpenDialog1: TOpenDialog
    Filter = 'Lists (*.lst)|*.lst|All files (*.*)|*.*'
    Left = 896
    Top = 88
  end
  object SaveDialog2: TSaveDialog
    DefaultExt = 'lst'
    Filter = 'Lists (*.lst)|*.lst|All files (*.*)|*.*'
    Options = [ofOverwritePrompt, ofHideReadOnly, ofEnableSizing]
    Left = 960
    Top = 120
  end
  object SynURISyn1: TSynURISyn
    Enabled = False
    Left = 896
    Top = 152
  end
  object SynURIOpener2: TSynURIOpener
    Editor = mmResult
    URIHighlighter = SynURISyn1
    Left = 864
    Top = 152
  end
  object PopUpMnu: TPopupMenu
    OnPopup = PopUpMnuPopup
    Left = 864
    Top = 120
    object mnuUndo: TMenuItem
      Caption = 'Undo'
      OnClick = mnuUndoClick
    end
    object mnuRedo: TMenuItem
      Caption = 'Redo'
      OnClick = mnuRedoClick
    end
    object N2: TMenuItem
      Caption = '-'
    end
    object mnuCut: TMenuItem
      Caption = 'Cut'
      OnClick = mnuCutClick
    end
    object mnuCopy: TMenuItem
      Caption = 'Copy'
      OnClick = mnuCopyClick
    end
    object mnuPaste: TMenuItem
      Caption = 'Paste'
      OnClick = mnuPasteClick
    end
    object mnuDelete: TMenuItem
      Caption = 'Delete'
      OnClick = mnuDeleteClick
    end
    object N1: TMenuItem
      Caption = '-'
    end
    object mnuSelectAll: TMenuItem
      Caption = 'Select All'
      OnClick = mnuSelectAllClick
    end
    object mnuClear: TMenuItem
      Caption = 'Clear'
      OnClick = mnuClearClick
    end
    object N3: TMenuItem
      Caption = '-'
    end
    object mnuLoadFromFile: TMenuItem
      Caption = 'Load from File'
      OnClick = mnuLoadFromFileClick
    end
    object mnuSaveToFile: TMenuItem
      Caption = 'Save to File'
      OnClick = mnuSaveToFileClick
    end
    object N6: TMenuItem
      Caption = '-'
    end
    object mnuScriptInternal: TMenuItem
      Caption = 'Run script'
      object mnuRemoveNULLs: TTntMenuItem
        Caption = 'Remove NULLs'
        OnClick = mnuRemoveNULLsClick
      end
      object mnuRemovewhitespaceall1: TMenuItem
        Caption = 'Remove whitespace (all)'
        OnClick = mnuRemovewhitespaceall1Click
      end
      object mnuRemoveWhitespace: TTntMenuItem
        Caption = 'Remove whitespace (smart)'
        OnClick = mnuRemoveWhitespaceClick
      end
      object mnuScriptDDec: TTntMenuItem
        Caption = 'Decode Dec'
        OnClick = mnuScriptDDecClick
      end
      object mnuScriptDHex: TTntMenuItem
        Caption = 'Decode Hex'
        OnClick = mnuScriptDHexClick
      end
      object mnuScriptDUCS2: TTntMenuItem
        Caption = 'Decode UCS2'
        OnClick = mnuScriptDUCS2Click
      end
      object mnuScriptDBase64: TTntMenuItem
        Caption = 'Decode Base64'
        OnClick = mnuScriptDBase64Click
      end
      object mnuScriptConcatenate: TTntMenuItem
        Caption = 'Concatenate'
        OnClick = mnuScriptConcatenateClick
      end
    end
    object N13: TMenuItem
      Caption = '-'
    end
    object mnuLoadFromBuffer: TMenuItem
      Caption = 'Load from buffer'
      object Slot11: TTntMenuItem
        Caption = 'Slot 1'
        OnClick = Slot11Click
      end
      object Slot21: TTntMenuItem
        Caption = 'Slot 2'
        OnClick = Slot21Click
      end
      object Slot31: TTntMenuItem
        Caption = 'Slot 3'
        OnClick = Slot31Click
      end
      object Slot41: TTntMenuItem
        Caption = 'Slot 4'
        OnClick = Slot41Click
      end
      object Slot51: TTntMenuItem
        Caption = 'Slot 5'
        OnClick = Slot51Click
      end
    end
    object mnuSaveToBuffer: TMenuItem
      Caption = 'Save to buffer'
      object Slot12: TMenuItem
        Caption = 'Slot 1'
        OnClick = Slot12Click
      end
      object Slot22: TMenuItem
        Caption = 'Slot 2'
        OnClick = Slot22Click
      end
      object Slot32: TMenuItem
        Caption = 'Slot 3'
        OnClick = Slot32Click
      end
      object Slot42: TMenuItem
        Caption = 'Slot 4'
        OnClick = Slot42Click
      end
      object Slot52: TMenuItem
        Caption = 'Slot 5'
        OnClick = Slot52Click
      end
    end
    object N9: TMenuItem
      Caption = '-'
    end
    object mnuWordWrap: TMenuItem
      Caption = 'Word Wrap'
      OnClick = mnuWordWrapClick
    end
    object N11: TMenuItem
      Caption = '-'
    end
    object mnuLog: TMenuItem
      Caption = 'Log actions'
      OnClick = mnuLogClick
    end
  end
  object IdDecoderMIME1: TIdDecoderMIME
    FillChar = '='
    Left = 928
    Top = 56
  end
  object OpenDialog2: TOpenDialog
    FilterIndex = 0
    Left = 928
    Top = 88
  end
  object PopUpMnuHex: TPopupMenu
    Left = 832
    Top = 120
    object mnuHexCopyClipText: TMenuItem
      Caption = 'Copy as text'
      OnClick = mnuHexCopyClipTextClick
    end
    object mnuHexCopyClipHex: TMenuItem
      Caption = 'Copy as hex'
      OnClick = mnuHexCopyClipHexClick
    end
    object mnuHexCopyClipTextSel: TMenuItem
      Caption = 'Copy selection as text'
      OnClick = mnuHexCopyClipTextSelClick
    end
    object mnuHexCopyClipHexSel: TMenuItem
      Caption = 'Copy selection as hex'
      OnClick = mnuHexCopyClipHexSelClick
    end
    object N4: TMenuItem
      Caption = '-'
    end
    object mnuHexPasteClipText: TMenuItem
      Caption = 'Paste as text'
      OnClick = mnuHexPasteClipTextClick
    end
    object mnuHexPasteClipHex: TMenuItem
      Caption = 'Paste as hex'
      OnClick = mnuHexPasteClipHexClick
    end
    object N5: TMenuItem
      Caption = '-'
    end
    object mnuHexLoad: TMenuItem
      Caption = 'Load'
      OnClick = mnuHexLoadClick
    end
    object mnuHexSave: TMenuItem
      Caption = 'Save'
      OnClick = mnuHexSaveClick
    end
  end
  object JvTrayIcon1: TJvTrayIcon
    Active = True
    Icon.Data = {
      0000010001000E10000001002000E803000016000000280000000E0000002000
      00000100200000000000C0030000000000000000000000000000000000007078
      77327F8F8F3E8797993D464C4D3A7575754149467B9F615E9DB7838398BD7576
      88968283855267676619525252106E6E6B0A979797032E899ADD1B9FBDFF3794
      A9FFB3C4B4FFBABFB5FF5953E3FF625EFAFF807FF5FF938CE9FFBEC0C3FFD3D4
      C4F17A79A5E88382B1E6A7A8A2AB557495872398DCF66DA9C6FFA19CAFFFBCBF
      CAFFB0AED2FFB6A4F3FFD7BAF4FFF0D6F0FFFFFFFBFFFFFFFFFFEDECFCFF9C8F
      CEDBB2B0B35081798A117672A59C9297BCF3534BE4FF5A55D5FF7993A5FF85B9
      D1FF86B9D5FF8BC2DDFFA7D3EAFFCCDEEBFFC9CAD3C89D9C9A0CAAA9AA006D6E
      6E0055535519486E9AD87E7EFEFF8F86FFFF4F87E9FF1FB9FFFF22B0FDFF169D
      E4FF1994D0FF1D7FB3FF9CA5B74BC4BFBA00A7A6A700D7D3CC00C2B8C8365E7A
      B6C76087CAFFD7B5FAFF73ABE9FF1679A6FF0E4055FF596364FF050200FF555D
      5DFC90919333B0AEAB00C6C6C70036333200524E4C00577173592C9EB2FF6AB8
      EAFF2D91BDFF2090CAFF2B9DD6FF4EA5D2FF1A536FFF5197B8FE439CD8DAA5B5
      D05ADEDAD7001A1A19003528546D2C629AEC27B1D8FF2CA6F4FF2D99E6FF64C2
      F6FFDBECF3FF6FC3EFFF23B9FFFF3EBFFFFF7BBCF2FF7992D2B99B969000BDBD
      BA00AA9EAB2C4A8DB0D027AFECFF44A6FFFF3C9CFEFF9DCAE8FFFBF3EDFF8385
      85FE38B4F6FF68A9C9FFB7B4BEFF8897CDB297969200D6D6D40A242526122773
      A0D12DB9FEFF3DA9FFFF35A1FDFF93D0F1FFD5CCC7FF514A46FF5EC0F1FF5D83
      93FE9293A8FFA0A6C87AAEB0A900C0BEC8235948B7D04A6BD9FF2AB9FBFF2EB4
      FFFF22AFFFFF8ECCECFFF0E0D8FF8A8C8AFF47B2EDFF94ACB4FFAAACC9F7BFC0
      CA24CACBC600F3F3EF00D1C9D92F7B728B503FA0D9E028BBFFFF25B2FEFF74B9
      DDFFA8CEDEFF63A9D0FF41A0F9FFA3B3E4FFA5A6BC90B0B2BB00B2B3BE009091
      8D00787A7300373B30002F39B6D83486F3FF35B8FFFF33B3FEFF34A9FCFF55A3
      FFFF839FFFFFA0A6E7C7C6C7D00FCDCED900CBCDD800AEACB100B0ADAF025B59
      8C8E7769E7FC9F83E2D7435C9FB53F70E2FF5D6FE0FF818CD4CB858AAC7FA8A9
      A60FD8DBDB00D3D4D900D3D4D900F0E5E600F7ECEB00C5BFCA207A7282404441
      3A0C1A19495A805EFFFFB297E29D9798900270746800A5A7A300D6D9DC00D2D3
      D900D2D3D900EEE2E000F5EAE700BFBBB8005E615D00474E48006E66898FA697
      C193C8C8BC02A8AAA20070746F00A5A7A400D6D9DC00D2D3D900D2D3D9000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000}
    IconIndex = 0
    PopupMenu = PopUpTray
    Delay = 0
    OnDblClick = JvTrayIcon1DblClick
    Left = 864
    Top = 88
  end
  object PopUpTray: TPopupMenu
    Left = 960
    Top = 88
    object mnuTrayShow: TMenuItem
      Caption = 'Show'
      OnClick = mnuTrayShowClick
    end
    object mnuTrayHide: TMenuItem
      Caption = 'Hide'
      OnClick = mnuTrayHideClick
    end
    object N8: TMenuItem
      Caption = '-'
    end
    object mnuTrayClipMonitorList: TMenuItem
      Caption = 'Clipboard Monitor'
      OnClick = mnuTrayClipMonitorListClick
    end
    object N7: TMenuItem
      Caption = '-'
    end
    object mnuTrayClose: TMenuItem
      Caption = 'Exit'
      OnClick = mnuTrayCloseClick
    end
  end
  object hkClipboardMonitor1: ThkClipboardMonitor
    Enabled = False
    OnChange = hkClipboardMonitor1Change
    Left = 864
    Top = 56
  end
  object JvSelectDirectory1: TJvSelectDirectory
    ClassicDialog = False
    Left = 832
    Top = 88
  end
  object HREFParser1: THREFParser
    OnFoundHyperlink = HREFParser1FoundHyperlink
    Left = 896
    Top = 56
  end
  object PSScript1: TPSScript
    CompilerOptions = []
    OnCompile = PSScript1Compile
    Plugins = <>
    UsePreProcessor = False
    Left = 896
    Top = 120
  end
  object SynPasSyn1: TSynPasSyn
    Left = 832
    Top = 152
  end
  object SynWebEngine1: TSynWebEngine
    Options.HtmlVersion = shvXHtml10Transitional
    Options.WmlVersion = swvWml13
    Options.CssVersion = scvCss21
    Options.PhpVersion = spvPhp5
    Options.PhpShortOpenTag = True
    Options.PhpAspTags = False
    Left = 928
    Top = 152
  end
  object SynWebEsSyn1: TSynWebEsSyn
    ActiveHighlighterSwitch = True
    Engine = SynWebEngine1
    Options.PhpVersion = spvPhp5
    Options.PhpShortOpenTag = True
    Options.PhpAspTags = False
    Options.PhpEmbeded = False
    Options.UseEngineOptions = False
    Left = 960
    Top = 152
  end
  object SynWebHtmlSyn1: TSynWebHtmlSyn
    ActiveHighlighterSwitch = False
    Engine = SynWebEngine1
    Options.HtmlVersion = shvXHtml10Transitional
    Options.CssVersion = scvCss21
    Options.PhpVersion = spvPhp5
    Options.PhpShortOpenTag = True
    Options.PhpAspTags = False
    Options.CssEmbeded = True
    Options.PhpEmbeded = True
    Options.EsEmbeded = True
    Options.UseEngineOptions = False
    Left = 832
    Top = 184
  end
  object PopUpMnuDownloadHex: TTntPopupMenu
    Left = 928
    Top = 184
    object mnuSaveDownloadHex: TTntMenuItem
      Caption = 'Save'
      ShortCut = 16467
      OnClick = mnuSaveDownloadHexClick
    end
  end
  object PopUpMnuDownloaderTabs: TTntPopupMenu
    OnPopup = PopUpMnuDownloaderTabsPopup
    Left = 896
    Top = 184
    object mnuNewDownloaderTab: TTntMenuItem
      Caption = 'New Tab'
      ShortCut = 16468
      OnClick = mnuNewDownloaderTabClick
    end
    object mnuNewDownloaderTabAuto: TTntMenuItem
      Caption = 'New Tab (next step)'
      OnClick = mnuNewDownloaderTabAutoClick
    end
    object N10: TTntMenuItem
      Caption = '-'
    end
    object mnuCloseDownloaderTab: TTntMenuItem
      Caption = 'Close Tab'
      ShortCut = 16471
      OnClick = mnuCloseDownloaderTabClick
    end
  end
  object FontDialog1: TFontDialog
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    Left = 832
    Top = 56
  end
  object JvFormAutoSize1: TJvFormAutoSize
    Left = 960
    Top = 56
  end
  object PopUpMnuDecoderTabs: TTntPopupMenu
    OnPopup = PopUpMnuDecoderTabsPopup
    Left = 864
    Top = 184
    object mnuNewDecoderTab: TTntMenuItem
      Caption = 'New Tab'
      ShortCut = 16468
      OnClick = mnuNewDecoderTabClick
    end
    object N12: TTntMenuItem
      Caption = '-'
    end
    object mnuCloseDecoderTab: TTntMenuItem
      Caption = 'Close Tab'
      ShortCut = 16471
      OnClick = mnuCloseDecoderTabClick
    end
  end
  object PopUpMnuClipMon: TTntPopupMenu
    Left = 964
    Top = 184
    object mnuClipMonPaste: TTntMenuItem
      Caption = 'Paste'
      OnClick = mnuClipMonPasteClick
    end
  end
  object PopUpMnuIncrement: TPopupMenu
    Left = 836
    Top = 216
    object mnuIncrementDec: TMenuItem
      AutoCheck = True
      Caption = 'Dec'
      Checked = True
      OnClick = mnuIncrementDecClick
    end
    object mnuIncrementHex: TMenuItem
      Caption = 'Hex'
      OnClick = mnuIncrementHexClick
    end
  end
  object emulator: TDosCommand
    OnTerminated = emulatorTerminated
    InputToOutput = False
    MaxTimeAfterBeginning = 0
    MaxTimeAfterLastOutput = 0
    ShowWindow = swHIDE
    CreationFlag = fCREATE_NEW_CONSOLE
    ReturnCode = rcLF
    Left = 784
    Top = 56
  end
end
