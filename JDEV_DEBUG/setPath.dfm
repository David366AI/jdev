object setSourcePathDlg: TsetSourcePathDlg
  Left = 291
  Top = 324
  BorderStyle = bsDialog
  Caption = 'Setup application source path'
  ClientHeight = 331
  ClientWidth = 392
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poDesktopCenter
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object Label3: TLabel
    Left = 10
    Top = 55
    Width = 79
    Height = 16
    AutoSize = False
    Caption = 'Path'#65306
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
  end
  object allPathListBox: TListBox
    Left = 0
    Top = 104
    Width = 392
    Height = 227
    Align = alBottom
    BevelInner = bvLowered
    BevelOuter = bvNone
    Color = 14087154
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ItemHeight = 16
    MultiSelect = True
    ParentFont = False
    TabOrder = 0
  end
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 392
    Height = 35
    Align = alTop
    BevelOuter = bvLowered
    TabOrder = 1
    object appNameLbl: TLabel
      Left = 89
      Top = 15
      Width = 4
      Height = 20
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clHighlight
      Font.Height = -16
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
    end
    object Label1: TLabel
      Left = 9
      Top = 11
      Width = 72
      Height = 16
      AutoSize = False
      Caption = 'Application'#65306
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
    end
    object BitBtn1: TBitBtn
      Left = 264
      Top = 5
      Width = 48
      Height = 24
      Caption = '&OK'
      Default = True
      ModalResult = 1
      TabOrder = 0
      NumGlyphs = 2
    end
    object BitBtn2: TBitBtn
      Left = 336
      Top = 5
      Width = 48
      Height = 24
      Caption = '&Cancel'
      TabOrder = 1
      NumGlyphs = 2
    end
  end
  object newPathEdit: TEdit
    Left = 88
    Top = 52
    Width = 265
    Height = 21
    Color = 14087154
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
    TabOrder = 2
  end
  object browseBtn: TBitBtn
    Left = 353
    Top = 52
    Width = 22
    Height = 20
    Caption = '...'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
    TabOrder = 3
    OnClick = browseBtnClick
  end
  object addPathBtn: TBitBtn
    Left = 88
    Top = 77
    Width = 57
    Height = 22
    Caption = '&Add Path'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
    TabOrder = 4
    OnClick = addPathBtnClick
  end
  object deletePathBtn: TBitBtn
    Left = 240
    Top = 77
    Width = 65
    Height = 22
    Caption = '&Delete Path'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
    TabOrder = 5
    OnClick = deletePathBtnClick
  end
end
