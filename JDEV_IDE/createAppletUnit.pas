unit createAppletUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Grids, ValEdit, Mask, ExtCtrls, Buttons;

type
  TcreateAppletFrm = class(TForm)
    featureSetup: TPanel;
    Label11: TLabel;
    Label13: TLabel;
    Label14: TLabel;
    Label15: TLabel;
    Label16: TLabel;
    heightEdit: TMaskEdit;
    widthEdit: TMaskEdit;
    appletNameEdit: TEdit;
    GroupBox5: TGroupBox;
    paramList: TValueListEditor;
    useArchive: TCheckBox;
    archiveClassEdit: TEdit;
    codebaseEdit: TEdit;
    beginAppBtn: TBitBtn;
    CloseBtn: TBitBtn;
    Label1: TLabel;
    appletNameLbl: TLabel;
    isStopAtInit: TCheckBox;
    procedure useArchiveClick(Sender: TObject);
    procedure beginAppBtnClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation
uses
  uCommandData;
{$R *.dfm}

procedure TcreateAppletFrm.useArchiveClick(Sender: TObject);
begin
  if  useArchive.Checked then
    archiveClassEdit.Enabled:=true
  else
    archiveClassEdit.Enabled:=false;
end;

procedure TcreateAppletFrm.beginAppBtnClick(Sender: TObject);
begin
  if Trim(heightEdit.Text) = '' then
  begin
    showerror(self.Handle,getErrorMsg('PleaseInputHeight'),getErrorMsg('ErrorDlgCaption'),MB_OK);
    self.ModalResult:=mrNone;
    exit;
  end;
  if Trim(widthEdit.Text) = '' then
  begin
    showerror(self.Handle,getErrorMsg('PleaseInputWidth'),getErrorMsg('ErrorDlgCaption'),MB_OK);
    self.ModalResult:=mrNone;
    exit;
  end;
  if trim(codeBaseEdit.Text) ='' then
  begin
    codeBaseEdit.Text:='.';
  end;
  
end;

end.
