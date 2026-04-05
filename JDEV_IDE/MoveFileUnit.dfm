object MoveFileForm: TMoveFileForm
  Left = 369
  Top = 226
  BorderStyle = bsDialog
  Caption = 'Move file dialog'
  ClientHeight = 104
  ClientWidth = 325
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 8
    Top = 32
    Width = 51
    Height = 13
    Caption = 'Move to'#65306
  end
  object fileNameLbl: TLabel
    Left = 72
    Top = 8
    Width = 241
    Height = 13
    AutoSize = False
  end
  object Label2: TLabel
    Left = 8
    Top = 8
    Width = 65
    Height = 13
    Caption = 'Source File'#65306
  end
  object destPackComboBox: TComboBox
    Left = 72
    Top = 27
    Width = 249
    Height = 21
    Style = csDropDownList
    Color = 14087154
    ItemHeight = 13
    TabOrder = 0
  end
  object BitBtn1: TBitBtn
    Left = 56
    Top = 64
    Width = 75
    Height = 25
    Caption = 'OK'
    Default = True
    ModalResult = 1
    TabOrder = 1
    NumGlyphs = 2
  end
  object BitBtn2: TBitBtn
    Left = 192
    Top = 64
    Width = 75
    Height = 25
    Cancel = True
    Caption = 'Cancel'
    ModalResult = 2
    TabOrder = 2
    NumGlyphs = 2
  end
end
