unit createMethod;

interface

uses
  SysUtils, Windows, Messages, Classes, Graphics, Controls,
  StdCtrls, ExtCtrls, Forms, ComCtrls,uCommandData;

type
  TcreateMethodForm = class(TForm)
    okBtn: TButton;
    cancelBtn: TButton;
    newMethodRB: TRadioButton;
    newConstructorMethod: TRadioButton;
    newMainRB: TRadioButton;
    methodEdit: TEdit;
    methodNameEdit: TEdit;
    Label1: TLabel;
    returnTypeSel: TComboBox;
    Label2: TLabel;
    arrayDimentionsEdit: TEdit;
    dimentionsUpDown: TUpDown;
    Label3: TLabel;
    isArrayCB: TCheckBox;
    methodModifierRG: TRadioGroup;
    GroupBox1: TGroupBox;
    m_final_CB: TCheckBox;
    m_static_CB: TCheckBox;
    m_native_CB: TCheckBox;
    GroupBox2: TGroupBox;
    paramListBox: TListBox;
    addBtn: TButton;
    deleteBtn: TButton;
    m_synchronized_CB: TCheckBox;
    procedure isArrayCBClick(Sender: TObject);
    procedure newMethodRBClick(Sender: TObject);
    procedure newConstructorMethodClick(Sender: TObject);
    procedure newMainRBClick(Sender: TObject);
    procedure addBtnClick(Sender: TObject);
    procedure deleteBtnClick(Sender: TObject);
    procedure returnTypeSelChange(Sender: TObject);
    procedure methodNameEditChange(Sender: TObject);
    procedure methodModifierRGClick(Sender: TObject);
    procedure m_final_CBClick(Sender: TObject);
    procedure arrayDimentionsEditChange(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
  public
    className:String;
    methodStr:TStringList;
    function getMethod:String;

  end;

implementation
uses
  addParamUnit;
{$R *.DFM}

procedure TcreateMethodForm.isArrayCBClick(Sender: TObject);
begin
  dimentionsUpDown.Enabled:=isArrayCB.Checked;
  arrayDimentionsEdit.Enabled:=isArrayCB.Checked;
  getMethod;  
end;

procedure TcreateMethodForm.newMethodRBClick(Sender: TObject);
begin
  methodEdit.Text:='public void newMethod()';
  methodNameEdit.Enabled:=true;
  methodNameEdit.Text:='newMethod';
  returnTypeSel.Enabled:=true;
  returnTypesel.Text:='void';
  isarrayCB.Checked:=false;
  isArrayCB.Enabled:=true;  
  methodModifierRG.ItemIndex:=3;
  methodModifierRG.Enabled:=true;
  m_final_CB.Enabled:=true;
  m_static_CB.Enabled:=true;
  m_native_CB.Enabled:=true;
  m_synchronized_CB.Enabled:=true;
  m_final_CB.Checked:=false;
  m_static_CB.Checked:=false;
  m_native_CB.Checked:=false;
  m_synchronized_CB.Checked:=false;
  addBtn.Enabled:=true;
  deleteBtn.Enabled:=true;
  paramListBox.Items.Clear;
  getMethod;  
end;

procedure TcreateMethodForm.newConstructorMethodClick(Sender: TObject);
begin
  methodEdit.Text:='public ' + className;
  methodNameEdit.Text:=className;
  methodNameEdit.Enabled:=false;
  returnTypesel.Text:='';
  returnTypeSel.Enabled:=false;
  isArrayCB.Enabled:=false;
  isarrayCB.Checked:=false;
  methodModifierRG.ItemIndex:=3;
  methodModifierRG.Enabled:=true;
  m_final_CB.Checked:=false;
  m_static_CB.Checked:=false;
  m_native_CB.Checked:=false;
  m_synchronized_CB.Checked:=false;
  m_final_CB.Enabled:=false;
  m_static_CB.Enabled:=false;
  m_native_CB.Enabled:=false;
  m_synchronized_CB.Enabled:=false;

  addBtn.Enabled:=true;
  deleteBtn.Enabled:=true;
  paramListBox.Items.Clear;
  getMethod;
end;

procedure TcreateMethodForm.newMainRBClick(Sender: TObject);
begin
  methodEdit.Text:='public static void main(String[] args)';
  methodNameEdit.Enabled:=false;
  methodNameEdit.Text:='main';
  returnTypeSel.Enabled:=false;
  returnTypesel.Text:='void';
  isarrayCB.Checked:=false;
  isArrayCB.Enabled:=false;
  methodModifierRG.ItemIndex:=3;
  methodModifierRG.Enabled:=false;
  m_final_CB.Checked:=false;
  m_static_CB.Checked:=true;
  m_native_CB.Checked:=false;
  m_synchronized_CB.Checked:=false;

  m_final_CB.Enabled:=false;
  m_static_CB.Enabled:=false;
  m_native_CB.Enabled:=false;
  m_synchronized_CB.Enabled:=false;
  addBtn.Enabled:=false;
  deleteBtn.Enabled:=false;
  paramListBox.Items.Clear;
  paramListBox.items.Add('String[] args');
  getMethod;
end;

procedure TcreateMethodForm.addBtnClick(Sender: TObject);
var
  addParamFrm: TaddParamForm;
begin
  addParamFrm:= TaddParamForm.Create(self);
  addParamFrm.ShowModal;
end;

procedure TcreateMethodForm.deleteBtnClick(Sender: TObject);
begin
  if paramListBox.ItemIndex >= 0 then
    paramListBox.DeleteSelected;
  getMethod;
end;

procedure TcreateMethodForm.returnTypeSelChange(Sender: TObject);
begin
  getMethod;
  if returnTypeSel.Text = 'void' then
    isArrayCB.Checked:=false
end;

function TcreateMethodForm.getMethod:String;
var
  s,return:String;
  i:Integer;
begin
  s:=getModifierByIndex(methodModifierRG.itemIndex);
  if m_final_CB.Checked then
    s:=s + ' final';
  if m_static_CB.Checked then
    s:=s + ' static';
  if m_native_CB.Checked then
    s:=s + ' native';
  if m_synchronized_CB.Checked then
    s:=s + ' synchronized';
  s:=trim(s);

  s:= s + ' ' + returnTypeSel.Text;
  return:=returnTypeSel.Text;
  if isArrayCB.Checked then
    for i:=1 to StrToInt(arrayDimentionsEdit.text) do
    begin
      s:=s+'[]';
      return:=return+'[]';
    end;
  s:=s + ' ' + methodNameEdit.text+'(';
  for i:=0 to paramListBox.Count-1 do
  begin
    s:=s+paramListBox.Items[i]+',';
  end;
  s:=trim(s);
  if s[length(s)] = ',' then
    s[length(s)] := ')'
  else
    s:=s+')';

  result:=s;
  methodEdit.Text:=s;
  methodStr.Text:=getCommentOfMethod(methodNameEdit.Text,paramListBox.Items,return);
  methodStr.Add(s);
  methodStr.Add('{');
  methodStr.Add('');
  methodStr.Add('}');
end;

procedure TcreateMethodForm.methodNameEditChange(Sender: TObject);
begin
  getMethod;
end;

procedure TcreateMethodForm.methodModifierRGClick(Sender: TObject);
begin
  getMethod;
end;

procedure TcreateMethodForm.m_final_CBClick(Sender: TObject);
begin
  getMethod;
end;

procedure TcreateMethodForm.arrayDimentionsEditChange(Sender: TObject);
begin
  getMethod;
end;

procedure TcreateMethodForm.FormCreate(Sender: TObject);
begin
    methodStr:=TStringList.Create;
end;

procedure TcreateMethodForm.FormDestroy(Sender: TObject);
begin
  methodStr.Free;
end;

end.
