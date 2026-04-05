object createPropertyForm: TcreatePropertyForm
  Left = 310
  Top = 137
  BorderStyle = bsDialog
  Caption = 'Create class property wizard'
  ClientHeight = 393
  ClientWidth = 420
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poDesktopCenter
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 8
    Top = 11
    Width = 73
    Height = 13
    Caption = 'Property Name:'
  end
  object Label2: TLabel
    Left = 200
    Top = 9
    Width = 65
    Height = 13
    Caption = 'Property type:'
  end
  object Label3: TLabel
    Left = 87
    Top = 32
    Width = 80
    Height = 13
    Caption = 'Array dimentions:'
  end
  object Label4: TLabel
    Left = 8
    Top = 56
    Width = 89
    Height = 13
    Caption = 'Property Comment:'
  end
  object proNameEdit: TEdit
    Left = 88
    Top = 6
    Width = 105
    Height = 21
    TabOrder = 0
  end
  object isArrayCB: TCheckBox
    Left = 8
    Top = 30
    Width = 65
    Height = 17
    Caption = 'Is Array'
    TabOrder = 2
    OnClick = isArrayCBClick
  end
  object arrayDimentionsEdit: TEdit
    Left = 178
    Top = 28
    Width = 121
    Height = 21
    Enabled = False
    ReadOnly = True
    TabOrder = 3
    Text = '1'
  end
  object dimentionsUpDown: TUpDown
    Left = 299
    Top = 28
    Width = 15
    Height = 21
    Associate = arrayDimentionsEdit
    Enabled = False
    Min = 1
    Max = 5
    Position = 1
    TabOrder = 4
    Wrap = False
  end
  object GroupBox1: TGroupBox
    Left = 8
    Top = 160
    Width = 401
    Height = 41
    Caption = 'Property Extention Modifier'
    TabOrder = 6
    object p_final_CB: TCheckBox
      Left = 8
      Top = 16
      Width = 89
      Height = 17
      Caption = 'final'
      TabOrder = 0
    end
    object p_static_CB: TCheckBox
      Left = 105
      Top = 16
      Width = 89
      Height = 17
      Caption = 'static'
      TabOrder = 1
    end
    object p_transient_CB: TCheckBox
      Left = 203
      Top = 16
      Width = 89
      Height = 17
      Caption = 'transient'
      TabOrder = 2
    end
    object p_volatile_CB: TCheckBox
      Left = 299
      Top = 16
      Width = 89
      Height = 17
      Caption = 'volatile'
      TabOrder = 3
    end
  end
  object generateMethodCB: TCheckBox
    Left = 8
    Top = 208
    Width = 201
    Height = 17
    Caption = 'Generate getter and setter method'
    TabOrder = 7
    OnClick = generateMethodCBClick
  end
  object OkBtn: TButton
    Left = 64
    Top = 352
    Width = 75
    Height = 25
    Caption = '&OK'
    ModalResult = 1
    TabOrder = 8
    OnClick = OkBtnClick
  end
  object CancelBtn: TButton
    Left = 280
    Top = 352
    Width = 75
    Height = 25
    Caption = '&Cancel'
    ModalResult = 2
    TabOrder = 9
  end
  object proTypeSel: TComboBox
    Left = 268
    Top = 5
    Width = 145
    Height = 21
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
  object propertyModifierRG: TRadioGroup
    Left = 8
    Top = 104
    Width = 401
    Height = 49
    Caption = 'Property Modifier'
    Columns = 4
    ItemIndex = 0
    Items.Strings = (
      'private'
      'protected'
      'default'
      'public')
    TabOrder = 10
  end
  object getterGroupBox: TRadioGroup
    Left = 8
    Top = 232
    Width = 185
    Height = 105
    Caption = 'Getter Modifier'
    Columns = 2
    Enabled = False
    ItemIndex = 3
    Items.Strings = (
      'private'
      'protected'
      'default'
      'public')
    TabOrder = 11
  end
  object setterGroupBox: TRadioGroup
    Left = 224
    Top = 232
    Width = 185
    Height = 105
    Caption = 'Setter Modifier'
    Columns = 2
    Enabled = False
    ItemIndex = 3
    Items.Strings = (
      'private'
      'protected'
      'default'
      'public')
    TabOrder = 12
  end
  object commentEdit: TEdit
    Left = 8
    Top = 72
    Width = 401
    Height = 21
    TabOrder = 5
  end
end
