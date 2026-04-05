object importProjectFrm: TimportProjectFrm
  Left = 354
  Top = 209
  BorderStyle = bsDialog
  Caption = 'Import project'
  ClientHeight = 325
  ClientWidth = 478
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poDesktopCenter
  OnCreate = FormCreate
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object GroupBox1: TGroupBox
    Left = 0
    Top = 0
    Width = 233
    Height = 273
    Caption = 'Source path setup'
    TabOrder = 0
    object Label4: TLabel
      Left = 8
      Top = 16
      Width = 129
      Height = 13
      AutoSize = False
      Caption = 'Jar File Path'#65306
    end
    object jarFileListBox: TFileListBox
      Left = 8
      Top = 72
      Width = 217
      Height = 193
      Color = 14087154
      ItemHeight = 13
      Mask = '*.jar'
      TabOrder = 0
      OnChange = jarFileListBoxChange
    end
    object jarFilePathEdit: TEdit
      Left = 8
      Top = 36
      Width = 158
      Height = 21
      Color = clSilver
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      ReadOnly = True
      TabOrder = 1
    end
    object browserJarBtn: TButton
      Left = 168
      Top = 33
      Width = 57
      Height = 25
      Caption = '&Browser'
      TabOrder = 2
      OnClick = browserJarBtnClick
    end
  end
  object GroupBox2: TGroupBox
    Left = 240
    Top = 0
    Width = 233
    Height = 273
    Caption = 'Project store path setup'
    TabOrder = 1
    object Label1: TLabel
      Left = 8
      Top = 16
      Width = 129
      Height = 13
      AutoSize = False
      Caption = 'Import to'#65306
    end
    object commentMemo: TMemo
      Left = 8
      Top = 72
      Width = 217
      Height = 193
      Color = clSilver
      ReadOnly = True
      TabOrder = 0
    end
    object projectSavePathEdit: TEdit
      Left = 8
      Top = 36
      Width = 158
      Height = 21
      Color = 14087154
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      TabOrder = 1
    end
    object browserSaveBtn: TButton
      Left = 168
      Top = 33
      Width = 57
      Height = 25
      Caption = 'B&rowser'
      TabOrder = 2
      OnClick = browserSaveBtnClick
    end
  end
  object importBtn: TButton
    Left = 120
    Top = 288
    Width = 75
    Height = 25
    Caption = '&Import'
    ModalResult = 1
    TabOrder = 2
    OnClick = importBtnClick
  end
  object cancelBtn: TButton
    Left = 280
    Top = 288
    Width = 75
    Height = 25
    Caption = '&Cancel'
    ModalResult = 2
    TabOrder = 3
  end
  object jarDirDialog: TDirDialog
    Left = 192
    Top = 8
  end
  object projectDirDialog: TDirDialog
    Left = 368
    Top = 8
  end
end
