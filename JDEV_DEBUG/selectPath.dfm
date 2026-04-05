object selectPathDlg: TselectPathDlg
  Left = 332
  Top = 248
  BorderStyle = bsDialog
  Caption = #36873#25321#36335#24452
  ClientHeight = 272
  ClientWidth = 305
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object pathLbl: TLabel
    Left = 96
    Top = 8
    Width = 76
    Height = 13
    Caption = 'F:\projects\jdev'
  end
  object Label2: TLabel
    Left = 16
    Top = 8
    Width = 60
    Height = 13
    Caption = #25152#36873#36335#24452#65306
  end
  object DriveComboBox1: TDriveComboBox
    Left = 16
    Top = 32
    Width = 273
    Height = 19
    DirList = DirectoryListBox1
    TabOrder = 0
  end
  object DirectoryListBox1: TDirectoryListBox
    Left = 16
    Top = 56
    Width = 273
    Height = 169
    DirLabel = pathLbl
    ItemHeight = 16
    TabOrder = 1
  end
  object BitBtn1: TBitBtn
    Left = 48
    Top = 240
    Width = 75
    Height = 25
    Caption = #30830#35748
    TabOrder = 2
    Kind = bkOK
  end
  object BitBtn2: TBitBtn
    Left = 168
    Top = 240
    Width = 75
    Height = 25
    Caption = #21462#28040
    TabOrder = 3
    Kind = bkClose
  end
end
