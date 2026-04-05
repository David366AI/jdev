unit WorkSpaceUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ComCtrls,ExtCtrls,ClassBrowserUnit, OleCtrls, SHDocVw, SynEdit,
  SynEditHighlighter, SynHighlighterJava,uCommandData, Menus, ActnList,uEditAppIntfs,
  ImgList, XPMenu,MoveFileUnit, StdCtrls, Buttons,XMLDoc,XMLIntf,jdkhelpUnit,
  createAppletUnit,envUnit, ToolWin;

type
  TWorkSpaceFrm = class(TForm)
    projectPM: TPopupMenu;
    packagePM: TPopupMenu;
    subfilePM: TPopupMenu;
    addPackageMI: TMenuItem;
    addFileToProjectMI: TMenuItem;
    compileProjectMI: TMenuItem;
    runProjectMI: TMenuItem;
    debugProjectMI: TMenuItem;
    projectPropertyMI: TMenuItem;
    N7: TMenuItem;
    renamePackageMI: TMenuItem;
    deletePackageMI: TMenuItem;
    compilePackageMI: TMenuItem;
    addFileToPackageMI: TMenuItem;
    renameFileMI: TMenuItem;
    N14: TMenuItem;
    deleteFileMI: TMenuItem;
    compileFileMI: TMenuItem;
    runFileMI: TMenuItem;
    debugFileMI: TMenuItem;
    ActionList: TActionList;
    actAddFile: TAction;
    dlgFileOpen: TOpenDialog;
    dlgJavaOpenFile: TOpenDialog;
    N8: TMenuItem;
    treeImageList: TImageList;
    openFileMI: TMenuItem;
    N1: TMenuItem;
    N2: TMenuItem;
    ActRenameFile: TAction;
    actDeleteFile: TAction;
    actMoveFile: TAction;
    debugAppletMI: TMenuItem;
    RunAppletMI: TMenuItem;
    projectTV: TTreeView;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormShow(Sender: TObject);
    procedure FormHide(Sender: TObject);
    procedure FormDockOver(Sender: TObject; Source: TDragDockObject; X,
      Y: Integer; State: TDragState; var Accept: Boolean);
    procedure projectTVMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure actAddFileExecute(Sender: TObject);
    procedure openFileMIClick(Sender: TObject);
    procedure actAddFileUpdate(Sender: TObject);
    procedure ActRenameFileExecute(Sender: TObject);
    procedure ActRenameFileUpdate(Sender: TObject);
    procedure actDeleteFileExecute(Sender: TObject);
    procedure actDeleteFileUpdate(Sender: TObject);
    procedure actMoveFileExecute(Sender: TObject);
    procedure actMoveFileUpdate(Sender: TObject);
    procedure debugProjectMIClick(Sender: TObject);
    procedure compileFileMIClick(Sender: TObject);
    procedure projectTVKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure compilePackageMIClick(Sender: TObject);
    procedure runFileMIClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure HelpTSHide(Sender: TObject);
    procedure RunAppletMIClick(Sender: TObject);
    procedure debugFileMIClick(Sender: TObject);
    procedure debugAppletMIClick(Sender: TObject);
    procedure projectTVDblClick(Sender: TObject);
    procedure projectTVMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
  private
    mouseX:Integer;
    mouseY:Integer;
    function ComputeDockingRect(var DockRect: TRect; MousePos: TPoint): TAlign;
    procedure CMDockClient(var Message: TCMDockClient); message CM_DOCKCLIENT;
    procedure WMNCLButtonDblClk(var M:TWMNCLButtonDblClk);message WM_NCLBUTTONDBLCLK;
    //procedure readJDKapiHelp;
  public
    //
  end;

var
  MouseUpNode:TTreeNode;
  jdkHelpFromSrc:Boolean;

implementation

uses ideUnit;

{$R *.dfm}

procedure TWorkSpaceFrm.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  //将视图中的‘消息窗口’checked设置为false

  if (HostDockSite is TPanel) then
    IDEFrm.ShowDockPanel(HostDockSite as TPanel, False, nil);

  Action := caHide;

end;
procedure TWorkSpaceFrm.WMNCLButtonDblClk(var M:TWMNCLButtonDblClk);
begin
  //inherited ;
  //单击标题栏时，将消息对话框放入MsgPanel
  //if ideFrm.DockClientCount >= 1 then
    ManualDock(ideFrm.WorkSpacePanel, nil, alTop)
  //else
  //  ManualDock(ideFrm.WorkSpacePanel, nil, alBottom)

end;

procedure TWorkSpaceFrm.FormShow(Sender: TObject);
begin
  ideFrm.WorkSpaceMenuItem.Checked:=true;
end;

procedure TWorkSpaceFrm.FormHide(Sender: TObject);
begin
  ideFrm.WorkSpaceMenuItem.Checked:=false;
end;
procedure TWorkSpaceFrm.CMDockClient(var Message: TCMDockClient);
var
  ARect: TRect;
  DockType: TAlign;
  Pt: TPoint;
begin
  //Overriding this message allows the dock form to create host forms
  //depending on the mouse position when docking occurs. If we don't override
  //this message, the form will use VCL's default DockManager.

  //NOTE: the only time ManualDock can be safely called during a drag
  //operation is we override processing of CM_DOCKCLIENT.

  if Message.DockSource.Control is TClassBrowserFrm then
  begin

    //Find out how to dock (Using a TAlign as the result of ComputeDockingRect)
    Pt.x := Message.MousePos.x;
    Pt.y := Message.MousePos.y;
    DockType := ComputeDockingRect(ARect, Pt);

    //if we are over a dockable form docked to a panel in the
    //main window, manually dock the dragged form to the panel with
    //the correct orientation.
    if (HostDockSite is TPanel) then
    begin
      Message.DockSource.Control.ManualDock(HostDockSite, nil, DockType);
      Exit;
    end;

  end;
end;

function TWorkSpaceFrm.ComputeDockingRect(var DockRect: TRect; MousePos: TPoint): TAlign;
var
  DockTopRect,
  DockLeftRect,
  DockBottomRect,
  DockRightRect,
  DockCenterRect: TRect;
begin
  Result := alNone;
  //divide form up into docking "Zones"
  DockLeftRect.TopLeft := Point(0, 0);
  DockLeftRect.BottomRight := Point(ClientWidth div 5, ClientHeight);

  DockTopRect.TopLeft := Point(ClientWidth div 5, 0);
  DockTopRect.BottomRight := Point(ClientWidth div 5 * 4, ClientHeight div 5);

  DockRightRect.TopLeft := Point(ClientWidth div 5 * 4, 0);
  DockRightRect.BottomRight := Point(ClientWidth, ClientHeight);

  DockBottomRect.TopLeft := Point(ClientWidth div 5, ClientHeight div 5 * 4);
  DockBottomRect.BottomRight := Point(ClientWidth div 5 * 4, ClientHeight);

  DockCenterRect.TopLeft := Point(ClientWidth div 5, ClientHeight div 5);
  DockCenterRect.BottomRight := Point(ClientWidth div 5 * 4, ClientHeight div 5 * 4);

  //Find out where the mouse cursor is, to decide where to draw dock preview.
  if PtInRect(DockLeftRect, MousePos) then
    begin
      Result := alLeft;
      DockRect := DockLeftRect;
      DockRect.Right := ClientWidth div 2;
    end
  else
    if PtInRect(DockTopRect, MousePos) then
      begin
        Result := alTop;
        DockRect := DockTopRect;
        DockRect.Left := 0;
        DockRect.Right := ClientWidth;
        DockRect.Bottom := ClientHeight div 2;
      end
    else
      if PtInRect(DockRightRect, MousePos) then
        begin
          Result := alRight;
          DockRect := DockRightRect;
          DockRect.Left := ClientWidth div 2;
        end
      else
        if PtInRect(DockBottomRect, MousePos) then
          begin
            Result := alBottom;
            DockRect := DockBottomRect;
            DockRect.Left := 0;
            DockRect.Right := ClientWidth;
            DockRect.Top := ClientHeight div 2;
         end
        else
          if PtInRect(DockCenterRect, MousePos) then
          begin
            Result := alClient;
            DockRect := DockCenterRect;
          end;
  if Result = alNone then Exit;

  //DockRect is in screen coordinates.
  DockRect.TopLeft := ClientToScreen(DockRect.TopLeft);
  DockRect.BottomRight := ClientToScreen(DockRect.BottomRight);
end;

procedure TWorkSpaceFrm.FormDockOver(Sender: TObject;
  Source: TDragDockObject; X, Y: Integer; State: TDragState;
  var Accept: Boolean);
var
  ARect: TRect;
begin
  Accept := (Source.Control is TClassBrowserFrm);
  //Draw dock preview depending on where the cursor is relative to our client area
  if Accept and (ComputeDockingRect(ARect, Point(X, Y)) <> alNone) then
    Source.DockRect := ARect;
end;


procedure TWorkSpaceFrm.projectTVMouseUp(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var
  node:TTreeNode;
  point:TPoint;
begin

  if ( button = mbRight) then
  begin
    point.X:=x;point.y:=y;
    point := ScreenToClient(point);
    node:=projectTV.GetNodeAt(point.x,point.y);
    if Node = nil then
    begin
       exit;
    end;
    projectTV.Selected:=Node;
    if ( getNodeTag(node) = FILE_TAG ) then
    begin
      if  isJavaFile(TSubFile(node.data).name) then
      begin
        compileFileMI.Enabled:=true;
        if not FindAppointedString(getFileLatestContent(TSubFile(node.data)),
                    'class\s+'+TSubFile(node.data).getClassName+'\s+extends\s+(Applet|JApplet|java.applet.Applet|javax.swing.JApplet)\s*\{') then
        begin
          debugAppletMi.Enabled:=false;
          runAppletMI.Enabled:=false;
          //发送一个命令，测试是不是Applet类的子类
          if  ideFrm.G_PMList.AnalysisSocket <> nil then
          begin
            if TSubFile(node.data).package = '' then
              ideFrm.G_PMList.AnalysisSocket.SendText('!!'
                + TSubFile(node.data).getClassName + ';'
                + G_Project.Path
                + #13#10)
            else
              ideFrm.G_PMList.AnalysisSocket.SendText('!!'
                + TSubFile(node.data).package+'.'+TSubFile(node.data).getClassName + ';'
                + G_Project.Path
                + #13#10);
          end;
        end else
        begin
          debugAppletMi.Enabled:=true;
          runAppletMI.Enabled:=true;
        end;
      end
      else
      begin
        compileFileMI.Enabled:=false;
        debugAppletMi.Enabled:=false;
        runAppletMI.Enabled:=false;
      end;
      if not findMainMethod(TSubFile(node.Data)) then
      begin
        runFileMI.Enabled:=false;
        debugFileMI.Enabled:=false;
      end
      else
      begin
        runFileMI.Enabled:=true;
        debugFileMI.Enabled:=true;
      end;
      subfilePM.Popup(X,Y);
    end else if getNodeTag(node) = PACKAGE_TAG then
    begin
      packagePM.Popup(X,Y);
    end else if getNodeTag(node) = PROJECT_TAG then
    begin
      projectPM.Popup(X,Y);
    end;
  end;
end;

procedure TWorkSpaceFrm.actAddFileExecute(Sender: TObject);
begin
  if G_Project = nil then
  begin
    ShowError(getErrorMsg('ProjectNotExist'),0);
    exit;
  end;
  
  if workSpaceFrm.ProjectTV.Selected = nil then
  begin
    ShowError(getErrorMsg('PleaseSelectPackage'),0);
    exit;
  end;

  if TTag(workSpaceFrm.ProjectTV.Selected.data).tag = PROJECT_TAG then
  begin
    if dlgFileOpen.Execute then
    begin
      addFilesToProject(dlgFileOpen.Files,projectTV.Selected);
    end;
  end;

  if TTag(workSpaceFrm.ProjectTV.Selected.data).tag = PACKAGE_TAG then
  begin
    if dlgJavaOpenFile.Execute then
    begin
      addFilesToProject(dlgJavaOpenFile.Files,projectTV.Selected);
    end;
  end;

end;

procedure TWorkSpaceFrm.openFileMIClick(Sender: TObject);
begin
  ideFrm.DoOpenFile(getFileFromSubFile(TSubFile(projectTV.Selected.data)));
end;

procedure TWorkSpaceFrm.actAddFileUpdate(Sender: TObject);
begin
  actAddFile.Enabled:= ( ( G_Project <> nil)
                               and (workSpaceFrm.ProjectTV.Selected <> nil)
                                and ( ( TTag(ProjectTV.Selected.data).tag = PACKAGE_TAG ) or ( TTag(ProjectTV.Selected.data).tag = PROJECT_TAG ) ) );
end;

procedure TWorkSpaceFrm.ActRenameFileExecute(Sender: TObject);
var
  fileName,extName,oldFileName,newFileName:String;
  i,index:Integer;
  pack:TPackage;
  LEditor: IEditor;
  isJava:  Boolean;
begin
  if GetNodeTag(ProjectTV.Selected) = FILE_TAG then
  begin
    fileName:=TSubFile(projectTV.Selected.data).name;
    index:=Pos('.java',LowerCase(fileName));
    if index > 0 then
    begin
      extName := Copy(fileName,index+1,length(fileName));
      fileName := Copy(fileName,1,index-1);
      isJava := true;
    end else
      isJava := false;

    if InputQuery(getErrorMsg('InputQueryCaption'), getErrorMsg('PleaseInputFileName'), fileName) then
    begin
      fileName:=Trim(fileName);

      if isJava then
      begin
        //检测是否为合法的文件名
        if not IsValidFileName(fileName) then
        begin
           showError(getErrorMsg('InvalidFileName'));
           exit;
        end;
        fileName:=fileName+'.'+ extName;
      end else
      begin
        //检测是否为合法的文件名
        if not IsValidPackageName(fileName) then
        begin
           showError(getErrorMsg('InvalidFileName'));
           exit;
        end;
      end;


      if  TSubFile(projectTV.Selected.data).name = fileName then
        exit;
      if  TSubFile(projectTV.Selected.data).package = '' then
        pack:=G_Project.DefaultPackage
      else
        pack:=TPackage(TSubFile(projectTV.Selected.data).parentNode.data);
        
      for i:=0 to pack.fileList.Count-1 do
        if TSubFile(pack.fileList[i]).name = fileName then
        begin
          ShowError(getErrorMsg('FileExistInPackage'),0);
          exit;
        end;


      //移动文件
      oldFileName:=getFileFromSubFile(TSubFile(projectTV.Selected.data));
      TSubFile(projectTV.Selected.data).name:=fileName;
      newFileName:=getFileFromSubFile(TSubFile(projectTV.Selected.data));
      renameFile(Pchar(oldFileName),PChar(newFileName));

      //更新节点树
      projectTV.Selected.Text:=fileName;
      TSubFile(projectTV.Selected.Data).fileNode.ImageIndex:=getSubFileType(fileName)+1;
      TSubFile(projectTV.Selected.Data).fileNode.SelectedIndex:=getSubFileType(fileName)+1;
      //保存工程
      saveProject(G_Project);
      //如果该文件当前被打开，修改eidtor的filename
      for i:= GI_EditorFactory.GetEditorCount - 1 downto 0 do
      begin
        LEditor := GI_EditorFactory.Editor[i];
        if CompareText(LEditor.GetFileName, oldFileName) = 0 then
        begin
          LEditor.SetFileName(newFileName);
          ideFrm.filePageControl.Pages[i].Caption:=fileName;
          break;
        end;
      end;
    end;
  end;
end;

procedure TWorkSpaceFrm.ActRenameFileUpdate(Sender: TObject);
begin
  ActRenameFile.Enabled:= ( ( G_Project <> nil)
                               and (workSpaceFrm.ProjectTV.Selected <> nil)
                                and ( TTag(ProjectTV.Selected.data).tag = FILE_TAG )  );

end;

procedure TWorkSpaceFrm.actDeleteFileExecute(Sender: TObject);
var
  pack:TPackage;
  subFile:TSubFile;
  i,j:Integer;
  fileName:String;
  LEditor: IEditor;
begin
  if GetNodeTag(ProjectTV.Selected) = FILE_TAG then
  begin
    if ShowError(self.handle,getErrorMsg('ConfirmDeleteFile'),getErrorMsg('ConfirmCaption'),MB_OKCANCEL) = IDCANCEL then
       exit;
    subFile:=TSubFile(projectTV.Selected.Data);
    if subFile.package = '' then
      pack:=G_Project.DefaultPackage
    else
      pack:=TPackage(subFile.parentNode.Data);

    for i:=0 to pack.fileList.Count-1 do
    begin
        fileName := getFileFromSubFile(subFile);
        if TSubFile(pack.fileList[i]) = subFile then
        begin
          //从工程中，删除文件
          pack.fileList.Delete(i);
          //从文件目录中删除文件
          deleteFile(fileName);

          //如果当前已经打开了该文件，关闭editor
          for j:=0  to GI_EditorFactory.GetEditorCount - 1 do
          begin
            LEditor := GI_EditorFactory.Editor[j];
            if CompareText(LEditor.GetFileName,fileName) = 0 then
            begin
              LEditor.GetSynEditor.Modified:=false;
              LEditor.Close;
              break;
            end;
          end;
          subFile.fileNode.Delete;
          subFile.Free;

          //保存工程
          saveProject(G_Project);
          updateProjectTreeView(projectTV,false);
          break;
        end;
    end;
  end;
end;

procedure TWorkSpaceFrm.actDeleteFileUpdate(Sender: TObject);
begin
  actDeleteFile.Enabled:= ( ( G_Project <> nil)
                               and (workSpaceFrm.ProjectTV.Selected <> nil)
                                and ( TTag(ProjectTV.Selected.data).tag = FILE_TAG )  );

end;

procedure TWorkSpaceFrm.actMoveFileExecute(Sender: TObject);
var
  i:Integer;
  subfile:TSubFile;
  pack1,pack2:TPackage;
  LEditor: IEditor;
  oldFileName,newFileName:String;
begin
  pack1:=nil;
  if ( ( G_Project <> nil)
                               and (workSpaceFrm.ProjectTV.Selected <> nil)
                                and ( TTag(ProjectTV.Selected.data).tag = FILE_TAG )  ) then
  begin
    subfile:= TSubFile(ProjectTV.Selected.data);
    MoveFileForm.fileNameLbl.Caption := subfile.name;
    MoveFileForm.destPackComboBox.Items.Clear;
    for i:=0 to G_Project.packageList.Count-1 do
    begin
      if subfile.package <> TPackage(G_Project.packageList[i]).name then
        if TPackage(G_Project.packageList[i]).name= '' then
        begin
          MoveFileForm.destPackComboBox.items.AddObject('工程:'+G_Project.name,G_Project.defaultPackage);
        end
        else
        begin
          MoveFileForm.destPackComboBox.items.AddObject('包:'+TPackage(G_Project.packageList[i]).name,TPackage(G_Project.packageList[i]));
        end
      else
        pack1:=TPackage(G_Project.packageList[i]);
    end;
    if MoveFileForm.destPackComboBox.Items.Count > 0 then
       MoveFileForm.destPackComboBox.ItemIndex := 0
    else
    begin
       showError(getErrorMsg('CannotMoveTheFile'),0);
       exit;
    end;
    if MoveFileForm.ShowModal = mrOk then
    begin
      oldFileName:=getFileFromSubFile(subfile);

      //从原来的包内删除该文件
      pack1.deleteFile(subfile);
      subfile.fileNode.Delete;
      //在目标包内添加该文件
      pack2:=TPackage(MoveFileForm.destPackComboBox.items.Objects[MoveFileForm.destPackComboBox.ItemIndex]);
      pack2.fileList.Add(subfile);

      subfile.package := pack2.name;
      saveProject(G_Project);
      updateProjectTreeView(projectTV,false);
      //从物理上移动文件
      newFileName:=getFileFromSubFile(subfile);
      MoveFile(PChar(oldFileName),Pchar(newFileName));
      
      //如果当前已经打开了该文件，修改editor文件名
      for i:=0  to GI_EditorFactory.GetEditorCount - 1 do
      begin
        LEditor := GI_EditorFactory.Editor[i];
        if CompareText(LEditor.GetFileName,oldFileName) = 0 then
        begin
          LEditor.SetFileName(newFileName);
          break;
        end;
      end;
      changePackageName(newFileName,pack2.name);
    end;
  end;
end;

procedure TWorkSpaceFrm.actMoveFileUpdate(Sender: TObject);
begin
  actMoveFile.Enabled:= ( ( G_Project <> nil)
                               and (workSpaceFrm.ProjectTV.Selected <> nil)
                                and ( TTag(ProjectTV.Selected.data).tag = FILE_TAG )  );
end;

procedure TWorkSpaceFrm.debugProjectMIClick(Sender: TObject);
begin
  if G_Project.cfg.mainClassName='' then
  begin
    ShowError(getErrorMsg('PleaseSetupMainClass'),MB_OK or MB_ICONWARNING);
    ideFrm.actProjectPropertyExecute(nil);
  end;
end;

procedure TWorkSpaceFrm.compileFileMIClick(Sender: TObject);
begin
  if (( TTag(projectTV.Selected.Data).tag = FILE_TAG)
     and ( isJavaFile(TTag(projectTV.Selected.Data).name) ) ) then
      CompileJava(TSubFile(projectTV.Selected.Data),false);
end;

procedure TWorkSpaceFrm.projectTVKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key = VK_DELETE then
  begin
    if projectTV.Selected = nil then
      exit;
    if (TTag(projectTV.Selected.data).tag = FILE_TAG) then
    begin
      actDeleteFileExecute(nil);
    end;
    if (TTag(projectTV.Selected.data).tag = PACKAGE_TAG) then
    begin
      ideFrm.ActDeletePackageExecute(nil);
    end;

  end;
end;

procedure TWorkSpaceFrm.compilePackageMIClick(Sender: TObject);
var
  j,count:Integer;
  pack:TPackage;
  subFile:TSubFile;
  //fn:String;
begin
  count:=0;
  if TTag(ProjectTV.Selected.Data).tag <> PACKAGE_TAG then
    exit;

  if ShowError(getErrorMsg('CompileAllWarning'),MB_OKCANCEL or MB_ICONWARNING) <> IDOK then
    exit;


  pack:=TPackage(TPackage(ProjectTV.Selected.Data));
  for j:=0 to pack.fileList.Count-1 do
  begin
    subFile:=TSubFile(pack.fileList[j]);
    if isJavaFile(getFileFromSubFile(subFile)) then
    begin
      CompileJava(subFile,false);
      count:=count+1;
    end;
  end;

  if Count = 0 then
  begin
    ShowError(getErrorMsg('ProjectNoJavaFile'),MB_OK or MB_ICONWARNING);
  end;
end;
procedure TWorkSpaceFrm.runFileMIClick(Sender: TObject);
var
  subFile:TSubFile;
  fn,PackageName:String;
begin
  subFile:=TSubFile(projectTV.Selected.data);
  fn:=getFileFromSubFile(subFile);
  FindPackage(getFileLatestContent(subFile),packageName);
  if packageName <> subFile.package then
  begin
    if MessageBox(handle,PChar(Format(getErrorMsg('PackageNotMatch'),[ExtractFileName(fn),subFile.package,#13#10,packageName])),
                  PChar(getErrorMsg('ErrorDlgCaption')),
                  MB_OKCANCEL or MB_ICONWARNING) <> IDOK then
      exit;
  end;

  G_curApp.RunApp(subFile.getClassName,subFile.package,fn,false,false);
end;

procedure TWorkSpaceFrm.FormCreate(Sender: TObject);
begin
  jdkHelpFrm.JDKWebBrowser.Navigate('about:blank');
end;

procedure TWorkSpaceFrm.HelpTSHide(Sender: TObject);
begin
  jdkHelpFrm.Close;
end;

procedure TWorkSpaceFrm.RunAppletMIClick(Sender: TObject);
var
  subFile:TSubFile;
begin
  if ( ProjectTv.Selected = nil ) or (TTag(ProjectTv.Selected.Data).tag <> FILE_TAG) then
    exit;
  subFile:=TSubFile(ProjectTv.Selected.Data);

  G_curApp.RunApp(subFile.getClassName,subFile.package,getFileFromSubFile(subFile),true,true);
end;

procedure TWorkSpaceFrm.debugFileMIClick(Sender: TObject);
var
  subFile:TSubFile;
  fn,PackageName:String;
begin
  subFile:=TSubFile(projectTV.Selected.data);
  fn:=getFileFromSubFile(subFile);
  FindPackage(getFileLatestContent(subFile),packageName);
  if packageName <> subFile.package then
  begin
    if MessageBox(handle,PChar(Format(getErrorMsg('PackageNotMatch'),[ExtractFileName(fn),subFile.package,#13#10,packageName])),
                  PChar(getErrorMsg('ErrorDlgCaption')),
                  MB_OKCANCEL or MB_ICONWARNING) <> IDOK then
      exit;
  end;

  DebugApp(subFile.getClassName,subFile.package,fn,false);

end;

procedure TWorkSpaceFrm.debugAppletMIClick(Sender: TObject);
var
  subFile:TSubFile;
  fn,PackageName:String;
begin
  subFile:=TSubFile(projectTV.Selected.data);
  fn:=getFileFromSubFile(subFile);
  FindPackage(getFileLatestContent(subFile),packageName);
  if packageName <> subFile.package then
  begin
    if MessageBox(handle,PChar(Format(getErrorMsg('PackageNotMatch'),[ExtractFileName(fn),subFile.package,#13#10,packageName])),
                  PChar(getErrorMsg('ErrorDlgCaption')),
                  MB_OKCANCEL or MB_ICONWARNING) <> IDOK then
      exit;
  end;

  DebugApp(subFile.getClassName,subFile.package,fn,true);
end;

procedure TWorkSpaceFrm.projectTVDblClick(Sender: TObject);
var
  fileName:string;
begin
  fileName:=getFileFromNode(projectTV.selected);
  if htOnLabel in projectTV.GetHitTestInfoAt(mouseX,mouseY) then
  begin
    if getNodeTag(projectTV.Selected) = FILE_TAG then
    begin
      {if not fileExists(fileName) then
      begin
        ShowError(getErrorMsg('FileNotExist'),MB_OK);
        exit;
      end;}
      ideFrm.DoOpenFile(getFileFromSubFile(TSubFile(projectTV.Selected.data)));
    end;
  end;
end;

procedure TWorkSpaceFrm.projectTVMouseMove(Sender: TObject;
  Shift: TShiftState; X, Y: Integer);
begin
  mouseX:=X;
  mouseY:=Y;
end;

end.
