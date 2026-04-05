object addParamForm: TaddParamForm
  Left = 440
  Top = 259
  BorderStyle = bsDialog
  Caption = 'Add Parameter Dialog'
  ClientHeight = 131
  ClientWidth = 256
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
    Left = 2
    Top = 11
    Width = 75
    Height = 13
    Caption = 'paramter Name:'
  end
  object Label2: TLabel
    Left = 2
    Top = 41
    Width = 77
    Height = 13
    Caption = 'parameter Type:'
  end
  object Label3: TLabel
    Left = 88
    Top = 68
    Width = 80
    Height = 13
    Caption = 'Array dimentions:'
  end
  object paramNameEdit: TEdit
    Left = 88
    Top = 6
    Width = 137
    Height = 21
    ImeName = #32043#20809#25340#38899#36755#20837#27861
    TabOrder = 0
    Text = 'param'
  end
  object paramTypeSel: TComboBox
    Left = 87
    Top = 37
    Width = 140
    Height = 21
    ImeName = #32043#20809#25340#38899#36755#20837#27861
    ItemHeight = 13
    TabOrder = 1
    Items.Strings = (
      'byte'
      'Boolean'
      'char'
      'double'
      'float'
      'int'
      'long'
      'short'
      'String')
  end
  object arrayDimentionsEdit: TEdit
    Left = 181
    Top = 64
    Width = 32
    Height = 21
    Enabled = False
    ImeName = #32043#20809#25340#38899#36755#20837#27861
    ReadOnly = True
    TabOrder = 2
    Text = '1'
  end
  object dimentionsUpDown: TUpDown
    Left = 213
    Top = 64
    Width = 15
    Height = 21
    Associate = arrayDimentionsEdit
    Enabled = False
    Min = 1
    Max = 5
    Position = 1
    TabOrder = 3
    Wrap = False
  end
  object isArrayCB: TCheckBox
    Left = 3
    Top = 66
    Width = 65
    Height = 17
    Caption = 'Is Array'
    TabOrder = 4
    OnClick = isArrayCBClick
  end
  object addBtn: TButton
    Left = 32
    Top = 96
    Width = 75
    Height = 25
    Caption = '&Add'
    TabOrder = 5
    OnClick = addBtnClick
  end
  object closeBtn: TButton
    Left = 152
    Top = 96
    Width = 75
    Height = 25
    Caption = '&Close'
    ModalResult = 2
    TabOrder = 6
  end
end
