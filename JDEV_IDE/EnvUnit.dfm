object EnvSetupForm: TEnvSetupForm
  Left = 252
  Top = 213
  BorderStyle = bsDialog
  Caption = 'Environment Setup Dialog'
  ClientHeight = 365
  ClientWidth = 466
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poDesktopCenter
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object setupPageControl: TPageControl
    Left = 0
    Top = 0
    Width = 466
    Height = 321
    ActivePage = TabSheet2
    Align = alTop
    TabIndex = 3
    TabOrder = 0
    object TabSheet5: TTabSheet
      Caption = '&Profile'
      ImageIndex = 4
      object Label10: TLabel
        Left = 16
        Top = 182
        Width = 116
        Height = 13
        Caption = 'File Editors Tab Position:'
      end
      object Label9: TLabel
        Left = 16
        Top = 210
        Width = 118
        Height = 13
        Caption = 'Editor Background Color:'
      end
      object Label12: TLabel
        Left = 16
        Top = 238
        Width = 59
        Height = 13
        Caption = 'Gutter Color:'
      end
      object Label13: TLabel
        Left = 272
        Top = 264
        Width = 63
        Height = 13
        Caption = 'Digital Count:'
      end
      object GroupBox3: TGroupBox
        Left = 0
        Top = 0
        Width = 457
        Height = 169
        Caption = 'Visible Window Options'
        TabOrder = 0
        object CommonToolBarCB: TCheckBox
          Left = 16
          Top = 18
          Width = 177
          Height = 17
          Caption = 'Common Tool Bar Hide'
          Color = clBtnFace
          ParentColor = False
          TabOrder = 0
        end
        object ExtToolBarCB: TCheckBox
          Left = 16
          Top = 37
          Width = 177
          Height = 17
          Caption = 'Extention Tool Bar Hide'
          Color = clBtnFace
          ParentColor = False
          TabOrder = 1
        end
        object WorkspaceCB: TCheckBox
          Left = 16
          Top = 58
          Width = 177
          Height = 17
          Caption = 'WorkSpace Hide'
          Color = clBtnFace
          ParentColor = False
          TabOrder = 2
        end
        object ClassBrowserCB: TCheckBox
          Left = 16
          Top = 78
          Width = 177
          Height = 17
          Caption = 'Class Browser Hide'
          Color = clBtnFace
          ParentColor = False
          TabOrder = 3
        end
        object MessageCB: TCheckBox
          Left = 16
          Top = 99
          Width = 177
          Height = 17
          Caption = 'Message Window Hide'
          Color = clBtnFace
          ParentColor = False
          TabOrder = 4
        end
        object DebugCB: TCheckBox
          Left = 16
          Top = 120
          Width = 177
          Height = 17
          Caption = 'Debug Window Hide'
          Color = clBtnFace
          ParentColor = False
          TabOrder = 5
        end
        object profileDefaultBtn: TButton
          Left = 305
          Top = 68
          Width = 75
          Height = 25
          Caption = 'Default'
          TabOrder = 6
          OnClick = profileDefaultBtnClick
        end
        object statusBarCB: TCheckBox
          Left = 16
          Top = 140
          Width = 177
          Height = 17
          Caption = 'Status Bar Hide'
          Color = clBtnFace
          ParentColor = False
          TabOrder = 7
        end
      end
      object tabPosDropList: TComboBox
        Left = 144
        Top = 176
        Width = 145
        Height = 21
        Style = csDropDownList
        Color = 14087154
        ImeName = #32043#20809#25340#38899#36755#20837#27861
        ItemHeight = 13
        TabOrder = 1
        Items.Strings = (
          'Top'
          'Bottom'
          'Left'
          'Right')
      end
      object gutterNumberCB: TCheckBox
        Left = 16
        Top = 264
        Width = 121
        Height = 17
        Caption = 'Show Gutter Number'
        Checked = True
        Color = clBtnFace
        ParentColor = False
        State = cbChecked
        TabOrder = 2
        OnClick = gutterNumberCBClick
      end
      object leadingZerosCB: TCheckBox
        Left = 152
        Top = 264
        Width = 105
        Height = 17
        Caption = 'Leading Zeros'
        Color = clBtnFace
        ParentColor = False
        TabOrder = 3
        OnClick = leadingZerosCBClick
      end
      object digitalCountEdit: TEdit
        Left = 344
        Top = 260
        Width = 57
        Height = 21
        Color = 14087154
        ImeName = #32043#20809#25340#38899#36755#20837#27861
        ReadOnly = True
        TabOrder = 4
        Text = '6'
        OnClick = digitalCountEditClick
      end
      object digCountUpDown: TUpDown
        Left = 401
        Top = 260
        Width = 15
        Height = 21
        Associate = digitalCountEdit
        Min = 0
        Max = 10
        Position = 6
        TabOrder = 5
        Wrap = False
        OnClick = digCountUpDownClick
      end
      object gutterColor: TPanel
        Left = 142
        Top = 234
        Width = 147
        Height = 19
        Cursor = crHandPoint
        Color = 11654116
        TabOrder = 6
        OnClick = gutterColorClick
      end
      object editorBGColor: TPanel
        Left = 142
        Top = 207
        Width = 147
        Height = 19
        Cursor = crHandPoint
        Color = 14087154
        TabOrder = 7
        OnClick = editorBGColorClick
      end
    end
    object TabSheet1: TTabSheet
      Caption = '&Editor'
      object Label1: TLabel
        Left = 24
        Top = 8
        Width = 58
        Height = 13
        Caption = 'Tab Length:'
      end
      object Label11: TLabel
        Left = 16
        Top = 240
        Width = 90
        Height = 13
        Caption = 'Undo Edit Number:'
      end
      object tabLengthEdit: TEdit
        Left = 95
        Top = 4
        Width = 130
        Height = 21
        Color = 14087154
        ImeName = #32043#20809#25340#38899#36755#20837#27861
        ReadOnly = True
        TabOrder = 0
        Text = '4'
        OnChange = tabLengthEditChange
      end
      object UpDown1: TUpDown
        Left = 225
        Top = 4
        Width = 15
        Height = 21
        Associate = tabLengthEdit
        Min = 0
        Max = 20
        Position = 4
        TabOrder = 1
        Wrap = False
      end
      object GroupBox1: TGroupBox
        Left = 8
        Top = 32
        Width = 449
        Height = 201
        Caption = 'Java Code Color'
        TabOrder = 2
        object Label2: TLabel
          Left = 16
          Top = 24
          Width = 52
          Height = 13
          Caption = 'Comments:'
        end
        object Label3: TLabel
          Left = 16
          Top = 48
          Width = 57
          Height = 13
          Caption = 'Documents:'
        end
        object Label4: TLabel
          Left = 16
          Top = 72
          Width = 48
          Height = 13
          Caption = 'Identifiers:'
        end
        object Label5: TLabel
          Left = 16
          Top = 96
          Width = 39
          Height = 13
          Caption = 'Invalids:'
        end
        object Label6: TLabel
          Left = 16
          Top = 120
          Width = 55
          Height = 13
          Caption = 'Key Words:'
        end
        object Label7: TLabel
          Left = 16
          Top = 144
          Width = 45
          Height = 13
          Caption = 'Numbers:'
        end
        object Label8: TLabel
          Left = 16
          Top = 168
          Width = 35
          Height = 13
          Caption = 'Strings:'
        end
        object commentsColor: TColorBox
          Left = 87
          Top = 19
          Width = 100
          Height = 22
          DefaultColorColor = clGreen
          Selected = clGreen
          Color = 14087154
          ItemHeight = 16
          TabOrder = 0
          OnChange = commentsColorChange
        end
        object documentsColor: TColorBox
          Left = 87
          Top = 43
          Width = 100
          Height = 22
          DefaultColorColor = clGreen
          Selected = clGreen
          Color = 14087154
          ItemHeight = 16
          TabOrder = 1
          OnChange = documentsColorChange
        end
        object identifiersColor: TColorBox
          Left = 87
          Top = 67
          Width = 100
          Height = 22
          Color = 14087154
          ItemHeight = 16
          TabOrder = 2
          OnChange = identifiersColorChange
        end
        object invalidsColor: TColorBox
          Left = 87
          Top = 91
          Width = 100
          Height = 22
          DefaultColorColor = clRed
          Selected = clRed
          Color = 14087154
          ItemHeight = 16
          TabOrder = 3
          OnChange = invalidsColorChange
        end
        object keyWordsColor: TColorBox
          Left = 87
          Top = 115
          Width = 100
          Height = 22
          DefaultColorColor = clBlue
          Selected = clBlue
          Color = 14087154
          ItemHeight = 16
          TabOrder = 4
          OnChange = keyWordsColorChange
        end
        object numbersColor: TColorBox
          Left = 87
          Top = 139
          Width = 100
          Height = 22
          DefaultColorColor = clFuchsia
          Selected = clFuchsia
          Color = 14087154
          ItemHeight = 16
          TabOrder = 5
          OnChange = numbersColorChange
        end
        object stringsColor: TColorBox
          Left = 87
          Top = 163
          Width = 100
          Height = 22
          DefaultColorColor = clRed
          Selected = clRed
          Color = 14087154
          ItemHeight = 16
          TabOrder = 6
          OnChange = stringsColorChange
        end
        object sampleSynedit: TSynEdit
          Left = 192
          Top = 8
          Width = 254
          Height = 189
          Cursor = crIBeam
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Courier New'
          Font.Style = []
          ParentColor = False
          ParentFont = False
          TabOrder = 7
          Highlighter = SynJava
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
          Lines.Strings = (
            '/* function name: setName'
            '   params'
            '         param 1: String name'
            '   return type:void'
            '*/'
            'public void setName(String name)'
            '{'
            '  int i = 2334;'
            '  if (name.equals(""))'
            '     this.name = "null";'
            '  else '
            '     this.name = name;'
            '}')
          ReadOnly = True
          ScrollBars = ssNone
        end
      end
      object editordefaultBtn: TButton
        Left = 345
        Top = 1
        Width = 75
        Height = 25
        Caption = 'Default'
        TabOrder = 3
        OnClick = editordefaultBtnClick
      end
      object undoNumberEdit: TEdit
        Left = 111
        Top = 236
        Width = 130
        Height = 21
        Color = 14087154
        ImeName = #32043#20809#25340#38899#36755#20837#27861
        ReadOnly = True
        TabOrder = 4
        Text = '1024'
      end
      object UpDown2: TUpDown
        Left = 241
        Top = 236
        Width = 16
        Height = 21
        Associate = undoNumberEdit
        Min = 0
        Max = 1024
        Position = 1024
        TabOrder = 5
        Thousands = False
        Wrap = False
      end
      object autoIndentCB: TCheckBox
        Left = 16
        Top = 264
        Width = 97
        Height = 17
        Caption = 'Auto Indent'
        Checked = True
        State = cbChecked
        TabOrder = 6
        OnClick = autoIndentCBClick
      end
    end
    object TabSheet3: TTabSheet
      Caption = '&Auto Complete'
      ImageIndex = 2
      object Label14: TLabel
        Left = 8
        Top = 8
        Width = 99
        Height = 13
        Caption = 'Auto Completion  List'
      end
      object Label15: TLabel
        Left = 216
        Top = 8
        Width = 84
        Height = 13
        Caption = 'Completion name:'
      end
      object Label16: TLabel
        Left = 216
        Top = 64
        Width = 100
        Height = 13
        Caption = 'Auto Complete Code:'
      end
      object Label17: TLabel
        Left = 8
        Top = 224
        Width = 189
        Height = 13
        Caption = 'Press <Ctrl+J> to invoke autocompletion'
      end
      object Label21: TLabel
        Left = 216
        Top = 224
        Width = 229
        Height = 13
        Caption = 'Char '#39'|'#39'(pipe symbol ) stands for the Caret position'
      end
      object Label22: TLabel
        Left = 328
        Top = 8
        Width = 52
        Height = 13
        Caption = 'Comments:'
      end
      object AutoCompList: TListBox
        Left = 0
        Top = 32
        Width = 193
        Height = 185
        Color = 14087154
        ImeName = #32043#20809#25340#38899#36755#20837#27861
        ItemHeight = 13
        TabOrder = 0
        OnClick = AutoCompListClick
      end
      object CompletionNameEdit: TEdit
        Left = 216
        Top = 32
        Width = 97
        Height = 21
        Color = 14087154
        ImeName = #32043#20809#25340#38899#36755#20837#27861
        TabOrder = 1
      end
      object AutoCodeMemo: TMemo
        Left = 216
        Top = 88
        Width = 225
        Height = 129
        Color = 14087154
        ImeName = #32043#20809#25340#38899#36755#20837#27861
        TabOrder = 2
      end
      object addAutoCompBtn: TButton
        Left = 248
        Top = 256
        Width = 75
        Height = 25
        Caption = '&Add '
        TabOrder = 3
        OnClick = addAutoCompBtnClick
      end
      object modifyAutoCompBtn: TButton
        Left = 336
        Top = 256
        Width = 75
        Height = 25
        Caption = '&Modify'
        TabOrder = 4
        OnClick = modifyAutoCompBtnClick
      end
      object deleteAutoCompBtn: TButton
        Left = 48
        Top = 256
        Width = 75
        Height = 25
        Caption = '&Delete Selete'
        TabOrder = 5
        OnClick = deleteAutoCompBtnClick
      end
      object commentsEdit: TEdit
        Left = 328
        Top = 32
        Width = 113
        Height = 21
        Color = 14087154
        ImeName = #32043#20809#25340#38899#36755#20837#27861
        TabOrder = 6
      end
    end
    object TabSheet2: TTabSheet
      Caption = '&JDK Options'
      ImageIndex = 1
      OnShow = TabSheet2Show
      object GroupBox4: TGroupBox
        Left = 0
        Top = 49
        Width = 458
        Height = 133
        Align = alTop
        Caption = 'IDE Class Path'
        TabOrder = 0
        object addDirBtn: TButton
          Left = 340
          Top = 42
          Width = 81
          Height = 22
          Caption = 'Add Di&rectory'
          TabOrder = 0
          OnClick = addDirBtnClick
        end
        object addJarBtn: TButton
          Left = 340
          Top = 11
          Width = 81
          Height = 22
          Caption = '&Add zip/jar file'
          TabOrder = 1
          OnClick = addJarBtnClick
        end
        object cpListBox: TListBox
          Left = 2
          Top = 15
          Width = 303
          Height = 116
          Align = alLeft
          Color = 14087154
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = [fsBold]
          ImeName = #32043#20809#25340#38899#36755#20837#27861
          ItemHeight = 13
          ParentFont = False
          TabOrder = 2
        end
        object deleteBtn: TButton
          Left = 340
          Top = 73
          Width = 81
          Height = 22
          Caption = '&Delete Select'
          TabOrder = 3
          OnClick = deleteBtnClick
        end
        object clearBtn: TButton
          Left = 340
          Top = 104
          Width = 81
          Height = 22
          Caption = '&Clear All'
          TabOrder = 4
          OnClick = clearBtnClick
        end
      end
      object GroupBox2: TGroupBox
        Left = 0
        Top = 182
        Width = 458
        Height = 153
        Align = alTop
        Caption = 'Java Source Path'
        TabOrder = 1
        object addDirBtn2: TButton
          Left = 340
          Top = 19
          Width = 81
          Height = 22
          Caption = 'Add Di&rectory'
          TabOrder = 0
          OnClick = addDirBtn2Click
        end
        object srcListBox: TListBox
          Left = 2
          Top = 15
          Width = 303
          Height = 136
          Align = alLeft
          Color = 14087154
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = [fsBold]
          ImeName = #32043#20809#25340#38899#36755#20837#27861
          ItemHeight = 13
          ParentFont = False
          TabOrder = 1
        end
        object deleteBtn2: TButton
          Left = 340
          Top = 50
          Width = 81
          Height = 22
          Caption = '&Delete Select'
          TabOrder = 2
          OnClick = deleteBtn2Click
        end
        object clearBtn2: TButton
          Left = 340
          Top = 81
          Width = 81
          Height = 22
          Caption = '&Clear All'
          TabOrder = 3
          OnClick = clearBtn2Click
        end
      end
      object Panel1: TPanel
        Left = 0
        Top = 0
        Width = 458
        Height = 49
        Align = alTop
        TabOrder = 2
        object Label23: TLabel
          Left = 8
          Top = 16
          Width = 65
          Height = 13
          AutoSize = False
          Caption = 'Java Home'#65306
        end
        object javaHomeLbl: TLabel
          Left = 80
          Top = 14
          Width = 225
          Height = 19
          AutoSize = False
          Color = clWhite
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlue
          Font.Height = -13
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentColor = False
          ParentFont = False
        end
        object setJavaHomeBtn: TButton
          Left = 340
          Top = 13
          Width = 81
          Height = 23
          Caption = 'Set Java Home'
          TabOrder = 0
          OnClick = setJavaHomeBtnClick
        end
      end
    end
    object TabSheet4: TTabSheet
      Caption = '&Help'
      ImageIndex = 3
      object Label18: TLabel
        Left = 16
        Top = 16
        Width = 84
        Height = 13
        Caption = 'jdk source zip file:'
      end
      object Label19: TLabel
        Left = 16
        Top = 72
        Width = 113
        Height = 13
        Caption = 'Servlet Document Path:'
      end
      object Label20: TLabel
        Left = 16
        Top = 128
        Width = 99
        Height = 13
        Caption = 'JSP Document Path:'
      end
      object jdkpathEdit: TEdit
        Left = 32
        Top = 40
        Width = 385
        Height = 21
        Color = 14087154
        ImeName = #32043#20809#25340#38899#36755#20837#27861
        ReadOnly = True
        TabOrder = 0
      end
      object Button8: TButton
        Left = 417
        Top = 40
        Width = 25
        Height = 21
        Caption = '...'
        TabOrder = 1
        OnClick = Button8Click
      end
      object servletpathEdit: TEdit
        Left = 32
        Top = 96
        Width = 385
        Height = 21
        Color = 14087154
        ImeName = #32043#20809#25340#38899#36755#20837#27861
        ReadOnly = True
        TabOrder = 2
      end
      object Button10: TButton
        Left = 418
        Top = 95
        Width = 26
        Height = 21
        Caption = '...'
        TabOrder = 3
        OnClick = Button10Click
      end
      object jspPathEdit: TEdit
        Left = 32
        Top = 152
        Width = 385
        Height = 21
        Color = 14087154
        ImeName = #32043#20809#25340#38899#36755#20837#27861
        ReadOnly = True
        TabOrder = 4
      end
      object Button12: TButton
        Left = 419
        Top = 151
        Width = 24
        Height = 21
        Caption = '...'
        TabOrder = 5
        OnClick = Button12Click
      end
    end
  end
  object OkBtn: TBitBtn
    Left = 116
    Top = 331
    Width = 75
    Height = 25
    TabOrder = 1
    OnClick = OkBtnClick
    Kind = bkOK
  end
  object cancelBtn: TBitBtn
    Left = 276
    Top = 331
    Width = 75
    Height = 25
    TabOrder = 2
    Kind = bkCancel
  end
  object colorDlg: TColorDialog
    Ctl3D = True
    CustomColors.Strings = (
      'ColorA=FFFFFFFF'
      'ColorB=FFFFFFFF'
      'ColorC=FFFFFFFF'
      'ColorD=FFFFFFFF'
      'ColorE=FFFFFFFF'
      'ColorF=FFFFFFFF'
      'ColorG=FFFFFFFF'
      'ColorH=FFFFFFFF'
      'ColorI=FFFFFFFF'
      'ColorJ=FFFFFFFF'
      'ColorK=FFFFFFFF'
      'ColorL=FFFFFFFF'
      'ColorM=FFFFFFFF'
      'ColorN=FFFFFFFF'
      'ColorO=FFFFFFFF'
      'ColorP=FFFFFFFF')
    Left = 296
    Top = 256
  end
  object SynJava: TSynJavaSyn
    DefaultFilter = 'Java files (*.java)|*.java'
    Left = 432
    Top = 80
  end
  object jarzipDlg: TOpenDialog
    Filter = 'java class'#31867#25991#20214'(*.jar)|*.jar|zip'#21387#32553#25991#20214'(*.zip)|*.zip'
    Options = [ofHideReadOnly, ofOldStyleDialog, ofEnableSizing]
    Left = 320
    Top = 72
  end
  object cpDirDialog: TDirDialog
    Left = 320
    Top = 104
  end
  object srcDirDialog: TDirDialog
    Left = 320
    Top = 152
  end
end
