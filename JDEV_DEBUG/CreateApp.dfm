object createAppDlg: TcreateAppDlg
  Left = 376
  Top = 175
  BorderStyle = bsDialog
  Caption = 'Startup Java Application Dialog'
  ClientHeight = 318
  ClientWidth = 394
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
  object PortOrAddressLabel: TLabel
    Left = 0
    Top = 200
    Width = 121
    Height = 13
    AutoSize = False
    Caption = 'Address Name'#65306
  end
  object LinkMethod: TRadioGroup
    Left = 0
    Top = 120
    Width = 129
    Height = 73
    Caption = 'Link Mode'
    ItemIndex = 1
    Items.Strings = (
      'socket Link'
      'ShareMemory Link')
    TabOrder = 0
    OnClick = LinkMethodClick
  end
  object beginAppBtn: TBitBtn
    Left = 72
    Top = 280
    Width = 75
    Height = 25
    Caption = 'Startup'
    Default = True
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ModalResult = 1
    ParentFont = False
    TabOrder = 1
    OnClick = beginAppBtnClick
    NumGlyphs = 2
  end
  object CloseBtn: TBitBtn
    Left = 232
    Top = 280
    Width = 75
    Height = 25
    Caption = 'Cancel'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ModalResult = 2
    ParentFont = False
    TabOrder = 2
    OnClick = CloseBtnClick
    NumGlyphs = 2
  end
  object GroupBox1: TGroupBox
    Left = 136
    Top = 120
    Width = 257
    Height = 145
    Caption = 'classpath setup'
    TabOrder = 3
    object classPathMemo: TMemo
      Left = 2
      Top = 15
      Width = 253
      Height = 98
      Hint = 'java'#24212#29992#31243#24207#26368#32456#20351#29992#30340#31867#36335#24452#20026#25805#20316#31995#32479#30340'CLASSPATH'#20197#21450#26412#22788#35774#32622#30340#31867#36335#24452#12290
      Align = alTop
      Color = 14087154
      ParentShowHint = False
      ScrollBars = ssVertical
      ShowHint = True
      TabOrder = 0
    end
    object Button1: TButton
      Left = 24
      Top = 117
      Width = 81
      Height = 22
      Caption = 'add direcotry'
      TabOrder = 1
      OnClick = Button1Click
    end
    object Button2: TButton
      Left = 144
      Top = 117
      Width = 81
      Height = 22
      Caption = 'add zip/jar file'
      TabOrder = 2
      OnClick = Button2Click
    end
  end
  object PortOrAddressEdit: TEdit
    Left = 0
    Top = 216
    Width = 129
    Height = 21
    Color = 14087154
    TabOrder = 4
  end
  object mainStopChecked: TCheckBox
    Left = 0
    Top = 248
    Width = 129
    Height = 17
    Caption = 'Stop at main function'
    Checked = True
    State = cbChecked
    TabOrder = 5
  end
  object GroupBox2: TGroupBox
    Left = 0
    Top = 0
    Width = 394
    Height = 113
    Align = alTop
    Caption = 'java application'#65288'which must have main function'#65289#65306
    TabOrder = 6
    object Label2: TLabel
      Left = 16
      Top = 79
      Width = 87
      Height = 13
      Caption = 'Run parameters'#65306
    end
    object Label7: TLabel
      Left = 16
      Top = 54
      Width = 185
      Height = 13
      AutoSize = False
      Caption = 'Class Name(eg.: package.ClassName)'
    end
    object Label8: TLabel
      Left = 16
      Top = 28
      Width = 129
      Height = 15
      AutoSize = False
      Caption = 'Path(exclude package)'#65306
    end
    object parametersEdit: TEdit
      Left = 120
      Top = 75
      Width = 249
      Height = 21
      Color = 14087154
      TabOrder = 0
    end
    object initalpathEdit: TEdit
      Left = 174
      Top = 26
      Width = 147
      Height = 21
      Color = 14087154
      ReadOnly = True
      TabOrder = 1
    end
    object ClassNameEdit: TEdit
      Left = 208
      Top = 50
      Width = 161
      Height = 21
      Color = 14087154
      TabOrder = 2
    end
    object SelectClassBtn: TBitBtn
      Left = 320
      Top = 26
      Width = 49
      Height = 19
      Caption = 'Browser'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      TabOrder = 3
      OnClick = SelectClassBtnClick
    end
  end
  object jarzipDlg: TOpenDialog
    Filter = 'jar file(*.jar)|*.jar|zip file(*.zip)|*.zip'
    Options = [ofHideReadOnly, ofOldStyleDialog, ofEnableSizing]
    Left = 288
    Top = 200
  end
end
