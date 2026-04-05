unit versionUnit;

interface

uses
  Windows, Messages, StrUtils,SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, DirDialog,uCommandData;

type
  TgenerateJarFrm = class(TForm)
    GroupBox2: TGroupBox;
    jarFileNameEdit: TEdit;
    Label1: TLabel;
    browserBtn: TButton;
    GroupBox1: TGroupBox;
    importJavaCB: TCheckBox;
    importClassCB: TCheckBox;
    importResCB: TCheckBox;
    GroupBox3: TGroupBox;
    selDebugCB: TCheckBox;
    selCompressCB: TCheckBox;
    selOverrideCB: TCheckBox;
    Label2: TLabel;
    Label3: TLabel;
    proNameLbl: TLabel;
    versionBtn: TButton;
    Button3: TButton;
    Label4: TLabel;
    jarFilePathEdit: TEdit;
    DirDialog: TDirDialog;
    Label5: TLabel;
    versionEdit: TEdit;
    procedure importClassCBClick(Sender: TObject);
    procedure browserBtnClick(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure versionBtnClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure versionEditChange(Sender: TObject);
  private
    { Private declarations }
  public
    jarFileName:String;
  end;

implementation
uses
  ideUnit;
{$R *.dfm}

procedure TgenerateJarFrm.importClassCBClick(Sender: TObject);
begin
  selDebugCB.Enabled:=importClassCB.Checked;
end;

procedure TgenerateJarFrm.browserBtnClick(Sender: TObject);
begin
  if DirDialog.Execute then
  begin
    jarFilePathEdit.Text:= DirDialog.Directory;
  end;
end;

procedure TgenerateJarFrm.Button3Click(Sender: TObject);
begin
  close;
end;

procedure TgenerateJarFrm.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
    {if importClassCB.Checked then
      if not CheckAllJavaCompile then
      begin
        showError(handle,'',getErrorMsg('ErrorDlgCaption'),MB_OK or MB_ICONWARNING);
        Action:=caNone;
      end;}
end;

procedure TgenerateJarFrm.versionBtnClick(Sender: TObject);
begin
    if (jarFileNameEdit.Text = '') or not (IsValidFileName(jarFileNameEdit.Text)) then
    begin
      showerror(self.Handle,getErrorMsg('InvalidFileName'),getErrorMsg('ErrorDlgCaption'),MB_OK or MB_ICONWARNING);
      self.ModalResult:= mrNone;
      exit;
    end;
    
    if not DirectoryExists(jarFilePathEdit.text) then
    begin
      showerror(self.Handle,getErrorMsg('PleaseSelectDirectory'),getErrorMsg('ErrorDlgCaption'),MB_OK or MB_ICONWARNING);
      self.ModalResult:= mrNone;
      exit;
    end;

    if not importjavacb.Checked and not importclasscb.Checked and not importrescb.Checked then
    begin
      showerror(self.Handle,getErrorMsg('MustSelectOneImport'),getErrorMsg('ErrorDlgCaption'),MB_OK or MB_ICONWARNING);
      self.ModalResult:= mrNone;
      exit;
    end;
    jarFileName:=getRealPath(jarFilePathEdit.text) + jarFileNameEdit.Text + '.jar';
end;

procedure TgenerateJarFrm.FormCreate(Sender: TObject);
begin
  dirDialog.Directory:=g_versionDataPath ;
end;

procedure TgenerateJarFrm.versionEditChange(Sender: TObject);
begin
  jarFileNameEdit.Text:=G_Project.name + AnsiReplaceStr(versionEdit.Text,'.','_');
end;

end.
