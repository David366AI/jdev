unit addParamUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ComCtrls, uCommandData,createMethod;

type
  TaddParamForm = class(TForm)
    Label1: TLabel;
    paramNameEdit: TEdit;
    Label2: TLabel;
    paramTypeSel: TComboBox;
    arrayDimentionsEdit: TEdit;
    dimentionsUpDown: TUpDown;
    Label3: TLabel;
    isArrayCB: TCheckBox;
    addBtn: TButton;
    closeBtn: TButton;
    procedure addBtnClick(Sender: TObject);
    procedure isArrayCBClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
    cmf:TcreateMethodForm;
  public
    constructor Create(parent:TcreateMethodForm);overload;
  end;

implementation

{$R *.dfm}

constructor TaddParamForm.Create(parent:TcreateMethodForm);
begin
  inherited Create(parent);
  cmf:=parent;
end;

procedure TaddParamForm.addBtnClick(Sender: TObject);
var
  i:Integer;
  s:String;
  tmpStr:String;
  found:Boolean;
begin
  try
    if trim(paramNameEdit.Text) = '' then
    begin
      ShowError(self.Handle,getErrorMsg('PleaseInputPropertyName'),getErrorMsg('ErrorDlgCaption'),MB_OK or MB_ICONWARNING);
      self.ModalResult:=mrNone;
      exit;
    end;
  
    if not IsValidFileName(trim(paramNameEdit.Text)) then
    begin
      ShowError(self.Handle,getErrorMsg('InvalidPropertyName'),getErrorMsg('ErrorDlgCaption'),MB_OK or MB_ICONWARNING);
      self.ModalResult:=mrNone;
      exit;
    end;

    if trim(paramTypeSel.Text) = '' then
    begin
      ShowError(self.Handle,getErrorMsg('PleaseInputPropertyType'),getErrorMsg('ErrorDlgCaption'),MB_OK or MB_ICONWARNING);
      self.ModalResult:=mrNone;
      exit;
    end;
    found:=false;
    for i:=0 to cmf.paramListBox.Count-1 do
    begin
      tmpStr:= cmf.paramListBox.Items[i];
      tmpStr:=Copy(tmpStr,Pos(' ',tmpStr)+1,length(tmpStr));
      if tmpStr = trim(paramNameEdit.Text) then
      begin
        found:=true;
        break;
      end;
    end;
    if found then
    begin
      ShowError(self.Handle,getErrorMsg('ParamHasExists'),getErrorMsg('ErrorDlgCaption'),MB_OK or MB_ICONWARNING);
      self.ModalResult:=mrNone;
      exit;
    end;
  
    s:= trim(paramTypeSel.Text);
    if isArrayCB.Checked then
      for i:=1 to StrToInt(arrayDimentionsEdit.text) do
        s:=s+'[]';
    s:=s+' '+paramNameEdit.Text;
    cmf.paramListBox.items.Add(s);
    paramNameEdit.Text:='param';
    paramNameEdit.SelectAll;
    cmf.getMethod;
  finally
    
  end;
end;

procedure TaddParamForm.isArrayCBClick(Sender: TObject);
begin
  dimentionsUpDown.Enabled:=isArrayCB.Checked;
  arrayDimentionsEdit.Enabled:=isArrayCB.Checked;
end;

procedure TaddParamForm.FormCreate(Sender: TObject);
begin
  paramNameEdit.SelectAll;
end;

end.
