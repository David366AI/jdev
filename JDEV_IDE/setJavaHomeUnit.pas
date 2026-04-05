unit setJavaHomeUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, DirDialog, Buttons, StdCtrls,Registry;

type
  TsetJavaHomeForm = class(TForm)
    Label1: TLabel;
    pathNameEdit: TEdit;
    BrowserBtn: TButton;
    OkBtn: TBitBtn;
    HltBtn: TBitBtn;
    DirDialog: TDirDialog;
    procedure HltBtnClick(Sender: TObject);
    procedure BrowserBtnClick(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
  private
    index:Integer;
  public
    { Public declarations }
    Constructor Create(p:TComponent;index:Integer);
  end;


implementation

uses ideUnit,uCommandData;

{$R *.dfm}

Constructor TsetJavaHomeForm.Create(p:TComponent;index:Integer);
begin
  inherited create(p);
  self.index := index;
  if index <> 0 then
    self.HltBtn.Caption:='C&lose';
end;

procedure TsetJavaHomeForm.HltBtnClick(Sender: TObject);
begin
  if  (index = 0)  then
  begin
    FreeMem(g_SystemClassPath,2048);
    halt;
  end else
    close;
end;

procedure TsetJavaHomeForm.BrowserBtnClick(Sender: TObject);
begin
  if  DirDialog.Execute then
  begin
    pathNameEdit.Text:=DirDialog.Directory;
  end;
end;

procedure TsetJavaHomeForm.FormCloseQuery(Sender: TObject;
  var CanClose: Boolean);
begin
  if  index = 0 then
  begin
    if Trim(pathNameEdit.Text) = '' then
    begin
      CanClose:=FALSE;
      exit;
    end;
    if Not Fileexists(getRealPath(Trim(pathNameEdit.Text))+'bin\java.exe') then
    begin
      MessageBox(ideFrm.handle,PChar(getErrorMsg('JavaHomeWrong')),
                   PChar(getErrorMsg('ErrorDlgCaption')),MB_OK or MB_ICONWARNING);
      CanClose:=FALSE;
      exit;
    end;
    if index = 0 then
      g_javaHome:=getRealPath(Trim(pathNameEdit.Text));
  end;
end;

end.
