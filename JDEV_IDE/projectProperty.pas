unit projectProperty;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, Buttons, ComCtrls ,uCommandData;


type
  TprojectPropertyFrm = class(TForm)
    beginAppBtn: TBitBtn;
    CloseBtn: TBitBtn;
    jarzipDlg: TOpenDialog;
    projectPageControl: TPageControl;
    basicTS: TTabSheet;
    MainClassTS: TTabSheet;
    classPathTS: TTabSheet;
    GroupBox1: TGroupBox;
    GroupBox2: TGroupBox;
    Label2: TLabel;
    Label8: TLabel;
    parametersEdit: TEdit;
    Label1: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label9: TLabel;
    pro_filename_edit: TEdit;
    pro_path_edit: TEdit;
    pro_name_edit: TEdit;
    pro_javatype_rb: TRadioButton;
    pro_webtype_rb: TRadioButton;
    pro_author_edit: TEdit;
    pro_createTime_lbl: TLabel;
    browserBtn: TBitBtn;
    webAppTS: TTabSheet;
    Label7: TLabel;
    ClassTreeView: TTreeView;
    Label10: TLabel;
    pro_updatetime_lbl: TLabel;
    Label12: TLabel;
    version_lbl: TLabel;
    GroupBox3: TGroupBox;
    existCPMemo: TMemo;
    GroupBox4: TGroupBox;
    addDirBtn: TButton;
    addJarBtn: TButton;
    cpListBox: TListBox;
    deleteBtn: TButton;
    clearBtn: TButton;
    procedure beginAppBtnClick(Sender: TObject);
    procedure CloseBtnClick(Sender: TObject);
    procedure addDirBtnClick(Sender: TObject);
    procedure pro_name_editChange(Sender: TObject);
    procedure browserBtnClick(Sender: TObject);
    procedure pro_javatype_rbClick(Sender: TObject);
    procedure ClassTreeViewCustomDrawItem(Sender: TCustomTreeView;
      Node: TTreeNode; State: TCustomDrawState; var DefaultDraw: Boolean);
    procedure clearBtnClick(Sender: TObject);
    procedure deleteBtnClick(Sender: TObject);
    procedure addJarBtnClick(Sender: TObject);
    procedure ClassTreeViewChanging(Sender: TObject; Node: TTreeNode;
      var AllowChange: Boolean);
  private
    openType:Integer;
    path:String;
    cpChanged:Boolean;
  public
    constructor create(owner:TComponent;openType:integer);
  end;

implementation
uses
  ideUnit,selectPath;
{$R *.dfm}

constructor TprojectPropertyFrm.create(owner:TComponent;openType:integer);
var
  i,j:Integer;
  s:String;
begin
  inherited create(owner);
  cpChanged:=false;
  self.openType:=openType;
  if (length(g_IDE_ClassPath) > 0)  and (g_IDE_ClassPath[length(g_IDE_ClassPath)]=';') then
    existCpMemo.Lines.Text := g_IDE_ClassPath + g_SystemClassPath
  else
    existCpMemo.Lines.Text := g_SystemClassPath;

  if openType = UPDATE_PROJECT then
  begin
    if G_Project = nil then
      exit;
    pro_name_edit.Text:=G_Project.name;

    pro_path_edit.Text := G_Project.Path;
    pro_path_edit.Enabled:=false;
    browserBtn.Enabled:=false;

    pro_filename_edit.Text:= G_Project.fileName;
    pro_filename_edit.Enabled:=false;

    pro_createTime_lbl.Caption:=G_Project.createDateTime;
    pro_updatetime_lbl.Caption:=G_Project.lastModifiedDateTime;

    if  G_Project.projectType = JAVAAPPLICATION then
      pro_javatype_rb.Checked:=true
    else
      pro_webtype_rb.Checked:=true;
    s := G_Project.cfg.classPath;
    while true do
    begin
      j:=Pos(';',s);
      if j<=0 then
        break;
      cpListBox.Items.Add(Copy(s,1,j-1));
      s:=Copy(s,j+1,length(s));
    end;

    pro_author_edit.Text := G_Project.cfg.author;
    parametersEdit.Text := G_Project.cfg.parameter;
    version_lbl.Caption := G_Project.cfg.version;
    updateProjectTreeView(ClassTreeView,true);

    for i:=0 to G_Project.packageList.Count-1 do
    begin
      if TPackage(G_Project.packageList[i]).name = G_Project.cfg.mainClassPackage then
      begin
        for j:=0 to TPackage(G_Project.packageList[i]).fileList.Count-1 do
          if TSubFile(TPackage(G_Project.packageList[i]).fileList[j]).name = G_Project.cfg.mainClassName+'.java' then
          begin
            classTreeView.Selected:=TSubFile(TPackage(G_Project.packageList[i]).fileList[j]).fileNode;
            exit;
          end;
      end;
    end;
  end;

  if openType = CREATE_PROJECT then
  begin
    pro_path_edit.Text:= g_projectFilePath;
    pro_javatype_rb.Checked:=true;
    pro_webtype_rb.Checked:=false;
    path:=g_projectFilePath;
    pro_filename_edit.Text:='ProjectFileName.jdp';
    pro_author_edit.Text:=getCurrentLoginUser;
    pro_createtime_lbl.Caption:=FormatDateTime('yyyy-mm-dd hh:nn:ss',now);
    version_lbl.Caption:='1.0';
  end;

end;

procedure TprojectPropertyFrm.beginAppBtnClick(Sender: TObject);
begin
  if Trim(pro_name_edit.Text) = '' then
  begin
    MessageBox(Handle,PChar(getErrorMsg('PleaseInputProjectName')),PChar(getErrorMsg('ErrorDlgCaption')),MB_OK);
    modalResult :=mrNone;
    exit;
  end;
  if (( openType = UPDATE_PROJECT)
      and ( classTreeview.Selected <> nil) ) then
  begin
    if not findMainMethod(TSubFile(classTreeview.Selected.data)) then
    begin
      if MessageBox(Handle,PChar(getErrorMsg('NoMainMethodInClass')),PChar(getErrorMsg('ErrorDlgCaption')),MB_OKCANCEL or MB_ICONWARNING) <> IDOK then
      begin
        modalResult :=mrNone;
        exit;
      end;
    end;
  end;
  if cpChanged then
  begin
    StartupAnalysisProcess;
  end;
  modalResult :=mrOK;
end;

procedure TprojectPropertyFrm.CloseBtnClick(Sender: TObject);
begin
  modalResult :=mrCancel;
end;

procedure TprojectPropertyFrm.addDirBtnClick(Sender: TObject);
var
  i:Integer;
begin
 if  selectPathDlg.ShowModal = mrOK then
 begin
   for i:=0 to cpListBox.items.Count-1 do
   begin
     if cpListBox.items[i] = selectPathDlg.pathLbl.Caption then
       exit;
   end;
   cpListBox.items.add(selectPathDlg.pathLbl.Caption);
   cpChanged:=true;
 end;
end;

procedure TprojectPropertyFrm.pro_name_editChange(Sender: TObject);
begin
  if openType = CREATE_PROJECT then
  begin
    pro_filename_edit.Text:=pro_name_edit.Text + '.jdp';
    pro_path_edit.Text:= getRealPath(path) + pro_name_edit.Text;
  end;
end;

procedure TprojectPropertyFrm.browserBtnClick(Sender: TObject);
begin
 selectPathDlg.DirectoryListBox1.Directory:=pro_path_edit.Text;
 if  selectPathDlg.ShowModal = mrOK then
 begin
   pro_path_edit.text:=selectPathDlg.pathLbl.caption;
   path:= pro_path_edit.text;
 end;
end;

procedure TprojectPropertyFrm.pro_javatype_rbClick(Sender: TObject);
begin
  if pro_javatype_rb.Checked then
  begin
    MainClassTS.TabVisible:=true;
    webAppTS.TabVisible:=false;
  end;
  if pro_webtype_rb.Checked then
  begin
    MainClassTS.TabVisible:=false;
    webAppTS.TabVisible:=true;
  end;
end;

procedure TprojectPropertyFrm.ClassTreeViewCustomDrawItem(
  Sender: TCustomTreeView; Node: TTreeNode; State: TCustomDrawState;
  var DefaultDraw: Boolean);
var
  NodeRect:TRect;
begin
   with ClassTreeView.Canvas do
   begin
     Font.size:=10;
     Font.Style:=[];
     if Node.Selected then
     begin
        Brush.Color := clblue;
        Font.Color:=clWhite;
        NodeRect := ClassTreeView.Selected.DisplayRect(true);
        FillRect(NodeRect);
        TextOut(NodeRect.left+2,NodeRect.top+1,ClassTreeView.Selected.Text) ;
     end;
   end;
end;

procedure TprojectPropertyFrm.clearBtnClick(Sender: TObject);
begin
  cpListBox.Items.Clear;
  cpChanged:=true;
end;

procedure TprojectPropertyFrm.deleteBtnClick(Sender: TObject);
begin
  cpListBox.items.Delete(cpListBox.ItemIndex);
  cpChanged:=true;
end;

procedure TprojectPropertyFrm.addJarBtnClick(Sender: TObject);
var
  i:Integer;
begin
 if  jarzipDlg.Execute then
 begin
   for i:=0 to cpListBox.items.Count-1 do
   begin
     if cpListBox.items[i] = jarzipDlg.FileName then
       exit;
   end;
   cpListBox.items.add(jarzipDlg.FileName);
   cpChanged:=true;
 end;
end;

procedure TprojectPropertyFrm.ClassTreeViewChanging(Sender: TObject;
  Node: TTreeNode; var AllowChange: Boolean);
begin
  if TTag(node.Data).tag = FILE_TAG then
    AllowChange := true
  else
    AllowChange := false;
end;

end.
