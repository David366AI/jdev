object projectPropertyFrm: TprojectPropertyFrm
  Left = 444
  Top = 143
  BorderStyle = bsDialog
  Caption = 'Project property setup'
  ClientHeight = 317
  ClientWidth = 445
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poDesktopCenter
  PixelsPerInch = 96
  TextHeight = 13
  object beginAppBtn: TBitBtn
    Left = 88
    Top = 276
    Width = 75
    Height = 25
    Caption = '&OK'
    Default = True
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ModalResult = 1
    ParentFont = False
    TabOrder = 0
    OnClick = beginAppBtnClick
    NumGlyphs = 2
  end
  object CloseBtn: TBitBtn
    Left = 272
    Top = 276
    Width = 75
    Height = 25
    Caption = '&Cancel'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ModalResult = 2
    ParentFont = False
    TabOrder = 1
    OnClick = CloseBtnClick
    NumGlyphs = 2
  end
  object projectPageControl: TPageControl
    Left = 0
    Top = 0
    Width = 445
    Height = 265
    ActivePage = basicTS
    Align = alTop
    TabIndex = 0
    TabOrder = 2
    object basicTS: TTabSheet
      Caption = 'Base infomation'
      object Label1: TLabel
        Left = 8
        Top = 80
        Width = 81
        Height = 13
        Caption = 'Project file name:'
      end
      object Label3: TLabel
        Left = 8
        Top = 16
        Width = 65
        Height = 13
        Caption = 'Project name:'
      end
      object Label4: TLabel
        Left = 8
        Top = 48
        Width = 60
        Height = 13
        Caption = 'Project path:'
      end
      object Label5: TLabel
        Left = 8
        Top = 112
        Width = 63
        Height = 13
        Caption = 'Project Type:'
      end
      object Label6: TLabel
        Left = 8
        Top = 144
        Width = 97
        Height = 13
        AutoSize = False
        Caption = 'Project create time:'
      end
      object Label9: TLabel
        Left = 8
        Top = 201
        Width = 79
        Height = 13
        Caption = 'Project Author'#65306
      end
      object pro_createTime_lbl: TLabel
        Left = 112
        Top = 144
        Width = 137
        Height = 21
        AutoSize = False
      end
      object Label10: TLabel
        Left = 8
        Top = 172
        Width = 97
        Height = 13
        AutoSize = False
        Caption = 'Latest update time:'
      end
      object pro_updatetime_lbl: TLabel
        Left = 112
        Top = 170
        Width = 137
        Height = 21
        AutoSize = False
      end
      object Label12: TLabel
        Left = 257
        Top = 172
        Width = 38
        Height = 13
        Caption = 'Version:'
      end
      object version_lbl: TLabel
        Left = 302
        Top = 171
        Width = 76
        Height = 13
        AutoSize = False
      end
      object pro_filename_edit: TEdit
        Left = 112
        Top = 75
        Width = 121
        Height = 21
        Color = 14087154
        ImeName = #32043#20809#25340#38899#36755#20837#27861
        ReadOnly = True
        TabOrder = 0
      end
      object pro_path_edit: TEdit
        Left = 112
        Top = 43
        Width = 241
        Height = 21
        Color = 14087154
        ImeName = #32043#20809#25340#38899#36755#20837#27861
        ReadOnly = True
        TabOrder = 1
      end
      object pro_name_edit: TEdit
        Left = 112
        Top = 13
        Width = 121
        Height = 21
        Color = 14087154
        ImeName = #32043#20809#25340#38899#36755#20837#27861
        TabOrder = 2
        OnChange = pro_name_editChange
      end
      object pro_javatype_rb: TRadioButton
        Left = 112
        Top = 112
        Width = 97
        Height = 17
        Caption = 'java application'
        Checked = True
        TabOrder = 3
        TabStop = True
        OnClick = pro_javatype_rbClick
      end
      object pro_webtype_rb: TRadioButton
        Left = 224
        Top = 112
        Width = 113
        Height = 17
        Caption = 'web application'
        TabOrder = 4
        OnClick = pro_javatype_rbClick
      end
      object pro_author_edit: TEdit
        Left = 112
        Top = 198
        Width = 121
        Height = 21
        Color = 14087154
        ImeName = #32043#20809#25340#38899#36755#20837#27861
        TabOrder = 5
      end
      object browserBtn: TBitBtn
        Left = 360
        Top = 42
        Width = 20
        Height = 22
        Caption = '...'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -16
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ParentFont = False
        TabOrder = 6
        OnClick = browserBtnClick
      end
    end
    object classPathTS: TTabSheet
      Caption = 'Classpath setup'
      ImageIndex = 2
      object GroupBox1: TGroupBox
        Left = 0
        Top = 0
        Width = 437
        Height = 237
        Align = alClient
        Caption = 'Classpath'
        TabOrder = 0
        object GroupBox3: TGroupBox
          Left = 2
          Top = 15
          Width = 433
          Height = 105
          Align = alTop
          Caption = 'Exists classpath  (validate in all project)'
          TabOrder = 0
          object existCPMemo: TMemo
            Left = 2
            Top = 15
            Width = 429
            Height = 88
            Align = alClient
            Color = clBtnFace
            ImeName = #32043#20809#25340#38899#36755#20837#27861
            Lines.Strings = (
              '')
            ReadOnly = True
            TabOrder = 0
          end
        end
        object GroupBox4: TGroupBox
          Left = 2
          Top = 120
          Width = 433
          Height = 115
          Align = alClient
          Caption = 'Project Classpath  (Only valid in this project)'
          TabOrder = 1
          object addDirBtn: TButton
            Left = 316
            Top = 34
            Width = 81
            Height = 22
            Caption = 'Add directory'
            TabOrder = 0
            OnClick = addDirBtnClick
          end
          object addJarBtn: TButton
            Left = 316
            Top = 10
            Width = 81
            Height = 22
            Caption = 'Add zip/jar file'
            TabOrder = 1
            OnClick = addJarBtnClick
          end
          object cpListBox: TListBox
            Left = 2
            Top = 15
            Width = 303
            Height = 98
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
            Left = 316
            Top = 58
            Width = 81
            Height = 22
            Caption = 'Delete  selected'
            TabOrder = 3
            OnClick = deleteBtnClick
          end
          object clearBtn: TButton
            Left = 316
            Top = 82
            Width = 81
            Height = 22
            Caption = 'Clear all'
            TabOrder = 4
            OnClick = clearBtnClick
          end
        end
      end
    end
    object MainClassTS: TTabSheet
      Caption = 'Main Class'
      ImageIndex = 1
      object GroupBox2: TGroupBox
        Left = 0
        Top = 0
        Width = 437
        Height = 237
        Align = alClient
        Caption = 'Main Class Select'
        TabOrder = 0
        object Label2: TLabel
          Left = 16
          Top = 194
          Width = 56
          Height = 13
          Caption = 'Parameters:'
        end
        object Label8: TLabel
          Left = 8
          Top = 18
          Width = 273
          Height = 13
          AutoSize = False
          Caption = 'Please select main class (which must has main method):'
        end
        object parametersEdit: TEdit
          Left = 88
          Top = 190
          Width = 313
          Height = 21
          Color = 14087154
          ImeName = #32043#20809#25340#38899#36755#20837#27861
          TabOrder = 0
        end
        object ClassTreeView: TTreeView
          Left = 8
          Top = 35
          Width = 398
          Height = 150
          Color = 14087154
          Indent = 19
          TabOrder = 1
          OnChanging = ClassTreeViewChanging
          OnCustomDrawItem = ClassTreeViewCustomDrawItem
        end
      end
    end
    object webAppTS: TTabSheet
      Caption = 'web application'
      ImageIndex = 3
      object Label7: TLabel
        Left = 112
        Top = 96
        Width = 248
        Height = 13
        Caption = 'JDev2.0 will support web application development....'
      end
    end
  end
  object jarzipDlg: TOpenDialog
    Filter = 'java class'#31867#25991#20214'(*.jar)|*.jar|zip'#21387#32553#25991#20214'(*.zip)|*.zip'
    Options = [ofHideReadOnly, ofOldStyleDialog, ofEnableSizing]
    Left = 344
    Top = 272
  end
end
