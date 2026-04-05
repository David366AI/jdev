object createAppletFrm: TcreateAppletFrm
  Left = 318
  Top = 181
  BorderStyle = bsDialog
  Caption = 'Config Applet Parameters'
  ClientHeight = 287
  ClientWidth = 442
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
  object Label1: TLabel
    Left = 8
    Top = 18
    Width = 73
    Height = 13
    AutoSize = False
    Caption = 'Applet Class'#65306
  end
  object appletNameLbl: TLabel
    Left = 96
    Top = 18
    Width = 337
    Height = 13
    AutoSize = False
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlue
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
  end
  object featureSetup: TPanel
    Left = 0
    Top = 48
    Width = 442
    Height = 201
    TabOrder = 0
    object Label11: TLabel
      Left = 23
      Top = 16
      Width = 41
      Height = 13
      Caption = 'height'#65306
    end
    object Label13: TLabel
      Left = 27
      Top = 41
      Width = 37
      Height = 13
      Caption = 'width'#65306
    end
    object Label14: TLabel
      Left = 27
      Top = 66
      Width = 38
      Height = 13
      Caption = 'name'#65306
    end
    object Label15: TLabel
      Left = 17
      Top = 93
      Width = 61
      Height = 13
      Caption = 'CodeBase'#65306
    end
    object Label16: TLabel
      Left = 27
      Top = 140
      Width = 47
      Height = 13
      Caption = 'archive'#65306
    end
    object heightEdit: TMaskEdit
      Left = 80
      Top = 11
      Width = 110
      Height = 21
      Color = 14087154
      EditMask = '!9999;1; '
      ImeName = #32043#20809#25340#38899#36755#20837#27861'2.2'#29256
      MaxLength = 4
      TabOrder = 0
      Text = ' 300'
    end
    object widthEdit: TMaskEdit
      Left = 80
      Top = 37
      Width = 110
      Height = 21
      Color = 14087154
      EditMask = '!9999;1; '
      ImeName = #32043#20809#25340#38899#36755#20837#27861'2.2'#29256
      MaxLength = 4
      TabOrder = 1
      Text = ' 500'
    end
    object appletNameEdit: TEdit
      Left = 80
      Top = 62
      Width = 110
      Height = 21
      Color = 14087154
      TabOrder = 2
    end
    object GroupBox5: TGroupBox
      Left = 221
      Top = 1
      Width = 220
      Height = 199
      Align = alRight
      Caption = 'Parameters'
      TabOrder = 3
      object paramList: TValueListEditor
        Left = 2
        Top = 15
        Width = 216
        Height = 182
        Align = alClient
        Color = 14087154
        FixedColor = clSilver
        KeyOptions = [keyEdit, keyAdd, keyDelete, keyUnique]
        Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goColSizing, goEditing, goTabs, goAlwaysShowEditor, goThumbTracking]
        Strings.Strings = (
          '=')
        TabOrder = 0
        TitleCaptions.Strings = (
          'Param Name'
          'Param Value')
        ColWidths = (
          106
          104)
      end
    end
    object useArchive: TCheckBox
      Left = 79
      Top = 114
      Width = 114
      Height = 17
      Caption = '&Enable archive '
      TabOrder = 4
      OnClick = useArchiveClick
    end
    object archiveClassEdit: TEdit
      Left = 77
      Top = 135
      Width = 116
      Height = 21
      Color = 14087154
      Enabled = False
      TabOrder = 5
    end
    object codebaseEdit: TEdit
      Left = 79
      Top = 89
      Width = 111
      Height = 21
      Color = 14087154
      TabOrder = 6
      Text = '.'
    end
    object isStopAtInit: TCheckBox
      Left = 21
      Top = 169
      Width = 174
      Height = 17
      Caption = 'Stop at init function'
      Checked = True
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = #23435#20307
      Font.Style = []
      ParentFont = False
      State = cbChecked
      TabOrder = 7
    end
  end
  object beginAppBtn: TBitBtn
    Left = 112
    Top = 255
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
    TabOrder = 1
    OnClick = beginAppBtnClick
    NumGlyphs = 2
  end
  object CloseBtn: TBitBtn
    Left = 256
    Top = 255
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
    TabOrder = 2
    NumGlyphs = 2
  end
end
