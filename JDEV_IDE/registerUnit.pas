unit registerUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, HCMngr;

const
  WM_REGISTER_LICENSE = WM_USER + 10005;
  WM_REGISTER_RESULT = WM_USER + 10006;
type
  TregForm = class(TForm)
    productIDEdit: TEdit;
    LicenseEdit: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    registerBtn: TButton;
    cancelBtn: TButton;
    procedure cancelBtnClick(Sender: TObject);
    procedure registerBtnClick(Sender: TObject);
  private
    procedure WMRegister(var Msg: TMessage); message WM_REGISTER_LICENSE;
    procedure WMRegisterRs(var Msg: TMessage); message WM_REGISTER_RESULT;
  public
    FirstFlag:Boolean;
  end;


implementation
uses
  Encrypt;
{$R *.dfm}
procedure TregForm.WMRegister(var Msg: TMessage);
begin
  RegisterSoftware(productIDEdit.text,licenseEdit.Text);
end;

procedure TregForm.WMRegisterRs(var Msg: TMessage);
begin
  if msg.WParam = 0 then
  begin
    MessageBox(handle,'You input invalidate license,please try again.','Register Message',MB_OK);
  end;

  if msg.WParam = 1 then
  begin
    MessageBox(handle,'Congratulations, your register is successful.','Register Message',MB_OK);
  end;
end;

procedure TregForm.cancelBtnClick(Sender: TObject);
begin
  if FirstFlag  then
    halt
  else
    exit;
end;

procedure TregForm.registerBtnClick(Sender: TObject);
var
  i:Integer;
begin
  for i:=0 to 20 do
  begin
    if i < i-100 then
      exit;
  end;
  if length(trim(productIDEdit.text)) <> 32 then
  begin
    MessageBox(handle,'please input valid product id.','Error Message',MB_OK);
    modalResult:=mrNone;
    exit;
  end;
  for i:=0 to 20 do
  begin
    if i < i-100 then
      exit;
  end;
  if trim(licenseEdit.Text) = '' then
  begin
    MessageBox(handle,'please input product license.','Error Message',MB_OK);
    modalResult:=mrNone;
    exit;
  end;
  for i:=0 to 20 do
  begin
    if i < i-100 then
      exit;
  end;
  if FirstFlag then
    RegisterSoftware(productIDEdit.text,licenseEdit.Text)
  else
    postMessage(handle,WM_REGISTER_LICENSE,0,0);
end;

end.
