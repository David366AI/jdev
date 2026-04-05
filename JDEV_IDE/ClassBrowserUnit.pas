unit ClassBrowserUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ComCtrls,ExtCtrls, ImgList,classBrowser,uEditAppIntfs,SynEditExt,
  StdCtrls, Buttons, Menus,uCommandData, ToolWin, ActnList,createProperty,
  createMethod,RegExpr,StrUtils;

type
  TClassBrowserFrm = class(TForm)
    ClassBrowserTV: TTreeView;
    ToolBar1: TToolBar;
    addMethodBtn: TToolButton;
    addPropertyBtn: TToolButton;
    deleteClassBtn: TToolButton;
    deleteMethodBtn: TToolButton;
    deletePropertyBtn: TToolButton;
    ToolButton1: TToolButton;
    ToolButton2: TToolButton;
    ClassOpeImageList: TImageList;
    ClassOprActionList: TActionList;
    actRefresh: TAction;
    actAddMethod: TAction;
    actAddField: TAction;
    actDeleteMethod: TAction;
    ClassIDImageList: TImageList;
    procedure FormHide(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormDockOver(Sender: TObject; Source: TDragDockObject; X,
      Y: Integer; State: TDragState; var Accept: Boolean);
    procedure FormCreate(Sender: TObject);
    procedure ClassBrowserTVDblClick(Sender: TObject);
    procedure actRefreshExecute(Sender: TObject);
    procedure actRefreshUpdate(Sender: TObject);
    procedure actAddMethodUpdate(Sender: TObject);
    procedure actAddFieldUpdate(Sender: TObject);
    procedure actAddFieldExecute(Sender: TObject);
    procedure actDeleteMethodUpdate(Sender: TObject);
    procedure actAddMethodExecute(Sender: TObject);
    procedure actDeleteMethodExecute(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
  private
    function ComputeDockingRect(var DockRect: TRect; MousePos: TPoint): TAlign;
    procedure CMDockClient(var Message: TCMDockClient); message CM_DOCKCLIENT;
    procedure WMNCLButtonDblClk(var M:TWMNCLButtonDblClk);message WM_NCLBUTTONDBLCLK;
    function FindNextLeftKuohao(beginPos:Integer;s:String):Integer;
    function FindNextRightKuohao(beginPos:Integer;s:String):Integer;    
  public
    { Public declarations }
    
  end;


implementation
uses
  ideUnit,WorkSpaceUnit;
{$R *.dfm}

procedure TClassBrowserFrm.FormHide(Sender: TObject);
begin
  ideFrm.ClassBrowserMenuItem.Checked:=false;
end;

procedure TClassBrowserFrm.FormShow(Sender: TObject);
begin
  ideFrm.ClassBrowserMenuItem.Checked:=true;

end;

procedure TClassBrowserFrm.WMNCLButtonDblClk(var M:TWMNCLButtonDblClk);
begin
  //单击标题栏时，将消息对话框放入MsgPanel
  //if ideFrm.DockClientCount >= 1 then
    ManualDock(ideFrm.WorkSpacePanel, nil, alBottom)
  //else
  //  ManualDock(ideFrm.WorkSpacePanel, nil, alTop)
end;

procedure TClassBrowserFrm.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  //将视图中的‘消息窗口’checked设置为false

  if (HostDockSite is TPanel) then
    IDEFrm.ShowDockPanel(HostDockSite as TPanel, False, nil);

  Action := caHide;

end;

procedure TClassBrowserFrm.FormDockOver(Sender: TObject;
  Source: TDragDockObject; X, Y: Integer; State: TDragState;
  var Accept: Boolean);
var
  ARect: TRect;
begin
  Accept := (Source.Control is TWorkSpaceFrm);
  //Draw dock preview depending on where the cursor is relative to our client area
  if Accept and (ComputeDockingRect(ARect, Point(X, Y)) <> alNone) then
    Source.DockRect := ARect;
end;

procedure TClassBrowserFrm.CMDockClient(var Message: TCMDockClient);
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

  if Message.DockSource.Control is TWorkSpaceFrm then
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

function TClassBrowserFrm.ComputeDockingRect(var DockRect: TRect; MousePos: TPoint): TAlign;
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

procedure TClassBrowserFrm.FormCreate(Sender: TObject);
var
  tempdirs:array[0..255] of Char;
begin
  if not FileExists(g_exeFilePath + JAVAPARSER) then
  begin
    showError(getErrorMsg('JavaParserNotExist'),MB_OK or MB_ICONWARNING);
    exit;
  end;

  GetTempPath(sizeof(tempdirs),tempdirs);
  CopyFile(JAVAPARSER,PChar(GetRealPath(tempdirs)+'javalang.GMR'),false);
  try
    ideFrm.g_AnaysisPgmr.SetGrammar(GetRealPath(tempdirs)+'javalang.GMR');
  except
    ideFrm.g_AnaysisPgmr.Free;
    ideFrm.g_AnaysisPgmr := nil;
  end;
  g_CB :=TClassBrowser.Create(ideFrm.g_AnaysisPgmr,ClassBrowserTV,msgFrm.operatorMemo);
  g_CB.Priority:=tpIdle;
  g_CB.Resume;
end;

procedure TClassBrowserFrm.ClassBrowserTVDblClick(Sender: TObject);
var
  fSynEdit:TSynEditExt;
  p1,p2:TPoint;
begin
  if ((ClassBrowserTV.Selected <> nil ) and (ClassBrowserTV.Selected.data<>nil))then
  begin

    fSynEdit:=GI_EditorFactory.Editor[ideFrm.filePageControl.ActivePageIndex].GetSynEditor;
    p1:=G_CB.TranslateLongToPoint(TNodeData(ClassBrowserTV.Selected.data).StartPos);;

    p2:=G_CB.TranslateLongToPoint(TNodeData(ClassBrowserTV.Selected.data).StartPos
                                               + TNodeData(ClassBrowserTV.Selected.data).NumChars);

    if ( ( p1.y > fSynEdit.TopLine + fSynEdit.LinesInWindow )
        or (p1.y < fSynEdit.TopLine) ) then
       fSynEdit.TopLine:=p1.y;
    fSynEdit.SetFocus;
    fSynEdit.BlockBegin:=p1;
    fSynEdit.BlockEnd:= p2;
    fSynEdit.CaretXY := p2;
  end;
end;

procedure TClassBrowserFrm.actRefreshExecute(Sender: TObject);
begin
      if ideFrm.G_PMList.AnalysisSocket <> nil then
         ideFrm.G_PMList.AnalysisSocket.SendText('@@' + GI_EditorFactory.Editor[ideFrm.filePageControl.ActivePageIndex].GetFileName + #13#10)
      else if  (G_CB<>nil ) and ( ideFrm.filePageControl.PageCount > 0) then
         PostThreadMessage(G_CB.ThreadID,WM_CLASSBROWSER,Integer(GI_EditorFactory.Editor[ideFrm.filePageControl.ActivePageIndex]),0);
end;

procedure TClassBrowserFrm.actRefreshUpdate(Sender: TObject);
begin
  actRefresh.Enabled:= ( GI_EditorFactory.GetEditorCount >=1 )
                      and ( isJavaFile(GI_EditorFactory.Editor[ideFrm.filePageControl.ActivePageIndex].GetFileName) )
end;

procedure TClassBrowserFrm.actAddMethodUpdate(Sender: TObject);
begin
  actAddMethod.Enabled := (G_CB <> nil) and (ClassBrowserTV.Selected <> nil)
                          and (ClassBrowserTV.Selected.Data <> nil)
                         and  ( (TNodeData(ClassBrowserTV.Selected.Data).nodeType = CLASS_TYPE) or (TNodeData(ClassBrowserTV.Selected.Data).nodeType = INTERFACE_TYPE) )
end;

procedure TClassBrowserFrm.actAddFieldUpdate(Sender: TObject);
begin
  actAddField.Enabled := (G_CB <> nil) and (ClassBrowserTV.Selected <> nil)
                          and (ClassBrowserTV.Selected.Data <> nil)
                          and  ( (TNodeData(ClassBrowserTV.Selected.Data).nodeType = CLASS_TYPE) or (TNodeData(ClassBrowserTV.Selected.Data).nodeType = INTERFACE_TYPE) )
end;

function TClassBrowserFrm.FindNextLeftKuohao(beginPos:Integer;s:String):Integer;
var
  i:Integer;
begin
  s:=preCompile(s);
  result:=-1;
  for i:=beginPos to length(s) do
  begin
    if s[i] = '{' then
    begin
      result:=i;
      exit;
    end;
  end;
end;
function TClassBrowserFrm.FindNextRightKuohao(beginPos:Integer;s:String):Integer;
var
  i,count:Integer;
begin
  s:=preCompile(s);
  count:=0;
  result:=-1;
  for i:=beginPos to length(s) do
  begin
    if s[i] = '}' then
      count := count + 1;
    if s[i] = '{' then
      count := count - 1;
    if count > 0 then
    begin
      result:=i;
      exit;
    end;
  end;
end;

procedure TClassBrowserFrm.actAddFieldExecute(Sender: TObject);
var
  i,j,index1,index2,line:Integer;
  spaceStr:String;
  editor:IEditor;
  content:String;
  createPropertyForm: TcreatePropertyForm;
begin
  if ideFrm.filePageControl.PageCount > 0 then
  begin
    editor:=GI_EditorFactory.Editor[ideFrm.filePageControl.activePageIndex];
    content:=editor.GetFileContent;
    index1:=FindNextLeftKuohao(TNodeData(ClassBrowserTV.Selected.Data).StartPos,content);
    if index1 <= 0 then
      exit;
    for i:=index1+1 to length(content) do
    begin
      if not (content[i] in  SPACECHARLIST) then
      begin
        break;
      end;
    end;
    line:=editor.GetSynEditor.TranslateLongToPoint(i-1).y-1;
    spaceStr:='';
    for j:=1 to length(editor.GetSynEditor.Lines[line]) do
    begin
      if editor.GetSynEditor.Lines[line][j] = ' ' then
        spaceStr := spaceStr + ' '
      else
        break;
    end;
    createPropertyForm := TcreatePropertyForm.Create(self);
    if createPropertyForm.ShowModal <> mrOK then
      exit;

    for j:=1 to createPropertyForm.proStr.Count-1 do
    begin
      createPropertyForm.proStr[j] := spaceStr + createPropertyForm.proStr[j];
    end;

    editor.GetSynEditor.BeginUpdate;
    editor.GetSynEditor.CaretXY := editor.GetSynEditor.TranslateLongToPoint(i-1);
    editor.GetSynEditor.BlockBegin := editor.GetSynEditor.TranslateLongToPoint(i-1);
    editor.GetSynEditor.BlockEnd := editor.GetSynEditor.TranslateLongToPoint(i-1);

    editor.GetSynEditor.SelText := createPropertyForm.proStr.text + spaceStr;

    //add method
    if createPropertyForm.methodStr.Count > 0 then
    begin
      content:=preCompile(editor.GetFileContent);
      index2:=FindNextRightKuohao(index1+1,content);
      line:=editor.GetSynEditor.TranslateLongToPoint(index2).Y-1;
      for j:=line-1 downto 0 do
      begin
        if trim(editor.GetSynEditor.lines[j]) <> '' then
        begin
          break;
        end;
      end;
      line:=j;
      spaceStr:='';
      for j:=1 to length(editor.GetSynEditor.Lines[line]) do
      begin
        if editor.GetSynEditor.Lines[line][j] = ' ' then
          spaceStr := spaceStr + ' '
        else
          break;
      end;
      for j:=0 to createPropertyForm.methodStr.Count-1 do
        createPropertyForm.methodStr[j]:=spaceStr + createPropertyForm.methodStr[j];

      editor.GetSynEditor.CaretXY := editor.GetSynEditor.TranslateLongToPoint(index2-1);
      editor.GetSynEditor.BlockBegin := editor.GetSynEditor.TranslateLongToPoint(index2-1);
      editor.GetSynEditor.BlockEnd := editor.GetSynEditor.TranslateLongToPoint(index2-1);
      editor.GetSynEditor.SelText :=createPropertyForm.methodStr.Text;
    end;
    editor.GetSynEditor.EndUpdate;

    createPropertyForm.Free;
    
    if G_CB <> nil then
         PostThreadMessage(G_CB.ThreadID,WM_CLASSBROWSER,Integer(editor),0);
  end;
end;
procedure TClassBrowserFrm.actDeleteMethodUpdate(Sender: TObject);
begin
  actDeleteMethod.Enabled := (G_CB <> nil) and (ClassBrowserTV.Selected <> nil)
                          and (ClassBrowserTV.Selected.Data <> nil)
                           and (  (TNodeData(ClassBrowserTV.Selected.Data).nodeType = METHOD_TYPE)
                                  or (TNodeData(ClassBrowserTV.Selected.Data).nodeType = CONSTRUCTOR_TYPE) )
end;

procedure TClassBrowserFrm.actAddMethodExecute(Sender: TObject);
var
  cmf:TcreateMethodForm;
  editor:IEditor;
  content,spaceStr:String;
  index1,index2,j,line:Integer;
begin
  if ideFrm.filePageControl.PageCount <= 0 then
    exit;

  cmf:=TcreateMethodForm.create(self);
  cmf.className:=ClassBrowserTV.Selected.Text;
  if cmf.ShowModal <> mrOK then
    exit;

  editor:=GI_EditorFactory.Editor[ideFrm.filePageControl.activePageIndex];

  editor.GetSynEditor.BeginUpdate;
  content:=preCompile(editor.GetFileContent);
  index1:=FindNextLeftKuohao(TNodeData(ClassBrowserTV.Selected.Data).StartPos,content);
  index2:=FindNextRightKuohao( index1 + 1,content);
  line:=editor.GetSynEditor.TranslateLongToPoint(index2).Y-1;
  for j:=line-1 downto 0 do
  begin
    if trim(editor.GetSynEditor.lines[j]) <> '' then
    begin
      break;
    end;
  end;
  line:=j;
  spaceStr:='';
  for j:=1 to length(editor.GetSynEditor.Lines[line]) do
  begin
    if editor.GetSynEditor.Lines[line][j] = ' ' then
      spaceStr := spaceStr + ' '
    else
      break;
  end;
  for j:=0 to cmf.methodStr.Count-1 do
    cmf.methodStr[j]:=spaceStr + cmf.methodStr[j];

  editor.GetSynEditor.CaretXY := editor.GetSynEditor.TranslateLongToPoint(index2-1);
  editor.GetSynEditor.BlockBegin := editor.GetSynEditor.TranslateLongToPoint(index2-1);
  editor.GetSynEditor.BlockEnd := editor.GetSynEditor.TranslateLongToPoint(index2-1);
  editor.GetSynEditor.SelText := cmf.methodStr.Text;

  editor.GetSynEditor.EndUpdate;
  cmf.Free;
  
  if G_CB <> nil then
       PostThreadMessage(G_CB.ThreadID,WM_CLASSBROWSER,Integer(editor),0);

end;

procedure TClassBrowserFrm.actDeleteMethodExecute(Sender: TObject);
var
  editor:IEditor;
  methodStr:TStringList;
  tempStr,content:String;
  i,index1,index2:Integer;
  regExr :TRegExpr;
begin
  if ideFrm.filePageControl.PageCount <= 0 then
    exit;
  editor:=GI_EditorFactory.Editor[ideFrm.filePageControl.activePageIndex];

  if ClassBrowserTV.Selected.Data = nil then
    exit;

  methodStr:=TStringList.Create;
  methodStr.Delimiter:=' ';
  methodStr.DelimitedText := ClassBrowserTV.Selected.Text;
  if methodStr.Count <= 0 then
    exit;
  tempStr:=methodStr[0];
  for i:=1 to methodStr.Count-1 do
  begin
    tempStr:=tempStr+'\s+' + methodStr[i];
  end;
  methodStr.Free;
  tempStr:=AnsiReplaceStr(tempStr,'(','\(');
  tempStr:=AnsiReplaceStr(tempStr,')','\)');
  tempStr:=AnsiReplaceStr(tempStr,'[','\[');
  tempStr:=AnsiReplaceStr(tempStr,']','\]');
  tempStr:=AnsiReplaceStr(tempStr,'.','\.');
  tempStr:=AnsiReplaceStr(tempStr,'-','\-');
  tempStr:=AnsiReplaceStr(tempStr,'$','\$');
  regExr := TRegExpr.create;
  regExr.Expression:='(!!\s*(\*/)?\s*)?' + tempStr;
  regExr.Compile;
  content:=preCompileStr(editor.GetFileContent);
  if regExr.Exec(content) then
  begin
    if ShowError(self.Handle,Format(getErrorMsg('DeleteMethodConfirm'),[ClassBrowserTV.Selected.Text]),getErrorMsg('ConfirmCaption'),MB_OKCANCEL or MB_ICONWARNING) <> IDOK then
    begin
      if regExr <> nil then
        regExr.Free;
      exit;
    end;
    index1:=FindNextLeftKuohao(regExr.MatchPos[0],content);
    index2:=FindNextRightKuohao( index1 + 1,content);
    editor.GetSynEditor.BeginUpdate;

    editor.GetSynEditor.CaretXY:=editor.GetSynEditor.TranslateLongToPoint(regExr.MatchPos[0]-1);
    editor.GetSynEditor.BlockBegin := editor.GetSynEditor.CaretXY;
    editor.GetSynEditor.BlockEnd := editor.GetSynEditor.TranslateLongToPoint(index2);
    editor.GetSynEditor.SelText:='';
    editor.GetSynEditor.EndUpdate;

    if G_CB <> nil then
         PostThreadMessage(G_CB.ThreadID,WM_CLASSBROWSER,Integer(editor),0);
    regExr.free;
  end else
  begin
    if ShowError(self.Handle,getErrorMsg('CannotFindMethod'),getErrorMsg('ConfirmCaption'),MB_OKCANCEL or MB_ICONWARNING) = IDOK then
    begin
      if G_CB <> nil then
           PostThreadMessage(G_CB.ThreadID,WM_CLASSBROWSER,Integer(editor),0);
    end else
      exit;
  end;
end;

procedure TClassBrowserFrm.FormDestroy(Sender: TObject);
var
  i:Integer;
begin
  for i:=0 to  ClassBrowserTV.Items.Count - 1 do
  begin
    if ClassBrowserTV.Items[i].data <> nil then
    begin
       TNodeData(ClassBrowserTV.Items[i].data).Free;
       ClassBrowserTV.Items[i].data:= nil;
    end;
  end;
end;

end.
