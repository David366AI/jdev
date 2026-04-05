unit selectFileTypeDlg;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons, ComCtrls, ImgList,uCommandData,
  ExtCtrls;

type
  TnewFileFrm = class(TForm)
    Label1: TLabel;
    fileTypeLV: TListView;
    okBtn: TBitBtn;
    cancelBtn: TBitBtn;
    fileTypeImageList: TImageList;
    destinationCombo: TComboBox;
    Label2: TLabel;
    StatusBar: TStatusBar;
    Label3: TLabel;
    fileNameEdit: TEdit;
    extnameEdit: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure okBtnClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure fileTypeLVMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure fileTypeLVClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure destinationComboChange(Sender: TObject);
  private
    mouseX,mouseY:Integer;
  public
    fileName:String;
  end;


implementation

uses
  WorkSpaceUnit,ideUnit;
{$R *.dfm}

procedure TnewFileFrm.FormCreate(Sender: TObject);
var
  ListItem: TListItem;
begin
  ListItem:=fileTypeLV.Items.Add;
  listItem.Caption:='java class';
  listItem.ImageIndex:=CLASS_FILE+1;

  fileTypeLV.Selected:=listitem;

  ListItem:=fileTypeLV.Items.Add;
  listItem.Caption:='Interface';
  listItem.ImageIndex:=INTERFACE_FILE+1;

  ListItem:=fileTypeLV.Items.Add;
  listItem.Caption:='Applet';
  listItem.ImageIndex:=APPLET_FILE+1;

  ListItem:=fileTypeLV.Items.Add;
  listItem.Caption:='JSP';
  listItem.ImageIndex:=JSP_FILE+1;

  ListItem:=fileTypeLV.Items.Add;
  listItem.Caption:='Servlet';
  listItem.ImageIndex:=SERVLET_FILE+1;

  ListItem:=fileTypeLV.Items.Add;
  listItem.Caption:='html';
  listItem.ImageIndex:=HTML_FILE+1;

  ListItem:=fileTypeLV.Items.Add;
  listItem.Caption:='xml';
  listItem.ImageIndex:=XML_FILE+1;

  ListItem:=fileTypeLV.Items.Add;
  listItem.Caption:='property';
  listItem.ImageIndex:=PROPERTY_FILE+1;

  ListItem:=fileTypeLV.Items.Add;
  listItem.Caption:='others';
  listItem.ImageIndex:=UNKNOWN_FILE+1;


end;



procedure TnewFileFrm.okBtnClick(Sender: TObject);
var
  i,j:integer;
  curPack:String;
begin
  if fileTypeLV.SelCount = 0 then
  begin
    ModalResult:=mrNone;
    exit;
  end;
  if fileNameEdit.Text = '' then
  begin
    ShowError(handle,getErrorMsg('PleaseInputFileName'));
    ModalResult:=mrNone;
    exit;
  end else if not IsValidFileName(fileNameEdit.Text) then
  begin
    ShowError(handle,getErrorMsg('InvalidFileName'));
    fileNameEdit.SetFocus;
    fileNameEdit.SelectAll;
    ModalResult:=mrNone;
    exit;
  end;
  if destinationCombo.ItemIndex = 0 then
    curPack:=''
  else
    curPack:=destinationCombo.Text;

    fileName:=assembleFileName(G_Project.Path+translatePackage(curPack),fileNameEdit.Text)+getFileTypeByIndex(fileTypeLV.ItemIndex);

    //检查文件是否已经存在于当前选择的包或者工程内
    for i:=0 to G_Project.packageList.Count-1 do
      if TPackage(G_Project.packageList[i]).name = curPack  then
      begin
        for j:=0 to TPackage(G_Project.packageList[i]).fileList.Count-1 do
          if  TSubFile(TPackage(G_Project.packageList[i]).fileList[j]).name = fileNameEdit.Text+ getFileTypeByIndex(fileTypeLV.ItemIndex) then
          begin
            ModalResult:=mrNone;
            showError(handle,getErrorMsg('FileExistInPackage'));
            exit;
          end;
        break;
      end;

  //检查文件是否已经存在（但是没有加入到工程中），询问是否覆盖该文件
  //如果覆盖，则删除该文件
  if FileExists(fileName) then
  begin
     if showError(handle,getErrorMsg('OverrideConfirm'),MB_OKCANCel) = IDOK then
     begin
       deletefile(fileName);
     end else
       ModalResult:=mrNone;
  end;
end;


procedure TnewFileFrm.FormShow(Sender: TObject);
var
  i:Integer;
begin
  destinationCombo.Items.Clear;
  if G_Project = nil then
    exit;
  destinationCombo.Items.Add( 'Project: '+G_Project.name);
  for i:=0 to workSpaceFrm.projectTV.Items.Count-1 do
  begin
    if TTag(workSpaceFrm.projectTV.Items[i].Data).tag = 1 then
       destinationCombo.Items.Add(TPackage(workSpaceFrm.projectTV.Items[i]).name);
  end;

  destinationCombo.ItemIndex:=0;
  statusBar.Panels[3].Text:=destinationCombo.Text;
end;

procedure TnewFileFrm.fileTypeLVMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  mouseX:=X;
  mouseY:=Y;
end;

procedure TnewFileFrm.fileTypeLVClick(Sender: TObject);
begin
  if ( htOnIcon	 in fileTypeLV.GetHitTestInfoAt(mouseX,mouseY) )
      or  ( htOnLabel	 in fileTypeLV.GetHitTestInfoAt(mouseX,mouseY) ) then
  begin
    statusBar.Panels[1].Text:=fileTypeLV.Selected.Caption;
    extnameEdit.caption:=getFileTypeByIndex(fileTypeLV.ItemIndex);
  end;
end;

procedure TnewFileFrm.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  action := caHide;
end;

procedure TnewFileFrm.destinationComboChange(Sender: TObject);
begin
   statusBar.Panels[3].Text:=destinationCombo.Text;
end;

end.

