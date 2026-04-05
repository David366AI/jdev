unit CreateApplet;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Grids, ValEdit, StdCtrls, Buttons, Mask, ComCtrls,selectPath, ExtCtrls;

type
  TappletForm = class(TForm)
    PageControl1: TPageControl;
    TabSheet1: TTabSheet;
    TabSheet2: TTabSheet;
    featureSetup: TPanel;
    Label1: TLabel;
    heightEdit: TMaskEdit;
    widthEdit: TMaskEdit;
    Label2: TLabel;
    Label3: TLabel;
    appletNameEdit: TEdit;
    GroupBox2: TGroupBox;
    paramList: TValueListEditor;
    Label4: TLabel;
    useArchive: TCheckBox;
    archiveClassEdit: TEdit;
    Label5: TLabel;
    Panel1: TPanel;
    confirmBtn: TBitBtn;
    BitBtn2: TBitBtn;
    Label6: TLabel;
    GroupBox1: TGroupBox;
    classPathMemo: TMemo;
    addDirBtn: TButton;
    Button2: TButton;
    jarzipDlg: TOpenDialog;
    Label7: TLabel;
    classNameEdit: TEdit;
    isStopAtInit: TCheckBox;
    htmlOpenDlg: TOpenDialog;
    GroupBox3: TGroupBox;
    classCheck: TRadioButton;
    Label8: TLabel;
    classPathEdit: TEdit;
    classBtn: TBitBtn;
    htmlBtn: TBitBtn;
    htmlEdit: TEdit;
    htmlCheck: TRadioButton;
    Label9: TLabel;
    codebaseEdit: TEdit;
    procedure classCheckClick(Sender: TObject);
    procedure htmlCheckClick(Sender: TObject);
    procedure useArchiveClick(Sender: TObject);
    procedure addDirBtnClick(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure classBtnClick(Sender: TObject);
    procedure htmlBtnClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure confirmBtnClick(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
  private
    { Private declarations }
  public
    { Public declarations }
    constructor create(owner:TComponent;sysClassPath:String);
  end;

implementation

{$R *.dfm}
constructor TappletForm.create(owner:TComponent;sysClassPath:String);
begin
  inherited create(owner);
  classPathMemo.Text:='.;'+sysClassPath;
end;
procedure TappletForm.classCheckClick(Sender: TObject);
begin
  if classCheck.Checked then
  begin
    classPathEdit.Enabled:=true;
    classBtn.Enabled:=true;
    htmlEdit.Enabled:=false;
    htmlBtn.Enabled:=false;
    featureSetup.Visible:=true;
  end else
  begin
    classPathEdit.Enabled:=false;
    classBtn.Enabled:=false;
    htmlEdit.Enabled:=true;
    htmlBtn.Enabled:=true;
    featureSetup.Visible:=false;
  end;
end;

procedure TappletForm.htmlCheckClick(Sender: TObject);
begin
  if htmlCheck.Checked then
  begin
    classPathEdit.Enabled:=false;
    classBtn.Enabled:=false;
    htmlEdit.Enabled:=true;
    htmlBtn.Enabled:=true;
    featureSetup.Visible:=false;
  end else
  begin
    classPathEdit.Enabled:=true;
    classBtn.Enabled:=true;
    htmlEdit.Enabled:=false;
    htmlBtn.Enabled:=false;
    featureSetup.Visible:=true;
  end;
end;

procedure TappletForm.useArchiveClick(Sender: TObject);
begin
  if  useArchive.Checked then
    archiveClassEdit.Enabled:=true
  else
    archiveClassEdit.Enabled:=false;
end;

procedure TappletForm.addDirBtnClick(Sender: TObject);
var
  str:String;
begin
 if  selectPathDlg.ShowModal = mrOK then
 begin
   str:=trim(classPathMemo.text);
   if ((length(str) > 0  )and (str[length(str)] <> ';') ) then
     str:=str + ';' + selectPathDlg.pathLbl.Caption
   else
     str:=str + selectPathDlg.pathLbl.Caption;
 end;
 classPathMemo.Text:=str;
end;

procedure TappletForm.Button2Click(Sender: TObject);
var
  str:String;
begin
 if  jarzipDlg.Execute then
 begin
   str:=trim(classPathMemo.text);
   if ((length(str) > 0  )and (str[length(str)] <> ';') ) then
     str:=str + ';' + jarzipDlg.FileName
   else
     str:=str + jarzipDlg.FileName;
 end;
 classPathMemo.Text:=str;
end;

procedure TappletForm.classBtnClick(Sender: TObject);
begin
 if  selectPathDlg.ShowModal = mrOK then
 begin
   classPathEdit.text:=selectPathDlg.pathLbl.Caption;
   codeBaseEdit.text:=selectPathDlg.pathLbl.Caption;
 end;
end;

procedure TappletForm.htmlBtnClick(Sender: TObject);
begin
 if htmlOpenDlg.Execute then
 begin
    self.htmlEdit.text:= htmlOpenDlg.FileName;
    classNameEdit.Text:= ChangeFileExt(ExtractFileName(htmlOpenDlg.FileName),'');
 end;
end;

procedure TappletForm.FormShow(Sender: TObject);
begin
  classBtn.SetFocus;
end;

procedure TappletForm.confirmBtnClick(Sender: TObject);
begin
 if classNameEdit.Text = '' then
 begin
    application.MessageBox('情输入applet 类名','提示信息',0);
    ModalResult:=mrNone;
 end;
 if (( htmlCheck.Checked) and (htmlEdit.Text = '')) then
 begin
    application.MessageBox('情输入html 文件名','提示信息',0);
    ModalResult:=mrNone;
 end;
end;

procedure TappletForm.FormCloseQuery(Sender: TObject;
  var CanClose: Boolean);
begin
 if modalResult = mrNone then
  CanClose := false;
end;

end.


