object jdkHelpFrm: TjdkHelpFrm
  Left = 312
  Top = 135
  BorderIcons = [biSystemMenu]
  BorderStyle = bsNone
  ClientHeight = 397
  ClientWidth = 471
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnClose = FormClose
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 471
    Height = 397
    Align = alClient
    BevelWidth = 2
    Caption = 'Panel1'
    TabOrder = 0
    object RzPageControl1: TRzPageControl
      Left = 2
      Top = 2
      Width = 467
      Height = 393
      ActivePage = TabSheet3
      Align = alClient
      AllowTabDragging = True
      HotTrackColor = clMoneyGreen
      TabColors.HighlightBar = clBlue
      TabIndex = 0
      TabOrder = 0
      TabStyle = tsDoubleSlant
      FixedDimension = 19
      object TabSheet3: TRzTabSheet
        Caption = 'Doc Help'
        object Splitter1: TSplitter
          Left = 0
          Top = 172
          Width = 463
          Height = 4
          Cursor = crVSplit
          Align = alBottom
        end
        object JDKWebBrowser: TWebBrowser
          Left = 0
          Top = 176
          Width = 463
          Height = 194
          Align = alBottom
          TabOrder = 0
          ControlData = {
            4C000000DA2F00000D1400000000000000000000000000000000000000000000
            000000004C000000000000000000000001000000E0D057007335CF11AE690800
            2B2E126208000000000000004C0000000114020000000000C000000000000046
            8000000000000000000000000000000000000000000000000000000000000000
            00000000000000000100000000000000000000000000000000000000}
        end
        object methodHelpTV: TTreeView
          Left = 0
          Top = 0
          Width = 463
          Height = 172
          Align = alClient
          Color = 16764878
          Indent = 19
          ReadOnly = True
          SortType = stText
          TabOrder = 1
          OnDblClick = methodhelpTVDblClick
        end
      end
      object TabSheet4: TRzTabSheet
        Caption = 'Source File'
        object SynEditor: TSynEditExt
          Left = 0
          Top = 0
          Width = 463
          Height = 370
          Cursor = crIBeam
          Align = alClient
          Color = 14087154
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -13
          Font.Name = 'Courier New'
          Font.Pitch = fpFixed
          Font.Style = []
          ParentColor = False
          ParentFont = False
          TabOrder = 0
          Gutter.Color = 11654116
          Gutter.Cursor = crHandPoint
          Gutter.DigitCount = 6
          Gutter.ShowLineNumbers = True
          Highlighter = SynJavaSyn
          Keystrokes = <
            item
              Command = ecUp
              ShortCut = 38
            end
            item
              Command = ecSelUp
              ShortCut = 8230
            end
            item
              Command = ecScrollUp
              ShortCut = 16422
            end
            item
              Command = ecDown
              ShortCut = 40
            end
            item
              Command = ecSelDown
              ShortCut = 8232
            end
            item
              Command = ecScrollDown
              ShortCut = 16424
            end
            item
              Command = ecLeft
              ShortCut = 37
            end
            item
              Command = ecSelLeft
              ShortCut = 8229
            end
            item
              Command = ecWordLeft
              ShortCut = 16421
            end
            item
              Command = ecSelWordLeft
              ShortCut = 24613
            end
            item
              Command = ecRight
              ShortCut = 39
            end
            item
              Command = ecSelRight
              ShortCut = 8231
            end
            item
              Command = ecWordRight
              ShortCut = 16423
            end
            item
              Command = ecSelWordRight
              ShortCut = 24615
            end
            item
              Command = ecPageDown
              ShortCut = 34
            end
            item
              Command = ecSelPageDown
              ShortCut = 8226
            end
            item
              Command = ecPageBottom
              ShortCut = 16418
            end
            item
              Command = ecSelPageBottom
              ShortCut = 24610
            end
            item
              Command = ecPageUp
              ShortCut = 33
            end
            item
              Command = ecSelPageUp
              ShortCut = 8225
            end
            item
              Command = ecPageTop
              ShortCut = 16417
            end
            item
              Command = ecSelPageTop
              ShortCut = 24609
            end
            item
              Command = ecLineStart
              ShortCut = 36
            end
            item
              Command = ecSelLineStart
              ShortCut = 8228
            end
            item
              Command = ecEditorTop
              ShortCut = 16420
            end
            item
              Command = ecSelEditorTop
              ShortCut = 24612
            end
            item
              Command = ecLineEnd
              ShortCut = 35
            end
            item
              Command = ecSelLineEnd
              ShortCut = 8227
            end
            item
              Command = ecEditorBottom
              ShortCut = 16419
            end
            item
              Command = ecSelEditorBottom
              ShortCut = 24611
            end
            item
              Command = ecToggleMode
              ShortCut = 45
            end
            item
              Command = ecCopy
              ShortCut = 16429
            end
            item
              Command = ecPaste
              ShortCut = 8237
            end
            item
              Command = ecDeleteChar
              ShortCut = 46
            end
            item
              Command = ecCut
              ShortCut = 8238
            end
            item
              Command = ecDeleteLastChar
              ShortCut = 8
            end
            item
              Command = ecDeleteLastChar
              ShortCut = 8200
            end
            item
              Command = ecDeleteLastWord
              ShortCut = 16392
            end
            item
              Command = ecUndo
              ShortCut = 32776
            end
            item
              Command = ecRedo
              ShortCut = 40968
            end
            item
              Command = ecLineBreak
              ShortCut = 13
            end
            item
              Command = ecSelectAll
              ShortCut = 16449
            end
            item
              Command = ecCopy
              ShortCut = 16451
            end
            item
              Command = ecBlockIndent
              ShortCut = 24649
            end
            item
              Command = ecLineBreak
              ShortCut = 16461
            end
            item
              Command = ecInsertLine
              ShortCut = 16462
            end
            item
              Command = ecDeleteWord
              ShortCut = 16468
            end
            item
              Command = ecBlockUnindent
              ShortCut = 24661
            end
            item
              Command = ecPaste
              ShortCut = 16470
            end
            item
              Command = ecCut
              ShortCut = 16472
            end
            item
              Command = ecDeleteLine
              ShortCut = 16473
            end
            item
              Command = ecDeleteEOL
              ShortCut = 24665
            end
            item
              Command = ecUndo
              ShortCut = 16474
            end
            item
              Command = ecRedo
              ShortCut = 24666
            end
            item
              Command = ecGotoMarker0
              ShortCut = 16432
            end
            item
              Command = ecGotoMarker1
              ShortCut = 16433
            end
            item
              Command = ecGotoMarker2
              ShortCut = 16434
            end
            item
              Command = ecGotoMarker3
              ShortCut = 16435
            end
            item
              Command = ecGotoMarker4
              ShortCut = 16436
            end
            item
              Command = ecGotoMarker5
              ShortCut = 16437
            end
            item
              Command = ecGotoMarker6
              ShortCut = 16438
            end
            item
              Command = ecGotoMarker7
              ShortCut = 16439
            end
            item
              Command = ecGotoMarker8
              ShortCut = 16440
            end
            item
              Command = ecGotoMarker9
              ShortCut = 16441
            end
            item
              Command = ecSetMarker0
              ShortCut = 24624
            end
            item
              Command = ecSetMarker1
              ShortCut = 24625
            end
            item
              Command = ecSetMarker2
              ShortCut = 24626
            end
            item
              Command = ecSetMarker3
              ShortCut = 24627
            end
            item
              Command = ecSetMarker4
              ShortCut = 24628
            end
            item
              Command = ecSetMarker5
              ShortCut = 24629
            end
            item
              Command = ecSetMarker6
              ShortCut = 24630
            end
            item
              Command = ecSetMarker7
              ShortCut = 24631
            end
            item
              Command = ecSetMarker8
              ShortCut = 24632
            end
            item
              Command = ecSetMarker9
              ShortCut = 24633
            end
            item
              Command = ecNormalSelect
              ShortCut = 24654
            end
            item
              Command = ecColumnSelect
              ShortCut = 24643
            end
            item
              Command = ecLineSelect
              ShortCut = 24652
            end
            item
              Command = ecTab
              ShortCut = 9
            end
            item
              Command = ecShiftTab
              ShortCut = 8201
            end
            item
              Command = ecMatchBracket
              ShortCut = 24642
            end>
          Options = [eoAutoIndent, eoDragDropEditing, eoKeepCaretX, eoScrollPastEol, eoShowScrollHint, eoTabsToSpaces, eoTrimTrailingSpaces]
          ReadOnly = True
          SelectedColor.Background = clBlue
          TabWidth = 3
          WantTabs = True
          findSourceFile = False
          BreakpointEnable = False
        end
      end
    end
    object hideBtn: TRzButton
      Left = 424
      Top = 1
      Width = 44
      Height = 19
      Caption = 'Hide'
      TabOrder = 1
      OnClick = hideBtnClick
    end
  end
  object SynJavaSyn: TSynJavaSyn
    DefaultFilter = 'Java files (*.java)|*.java'
    CommentAttri.Foreground = clGreen
    DocumentAttri.Foreground = clGreen
    KeyAttri.Foreground = clBlue
    NumberAttri.Foreground = clPurple
    StringAttri.Foreground = clRed
    Left = 184
    Top = 128
  end
end
