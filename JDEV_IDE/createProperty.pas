unit createProperty;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ComCtrls, StdCtrls, ExtCtrls,uCommandData;

type
  TcreatePropertyForm = class(TForm)
    Label1: TLabel;
    proNameEdit: TEdit;
    Label2: TLabel;
    isArrayCB: TCheckBox;
    Label3: TLabel;
    arrayDimentionsEdit: TEdit;
    dimentionsUpDown: TUpDown;
    GroupBox1: TGroupBox;
    p_final_CB: TCheckBox;
    p_static_CB: TCheckBox;
    p_transient_CB: TCheckBox;
    p_volatile_CB: TCheckBox;
    generateMethodCB: TCheckBox;
    OkBtn: TButton;
    CancelBtn: TButton;
    Label4: TLabel;
    proTypeSel: TComboBox;
    propertyModifierRG: TRadioGroup;
    getterGroupBox: TRadioGroup;
    setterGroupBox: TRadioGroup;
    commentEdit: TEdit;
    procedure isArrayCBClick(Sender: TObject);
    procedure generateMethodCBClick(Sender: TObject);
    procedure OkBtnClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
  private
     
  public
    proStr:TStringList;
    methodStr:TStringList;
  end;

implementation

{$R *.dfm}

procedure TcreatePropertyForm.isArrayCBClick(Sender: TObject);
begin
  dimentionsUpDown.Enabled:=isArrayCB.Checked;
  arrayDimentionsEdit.Enabled:=isArrayCB.Checked;
end;

procedure TcreatePropertyForm.generateMethodCBClick(Sender: TObject);
begin
  getterGroupBox.Enabled:= generateMethodCB.Checked;
  setterGroupBox.Enabled:= generateMethodCB.Checked;
end;

procedure TcreatePropertyForm.OkBtnClick(Sender: TObject);
var
  i:Integer;
  temp:String;
  params:TStringList;
begin
  if trim(proNameEdit.Text) = '' then
  begin
    ShowError(self.Handle,getErrorMsg('PleaseInputPropertyName'),getErrorMsg('ErrorDlgCaption'),MB_OK or MB_ICONWARNING);
    self.ModalResult:=mrNone;
    exit;
  end;
  
  if not IsValidFileName(trim(proNameEdit.Text)) then
  begin
    ShowError(self.Handle,getErrorMsg('InvalidPropertyName'),getErrorMsg('ErrorDlgCaption'),MB_OK or MB_ICONWARNING);
    self.ModalResult:=mrNone;
    exit;
  end;

  if trim(proTypeSel.Text) = '' then
  begin
    ShowError(self.Handle,getErrorMsg('PleaseInputPropertyType'),getErrorMsg('ErrorDlgCaption'),MB_OK or MB_ICONWARNING);
    self.ModalResult:=mrNone;
    exit;
  end;
  if commentEdit.Text = '' then
    proStr.Add('// field:'+ proNameEdit.Text)
  else
    proStr.Add('// '+ commentEdit.Text);

  temp:=getModifierByIndex(propertyModifierRG.ItemIndex);
  if p_final_CB.Checked then
    temp:=temp + ' final';
  if p_static_CB.Checked then
    temp:=temp + ' static';
  if p_transient_CB.Checked then
    temp:=temp + ' transient';
  if p_volatile_CB.Checked then
    temp:=temp + ' volatile';
  temp:=trim(temp);
  if isArrayCB.Checked then
    for i:=1 to StrToInt(arrayDimentionsEdit.text) do
      proTypeSel.Text:=proTypeSel.Text+'[]';
  if trim(temp) = '' then
    temp := proTypeSel.Text+' ' +  proNameEdit.Text + ' ;'
  else
    temp := temp + ' ' + proTypeSel.Text+' ' +  proNameEdit.Text + ' ;';

  proStr.Add(temp);

  //getter and setter method
  if generateMethodCB.Checked then
  begin
    //generate the string of method;
    params:=TStringList.Create;
    params.Add(proTypeSel.Text + ' '+ proNameEdit.Text + ' ;');
    methodStr.Text:=getCommentOfMethod('set' + getSetName(proNameEdit.Text),params,'void');
    methodStr.Add(getModifierByIndex(setterGroupBox.ItemIndex)+'void set'+getSetName(proNameEdit.Text)+'( '+ proTypeSel.Text + ' ' +proNameEdit.Text +' )');
    methodStr.Add('{');
    methodStr.Add('    this.'+ proNameEdit.Text + ' = ' + proNameEdit.Text+' ;');
    methodStr.Add('}');
    methodStr.Add('');

    params.free;

    methodStr.Text:=methodStr.Text + getCommentOfMethod('get' + getSetName(proNameEdit.Text),nil,proTypeSel.Text);
    methodStr.Add(getModifierByIndex(getterGroupBox.ItemIndex) + proTypeSel.Text +' get'+ getSetName(proNameEdit.Text)+'( )');
    methodStr.Add('{');
    methodStr.Add('    return this.'+ proNameEdit.Text + ' ;');
    methodStr.Add('}');
  end;

end;

procedure TcreatePropertyForm.FormCreate(Sender: TObject);
begin
  proStr:=TStringList.Create;
  methodStr:=TStringList.Create;
end;

procedure TcreatePropertyForm.FormDestroy(Sender: TObject);
begin
  proStr.Free;
  methodStr.Free;
end;


end.
