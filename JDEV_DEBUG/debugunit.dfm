object DebugForm: TDebugForm
  Left = 214
  Top = 175
  Width = 732
  Height = 545
  Caption = 'Debug Console'
  Color = clBtnFace
  DefaultMonitor = dmDesktop
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -16
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  Menu = MainMenu
  OldCreateOrder = False
  Position = poDesktopCenter
  OnClose = FormClose
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnHide = FormHide
  OnResize = FormResize
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 20
  object Splitter1: TSplitter
    Left = 0
    Top = 217
    Width = 724
    Height = 4
    Cursor = crVSplit
    Align = alTop
    Beveled = True
  end
  object MyToolBar: TToolBar
    Left = 0
    Top = 0
    Width = 724
    Height = 30
    ButtonHeight = 24
    ButtonWidth = 24
    Caption = 'MyToolBar'
    Images = AllImage
    TabOrder = 0
    object ToolButton1: TToolButton
      Left = 0
      Top = 2
      Width = 8
      Caption = 'ToolButton1'
      Style = tbsSeparator
    end
    object stepinBtn: TToolButton
      Left = 8
      Top = 2
      Hint = 'Step in'
      Caption = 'stepinBtn'
      ImageIndex = 8
      ParentShowHint = False
      ShowHint = True
      OnClick = stepinBtnClick
    end
    object stepBtn: TToolButton
      Left = 32
      Top = 2
      Hint = 'Step'
      Caption = 'stepBtn'
      ImageIndex = 2
      ParentShowHint = False
      ShowHint = True
      OnClick = stepBtnClick
    end
    object stepoutBtn: TToolButton
      Left = 56
      Top = 2
      Hint = 'Step out'
      Caption = 'stepoutBtn'
      ImageIndex = 1
      ParentShowHint = False
      ShowHint = True
      OnClick = stepoutBtnClick
    end
    object ToolButton15: TToolButton
      Left = 80
      Top = 2
      Width = 8
      Caption = 'ToolButton15'
      ImageIndex = 12
      Style = tbsSeparator
    end
    object ToolButton16: TToolButton
      Left = 88
      Top = 2
      Width = 8
      Caption = 'ToolButton16'
      ImageIndex = 13
      Style = tbsSeparator
    end
    object runBtn: TToolButton
      Left = 96
      Top = 2
      Hint = 'Run'
      Caption = 'runBtn'
      ImageIndex = 6
      ParentShowHint = False
      ShowHint = True
      OnClick = runBtnClick
    end
    object suspendBtn: TToolButton
      Left = 120
      Top = 2
      Hint = 'Suspend'
      Caption = 'suspendBtn'
      ImageIndex = 7
      ParentShowHint = False
      ShowHint = True
      OnClick = suspendBtnClick
    end
    object exitBtn: TToolButton
      Left = 144
      Top = 2
      Hint = 'Terminate'
      Caption = 'exitBtn'
      ImageIndex = 0
      ParentShowHint = False
      ShowHint = True
      OnClick = exitBtnClick
    end
    object ToolButton14: TToolButton
      Left = 168
      Top = 2
      Width = 8
      Caption = 'ToolButton14'
      ImageIndex = 8
      Style = tbsSeparator
    end
    object breakBtn: TToolButton
      Left = 176
      Top = 2
      Hint = 'Create/Clear Breakpoint'
      Caption = 'breakBtn'
      ImageIndex = 9
      ParentShowHint = False
      ShowHint = True
      OnClick = breakBtnClick
    end
    object ToolButton13: TToolButton
      Left = 200
      Top = 2
      Width = 8
      Caption = 'ToolButton13'
      ImageIndex = 7
      Style = tbsSeparator
    end
    object ToolButton18: TToolButton
      Left = 208
      Top = 2
      Width = 8
      Caption = 'ToolButton18'
      ImageIndex = 7
      Style = tbsSeparator
    end
    object ToolButton8: TToolButton
      Left = 216
      Top = 2
      Hint = 'New watch variable'
      Caption = 'ToolButton8'
      ImageIndex = 5
      ParentShowHint = False
      ShowHint = True
      OnClick = ToolButton8Click
    end
    object ToolButton2: TToolButton
      Left = 240
      Top = 2
      Width = 8
      Caption = 'ToolButton2'
      ImageIndex = 5
      Style = tbsSeparator
    end
    object stayOnTopBtn: TToolButton
      Left = 248
      Top = 2
      Hint = 'stay on top'
      Grouped = True
      ImageIndex = 15
      ParentShowHint = False
      ShowHint = True
      Style = tbsCheck
      OnClick = Stayontop1Click
    end
  end
  object MyStatusBar: TStatusBar
    Left = 0
    Top = 480
    Width = 724
    Height = 19
    Panels = <
      item
        Width = 400
      end>
    SimplePanel = False
  end
  object PageControl: TPageControl
    Left = 0
    Top = 221
    Width = 724
    Height = 259
    ActivePage = ConsoleTabSheet
    Align = alClient
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
    TabIndex = 0
    TabOrder = 2
    TabPosition = tpBottom
    object ConsoleTabSheet: TTabSheet
      Caption = 'Console'
      OnShow = ConsoleTabSheetShow
      object Splitter2: TSplitter
        Left = 242
        Top = 0
        Width = 4
        Height = 233
        Cursor = crHSplit
        Beveled = True
      end
      object ConsoleInputGroupBox: TGroupBox
        Left = 0
        Top = 0
        Width = 242
        Height = 233
        Align = alLeft
        Caption = 'Console Input'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ParentFont = False
        TabOrder = 0
        object ConsoleInputMemo: TMemo
          Left = 2
          Top = 18
          Width = 238
          Height = 213
          Align = alClient
          Color = clBlack
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clLime
          Font.Height = -13
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ImeName = #32043#20809#25340#38899#36755#20837#27861
          ParentFont = False
          ScrollBars = ssBoth
          TabOrder = 0
          OnKeyDown = ConsoleInputMemoKeyDown
          OnKeyUp = ConsoleInputMemoKeyUp
        end
      end
      object GroupBox2: TGroupBox
        Left = 246
        Top = 0
        Width = 470
        Height = 233
        Align = alClient
        Caption = 'Console Output'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ParentFont = False
        TabOrder = 1
        object ConsoleOutputMemo: TMemo
          Left = 2
          Top = 18
          Width = 466
          Height = 213
          Align = alClient
          Color = 12962247
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clNavy
          Font.Height = -13
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ImeName = #32043#20809#25340#38899#36755#20837#27861
          ParentFont = False
          ScrollBars = ssBoth
          TabOrder = 0
        end
      end
    end
    object SourceTabSheet: TTabSheet
      Caption = 'Source'
      ImageIndex = 2
      object sourceGroupBox: TGroupBox
        Left = 0
        Top = 0
        Width = 716
        Height = 233
        Align = alClient
        Caption = 'Source Code '
        TabOrder = 0
        object sourceEdit: TSynEditExt
          Left = 2
          Top = 15
          Width = 712
          Height = 216
          Cursor = crIBeam
          Align = alClient
          Color = 12962247
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -13
          Font.Name = 'Courier New'
          Font.Style = []
          ParentColor = False
          ParentFont = False
          PopupMenu = SynEditorPopupMenu
          TabOrder = 0
          Gutter.Color = 11654116
          Gutter.DigitCount = 5
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
          ReadOnly = True
          SelectedColor.Background = clBlue
          TabWidth = 3
          WantTabs = True
          OnGutterClick = sourceEditGutterClick
          findSourceFile = False
          BpImageList = LineBpImageList
          BreakpointEnable = True
        end
      end
    end
    object BreakpointTabSheet: TTabSheet
      Caption = 'Breakpoint'
      ImageIndex = 3
      object BreakpointListTV: TTreeView
        Left = 0
        Top = 0
        Width = 716
        Height = 233
        Align = alClient
        Color = 12962247
        Images = bpImagelist
        Indent = 19
        ReadOnly = True
        TabOrder = 0
        OnMouseDown = BreakpointListTVMouseDown
        Items.Data = {
          03000000280000000000000000000000FFFFFFFFFFFFFFFF0000000000000000
          0F4C696E6520427265616B706F696E742A0000000100000001000000FFFFFFFF
          FFFFFFFF0000000000000000114D6574686F6420427265616B706F696E742D00
          00000200000002000000FFFFFFFFFFFFFFFF0000000000000000144578636570
          74696F6E20427265616B706F696E74}
      end
    end
    object VarWatchTabSheet: TTabSheet
      Caption = 'Watch var'
      ImageIndex = 5
      object Label7: TLabel
        Left = 0
        Top = 0
        Width = 123
        Height = 16
        Align = alTop
        Caption = 'watching variables'#65306
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ParentFont = False
      end
      object watchVarLV: TListView
        Left = 0
        Top = 16
        Width = 716
        Height = 217
        Align = alClient
        Color = 12962247
        Columns = <
          item
            Caption = 'variable name'
            Width = 80
          end
          item
            Caption = 'variable value'
            Width = 630
          end>
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        GridLines = True
        RowSelect = True
        ParentFont = False
        PopupMenu = watchVarPopupMenu
        SortType = stText
        TabOrder = 0
        ViewStyle = vsReport
        OnDblClick = watchVarLVDblClick
      end
    end
    object LoadClassesTabSheet: TTabSheet
      Caption = 'Class Loader'
      ImageIndex = 4
      object Label6: TLabel
        Left = 0
        Top = 0
        Width = 111
        Height = 16
        Align = alTop
        Caption = 'Loaded Classes'#65306
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ParentFont = False
      end
      object classListBox: TListBox
        Left = 0
        Top = 16
        Width = 716
        Height = 217
        Hint = #21333#20987#26412#21306#22495#21047#26032#35013#36733#31867
        Align = alClient
        Color = 12962247
        ImeName = #32043#20809#25340#38899#36755#20837#27861
        ItemHeight = 13
        ParentShowHint = False
        ShowHint = True
        TabOrder = 0
      end
    end
    object MessageTabSheet: TTabSheet
      Caption = 'message'
      ImageIndex = 5
      object GroupBox3: TGroupBox
        Left = 0
        Top = 0
        Width = 716
        Height = 233
        Align = alClient
        Caption = 'Debug Infomation'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ParentFont = False
        TabOrder = 0
        object debugMsg: TMemo
          Left = 2
          Top = 18
          Width = 712
          Height = 213
          Align = alClient
          Color = 12962247
          ImeName = #32043#20809#25340#38899#36755#20837#27861
          TabOrder = 0
        end
      end
    end
  end
  object TreePanel: TPanel
    Left = 0
    Top = 30
    Width = 724
    Height = 187
    Align = alTop
    TabOrder = 3
    object Splitter3: TSplitter
      Left = 245
      Top = 1
      Width = 4
      Height = 185
      Cursor = crHSplit
      Beveled = True
    end
    object Splitter4: TSplitter
      Left = 477
      Top = 1
      Width = 4
      Height = 185
      Cursor = crHSplit
      Beveled = True
    end
    object ThreadListPanel: TPanel
      Left = 1
      Top = 1
      Width = 244
      Height = 185
      Align = alLeft
      BevelInner = bvLowered
      TabOrder = 0
      object Label1: TLabel
        Left = 2
        Top = 2
        Width = 240
        Height = 16
        Align = alTop
        Alignment = taCenter
        Caption = 'Application/Thread'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ParentFont = False
      end
      object ThreadListTV: TTreeView
        Left = 2
        Top = 18
        Width = 240
        Height = 165
        Align = alClient
        Color = 12962247
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -15
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        HideSelection = False
        Images = threadImageList
        Indent = 19
        ParentFont = False
        PopupMenu = appNodePopupMenu
        ReadOnly = True
        RightClickSelect = True
        TabOrder = 0
        TabStop = False
        OnChange = ThreadListTVChange
        OnChanging = ThreadListTVChanging
        OnCustomDrawItem = ThreadListTVCustomDrawItem
      end
    end
    object LocalsListPanel: TPanel
      Left = 249
      Top = 1
      Width = 228
      Height = 185
      Align = alLeft
      BevelInner = bvLowered
      TabOrder = 1
      object Label2: TLabel
        Left = 2
        Top = 2
        Width = 224
        Height = 16
        Align = alTop
        Alignment = taCenter
        Caption = 'Variable List'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ParentFont = False
      end
      object LocalsListTV: TTreeView
        Left = 2
        Top = 18
        Width = 224
        Height = 165
        Align = alClient
        Color = 12962247
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -15
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        Indent = 19
        ParentFont = False
        ReadOnly = True
        TabOrder = 0
        TabStop = False
        OnChange = LocalsListTVChange
        OnChanging = LocalsListTVChanging
        OnCustomDrawItem = LocalsListTVCustomDrawItem
        OnDeletion = LocalsListTVDeletion
        OnExpanding = LocalsListTVExpanding
      end
    end
    object Panel3: TPanel
      Left = 481
      Top = 1
      Width = 242
      Height = 185
      Align = alClient
      BevelInner = bvLowered
      TabOrder = 2
      object Label3: TLabel
        Left = 2
        Top = 37
        Width = 238
        Height = 16
        Align = alTop
        Caption = 'Variable Value'#65306
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ParentFont = False
      end
      object varTypeLabel: TLabel
        Left = 2
        Top = 18
        Width = 238
        Height = 19
        Align = alTop
        AutoSize = False
        Color = 12962247
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlue
        Font.Height = -13
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ParentColor = False
        ParentFont = False
      end
      object Label5: TLabel
        Left = 2
        Top = 2
        Width = 238
        Height = 16
        Align = alTop
        Caption = 'Variable Type'#65306
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ParentFont = False
      end
      object varValueMemo: TMemo
        Left = 2
        Top = 53
        Width = 238
        Height = 130
        Align = alClient
        Color = 12962247
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlue
        Font.Height = -13
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ImeName = #32043#20809#25340#38899#36755#20837#27861
        ParentFont = False
        ReadOnly = True
        ScrollBars = ssBoth
        TabOrder = 0
      end
    end
  end
  object MainMenu: TMainMenu
    AutoHotkeys = maManual
    Images = AllImage
    Left = 328
    object N1: TMenuItem
      Caption = '&File'
      object terminateMenuItem: TMenuItem
        Caption = '&Exit'
        OnClick = terminateMenuItemClick
      end
    end
    object N2: TMenuItem
      Caption = '&Edit'
      object N4: TMenuItem
        Action = EditCopy
      end
      object N6: TMenuItem
        Action = EditSelectAll
      end
      object N8: TMenuItem
        Caption = '-'
      end
      object N9: TMenuItem
        Action = SearchFind
      end
      object N10: TMenuItem
        Action = SearchFindNext
      end
      object FindFirst1: TMenuItem
        Action = SearchFindFirst
      end
    end
    object N25: TMenuItem
      Caption = '&View'
      object N26: TMenuItem
        Caption = 'Console'
        ShortCut = 16433
        OnClick = N26Click
      end
      object N28: TMenuItem
        Caption = 'Source code'
        ShortCut = 16434
        OnClick = N28Click
      end
      object N27: TMenuItem
        Caption = 'Breakpoint'
        ShortCut = 16435
        OnClick = N27Click
      end
      object N30: TMenuItem
        Caption = 'Class Loader'
        ShortCut = 16436
        OnClick = N30Click
      end
      object N31: TMenuItem
        Caption = 'Watch Window'
        ShortCut = 16437
        OnClick = N31Click
      end
      object N29: TMenuItem
        Caption = 'Debug infomation'
        ShortCut = 16438
        OnClick = N29Click
      end
      object N32: TMenuItem
        Caption = '-'
      end
      object IDE1: TMenuItem
        Caption = 'IDE window'
        ShortCut = 16432
        OnClick = IDE1Click
      end
      object N5: TMenuItem
        Caption = '-'
      end
      object Stayontop1: TMenuItem
        Caption = 'Stay on top'
        OnClick = Stayontop1Click
      end
    end
    object N11: TMenuItem
      AutoHotkeys = maManual
      Caption = '&Debug'
      object run1: TMenuItem
        Caption = '&Run'
        ImageIndex = 6
        ShortCut = 120
        OnClick = runBtnClick
      end
      object step1: TMenuItem
        Caption = '&Suspend'
        ImageIndex = 7
        OnClick = suspendBtnClick
      end
      object N12: TMenuItem
        Caption = 'Run -> Step'
        ImageIndex = 2
        ShortCut = 119
        OnClick = stepBtnClick
      end
      object step2: TMenuItem
        Caption = 'Run -> Step in'
        ImageIndex = 8
        ShortCut = 118
        OnClick = stepinBtnClick
      end
      object N13: TMenuItem
        Caption = 'Run -> Step out'
        ImageIndex = 1
        ShortCut = 117
        OnClick = stepoutBtnClick
      end
      object N14: TMenuItem
        Caption = '&Terminate'
        ImageIndex = 0
        ShortCut = 16497
        OnClick = exitBtnClick
      end
      object N20: TMenuItem
        Caption = '-'
      end
      object lineBpMenuItem: TMenuItem
        Caption = 'Create/Clear Line Breakpoint'
        ImageIndex = 9
        ShortCut = 116
        OnClick = breakBtnClick
      end
      object methodBpMenuItem: TMenuItem
        Caption = 'Create/Clear Function Breakpoint'
        OnClick = methodBpMenuItemClick
      end
      object exceptionBpMenuItem: TMenuItem
        Caption = 'Create/Clear Exception Breakpoint'
        OnClick = exceptionBpMenuItemClick
      end
      object N33: TMenuItem
        Caption = '-'
      end
      object setWatchVarMenuItem: TMenuItem
        Caption = '&New watch variable'
        OnClick = setWatchVarMenuItemClick
      end
      object N15: TMenuItem
        Caption = '-'
      end
      object terminateAllAppMenuItem: TMenuItem
        Caption = 'Terminate &All'
        OnClick = terminateAllAppMenuItemClick
      end
      object N17: TMenuItem
        Caption = '-'
      end
    end
    object N35: TMenuItem
      Caption = '&Tools'
      object CreateJavaMenuItem: TMenuItem
        Caption = 'Startup java application'
        Enabled = False
        ShortCut = 16471
        OnClick = CreateJavaMenuItemClick
      end
      object CreateAppletMenuItem: TMenuItem
        Caption = 'Startup applet'
        Enabled = False
        ShortCut = 16449
        OnClick = CreateAppletMenuItemClick
      end
      object N38: TMenuItem
        Caption = 'Config source path'
        Enabled = False
        OnClick = setSourcePathItemClick
      end
      object N7: TMenuItem
        Caption = '-'
      end
      object startDebugServerMenuItem: TMenuItem
        Caption = 'Startup debug server center'
        ShortCut = 16504
        OnClick = startDebugServerMenuItemClick
      end
    end
    object N24: TMenuItem
      Caption = '&Help'
      object U1: TMenuItem
        Caption = 'JDEV debug  &help'
        ShortCut = 112
      end
      object N3: TMenuItem
        Caption = '-'
      end
      object A1: TMenuItem
        Caption = '&About JDev Debug'
      end
    end
  end
  object AllImage: TImageList
    Left = 488
    Bitmap = {
      494C010110001300040010001000FFFFFFFFFF10FFFFFFFFFFFFFFFF424D3600
      0000000000003600000028000000400000005000000001001000000000000028
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000B41DB41DB41DB41DB41DB41DB41D
      B41DB41DB41DB41DB41DB41DB41DB41DB41D0000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000B41DB41DB41DB41DB41DB41DB41D
      B41DB41DB41DB41DB41DB41DB41DB41DB41D0000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000B41DB41DB41DB41DB41DB41DB41D
      B41DB41DB41DB41DB41DB41DB41DB41DB41D0000FF7F00000000000000000000
      0000000000000000FF7F00000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000B41DB41D10421863186318631863
      186318631863186318631042B41DB41DB41D0000FF7F00000000000000000000
      0000000000000000FF7F00000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000B41DB41D10421863186318631000
      18631863186318631863EF3DB41DB41DB41D0000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      104200000000000000000000000000000000B41DB41D10421863186310001000
      18631863100018631863EF3DB41DB41DB41D00000000FF7F0000000000000000
      00000000FF7F0000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000B41DB41D10421863186318631863
      100010001863186318631042B41DB41DB41D00000000FF7F0000000000001863
      00000000FF7F0000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000001042
      000010420000000000000000000000000000B41DB41D10421863104218631863
      100010001863186318630F3EB41DB41DB41D00000000FF7F0000000000001863
      00000000FF7F0000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000B41DB41D10421863100010421042
      100010001000186318631042B41DB41DB41D0000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000B41DB41D10421863186310001042
      186318631000186318631042B41DB41DB41D000000000000FF7F000000000000
      00000000FF7F0000000000000000000000000000000000000000000000000000
      1042000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000B41DB41D10421863186318631000
      100018631863186318631042B41DB41DB41D0000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000B41DB41D10421863186318631863
      186318631863186318631042B41DB41DB41D0000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000001042
      0000104200000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000B41DB41D10421042104210421042
      104210421042104210420F3EB41DB41DB41D0000000000000000FF7F00000000
      000000000000FF7F000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000B41DB41DB41DB41DB41DB41DB41D
      B41DB41DB41DB41DB41DB41DB41DB41DB41D0000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000B41DB41DB41DB41DB41DB41DB41D
      B41DB41DB41DB41DB41DB41DB41DB41DB41D0000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000B41DB41DB41DB41DB41DB41DB41D
      B41DB41DB41DB41DB41DB41DB41DB41DB41D2925E71CE71CE71CE71CE71CE71C
      E71CE71CE71CE71CE71CE71CE71CE71C29250000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000003967F75EF75EF75EF75EF75EF75E
      F75EF75EF75EF75EF75EF75EF75EF75E8C310000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000010001000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000003967186318631863186318631863
      1863186318631863186318631863F75E8C310000000000000000000000000000
      0000000000000000000000000000000000000000000000000000100000000000
      1000000000001000100000000000000000000000000000000000000000000000
      100010001000100010001000100010001000396718631863D65AC618734E1863
      1863186318631863C61831461863F75E8C310000000000000000000000000000
      007C007C00000000000000000000000000000000000000000000100000000000
      1000000010000000000010000000000000000000000000000000000000000000
      1000FF7FFF7FFF7FFF7FFF7FFF7FFF7F10003967186318632104210494521863
      1863186318631863082100001863F75E8C3100000000000000000000007C007C
      007C007C007C007C000000000000000000000000000000000000100000000000
      1000000010000000000010000000000000000000000000000000000000000000
      1000FF7F00000000000000000000FF7F100039671863186300008C3118631863
      1863186318631863186300001863F75E8C310000000000000000007C007C007C
      007C007C007C007C007C00000000000000000000000000000000000010001000
      1000000010000000000010000000000000000000000000000000000000000000
      1000FF7FFF7FFF7FFF7FFF7FFF7FFF7F10003967186318630000314618631863
      1863316618631863186300001863F75E8C310000000000000000007C007C007C
      007C007C007C007C007C00000000000000000000000000000000000000000000
      10000000100010001000000000000000000000000000FF7FFF7FFF7FFF7FFF7F
      1000FF7F00000000000000000000FF7F100039671863C6180000186318631863
      5266C67418631863186321040000F75E8C31000000000000007C007C007C007C
      007C007C007C007C007C007C0000000000000000000000000000000000000000
      10000000100000000000000000000000000000000000FF7F0000000000000000
      1000FF7FFF7FFF7FFF7FFF7FFF7FFF7F100039671863186300008C3118637366
      007C007C84741863186300001863F75E8C31000000000000007C007C007C007C
      007C007C007C007C007C007C0000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000FF7FFF7FFF7FFF7FFF7F
      1000FF7F00000000FF7F100010001000100039671863186300008C311863EF69
      AD6D007CAD6D9466186300001863F75E8C310000000000000000007C007C007C
      007C007C007C007C007C00000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000FF7F0000000000000000
      1000FF7FFF7FFF7FFF7F1000FF7F10000000396718631863630C000031461863
      1863007C18631863000000001863F75E8C310000000000000000007C007C007C
      007C007C007C007C007C00000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000FF7FFF7FFF7FFF7FFF7F
      1000FF7FFF7FFF7FFF7F100010000000000039671863186318633146D65A1863
      1863007C18631863314618631863F75E8C3100000000000000000000007C007C
      007C007C007C007C000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000FF7F00000000FF7F0000
      100010001000100010001000000000000000396718631863007C007C007C007C
      007C007C18631863186318631863F75E8C310000000000000000000000000000
      007C007C00000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000FF7FFF7FFF7FFF7F0000
      FF7F000000000000000000000000000000003967186318631863186318631863
      1863186318631863186318631863F75E8C310000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000FF7FFF7FFF7FFF7F0000
      0000000000000000000000000000000000003967186318631863186318631863
      1863186318631863186318631863F75E8C310000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000007B6F5A6B5A6B5A6B5A6B5A6B5A6B
      5A6B5A6B5A6B5A6B5A6B5A6B5A6B5A6B10420000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000002925E71CE71CE71CE71CE71CE71C
      E71CE71CE71CE71CE71CE71CE71CE71C29252925E71CE71CE71CE71CE71CE71C
      E71CE71CE71CE71CE71CE71CE71CE71C29252925E71CE71CE71CE71CE71CE71C
      E71CE71CE71CE71CE71CE71CE71CE71C29252925E71CE71CE71CE71CE71CE71C
      E71CE71CE71CE71CE71CE71CE71CE71C29253967F75EF75EF75EF75EF75EF75E
      F75EF75EF75EF75EF75EF75EF75EF75E8C313967F75EF75EF75EF75EF75EF75E
      F75EF75EF75EF75EF75EF75EF75EF75E8C313967F75EF75EF75EF75EF75EF75E
      F75EF75EF75EF75EF75EF75EF75EF75E8C313967F75EF75EF75EF75EF75EF75E
      F75EF75EF75EF75EF75EF75EF75EF75E8C3139671863F75E9452186318631863
      1863186318631863186318631863F75E8C31396718635A6BFF7FFF7FFF7FFF7F
      FF7FFF7FFF7FFF7FFF7FFF7F8410F75E8C3139671863E500734A186318631863
      1863186318631863186318631863F75E8C313967186300540020002000201863
      1863186300540020002000201863F75E8C3139671863F75EE508186318631863
      9456945618631863186318631863F75E8C3139671863FF7FFF7FFF7FFF7FFF7F
      FF7FFF7FFF7FFF7FFF7FFF7FCE39F75E8C3139671863EA09C3008200D65A1863
      1863186318631863186318631863F75E8C3139671863E77C007C007C00641863
      18631863E77C007C007C00641863F75E8C3139671863D65ACA01C514270D701A
      B22E701E89016304D65A18631863F75E8C313967AD35FF7F0000000000000000
      00000000000000000000FF7F1863F75E8C31396718634E1EC90146018200C408
      F75E186318631863186318631863F75E8C3139671863E77C007C007C00641863
      18631863E77C007C007C00641863F75E8C31396718630E360D06AA01F65E1863
      18631863F762164F890129251863F75E8C313967630CFF7FFF7FFF7FFF7FFF7F
      FF7FFF7FFF7FFF7FFF7F39671863F75E8C31396718634E1EEA09C901A8012501
      6200071518631863186318631863F75E8C3139671863E77C007C007C00641863
      18631863E77C007C007C00641863F75E8C313967D65EF65EF656B2328B2D1863
      1863186318631863F76268091863F75E8C3139670000FF7FFF7FFF7FFF7FFF7F
      FF7FFF7FFF7FFF7FFF7FC6181863F75E8C31396718634E1EEA09C901C901C901
      A801050162008B29186318631863F75E8C3139671863E77C007C007C00641863
      18631863E77C007C007C00641863F75E8C313967186318631863F75EF75E1863
      18631863186318631863B55A1863F75E8C313967104200000000000000000000
      0000000000000000FF7F00001863F75E8C31396718634E1EEA09C901C901C901
      C901C9018701E40062000F3A1863F75E8C3139671863E77C007C007C00641863
      18631863E77C007C007C00641863F75E8C313967186318631863186318631863
      1863186318631863186318631863F75E8C313967BD771042000000001042FF7F
      FF7F7B6FE71C4208F75EE71C1863F75E8C31396718634E1EEA09C901C901C901
      C901C901E901EA09EA05A801B54EF75E8C3139671863E77C007C007C00641863
      18631863E77C007C007C00641863F75E8C313967186372521863186318631863
      18631863F75ED65A186318631863F75E8C3139678C3111365D4B5D4B11368C31
      8C3111365D4B5D4B11368C311863F75E8C31396718634E1EEA09C901C901C901
      C901EA094D1A6F22D54E18631863F75E8C3139671863E77C007C007C00641863
      18631863E77C007C007C00641863F75E8C3139671863CA0D4929186318631863
      18631863503E0601A510AC31B556F75E8C31396700005D4B5D4B5D4B5D4B0000
      00005D4B5D4B5D4B5D4B00001863F75E8C31396718634E1EEA09C901C901EA05
      2D166F22B3421863186318631863F75E8C3139671863E77C007C007C00641863
      18631863E77C007C007C00641863F75E8C3139671863D55E4F166304B5561863
      18631863F75E2E12CB01AB291863F75E8C31396700005D4B5D4B5D4B5D4B0000
      00005D4B5D4B5D4B5D4B00001863F75E8C31396718634E1EEA09EA052C124E1E
      9132186318631863186318631863F75E8C3139671863E77C007C007C00641863
      18631863E77C007C007C00641863F75E8C31396718631863F762164F4F166801
      27018901502EF6562E0EB4561863F75E8C3139678C3111365D4B5D4B11368C31
      8C3111365D4B5D4B11364A291863F75E8C31396718636F224E1A4E1E902A1863
      1863186318631863186318631863F75E8C3139671863E77C007C007C00641863
      18631863E77C007C007C00641863F75E8C31396718631863186318631863F762
      F75E186318631863B33EF75E1863F75E8C31396718638C31000000008C311863
      18638C31000000008C31630C00003146082139671863F542912EF75E18631863
      1863186318631863186318631863F75E8C31396718638C7D087D087D427C1863
      186318638C7D087D087D427C1863F75E8C313967186318631863186318631863
      1863186318631863F65EF75E1863F75E8C31396718631863630C000031461042
      186318631863186318631863734ECE398C3139671863F75A1863186318631863
      1863186318631863186318631863F75E8C313967186318631863186318631863
      1863186318631863186318631863F75E8C317B6F5A6B5A6B5A6B5A6B5A6B5A6B
      5A6B5A6B5A6B5A6B5A6B5A6B5A6B5A6B10427B6F5A6B5A6B5A6BB556EF3D5A6B
      5A6B5A6B5A6B5A6B5A6B5A6B5A6B5A6B10427B6F5A6B5A6B5A6B5A6B5A6B5A6B
      5A6B5A6B5A6B5A6B5A6B5A6B5A6B5A6B10427B6F5A6B5A6B5A6B5A6B5A6B5A6B
      5A6B5A6B5A6B5A6B5A6B5A6B5A6B5A6B10422925E71CE71CE71CE71CE71CE71C
      E71CE71CE71CE71CE71CE71CE71CE71C29252925E71CE71CE71CE71CE71CE71C
      E71CE71CE71CE71CE71CE71CE71CE71C29252925E71CE71CE71CE71CE71CE71C
      E71CE71CE71CE71CE71CE71CE71CE71C29252925E71CE71CE71CE71CE71CE71C
      E71CE71CE71CE71CE71CE71CE71CE71C29253967F75EF75EF75EF75EF75EF75E
      F75EF75EF75EF75EF75EF75EF75EF75E8C313967F75EF75EF75EF75EF75EF75E
      F75EF75EF75EF75EF75EF75EF75EF75E8C313967F75EF75EF75EF75EF75EF75E
      F75EF75EF75EF75EF75EF75EF75EF75E8C313967F75EF75EF75EF75EF75EF75E
      F75EF75EF75EF75EF75EF75EF75EF75E8C313967186300280020002000200020
      0020002000200020002000200020F75E8C31396718631863D65AC618734E1863
      18631863C6186B2D186318631863F75E8C313967186318630000000018631863
      186318631863C618000094521863F75E8C313967186318631863186318631863
      1863186318631863186318631863F75E8C3139671863847C007C007C007C007C
      007C007C007C007C007C007C0038F75E8C313967186318632104210494521863
      186318638C310000314618631863F75E8C313967186318630000186318631863
      186318631863186300008C311863F75E8C313967186318631863186318631863
      1863186318631863186318631863F75E8C3139671863847C007C007C007C007C
      007C007C007C007C007C007C0038F75E8C3139671863186300008C3118631863
      1863186318630000314618631863F75E8C313967186318630000186318631863
      186318631863186300008C311863F75E8C313967186318631863186318631863
      1863186318631863186318631863F75E8C3139671863847C007C007C007C007C
      007C007C007C007C007C007C0038F75E8C31396718631863000031461863007C
      1863186318630000292518631863F75E8C313967186300002104186318631863
      18631863186318638C310000734EF75E8C3139671863186318631863B5621863
      1863186352661863186318631863F75E8C3139671863847C007C007C007C007C
      007C007C007C007C007C007C0038F75E8C3139671863C618000018631863007C
      1863186318633146000018631863F75E8C3139671863630C0000186318631863
      1863186318631863292500009452F75E8C313967186318631863F762007CB562
      18638C6D217C1863186318631863F75E8C3139671863847C007C007C007C007C
      007C007C007C007C007C007C0038F75E8C3139671863186300008C311863007C
      18631863186300008C3118631863F75E8C313967186318630000186318631863
      186318631863186300008C311863F75E8C313967E07EE07EE07EE17E5266007C
      6B6D4278F762E07EE07EE07EE07EEC6E8C3139671863847C007C007C007C007C
      007C007C007C007C007C007C0038F75E8C3139671863186300008C311863007C
      1863186318630000314618631863F75E8C313967186318630000186318631863
      186318631863186300008C311863F75E8C313967007FE07EE07E017F1863E774
      007CF7621863007FE07E007F007FEC6E8C3139671863847C007C007C007C007C
      007C007C007C007C007C007C0038F75E8C31396718631863630C00003146007C
      1863186300000000D65A18631863F75E8C313967186318632104000018631863
      186318631863C618000018631863F75E8C3139671863186318631863AD6D4278
      9466007CD6621863186318631863F75E8C3139671863847C007C007C007C007C
      007C007C007C007C007C007C0038F75E8C3139671863186318633146D65A007C
      186318633146D65AF76218631863F75E8C313967186318631863186318631863
      186318631863F762186318631863F75E8C31396718631863186373662178F762
      18639466007C1863186318631863F75E8C3139671863847C007C007C007C007C
      007C007C007C007C007C007C0038F75E8C31396718631863186318631863007C
      186318631863AD6D847818631863F75E8C31396718631863007C186318631863
      18631863186342780871EF69316AF75E8C313967186318631863186394661863
      1863186318631863186318631863F75E8C3139671863847C007C007C007C007C
      007C007C007C007C007C007C0038F75E8C31396718631863186318631863007C
      007C007C007C007C007CC6741863F75E8C31396718631863007C007CCE6D1863
      186318631863EF69007C217C1863F75E8C313967186318631863186318631863
      1863186318631863186318631863F75E8C31396718636B7D087D087D087D087D
      087D087D087D087D087D087D0050F75E8C313967186318631863186318631863
      186318631863AD6D007C52661863F75E8C313967186318631863AD6D007C007C
      007C007C007C106AA57408751863F75E8C313967186318631863186318631863
      1863186318631863186318631863F75E8C313967186318631863186318631863
      1863186318631863186318631863F75E8C313967186318631863186318631863
      186318631863AD6D526618631863F75E8C313967186318631863186318631863
      7366186318631863526673661863F75E8C313967186318631863186318631863
      1863186318631863186318631863F75E8C3138635A6B5A6B5A6B5A6B5A6B5A6B
      5A6B5A6B5A6B5A6B5A6B5A6B5A6B5A6B10427B6F5A6B5A6B5A6B5A6B5A6B5A6B
      5A6B5A6B5A6B5A6B5A6B5A6B5A6B5A6B10427B6F5A6B5A6B5A6B5A6B5A6B5A6B
      5A6B5A6B5A6B5A6B5A6BF76A5A6B5A6B10427B6F5A6B5A6B5A6B5A6B5A6B5A6B
      5A6B5A6B5A6B5A6B5A6B5A6B5A6B5A6B1042424D3E000000000000003E000000
      2800000040000000500000000100010000000000800200000000000000000000
      000000000000000000000000FFFFFF0000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000FFFFFFFDC3850000FFFFFFF8D3A50000
      07C1FFF0D3A5000007C1FFFDD3A5000007C1FFFDC10500000101C385D0450000
      0001D3A5D04500000001D3A5E10D00000001D3A5F39D00008003C105F39D0000
      C107D045FFFD0000C107D045FFFD0000E38FE10DFFF00000E38FF39DFFF80000
      E38FF39DFFFD0000FFFFFFFFFFFF00000000FFFFFFFFFFFF0000FFFFF9FFFFFF
      0000FFFFF6CFFE000000FE7FF6B7FE000000F81FF6B7FE000000F00FF8B78000
      0000F00FFE8F80000000E007FE3F80000000E007FF7F80000000F00FFE3F8001
      0000F00FFEBF80030000F81FFC9F80070000FE7FFDDF807F0000FFFFFDDF80FF
      0000FFFFFDDF81FF0000FFFFFFFFFFFF00000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000400000000
      0000080000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000}
  end
  object SynJavaSyn: TSynJavaSyn
    DefaultFilter = 'Java files (*.java)|*.java'
    CommentAttri.Foreground = clGreen
    DocumentAttri.Foreground = clGreen
    KeyAttri.Foreground = clBlue
    NumberAttri.Foreground = clPurple
    StringAttri.Foreground = clRed
    Left = 24
    Top = 312
  end
  object appNodePopupMenu: TPopupMenu
    Left = 56
    Top = 104
    object setSourcePathItem: TMenuItem
      Caption = 'Config Source &Path'
      OnClick = setSourcePathItemClick
    end
  end
  object watchVarPopupMenu: TPopupMenu
    Left = 112
    Top = 352
    object addWatchVarMenuItem: TMenuItem
      Caption = 'Add Variable'
      OnClick = addWatchVarMenuItemClick
    end
    object N44: TMenuItem
      Caption = 'Rename Variable'
      OnClick = N44Click
    end
    object N40: TMenuItem
      Caption = 'Delete Variable'
      OnClick = N40Click
    end
    object N41: TMenuItem
      Caption = 'Clear All Variable'
      OnClick = N41Click
    end
    object N42: TMenuItem
      Caption = 'Refresh'
      OnClick = N42Click
    end
    object N43: TMenuItem
      Caption = 'Refresh All'
      OnClick = N43Click
    end
  end
  object bpPopupMenu: TPopupMenu
    AutoHotkeys = maManual
    Left = 72
    Top = 352
    object addBp: TMenuItem
      Caption = 'Add Breakpoint'
      OnClick = addBpClick
    end
    object delBp: TMenuItem
      Caption = 'Delete Breakpoint'
      OnClick = delBpClick
    end
    object delAllBp: TMenuItem
      Caption = 'Delete All Breakpoint'
      OnClick = delAllBpClick
    end
  end
  object bpImagelist: TImageList
    Left = 152
    Top = 352
    Bitmap = {
      494C010103000400040010001000FFFFFFFFFF10FFFFFFFFFFFFFFFF424D3600
      0000000000003600000028000000400000001000000001001000000000000008
      0000000000000000000000000000000000002725C418C418C418C418C418C418
      C418C418C418C418C418C418C418C418C4182725C418C418C418C418C418C418
      C418C418C418C418C418C418C418C418C4182725C418C418C418C418C418C418
      C418C418C418C418C418C418C418C418C4180000000000000000000000000000
      0000000000000000000000000000000000001463F25EF25EF25EF25EF25EF25E
      F25EF25EF25EF25EF25EF25EF25EF25EC4181463F25EF25EF25EF25EF25EF25E
      F25EF25EF25EF25EF25EF25EF25EF25EC4181463F25EF25EF25EF25EF25EF25E
      F25EF25EF25EF25EF25EF25EF25EF25EC4180000000000000000000000000000
      0000000000000000000000000000000000001463F25EF25EF25EF25EF25EF25E
      F25EF25EF25EF25EF25EF25EF25EF25EC4181463F25EF25EF25EF25EF25EF25E
      F25EF25E2D46F25EF25EF25EF25EF25EC4181463F25EF25EF25EF25EF25EF25E
      2D462D462D462D462D462D466F4EF25EC4180000000000000000000000000000
      0000000000000000000000000000000000001463F25EF25E0000000000000000
      D25AD25A0000000000000000F25EF25EC4181463F25EF25EF25EF25EF25ED25A
      D25AD25A0000F25EF25EF25EF25EF25EC4181463F25EF25EF25EF25EF25ED25A
      000000000000000000000000A414F25EC4180000000000000000000000000000
      0000000000000000000000000000000000001463F25E00000000000000000000
      0000D25A00000000000000000000F25EC4181463F25EF25EF25ED25AD25AD25A
      D25AD25A0000D25AF25EF25EF25EF25EC4181463F25EF25EF25ED25AD25AD25A
      0000692DD25AD25AF25EF25EF25EF25EC4180000000000000000000000000000
      0000000000000000000000000000000000001463F25EF25ED25AD25AD25AD25A
      D25AD25AD25AD25AD25AF25EF25EF25EC4181463F25EF25ED25AD25AD25AD25A
      D25AD25A0000D25AD25AF25EF25EF25EC4181463F25EF25ED25AD25AD25AD25A
      0000692DD25AD25AD25AF25EF25EF25EC4180000000000000000000000000000
      0000000000000000000000000000000000001463F25EF25ED25AD25AD25AD25A
      D25AD25AD25AD25AD25AD25AF25EF25EC4181463F25EF25ED25AD25AD25AD25A
      D25AD25A0000D25AD25AD25AF25EF25EC4181463F25EF25ED25AD25AD25AD25A
      0000692DD25AD25AD25AD25AF25EF25EC4180000000000000000000000000000
      0000000000000000000000000000000000001463F25E8378007C0D66D25AD15A
      D15AD15AD25AD25AD25AD25AF25EF25EC4181463F25E8378007C0D66D25AD15A
      D15AD15A0000D25AD25AD25AF25EF25EC4181463F25E8378007C0D66D25AD15A
      0000682DD25AD25AD25AD25AF25EF25EC4180000000000000000000000000000
      0000000000000000000000000000000000001463896D007C007C007CD25AD15A
      0000000000000000000000000000F25EC4181463896D007C007C007CD25AD15A
      D15AD15A0000D25AD25AD25AF25EF25EC4181463896D007C007C007CD25AD15A
      000000000000000000000000F25EF25EC4180000000000000000000000000000
      0000000000000000000000000000000000001463696D007C007C007CD25AD25A
      000000000000000000000000F25EF25EC4181463696D007C007C007CD25A0D42
      000000000000000000000000F25EF25EC4181463696D007C007C007CD25AD25A
      0000682DD25AD25AD25AD25AF25EF25EC4180000000000000000000000000000
      0000000000000000000000000000000000001463F25E6278007CCB69D25AD25A
      D25AD25AD25AD25AD25AF25EF25EF25EC4181463F25E6278007CCB69D25AD25A
      D25AD25A0000D25AD25AF25EF25EF25EC4181463F25E6278007CCB69D25AD25A
      0000692DD25AD25AD25AF25EF25EF25EC4180000000000000000000000000000
      0000000000000000000000000000000000001463F25EF25ED25AD25AD25A0000
      00000000D25AD25A000000000000F25EC4181463F25EF25ED25AD25AD25AD25A
      D25AD25A0000B156D25AF25EF25EF25EC4181463F25EF25ED25AD25AD25AD25A
      0000692DD25AD25AD25AF25EF25EF25EC4180000000000000000000000000000
      0000000000000000000000000000000000001463F25EF25EF25ED25A00000000
      00000000D25A0000000000000000F25EC4181463F25EF25EF25ED25AD25AD25A
      D25AD25A00008310F25E2D46CB39F25EC4181463F25EF25EF25ED25AD25AD25A
      000006212D462D462D462D46F25EF25EC4180000000000000000000000000000
      0000000000000000000000000000000000001463F25EF25EF25EF25EF25ED25A
      D25AD25AF25EF25EF25EF25EF25EF25EC4181463F25EF25EF25EF25EF25ED25A
      D25AD25A4E4A000000000000692DF25EC4181463F25EF25EF25EF25EF25ED25A
      000000000000000000000000F25EF25EC4180000000000000000000000000000
      0000000000000000000000000000000000001463F25EF25EF25EF25EF25EF25E
      F25EF25EF25EF25EF25EF25EF25EF25EC4181463F25EF25EF25EF25EF25EF25E
      F25EF25EF25EF25EF25EF25EF25EF25EC4181463F25EF25EF25EF25EF25EF25E
      F25EF25EF25EF25EF25EF25EF25EF25EC4180000000000000000000000000000
      0000000000000000000000000000000000003567146314631463146314631463
      14631463146314631463146314631463E51C3567146314631463146314631463
      14631463146314631463146314631463E51C3567146314631463146314631463
      14631463146314631463146314631463E51C0000000000000000000000000000
      000000000000000000000000000000000000424D3E000000000000003E000000
      2800000040000000100000000100010000000000800000000000000000000000
      000000000000000000000000FFFFFF0000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000}
  end
  object CommSocket: TServerSocket
    Active = False
    Port = 7899
    ServerType = stNonBlocking
    OnListen = CommSocketListen
    OnAccept = CommSocketAccept
    OnClientConnect = CommSocketConnect
    OnClientDisconnect = CommSocketClientDisconnect
    OnClientRead = CommSocketRead
    Left = 24
    Top = 64
  end
  object threadImageList: TImageList
    Left = 56
    Top = 64
    Bitmap = {
      494C010109000E00040010001000FFFFFFFFFF10FFFFFFFFFFFFFFFF424D3600
      0000000000003600000028000000400000004000000001001000000000000020
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000002725C418C418C418C418C418C418
      C418C418C418C418C418C418C418C418C4180000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000001463F25EF25EF25EF25EF25EF25E
      F25EF25EF25EF25EF25EF25EF25EF25EC4180000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000001463F25EF25E00000000F25EF25E
      F25EF25EF25EF25EF25EF25EF25EF25EC4180000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000001463F25EF25E00000000F25ED25A
      D25AD25AD25AF25EF25EF25EF25EF25EC4180000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000001463F25EF25E000000000000D25A
      D25AD25AAB35D25AF25EF25EF25EF25EC4180000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000001463F25EF25ED25A000000000000
      0000000000000000D25AF25EF25EF25EC4180000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000001463F25EF25ED25AD25AD25AD25A
      D25A000000000000D25AD25AF25EF25EC4180000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000001463F25ED25AD25AD25AD25AD15A
      D15A000000000000D25AD25AF25EF25EC4180000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000001463F25ED25AD25AD25AD25AD15A
      D15A620C00000000D25AD25AF25EF25EC4180000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000001463F25ED25AD25AD25AD25AD25A
      D15A692D00000000B156D25AF25EF25EC4180000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000001463F25EF25ED25AD25AD25AD25A
      D25A6F4E00000D42D25AF25EF25EF25EC4180000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000001463F25EF25ED25AD25AD25AD25A
      D25AD25AEC3DD25AD25AF25EF25EF25EC4180000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000001463F25EF25EF25ED25AD25AD25A
      D25AA41400004829F25EF25EF25EF25EC4180000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000001463F25EF25EF25EF25EF25ED25A
      D25A000000000000F25EF25EF25EF25EC4180000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000001463F25EF25EF25EF25EF25EF25E
      F25E000000004108F25EF25EF25EF25EC4180000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000003567146314631463146314631463
      14631463146314631463146314631463E51C0000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000002725C418C418C418C418C418C418
      C418C418C418C418C418C418C418C418C4182725C418C418C418C418C418C418
      C418C418C418C418C418C418C418C418C4182725C418C418C418C418C418C418
      C418C418C418C418C418C418C418C418C4182725C418C418C418C418C418C418
      C418C418C418C418C418C418C418C418C4181463F25EF25EF25EF25EF25EF25E
      F25EF25EF25EF25EF25EF25EF25EF25EC4181463F25EF25EF25EF25EF25EF25E
      F25EF25EF25EF25EF25EF25EF25EF25EC4181463F25EF25EF25EF25EF25EF25E
      F25EF25EF25EF25EF25EF25EF25EF25EC4181463F25EF25EF25EF25EF25EF25E
      F25EF25EF25EF25EF25EF25EF25EF25EC4181463F25EF25EF25EF25E0000F25E
      F25EF25EF25EF25EF25EF25EF25EF25EC4181463F25EF25EF25EF25EF25EF25E
      F25EF25EF25EF25EF25EF25EF25EF25EC4181463F25EF25EF25EF25EF25EF25E
      F25EF25EF25EF25EF25EF25EF25EF25EC4181463F25EF25EF25EF25EEC3DA414
      00000000A414EC3DF25EF25EF25EF25EC4181463F25EF25EF25E000000000000
      D25AD25AD25AF25E0000F25EF25EF25EC418146300000000F25EF25EF25ED25A
      D25AD25AD25AF25EF25EF25EF25EF25EC4181463F25EF25EF25EF25EF25ED25A
      D25AD25AD25AF25EF25EF25EF25EF25EC4181463F25EF25E9052000000000000
      000000000000000000009052F25EF25EC4181463F25EF25EF25ED25A00000000
      0000D25A000000000000F25EF25EF25EC4181463000000000000D25AD25AD25A
      D25AD25AD25AD25AF25EF25EF25EF25EC41814630000692DF25ED25A00000000
      0000000000000000000000000000F25EC4181463F25EF25E000000000621D25A
      D25AD25AD25A062100000000F25EF25EC4181463F25EF25ED25AD25AD25A0000
      00000000000000000000F25EF25EF25EC4181463F25E00000000D25AD25AD25A
      D25AD25AD25AD25AD25AF25EF25EF25EC41814630000000000004F4A00000000
      0000000000000000000000000000F25EC4181463F25EC51800008A31D25AD25A
      D25AD25AD25AD25A8A310000C518F25EC4181463F25EF25ED25AD25AD25AD25A
      000000000000D25AD25AD25AF25EF25EC4181463F25E00000000000000000000
      000000000000D25AD25AD25AF25EF25EC4181463000000000000000000000000
      0000000000000000000000000000F25EC4181463F25E00002104D25AD25AD25A
      D25AD25AD25AD25AD25A21040000F25EC4181463F25ED25AD25A000000000000
      0000000000000000D25AD25AF25EF25EC4181463F25ED25AD25AD25AD25AD15A
      0000000000000000D25AD25AF25EF25EC4181463000000000000000000000000
      0000000000000000000000000000F25EC4181463F25E00008A31D25AD25AD15A
      D15AD15AD25AD25AD25A8A310000F25EC4181463F25ED25AD25A000000000000
      00000000000000000000D25AF25EF25EC4181463F25ED25AD25AD25AD25AD15A
      D15A00000000000000000000F25EF25EC4181463000000000000000000000000
      0000000000000000000000000000F25EC4181463F25E00009052D25AD25AD15A
      0000000000000000D25A90520000F25EC4181463F25ED25AD25AD25A00000000
      0000000000000000D25AD25AF25EF25EC4181463F25ED25AD25AD25AD25AD25A
      D15AD15A0000000000000000F25EF25EC418146300000000EC3DD25A00000000
      0000000000000000000000000000F25EC4181463F25E00008A31D25AD25AD25A
      00000000D25AD25AD25A8A310000F25EC4181463F25EF25ED25AD25AD25A0000
      0000D25AD25AD25AD25AF25EF25EF25EC4181463F25EF25ED25AD25AD25AD25A
      D25AD25AD25AD25A00000000F25EF25EC41814630621F25ED25AD25A00000000
      0000000000000000000000000000F25EC4181463F25E00002104D25AD25AD25A
      00000000D25AD25AD25A21040000F25EC4181463F25EF25ED25AD25AD25AD25A
      AA35D25AD25AD25AD25AF25EF25EF25EC4181463F25EF25ED25AD25AD25AD25A
      D25AD25AD25AD25AD25AAB35F25EF25EC4181463F25EF25ED25AD25AD25A0000
      00000000D25AD25AD25AF25EF25EF25EC4181463F25EC51800008A31D25AD25A
      00000000D25AD25A8A310000C518F25EC4181463F25EF25EF25ED25AD25A0000
      00000000D25AD25AF25EF25EF25EF25EC4181463F25EF25EF25ED25AD25AD25A
      D25AD25AD25AD25A000000000000F25EC4181463F25EF25EF25ED25AD25AD25A
      00000000000000000000F25EF25EF25EC4181463F25EF25E000000000621D25A
      D25AD25AD25A062100000000F25EF25EC4181463F25EF25EF25EF25EF25E0000
      00000000F25EF25EF25EF25EF25EF25EC4181463F25EF25EF25EF25EF25ED25A
      D25AD25AF25EF25E000000000000F25EC4181463F25EF25EF25EF25EF25ED25A
      D25AD25A0000000000000000F25EF25EC4181463F25EF25E9052000000000000
      000000000000000000009052F25EF25EC4181463F25EF25EF25EF25EF25EEC3D
      00006F4EF25EF25EF25EF25EF25EF25EC4181463F25EF25EF25EF25EF25EF25E
      F25EF25EF25EF25EEC3D00006F4EF25EC4181463F25EF25EF25EF25EF25EF25E
      F25EF25EF25EF25EF25EF25EF25EF25EC4181463F25EF25EF25EF25EEC3DA414
      00000000A414EC3DF25EF25EF25EF25EC4183567146314631463146314631463
      14631463146314631463146314631463E51C3567146314631463146314631463
      14631463146314631463146314631463E51C3567146314631463146314631463
      14631463146314631463146314631463E51C3567146314631463146314631463
      14631463146314631463146314631463E51C2725C418C418C418C418C418C418
      C418C418C418C418C418C418C418C418C4182725C418C418C418C418C418C418
      C418C418C418C418C418C418C418C418C4182725C418C418C418C418C418C418
      C418C418C418C418C418C418C418C418C4182725C418C418C418C418C418C418
      C418C418C418C418C418C418C418C418C4181463F25EF25EF25EF25EF25EF25E
      F25EF25EF25EF25EF25EF25EF25EF25EC4181463F25EF25EF25EF25EF25EF25E
      F25EF25EF25EF25EF25EF25EF25EF25EC4181463F25EF25E0000000000000000
      00000000000000000000F25EF25EF25EC4181463F25EF25EF25EF25EF25EF25E
      F25EF25EF25EF25EF25EF25EF25EF25EC4181463000000000000000000000000
      0000F25E00000000000000000000F25EC4181463F25EF25EF25E000000000000
      0000000000000000F25EF25EF25EF25EC4181463000000000000000000000000
      2725000000000000000000000000F25EC4181463F25EF25EF25EF25EF25EF25E
      692D2D46F25EF25EF25EF25EF25EF25EC418146300000000F25E00000000D25A
      0000D25A200448290000B1560000F25EC4181463F25EF25EF25E00000000D25A
      00000000D25A0000F25EF25EF25EF25EC4181463000000000000000000000000
      8310D25AD25A0000000000000000F25EC4181463F25EF25EF25EF25EF25ED25A
      0000692DD25AF25EF25EF25EF25EF25EC418146300000000F25E00000000D25A
      0000D25A200442080000A4140000F25EC4181463F25EF25EF25E00000000D25A
      00000000D25A0000F25EF25EF25EF25EC4181463000000000000000000000D42
      D25AD25AD25A00000000000000000000C4181463F25EF25EF25ED25AD25AD25A
      D25AD25AD25AD25AF25EF25EF25EF25EC4181463000000000000000000000000
      0000D25A20040000000020040000F25EC4181463F25EF25ED25A000000000000
      0000000000000000D25AF25EF25EF25EC41814630000000000000000D25AD25A
      D25AD25AD25A00000000000000000000C4181463F25EF25ED25AD25AD25AD25A
      D25AD25AD25AD25AD25AF25EF25EF25EC4181463000000000000000000000000
      0000D25A200448290000B1560000F25EC4181463F25EF25ED25A000000000000
      0000000000000000D25AD25AF25EF25EC418146300000000D25AD25AD25AD25A
      D25AD25AD25AD25AD25A000000000000C4181463F25EF25ED25AD25AD25AD25A
      0000CB39D25AD25AD25AD25AF25EF25EC418146300000000D25A00000000D15A
      0000D15A20040000000000000000F25EC4181463F25ED25AD25A00000000D15A
      00000000D25A0000D25AD25AF25EF25EC418146300000000D25AD25AD25AD15A
      D15AD15AD25AD25AD25A000000000000C4181463F25ED25AD25AD25AD25AD15A
      21040000D25AD25AD25AD25AF25EF25EC418146300000000D25A00000000D15A
      0000D15A2004C5180000AA350000F25EC4181463F25ED25AD25A00000000D15A
      00000000D25A0000D25AD25AF25EF25EC418146300000000D25AD25AD25AD15A
      D15AD15AD25AD25AD25A000000000000C4181463F25ED25AD25AD25AD25AD15A
      D15A00000000D25AD25AD25AF25EF25EC4181463000000000000000000000000
      0000D15A20040000000021040000F25EC4181463F25ED25AD25A000000000000
      0000000000000000D25AD25AF25EF25EC418146300000000D25AD25AD25AD25A
      D15AD15AD25AD25AD25A000000000000C4181463F25ED25AD25AD25AD25AD25A
      D15A6F4E0000A414D25AD25AF25EF25EC4181463000000000000000000000000
      0000D25A42082104210421042104F25EC4181463F25EF25ED25A000000000000
      0000000000000000D25AF25EF25EF25EC418146300000000D25AD25AD25AD25A
      D25AD25AD25AD25AD25A000000000000C4181463F25EF25ED25A2D460000D25A
      D25AD25A00000000D25AF25EF25EF25EC418146300000000D25A00000000D25A
      0000D25AD25AD25AD25AF25EF25EF25EC4181463F25EF25ED25A00000000D25A
      00000000D25A0000D25AF25EF25EF25EC418146300000000D25AD25AD25AD25A
      D25AD25AD25AD25AD25A000000000000C4181463F25EF25ED25AD25A0000CB39
      D25AD25A00000000D25AF25EF25EF25EC418146300000000F25E00000000D25A
      0000D25AD25AD25AF25EF25EF25EF25EC4181463F25EF25EF25E00000000D25A
      00000000D25A0000F25EF25EF25EF25EC4181463000000000000D25AD25AD25A
      D25AD25AD25AD25A0000000000000000C4181463F25EF25EF25ED25A21040000
      420800000000A414F25EF25EF25EF25EC4181463000000000000000000000000
      0000D25AF25EF25EF25EF25EF25EF25EC4181463F25EF25EF25E000000000000
      0000000000000000F25EF25EF25EF25EC4181463000000000000000000000000
      0000000000000000000000000000F25EC4181463F25EF25EF25EF25EF25EE51C
      00000000692DF25EF25EF25EF25EF25EC4181463000000000000000000000000
      0000F25EF25EF25EF25EF25EF25EF25EC4181463F25EF25EF25E000000000000
      0000000000000000F25EF25EF25EF25EC4181463F25E00000000000000000000
      0000000000000000000000000000F25EC4181463F25EF25EF25EF25EF25EF25E
      F25EF25EF25EF25EF25EF25EF25EF25EC4183567146314631463146314631463
      14631463146314631463146314631463E51C3567146314631463146314631463
      14631463146314631463146314631463E51C3567146314631463146314631463
      14631463146314631463146314631463E51C3567146314631463146314631463
      14631463146314631463146314631463E51C424D3E000000000000003E000000
      2800000040000000400000000100010000000000000200000000000000000000
      000000000000000000000000FFFFFF0000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000001FF00000
      000000007E7C0000000000007C3C000000000000000200000000000000020000
      0000000000020000000000000002000000000000000200000000000000020000
      0000000000020000000000000002000000000000101200000000000000000000
      000000003FFC0000000000000000000000000000000000000000000000000000
      000000000000}
  end
  object SynEditorPopupMenu: TPopupMenu
    Left = 248
    Top = 320
    object Copy1: TMenuItem
      Action = EditCopy
    end
    object SelectAll1: TMenuItem
      Action = EditSelectAll
    end
  end
  object ActionList: TActionList
    Images = AllImage
    Left = 176
    Top = 280
    object EditCopy: TEditCopy
      Category = 'Edit'
      Caption = '&Copy'
      Hint = 'Copy|Copies the selection and puts it on the Clipboard'
      ImageIndex = 11
      ShortCut = 16451
      OnExecute = EditCopyExecute
      OnUpdate = EditCopyUpdate
    end
    object EditSelectAll: TEditSelectAll
      Category = 'Edit'
      Caption = '&Select All'
      Hint = 'Select All|Selects the entire document'
      ShortCut = 16449
      OnExecute = EditSelectAllExecute
      OnUpdate = EditSelectAllUpdate
    end
    object SearchFind: TAction
      Category = 'Search'
      Caption = '&Find'
      ImageIndex = 12
      ShortCut = 16454
      OnExecute = SearchFindExecute
      OnUpdate = SearchFindUpdate
    end
    object SearchFindFirst: TAction
      Category = 'Search'
      Caption = 'Find  &Previous'
      ImageIndex = 14
      ShortCut = 8306
      OnExecute = SearchFindFirstExecute
      OnUpdate = SearchFindFirstUpdate
    end
    object SearchFindNext: TAction
      Category = 'Search'
      Caption = 'Find &Next'
      ImageIndex = 13
      ShortCut = 114
      OnExecute = SearchFindNextExecute
      OnUpdate = SearchFindNextUpdate
    end
  end
  object LineBpImageList: TImageList
    Left = 240
    Top = 288
    Bitmap = {
      494C010101000400040010001000FFFFFFFFFF10FFFFFFFFFFFFFFFF424D3600
      0000000000003600000028000000400000001000000001001000000000000008
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      007C007C00000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000000000000000007C007C
      007C007C007C007C000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000007C007C007C
      007C007C007C007C007C00000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000007C007C007C
      007C007C007C007C007C00000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000007C007C007C007C
      007C007C007C007C007C007C0000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000007C007C007C007C
      007C007C007C007C007C007C0000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000007C007C007C
      007C007C007C007C007C00000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000007C007C007C
      007C007C007C007C007C00000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000000000000000007C007C
      007C007C007C007C000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      007C007C00000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000424D3E000000000000003E000000
      2800000040000000100000000100010000000000800000000000000000000000
      000000000000000000000000FFFFFF00FFFF000000000000FFFF000000000000
      FFFF000000000000FE7F000000000000F81F000000000000F00F000000000000
      F00F000000000000E007000000000000E007000000000000F00F000000000000
      F00F000000000000F81F000000000000FE7F000000000000FFFF000000000000
      FFFF000000000000FFFF00000000000000000000000000000000000000000000
      000000000000}
  end
end
