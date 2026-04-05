unit CreateApp;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, Buttons,DataInfo;

type
  TCreateAppDlg = class(TForm)
    LinkMethod: TRadioGroup;
    PortOrAddressLabel: TLabel;
    beginAppBtn: TBitBtn;
    CloseBtn: TBitBtn;
    jarzipDlg: TOpenDialog;
    GroupBox1: TGroupBox;
    classPathMemo: TMemo;
    PortOrAddressEdit: TEdit;
    mainStopChecked: TCheckBox;
    GroupBox2: TGroupBox;
    Label2: TLabel;
    parametersEdit: TEdit;
    Label7: TLabel;
    Label8: TLabel;
    initalpathEdit: TEdit;
    ClassNameEdit: TEdit;
    SelectClassBtn: TBitBtn;
    Button1: TButton;
    Button2: TButton;
    procedure LinkMethodClick(Sender: TObject);
    procedure beginAppBtnClick(Sender: TObject);
    procedure CloseBtnClick(Sender: TObject);
    procedure SelectClassBtnClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    link:TLinkMethod;
    constructor create(owner:TComponent;sysClassPath:String);
  end;

implementation
uses
  selectPath,ideUnit;
{$R *.dfm}

constructor TCreateAppDlg.create(owner:TComponent;sysClassPath:String);
begin
  inherited create(owner);
  classPathMemo.Text:='.;'+sysClassPath;
  PortOrAddressEdit.Text:=FormatDateTime('hhnnsszzz',now);
end;

procedure TCreateAppDlg.LinkMethodClick(Sender: TObject);
begin
  if (linkmethod.itemIndex = 1) then
  begin
     PortOrAddressEdit.MaxLength := 10;
     PortOrAddressEdit.Text:=FormatDateTime('hhnnsszzz',now);
     PortOrAddressLabel.caption := '地址名称：';
  end
  else
  begin
     PortOrAddressLabel.caption := '端口( < 65535 )';
     PortOrAddressEdit.MaxLength := 5;
     PortOrAddressEdit.Text:='12345';
  end;
end;

procedure TCreateAppDlg.beginAppBtnClick(Sender: TObject);
var
  i:Integer;
begin
  if LinkMethod.ItemIndex = 0 then
  begin
     link := lmSocket;
     try
       i:=StrToInt(PortOrAddressEdit.Text);
       if i>65535 then
       begin
         showMessage('端口必须小于65535');
         modalResult:=mrCancel;
         exit;
       end;
     except
       showMessage('端口必须为数字');
       modalResult:=mrCancel;
       exit;
     end;
  end
  else
     link := lmShmem;


  modalResult :=mrOK;
end;

procedure TCreateAppDlg.CloseBtnClick(Sender: TObject);
begin
  modalResult :=mrCancel;
end;

procedure TCreateAppDlg.SelectClassBtnClick(Sender: TObject);
begin
 if  selectPathDlg.ShowModal = mrOK then
   initalPathEdit.text:=selectPathDlg.pathLbl.caption;
end;

procedure TCreateAppDlg.FormShow(Sender: TObject);
begin
  selectClassBtn.SetFocus;
end;

procedure TCreateAppDlg.Button1Click(Sender: TObject);
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

procedure TCreateAppDlg.Button2Click(Sender: TObject);
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

end.
