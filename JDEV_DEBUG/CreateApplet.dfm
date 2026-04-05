object appletForm: TappletForm
  Left = 291
  Top = 143
  BorderStyle = bsDialog
  Caption = 'Startup Java Applet'
  ClientHeight = 491
  ClientWidth = 468
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poDesktopCenter
  OnCloseQuery = FormCloseQuery
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object Label7: TLabel
    Left = 4
    Top = 112
    Width = 189
    Height = 13
    AutoSize = False
    Caption = 'Class Name(eg.: package.ClassName):'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
  end
  object PageControl1: TPageControl
    Left = 0
    Top = 153
    Width = 468
    Height = 297
    ActivePage = TabSheet1
    Align = alBottom
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
    TabIndex = 0
    TabOrder = 0
    object TabSheet1: TTabSheet
      Caption = 'applet property'
      object Label5: TLabel
        Left = 56
        Top = 56
        Width = 393
        Height = 13
        AutoSize = False
        Caption = #30001' html '#25991#20214#21551#21160#19981#38656#35201#35774#32622#23646#24615
      end
      object featureSetup: TPanel
        Left = 0
        Top = 0
        Width = 460
        Height = 269
        Align = alBottom
        TabOrder = 0
        object Label1: TLabel
          Left = 18
          Top = 16
          Width = 41
          Height = 13
          Caption = 'height'#65306
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
        end
        object Label2: TLabel
          Left = 17
          Top = 57
          Width = 37
          Height = 13
          Caption = 'width'#65306
        end
        object Label3: TLabel
          Left = 18
          Top = 95
          Width = 38
          Height = 13
          Caption = 'name'#65306
        end
        object Label4: TLabel
          Left = 19
          Top = 136
          Width = 61
          Height = 13
          Caption = 'CodeBase'#65306
        end
        object Label6: TLabel
          Left = 18
          Top = 191
          Width = 47
          Height = 13
          Caption = 'archive'#65306
        end
        object heightEdit: TMaskEdit
          Left = 88
          Top = 11
          Width = 116
          Height = 21
          Color = 14087154
          EditMask = '!9999;1; '
          ImeName = #32043#20809#25340#38899#36755#20837#27861'2.2'#29256
          MaxLength = 4
          TabOrder = 0
          Text = ' 300'
        end
        object widthEdit: TMaskEdit
          Left = 88
          Top = 53
          Width = 118
          Height = 21
          Color = 14087154
          EditMask = '!9999;1; '
          ImeName = #32043#20809#25340#38899#36755#20837#27861'2.2'#29256
          MaxLength = 4
          TabOrder = 1
          Text = ' 500'
        end
        object appletNameEdit: TEdit
          Left = 88
          Top = 94
          Width = 119
          Height = 21
          Color = 14087154
          TabOrder = 2
        end
        object GroupBox2: TGroupBox
          Left = 225
          Top = 1
          Width = 234
          Height = 267
          Align = alRight
          Caption = 'Parameters'
          TabOrder = 3
          object paramList: TValueListEditor
            Left = 2
            Top = 15
            Width = 230
            Height = 250
            Align = alClient
            Color = 14087154
            FixedColor = clSilver
            KeyOptions = [keyEdit, keyAdd, keyDelete, keyUnique]
            Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goColSizing, goEditing, goTabs, goAlwaysShowEditor, goThumbTracking]
            Strings.Strings = (
              '=')
            TabOrder = 0
            TitleCaptions.Strings = (
              'param name'
              'param value')
            ColWidths = (
              106
              118)
          end
        end
        object useArchive: TCheckBox
          Left = 18
          Top = 167
          Width = 119
          Height = 17
          Caption = 'Enable archive '
          TabOrder = 4
          OnClick = useArchiveClick
        end
        object archiveClassEdit: TEdit
          Left = 88
          Top = 186
          Width = 121
          Height = 21
          Color = 14087154
          Enabled = False
          TabOrder = 5
        end
        object codebaseEdit: TEdit
          Left = 87
          Top = 132
          Width = 121
          Height = 21
          Color = clSilver
          ReadOnly = True
          TabOrder = 6
        end
      end
    end
    object TabSheet2: TTabSheet
      Caption = 'classpath'
      ImageIndex = 1
      object GroupBox1: TGroupBox
        Left = 0
        Top = 0
        Width = 460
        Height = 269
        Align = alClient
        TabOrder = 0
        object classPathMemo: TMemo
          Left = 2
          Top = 15
          Width = 319
          Height = 252
          Align = alLeft
          Color = 14087154
          ImeName = #32043#20809#25340#38899#36755#20837#27861'2.2'#29256
          ScrollBars = ssVertical
          TabOrder = 0
        end
        object addDirBtn: TButton
          Left = 338
          Top = 80
          Width = 115
          Height = 25
          Caption = '&Add directory'
          TabOrder = 1
          OnClick = addDirBtnClick
        end
        object Button2: TButton
          Left = 338
          Top = 152
          Width = 115
          Height = 25
          Caption = 'Add &jar/zip File'
          TabOrder = 2
          OnClick = Button2Click
        end
      end
    end
  end
  object Panel1: TPanel
    Left = 0
    Top = 450
    Width = 468
    Height = 41
    Align = alBottom
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = #23435#20307
    Font.Style = []
    ParentFont = False
    TabOrder = 1
    object confirmBtn: TBitBtn
      Left = 96
      Top = 8
      Width = 75
      Height = 25
      Caption = 'OK'
      Default = True
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ModalResult = 1
      ParentFont = False
      TabOrder = 0
      OnClick = confirmBtnClick
      NumGlyphs = 2
    end
    object BitBtn2: TBitBtn
      Left = 288
      Top = 8
      Width = 75
      Height = 25
      Caption = '&Close'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ModalResult = 2
      ParentFont = False
      TabOrder = 1
      NumGlyphs = 2
    end
  end
  object classNameEdit: TEdit
    Left = 194
    Top = 108
    Width = 254
    Height = 21
    Color = 14087154
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = #23435#20307
    Font.Style = []
    ParentFont = False
    TabOrder = 2
  end
  object isStopAtInit: TCheckBox
    Left = 3
    Top = 129
    Width = 174
    Height = 17
    Caption = 'stop at init function'
    Checked = True
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
    State = cbChecked
    TabOrder = 3
  end
  object GroupBox3: TGroupBox
    Left = 0
    Top = 0
    Width = 468
    Height = 100
    Align = alTop
    Caption = 'Startup File'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
    TabOrder = 4
    object Label8: TLabel
      Left = 35
      Top = 36
      Width = 118
      Height = 13
      AutoSize = False
      Caption = 'path(exclude package):'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
    end
    object Label9: TLabel
      Left = 35
      Top = 73
      Width = 78
      Height = 13
      AutoSize = False
      Caption = 'html file:'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
    end
    object classCheck: TRadioButton
      Left = 2
      Top = 17
      Width = 113
      Height = 17
      Caption = 'Startup using class'
      Checked = True
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      TabOrder = 0
      TabStop = True
      OnClick = classCheckClick
    end
    object classPathEdit: TEdit
      Left = 152
      Top = 30
      Width = 265
      Height = 21
      Color = 14087154
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      TabOrder = 1
    end
    object classBtn: TBitBtn
      Left = 416
      Top = 29
      Width = 47
      Height = 23
      Caption = '&Browser'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      TabOrder = 2
      OnClick = classBtnClick
    end
    object htmlBtn: TBitBtn
      Left = 417
      Top = 68
      Width = 45
      Height = 23
      Caption = 'B&rowser'
      Enabled = False
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      TabOrder = 3
      OnClick = htmlBtnClick
    end
    object htmlEdit: TEdit
      Left = 151
      Top = 69
      Width = 265
      Height = 21
      Color = 14087154
      Enabled = False
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      TabOrder = 4
    end
    object htmlCheck: TRadioButton
      Left = 2
      Top = 54
      Width = 143
      Height = 17
      Caption = 'Startup using html'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      TabOrder = 5
      OnClick = htmlCheckClick
    end
  end
  object jarzipDlg: TOpenDialog
    Filter = 'jar  file(*.jar)|*.jar|zip file(*.zip)|*.zip'
    FilterIndex = 0
    Options = [ofHideReadOnly, ofOldStyleDialog, ofEnableSizing]
    Title = #35831#36873#25321'jar/zip'#25991#20214
    Left = 288
    Top = 216
  end
  object htmlOpenDlg: TOpenDialog
    Filter = 'html file(*.html)|*.html|htm file(*.htm)|*.htm'
    Left = 352
    Top = 72
  end
end
