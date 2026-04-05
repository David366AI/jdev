object setJavaHomeForm: TsetJavaHomeForm
  Left = 262
  Top = 182
  BorderStyle = bsDialog
  Caption = 'Set JAVA_HOME value'
  ClientHeight = 113
  ClientWidth = 327
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poDesktopCenter
  OnCloseQuery = FormCloseQuery
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 8
    Top = 8
    Width = 186
    Height = 13
    Caption = 'Please input the path of '#39'JAVA_HOME '#39
  end
  object pathNameEdit: TEdit
    Left = 8
    Top = 32
    Width = 257
    Height = 21
    ImeName = #32043#20809#25340#38899#36755#20837#27861
    TabOrder = 0
  end
  object BrowserBtn: TButton
    Left = 272
    Top = 29
    Width = 51
    Height = 25
    Caption = 'Browser'
    TabOrder = 1
    OnClick = BrowserBtnClick
  end
  object OkBtn: TBitBtn
    Left = 72
    Top = 72
    Width = 75
    Height = 25
    Caption = '&Ok'
    ModalResult = 1
    TabOrder = 2
  end
  object HltBtn: TBitBtn
    Left = 192
    Top = 72
    Width = 75
    Height = 25
    Caption = '&Halt'
    ModalResult = 2
    TabOrder = 3
    OnClick = HltBtnClick
  end
  object DirDialog: TDirDialog
    Left = 280
    Top = 64
  end
end
