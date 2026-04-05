object addMethodBpForm: TaddMethodBpForm
  Left = 329
  Top = 186
  Width = 384
  Height = 375
  Caption = 'Add function breakpoint'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 9
    Top = 9
    Width = 54
    Height = 13
    Caption = 'package'#65306
  end
  object Label2: TLabel
    Left = 9
    Top = 32
    Width = 37
    Height = 13
    Caption = 'Class'#65306
  end
  object Label3: TLabel
    Left = 9
    Top = 56
    Width = 53
    Height = 13
    Caption = 'Function'#65306
  end
  object Label5: TLabel
    Left = 310
    Top = 9
    Width = 53
    Height = 13
    Caption = '(permit null)'
  end
  object Label6: TLabel
    Left = 310
    Top = 32
    Width = 40
    Height = 13
    Caption = '(not null)'
  end
  object Label7: TLabel
    Left = 310
    Top = 54
    Width = 40
    Height = 13
    Caption = '(not null)'
  end
  object GroupBox1: TGroupBox
    Left = 0
    Top = 80
    Width = 375
    Height = 201
    Caption = 'Parameters<permit null>'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
    TabOrder = 0
    object Label4: TLabel
      Left = 12
      Top = 22
      Width = 82
      Height = 13
      Caption = 'parameter type'#65306
    end
    object paramListBox: TListBox
      Left = 2
      Top = 48
      Width = 371
      Height = 151
      Align = alBottom
      Color = 14087154
      ItemHeight = 13
      TabOrder = 0
      OnMouseDown = paramListBoxMouseDown
    end
    object paramEdit: TEdit
      Left = 104
      Top = 19
      Width = 145
      Height = 21
      Color = 14087154
      TabOrder = 1
    end
    object Button1: TButton
      Left = 258
      Top = 18
      Width = 59
      Height = 25
      Caption = '&Add'
      TabOrder = 2
      OnClick = Button1Click
    end
  end
  object packageEdit: TEdit
    Left = 64
    Top = 5
    Width = 241
    Height = 21
    Color = 14087154
    TabOrder = 1
  end
  object classEdit: TEdit
    Left = 64
    Top = 28
    Width = 241
    Height = 21
    Color = 14087154
    TabOrder = 2
  end
  object functionEdit: TEdit
    Left = 64
    Top = 51
    Width = 241
    Height = 21
    Color = 14087154
    TabOrder = 3
  end
  object Panel1: TPanel
    Left = 0
    Top = 282
    Width = 376
    Height = 66
    Align = alBottom
    TabOrder = 4
    object okBtn: TBitBtn
      Left = 72
      Top = 24
      Width = 75
      Height = 25
      Caption = '&OK'
      Default = True
      ModalResult = 1
      TabOrder = 0
      NumGlyphs = 2
    end
    object closeBtn: TBitBtn
      Left = 208
      Top = 24
      Width = 75
      Height = 25
      Caption = '&Cancel'
      ModalResult = 2
      TabOrder = 1
      NumGlyphs = 2
    end
  end
  object paramPopupMenu: TPopupMenu
    Left = 128
    Top = 184
    object N1: TMenuItem
      Caption = 'Delete'
      OnClick = N1Click
    end
  end
end
