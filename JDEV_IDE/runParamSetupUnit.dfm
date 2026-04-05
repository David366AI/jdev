object RunParamSetupDlg: TRunParamSetupDlg
  Left = 310
  Top = 157
  BorderStyle = bsDialog
  Caption = 'Run java application'
  ClientHeight = 171
  ClientWidth = 320
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
  object Label1: TLabel
    Left = 16
    Top = 16
    Width = 137
    Height = 13
    AutoSize = False
    Caption = 'Aapplication Command:'
  end
  object appNameLbl: TLabel
    Left = 40
    Top = 38
    Width = 273
    Height = 13
    AutoSize = False
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlue
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
  end
  object Label2: TLabel
    Left = 16
    Top = 61
    Width = 289
    Height = 13
    AutoSize = False
    Caption = 'Parameters(eg.: arg1 arg2 ) :'
  end
  object runBtn: TBitBtn
    Left = 56
    Top = 136
    Width = 75
    Height = 25
    Caption = 'OK'
    Default = True
    ModalResult = 1
    TabOrder = 0
    NumGlyphs = 2
  end
  object BitBtn2: TBitBtn
    Left = 208
    Top = 136
    Width = 75
    Height = 25
    Cancel = True
    Caption = 'Cancel'
    ModalResult = 2
    TabOrder = 1
    NumGlyphs = 2
  end
  object paramsEdit: TEdit
    Left = 16
    Top = 81
    Width = 297
    Height = 21
    Color = 14087154
    TabOrder = 2
  end
  object mainStopChecked: TCheckBox
    Left = 16
    Top = 109
    Width = 129
    Height = 17
    Caption = 'Stop at main function'
    Checked = True
    State = cbChecked
    TabOrder = 3
  end
end
