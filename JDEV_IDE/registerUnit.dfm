object regForm: TregForm
  Left = 376
  Top = 175
  BorderStyle = bsDialog
  Caption = 'Register dialog'
  ClientHeight = 131
  ClientWidth = 350
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
    Top = 24
    Width = 57
    Height = 13
    Caption = 'Produce ID:'
  end
  object Label2: TLabel
    Left = 9
    Top = 54
    Width = 40
    Height = 13
    Caption = 'License:'
  end
  object productIDEdit: TEdit
    Left = 72
    Top = 20
    Width = 273
    Height = 21
    TabOrder = 0
  end
  object LicenseEdit: TEdit
    Left = 72
    Top = 52
    Width = 273
    Height = 21
    TabOrder = 1
  end
  object registerBtn: TButton
    Left = 80
    Top = 88
    Width = 75
    Height = 25
    Caption = 'Register'
    ModalResult = 1
    TabOrder = 2
    OnClick = registerBtnClick
  end
  object cancelBtn: TButton
    Left = 208
    Top = 88
    Width = 75
    Height = 25
    Caption = 'Cancel'
    ModalResult = 2
    TabOrder = 3
    OnClick = cancelBtnClick
  end
end
