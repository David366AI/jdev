object generateJarFrm: TgenerateJarFrm
  Left = 342
  Top = 277
  BorderStyle = bsDialog
  Caption = 'Generate jar file'
  ClientHeight = 315
  ClientWidth = 402
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poDesktopCenter
  OnClose = FormClose
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object GroupBox2: TGroupBox
    Left = 0
    Top = 0
    Width = 401
    Height = 313
    TabOrder = 0
    object Label1: TLabel
      Left = 16
      Top = 76
      Width = 53
      Height = 12
      AutoSize = False
      Caption = 'Jar File:'
    end
    object Label2: TLabel
      Left = 16
      Top = 24
      Width = 73
      Height = 13
      AutoSize = False
      Caption = 'Project Name:'
    end
    object Label3: TLabel
      Left = 16
      Top = 50
      Width = 73
      Height = 13
      AutoSize = False
      Caption = 'Project Version:'
    end
    object proNameLbl: TLabel
      Left = 93
      Top = 24
      Width = 177
      Height = 13
      AutoSize = False
    end
    object TLabel
      Left = 88
      Top = 50
      Width = 177
      Height = 13
      AutoSize = False
    end
    object Label4: TLabel
      Left = 16
      Top = 104
      Width = 53
      Height = 13
      AutoSize = False
      Caption = 'Jar Path:'
    end
    object Label5: TLabel
      Left = 209
      Top = 74
      Width = 141
      Height = 13
      AutoSize = False
      Caption = '.jar ( you needn'#39't input ".jar )"'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlue
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
    end
    object jarFileNameEdit: TEdit
      Left = 93
      Top = 72
      Width = 113
      Height = 21
      Color = 14087154
      TabOrder = 0
    end
    object browserBtn: TButton
      Left = 322
      Top = 97
      Width = 75
      Height = 25
      Caption = 'B&rowser'
      TabOrder = 1
      OnClick = browserBtnClick
    end
    object GroupBox1: TGroupBox
      Left = 8
      Top = 128
      Width = 313
      Height = 88
      Caption = 'Export Items'
      TabOrder = 2
      object importJavaCB: TCheckBox
        Left = 8
        Top = 18
        Width = 97
        Height = 17
        Caption = 'java file'
        TabOrder = 0
      end
      object importClassCB: TCheckBox
        Left = 8
        Top = 42
        Width = 97
        Height = 17
        Caption = 'class file'
        Checked = True
        State = cbChecked
        TabOrder = 1
        OnClick = importClassCBClick
      end
      object importResCB: TCheckBox
        Left = 8
        Top = 66
        Width = 97
        Height = 17
        Caption = 'resource file'
        Checked = True
        State = cbChecked
        TabOrder = 2
      end
    end
    object GroupBox3: TGroupBox
      Left = 9
      Top = 224
      Width = 312
      Height = 85
      Caption = 'Export Options'
      TabOrder = 3
      object selDebugCB: TCheckBox
        Left = 8
        Top = 18
        Width = 289
        Height = 17
        Caption = 'include debug infomation in  class file'
        TabOrder = 0
      end
      object selCompressCB: TCheckBox
        Left = 8
        Top = 42
        Width = 137
        Height = 17
        Caption = 'compress file in jar'
        Checked = True
        State = cbChecked
        TabOrder = 1
      end
      object selOverrideCB: TCheckBox
        Left = 8
        Top = 66
        Width = 249
        Height = 17
        Caption = 'didn'#39't give warning before override the exists jar'
        TabOrder = 2
      end
    end
    object versionBtn: TButton
      Left = 322
      Top = 232
      Width = 75
      Height = 25
      Caption = 'Generate jar'
      ModalResult = 1
      TabOrder = 4
      OnClick = versionBtnClick
    end
    object Button3: TButton
      Left = 322
      Top = 272
      Width = 75
      Height = 25
      Caption = '&Cancel'
      ModalResult = 2
      TabOrder = 5
      OnClick = Button3Click
    end
    object jarFilePathEdit: TEdit
      Left = 93
      Top = 100
      Width = 228
      Height = 21
      Color = clSilver
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      ReadOnly = True
      TabOrder = 6
    end
    object versionEdit: TEdit
      Left = 93
      Top = 44
      Width = 177
      Height = 21
      Color = clSilver
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      TabOrder = 7
      OnChange = versionEditChange
    end
  end
  object DirDialog: TDirDialog
    Title = #35831#36873#21462'jar'#23384#25918#36335#24452#65306
    Directory = 'F:\jdev\JDEV_IDE\versionData'
    Left = 344
    Top = 40
  end
end
