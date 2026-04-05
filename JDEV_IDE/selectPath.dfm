object selectPathDlg: TselectPathDlg
  Left = 332
  Top = 248
  BorderStyle = bsDialog
  Caption = 'Select Path'
  ClientHeight = 272
  ClientWidth = 305
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
  object pathLbl: TLabel
    Left = 120
    Top = 8
    Width = 14
    Height = 13
    Caption = 'F:\'
  end
  object Label2: TLabel
    Left = 16
    Top = 8
    Width = 98
    Height = 13
    Caption = 'You selected path'#65306
  end
  object DriveComboBox1: TDriveComboBox
    Left = 16
    Top = 32
    Width = 273
    Height = 19
    Color = 14087154
    DirList = DirectoryListBox1
    TabOrder = 0
  end
  object DirectoryListBox1: TDirectoryListBox
    Left = 16
    Top = 56
    Width = 273
    Height = 169
    Color = 14087154
    DirLabel = pathLbl
    ItemHeight = 16
    TabOrder = 1
  end
  object BitBtn1: TBitBtn
    Left = 48
    Top = 240
    Width = 75
    Height = 25
    Caption = '&OK'
    Default = True
    ModalResult = 1
    TabOrder = 2
    NumGlyphs = 2
  end
  object BitBtn2: TBitBtn
    Left = 168
    Top = 240
    Width = 75
    Height = 25
    Caption = '&Cancel'
    ModalResult = 2
    TabOrder = 3
    NumGlyphs = 2
  end
end
