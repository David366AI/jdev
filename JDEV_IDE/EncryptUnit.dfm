object Form1: TForm1
  Left = 264
  Top = 179
  Width = 532
  Height = 344
  Caption = 'Form1'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object Button1: TButton
    Left = 88
    Top = 24
    Width = 75
    Height = 25
    Caption = 'Register'
    TabOrder = 0
    OnClick = Button1Click
  end
  object Memo1: TMemo
    Left = 0
    Top = 64
    Width = 521
    Height = 249
    Lines.Strings = (
      'Memo1')
    TabOrder = 1
  end
  object CipherManager1: TCipherManager
    Mode = cmCTS
    Left = 192
    Top = 16
    Cipher = 'TCipher_Blowfish'
  end
end
