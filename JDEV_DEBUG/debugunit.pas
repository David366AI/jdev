unit debugunit;

interface

uses
  Windows, Messages, SysUtils,StrUtils, Classes, Graphics, Controls, Forms,
  Dialogs, Menus, ComCtrls, ToolWin, StdCtrls, ExtCtrls, ImgList,
  SynEditHighlighter, SynHighlighterJava, ScktComp, SynEditExt,DataInfo,ConstVar,
  XmlDoc,XMLIntf,setPath,changVarName,methodBp, SynEdit,StdActns,
  ActnList, dlgSearchText, dlgReplaceText, dlgConfirmReplace,frmEditor,uCommandData;

const
    ErrorDlgCaption='Error Infomation';
type
  TDebugForm = class(TForm)
    MainMenu: TMainMenu;
    N1: TMenuItem;
    N2: TMenuItem;
    N4: TMenuItem;
    N6: TMenuItem;
    terminateMenuItem: TMenuItem;
    N8: TMenuItem;
    N9: TMenuItem;
    MyToolBar: TToolBar;
    MyStatusBar: TStatusBar;
    AllImage: TImageList;
    Splitter1: TSplitter;
    PageControl: TPageControl;
    ConsoleTabSheet: TTabSheet;
    SourceTabSheet: TTabSheet;
    BreakpointTabSheet: TTabSheet;
    TreePanel: TPanel;
    LoadClassesTabSheet: TTabSheet;
    ConsoleInputGroupBox: TGroupBox;
    Splitter2: TSplitter;
    GroupBox2: TGroupBox;
    ConsoleInputMemo: TMemo;
    ConsoleOutputMemo: TMemo;
    VarWatchTabSheet: TTabSheet;
    ThreadListPanel: TPanel;
    Splitter3: TSplitter;
    Label1: TLabel;
    ThreadListTV: TTreeView;
    LocalsListPanel: TPanel;
    Label2: TLabel;
    Splitter4: TSplitter;
    Panel3: TPanel;
    Label3: TLabel;
    varTypeLabel: TLabel;
    Label5: TLabel;
    varValueMemo: TMemo;
    N10: TMenuItem;
    N11: TMenuItem;
    run1: TMenuItem;
    step1: TMenuItem;
    step2: TMenuItem;
    N12: TMenuItem;
    N13: TMenuItem;
    N14: TMenuItem;
    N15: TMenuItem;
    terminateAllAppMenuItem: TMenuItem;
    N17: TMenuItem;
    N20: TMenuItem;
    lineBpMenuItem: TMenuItem;
    methodBpMenuItem: TMenuItem;
    exceptionBpMenuItem: TMenuItem;
    N24: TMenuItem;
    U1: TMenuItem;
    A1: TMenuItem;
    N25: TMenuItem;
    N26: TMenuItem;
    N27: TMenuItem;
    N28: TMenuItem;
    N30: TMenuItem;
    N31: TMenuItem;
    IDE1: TMenuItem;
    N32: TMenuItem;
    BreakpointListTV: TTreeView;
    Label6: TLabel;
    classListBox: TListBox;
    watchVarLV: TListView;
    Label7: TLabel;
    N33: TMenuItem;
    setWatchVarMenuItem: TMenuItem;
    ToolButton1: TToolButton;
    exitBtn: TToolButton;
    stepoutBtn: TToolButton;
    stepBtn: TToolButton;
    breakBtn: TToolButton;
    ToolButton8: TToolButton;
    runBtn: TToolButton;
    suspendBtn: TToolButton;
    stepinBtn: TToolButton;
    ToolButton15: TToolButton;
    ToolButton16: TToolButton;
    ToolButton13: TToolButton;
    ToolButton14: TToolButton;
    ToolButton18: TToolButton;
    ToolButton2: TToolButton;
    sourceGroupBox: TGroupBox;
    N35: TMenuItem;
    CreateJavaMenuItem: TMenuItem;
    sourceEdit: TSynEditExt;
    SynJavaSyn: TSynJavaSyn;
    MessageTabSheet: TTabSheet;
    GroupBox3: TGroupBox;
    debugMsg: TMemo;
    LocalsListTV: TTreeView;
    N38: TMenuItem;
    appNodePopupMenu: TPopupMenu;
    setSourcePathItem: TMenuItem;
    watchVarPopupMenu: TPopupMenu;
    addWatchVarMenuItem: TMenuItem;
    N40: TMenuItem;
    N41: TMenuItem;
    N42: TMenuItem;
    N43: TMenuItem;
    N44: TMenuItem;
    bpPopupMenu: TPopupMenu;
    addBp: TMenuItem;
    delBp: TMenuItem;
    delAllBp: TMenuItem;
    N29: TMenuItem;
    N7: TMenuItem;
    startDebugServerMenuItem: TMenuItem;
    bpImagelist: TImageList;
    CommSocket: TServerSocket;
    threadImageList: TImageList;
    CreateAppletMenuItem: TMenuItem;
    SynEditorPopupMenu: TPopupMenu;
    ActionList: TActionList;
    EditCopy: TEditCopy;
    EditSelectAll: TEditSelectAll;
    Copy1: TMenuItem;
    SelectAll1: TMenuItem;
    FindFirst1: TMenuItem;
    SearchFind: TAction;
    SearchFindFirst: TAction;
    SearchFindNext: TAction;
    LineBpImageList: TImageList;
    N3: TMenuItem;
    stayOnTopBtn: TToolButton;
    N5: TMenuItem;
    Stayontop1: TMenuItem;
    procedure FormResize(Sender: TObject);
    procedure CreateJavaMenuItemClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure sourceEditGutterClick(Sender: TObject; X, Y, Line: Integer;
      mark: TSynEditMark);
    procedure FormDestroy(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure CommSocketConnect(Sender: TObject; Socket: TCustomWinSocket);
    procedure CommSocketRead(Sender: TObject; Socket: TCustomWinSocket);
    procedure stepinBtnClick(Sender: TObject);
    procedure stepBtnClick(Sender: TObject);
    procedure stepoutBtnClick(Sender: TObject);
    procedure runBtnClick(Sender: TObject);
    procedure suspendBtnClick(Sender: TObject);
    procedure exitBtnClick(Sender: TObject);
    procedure LocalsListTVChange(Sender: TObject; Node: TTreeNode);
    procedure LocalsListTVExpanding(Sender: TObject; Node: TTreeNode;
      var AllowExpansion: Boolean);
    procedure ThreadListTVChanging(Sender: TObject; Node: TTreeNode;
      var AllowChange: Boolean);
    procedure breakBtnClick(Sender: TObject);
    procedure LocalsListTVCustomDrawItem(Sender: TCustomTreeView;
      Node: TTreeNode; State: TCustomDrawState; var DefaultDraw: Boolean);
    procedure ThreadListTVCustomDrawItem(Sender: TCustomTreeView;
      Node: TTreeNode; State: TCustomDrawState; var DefaultDraw: Boolean);
    procedure LocalsListTVChanging(Sender: TObject; Node: TTreeNode;
      var AllowChange: Boolean);
    procedure LocalsListTVDeletion(Sender: TObject; Node: TTreeNode);
    procedure setSourcePathItemClick(Sender: TObject);
    procedure addWatchVarMenuItemClick(Sender: TObject);
    procedure N40Click(Sender: TObject);
    procedure N41Click(Sender: TObject);
    procedure N42Click(Sender: TObject);
    procedure N43Click(Sender: TObject);
    procedure ConsoleInputMemoKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure ConsoleInputMemoKeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure N44Click(Sender: TObject);
    procedure watchVarLVDblClick(Sender: TObject);
    procedure BreakpointListTVMouseDown(Sender: TObject;
      Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure addBpClick(Sender: TObject);
    procedure delBpClick(Sender: TObject);
    procedure delAllBpClick(Sender: TObject);
    procedure N26Click(Sender: TObject);
    procedure N27Click(Sender: TObject);
    procedure N28Click(Sender: TObject);
    procedure N30Click(Sender: TObject);
    procedure N31Click(Sender: TObject);
    procedure N29Click(Sender: TObject);
    procedure setWatchVarMenuItemClick(Sender: TObject);
    procedure terminateAllAppMenuItemClick(Sender: TObject);
    procedure terminateMenuItemClick(Sender: TObject);
    procedure methodBpMenuItemClick(Sender: TObject);
    procedure ToolButton8Click(Sender: TObject);
    procedure startDebugServerMenuItemClick(Sender: TObject);
    procedure CommSocketListen(Sender: TObject; Socket: TCustomWinSocket);
    procedure CommSocketAccept(Sender: TObject; Socket: TCustomWinSocket);
    procedure CommSocketClientDisconnect(Sender: TObject;
      Socket: TCustomWinSocket);
    procedure ConsoleTabSheetShow(Sender: TObject);
    procedure CreateAppletMenuItemClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure EditCopyExecute(Sender: TObject);
    procedure EditSelectAllExecute(Sender: TObject);
    procedure EditCopyUpdate(Sender: TObject);
    procedure IDE1Click(Sender: TObject);
    procedure EditSelectAllUpdate(Sender: TObject);
    procedure ShowSearchReplaceDialog(AReplace: boolean);
    procedure DoSearchReplaceText(AReplace: boolean;
      ABackwards: boolean);
    procedure SearchFindExecute(Sender: TObject);
    procedure SearchFindNextExecute(Sender: TObject);
    procedure SearchFindFirstExecute(Sender: TObject);
    procedure SearchFindFirstUpdate(Sender: TObject);
    procedure SearchFindUpdate(Sender: TObject);
    procedure SearchFindNextUpdate(Sender: TObject);
    procedure ThreadListTVChange(Sender: TObject; Node: TTreeNode);
    procedure FormHide(Sender: TObject);
    procedure exceptionBpMenuItemClick(Sender: TObject);
    procedure Stayontop1Click(Sender: TObject);
  private
    fIcon:TIcon;
    fSearchFromCaret: boolean;
  public
    { Public declarations }
  end;
var
  DebugForm: TDebugForm;

implementation
uses
  CreateApp,CreateApplet,Common,ideUnit;
{$R *.dfm}
resourcestring
  rs_NotSelectApplicaion='You do not select any application.' ;
  rs_CreateExceptionBP='Set Exception Breakpoint';
  rs_InputExceptoinClassName='Please input the exception''s class name';
  rs_InvalideJavaVariable='Invalide java variable name';
  rs_CreateWatchVariable='Add watching variable';
  rs_InputVariableName='Please input variable name:';
  rs_VariableHasExists='The variable has been existed.';
  rs_NoSelectedVariable='You do not select any variable';

procedure TDebugForm.FormResize(Sender: TObject);
begin
  BreakpointListTV.Width := Round(width / 3) ;
  ThreadListPanel.Width     := Round(width / 3) ;
  LocalsListPanel.Width     := Round(width / 3) ;
  ConsoleInputGroupBox.Width     := Round(width / 2) ;
  TreePanel.Height := Round(DebugForm.ClientHeight*(2/5));
  ConsoleInputGroupBox.Width := Round(width / 3) ;
  watchVarLV.Columns[0].Width:=80;
  watchVarLV.Columns[1].Width:=watchVarLV.Width-watchVarLV.Columns[1].Width-5;
end;

procedure TDebugForm.CreateJavaMenuItemClick(Sender: TObject);
var
  createAppdlg:TCreateAppDlg;
  linkParam:String;
begin
   {if not commSocket.Active then
   begin
     Application.MessageBox('调试控制中心尚未启动，不允许调试！','提示信息',0);
     exit;
   end;}

   createAppDlg :=TCreateAppDlg.Create(self,g_systemClassPath);
   if (createAppdlg.ShowModal = mrOK  ) then
   begin
    appParam.style:=1;
    appParam.className:=createAppdlg.ClassNameEdit.Text;
    appParam.parameters:=createAppdlg.parametersEdit.Text;
    appParam.address:=createAppdlg.portOrAddressEdit.Text;
    appParam.cp:=createAppdlg.classPathMemo.Text;
    appParam.initialPath:=createAppdlg.initalPathEdit.Text;
    appParam.isMainStop:=createAppdlg.mainStopChecked.Checked;
    appParam.link:=createAppdlg.link;
    if (createAppdlg.link = lmSocket)  then
       linkParam:='-connect com.sun.jdi.SocketListen:port='+appParam.address
    else
       linkParam:='-connect com.sun.jdi.SharedMemoryListen:name='+appParam.address ;
    //通知debug server center建立listen
    SendCommand(REQUEST_CREATE,'0',LinkParam);
   end;
   createAppDlg.Destroy;
end;

procedure TDebugForm.FormShow(Sender: TObject);
begin
  PageControl.ActivePageIndex:=1;
  SetWindowLong(Handle, GWL_EXSTYLE, WS_EX_APPWINDOW );
  ideFrm.debugWindowMI.Checked:=true;
end;

procedure TDebugForm.sourceEditGutterClick(Sender: TObject; X, Y,
  Line: Integer; mark: TSynEditMark);
begin
  setBreakpoint(line);
end;

procedure TDebugForm.FormDestroy(Sender: TObject);
begin
  if Assigned(fIcon) then
    fIcon.Free;
  FreeGlobalData;
end;

procedure TDebugForm.FormCreate(Sender: TObject);
begin
  fIcon:=TIcon.Create;
  if FileExists(g_exeFilePath+'debug.ico') then
    fIcon.LoadFromFile(g_exeFilePath+'debug.ico')
  else
    fIcon:=Application.Icon;
  icon:=fIcon;
  InitGlobalData;
  CommSocket.Port:=g_Debug_Server_Port;
  CommSocket.Active:=true;
  startDebugServer;
end;


procedure TDebugForm.CommSocketRead(Sender: TObject;
  Socket: TCustomWinSocket);
var
  command,pid,netPackage:WideString;
  pack,con,rs:WideString;
  posPack:Integer;
begin
  netPackage := socket.ReceiveText;
  if (pos('</JdevPackage>',netPackage) = 0 ) then //表示该包还没有结束，开始组装包
  begin
    g_netPackage := g_netPackage + netPackage;
    exit;
  end
  else
    g_netPackage := g_netPackage + netPackage;


  //解析包内容

  while ( pos('</JdevPackage>',g_netPackage) > 0) do
  begin
    posPack := Pos('</JdevPackage>',g_netPackage) ;
    pack := copy(g_netPackage,1,posPack-1+Length('</JdevPackage>'));
    g_netPackage := copy(g_netPackage,posPack+Length('</JdevPackage>'),Length(g_netPackage));
    try
      pack:=AnsiReplaceStr(pack,#12,'');
      parsePackage(pack,command,pid,rs,con);
      case StrToInt(command) of
          //表明建立帧听完毕，可以发出建立java进程的命令
          REPLY_VM_LISTEN :
                   if (rs='true') then
                      CreateApplication;
          //如果connection成功，发出run的命令
          REPLY_VM_CONNECT :
                                    ;
          REPLY_VM_START :
                   if (rs='true') then
                      BeginAppDebug;
          REPLY_VM_INTERRUPT :
                                    ;
          REPLY_VM_DISCONNECT :
                                    ;
          REPLY_VM_DEATH :
                                    ;
          REPLY_EXIT :
                                    ;
          REPLY_DEBUG :
                                    ;

          //线程增加
          REPLY_THREAD_ADD :
               addThread(pid,con);

          //线程消失
          REPLY_THREAD_DELETE :
               delThread(pid,con);

          //所有线程列表
          REPLY_THREAD_LIST :
               doAllThreads(pid,con);

          //resume线程
          REPLY_THREAD_RESUME :
               resumeReply(pid,con);
          //suspend线程
          REPLY_THREAD_SUSPEND :
               suspendReply(pid,con);
          //设置断点
          REPLY_SETBREAKPOINT:
               replySetBreakpoint(rs,pid,con);
          REPLY_CLEARBREAKPOINT:
               replyClearBreakpoint(rs,pid,con);
          //线程帧列表
          REPLY_THREAD_FRAMES:
               refreshThreadFrames(pid,con);
          //变量列表
          REPLY_FRAME_LOCALS:
          begin
              try
               refreshLocals(pid,con);
               //表明已经运行完毕，允许用户继续进行调试
              finally
               if findApp(pid) <> nil then
                 findApp(pid).status:= Ready;
              end;
          end;
          //子变量列表
          REPLY_LOCAL_DUMP:
          begin
               //gsh
               // addErrorMsg('get dump  net data',false);
               //g_isDumpingOrPrint := false;
               //localsListTV.Items.BeginUpdate;
               refreshLocalByDump(rs,con);
               //localsListTV.Items.EndUpdate;
          end;
          //批处理子变量列表
          REPLY_LOCAL_DUMPBATCH:
          begin
               refreshLocalByDumpBatch(con);
          end;
          //处理单个数组变量
          REPLY_LOCAL_PRINT:
          begin
               //g_isDumpingOrPrint := false;
               refreshSingleLocal(rs,con);
          end;
          REPLY_LOCAL_GETVALUE:
               refreshWatchVar(con);
          //类装载
          REPLY_CLASS_LOAD :
                 ;//debugMsg.Lines.Add('类装载：'+pack)            ;
          //类卸载
          REPLY_CLASS_UNLOAD :
                             ;
          REPLY_CLASS_LIST :
                refreshClassListBox(pid,con);
          //无法识别的命令
          else
             debugMsg.Lines.Add('can''t identify the reply command!') ;
      end;
    except
      ;
    end;
  end;
  g_netPackage := '';
end;

procedure TDebugForm.stepinBtnClick(Sender: TObject);
var
  app:TAppInfo;
begin
  if (   ThreadListTV.Selected <> nil)  then
  begin
    if TMyNode(ThreadListTV.Selected.data).level <> 3 then
    begin
      Beep;
      exit;
    end;
    app:=TAppInfo(ThreadListTV.Selected.Parent.Parent.Data);
    if (app.status = Ready) then   //如果服务器还没有反馈，不允许调试
    begin
       app.g_curThreadID:=TDebugThread(ThreadListTV.Selected.parent.data).threadID;
       app.g_curThreadFrameID:=TThreadFrame(ThreadListTV.Selected.data).id;
       SendCommand(REQUEST_DEBUG,app.appid,'step');
       app.status:=Waiting;
    end;
  end;
end;

procedure TDebugForm.stepBtnClick(Sender: TObject);
var
  app:TAppInfo;
  mythread:TDebugThread;
begin
  if (   ThreadListTV.Selected <> nil)  then
  begin
    if TMyNode(ThreadListTV.Selected.data).level <> 3 then
    begin
      Beep;
      exit;
    end;
    mythread:=TDebugThread(ThreadListTV.Selected.Parent.Data);
    app:=mythread.parent;
    //app:=TAppInfo(ThreadListTV.Selected.Parent.Parent.Data);
    if (app.status = Ready) then   //如果服务器还没有反馈，不允许调试
    begin
       SendCommand(REQUEST_DEBUG,app.appid,'next');
       app.status:=Waiting;
    end;
  end;
end;

procedure TDebugForm.stepoutBtnClick(Sender: TObject);
var
  app:TAppInfo;
begin
  if (   ThreadListTV.Selected <> nil)  then
  begin
    if TMyNode(ThreadListTV.Selected.data).level <> 3 then
    begin
      Beep;
      exit;
    end;
    app:=TAppInfo(ThreadListTV.Selected.Parent.Parent.Data);
    if (app.status = Ready) then   //如果服务器还没有反馈，不允许调试
    begin
       app.g_curThreadID:=TDebugThread(ThreadListTV.Selected.parent.data).threadID;
       app.g_curThreadFrameID:=TThreadFrame(ThreadListTV.Selected.data).id;
       SendCommand(REQUEST_DEBUG,app.appid,'step up');
       app.status:=Waiting;
    end;
  end;
end;

procedure TDebugForm.runBtnClick(Sender: TObject);
var
  app:TAppInfo;
begin
  if (   ThreadListTV.Selected <> nil)  then
  begin
    if TMyNode(ThreadListTV.Selected.data).level = 2 then
    begin
      SendCommand(REQUEST_DEBUG,getCurNodePID,'resume  '+ TDebugThread(ThreadListTV.Selected.data).threadID);
    end else if  TMyNode(ThreadListTV.Selected.data).level = 3 then
    begin
      app:=TAppInfo(ThreadListTV.Selected.Parent.Parent.Data);
      if (app.status = Ready) then   //如果服务器还没有反馈，不允许调试该程序
      begin
         app.g_curThreadID:=TDebugThread(ThreadListTV.Selected.parent.data).threadID;
         app.g_curThreadFrameID:=TThreadFrame(ThreadListTV.Selected.data).id;
         SendCommand(REQUEST_DEBUG,app.appid,'resume  '+ TDebugThread(ThreadListTV.Selected.parent.data).threadID);
         app.status:=Waiting;
      end;
    end  else if  TMyNode(ThreadListTV.Selected.data).level = 1 then
    begin
     Beep;
     Exit;
    end;
  end;
end;

procedure TDebugForm.suspendBtnClick(Sender: TObject);
begin
  if (   ThreadListTV.Selected <> nil)  then
  begin
    if TMyNode(ThreadListTV.Selected.data).level = 2 then//悬挂线程
    begin
      //if not TDebugThread(ThreadListTV.Selected.data).isSuspended then
        SendCommand(REQUEST_DEBUG,getCurNodePID,'suspend '+ TDebugThread(ThreadListTV.Selected.data).threadID)
      //else
      //  Application.MessageBox('该线程已经被挂起！','提示信息',0);
    end{ else
    if TMyNode(ThreadListTV.Selected.data).level = 1 then//悬挂应用，即所有线程
    begin
      SendCommand(REQUEST_DEBUG,getCurNodePID,'suspend ');
    end }else
    begin
      beep;
      exit;
    end;
  end;
end;

procedure TDebugForm.exitBtnClick(Sender: TObject);
begin
  if (   ThreadListTV.Selected <> nil)  then
  begin
    //if TMyNode(ThreadListTV.Selected.data).level = 1 then
        SendCommand(REQUEST_EXIT,getCurNodePID,'exit')
    {else if TMyNode(ThreadListTV.Selected.data).level = 2 then
        SendCommand(REQUEST_DEBUG,getCurNodePID,'kill');
    }
  end;
end;


procedure TDebugForm.LocalsListTVChange(Sender: TObject; Node: TTreeNode);
var
  local:TLocal;
begin
  if ( debugForm.LocalsListTV.Selected.data <> nil) then
  begin
    varTypeLabel.caption := TLocal(debugForm.LocalsListTV.Selected.data).varType;
    varValueMemo.Text := TLocal(debugForm.LocalsListTV.Selected.data).value;
  end
  else
  begin
    local:=TLocal.Create;
    local.name:=getTextByNode(Node);
    Node.Data := local;
    //g_isDumpingOrPrint :=true;
    SendCommand(REQUEST_DEBUG,getCurNodePID,'print '+ TLocal(Node.data).name +' '+TLocal(Node.Parent.data).varType+' select');
  end;

end;

procedure TDebugForm.LocalsListTVExpanding(Sender: TObject;
  Node: TTreeNode; var AllowExpansion: Boolean);
var
  childNode:TTreeNode;
  i:Integer;
  local:TLocal;
begin
  {if  g_isDumpingOrPrint then  //如果用户正在查询变量的子变量数据，那么不允许同时查询另外一个变量，退出本函数
  begin
    AllowExpansion := false;
    Beep;
    exit;
  end;
  }

  if (   ThreadListTV.Selected <> nil)  then
  begin
    if  node.Data = nil  then
    begin
      Node.DeleteChildren;
      local:=TLocal.Create;
      local.name:=getTextByNode(Node);
      Node.Data := local;
      //g_isDumpingOrPrint :=true;
      SendCommand(REQUEST_DEBUG,getCurNodePID,'print '+ local.name +' '+TLocal(Node.Parent.data).varType +' expand');
      exit;
    end;

    if not (TLocal(node.Data).hasRefresh) then
    begin

        //deleteChildrenData(Node);
        Node.DeleteChildren;

        if ( TLocal(Node.Data).isArray = 1 )  then
        begin
          //localsListTV.Items.BeginUpdate;
          for i:=0 to TLocal(Node.Data).arrayLength-1 do
          begin
            childNode:=localsListTV.Items.AddChild(Node,'['+ IntToStr(i) +']');
            if (TLocal(Node.Data).style = 1) then
              localsListTV.Items.AddChild(childNode,'1');
          end;
          TLocal(node.Data).hasRefresh := true;
          //localsListTV.Items.endUpdate;
        end else
        begin
          //g_isDumpingOrPrint := true;
          //gsh
          addErrorMsg('dump begin,send net data',false);
          SendCommand(REQUEST_DEBUG,getCurNodePID,'dump '+ TLocal(Node.data).name );
        end;
    end;
  end;
end;

procedure TDebugForm.breakBtnClick(Sender: TObject);
begin
    if ( sourceEdit.CaretY > 0 ) then
        setBreakpoint(sourceEdit.CaretY);
end;


procedure TDebugForm.ThreadListTVChanging(Sender: TObject; Node: TTreeNode;
  var AllowChange: Boolean);
var
  newSelectedFrame:TThreadFrame;
  newApp,oldApp:TAppInfo;
begin
 if Node = nil then
   exit;
 if g_CanNotChThreadNode then
 begin
   g_CanNotChThreadNode:=false;
   exit;
 end;

 //如果换了App
 newApp:=getAppByNode(node);
 oldApp := getCurApp;



 if ( newApp = nil ) then
 begin
   consoleInputMemo.text:='';
   consoleOutputMemo.text:='';
 end else  if (( oldApp = nil) or (newApp.appID <> oldApp.appID)) then
 begin
   consoleInputMemo.Lines.Assign(newApp.consoleInStrings);
   consoleOutputMemo.Lines.Assign(newApp.consoleOutStrings);
   classListBox.Items.Assign(newApp.loadedClassList);
   //断点列表
   UpdateJavaSourceBp(newApp,DebugForm.sourceEdit.packageName);
 end;


 if TMyNode(Node.data).level = 3 then  //更换帧节点
 begin
     {if  g_isDumpingOrPrint then  //如果用户正在查询变量的子变量数据，那么不允许更新节点，退出本函数
     begin
       AllowChange := false;
       exit;
     end; }
     newSelectedFrame:=getThreadFrameByNode(Node);
     if ( newSelectedFrame <> nil) then//如果改变了帧
     begin
       //刷新变量列表区，当前变量类型以及变量值
       //开始刷新
       //清空变量列表
       LocalsListTV.Items.clear;

       //刷新变量类型和变量值
       varTypeLabel.Caption := '';
       varValueMemo.Text :='';
       //通知刷新变量列表区
       SendCommand(REQUEST_DEBUG,TAppInfo(Node.parent.parent.Data).appID,'getFrameLocals ' + TDebugThread(Node.Parent.data).threadID + ' ' + IntToStr(Node.Index));
       //刷新源文件
     end;
 end
 else if TMyNode(Node.data).level = 2 then   //更换线程节点
 begin
     //通知改变当前线程
     SendCommand(REQUEST_DEBUG,TAppInfo(Node.parent.Data).appID,'thread ' + TDebugThread(Node.data).threadID);
     //清空所有的节点
     debugForm.localsListTV.Items.BeginUpdate;
     debugForm.LocalsListTV.Items.Clear;
     debugForm.localsListTV.Items.EndUpdate;
     debugForm.varTypeLabel.Caption:='';
     debugForm.varValueMemo.Text:='';
 end;

end;

procedure TDebugForm.LocalsListTVCustomDrawItem(Sender: TCustomTreeView;
  Node: TTreeNode; State: TCustomDrawState; var DefaultDraw: Boolean);
var
  NodeRect:TRect;
begin
   with LocalsListTV.Canvas do
   begin
     Font.size:=10;
     Font.Style:=[];
     if Node.Selected then
     begin
        Brush.Color := clblue;
        Font.Color:=clWhite;
        NodeRect := LocalsListTV.Selected.DisplayRect(true);
        FillRect(NodeRect);
        TextOut(NodeRect.left+2,NodeRect.top+1,LocalsListTV.Selected.Text) ;
     end;
   end;
end;

procedure TDebugForm.ThreadListTVCustomDrawItem(Sender: TCustomTreeView;
  Node: TTreeNode; State: TCustomDrawState; var DefaultDraw: Boolean);
var
  NodeRect:TRect;
begin
   with ThreadListTV.Canvas do
   begin
     Font.size:=10;
     Font.Style:=[];
     if Node.Selected then
     begin
        Brush.Color := clblue;
        Font.Color:=clWhite;
        NodeRect := ThreadListTV.Selected.DisplayRect(true);
        FillRect(NodeRect);
        TextOut(NodeRect.left+2,NodeRect.top+1,ThreadListTV.Selected.Text) ;
     end;
   end;
end;

procedure TDebugForm.LocalsListTVChanging(Sender: TObject; Node: TTreeNode;
  var AllowChange: Boolean);
begin
    //LocalsListTV.Repaint;
    //if g_isDumpingOrPrint then
    //  AllowChange:=false;
end;

procedure TDebugForm.LocalsListTVDeletion(Sender: TObject;
  Node: TTreeNode);
begin
   if Node.Data <> nil then
      TLocal(Node.data).Free;
end;
procedure TDebugForm.setSourcePathItemClick(Sender: TObject);
var
  app:TAppInfo;
begin
 app:= getCurApp;
 if app = nil then
   exit;
 setSourcePathDlg.appNameLbl.Caption := app.name;
 setSourcePathDlg.allPathListBox.Items := app.sourceFilePathList;
 setSourcePathDlg.allPathListBox.Items.Add(app.iniPath);
 if  setSourcePathDlg.ShowModal = mrOK then
   app.sourceFilePathList.Assign(setSourcePathDlg.allPathListBox.Items);
end;

procedure TDebugForm.addWatchVarMenuItemClick(Sender: TObject);
var
  inputStr:String;
  app:TAppInfo;
  ListItem: TListItem;
  i:Integer;
  finded:Boolean;
begin
  if (debugForm.ThreadListTV.Selected = nil) then
  begin
    ShowMessageBox(rs_NotSelectApplicaion,0);
    exit;
  end;
  app:=getCurApp;
  finded:=false;
  if InputQuery(rs_CreateWatchVariable,rs_InputVariableName,inputStr) then
  begin
      inputStr:=trim(inputStr);
      if not isLegalVar(inputStr) then
      begin
        ShowMessageBox(rs_InvalideJavaVariable,0);
        exit;
      end;

      for i:=0 to watchVarLV.Items.Count-1 do
       if watchVarLV.Items[i].Caption = trim(inputStr) then
       begin
         finded:=true;
         break;
       end;
      if not finded then
      begin
          ListItem:=watchVarLV.Items.Add;
          ListItem.Caption:=inputStr;
          ListItem.SubItems.Add('');

          //发送消息获取该变量的最新值
          SendCommand(REQUEST_DEBUG,app.appID,'getValue ' + inputStr);
      end
      else
      begin
         ShowMessageBox(rs_VariableHasExists,0);
      end;
  end;
end;

procedure TDebugForm.N40Click(Sender: TObject);
begin
  watchVarLV.DeleteSelected;
end;

procedure TDebugForm.N41Click(Sender: TObject);
begin
  watchVarLV.Items.Clear;
end;

procedure TDebugForm.N42Click(Sender: TObject);
begin
  if (debugForm.ThreadListTV.Selected = nil) then
  begin
    ShowMessageBox(rs_NotSelectApplicaion,0);
    exit;
  end;

  if (debugForm.watchVarLV.ItemIndex < 0) then
  begin
    ShowMessageBox(rs_NoSelectedVariable,0);
    exit;
  end;

  //发送消息获取该变量的最新值
  SendCommand(REQUEST_DEBUG,getCurApp.appID,'getValue ' +debugForm.watchVarLV.Selected.caption );
end;

procedure TDebugForm.N43Click(Sender: TObject);
var
 i:Integer;
 tempStr:String;
begin
  tempStr:='';

  if (debugForm.ThreadListTV.Selected = nil) then
  begin
    ShowMessageBox(rs_NotSelectApplicaion,0);
    exit;
  end;

  for i:=0 to  watchVarLV.Items.Count-1 do
   tempStr:=tempStr+' '+watchVarLV.Items[i].Caption;
  //发送消息获取该变量的最新值
  if tempStr <> '' then
    SendCommand(REQUEST_DEBUG,getCurApp.appID,'getValue ' + tempStr);
end;

procedure TDebugForm.ConsoleInputMemoKeyDown(Sender: TObject;
  var Key: Word; Shift: TShiftState);
var
  BytesRead:DWord;
  sendMsg,tempStr:String;
  Buffer: array[0..255] of char;
  i:Integer;
  app:TAppInfo;
begin
  { Place thread code here }
  if ( key = VK_RETURN ) then
  begin
          tempStr :=ConsoleInputMemo.Lines[ConsoleInputMemo.Lines.Count-1];
//          if ((tempStr<>'') and (tempStr[1]='>')) then
//          tempStr :=Copy(tempStr,2,Length(tempStr));
          sendMsg  := tempStr+#13#10;
          ConsoleInputMemo.SetFocus;
          app:= getCurApp;
          if app <> nil then
          begin
            fillchar(buffer,sizeof(buffer),0);
            for i:=0 to length(sendMsg)-1 do
            begin
                  buffer[i] := sendMsg[i+1];
            end;
            BytesRead := 0;

            WriteFile(app.WritePipeInput,buffer[0],length(sendMsg), BytesRead, nil);
            app.conSoleInStrings.Assign(ConsoleInputMemo.Lines);
          end;
  end;
  if key = VK_UP then
      key := 0;
  if ( key = VK_BACK ) and (ConsoleInputMemo.CaretPos.X = 0) then
      key := 0;
  
end;


procedure TDebugForm.ConsoleInputMemoKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
//        if key = VK_RETURN then
//          SendMessage(ConsoleInputMemo.Handle,WM_CHAR,ord('>'),0);

end;

procedure TDebugForm.N44Click(Sender: TObject);
var
  app:TAppInfo;
begin

  if (debugForm.watchVarLV.ItemIndex < 0) then
  begin
    ShowMessageBox(rs_NoSelectedVariable,0);
    exit;
  end;

  changeVarForm.varNameEdit.Text := watchVarLV.Selected.Caption;
  if changeVarForm.ShowModal = mrOK then
  begin
    if not isLegalVar(changeVarForm.varNameEdit.Text) then
    begin
      ShowMessageBox(rs_InvalideJavaVariable,0);
      exit;
    end;
    watchVarLV.Selected.Caption:= changeVarForm.varNameEdit.Text;
  end else exit;
  app:=getCurApp;
  if app = nil then
     watchVarLV.Selected.SubItems[0]:=VARNOTACCESS
  else
     //发送消息获取该变量的最新值
     SendCommand(REQUEST_DEBUG,app.appID,'getValue ' + changeVarForm.varNameEdit.Text );
  end;

procedure TDebugForm.watchVarLVDblClick(Sender: TObject);
var
  app:TAppInfo;
begin

  if (debugForm.watchVarLV.ItemIndex < 0) then
    exit;
  changeVarForm.varNameEdit.Text := watchVarLV.Selected.Caption;
  if changeVarForm.ShowModal = mrOK then
  begin
    if not isLegalVar(changeVarForm.varNameEdit.Text) then
    begin
      ShowMessageBox(rs_InvalideJavaVariable,0);
      exit;
    end;
    watchVarLV.Selected.Caption:= changeVarForm.varNameEdit.Text;
  end else exit;
  app:=getCurApp;
  if app = nil then
     watchVarLV.Selected.SubItems[0]:=VARNOTACCESS
  else
     //发送消息获取该变量的最新值
     SendCommand(REQUEST_DEBUG,app.appID,'getValue ' + changeVarForm.varNameEdit.Text );
end;


procedure TDebugForm.BreakpointListTVMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var
  clickNode:TTreeNode;
  pt:TPoint;
begin
  if button  = mbRight then
  begin
    clickNode:=breakpointListTV.GetNodeAt(x,y);
    if ClickNode <> nil then
    begin
      breakpointListTV.Selected:= clickNode;
      if clickNode.Level = 0 then
      begin
        bpPopupMenu.Items[1].Enabled:=false;
        if clickNode.Count = 0 then
          bpPopupMenu.Items[2].Enabled:=false
        else
          bpPopupMenu.Items[2].Enabled:=true;

        if clickNode.Text = LINEBPTEXT then
        begin
          bpPopupMenu.Items[0].Enabled:=false;
        end else if clickNode.Text = FUNCTIONBPTEXT then
        begin
          bpPopupMenu.Items[0].Enabled:=true;
        end else if clickNode.Text = EXCEPTIONBPTEXT then
        begin
          bpPopupMenu.Items[0].Enabled:=true;
        end;
      end else
      begin
        bpPopupMenu.Items[0].Enabled:=false;
        bpPopupMenu.Items[1].Enabled:=true;
        bpPopupMenu.Items[2].Enabled:=false;
      end;
      pt:=breakpointListTV.ClientToScreen(point(x,y));
      bpPopupMenu.Popup(pt.x,pt.y);
    end;
  end;
end;

procedure TDebugForm.addBpClick(Sender: TObject);
var
  app:TAppInfo;
  tempStr,command,inputStr:String;
  i:Integer;
begin
  app:=getCurApp;
  if app = nil then
  begin
     ShowMessageBox(rs_NotSelectApplicaion,0);
     exit;
  end;
  
  if BreakpointListTV.Selected.Text = FUNCTIONBPTEXT then
  begin
    if addMethodBpForm.ShowModal = mrOK then
    begin
     if trim(addMethodBpForm.packageEdit.text) = '' then
       command:='stopin ' + trim(addMethodBpForm.classEdit.text)
         + ' ' + addMethodBpForm.functionEdit.text
     else
       command:='stopin ' + trim(addMethodBpForm.packageEdit.text)+'.'+ trim(addMethodBpForm.classEdit.text)
         + ' ' + addMethodBpForm.functionEdit.text;

     for i:=0 to addMethodBpForm.paramListBox.Count-1 do
       tempStr:=tempStr+','+addMethodBpForm.paramListBox.Items[i];
     if Length(tempStr)>1 then
     begin
       tempStr[1]:='(';
       command:=command + tempStr +')';
     end;

     SendCommand(REQUEST_DEBUG,app.appID,command);
    end ;
  end else if BreakpointListTV.Selected.Text = EXCEPTIONBPTEXT then
  begin
    if InputQuery(rs_CreateExceptionBP,rs_InputExceptoinClassName,inputStr) then
    begin
      SendCommand(REQUEST_DEBUG,app.appID,'catch '+inputStr);
    end;
  end;
end;

procedure TDebugForm.delBpClick(Sender: TObject);
var
  command:String;
  app:TAppInfo;
begin
  app:=getCurApp;
  if app = nil then
  begin
     ShowMessageBox(rs_NotSelectApplicaion,0);
     exit;
  end;

  if BreakpointListTV.Selected.Data = nil then
  begin
    BreakpointListTV.Selected.Delete;
    exit;
  end;

  if  TBreakpoint(BreakpointListTV.Selected.Data).classType = LINEBREAKPOINT then
  begin
     command:='clear linebp '+TBreakpoint(BreakpointListTV.Selected.Data).id
              +' '+TBreakpoint(BreakpointListTV.Selected.Data).name
              +' '+TBreakpoint(BreakpointListTV.Selected.Data).addtional;
     SendCommand(REQUEST_DEBUG,app.appID,command);
  end else if  TBreakpoint(BreakpointListTV.Selected.Data).classType = METHODBREAKPOINT then
  begin
     command:='clear methodbp '+TBreakpoint(BreakpointListTV.Selected.Data).id
              +' '+TBreakpoint(BreakpointListTV.Selected.Data).name
              +' '+TBreakpoint(BreakpointListTV.Selected.Data).addtional;
     SendCommand(REQUEST_DEBUG,app.appID,command);
  end else if  TBreakpoint(BreakpointListTV.Selected.Data).classType = EXCEPTIONBREAKPOINT then
  begin
     command:='ignore  '+TBreakpoint(BreakpointListTV.Selected.Data).id
              +' '+TBreakpoint(BreakpointListTV.Selected.Data).name;
     SendCommand(REQUEST_DEBUG,app.appID,command);
  end;
end;

procedure TDebugForm.delAllBpClick(Sender: TObject);
var
  list:TStringList;
  i:Integer;
  app:TAppInfo;
begin
  app:=getCurApp;
  list:=TStringList.Create;
  if BreakpointListTV.Selected.Text = LINEBPTEXT then  //如果是清除所有的行断点
  begin
    for i:=0 to BreakpointListTV.Selected.Count-1 do
    begin
      list.Add('clear linebp '+TBreakpoint(BreakpointListTV.Selected.Item[i].data).id
              +' '+TBreakpoint(BreakpointListTV.Selected.Item[i].data).name
              +' '+TBreakpoint(BreakpointListTV.Selected.Item[i].data).addtional);
    end;
    SendCommand(REQUEST_DEBUG,app.appID,list);
  end else if BreakpointListTV.Selected.Text = FUNCTIONBPTEXT then  //如果是清除所有的函数断点
  begin
    for i:=0 to BreakpointListTV.Selected.Count-1 do
    begin
      list.Add('clear methodbp '+TBreakpoint(BreakpointListTV.Selected.Item[i].data).id
              +' '+TBreakpoint(BreakpointListTV.Selected.Item[i].data).name
              +' '+TBreakpoint(BreakpointListTV.Selected.Item[i].data).addtional);
    end;
    SendCommand(REQUEST_DEBUG,app.appID,list);
  end else if BreakpointListTV.Selected.Text = EXCEPTIONBPTEXT then  //如果是清除所有的异常断点
  begin
    for i:=0 to BreakpointListTV.Selected.Count-1 do
    begin
      list.Add('ignore '+TBreakpoint(BreakpointListTV.Selected.Item[i].data).id
              +' '+TBreakpoint(BreakpointListTV.Selected.Item[i].data).name);
    end;
    SendCommand(REQUEST_DEBUG,app.appID,list);
  end;

  list.Destroy;
end;

procedure TDebugForm.N26Click(Sender: TObject);
begin
  PageControl.ActivePageIndex:=0;
end;

procedure TDebugForm.N28Click(Sender: TObject);
begin
  PageControl.ActivePageIndex:=1;
end;

procedure TDebugForm.N27Click(Sender: TObject);
begin
  PageControl.ActivePageIndex:=2;

end;

procedure TDebugForm.N30Click(Sender: TObject);
begin
  PageControl.ActivePageIndex:=3;
end;

procedure TDebugForm.N31Click(Sender: TObject);
begin
  PageControl.ActivePageIndex:=4;

end;

procedure TDebugForm.N29Click(Sender: TObject);
begin
  PageControl.ActivePageIndex:=5;
end;

procedure TDebugForm.setWatchVarMenuItemClick(Sender: TObject);
begin
  PageControl.ActivePageIndex:=3;
  addWatchVarMenuItemClick(nil);
end;

procedure TDebugForm.terminateAllAppMenuItemClick(Sender: TObject);
begin
    SendCommand(REQUEST_EXIT,'0','exit');
end;

procedure TDebugForm.terminateMenuItemClick(Sender: TObject);
begin
  close;
end;

procedure TDebugForm.methodBpMenuItemClick(Sender: TObject);
var
  app:TAppInfo;
  command,tempStr:String;
  i:integer;
begin
    app:=getCurApp;
    if app = nil then
    begin
       ShowMessageBox(rs_NotSelectApplicaion,0);
       exit;
    end;
    //如果当前选择的断点为函数断点，则取消断点，否则添加断点
    if ( (breakpointListTV.Selected <> nil)
          and (breakpointListTV.Selected.Level = 1)
          and (breakpointListTV.Selected.Parent.Text = FUNCTIONBPTEXT ) ) then
    begin
       command:='clear methodbp '+TBreakpoint(BreakpointListTV.Selected.Data).id
                +' '+TBreakpoint(BreakpointListTV.Selected.Data).name
                +' '+TBreakpoint(BreakpointListTV.Selected.Data).addtional;
       SendCommand(REQUEST_DEBUG,app.appID,command);
    end else
    begin
      if addMethodBpForm.ShowModal = mrOK then
      begin
       if trim(addMethodBpForm.packageEdit.text) = '' then
         command:='stopin ' + trim(addMethodBpForm.classEdit.text)
           + ' ' + addMethodBpForm.functionEdit.text
       else
         command:='stopin ' + trim(addMethodBpForm.packageEdit.text)+'.'+ trim(addMethodBpForm.classEdit.text)
           + ' ' + addMethodBpForm.functionEdit.text;

       for i:=0 to addMethodBpForm.paramListBox.Count-1 do
         tempStr:=tempStr+','+addMethodBpForm.paramListBox.Items[i];
       if Length(tempStr)>1 then
       begin
         tempStr[1]:='(';
         command:=command + tempStr +')';
       end;

       SendCommand(REQUEST_DEBUG,app.appID,command);
      end ;
    end;
end;

procedure TDebugForm.ToolButton8Click(Sender: TObject);
begin
   setWatchVarMenuItemClick(nil);
end;

procedure TDebugForm.startDebugServerMenuItemClick(Sender: TObject);
begin
  startDebugServer;
end;

procedure TDebugForm.CommSocketListen(Sender: TObject;
  Socket: TCustomWinSocket);
begin
  addErrorMsg('begin to listen some one connected.',false);
end;

procedure TDebugForm.CommSocketAccept(Sender: TObject;
  Socket: TCustomWinSocket);
begin
  addErrorMsg('accept debug server connect.',false);
end;

procedure TDebugForm.CommSocketClientDisconnect(Sender: TObject;
  Socket: TCustomWinSocket);
begin
  g_debugServerSocket:=nil;
  MainMenu.Items[4].Items[0].Enabled:=false;
  MainMenu.Items[4].Items[1].Enabled:=false;
  MainMenu.Items[4].Items[4].Enabled:=true;
  addErrorMsg('debug server disconnect with debug center.',false);
end;

procedure TDebugForm.CommSocketConnect(Sender: TObject;
  Socket: TCustomWinSocket);
begin
  g_debugServerSocket:=Socket;
  MainMenu.Items[4].Items[0].Enabled:=true;
  MainMenu.Items[4].Items[1].Enabled:=true;
  MainMenu.Items[4].Items[4].Enabled:=false;
  addErrorMsg('debug server connect to debug center successfully.',false);
end;

procedure TDebugForm.ConsoleTabSheetShow(Sender: TObject);
begin
  ConsoleInputMemo.SetFocus;
end;

procedure TDebugForm.CreateAppletMenuItemClick(Sender: TObject);
var
  appletForm:TappletForm;
  linkParam:String;
  content:TStringList;
  appletParam:String;
  i:Integer;
begin
  appletForm:=TappletForm.create(self,g_SystemClassPath);
  if appletForm.ShowModal = mrOK then
  begin
    if appletForm.classCheck.Checked then //通过class启动
    begin
      content:=TStringList.Create;
      //gsh???
      content.LoadFromFile(g_templatePath + 'AppletTemplate.html');
      appletParam:='<applet code='+trim(appletForm.classNameEdit.Text)+' codebase=. width='+trim(appletForm.widthEdit.Text)
                   +' height='+trim(appletForm.heightEdit.Text);
      if appletForm.appletNameEdit.Text <> '' then
        appletParam:=appletParam+' name='+trim(appletForm.appletNameEdit.Text);
      if appletForm.useArchive.Checked  then
        appletParam:=appletParam+' archive='+trim(appletForm.archiveClassEdit.Text);
      appletParam:=appletParam + ' >';
      if appletForm.paramList.Strings.Count > 0  then
      begin
        for i:=0 to appletForm.paramList.Strings.Count-1 do
          if ((trim(appletForm.paramList.Strings.Names[i])<>'') and (trim(appletForm.paramList.Strings.Values[appletForm.paramList.Strings.Names[i]])<>'') ) then
            appletParam:=appletParam+ '<param name="'+appletForm.paramList.Strings.Names[i] +'" value="'+appletForm.paramList.Strings.Values[appletForm.paramList.Strings.Names[i]]+'">';
      end;
      appletParam:=appletParam +#13#10+'</applet>';
      content.text:=AnsiReplaceStr(content.text,'<APPLETNAME>',appletForm.classNameEdit.Text);
      content.text:=AnsiReplaceStr(content.text,'<APPLETCONFIG>',appletParam);
      appletForm.htmlEdit.text:=getDirByStr(appletForm.classPathEdit.Text)+appletForm.classNameEdit.Text+'.html';
      content.SaveToFile(appletForm.htmlEdit.text);
      content.Destroy;
    end;
    appParam.style:=2;
    appParam.className:='sun.applet.Main';
    appParam.appletClass:=appletForm.classNameEdit.Text;
    appParam.parameters:=ExtractFileName(appletForm.htmlEdit.Text);
    appParam.cp:=appletForm.classPathMemo.Text;
    appParam.initialPath:=ExtractFilePath(appletForm.htmlEdit.Text);
    appParam.isMainStop:=appletForm.isStopAtInit.Checked;
    appParam.address :=FormatDateTime('hhnnsszzz',now);
    appParam.link:=lmShmem;
//    appParam.address :='6666';
//    appParam.link:=socket;
    if (appParam.link = lmSocket)  then
      linkParam:='-connect com.sun.jdi.SocketListen:port='+appParam.address
    else
      linkParam:='-connect com.sun.jdi.SharedMemoryListen:name='+ appParam.address;
    //通知debug server center建立listen
    SendCommand(REQUEST_CREATE,'0',LinkParam);
  end;

  appletForm.Destroy;
end;

procedure TDebugForm.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  action:=caHide;
  SetWindowLong(Handle, GWL_EXSTYLE,
                      GetWindowLong(handle, GWL_EXSTYLE)
                         or WS_EX_TOOLWINDOW and not WS_EX_APPWINDOW);
end;

procedure TDebugForm.EditCopyExecute(Sender: TObject);
begin
  sourceEdit.CopyToClipboard;
end;

procedure TDebugForm.EditSelectAllExecute(Sender: TObject);
begin
  sourceEdit.SelectAll;
end;

procedure TDebugForm.EditCopyUpdate(Sender: TObject);
begin
  editCopy.Enabled:=sourceEdit.SelAvail;
end;

procedure TDebugForm.IDE1Click(Sender: TObject);
begin
    ShowWindow(ideFrm.Handle,SW_SHOW);
    BringWindowToTop( ideFrm.Handle );
    SetForegroundWindow( ideFrm.Handle );
end;

procedure TDebugForm.EditSelectAllUpdate(Sender: TObject);
begin
  EditSelectAll.Enabled := ( trim(sourceEdit.Lines.Text) <> '');
end;

procedure TDebugForm.ShowSearchReplaceDialog(AReplace: boolean);
var
  dlg: TTextSearchDialog;
begin
  if AReplace then
    dlg := TTextReplaceDialog.Create(Self)
  else
    dlg := TTextSearchDialog.Create(Self);
  with dlg do try
    // assign search options
    SearchBackwards := gbSearchBackwards;
    SearchCaseSensitive := gbSearchCaseSensitive;
    SearchFromCursor := gbSearchFromCaret;
    SearchInSelectionOnly := gbSearchSelectionOnly;
    // start with last search text
    SearchText := gsSearchText;
    if gbSearchTextAtCaret then begin
      // if something is selected search for that text
      if sourceEdit.SelAvail and (sourceEdit.BlockBegin.Y = sourceEdit.BlockEnd.Y)
      then
        SearchText := sourceEdit.SelText
      else
        SearchText := sourceEdit.GetWordAtRowCol(sourceEdit.CaretXY);
    end;
    SearchTextHistory := gsSearchTextHistory;
    if AReplace then with dlg as TTextReplaceDialog do begin
      ReplaceText := gsReplaceText;
      ReplaceTextHistory := gsReplaceTextHistory;
    end;
    SearchWholeWords := gbSearchWholeWords;
    if ShowModal = mrOK then begin
      gbSearchBackwards := SearchBackwards;
      gbSearchCaseSensitive := SearchCaseSensitive;
      gbSearchFromCaret := SearchFromCursor;
      gbSearchSelectionOnly := SearchInSelectionOnly;
      gbSearchWholeWords := SearchWholeWords;
      gsSearchText := SearchText;
      gsSearchTextHistory := SearchTextHistory;
      if AReplace then with dlg as TTextReplaceDialog do begin
        gsReplaceText := ReplaceText;
        gsReplaceTextHistory := ReplaceTextHistory;
      end;
      fSearchFromCaret := gbSearchFromCaret;
      if gsSearchText <> '' then begin
        DoSearchReplaceText(AReplace, gbSearchBackwards);
        fSearchFromCaret := TRUE;
      end;
    end;
  finally
    dlg.Free;
  end;
end;

procedure TDebugForm.DoSearchReplaceText(AReplace: boolean;
  ABackwards: boolean);
var
  Options: TSynSearchOptions;
begin
  if AReplace then
    Options := [ssoPrompt, ssoReplace, ssoReplaceAll]
  else
    Options := [];
  if ABackwards then
    Include(Options, ssoBackwards);
  if gbSearchCaseSensitive then
    Include(Options, ssoMatchCase);
  if not fSearchFromCaret then
    Include(Options, ssoEntireScope);
  if gbSearchSelectionOnly then
    Include(Options, ssoSelectedOnly);
  if gbSearchWholeWords then
    Include(Options, ssoWholeWord);
  if sourceEdit.SearchReplace(gsSearchText, gsReplaceText, Options) = 0 then
  begin
    MessageBeep(MB_ICONASTERISK);
    if ssoBackwards in Options then
      sourceEdit.BlockEnd := sourceEdit.BlockBegin
    else
      sourceEdit.BlockBegin := sourceEdit.BlockEnd;
    sourceEdit.CaretXY := sourceEdit.BlockBegin;
  end;

  if ConfirmReplaceDialog <> nil then
    ConfirmReplaceDialog.Free;
end;
procedure TDebugForm.SearchFindExecute(Sender: TObject);
begin
  ShowSearchReplaceDialog(FALSE);
end;

procedure TDebugForm.SearchFindNextExecute(Sender: TObject);
begin
  DoSearchReplaceText(FALSE, FALSE);
end;

procedure TDebugForm.SearchFindFirstExecute(Sender: TObject);
begin
  DoSearchReplaceText(FALSE, TRUE);
end;

procedure TDebugForm.SearchFindFirstUpdate(Sender: TObject);
begin
  SearchFindFirst.Enabled := ( trim(sourceEdit.Lines.Text) <> '');
end;

procedure TDebugForm.SearchFindUpdate(Sender: TObject);
begin
  SearchFind.Enabled := ( trim(sourceEdit.Lines.Text) <> '');
end;

procedure TDebugForm.SearchFindNextUpdate(Sender: TObject);
begin
  SearchFindNext.Enabled := ( trim(sourceEdit.Lines.Text) <> '');

end;

procedure TDebugForm.ThreadListTVChange(Sender: TObject; Node: TTreeNode);
var
  app:TAppInfo;
begin
  app:=getAppByNode(node);
  if app <> nil then
    app.lastSelNode:=DebugForm.ThreadListTV.Selected;
end;

procedure TDebugForm.FormHide(Sender: TObject);
begin
    ideFrm.debugWindowMI.Checked:=false;
end;

procedure TDebugForm.exceptionBpMenuItemClick(Sender: TObject);
var
  app:TAppInfo;
  command,inputStr:String;
begin
    app:=getCurApp;
    if app = nil then
    begin
       ShowMessageBox(rs_NotSelectApplicaion,0);
       exit;
    end;
    //如果当前选择的断点为函数断点，则取消断点，否则添加断点
    if ( (breakpointListTV.Selected <> nil)
          and (breakpointListTV.Selected.Level = 1)
          and (breakpointListTV.Selected.Parent.Text = EXCEPTIONBPTEXT ) ) then
    begin
      command:='ignore  '+TBreakpoint(BreakpointListTV.Selected.Data).id
              +' ' + TBreakpoint(BreakpointListTV.Selected.Data).name;
      SendCommand(REQUEST_DEBUG,app.appID,command);
    end else
    begin
      if InputQuery(rs_CreateExceptionBP,rs_InputExceptoinClassName,inputStr) then
      begin
        SendCommand(REQUEST_DEBUG,app.appID,'catch '+inputStr);
      end;
    end;
end;

procedure TDebugForm.Stayontop1Click(Sender: TObject);
begin
  if Stayontop1.Checked then
  begin
    self.FormStyle:=fsNormal;
    Stayontop1.Checked := false;
    stayOnTopBtn.Down := false;
  end else
  begin
    self.FormStyle:=fsStayOnTop;
    Stayontop1.Checked := true;
    stayOnTopBtn.Down := true;
  end;
end;

end.

