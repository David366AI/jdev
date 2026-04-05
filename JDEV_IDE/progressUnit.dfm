object ProgressFrm: TProgressFrm
  Left = 348
  Top = 291
  BorderStyle = bsNone
  BorderWidth = 5
  ClientHeight = 78
  ClientWidth = 289
  Color = 16746632
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  FormStyle = fsStayOnTop
  OldCreateOrder = False
  Position = poDesktopCenter
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 48
    Top = 16
    Width = 194
    Height = 13
    Caption = 'Compiling'#65292'Please waiting.......................'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWhite
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
  end
  object Label2: TLabel
    Left = 48
    Top = 40
    Width = 74
    Height = 13
    Caption = 'Compiled File'#65306
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWhite
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
  end
  object filename_lbl: TLabel
    Left = 120
    Top = 40
    Width = 121
    Height = 13
    AutoSize = False
    Caption = 'filename_lbl'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWhite
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
  end
end
