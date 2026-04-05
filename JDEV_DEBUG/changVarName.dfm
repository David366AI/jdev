object changeVarForm: TchangeVarForm
  Left = 374
  Top = 175
  BorderStyle = bsDialog
  Caption = 'Modify Var Name Dialog'
  ClientHeight = 66
  ClientWidth = 307
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
    Top = 10
    Width = 117
    Height = 13
    Caption = 'Please input var name'#65306
  end
  object varNameEdit: TEdit
    Left = 127
    Top = 5
    Width = 156
    Height = 21
    Color = 14087154
    TabOrder = 0
  end
  object BitBtn1: TBitBtn
    Left = 40
    Top = 34
    Width = 75
    Height = 22
    Caption = 'OK'
    Default = True
    ModalResult = 1
    TabOrder = 1
    NumGlyphs = 2
  end
  object BitBtn2: TBitBtn
    Left = 192
    Top = 34
    Width = 75
    Height = 23
    Caption = '&Close'
    ModalResult = 2
    TabOrder = 2
    NumGlyphs = 2
  end
end
