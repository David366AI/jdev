unit ideUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes,ComObj,ShellAPI, Graphics, Controls,
  Forms,Dialogs, Commctrl,ComCtrls, ImgList, ActnList, ExtCtrls, ToolWin, Menus,
  uCommandData,SynEdit,Contnrs,  SynEditExt,MsgUnit, WorkSpaceUnit,ClassBrowserUnit,
  StdCtrls, StdActns,ActnMan, SynEditHighlighter, SynHighlighterJava, AdvancedPanel,
  SynHighlighterHTML,PGMRX120Lib_TLB,selectFileTypeDlg,uEditAppIntfs,IniFiles,projectProperty,
  OleServer,classBrowser,SynEditTypes, Buttons,SynEditPrint,ChkList, ScktComp,frmEditor,StrUtils,
  DataInfo,jdkhelpUnit,splashUnit,versionUnit,importProjectUnit,progressUnit,RegExpr,
  ConstVar,debugunit,EnvUnit,registerUnit, HCMngr, RzPanel,
  RzSplit;

const
  MaxAnalysisNumber   =  30;
  MaxSaveFileSize     =  2500;
  MaxDebugApplication = 2;

  SHOWJDKHELP = 9;
  HIDEJDKHELP = 10;
type
  TIDEFrm = class(TForm)
    CoolBar: TCoolBar;
    CommonToolBar: TToolBar;
    CommonExtToolBar: TToolBar;
    MsgPanel: TPanel;
    HSplitter: TSplitter;
    WorkSpacePanel: TPanel;
    VSplitter: TSplitter;
    mainPanel: TPanel;
    ToolButton1: TToolButton;
    ToolButton2: TToolButton;
    ToolButton3: TToolButton;
    ToolButton4: TToolButton;
    ToolButton5: TToolButton;
    ToolButton6: TToolButton;
    ToolButton7: TToolButton;
    MenuToolBarImageList: TImageList;
    ToolButton8: TToolButton;
    ToolButton9: TToolButton;
    ToolButton10: TToolButton;
    ToolButton11: TToolButton;
    ToolButton12: TToolButton;
    ToolButton13: TToolButton;
    ToolButton14: TToolButton;
    ToolButton15: TToolButton;
    ToolButton16: TToolButton;
    ToolButton17: TToolButton;
    findBtn: TToolButton;
    ToolButton19: TToolButton;
    ToolButton20: TToolButton;
    findReplaceBtn: TToolButton;
    findEdit: TEdit;
    ToolButton22: TToolButton;
    ToolButton23: TToolButton;
    windows1TB: TToolButton;
    windows2TB: TToolButton;
    windows3TB: TToolButton;
    windows4TB: TToolButton;
    ToolButton29: TToolButton;
    ToolButton30: TToolButton;
    ToolButton31: TToolButton;
    ToolButton32: TToolButton;
    ToolButton28: TToolButton;
    ToolButton33: TToolButton;
    ToolButton34: TToolButton;
    BookmarkBtn: TToolButton;
    goToBookmarkBtn: TToolButton;
    ToolButton38: TToolButton;
    ToolButton42: TToolButton;
    ToolButton40: TToolButton;
    ToolButton41: TToolButton;
    ToolButton37: TToolButton;
    ToolButton39: TToolButton;
    openProjectDlg: TOpenDialog;
    FileTypeImageList: TImageList;
    ToolButton24: TToolButton;
    MainMenu: TMainMenu;
    FileMenuItem: TMenuItem;
    newFileItem: TMenuItem;
    openFileMI: TMenuItem;
    saveFileMI: TMenuItem;
    saveFileAsMI: TMenuItem;
    saveAllMI: TMenuItem;
    mailFileToMI: TMenuItem;
    closeFileMI: TMenuItem;
    closeAllFileMI: TMenuItem;
    N20: TMenuItem;
    newProjectMI: TMenuItem;
    openProjectMI: TMenuItem;
    saveProjectMI: TMenuItem;
    closeProjectMI: TMenuItem;
    N25: TMenuItem;
    printSetupMI: TMenuItem;
    printMI: TMenuItem;
    N28: TMenuItem;
    recentFileMI: TMenuItem;
    recentProjectMI: TMenuItem;
    N31: TMenuItem;
    exitAppMI: TMenuItem;
    Edit1: TMenuItem;
    UndoMI: TMenuItem;
    RepeatMI: TMenuItem;
    N11: TMenuItem;
    CutMI: TMenuItem;
    CopyMI: TMenuItem;
    PasteMI: TMenuItem;
    N10: TMenuItem;
    FindMI: TMenuItem;
    Replace1: TMenuItem;
    indentMI: TMenuItem;
    disIndentMI: TMenuItem;
    formatMI: TMenuItem;
    searchTopMI: TMenuItem;
    findStringMI: TMenuItem;
    findNextMI: TMenuItem;
    findPreviousMI: TMenuItem;
    findReplaceMI: TMenuItem;
    N13: TMenuItem;
    findInProjectMI: TMenuItem;
    findReplaceInProMI: TMenuItem;
    N16: TMenuItem;
    toggleBookMarkMI: TMenuItem;
    BookmarkMI1: TMenuItem;
    BookmarkMI2: TMenuItem;
    BookmarkMI3: TMenuItem;
    BookmarkMI4: TMenuItem;
    BookmarkMI5: TMenuItem;
    BookmarkMI6: TMenuItem;
    BookmarkMI7: TMenuItem;
    BookmarkMI8: TMenuItem;
    BookmarkMI9: TMenuItem;
    BookmarkMI10: TMenuItem;
    gotoBookMarkMI: TMenuItem;
    goBookMark1: TMenuItem;
    N110: TMenuItem;
    N111: TMenuItem;
    N112: TMenuItem;
    N113: TMenuItem;
    N114: TMenuItem;
    N115: TMenuItem;
    N116: TMenuItem;
    N117: TMenuItem;
    N118: TMenuItem;
    removeAllBookMarkMI: TMenuItem;
    viewTop: TMenuItem;
    commonToolBarMI: TMenuItem;
    commonExtToolbarMI: TMenuItem;
    N26: TMenuItem;
    WorkSpaceMenuItem: TMenuItem;
    ClassBrowserMenuItem: TMenuItem;
    MsgMenuItem: TMenuItem;
    FindResultMenuItem: TMenuItem;
    N29: TMenuItem;
    debugWindowMI: TMenuItem;
    projectMI: TMenuItem;
    addPackageMI: TMenuItem;
    renamePackageMI: TMenuItem;
    deletePackageMI: TMenuItem;
    N45: TMenuItem;
    addFilesMI: TMenuItem;
    deleteFilesMI: TMenuItem;
    N38: TMenuItem;
    projectPropertiesMI: TMenuItem;
    runTopMI: TMenuItem;
    compileMI: TMenuItem;
    compileAllMI: TMenuItem;
    runMI: TMenuItem;
    debugMI: TMenuItem;
    toggleBreakpointMI: TMenuItem;
    clearAllBreakpointMI: TMenuItem;
    N8: TMenuItem;
    configurationMI: TMenuItem;
    buildJarMI: TMenuItem;
    windowsMI: TMenuItem;
    helpMI: TMenuItem;
    AboutMI: TMenuItem;
    jdevIDEHelpMI: TMenuItem;
    jdevDebugMI: TMenuItem;
    registerMI: TMenuItem;
    orderingMI: TMenuItem;
    StatusBar: TStatusBar;
    actlStandard: TActionList;
    actFileCloseAll: TAction;
    actUpdateStatusBarPanels: TAction;
    actFileSaveAll: TAction;
    sendMailTo: TAction;
    miFileMRU1: TMenuItem;
    miFileMRU2: TMenuItem;
    miFileMRU3: TMenuItem;
    miFileMRU4: TMenuItem;
    miFileMRU5: TMenuItem;
    miFileMRU7: TMenuItem;
    miFileMRU6: TMenuItem;
    miFileMRU8: TMenuItem;
    N1: TMenuItem;
    N2: TMenuItem;
    actSaveProject: TAction;
    actCloseProject: TAction;
    pagePopupMenu: TPopupMenu;
    N3: TMenuItem;
    g_AnaysisPgmr: TPgmr;
    N4: TMenuItem;
    runPopupMI: TMenuItem;
    compilePopupMI: TMenuItem;
    debugRunPopupMI: TMenuItem;
    ToolButton25: TToolButton;
    recentProjectMRU1: TMenuItem;
    recentProjectMRU2: TMenuItem;
    recentProjectMRU3: TMenuItem;
    recentProjectMRU4: TMenuItem;
    SelectComboBox: TComboBox;
    ToolButton26: TToolButton;
    selectModeMI: TMenuItem;
    N12: TMenuItem;
    N14: TMenuItem;
    N15: TMenuItem;
    BookMarkPM: TPopupMenu;
    N17: TMenuItem;
    N18: TMenuItem;
    N19: TMenuItem;
    N119: TMenuItem;
    N120: TMenuItem;
    N121: TMenuItem;
    N122: TMenuItem;
    N123: TMenuItem;
    N124: TMenuItem;
    N125: TMenuItem;
    actBookmark: TAction;
    actGotoBookmark: TAction;
    gotoBookmarkPM: TPopupMenu;
    MenuItem1: TMenuItem;
    MenuItem2: TMenuItem;
    MenuItem3: TMenuItem;
    MenuItem4: TMenuItem;
    MenuItem5: TMenuItem;
    MenuItem6: TMenuItem;
    MenuItem7: TMenuItem;
    MenuItem8: TMenuItem;
    MenuItem9: TMenuItem;
    MenuItem10: TMenuItem;
    actFormat: TAction;
    deCompilerMI: TMenuItem;
    ClassOpenDialog: TOpenDialog;
    N126: TMenuItem;
    actAnalysisClass: TAction;
    analysisClassSocket: TServerSocket;
    ToolButton27: TToolButton;
    actIndent: TAction;
    actDesIndent: TAction;
    ActAddPackage: TAction;
    actRenamePackage: TAction;
    ActDeletePackage: TAction;
    N9: TMenuItem;
    N21: TMenuItem;
    N22: TMenuItem;
    N23: TMenuItem;
    actSearchInProject: TAction;
    actReplaceInProject: TAction;
    actProjectProperty: TAction;
    actCompileJavaFile: TAction;
    actCompileAllJavaFile: TAction;
    actSetupBp: TAction;
    ToolButton35: TToolButton;
    actClearBp: TAction;
    actDebugProject: TAction;
    actRunProject: TAction;
    actTerminate: TAction;
    runAppletMI: TMenuItem;
    debugAppletMI: TMenuItem;
    actVersion: TAction;
    actGenerateJar: TAction;
    actImportProject: TAction;
    N5: TMenuItem;
    actStartupAnalysisServer: TAction;
    N6: TMenuItem;
    N7: TMenuItem;
    N24: TMenuItem;
    SupportMI: TMenuItem;
    sunJDKhelp: TMenuItem;
    actFindApointText: TAction;
    checkLicenseTimer: TTimer;
    CipherManager: TCipherManager;
    unregisterPanel: TAdvancedPanel;
    registerLbl: TLabel;
    bugReportMI: TMenuItem;
    packageListBox: TListBox;
    G_PMList: TCheckList;
    jdkHelpPanel: TRzSizePanel;
    filePageControl: TPageControl;
    jdkApiTV: TTreeView;
    ToolBar1: TToolBar;
    showJDKHelpBtn: TToolButton;
    findClassBtn: TToolButton;
    jdkLabel: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure MsgPanelDockOver(Sender: TObject; Source: TDragDockObject; X,
      Y: Integer; State: TDragState; var Accept: Boolean);
    procedure MsgPanelUnDock(Sender: TObject; Client: TControl;
      NewTarget: TWinControl; var Allow: Boolean);
    procedure MsgPanelGetSiteInfo(Sender: TObject; DockClient: TControl;
      var InfluenceRect: TRect; MousePos: TPoint; var CanDock: Boolean);
    procedure MsgMenuItemClick(Sender: TObject);
    procedure MsgPanelDockDrop(Sender: TObject; Source: TDragDockObject; X,
      Y: Integer);
    procedure WorkSpacePanelDockDrop(Sender: TObject;
      Source: TDragDockObject; X, Y: Integer);
    procedure WorkSpacePanelDockOver(Sender: TObject;
      Source: TDragDockObject; X, Y: Integer; State: TDragState;
      var Accept: Boolean);
    procedure WorkSpacePanelGetSiteInfo(Sender: TObject;
      DockClient: TControl; var InfluenceRect: TRect; MousePos: TPoint;
      var CanDock: Boolean);
    procedure WorkSpacePanelUnDock(Sender: TObject; Client: TControl;
      NewTarget: TWinControl; var Allow: Boolean);
    procedure WorkSpaceMenuItemClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure ClassBrowserMenuItemClick(Sender: TObject);
    procedure exitAppMIClick(Sender: TObject);
    procedure commonToolBarMIClick(Sender: TObject);
    procedure commonExtToolbarMIClick(Sender: TObject);
    procedure windows1TBClick(Sender: TObject);
    procedure windows2TBClick(Sender: TObject);
    procedure windows3TBClick(Sender: TObject);
    procedure windows4TBClick(Sender: TObject);
    procedure openProjectMIClick(Sender: TObject);
    procedure newFileItemClick(Sender: TObject);
    procedure openFileMIClick(Sender: TObject);
    procedure newProjectMIClick(Sender: TObject);
    procedure FilePageControlChange(Sender: TObject);
    procedure actFileCloseAllExecute(Sender: TObject);
    procedure actFileCloseAllUpdate(Sender: TObject);
    procedure actUpdateStatusBarPanelsUpdate(Sender: TObject);
    procedure actFileSaveAllExecute(Sender: TObject);
    procedure sendMailToExecute(Sender: TObject);
    procedure sendMailToUpdate(Sender: TObject);
    procedure miFileMRUClick(Sender: TObject);
    procedure recentFileMIClick(Sender: TObject);
    procedure saveProjectMIClick(Sender: TObject);
    procedure actSaveProjectExecute(Sender: TObject);
    procedure actSaveProjectUpdate(Sender: TObject);
    procedure actCloseProjectExecute(Sender: TObject);
    procedure actCloseProjectUpdate(Sender: TObject);
    procedure filePageControlMouseDown(Sender: TObject;
      Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure BookmarkMI1Click(Sender: TObject);
    procedure goBookMark1Click(Sender: TObject);
    procedure removeAllBookMarkMIClick(Sender: TObject);
    procedure recentProjectMIClick(Sender: TObject);
    procedure recentProjectMRU1Click(Sender: TObject);
    procedure Label1Click(Sender: TObject);
    procedure SelectComboBoxChange(Sender: TObject);
    procedure N15Click(Sender: TObject);
    procedure actBookmarkExecute(Sender: TObject);
    procedure actBookmarkUpdate(Sender: TObject);
    procedure actGotoBookmarkExecute(Sender: TObject);
    procedure actGotoBookmarkUpdate(Sender: TObject);
    procedure actFormatExecute(Sender: TObject);
    procedure actFormatUpdate(Sender: TObject);
    procedure deCompilerMIClick(Sender: TObject);
    procedure actAnalysisClassExecute(Sender: TObject);
    procedure analysisClassSocketClientConnect(Sender: TObject;
      Socket: TCustomWinSocket);
    procedure analysisClassSocketClientDisconnect(Sender: TObject;
      Socket: TCustomWinSocket);
    procedure analysisClassSocketClientRead(Sender: TObject;
      Socket: TCustomWinSocket);
    procedure FormResize(Sender: TObject);
    procedure actIndentExecute(Sender: TObject);
    procedure actDesIndentExecute(Sender: TObject);
    procedure actIndentUpdate(Sender: TObject);
    procedure actDesIndentUpdate(Sender: TObject);
    procedure ActAddPackageExecute(Sender: TObject);
    procedure ActAddPackageUpdate(Sender: TObject);
    procedure actRenamePackageExecute(Sender: TObject);
    procedure actRenamePackageUpdate(Sender: TObject);
    procedure ActDeletePackageUpdate(Sender: TObject);
    procedure ActDeletePackageExecute(Sender: TObject);
    procedure actSearchInProjectUpdate(Sender: TObject);
    procedure actSearchInProjectExecute(Sender: TObject);
    procedure actReplaceInProjectUpdate(Sender: TObject);
    procedure actReplaceInProjectExecute(Sender: TObject);
    procedure actProjectPropertyExecute(Sender: TObject);
    procedure actProjectPropertyUpdate(Sender: TObject);
    procedure actCompileJavaFileUpdate(Sender: TObject);
    procedure actCompileJavaFileExecute(Sender: TObject);
    procedure pagePopupMenuPopup(Sender: TObject);
    procedure actCompileAllJavaFileExecute(Sender: TObject);
    procedure actCompileAllJavaFileUpdate(Sender: TObject);
    procedure actSetupBpUpdate(Sender: TObject);
    procedure actClearBpExecute(Sender: TObject);
    procedure actClearBpUpdate(Sender: TObject);
    procedure actDebugProjectExecute(Sender: TObject);
    procedure runPopupMIClick(Sender: TObject);
    procedure actRunProjectUpdate(Sender: TObject);
    procedure actRunProjectExecute(Sender: TObject);
    procedure actTerminateUpdate(Sender: TObject);
    procedure actTerminateExecute(Sender: TObject);
    procedure analysisClassSocketClientError(Sender: TObject;
      Socket: TCustomWinSocket; ErrorEvent: TErrorEvent;
      var ErrorCode: Integer);
    procedure actVersionUpdate(Sender: TObject);
    procedure actVersionExecute(Sender: TObject);
    procedure actGenerateJarExecute(Sender: TObject);
    procedure actGenerateJarUpdate(Sender: TObject);
    procedure actImportProjectExecute(Sender: TObject);
    procedure actStartupAnalysisServerUpdate(Sender: TObject);
    procedure actStartupAnalysisServerExecute(Sender: TObject);
    procedure actSetupBpExecute(Sender: TObject);
    procedure debugRunPopupMIClick(Sender: TObject);
    procedure actDebugProjectUpdate(Sender: TObject);
    procedure debugWindowMIClick(Sender: TObject);
    procedure configurationMIClick(Sender: TObject);
    procedure AboutMIClick(Sender: TObject);
    procedure SupportMIClick(Sender: TObject);
    procedure ToolButton39Click(Sender: TObject);
    procedure actFindApointTextExecute(Sender: TObject);
    procedure actFindApointTextUpdate(Sender: TObject);
    procedure checkLicenseTimerTimer(Sender: TObject);
    procedure registerMIClick(Sender: TObject);
    procedure bugReportMIClick(Sender: TObject);
    procedure packageListBoxDblClick(Sender: TObject);
    procedure packageListBoxClick(Sender: TObject);
    procedure packageListBoxKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure findClassBtnClick(Sender: TObject);
    procedure showJDKHelpBtnClick(Sender: TObject);
    procedure jdkApiTVCustomDrawItem(Sender: TCustomTreeView;
      Node: TTreeNode; State: TCustomDrawState; var DefaultDraw: Boolean);
    procedure jdkApiTVDblClick(Sender: TObject);
    procedure jdkApiTVExpanded(Sender: TObject; Node: TTreeNode);
    procedure jdkApiTVMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure jdkHelpPanelHotSpotClick(Sender: TObject);
    procedure sunJDKhelpClick(Sender: TObject);
    procedure jdkHelpPanelResize(Sender: TObject);
    procedure orderingMIClick(Sender: TObject);
  private
    mouseX:Integer;
    mouseY:Integer;
    procedure WindowClickEvent(Sender: TObject);
    procedure WMRegister(var Msg: TMessage); message WM_REGISTER_LICENSE;
    procedure TabMenuPopup(APageControl: TPageControl;button:TMouseButton; X, Y: Integer);
  protected
    fMRUItems: array[1..8] of TMenuItem;
    fProjectMRUItems: array[1..4] of TMenuItem;
  public
    procedure checkFileValid;
    procedure ShowDockPanel(APanel: TPanel; MakeVisible: Boolean; Client: TControl);
    procedure WMCopyData(var Msg: TMessage);Message WM_COPYDATA;

    procedure DropFiles(var Msg:TMessage);message WM_DROPFILES;

    procedure DoOpenFile(AFileName: string;index:Integer;pack:String);overload;
    procedure DoOpenFile(AFileName: string);overload;
    function DoCreateEditor(AFileName: string;index:Integer): IEditor; virtual;
    function CanCloseAll: boolean;
    procedure ReadIniSettings;
    procedure WriteIniSettings;
    procedure OpenProject(fileName:String);
    procedure setSelectMode(index:Integer);
    function DoFormat(fileContent:TStrings):Boolean;
    procedure doDeCompile(fileName:String);
    procedure AppMessage(var Msg: TMsg; var Handled: Boolean);
    procedure OnDeactivate(Sender: TObject);
    function CloseProject:Boolean;
  end;

var
  IDEFrm: TIDEFrm;
  msgFrm: TMsgFrm;
  g_RegForm:TRegForm;
  workSpaceFrm: TWorkSpaceFrm;
  classBrowserFrm: TClassBrowserFrm;
  newFileFrm: TnewFileFrm;
  jdkHelpFrm: TjdkHelpFrm;
  generateJarFrm: TgenerateJarFrm;
  importProjectFrm: TimportProjectFrm;
  versionFrm: TgenerateJarFrm;

  ErrorMsgList:TStringList;
  G_curAPP:TRunAppInfo;
  G_Project:TProject;

  g_jdkHelpRegr:String;
  g_socket_live:Boolean;
  g_poplistNumber:Integer;
  g_Security: TSecurityAttributes;
  g_exeFilePath:String;
  g_IDEFilePath:String;
  g_versionDataPath:String;
  g_debugServerPath:String;
  g_tempFilePath:String;
  g_projectFilePath:String;
  g_backupFilePath:String;
  g_pluginFilePath:String;
  g_templatePath:String;
  g_helpFilePath:String;
  g_jdkdocpath:String;
  g_servletdocpath:String;
  g_jspdocpath:String;
  g_javaHome:String;
  g_java:String;
  g_javaw:String;
  g_javac:String;
  g_javaJar:String;

  g_analysis_server_port:Integer;
  g_debug_server_port:Integer;

  g_SystemClassPath:PChar;
  g_JarComment:String;
  g_IDE_ClassPath:String;
  g_IDE_SourcePath:String;
  g_jdk_zipsrc_path:String;

  g_analysisProcessInfo : TProcessInformation;
  g_analysisPackage: WideString;
  g_CB:TClassBrowser;
  g_CancelSave:Boolean;

  G_VersionType:Integer;
  g_filesize:Integer;
  g_status:String;
  g_domain_web_site:String;

  g_packageList:TStrings;
  g_dotPosition:Integer;
implementation

uses
  dmCommands,dlgSearchText,dlgReplaceText,dlgConfirmReplace,Encrypt,
  aboutUnit;
  
{$R *.dfm}
procedure TIDEFrm.WMCopyData(var Msg: TMessage);
var
  fileName:String;
begin
  if PCopyDataStruct(Msg.LParam)^.dwData = WM_JDEV_OPENFILE_MSG then
  begin
    fileName:=PChar(PCopyDataStruct(Msg.LParam)^.lpData);
    if fileName <> '' then
    begin
      if Pos('.jdp',ExtractFileName(fileName)) > 0 then
      begin
        if ((G_Project <> nil) and (fileName = (G_Project.Path+ G_Project.filename)) )then
          exit;

        //CloseAllFile;
        G_Project:=LoadProjectFromFile(fileName);
        updateProjectTreeView(workSpaceFrm.projectTV,false);
      end else
      begin
         DoOpenFile(fileName);
      end;
    end;
    //DoOpenFile(PChar(PCopyDataStruct(Msg.LParam)^.lpData));
  end;
end;

procedure TIDEFrm.FormCreate(Sender: TObject);
var
  index:Integer;
  s:String;
  startupFlag:Boolean;
begin

  //checkFileValid;
  visible:=false;
  g_exeFilePath := GetRealPath(ExtractFilePath(application.ExeName));

  g_filesize := GetFileSize(application.ExeName);

  //装载错误信息列表
  ErrorMsgList:=TStringList.Create;
  try
    ErrorMsgList.LoadFromFile(g_exeFilePath+'MsgCfg');
  except
    MessageBox(handle,'Can''t find the config file, the application will halt','Fatal Error',MB_OK or MB_ICONWARNING);
    halt;
  end;

  if not fileexists(g_exeFilePath+CONFIGFILE) then
  begin
    MessageBox(handle,'Can''t find file jdev.ini, the application will halt','Fatal Error',MB_OK or MB_ICONWARNING);
    halt;
  end;
  g_RegForm:=TRegForm.Create(nil);
  InitCheckLicense;

  with g_Security do
  begin
    nlength := SizeOf(TSecurityAttributes);
    binherithandle := true;
    lpsecuritydescriptor := nil;
  end;

  //检查java jdk是否安装以及jdk的版本
  IniJavaEnvironment;

  index:=LastDelimiter('\',g_exeFilePath);
  s := Copy(g_exeFilePath,1,index-1);
  index:=LastDelimiter('\',s);
  g_IDEFilePath := Copy(g_exeFilePath,1,index);
  g_debugServerPath := g_exeFilePath + DEBUGSERVERCENTER;
  g_versionDataPath := g_IDEFilePath + VERSIONDATADIR;
  g_tempFilePath := g_IDEFilePath + TEMPDIR;
  g_projectFilePath := g_IDEFilePath + PROJECTDIR;
  g_backupFilePath := g_IDEFilePath + BACKUPDIR;
  g_helpFilePath := g_IDEFilePath + HELPDIR;

  g_templatePath := g_IDEFilePath + TEMPLATE;
  g_pluginFilePath := g_IDEFilePath + PLUGINDIR;
  G_curAPP:=TRunAppInfo.create;
  g_packageList := TStringList.Create;

  //创建edit 命令模块

  CommandsDataModule := TCommandsDataModule.Create(Self);
  commandDataDM := TCommandDataDM.Create(Self);
  generateJarFrm:=TgenerateJarFrm.Create(nil);
  importProjectFrm:= TimportProjectFrm.Create(nil);
  versionFrm := TgenerateJarFrm.Create(nil);
  application.OnMessage := AppMessage;
  application.OnDeactivate := OnDeactivate;

  fMRUItems[1] := miFileMRU1;
  fMRUItems[2] := miFileMRU2;
  fMRUItems[3] := miFileMRU3;
  fMRUItems[4] := miFileMRU4;
  fMRUItems[5] := miFileMRU5;
  fMRUItems[6] := miFileMRU6;
  fMRUItems[7] := miFileMRU7;
  fMRUItems[8] := miFileMRU8;

  fProjectMRUItems[1] := recentProjectMRU1;
  fProjectMRUItems[2] := recentProjectMRU2;
  fProjectMRUItems[3] := recentProjectMRU3;
  fProjectMRUItems[4] := recentProjectMRU4;


  //创建jdkhelp窗口
  jdkHelpFrm := TjdkHelpFrm.Create(nil);
  jdkHelpFrm.Parent:=self;
  jdkHelpFrm.visible:=false;

  //创建消息窗口
  msgFrm := TMsgFrm.Create(nil);
  msgFrm.ManualDock(MsgPanel, nil, alClient);
  msgFrm.Show;

  workSpacePanel.DockManager.BeginUpdate;

  //创建工作区窗口
  workSpaceFrm := TWorkSpaceFrm.Create(nil);
  //workSpaceFrm.Show;
  workSpaceFrm.ManualDock(WorkSpacePanel, nil, alTop);

  //创建工作区窗口
  classBrowserFrm := TClassBrowserFrm.Create(nil);
  classBrowserFrm.Show;
  classBrowserFrm.ManualDock(WorkSpacePanel, nil, alBottom);

  workSpaceFrm.Show;
  workSpacePanel.DockManager.EndUpdate;


  //设置菜单的checked属性
  self.msgMenuItem.Checked:=true;

  //创建文件类型选择对话框
  newFileFrm:=TnewFileFrm.Create(nil);

  ReadIniSettings;

  g_poplistNumber:=0;
  //检查两个java服务进程是否还存在，如果存在，kill
  KillJavaProcess(ReadCfgString('DebugServer','analysis_server_id'));
  WriteCfgString('DebugServer','analysis_server_id','0');
  KillJavaProcess(ReadCfgString('DebugServer','debug_server_id'));
  WriteCfgString('DebugServer','debug_server_id','0');

  analysisClassSocket.Port := g_analysis_server_port;
  analysisClassSocket.Active:=true;
  {
    检测参数
    1、如果无参数，则打开一个空的工程，工程模板在.\template目录下
    2、如果有参数，且参数的扩展名为jdp，则打开该工程文件
    3、如果有参数，且参数的扩展名不是jdp，则打开一个空的工程，工程模板在.\template目录下，
       ，同时将该参数作为工程的一个子文件加入到工程中去；
  }
  startupFlag:=false;
  if paramStr(1) <> '' then
  begin
    if Pos('.jdp',ExtractFileName(paramStr(1))) > 0 then
    begin
     startupFlag:=true;
     OpenProject(paramStr(1));
    end else
    begin
       Sleep(100);
       DoOpenFile(paramStr(1));
    end;
  end;
  
  if not startupFlag then
    StartupAnalysisProcess;

  DragAcceptFiles(self.Handle,true);//gsh add 2003-10-02
  
end;

procedure TIDEFrm.MsgPanelDockOver(Sender: TObject;
  Source: TDragDockObject; X, Y: Integer; State: TDragState;
  var Accept: Boolean);
var
  ARect: TRect;
begin
  Accept := Source.Control is TMsgFrm;
  if Accept then
  begin
    //Modify the DockRect to preview dock area.
    ARect.TopLeft := MsgPanel.ClientToScreen(
      Point(0, -Self.ClientHeight div 4));
    ARect.BottomRight := MsgPanel.ClientToScreen(
      Point(MsgPanel.Width, MsgPanel.Height));
    Source.DockRect := ARect;
  end;
end;


procedure TIDEFrm.MsgPanelUnDock(Sender: TObject; Client: TControl;
  NewTarget: TWinControl; var Allow: Boolean);
begin
  //OnUnDock gets called BEFORE the client is undocked, in order to optionally
  //disallow the undock. DockClientCount is never 0 when called from this event.
  if (Sender as TPanel).DockClientCount = 1 then
    ShowDockPanel(Sender as TPanel, False, nil);

end;

procedure TIDEFrm.MsgPanelGetSiteInfo(Sender: TObject;
  DockClient: TControl; var InfluenceRect: TRect; MousePos: TPoint;
  var CanDock: Boolean);
begin
  CanDock := DockClient is TMsgFrm;
end;

procedure TIDEFrm.MsgMenuItemClick(Sender: TObject);
begin
  if not (sender as TMenuItem).Checked then
  begin
    if (msgFrm.HostDockSite is TPanel)
    and ((msgFrm.HostDockSite.Height = 0) or (msgFrm.HostDockSite.Width = 0)) then
      ShowDockPanel(msgFrm.HostDockSite as TPanel, True, MsgFrm)
    else
      //if the window isn't docked at all, simply show it.
      MsgFrm.Show;
  end else
  begin
    if (msgFrm.HostDockSite is TPanel)  then
    begin
      ShowDockPanel(msgFrm.HostDockSite as TPanel, false, MsgFrm);
      MsgFrm.Hide;
    end
    else
      //if the window isn't docked at all, simply show it.
      MsgFrm.hide;
  end;
end;

procedure TIDEFrm.MsgPanelDockDrop(Sender: TObject;
  Source: TDragDockObject; X, Y: Integer);
begin
  if (Sender as TPanel).DockClientCount = 1 then
    ShowDockPanel(Sender as TPanel, True, nil);
  (Sender as TPanel).DockManager.ResetBounds(True);
  //Make DockManager repaints it's clients.
end;

procedure TIDEFrm.ShowDockPanel(APanel: TPanel; MakeVisible: Boolean; Client: TControl);
begin
  //Don't try to hide a panel which has visible dock clients.
    if not MakeVisible and (APanel.VisibleDockClientCount > 1) then
      Exit;

    if APanel = WorkSpacePanel then
      VSplitter.Visible := MakeVisible
    else
      HSplitter.Visible := MakeVisible;

      if MakeVisible then
        if APanel = WorkSpacePanel then
        begin
          APanel.Width := ClientWidth div 4;
          VSplitter.Left := APanel.Width + VSplitter.Width;
        end
        else begin
          APanel.Height := ClientHeight div 4;
          HSplitter.Top := ClientHeight - APanel.Height - HSplitter.Width;
        end
      else
        if APanel = WorkSpacePanel then
          APanel.Width := 0
        else
          APanel.Height := 0;

  if MakeVisible and (Client <> nil) then
     Client.Show;
end;

procedure TIDEFrm.WorkSpacePanelDockDrop(Sender: TObject;
  Source: TDragDockObject; X, Y: Integer);
begin
  if (Sender as TPanel).DockClientCount = 1 then
    ShowDockPanel(Sender as TPanel, True, nil);
  (Sender as TPanel).DockManager.ResetBounds(True);
  //Make DockManager repaints it's clients.
end;

procedure TIDEFrm.WorkSpacePanelDockOver(Sender: TObject;
  Source: TDragDockObject; X, Y: Integer; State: TDragState;
  var Accept: Boolean);
var
  ARect: TRect;
begin
  Accept := (Source.Control is TWorkSpaceFrm) or (Source.Control is TClassBrowserFrm);
  if Accept then
  begin
    //Modify the DockRect to preview dock area.
    ARect.TopLeft := WorkSpacePanel.ClientToScreen(Point(0, 0));
    ARect.BottomRight := WorkSpacePanel.ClientToScreen(
      Point(self.ClientWidth div 4, WorkSpacePanel.Height));
    Source.DockRect := ARect;
  end;
end;


procedure TIDEFrm.WorkSpacePanelGetSiteInfo(Sender: TObject;
  DockClient: TControl; var InfluenceRect: TRect; MousePos: TPoint;
  var CanDock: Boolean);
begin
  CanDock := (DockClient is TWorkSpaceFrm) or (DockClient is TClassBrowserFrm);
end;

procedure TIDEFrm.WorkSpacePanelUnDock(Sender: TObject; Client: TControl;
  NewTarget: TWinControl; var Allow: Boolean);
begin
  //OnUnDock gets called BEFORE the client is undocked, in order to optionally
  //disallow the undock. DockClientCount is never 0 when called from this event.
  if (Sender as TPanel).DockClientCount = 1 then
    ShowDockPanel(Sender as TPanel, False, nil);
end;

procedure TIDEFrm.WorkSpaceMenuItemClick(Sender: TObject);
begin
  if not (sender as TMenuItem).Checked then
  begin
    if (WorkSpaceFrm.HostDockSite is TPanel)
    and ((WorkSpaceFrm.HostDockSite.Height = 0) or (WorkSpaceFrm.HostDockSite.Width = 0)) then
      ShowDockPanel(WorkSpaceFrm.HostDockSite as TPanel, True, WorkSpaceFrm)
    else
      //if the window isn't docked at all, simply show it.
      WorkSpaceFrm.Show;
  end else
  begin
    if (WorkSpaceFrm.HostDockSite is TPanel)  then
    begin
      ShowDockPanel(WorkSpaceFrm.HostDockSite as TPanel, false, WorkSpaceFrm);
      WorkSpaceFrm.Hide;
    end
    else
      //if the window isn't docked at all, simply show it.
      WorkSpaceFrm.hide;
  end;

end;

procedure TIDEFrm.FormClose(Sender: TObject; var Action: TCloseAction);
var
  exitCode:DWord;
begin

  if g_socket_live then
    action :=caNone;

  try
    //if G_Project <> nil then
    //begin
    if not CloseProject then
    begin
      action:=caNone;
      exit;
    end;
    //end;
    if g_packageList <> nil then
      g_packageList.Free;

    WriteIniSettings;

    if Assigned(G_curApp) then
      G_curApp.Destroy;



    if G_CB <> nil then
       G_CB.Terminate;
    if   g_SystemClassPath <> nil then
      FreeMem(g_SystemClassPath,2048);

    if newFileFrm <> nil then
      newFileFrm.Free;
    if ErrorMsgList <> nil then
      ErrorMsgList.Free;

    if g_RegForm <> nil then
      g_RegForm.Free;

    if msgFrm <> nil then
    begin
      msgFrm.Destroy;
      msgFrm:=nil;
    end;
    if workSpaceFrm <> nil then
    begin
      workSpaceFrm.Destroy;
      workSpaceFrm:=nil;
    end;
    if classBrowserFrm <> nil then
    begin
      classBrowserFrm.Destroy;
      classBrowserFrm:=nil;
    end;

    if jdkHelpFrm <> nil then
    begin
      jdkHelpFrm.Destroy;
      jdkHelpFrm := nil;
    end;
    if generateJarFrm <> nil then
    begin
      generateJarFrm.Free;
      generateJarFrm := nil;
    end;
    if versionFrm <> nil then
    begin
      versionFrm.Free;
      versionFrm := nil;
    end;
    if importProjectFrm <> nil then
    begin
      importProjectFrm.Free;
      importProjectFrm := nil;
    end;

    if CommandsDataModule <> nil then
      CommandsDataModule.free;
    if commandDataDM <> nil then
      commandDataDM.free;

    //如果popup list 进程没有结束，强制结束popup list进程
    //if  G_PMList.AnalysisSocket <> nil then
    //  G_PMList.AnalysisSocket.SendText('exit');
    GetExitCodeProcess(g_analysisProcessInfo.hProcess, exitcode);
    if ( exitcode = STILL_ACTIVE ) then //如果当前进程没有结束
    begin
      //强制结束
      TerminateProcess(g_analysisProcessInfo.hProcess,0);
      WriteCfgString('DebugServer','analysis_server_id','0');
    end;
  except
    ;
  end;
end;

procedure TIDEFrm.ClassBrowserMenuItemClick(Sender: TObject);
begin
  if not (sender as TMenuItem).Checked then
  begin
    if (ClassBrowserFrm.HostDockSite is TPanel)
    and ((ClassBrowserFrm.HostDockSite.Height = 0) or (ClassBrowserFrm.HostDockSite.Width = 0)) then
      ShowDockPanel(ClassBrowserFrm.HostDockSite as TPanel, True, ClassBrowserFrm)
    else
      //if the window isn't docked at all, simply show it.
      ClassBrowserFrm.Show;
  end else
  begin
    if (ClassBrowserFrm.HostDockSite is TPanel)  then
    begin
      ShowDockPanel(ClassBrowserFrm.HostDockSite as TPanel, false, ClassBrowserFrm);
      ClassBrowserFrm.Hide;
    end
    else
      //if the window isn't docked at all, simply show it.
      ClassBrowserFrm.hide;
  end;

end;

procedure TIDEFrm.exitAppMIClick(Sender: TObject);
begin
  if CloseProject then
    close;
end;

procedure TIDEFrm.commonToolBarMIClick(Sender: TObject);
begin
  if (sender as TMenuItem).Checked then
    commonToolBar.Hide
  else
    commonToolBar.Show;
  (sender as TMenuItem).Checked:=not (sender as TMenuItem).Checked;

end;

procedure TIDEFrm.commonExtToolbarMIClick(Sender: TObject);
begin
  if (sender as TMenuItem).Checked then
    commonExtToolBar.Hide
  else
    commonExtToolBar.Show;
  (sender as TMenuItem).Checked:=not (sender as TMenuItem).Checked;
end;

procedure TIDEFrm.windows1TBClick(Sender: TObject);
begin
  workspacePanel.Hide;
  msgPanel.Hide;
end;

procedure TIDEFrm.windows2TBClick(Sender: TObject);
begin
  MsgPanel.Hide;
  workspacePanel.Show;
end;

procedure TIDEFrm.windows3TBClick(Sender: TObject);
begin
  MsgPanel.Show;
  workspacePanel.hide;
end;

procedure TIDEFrm.windows4TBClick(Sender: TObject);
begin
  MsgPanel.Show;
  workspacePanel.Show;
end;

procedure TIDEFrm.openProjectMIClick(Sender: TObject);
begin
  checkDirectory(g_projectFilePath);
  openProjectDlg.InitialDir:=g_projectFilePath;
  with openProjectDlg do
  if Execute then
  begin
    if not fileExists(fileName) then
    begin
      ShowError(getErrorMsg('CanNotFindProject'),MB_OK);
    end else
    begin
      if ((G_Project <> nil) and ( fileName = (G_Project.Path + G_Project.filename)) )then
        exit;
      if not CloseProject then
        exit;
      OpenProject(filename);
      CommandsDataModule.RemoveProjectMRUEntry(filename);
    end;
  end;
end;

procedure TIDEFrm.newFileItemClick(Sender: TObject);
var
  pack:String;
begin
  if G_Project = nil then
  begin
    ShowError(getErrorMsg('PleaseNewProject'),MB_OK);
    exit;
  end;

  if newFileFrm.ShowModal = mrOK then
  begin
    if newFileFrm.destinationCombo.ItemIndex = 0 then
      pack:=''
    else
      pack:=newFileFrm.destinationCombo.Text;
    DoOpenFile(newFileFrm.fileName,newFileFrm.fileTypeLV.ItemIndex,pack);
    addFileToProject(pack,GI_ActiveEditor.GetFileTitle);
    SaveProject(G_Project);
  end;
end;

procedure TIDEFrm.openFileMIClick(Sender: TObject);
begin
  with CommandsDataModule.dlgFileOpen do
  begin
    if Execute then
      DoOpenFile(FileName);
  end;
end;

procedure TIDEFrm.newProjectMIClick(Sender: TObject);
var
  propertyFrm:TprojectPropertyFrm;
  pack:TPackage;
begin
  //打开工程属性窗口，让用户输入信息
  propertyFrm:=TprojectPropertyFrm.create(nil,CREATE_PROJECT);
  if propertyFrm.ShowModal = mrOK then
  begin
    //检测是否有工程打开，如果有，关闭工程
    if not CloseProject then
      exit;
    //保存，设置G_Project
    G_Project := TProject.create;
    G_Project.name:=propertyFrm.pro_name_edit.Text;

    G_Project.Path:=getRealPath(propertyFrm.pro_path_edit.Text);
    G_Project.fileName:= propertyFrm.pro_filename_edit.Text;
    G_Project.createDateTime:=propertyFrm.pro_createTime_lbl.Caption;
    G_Project.lastModifiedDateTime:=G_Project.createDateTime;
    if  propertyFrm.pro_javatype_rb.Checked then
      G_Project.projectType:=JAVAAPPLICATION
    else
      G_Project.projectType:=WEBAPPLICATION;

    G_Project.cfg.classPath:=AnsiReplaceStr(propertyFrm.cpListBox.Items.Text,#13#10,';');
    G_Project.cfg.mainClassName := '';
    G_Project.cfg.mainClassPackage := '';
    G_Project.cfg.author := propertyFrm.pro_author_edit.Text;
    G_Project.cfg.parameter:=propertyFrm.parametersEdit.Text;
    G_Project.cfg.version:=propertyFrm.version_lbl.Caption;

    pack:=TPackage.create;
    pack.name:='';
    pack.path:=G_Project.Path;
    G_Project.packageList.Add(pack);
    G_Project.DefaultPackage:=pack;

    //保存工程
    saveProject(G_Project);
    //更新节点树
    updateProjectTreeView(workSpaceFrm.projectTV,false);

    //新建工程，需要重新启动类解析服务器
    StartupAnalysisProcess;

  end else
    exit;
  propertyFrm.Free;

end;

procedure TIDEFrm.DoOpenFile(AFileName:string;index:Integer;pack:String);
var
  i: integer;
  LEditor: IEditor;
  item:TMenuItem;
  fn,oldfn:String;
begin
  AFileName := ExpandFileName(AFileName);
  for i:=0 to ideFrm.windowsMI.Count-1 do
    ideFrm.windowsMI.Items[i].Checked:=false;

  if filePageControl.PageCount > 0 then
     oldfn := GI_EditorFactory.Editor[filePageControl.activePageIndex].GetFileName;
  if AFileName <> '' then begin
    //CommandsDataModule.RemoveMRUEntry(AFileName);
    // activate the editor if already open
    Assert(GI_EditorFactory <> nil);
    for i := GI_EditorFactory.GetEditorCount - 1 downto 0 do begin
      LEditor := GI_EditorFactory.Editor[i];
      if CompareText(LEditor.GetFileName, AFileName) = 0 then begin
        fn:=LEditor.GetFileName;
        LEditor.Activate;
        LEditor.GetMenuItem.Checked:=true;
        //如果没有更新页面，不用重新解析
        if oldfn <> fn then
        if isJavaFile(fn)  then
        begin
          if ideFrm.G_PMList.AnalysisSocket <> nil then
          begin
             //copyFile(fn,g_tempFilePath + DateToStr(now),false);
             ideFrm.G_PMList.AnalysisSocket.SendText('@@' + fn + #13#10);
          end else if  (G_CB<>nil ) and ( filePageControl.PageCount > 0) then
             PostThreadMessage(G_CB.ThreadID,WM_CLASSBROWSER,Integer(GI_EditorFactory.Editor[filePageControl.ActivePageIndex]),0);
        end
        else
          //classBrowserFrm.classBrowserTV.items.clear;
          PostThreadMessage(G_CB.ThreadID,WM_CLASSBROWSER,0,0);
        exit;
      end;
    end;
  end;
  // create a new editor, add it to the editor list, open the file

  begin
    LEditor := DoCreateEditor(AFileName,index);
    if LEditor <> nil then
    begin
      LEditor.OpenFile(AFileName,pack);
      //for i:=0 to ideFrm.windowsMI.Count-1 do
        //ideFrm.windowsMI.Items[i].Checked:=false;
      item:=TMenuItem.Create(self);
      item.Caption:=LEditor.GetFileName;
      item.Checked:=true;
      ideFrm.windowsMI.Add(item);
      LEditor.SetMenuItem(item);
      item.OnClick:=WindowClickEvent;
      fn:=LEditor.GetFileName;
      if not FileExists(fn) then
        exit;
      //恢复断点
      //setFileBreakPoint(LEditor);
      if (isJavaFile(fn)) then
      begin
        if ideFrm.G_PMList.AnalysisSocket <> nil then
           ideFrm.G_PMList.AnalysisSocket.SendText('@@' + fn + #13#10)
        else if  (G_CB<>nil ) and ( filePageControl.PageCount > 0) then
           PostThreadMessage(G_CB.ThreadID,WM_CLASSBROWSER,Integer(LEditor),0);
      end
      else
        //classBrowserFrm.classBrowserTV.items.clear;
        PostThreadMessage(G_CB.ThreadID,WM_CLASSBROWSER,0,0);
    end;
  end;

  setSelectMode(SelectComboBox.ItemIndex);


end;

procedure TIDEFrm.DoOpenFile(AFileName: string);
begin
  DoOpenFile(AFileName,getSubFileType(AFileName),'####');
end;

function TIDEFrm.DoCreateEditor(AFileName: string;Index:integer): IEditor;
begin
  if GI_EditorFactory <> nil then
    Result := GI_EditorFactory.CreateTabSheet(filePageControl,index)
  else
    Result := nil;
end;

procedure TIDEFrm.FilePageControlChange(Sender: TObject);
var
  i:Integer;
  fn:String;
begin
  fn:=GI_EditorFactory.Editor[filePageControl.ActivePageIndex].GetFileName;
  if isJavaFile(fn) then
  begin
    if ideFrm.G_PMList.AnalysisSocket <> nil then
       ideFrm.G_PMList.AnalysisSocket.SendText('@@' + fn + #13#10)
    else if  (G_CB<>nil ) and ( filePageControl.PageCount > 0) then
       PostThreadMessage(G_CB.ThreadID,WM_CLASSBROWSER,Integer(GI_EditorFactory.Editor[filePageControl.ActivePageIndex]),0);
  end
  else
    //classBrowserFrm.classBrowserTV.items.clear;
    PostThreadMessage(G_CB.ThreadID,WM_CLASSBROWSER,0,0);
  GI_EditorFactory.Editor[filePageControl.ActivePageIndex].SetFileCmds;
  for i:=0 to GI_EditorFactory.GetEditorCount-1 do
  if i =  filePageControl.ActivePageIndex then
    GI_EditorFactory.Editor[i].GetMenuItem.Checked:=true
  else
    GI_EditorFactory.Editor[i].GetMenuItem.Checked:=false;
end;

procedure TIdeFrm.WindowClickEvent(Sender: TObject);
var
  i:Integer;
  fn:String;
begin
  for i:=0 to ideFrm.windowsMI.Count-1 do
    ideFrm.windowsMI.Items[i].Checked:=false;
  (sender as TMenuItem).Checked:=true;
  if GI_EditorFactory = nil then
    exit;
  for i:=0 to GI_EditorFactory.GetEditorCount-1 do
  begin
    if (sender as TMenuItem) = GI_EditorFactory.Editor[i].GetMenuItem then
    begin
      ideFrm.FilePageControl.ActivePageIndex:=i;
      fn:=GI_EditorFactory.Editor[filePageControl.ActivePageIndex].GetFileName;
      if isJavaFile(fn) then
      begin
        if ideFrm.G_PMList.AnalysisSocket <> nil then
           ideFrm.G_PMList.AnalysisSocket.SendText('@@' + fn + #13#10)
        else if  (G_CB<>nil ) and ( filePageControl.PageCount > 0) then
           PostThreadMessage(G_CB.ThreadID,WM_CLASSBROWSER,Integer(GI_EditorFactory.Editor[filePageControl.ActivePageIndex]),0);
      end
      else
        //classBrowserFrm.classBrowserTV.items.clear;
        PostThreadMessage(G_CB.ThreadID,WM_CLASSBROWSER,0,0);
    end;
  end;
end;

procedure TIDEFrm.actFileCloseAllExecute(Sender: TObject);
var
  i: integer;
begin
  if GI_EditorFactory <> nil then
  begin
    if not CanCloseAll then
      exit;
    i := GI_EditorFactory.GetEditorCount - 1;
    // close all editor childs
    while i >= 0 do begin
      GI_EditorFactory.GetEditor(i).Close;
      Dec(i);
      if g_CancelSave then
        break;
    end;
  end;
end;


procedure TIDEFrm.actFileCloseAllUpdate(Sender: TObject);
begin
  actFileCloseAll.Enabled := (GI_EditorFactory <> nil)
    and (GI_EditorFactory.GetEditorCount > 0);
end;

function TIDEFrm.CanCloseAll: boolean;
begin
  Result := true;
end;

procedure TIDEFrm.actUpdateStatusBarPanelsUpdate(Sender: TObject);
resourcestring
  SModified = 'Modified';
var
  ptCaret: TPoint;
begin
  actUpdateStatusBarPanels.Enabled := TRUE;
  if filePageControl.PageCount = 0 then
     GI_ActiveEditor := nil;
  if GI_ActiveEditor <> nil then begin
    ptCaret := GI_ActiveEditor.GetCaretPos;
    if (ptCaret.X > 0) and (ptCaret.Y > 0) then
      StatusBar.Panels[0].Text := Format(' Row:%6d  Col:%3d ', [ptCaret.Y, ptCaret.X])
    else
      StatusBar.Panels[0].Text := '';
    if GI_ActiveEditor.GetModified then
      StatusBar.Panels[1].Text := SModified
    else
      StatusBar.Panels[1].Text := '';
    StatusBar.Panels[2].Text := GI_ActiveEditor.GetEditorState;
    StatusBar.Panels[3].Text := GI_ActiveEditor.GetFileName;
    //caption:=FORM_PRE_CAPTION+GI_ActiveEditor.GetFileName;
  end
  else
  begin
    StatusBar.Panels[0].Text := '';
    StatusBar.Panels[1].Text := '';
    StatusBar.Panels[2].Text := '';
    StatusBar.Panels[3].Text := '';
    //caption:=FORM_PRE_CAPTION;
  end;
end;


procedure TIDEFrm.actFileSaveAllExecute(Sender: TObject);
var
  i:Integer;
  fn:String;
begin
  if GI_EditorFactory <> nil then
  begin
    for i:=0 to GI_EditorFactory.GetEditorCount-1 do
    begin
      if ( G_VersionType = TRAILVERSION )  and ( Length(GI_EditorFactory.Editor[i].GetFileContent) >= MaxSaveFileSize)  then
      begin
        msgFrm.operatorMemo.Lines.Add('You are using Trial Version,you can''t save file over 2500 bytes.');
        msgFrm.operatorMemo.Lines.Add('Please login '+g_domain_web_site+' to get license.');
        exit;
      end;
      GI_EditorFactory.GetEditor(i).Save;
    end;
  end;

  fn:=GI_EditorFactory.Editor[filePageControl.ActivePageIndex].GetFileName;
  if isJavaFile(fn) then
  begin
    if ideFrm.G_PMList.AnalysisSocket <> nil then
       ideFrm.G_PMList.AnalysisSocket.SendText('@@' + fn + #13#10)
    else if  (G_CB<>nil ) and ( filePageControl.PageCount > 0) then
       PostThreadMessage(G_CB.ThreadID,WM_CLASSBROWSER,Integer(GI_EditorFactory.Editor[filePageControl.ActivePageIndex]),0);

  end
  else
    PostThreadMessage(G_CB.ThreadID,WM_CLASSBROWSER,0,0);
end;

procedure TIDEFrm.sendMailToExecute(Sender: TObject);
begin
ShellExecute(0, nil, PChar('mailto:?SUBJECT='+ filePageControl.ActivePage.caption
                  +'&BODY='+GI_EditorFactory.Editor[filePageControl.ActivePageIndex].getFileContent), nil, nil, SW_NORMAL);

end;

procedure TIDEFrm.sendMailToUpdate(Sender: TObject);
begin
  self.sendMailTo.Enabled:= (filePageControl.PageCount > 0);
end;

procedure TIDEFrm.ReadIniSettings;
var
  iniFile: TIniFile;
  x, y, w, h: integer;
  i: integer;
  s: string;
  tabPos:Integer;
begin
  iniFile := TIniFile.Create(g_exeFilePath+CONFIGFILE);

  try
    x := iniFile.ReadInteger('MainLocation', 'Left', 0);
    y := iniFile.ReadInteger('MainLocation', 'Top', 0);
    w := iniFile.ReadInteger('MainLocation', 'Width', 0);
    h := iniFile.ReadInteger('MainLocation', 'Height', 0);
    if (w > 0) and (h > 0) then
      SetBounds(x, y, w, h);
    if iniFile.ReadInteger('MainLocation', 'Maximized', 0) <> 0 then
      WindowState := wsMaximized;
    StatusBar.Visible := iniFile.ReadInteger('MainLocation', 'ShowStatusbar', 1) <> 0;
    // MRU files
    for i := 8 downto 1 do begin
      s := iniFile.ReadString('MRUFiles', Format('MRUFile%d', [i]), '');
      if s <> '' then
        CommandsDataModule.AddMRUEntry(s);
    end;
    // ProjectMRU files
    for i := 4 downto 1 do begin
      s := iniFile.ReadString('ProjectMRUFiles', Format('ProjectMRUFile%d', [i]), '');
      if s <> '' then
        CommandsDataModule.AddProjectMRUEntry(s);
    end;

    g_IDE_ClassPath := iniFile.ReadString('JDK_CFG','class_path', '');
    g_IDE_SourcePath :=iniFile.ReadString('JDK_CFG','source_path', '');
    g_jdk_zipsrc_path :=iniFile.ReadString('JDK_CFG','jdk_srczip_path', '');
    g_domain_web_site :=iniFile.ReadString('IDE','DOMAIN_WEB_SITE', '');
    g_jdkdocPath := iniFile.ReadString('Help_CFG','jdk_doc_path', '');
    g_servletdocPath := iniFile.ReadString('Help_CFG','servlet_doc_path', '');
    g_jspdocPath := iniFile.ReadString('Help_CFG','jsp_doc_path', '');
    if g_jdkdocpath <> '' then
      g_jdkdocpath := getRealPath(g_jdkdocpath);
    g_Debug_Server_Port:=iniFile.ReadInteger('DebugServer','debug_server_port', 7899);
    g_analysis_server_port := iniFile.ReadInteger('DebugServer','analysis_server_port', 7900);
    
    tabPos:=iniFile.ReadInteger('Profile_CFG','fileTabPos',0);
    if tabPos = 0 then ideFrm.filePageControl.TabPosition:=tpTop
    else if tabPos = 1 then ideFrm.filePageControl.TabPosition:=tpBottom
    else if tabPos = 2 then ideFrm.filePageControl.TabPosition:=tpLeft
    else if tabPos = 3 then ideFrm.filePageControl.TabPosition:=tpRight;
    if  iniFile.ReadInteger('Profile_CFG','commonToolBar',0) = 1 then
      commonToolBar.Visible:=false
    else
      commonToolBar.Visible:=true;
    if  iniFile.ReadInteger('Profile_CFG','extToolBar',0) = 1 then
      commonExtToolBar.Visible:=false
    else
      commonExtToolBar.Visible:=true;
    if  iniFile.ReadInteger('Profile_CFG','workSpace',0) = 1 then
      workSpaceFrm.Visible:=false
    else
      workSpaceFrm.Visible:=true;
    if  iniFile.ReadInteger('Profile_CFG','classbrowser',0) = 1 then
      classbrowserFrm.Visible:=false
    else
      classbrowserFrm.Visible:=true;

    if  iniFile.ReadInteger('Profile_CFG','messageWin',0) = 1 then
      msgFrm.Visible:=false
    else
      msgFrm.Visible:=true;

    if  iniFile.ReadInteger('Profile_CFG','statusBar',0) = 1 then
      statusBar.visible:=false
    else
      statusBar.visible:=true;
     

  finally
    iniFile.Free;
  end;
end;

procedure TIDEFrm.WriteIniSettings;
var
  iniFile: TIniFile;
  wp: TWindowPlacement;
  i: integer;
  s: string;
  //count:Integer;
begin
  iniFile := TIniFile.Create(g_exeFilePath+CONFIGFILE);
  try
    wp.length := SizeOf(TWindowPlacement);
    GetWindowPlacement(Handle, @wp);
    // form properties
    with wp.rcNormalPosition do begin
      iniFile.WriteInteger('MainLocation', 'Left', Left);
      iniFile.WriteInteger('MainLocation', 'Top', Top);
      iniFile.WriteInteger('MainLocation', 'Width', Right - Left);
      iniFile.WriteInteger('MainLocation', 'Height', Bottom - Top);
    end;
    iniFile.WriteInteger('MainLocation', 'Maximized', Ord(WindowState = wsMaximized));
    iniFile.WriteInteger('MainLocation', 'ShowStatusbar', Ord(Statusbar.Visible));
    // MRU files
    for i := 1 to 8 do
    begin
      s := CommandsDataModule.GetMRUEntry(i - 1);
      if s <> '' then
        iniFile.WriteString('MRUFiles', Format('MRUFile%d', [i]), s)
      else
        iniFile.DeleteKey('MRUFiles', Format('MRUFile%d', [i]));
    end;
    // ProjectMRU files
    for i := 1 to 8 do
    begin
      s := CommandsDataModule.GetProjectMRUEntry(i - 1);
      if s <> '' then
        iniFile.WriteString('ProjectMRUFiles', Format('ProjectMRUFile%d', [i]), s)
      else
        iniFile.DeleteKey('ProjectMRUFiles', Format('ProjectMRUFile%d', [i]));
    end;
  finally
    iniFile.Free;
  end;
end;

procedure TIDEFrm.miFileMRUClick(Sender: TObject);
var
  i: integer;
  s: string;
begin
  for i := Low(fMRUItems) to High(fMRUItems) do
    if Sender = fMRUItems[i] then begin
      s := CommandsDataModule.GetMRUEntry(i-1);
      if s <> '' then
      begin
        if not fileExists(s) then
        begin
          ShowError(getErrorMsg('FileNotExist'),MB_OK);
          exit;
        end else
        begin
          DoOpenFile(s);
        end;
        CommandsDataModule.RemoveMRUEntry(s);
      end;
    end;
end;

procedure TIDEFrm.recentFileMIClick(Sender: TObject);
var
  i: integer;
  s: string;
begin
  for i := Low(fMRUItems) to High(fMRUItems) do
    if fMRUItems[i] <> nil then
    begin
      s := CommandsDataModule.GetMRUEntry(i - Low(fMRUItems));
      fMRUItems[i].Visible := s <> '';
      fMRUItems[i].Caption := s;
    end;
end;

procedure TIDEFrm.saveProjectMIClick(Sender: TObject);
begin
  saveProject(G_Project);
end;

procedure TIDEFrm.actSaveProjectExecute(Sender: TObject);
begin
  saveProject(G_Project);
end;

procedure TIDEFrm.actSaveProjectUpdate(Sender: TObject);
begin
  actSaveProject.Enabled:=(G_Project <> nil );
end;

procedure TIDEFrm.actCloseProjectExecute(Sender: TObject);
begin
  CloseProject;
end;

procedure TIDEFrm.actCloseProjectUpdate(Sender: TObject);
begin
  actCloseProject.Enabled:=(G_Project <> nil );
end;

procedure TIDEFrm.TabMenuPopup(APageControl: TPageControl;button:TMouseButton; X, Y: Integer);
var
   hi: TTCHitTestInfo;
   TabIndex: Integer;
   p: TPoint;
begin

   hi.pt.x := X;
   hi.pt.y := Y;
   hi.flags := 0;
   TabIndex := APageControl.Perform(TCM_HITTEST, 0, longint(@hi));
   filePageControl.ActivePageIndex:=TabIndex;
   //p.x := APageControl.Left + X;
   //p.y := APageControl.Top + y;
   p.x := X;
   p.y := y;
   p := APageControl.ClientToScreen(p);
   // Allows use of different menus for each tab...
   if Button = mbRight then
   begin
     pagePopupMenu.Popup(p.x, p.y);
   end;



   {case TabIndex of
   0:
     //pagePopupMenu.Popup(p.x, p.y);
   1:
     //pagePopupMenu.Popup(p.x, p.y);
   end;} {case}
end;

procedure TIDEFrm.filePageControlMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
 //filePageControl.ActivePageIndex:=TabIndex;
 //if Button = mbRight then
 //begin
 TabMenuPopup(filePageControl,Button, X, Y);
 //end;
end;

procedure TIDEFrm.BookmarkMI1Click(Sender: TObject);
var
  synedit:TSynEditExt;
  i,x,y:Integer;
  found:Boolean;
begin
  if GI_EditorFactory.GetEditorCount > 0 then
  begin
    synedit:=GI_EditorFactory.Editor[filePageControl.ActivePageIndex].GetSynEditor;
    found :=false;
    for i:=0 to 9 do
    begin
      if (( synedit.GetBookMark(i,x,y) ) and ( y = synedit.CaretY) )then
      begin
        synedit.ClearBookMark(i); 
        if i=(sender as TMenuItem).Tag then
          found:=true;
        //break;
      end;
    end;

    if not found then
      synedit.SetBookMark( (sender as TMenuItem).Tag,synedit.CaretX, synedit.CaretY);

  end;
end;

procedure TIDEFrm.goBookMark1Click(Sender: TObject);
var
  synedit:TSynEditExt;
begin
  if GI_EditorFactory.GetEditorCount > 0 then
  begin
    synedit:=GI_EditorFactory.Editor[filePageControl.ActivePageIndex].GetSynEditor;
    synedit.GotoBookMark((sender as TMenuItem).Tag);
  end;
end;

procedure TIDEFrm.removeAllBookMarkMIClick(Sender: TObject);
var
  synedit:TSynEditExt;
  i:Integer;
begin
  if GI_EditorFactory.GetEditorCount > 0 then
  begin
    synedit:=GI_EditorFactory.Editor[filePageControl.ActivePageIndex].GetSynEditor;
    for i:=0 to 9 do
     if synedit.IsBookmark(i) then
        synedit.ClearBookMark(i);
  end;
end;

procedure TIDEFrm.recentProjectMIClick(Sender: TObject);
var
  i: integer;
  s: string;
begin
  for i := Low(fProjectMRUItems) to High(fProjectMRUItems) do
    if fProjectMRUItems[i] <> nil then
    begin
      s := CommandsDataModule.GetProjectMRUEntry(i - Low(fProjectMRUItems));
      fProjectMRUItems[i].Visible := s <> '';
      fProjectMRUItems[i].Caption := s;
    end;
end;

procedure TIDEFrm.recentProjectMRU1Click(Sender: TObject);
var
  i: integer;
  s: string;
begin
  for i := Low(fProjectMRUItems) to High(fProjectMRUItems) do
  begin
    if Sender = fProjectMRUItems[i] then
    begin
      s := CommandsDataModule.GetProjectMRUEntry(i - 1);
      if s <> '' then
      begin
        if not fileExists(s) then
        begin
          ShowError(getErrorMsg('CanNotFindProject'),MB_OK);
        end else
        begin
          if ((G_Project <> nil) and (s = (G_Project.Path + G_Project.filename)) )then
            exit;
          if not CloseProject then
            exit;
          OpenProject(s);
        end;
        CommandsDataModule.RemoveProjectMRUEntry(s);
      end;
      break;
    end;
  end;
end;

procedure TIDEFrm.OpenProject(fileName:String);
begin
    {if not( FileExists(fileName) ) then
    begin
      ShowError(getErrorMsg('CanNotFindProject'),0);
      exit;
    end;}
    G_Project:=LoadProjectFromFile(fileName);
    updateProjectTreeView(workSpaceFrm.projectTV,false);

    //打开工程，需要重新启动类服务器；
    //try
      startupAnalysisProcess;
    //except
    //  startupAnalysisProcess;
    //end;
end;

procedure TIDEFrm.Label1Click(Sender: TObject);
begin
  ShellExecute(0, nil, PChar('mailto:gongsh@vip.sina.com?SUBJECT=Get License!'
                  +'&BODY=I want to get a license from you. '), nil, nil, SW_NORMAL);

end;

procedure TIDEFrm.SelectComboBoxChange(Sender: TObject);
begin
  setSelectMode(selectComboBox.ItemIndex);
end;

procedure TIDEFrm.setSelectMode(index:Integer);
var
  synedit:TSynEditExt;
  i:Integer;
begin
  selectComboBox.ItemIndex := index;
  selectModeMI.Items[index].Checked:=true;

  if GI_EditorFactory.GetEditorCount > 0 then
  begin
    for i:=0 to GI_EditorFactory.GetEditorCount-1 do
    begin
      synedit:=GI_EditorFactory.Editor[i].GetSynEditor;
      if index = 0 then
        synedit.SelectionMode:= smNormal
      else if index = 1 then
        synedit.SelectionMode:= smLine
      else if index = 2 then
        synedit.SelectionMode:= smColumn;
    end;
  end;
end;

procedure TIDEFrm.N15Click(Sender: TObject);
begin
  setSelectMode( (sender as TMenuItem).Tag);
end;

procedure TIDEFrm.actBookmarkExecute(Sender: TObject);
var
  p:TPoint;
begin
  p.y:=BookmarkBtn.top + BookmarkBtn.Height ;
  p.x:=0;
  p:=BookmarkBtn.ClientToScreen(p);
  BookMarkPM.Popup(p.x,p.y);
end;

procedure TIDEFrm.actBookmarkUpdate(Sender: TObject);
begin
  actBookMark.Enabled:= (GI_EditorFactory.GetEditorCount > 0);
end;

procedure TIDEFrm.actGotoBookmarkExecute(Sender: TObject);
var
  p:TPoint;
begin
  p.y:=BookmarkBtn.top + BookmarkBtn.Height ;
  p.x:=0;
  p:=goToBookmarkBtn.ClientToScreen(p);
  gotoBookMarkPM.Popup(p.x,p.y);
end;

procedure TIDEFrm.actGotoBookmarkUpdate(Sender: TObject);
begin
  actGotoBookmark.Enabled:= (GI_EditorFactory.GetEditorCount > 0);
end;

procedure TIDEFrm.actFormatExecute(Sender: TObject);
var
  fileName:String;
begin
  if filePageControl.PageCount > 0 then
  begin
    fileName := trim(GI_EditorFactory.Editor[filePageControl.ActivePageIndex].GetFileName);
    if isJavaFile(fileName) then
      DoFormat(GI_EditorFactory.Editor[filePageControl.ActivePageIndex].GetSynEditor.Lines);
  end;
end;

procedure TIDEFrm.actFormatUpdate(Sender: TObject);
begin
  actFormat.Enabled:= (GI_EditorFactory.GetEditorCount > 0);
end;

function TIDEFrm.DoFormat(fileContent:TStrings):Boolean;
var
  commandLine :String;
  StartupInfo:TStartUpInfo;
  ProcessInfo: TProcessInformation;
  zAppName : array[0..512] of char;
  rs:Cardinal;
  tempList:TStringList;
begin
  result:=false;
  if fileContent.Text = '' then
     exit;

  if not FileExists(g_pluginFilePath+FORMAT_EXE_PLUGIN) then
  begin
    ShowError(getErrorMsg('FormatPluginIsNotExist'),MB_OK);
    exit;
  end;
  checkDirectory('.\temp');

  if FileExists(g_tempFilePath+TEMPFORMAT_FILE) then
    deletefile(g_tempFilePath+TEMPFORMAT_FILE);

  fileContent.SaveToFile(g_tempFilePath+TEMPFORMAT_FILE);
  commandLine:='"'+g_pluginFilePath+FORMAT_EXE_PLUGIN+'" -b  '+g_tempFilePath+TEMPFORMAT_FILE ;
  FillChar(zAppName, Sizeof(zAppName), #0);
  StrPCopy( zAppName, commandLine );

  FillChar(StartupInfo, Sizeof(StartupInfo), #0);
  StartupInfo.cb := Sizeof(StartupInfo);
  StartupInfo.dwFlags := STARTF_USESHOWWINDOW;
  StartupInfo.wShowWindow := SW_HIDE;
  //创建进程
  if  CreateProcess(nil,zAppName, nil, nil, false,
    CREATE_NEW_CONSOLE,nil,nil, StartupInfo, ProcessInfo) then
  begin
    WaitForSingleObject(ProcessInfo.hProcess, INFINITE);
    GetExitCodeProcess( ProcessInfo.hProcess, rs );
    CloseHandle ( ProcessInfo.hProcess );
    CloseHandle ( ProcessInfo.hThread );
    if not FileExists(g_tempFilePath+TEMPFORMAT_FILE) then
    begin
      ShowError(getErrorMsg('FormatError'),MB_OK);
      exit;
    end else
    begin
      if not FileExists(g_tempFilePath+TEMPFORMAT_FILE) then
        exit;
      tempList:=TStringList.Create;
      tempList.LoadFromFile(g_tempFilePath+TEMPFORMAT_FILE);
      tempList.Delete(tempList.Count-1);
      
      GI_EditorFactory.Editor[filePageControl.ActivePageIndex].GetSynEditor.SelectAll;
      GI_EditorFactory.Editor[filePageControl.ActivePageIndex].GetSynEditor.DoCopyToClipboard(tempList.Text);
      GI_EditorFactory.Editor[filePageControl.ActivePageIndex].GetSynEditor.PasteFromClipboard;
      GI_EditorFactory.Editor[filePageControl.ActivePageIndex].GetSynEditor.CaretXY:=Point(1,1);

      tempList.Free;
      result:=true;
    end;
  end;
end;

procedure TIDEFrm.deCompilerMIClick(Sender: TObject);

begin
  if ClassOpenDialog.Execute then
  begin
    doDeCompile(ClassOpenDialog.FileName);
  end;
end;

procedure TIDEFrm.doDeCompile(fileName:String);
var
  commandLine,fileprex:String;
  StartupInfo:TStartUpInfo;
  ProcessInfo: TProcessInformation;
  zAppName : array[0..512] of char;
  rs:Cardinal;
  index,i:Integer;
  list:TStringList;
begin
  if not FileExists(fileName) then
     exit;
  if not FileExists(g_pluginFilePath+DECOMPILER_EXE_PLUGIN) then
  begin
    ShowError(getErrorMsg('DeCompilePluginIsNotExist'),MB_OK);
    exit;
  end;
  checkDirectory(g_tempFilePath);
  fileprex:=extractFileName(fileName);
  index:=Pos('.',fileprex);
  if index < 1 then
    exit;
  fileprex:=Copy(fileprex,1,index-1);

  commandLine:='"'+g_pluginFilePath + DECOMPILER_EXE_PLUGIN+'" -o -sjava -d "..\temp" "' + fileName + '"';
  //showmessage(commandLine);
  FillChar(zAppName, Sizeof(zAppName), #0);
  StrPCopy( zAppName, commandLine );

  FillChar(StartupInfo, Sizeof(StartupInfo), #0);
  StartupInfo.cb := Sizeof(StartupInfo);
  StartupInfo.dwFlags := STARTF_USESHOWWINDOW;
  StartupInfo.wShowWindow := SW_HIDE;
  //创建进程
  if  CreateProcess(nil,zAppName, nil, nil, false,
    CREATE_NEW_CONSOLE,nil,nil, StartupInfo, ProcessInfo) then
  begin
    WaitForSingleObject(ProcessInfo.hProcess, INFINITE);
    GetExitCodeProcess( ProcessInfo.hProcess, rs );
    CloseHandle ( ProcessInfo.hProcess );
    CloseHandle ( ProcessInfo.hThread );
    if not FileExists(g_tempFilePath+fileprex+'.java') then
    begin
      ShowError(getErrorMsg('DeCompileError'),MB_OK);
      exit;
    end else
    begin
      list:=TStringList.Create;
      list.LoadFromFile(g_tempFilePath+fileprex+'.java');
      if list.count >1 then
      for i:=list.Count-1 downto 0 do
       if pos('//',list[i])=1 then
         list.Delete(i);
      list.SaveToFile(g_tempFilePath + fileprex + '.java');
      list.Free;
      DoOpenFile(g_tempFilePath + fileprex + '.java');
    end;
  end;
end;

procedure TIDEFrm.actAnalysisClassExecute(Sender: TObject);
begin
  if GI_EditorFactory.GetEditorCount <= 0 then
    exit;
  G_PMList.filename:=GI_EditorFactory.Editor[filePageControl.ActivePageIndex].getFileName;
  G_PMList.SynEditor:=GI_EditorFactory.Editor[filePageControl.ActivePageIndex].GetSynEditor;
  if G_PMList.Visible then
    exit;
  G_PMList.allItems.Clear;

end;

procedure TIDEFrm.analysisClassSocketClientConnect(Sender: TObject;
  Socket: TCustomWinSocket);
begin
  G_PMList.AnalysisSocket:=socket;
  if (FileExists(g_jdk_zipsrc_path)) and( jdkApiTV.Items.Count = 0 ) and (ideFrm.G_PMList.AnalysisSocket <> nil) then
    ideFrm.G_PMList.AnalysisSocket.SendText('%%' + #13#10);
end;

procedure TIDEFrm.analysisClassSocketClientDisconnect(Sender: TObject;
  Socket: TCustomWinSocket);
begin
  G_PMList.AnalysisSocket := nil;
end;

procedure TIDEFrm.analysisClassSocketClientRead(Sender: TObject;
  Socket: TCustomWinSocket);
var
  netPackage,pack:WideString;
  posPack:Integer;
  command,rs,con:wideString;
  line:String;
  indexNR:Integer;
  data:TCompileErrorData;
  reg:TRegExpr;
begin
  g_socket_live:=true;
  netPackage := socket.ReceiveText;
  if (pos('</package>',netPackage) = 0 ) then //表示该包还没有结束，开始组装包
  begin
    g_analysisPackage := g_analysisPackage + netPackage;
    exit;
  end else
    g_analysisPackage := g_analysisPackage + netPackage;

  try
    g_analysisPackage:=AnsiReplaceStr(g_analysisPackage,#12,'');
    while ( pos('</package>',g_analysisPackage) > 0) do
    begin
      posPack := Pos('</package>',g_analysisPackage) ;
      pack := copy(g_analysisPackage,1,posPack-1+Length('</package>'));
      g_analysisPackage := copy(g_analysisPackage,posPack+Length('</package>'),Length(g_analysisPackage));
      try
        parsePackage(pack,command,rs,con);
      except
        ;
      end;
      if command = '0' then   //pop up list
        G_PMList.dealWithSendBackData(pack);

      if command = '1' then    //是否为applet
      begin
        if rs = '1' then      //是
        begin
          if workspaceFrm.RunAppletMI.Visible then
            workspaceFrm.RunAppletMI.Enabled:=true;
          if workspaceFrm.debugAppletMI.Visible then
            workspaceFrm.debugAppletMI.Enabled:=true;
          if filePageControl.PageCount > 0 then
          begin
            if GI_EditorFactory.Editor[filePageControl.ActivePageIndex].GetSynEditor.PopupMenu.Items[12].Visible then
               GI_EditorFactory.Editor[filePageControl.ActivePageIndex].GetSynEditor.PopupMenu.Items[12].Enabled:=true;
            if GI_EditorFactory.Editor[filePageControl.ActivePageIndex].GetSynEditor.PopupMenu.Items[14].Visible then
               GI_EditorFactory.Editor[filePageControl.ActivePageIndex].GetSynEditor.PopupMenu.Items[14].Enabled:=true;
            if pagePopupMenu.Items[4].Visible then
               pagePopupMenu.Items[4].Enabled:=true;
            if pagePopupMenu.Items[6].Visible then
               pagePopupMenu.Items[6].Enabled:=true;
          end;
        end else              //否
        begin

        end;
      end;
      if command = '2' then  //类的构造方法，属性，方法列表
      begin
        jdkHelpFrm.refreshMethod(pack,rs);
      end;
      if command = '3' then  //解析java语法
      begin
        if ( rs = '') and ( G_CB<>nil) then
        begin
          if filePageControl.PageCount > 0 then
            PostThreadMessage(G_CB.ThreadID,WM_CLASSBROWSER,Integer(GI_EditorFactory.Editor[filePageControl.ActivePageIndex]),0);
        end
        else
        begin
          PostThreadMessage(G_CB.ThreadID,WM_CLASSBROWSER,0,0);
          while true do
          begin
            indexNR := Pos(#10,rs);
            if indexNR <=0 then
              break;
            line := Copy(rs, 1, indexNR-1 );
            rs := Copy(rs, indexNR+1, length(rs));

            reg:=TRegExpr.Create;
            reg.Expression:=':[0-9]+:';
            reg.Compile;
            if (  reg.Exec(line) )then
            begin
              if  isJavaFile(Copy(line,1,reg.MatchPos[0]-1)) then
              begin
                data:=TCompileErrorData.Create;
                data.FileName:= Copy(line,1,reg.MatchPos[0]-1);
                data.reference:=1;
                data.line:= StrToInt(Copy(reg.Match[0],2,length(reg.Match[0])-2));
                msgFrm.operatorMemo.Lines.AddObject(line,data);
                msgFrm.operatorMemo.ChangeBreakPoint(msgFrm.operatorMemo.Lines.Count);
                msgFrm.operatorMemo.CaretY:=msgFrm.operatorMemo.Lines.Count;
              end;
            end;
            reg.free;
          end;
        end;
      end;

      if command = '4' then  //解析包列表
      begin
        parseJDKPackage(con,jdkApiTV);
      end;

      if command = '5' then  //解析类列表
      begin
        if Assigned(workSpaceFrm) then
          parseJDKClassList(con,rs,jdkApiTV);
      end;

      if command = '6' then  //函数方法属性帮助文档
      begin
        dealWithDocHelp(rs,con);
      end;

      if command = '10' then  //无法解析类
      begin
        msgFrm.operatorMemo.Lines.Add(getErrorMsg('CannotAnalysisClass')+':'+rs) ;
      end;
    end;
    g_analysisPackage := '';
  finally
  end;
  g_socket_live:=false;
end;

procedure TIDEFrm.AppMessage(var Msg: TMsg; var Handled: Boolean);
begin
  if  (Msg.hwnd <> packageListBox.Handle) and ( (Msg.message = WM_LBUTTONDOWN )
                                            or  (Msg.message =WM_RBUTTONDOWN)
                                             or  (Msg.message = WM_NCLBUTTONDOWN)
                                               or  (Msg.message = WM_NCRBUTTONDOWN)  )then
  begin
    if packageListBox.Visible then
    begin
      if packageListBox.Visible then
        packageListBox.Visible:=false;
    end;
  end;

  if  (Msg.hwnd <> G_PMList.Handle) and ( (Msg.message = WM_LBUTTONDOWN )
                                            or  (Msg.message =WM_RBUTTONDOWN)
                                             or  (Msg.message = WM_NCLBUTTONDOWN)
                                               or  (Msg.message = WM_NCRBUTTONDOWN)  )then
  begin

    if G_PMList.Visible then
    begin
      if G_PMList.Visible then
        G_PMList.Visible:=false;
    end;

    if G_PMList.EditHintWnd.Visible then
    begin
      G_PMList.EditHintWnd.Visible:=false;  
      G_PMList.EditHintWnd.ActivateHint(Rect(0, 0, 0, 0), '');
      G_PMList.Update;
    end;
  end;

  Handled := false;
end;

procedure TIDEFrm.OnDeactivate(Sender: TObject);
begin
    if   G_PMList.Visible then
    begin
      if G_PMList.Visible then
        G_PMList.Visible:=false;
    end;
    if packageListBox.Visible then
    begin
      if packageListBox.Visible then
        packageListBox.Visible:=false;
    end;
    if G_PMList.EditHintWnd.Visible then
    begin
      G_PMList.EditHintWnd.Visible:=false;
      G_PMList.EditHintWnd.ActivateHint(Rect(0, 0, 0, 0), '');
      G_PMList.Update;
    end;    
end;

procedure TIDEFrm.FormResize(Sender: TObject);
begin
  if workSpaceFrm <> nil then
    workSpaceFrm.ManualDock(WorkSpacePanel, nil, alTop);
  if classBrowserFrm <> nil then
  classBrowserFrm.ManualDock(WorkSpacePanel, nil, alBottom);
end;

function TIDEFrm.CloseProject:Boolean;
var
  i: integer;
begin
  result:=true;
  if GI_EditorFactory <> nil then
  begin
    if not CanCloseAll then
      exit;
    i := GI_EditorFactory.GetEditorCount - 1;
    // close all editor childs
    while i >= 0 do begin
      GI_EditorFactory.GetEditor(i).Close;
      Dec(i);
      if g_CancelSave then
      begin
        result:=false;
        exit;
      end;
    end;
  end;

  if G_Project <> nil then
  begin
    SaveProject(G_Project);
    if ( CommandsDataModule <> nil ) then
      CommandsDataModule.AddProjectMRUEntry(G_Project.Path+G_Project.fileName);
    G_Project.Destroy;
    G_Project:= nil;
  end;
  updateProjectTreeView(workSpaceFrm.projectTV,false);

  result:=true;
end;

procedure TIDEFrm.actIndentExecute(Sender: TObject);
var
  synedit:TSynEditExt;
begin
  if GI_EditorFactory.GetEditorCount > 0 then
  begin
    synedit:=GI_EditorFactory.Editor[filePageControl.ActivePageIndex].GetSynEditor;
    synedit.DoBlockIndent;
  end;
end;

procedure TIDEFrm.actDesIndentExecute(Sender: TObject);
var
  synedit:TSynEditExt;
begin
  if GI_EditorFactory.GetEditorCount > 0 then
  begin
    synedit:=GI_EditorFactory.Editor[filePageControl.ActivePageIndex].GetSynEditor;
    synedit.DoBlockUnIndent;
  end;
end;

procedure TIDEFrm.actIndentUpdate(Sender: TObject);
begin
  actIndent.Enabled:= (GI_EditorFactory.GetEditorCount > 0);

end;

procedure TIDEFrm.actDesIndentUpdate(Sender: TObject);
begin
  actDesIndent.Enabled:= (GI_EditorFactory.GetEditorCount > 0);
end;

procedure TIDEFrm.ActAddPackageExecute(Sender: TObject);
var
  packageName:String;
  i:Integer;
begin
  if G_Project = nil then
  begin
    ShowError(getErrorMsg('ProjectNotExist'),0);
    exit;
  end;
  if InputQuery(getErrorMsg('InputQueryCaption'), getErrorMsg('PleaseInputPackageName'), packageName) then
  begin
    for i:=0 to G_Project.packageList.Count-1 do
      if TPackage(G_Project.packageList[i]).name = trim(packageName) then
      begin
        ShowError(getErrorMsg('PackageNameExist'),0);
        exit;
      end;

    //检测是否为合法的包名，???,功能保留
    if not IsValidPackageName(packageName) then
    begin
       showError(getErrorMsg('InvalidPackageName'));
       exit;
    end;
    addPackage(packageName);
  end;
end;

procedure TIDEFrm.ActAddPackageUpdate(Sender: TObject);
begin
  actAddPackage.Enabled:=(G_Project <> nil);
end;

procedure TIDEFrm.actRenamePackageExecute(Sender: TObject);
var
  packageName,oldFileName,newFileName:String;
  i,j:Integer;
  LEditor: IEditor;
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

  packageName:=TPackage(workSpaceFrm.projectTV.Selected.data).name;
  if InputQuery(getErrorMsg('InputQueryCaption'), getErrorMsg('PleaseInputPackageName'), packageName) then
  begin
    if packageName = '' then
      exit;
    if  TPackage(workSpaceFrm.projectTV.Selected.data).name = packageName then
      exit;
    for i:=0 to G_Project.packageList.Count-1 do
      if TPackage(G_Project.packageList[i]).name = trim(packageName) then
      begin
        ShowError(getErrorMsg('PackageNameExist'),0);
        exit;
      end;

    //检测是否为合法的包名，???,功能保留
    if not IsValidPackageName(packageName) then
    begin
       showError(getErrorMsg('InvalidPackageName'));
       exit;
    end;
    //创建目录
    if not DirectoryExists(G_Project.Path+translatePackage(packageName)) then
      ForceDirectories(G_Project.Path+translatePackage(packageName));
    //移动文件
    for i:=0 to TPackage(workSpaceFrm.projectTV.Selected.data).fileList.Count-1 do
    begin
      oldFileName:=getFileFromSubFile(TSubFile(TPackage(workSpaceFrm.projectTV.Selected.data).fileList[i]));
      newFileName:=G_Project.Path+translatePackage(packageName)+TSubFile(TPackage(workSpaceFrm.projectTV.Selected.data).fileList[i]).name;
      moveFile(Pchar(oldFileName),PChar(newFileName));
      TSubFile(TPackage(workSpaceFrm.projectTV.Selected.data).fileList[i]).package:=packageName;
      TSubFile(TPackage(workSpaceFrm.projectTV.Selected.data).fileList[i]).path:=G_Project.Path+translatePackage(packageName);

      // change the file name if  the editor if already open for this file
      Assert(GI_EditorFactory <> nil);
      for j := GI_EditorFactory.GetEditorCount - 1 downto 0 do
      begin
        LEditor := GI_EditorFactory.Editor[j];
        if CompareText(LEditor.GetFileName, oldFileName) = 0 then
        begin
          LEditor.SetFileName(newFileName);
          break;
        end;
      end;
      //提示是否更新包名；
      changePackageName(newFileName,packageName);
    end;
    //更新工程文件
    TPackage(workSpaceFrm.projectTV.Selected.data).name:=packageName;
    //更新节点树
    workSpaceFrm.projectTV.Selected.Text:=packageName;
    //保存工程
    saveProject(G_Project);
  end;
end;


procedure TIDEFrm.actRenamePackageUpdate(Sender: TObject);
begin
  actRenamePackage.Enabled:= ( ( G_Project <> nil) and (workSpaceFrm.ProjectTV.Selected <> nil) and  ( TTag(workSpaceFrm.ProjectTV.Selected.data).tag = PACKAGE_TAG ) );
end;

procedure TIDEFrm.ActDeletePackageUpdate(Sender: TObject);
begin
  ActDeletePackage.Enabled:= ( ( G_Project <> nil) and (workSpaceFrm.ProjectTV.Selected <> nil) and  ( TTag(workSpaceFrm.ProjectTV.Selected.data).tag = PACKAGE_TAG ) );
end;

procedure TIDEFrm.ActDeletePackageExecute(Sender: TObject);
var
  pack:TPackage;
  subFile:TSubFile;
  i,j:Integer;
  fileName:String;
  LEditor: IEditor;
begin
  if GetNodeTag(workSpaceFrm.ProjectTV.Selected) = PACKAGE_TAG then
  begin
    if ShowError(self.handle,Format(getErrorMsg('ConfirmDeletePackage'),[#13#10]),getErrorMsg('ConfirmCaption'),MB_OKCANCEL) = IDCANCEL then
      exit;
    pack:=TPackage(workSpaceFrm.projectTV.Selected.Data);

    for i:=pack.fileList.Count-1 downto 0 do
    begin
        subFile:=TSubFile(pack.fileList[i]);
        fileName := getFileFromSubFile(subFile);
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
    end;
    // delete pack;
    G_Project.deletePackage(pack);
    //保存工程
    saveProject(G_Project);

  end;
end;

procedure TIDEFrm.actSearchInProjectUpdate(Sender: TObject);
begin
  actSearchInProject.Enabled:=(G_Project <> nil );
end;

procedure TIDEFrm.actSearchInProjectExecute(Sender: TObject);
var
  searchTxt,filename:String;
  i,j,k:Integer;
  subfile:TSubFile;
  LEditor: IEditor;
  found:Boolean;
  finddata:TFindTextData;
  dlg: TTextSearchDialog;
  edit:TSynEdit;
  Options: TSynSearchOptions;
begin
  dlg := TTextSearchDialog.Create(self);
  with dlg do
  begin
    cbSearchFromCursor.Enabled:=false;
    cbSearchSelectedOnly.Enabled:=false;
    rgSearchDirection.Enabled:=false;

    SearchWholeWords := gbSearchWholeWords;
    SearchTextHistory := gsSearchTextHistory;
    SearchCaseSensitive := gbSearchCaseSensitive;
    SearchText := gsSearchText;
  end;

  if dlg.ShowModal = mrOk then
  begin
    if dlg.cbSearchText.Text = '' then
      exit;
    gbSearchCaseSensitive := dlg.SearchCaseSensitive;
    gbSearchWholeWords := dlg.SearchWholeWords;
    gsSearchText := dlg.SearchText;
    gsSearchTextHistory := dlg.SearchTextHistory;

    searchTxt := dlg.cbSearchText.Text;
    edit:=TSynEdit.Create(self);
    edit.Visible:=false;
    Options:=[];
    if dlg.SearchCaseSensitive then
      Include(Options, ssoMatchCase);
    if dlg.SearchWholeWords then
      Include(Options, ssoWholeWord);

    msgFrm.ClearFindItems;
    msgFrm.setActivePage(FINDPAGE);
    //对工程内的每个文件
    for i:=0 to G_Project.packageList.Count-1 do
    begin
      for j:=0 to TPackage(G_Project.packageList[i]).fileList.Count-1 do
      begin
        subfile:=TSubFile(TPackage(G_Project.packageList[i]).fileList[j]);
        //该文件是否已经打开，如果打开，查找内容为编辑器内的内容，否则从文件内取内容
        filename:=getFileFromSubFile(subfile);
        found:=false;
        for k:=0  to GI_EditorFactory.GetEditorCount - 1 do
        begin
          LEditor := GI_EditorFactory.Editor[k];
          if CompareText(LEditor.GetFileName,filename) = 0 then
          begin
            edit.Lines.text:=LEditor.GetFileContent;
            found:=true;
            break;
          end;
        end;

        if not found then
          edit.Lines.LoadFromFile(filename);

        while edit.SearchReplace(searchTxt, '', Options) <> 0 do
        begin
            finddata:=TFindTextData.Create;
            finddata.fileName:=filename;
            finddata.BlockBegin:=edit.BlockBegin;
            finddata.BlockEnd:=edit.BlockEnd;
            msgFrm.addFindResult(filename+':        ' + edit.Lines[edit.blockbegin.y-1],finddata);
        end;
      end;
    end;
  end;
end;

procedure TIDEFrm.actReplaceInProjectUpdate(Sender: TObject);
begin
  actReplaceInProject.Enabled:=(G_Project <> nil );

end;

procedure TIDEFrm.actReplaceInProjectExecute(Sender: TObject);
var
  searchTxt,replaceTxt,filename:String;
  i,j,k:Integer;
  subfile:TSubFile;
  LEditor: IEditor;
  found:Boolean;
  //finddata:TFindTextData;
  dlg: TTextReplaceDialog;
  edit:TSynEdit;
  Options: TSynSearchOptions;
  oldReplaceProcedure:TReplaceTextEvent;
begin
  dlg := TTextReplaceDialog.Create(self);
  with dlg do
  begin
    cbSearchFromCursor.Enabled:=false;
    cbSearchSelectedOnly.Enabled:=false;
    rgSearchDirection.Enabled:=false;

    SearchWholeWords := gbSearchWholeWords;
    SearchTextHistory := gsSearchTextHistory;
    SearchCaseSensitive := gbSearchCaseSensitive;
    ReplaceTextHistory :=  gsReplaceTextHistory ;
    SearchText := gsSearchText;
    ReplaceText :=gsReplaceText;
  end;

  if dlg.ShowModal = mrOk then
  begin
    if dlg.cbSearchText.Text = '' then
      exit;

    gbSearchCaseSensitive := dlg.SearchCaseSensitive;
    gbSearchWholeWords := dlg.SearchWholeWords;
    gsSearchText := dlg.SearchText;
    gsSearchTextHistory := dlg.SearchTextHistory;
    gsReplaceTextHistory := dlg.ReplaceTextHistory;
    gsReplaceText := dlg.ReplaceText;

    searchTxt := dlg.cbSearchText.Text;
    replaceTxt := dlg.cbReplaceText.Text;

    Options:=[ssoReplaceAll];
    if dlg.SearchCaseSensitive then
      Include(Options, ssoMatchCase);
    if dlg.SearchWholeWords then
      Include(Options, ssoWholeWord);
    Include(Options, ssoWholeWord);
    //msgFrm.ClearFindItems;
    //msgFrm.setActivePage(FINDPAGE);
    //对工程内的每个文件
    for i:=0 to G_Project.packageList.Count-1 do
    begin
      for j:=0 to TPackage(G_Project.packageList[i]).fileList.Count-1 do
      begin
        subfile:=TSubFile(TPackage(G_Project.packageList[i]).fileList[j]);
        //该文件是否已经打开，如果打开，查找内容为编辑器内的内容，否则从文件内取内容
        filename:=getFileFromSubFile(subfile);
        found:=false;
        for k:=0  to GI_EditorFactory.GetEditorCount - 1 do
        begin
          LEditor := GI_EditorFactory.Editor[k];
          if CompareText(LEditor.GetFileName,filename) = 0 then
          begin
            LEditor.GetSynEditor.CaretXY:=Point(1,1);
            oldReplaceProcedure:=LEditor.GetSynEditor.OnReplaceText;
            LEditor.GetSynEditor.OnReplaceText:=nil;
            LEditor.GetSynEditor.SearchReplace(searchTxt, replaceTxt, Options);
            LEditor.GetSynEditor.OnReplaceText:= oldReplaceProcedure;
            found:=true;
            break;
          end;
        end;

        if not found then
        begin
          edit:=TSynEdit.Create(self);
          edit.Visible:=false;
          edit.Lines.LoadFromFile(filename);
          edit.SearchReplace(searchTxt, replaceTxt, Options);
          edit.Lines.SaveToFile(filename);
          edit.free;
        end;

      end;
    end;
  end;
  dlg.free;

end;
{
本周需要实现的功能
1、导入工程
2、版本化工程
3、工程内查找       ok
4、工程内查找替换   ok
5、移动文件         ok
6、工程文件属性
}
procedure TIDEFrm.actProjectPropertyExecute(Sender: TObject);
var
  propertyFrm:TprojectPropertyFrm;
  s:String;
begin
  propertyFrm:=TprojectPropertyFrm.create(nil,UPDATE_PROJECT);
    if G_Project.projectType = JAVAAPPLICATION then
    begin
      propertyFrm.MainClassTS.TabVisible:=true;
      propertyFrm.webAppTS.TabVisible:=false;
    end;
    if G_Project.projectType = WEBAPPLICATION then
    begin
      propertyFrm.MainClassTS.TabVisible:=false;
      propertyFrm.webAppTS.TabVisible:=true;
    end;

  if propertyFrm.ShowModal = mrOK then
  begin
    G_Project.name:=propertyFrm.pro_name_edit.Text;

    G_Project.lastModifiedDateTime:=FormatDateTime('yyyy-mm-dd hh:nn:ss',now);

    if  propertyFrm.pro_javatype_rb.Checked then
      G_Project.projectType:=JAVAAPPLICATION
    else
      G_Project.projectType:=WEBAPPLICATION;

    G_Project.cfg.author := propertyFrm.pro_author_edit.Text;
    G_Project.cfg.parameter:=propertyFrm.parametersEdit.Text;
    G_Project.cfg.version:=propertyFrm.version_lbl.Caption;

    G_Project.cfg.classPath:=AnsiReplaceStr(propertyFrm.cpListBox.Items.Text,#13#10,';');
    if (  (propertyFrm.ClassTreeView.Selected <> nil)
         and (TTag(propertyFrm.ClassTreeView.Selected.Data).tag = FILE_TAG )  )  then
    begin
      G_Project.cfg.mainClassPackage := TSubFile(propertyFrm.ClassTreeView.Selected.Data).package;
      s:= TSubFile(propertyFrm.ClassTreeView.Selected.Data).name;
      G_Project.cfg.mainClassName := Copy(s,1,pos('.java',s)-1) ;
    end else
    begin
      G_Project.cfg.mainClassPackage := '';
      G_Project.cfg.mainClassName := '';
    end;
    saveProject(G_Project);

  end;
  propertyFrm.Free;
end;


procedure TIDEFrm.actProjectPropertyUpdate(Sender: TObject);
begin
  actProjectProperty.Enabled:= not( G_Project = nil);
end;

procedure TIDEFrm.actCompileJavaFileUpdate(Sender: TObject);
begin
  actCompileJavaFile.Enabled:= ( G_Project <> nil )
    or ( (workSpaceFrm.projectTV.Selected <> nil)   and ( TTag(workSpaceFrm.projectTV.Selected.data).tag = FILE_TAG ) and ( Pos('.java',TTag(workSpaceFrm.projectTV.Selected.data).name) > 0   ) )
    or ( ( FilePageControl.PageCount > 0)  and (Pos('.java',GI_EditorFactory.Editor[FilePageControl.ActivePageIndex].GetFileName) >0 ) );
end;

procedure TIDEFrm.actCompileJavaFileExecute(Sender: TObject);
var
  fn:String;
  pack:String;
begin
  if ( ( FilePageControl.PageCount > 0)  and (Pos('.java',GI_EditorFactory.Editor[FilePageControl.ActivePageIndex].GetFileName) >0 ) ) then
  begin
    FindPackage(GI_EditorFactory.Editor[FilePageControl.ActivePageIndex].GetFileContent,pack);
    CompileJava(GI_EditorFactory.Editor[FilePageControl.ActivePageIndex].GetFileName,pack,false);
    exit;
  end;

  if ( (workSpaceFrm.projectTV.Selected <> nil)   and ( TTag(workSpaceFrm.projectTV.Selected.data).tag = FILE_TAG ) and ( Pos('.java',TTag(workSpaceFrm.projectTV.Selected.data).name) > 0   ) ) then
  begin
    CompileJava(TSubFile(workSpaceFrm.projectTV.Selected.Data),false);
    exit;
  end;

  if G_Project <> nil then
    if G_Project.cfg.mainClassName = '' then
    begin
      actProjectPropertyExecute(nil);
    end else
    begin
      if G_Project.cfg.mainClassPackage = '' then
        fn:=G_Project.Path + G_Project.cfg.mainClassName+'.java'
      else
        fn:=G_Project.Path + translatePackage(G_Project.cfg.mainClassPackage) + G_Project.cfg.mainClassName+'.java';
      if FileExists(fn) then
        CompileJava(fn,G_Project.cfg.mainClassPackage,false)
      else
      begin
        showError(getErrorMsg('MainClassNotExist'),MB_OK or MB_ICONWARNING);
        actProjectPropertyExecute(nil);
      end;
    end;
end;

procedure TIDEFrm.pagePopupMenuPopup(Sender: TObject);
var
  editor:IEditor;
  className,packageName:String;
begin
    debugAppletMi.Enabled:=false;
    runAppletMI.Enabled:=false;
    editor:=GI_EditorFactory.Editor[FilePageControl.ActivePageIndex];
    if ( Pos('.java',editor.GetFileName) > 0 ) then
    begin
      compilePopupMI.Enabled:=true;

      if not findMainMethod(editor.getFileContent) then
      begin
        runPopupMI.Enabled:=false;
        debugRunPopupMI.Enabled:=false;
      end
      else
      begin
        runPopupMI.Enabled:=true;
        debugRunPopupMI.Enabled:=true;
      end;
      className := ExtractFileName(editor.GetFileName);
      className := Copy(className,1,length(className)-length('.java'));
      if not FindAppointedString(editor.getFileContent,
                  'class\s+'+className+'\s+extends\s+(Applet|JApplet|java.applet.Applet|javax.swing.JApplet)\s*\{') then
      begin
        debugAppletMi.Enabled:=false;
        runAppletMI.Enabled:=false;
        //发送一个命令，测试是不是Applet类的子类
        if  ideFrm.G_PMList.AnalysisSocket <> nil then
        begin
          if not FindPackage(editor.getFileContent,packageName) then
          begin
            ideFrm.G_PMList.AnalysisSocket.SendText('!!'
                 + className + ';'
                 + findPathNoPackage(editor.GetFileName,packageName)
                 + #13#10);
          end
          else
          begin
            ideFrm.G_PMList.AnalysisSocket.SendText('!!'
                  + packageName+'.' + className+ ';'
                  + findPathNoPackage(editor.GetFileName,packageName)
                  + #13#10);
          end;
        end;
      end else
      begin
        debugAppletMi.Enabled:=true;
        runAppletMI.Enabled:=true;
      end;

    end else
    begin
      compilePopupMI.Enabled:=false;
      runPopupMI.Enabled:=false;
      debugRunPopupMI.Enabled:=false;
    end;
end;

procedure TIDEFrm.actCompileAllJavaFileExecute(Sender: TObject);
var
  i,j,count:Integer;
  pack:TPackage;
  subFile:TSubFile;
begin
  count:=0;
  //g_CancelCompile:=false;
  if ShowError(getErrorMsg('CompileAllWarning'),MB_OKCANCEL or MB_ICONWARNING) <> IDOK then
    exit;

  for i:=0 to G_Project.packageList.Count-1 do
  begin
    pack:=TPackage(G_Project.packageList[i]);
    for j:=0 to pack.fileList.Count-1 do
    begin
      subFile:=TSubFile(pack.fileList[j]);
      if Pos('.java',getFileFromSubFile(subFile)) > 0 then
      begin
        CompileJava(subFile,false);
        count:=count+1;
        //if g_CancelCompile then
        //  exit;
      end;
    end;
  end;
  if Count = 0 then
  begin
    ShowError(getErrorMsg('ProjectNoJavaFile'),MB_OK or MB_ICONWARNING);
  end;
end;

procedure TIDEFrm.actCompileAllJavaFileUpdate(Sender: TObject);
begin
  actCompileAllJavaFile.Enabled:=G_Project <> nil;
end;

procedure TIDEFrm.actSetupBpUpdate(Sender: TObject);
begin
  actSetupBp.Enabled := (filePageControl.PageCount > 0 )
     and (GI_EditorFactory.Editor[FilePageControl.ActivePageIndex].GetSynEditor.Focused)
     and (Pos('.java',GI_EditorFactory.Editor[FilePageControl.ActivePageIndex].GetFileName) > 0);
end;

procedure TIDEFrm.actClearBpExecute(Sender: TObject);
var
  editor:IEditor;
begin
  editor := GI_EditorFactory.Editor[FilePageControl.ActivePageIndex];
  editor.GetSynEditor.ClearBreakPoint;
end;

procedure TIDEFrm.actClearBpUpdate(Sender: TObject);
begin
  actClearBp.Enabled := (filePageControl.PageCount > 0 )
     and (Pos('.java',GI_EditorFactory.Editor[FilePageControl.ActivePageIndex].GetFileName) > 0);
end;


procedure TIDEFrm.actDebugProjectExecute(Sender: TObject);
var
  fn:String;
  subFile:TSubFile;
begin
  DebugForm.Show;
  DebugForm.Update;

  if  G_Project.cfg.mainClassName = '' then
  begin
    showError(getErrorMsg('PleaseSetupMainClass'),MB_OK or MB_ICONWARNING);
    actProjectPropertyExecute(nil);
    exit;
  end;
  
  if G_Project.cfg.mainClassPackage = '' then
    fn:=G_Project.Path + G_Project.cfg.mainClassName+'.java'
  else
    fn:=G_Project.Path + translatePackage(G_Project.cfg.mainClassPackage) + G_Project.cfg.mainClassName+'.java';

  subFile := G_Project.findSubFileByName(fn);
  if subFile = nil then
  begin
    showError(getErrorMsg('MainClassNotExist'),MB_OK or MB_ICONWARNING);
    actProjectPropertyExecute(nil);
    exit;
  end;

  if not FileExists(getFileFromSubFile(subFile)) then
  begin
    showError(getErrorMsg('MainClassNotExist'),MB_OK or MB_ICONWARNING);
    actProjectPropertyExecute(nil);
    exit;
  end;

  DebugApp(subFile.getClassName,subFile.package,getFileFromSubFile(subFile),false);

end;

procedure TIDEFrm.runPopupMIClick(Sender: TObject);
var
  subFile:TSubFile;
  editor:IEditor;
  fn,className,packageName:String;
  index:Integer;
begin
  editor:=GI_EditorFactory.Editor[FilePageControl.ActivePageIndex];
  fn:=editor.GetFileName;
  if  G_Project <> nil then
    subFile := G_Project.findSubFileByName(fn)
  else
    subFile := nil;

  FindPackage(editor.GetFileContent,packageName);

  if subFile <> nil then
  begin
    if packageName <> subFile.package then
    begin
      if MessageBox(handle,PChar(Format(getErrorMsg('PackageNotMatch'),[ExtractFileName(fn),subFile.package,#13#10,packageName])),
                    PChar(getErrorMsg('ErrorDlgCaption')),
                    MB_OKCANCEL or MB_ICONWARNING) <> IDOK then
        exit;
    end;
    if (sender as TComponent).Tag = 0 then
      G_curApp.RunApp(subFile.getClassName,subFile.package,getFileFromSubFile(subFile),false,false)
    else
      G_curApp.RunApp(subFile.getClassName,subFile.package,getFileFromSubFile(subFile),false,true);

    exit;
  end else
  begin
    index:=Pos('.java',LowerCase(ExtractFileName(fn)));
    if index <= 0 then
      exit;
    className:=Copy(ExtractFileName(fn),1,index-1);
    G_curApp.RunApp(className,packageName,fn,false,false);
  end;
end;


procedure TIDEFrm.actRunProjectUpdate(Sender: TObject);
begin
  actRunProject.Enabled:=G_Project <> nil ;
end;

procedure TIDEFrm.actRunProjectExecute(Sender: TObject);
var
  fn:String;
  subFile:TSubFile;
begin
  if  G_Project.cfg.mainClassName = '' then
  begin
    showError(getErrorMsg('PleaseSetupMainClass'),MB_OK or MB_ICONWARNING);
    actProjectPropertyExecute(nil);
    exit;
  end;
  
  if G_Project.cfg.mainClassPackage = '' then
    fn:=G_Project.Path + G_Project.cfg.mainClassName+'.java'
  else
    fn:=G_Project.Path + translatePackage(G_Project.cfg.mainClassPackage) + G_Project.cfg.mainClassName+'.java';

  subFile := G_Project.findSubFileByName(fn);
  if subFile = nil then
  begin
    showError(getErrorMsg('MainClassNotExist'),MB_OK or MB_ICONWARNING);
    actProjectPropertyExecute(nil);
    exit;
  end;

  if not FileExists(getFileFromSubFile(subFile)) then
  begin
    showError(getErrorMsg('MainClassNotExist'),MB_OK or MB_ICONWARNING);
    actProjectPropertyExecute(nil);
    exit;
  end;

  G_curApp.RunApp(subFile.getClassName,subFile.package,getFileFromSubFile(subFile),true,false);

end;

procedure TIDEFrm.actTerminateUpdate(Sender: TObject);
begin
  actTerminate.Enabled:=(G_curAPP <> nil) and (G_curAPP.status = 1);
end;

procedure TIDEFrm.actTerminateExecute(Sender: TObject);
begin
  G_curApp.EndRun;
end;

procedure TIDEFrm.analysisClassSocketClientError(Sender: TObject;
  Socket: TCustomWinSocket; ErrorEvent: TErrorEvent;
  var ErrorCode: Integer);
begin
  try
    ;
  except
    on ESocketError do
    begin
        G_PMList.AnalysisSocket := nil;
        msgFrm.operatorMemo.Lines.Add(Format(getErrorMsg('AnalysisProcessHalt'),[#13#10]));
    end;
  end;
end;

procedure TIDEFrm.actVersionUpdate(Sender: TObject);
begin
  actVersion.Enabled:=(G_Project <> nil);
end;

procedure TIDEFrm.actVersionExecute(Sender: TObject);
var
  tempPath:String;
  i,j:Integer;
  pack:TPackage;
  subfile:TSubFile;
  jarFileList:TStringList;
  start:TStartupInfo;
  pi:TProcessInformation;
  commandLine,iniPath:String;
  progressFrm:TProgressFrm;
begin
    versionFrm.Caption:='Version project';
    versionFrm.proNameLbl.caption:=G_Project.name;
    versionFrm.versionEdit.Color:=clWhite;
    versionFrm.versionEdit.ReadOnly:=false;
    versionFrm.versionEdit.text:=G_Project.cfg.version;
    versionFrm.importJavaCB.Checked:=true;
    versionFrm.importJavaCB.Enabled:=false;
    versionFrm.importResCB.Checked:=true;
    versionFrm.importResCB.Enabled:=false;
    versionFrm.importClassCB.Checked:=false;
    versionFrm.importClassCB.Enabled:=false;
    versionFrm.selDebugCB.Checked:=false;
    versionFrm.selDebugCB.Enabled:=false;
    versionFrm.selCompressCB.Checked:=true;
    versionFrm.selCompressCB.Enabled:=true;
    versionFrm.selOverrideCB.Checked:=false;
    versionFrm.selOverrideCB.Enabled:=true;
    versionFrm.versionBtn.Caption:='&Version';

    if versionFrm.ShowModal = mrOK then
    begin
      if not versionFrm.selOverrideCB.Checked and FileExists( versionFrm.jarFileName ) then
      begin
        if showerror(self.Handle,Format(getErrorMsg('OverrideFileReally'),[versionFrm.jarFileName,#13#10]),getErrorMsg('ConfirmCaption'),MB_OKCANCEL or MB_ICONWARNING) <> IDOK then
          exit;
      end;
      //显示进度条
      msgFrm.operatorMemo.Lines.add('Begin version project');
      progressFrm:=TProgressFrm.Create(self);
      progressFrm.Label1.Caption:='versioning project,please keep waiting......';
      progressFrm.Label2.Visible:=false;
      progressFrm.filename_lbl.Visible:=false;
      progressFrm.Show;
      progressFrm.Update;
      //检查临时路径是否存在，不存在，创建之
      tempPath:=g_tempFilePath+G_Project.name+'\';
      iniPath:=g_tempFilePath+G_Project.name + #0;
      if DirectoryExists(tempPath) then
        DelDir(iniPath);
      ForceDirectories(tempPath);
      jarFileList:=TStringList.Create;
      jarFileList.Add('.\'+G_Project.fileName);
      CopyFile(PChar(AssembleFileName(G_Project.Path,G_Project.fileName)),PChar(tempPath+G_Project.fileName),false);

      //拷贝需要打包的文件
      for i:=0 to G_Project.packageList.Count-1 do
      begin
        pack:=TPackage(G_Project.packageList[i]);
        for j:=0 to pack.fileList.Count-1 do
        begin
          subfile:=TSubFile(pack.fileList[j]);
          if not DirectoryExists(tempPath + TranslatePackage(subfile.package)) then
            ForceDirectories(tempPath + TranslatePackage(subfile.package));
          CopyFile(PChar(getFileFromSubFile(subfile)),PChar(tempPath + TranslatePackage(subfile.package) + subfile.name),false);
          jarFileList.Add('.\'+TranslatePackage(subfile.package) + subfile.name);
        end;
      end;
      //开始打包
      FillChar(Start, Sizeof(Start), #0);
      with start do
      begin
        cb := SizeOf(start);
        dwFlags := STARTF_USESHOWWINDOW;
        wShowWindow := SW_HIDE;//设置窗口是否显示
      end;
      if versionFrm.selCompressCB.Checked then
        commandline := g_javaJar + ' cvf ' + versionFrm.jarFileName + ' '
      else
        commandline := g_javaJar + ' cvf0 ' + versionFrm.jarFileName + ' ';
      for i:=0 to jarFileList.Count-1 do
      begin
        commandline :=commandline + ' "' + jarFileList[i] + '" ';
      end;

      if  CreateProcess(nil,@commandline[1], @g_Security, @g_Security, true,
        CREATE_NEW_CONSOLE or NORMAL_PRIORITY_CLASS,nil,@iniPath[1], start, pi) then  //如果创建新进程成功
      begin
        WaitforSingleObject( pi.hProcess, 10000);
      end;
      if FileExists(versionFrm.jarFileName) then
      begin
        g_JarComment:=JDEVJARFILETAG+ G_Project.fileName + #13#10
                       + 'project name='+g_Project.name+#13#10
                        + 'project version='+g_project.cfg.version+#13#10
                         + '------File Lists------'+#13#10;
        for i:=0 to jarFileList.Count-1 do
        begin
          g_JarComment:= g_JarComment + jarFileList[i]+ #13#10;
        end;

        ZipFiles(versionFrm.jarFileName);
        G_Project.cfg.version:=versionFrm.versionEdit.Text;
        SaveProject(G_Project);
      end;

      //删除临时路径
      jarFileList.free;
      if DirectoryExists(tempPath) then
        DelDir(iniPath);
      progressFrm.Close;
      progressFrm.Free;
      msgFrm.operatorMemo.Lines.add('成功版本化工程：' + versionFrm.jarFileName);
    end;
end;

procedure TIDEFrm.actGenerateJarExecute(Sender: TObject);
var
  tempPath:String;
  i,j:Integer;
  pack:TPackage;
  subfile:TSubFile;
  classFileName:String;
  javaFileList:TStringList;
  jarFileList:TStringList;
  start:TStartupInfo;
  pi:TProcessInformation;
  commandLine,iniPath,command:String;
  progressFrm:TProgressFrm;
begin
    generateJarFrm.proNameLbl.caption:=G_Project.name;
    generateJarFrm.versionEdit.text:=G_Project.cfg.version;
    if generateJarFrm.ShowModal = mrOK then
    begin
      if not generateJarFrm.selOverrideCB.Checked and FileExists( generateJarFrm.jarFileName ) then
      begin
        if showerror(self.Handle,Format(getErrorMsg('OverrideFileReally'),[generateJarFrm.jarFileName,#13#10]),getErrorMsg('ConfirmCaption'),MB_OKCANCEL or MB_ICONWARNING) <> IDOK then
          exit;
      end;
      //显示进度条
      msgFrm.operatorMemo.Lines.add('Begin generating jar file');
      progressFrm:=TProgressFrm.Create(self);
      progressFrm.Label1.Caption:='Generating jar file,please keep waiting......';
      progressFrm.Label2.Visible:=false;
      progressFrm.filename_lbl.Visible:=false;
      progressFrm.Show;
      progressFrm.Update;
      //检查临时路径是否存在，不存在，创建之
      tempPath:=g_tempFilePath+G_Project.name+'\';
      iniPath:=g_tempFilePath+G_Project.name + #0;
      if DirectoryExists(tempPath) then
        DelDir(iniPath);
      ForceDirectories(tempPath);
      javaFileList:=TStringList.Create;
      jarFileList:=TStringList.Create;
      //拷贝需要打包的文件

      for i:=0 to G_Project.packageList.Count-1 do
      begin
        pack:=TPackage(G_Project.packageList[i]);
        for j:=0 to pack.fileList.Count-1 do
        begin

          subfile:=TSubFile(pack.fileList[j]);
          if not DirectoryExists(tempPath + TranslatePackage(subfile.package)) then
            ForceDirectories(tempPath + TranslatePackage(subfile.package));
          if  generateJarFrm.importResCB.Checked and (Pos('.java',LowerCase(subfile.name)) <= 0  ) then
          begin
            copyFile(PChar(getFileFromSubFile(subfile)),PChar(tempPath + TranslatePackage(subfile.package) + subfile.name),false);
            jarFileList.Add('.\'+TranslatePackage(subfile.package) + subfile.name);
          end;
          if isJavaFile(subfile.name) then
          begin
            if copyFile(PChar(getFileFromSubFile(subfile)),PChar(tempPath + TranslatePackage(subfile.package) + subfile.name),false) then
              javaFileList.Add('.\'+TranslatePackage(subfile.package) + subfile.name);
            if  generateJarFrm.importJavaCB.Checked  then
              jarFileList.Add('.\'+TranslatePackage(subfile.package) + subfile.name);
          end;
          if   generateJarFrm.importClassCB.Checked  then
          begin
            classFileName:=Copy(getFileFromSubFile(subFile),1,length(getFileFromSubFile(subFile))-5) + '.class';
            jarFileList.Add('.\'+TranslatePackage(subfile.package) + ExtractFileName(classFileName));
          end;
        end;
      end;
      if generateJarFrm.importJavaCB.Checked and generateJarFrm.importResCB.Checked then
      begin
        jarFileList.Add('.\'+G_Project.fileName);
        CopyFile(PChar(AssembleFileName(G_Project.Path,G_Project.fileName)),PChar(tempPath+G_Project.fileName),false);
      end;

      FillChar(Start, Sizeof(Start), #0);
      with start do
      begin
        cb := SizeOf(start);
        dwFlags := STARTF_USESHOWWINDOW;
        wShowWindow := SW_HIDE;//设置窗口是否显示
      end;
      //必要情况下重新编译java文件
      if ( generateJarFrm.importClassCB.checked ) and (javaFileList.Count > 0) then
      begin
        if generateJarFrm.selDebugCB.Checked then
          commandLine:=g_javac+ ' -g -classpath "' + getAllClassPath + '" '
        else
          commandLine:=g_javac+ ' -classpath "' + getAllClassPath + '" ';

        for i:=0 to javaFileList.Count-1 do
        begin
          command:=commandLine +' "'+ javaFileList[i] + '" '+#0;
          if  CreateProcess(nil,@command[1], @g_Security, @g_Security, true,
            CREATE_NEW_CONSOLE or NORMAL_PRIORITY_CLASS,nil,@iniPath[1], start, pi) then  //如果创建新进程成功
          begin
            //等待进程结束,最长等待时间5秒
            WaitforSingleObject( pi.hProcess, 5000);
          end;
        end;

      end;
      //开始打包
      if generateJarFrm.selCompressCB.Checked then
        commandline := g_javaJar + ' cvf ' + generateJarFrm.jarFileName + ' '
      else
        commandline := g_javaJar + ' cvf0 ' + generateJarFrm.jarFileName + ' ';
      for i:=0 to jarFileList.Count-1 do
      begin
        commandline :=commandline + ' "' + jarFileList[i] + '" ';
      end;

      if  CreateProcess(nil,@commandline[1], @g_Security, @g_Security, true,
        CREATE_NEW_CONSOLE or NORMAL_PRIORITY_CLASS,nil,@iniPath[1], start, pi) then  //如果创建新进程成功
      begin
        WaitforSingleObject( pi.hProcess, 10000);
      end;
      if FileExists(generateJarFrm.jarFileName) and generateJarFrm.importJavaCB.Checked and generateJarFrm.importResCB.Checked  then
      begin
        g_JarComment:=JDEVJARFILETAG+ G_Project.fileName + #13#10
                       + 'project name='+g_Project.name+#13#10
                        + 'project version='+g_project.cfg.version+#13#10
                         + '------File Lists------'+#13#10;
        for i:=0 to jarFileList.Count-1 do
        begin
          g_JarComment:= g_JarComment + jarFileList[i]+ #13#10;
        end;

        ZipFiles(generateJarFrm.jarFileName);
      end;
      //删除临时路径
      javaFileList.Free;
      jarFileList.free;
      if DirectoryExists(tempPath) then
        DelDir(iniPath);
      progressFrm.Close;
      progressFrm.Free;
      msgFrm.operatorMemo.Lines.add('Generated jar file successfully ：' + generateJarFrm.jarFileName);
    end;
end;

procedure TIDEFrm.actGenerateJarUpdate(Sender: TObject);
begin
  actGenerateJar.Enabled:=(G_Project <> nil);
end;

procedure TIDEFrm.actImportProjectExecute(Sender: TObject);
var
  start:TStartupInfo;
  pi:TProcessInformation;
  commandLine,iniPath,propath:String;
  progressFrm:TProgressFrm;
begin
  if importProjectFrm.ShowModal = mrOK then
  begin
    if not closeProject then
      exit;

    progressFrm:=TProgressFrm.Create(self);
    progressFrm.Label1.Caption:='Importing now,please keep waiting......';
    progressFrm.Label2.Visible:=false;
    progressFrm.filename_lbl.Visible:=false;
    progressFrm.Show;
    progressFrm.Update;

    FillChar(Start, Sizeof(Start), #0);
    with start do
    begin
      cb := SizeOf(start);
      dwFlags := STARTF_USESHOWWINDOW;
      wShowWindow := SW_HIDE;//设置窗口是否显示
    end;
    propath:=GetRealPath(GetRealPath(importProjectFrm.destPath)+ importProjectFrm.projectName);
    ForceDirectories(propath);
    CopyFile( PChar(importProjectFrm.jarFileName),PChar(propath+ ExtractFileName(importProjectFrm.jarFileName)),false);
    commandline := g_javaJar + ' xvf ' + propath + ExtractFileName(importProjectFrm.jarFileName) + #0;
    iniPath := propath + #0;
    if  CreateProcess(nil,@commandline[1], @g_Security, @g_Security, true,
      CREATE_NEW_CONSOLE or NORMAL_PRIORITY_CLASS,nil,@iniPath[1], start, pi) then  //如果创建新进程成功
    begin
      WaitforSingleObject( pi.hProcess, 10000);
    end;
    if FileExists(PChar(propath+ ExtractFileName(importProjectFrm.jarFileName))) then
      deleteFile(PChar(propath+ ExtractFileName(importProjectFrm.jarFileName)));

    OpenProject(propath + importProjectFrm.projectFileName);
    progressFrm.Close;
    progressFrm.Free;
  end;
end;

procedure TIDEFrm.actStartupAnalysisServerUpdate(Sender: TObject);
var
  exitcode:DWord;
begin
  GetExitCodeProcess(g_analysisProcessInfo.hProcess, exitcode);
  //如果当前进程没有结束
  actStartupAnalysisServer.Enabled:=exitcode <> STILL_ACTIVE;
end;

procedure TIDEFrm.actStartupAnalysisServerExecute(Sender: TObject);
begin
  StartupAnalysisProcess;
end;

procedure TIDEFrm.actSetupBpExecute(Sender: TObject);
var
  editor:IEditor;
begin
  editor:=GI_EditorFactory.Editor[FilePageControl.ActivePageIndex];

  setBreakPointInEditor(editor,IntToStr(editor.GetSynEditor.CaretY));
end;

procedure TIDEFrm.debugRunPopupMIClick(Sender: TObject);
var
  subFile:TSubFile;
  editor:IEditor;
  fn,className,packageName:String;
  index:Integer;
begin
  editor:=GI_EditorFactory.Editor[FilePageControl.ActivePageIndex];
  fn:=editor.GetFileName;
  if  G_Project <> nil then
    subFile := G_Project.findSubFileByName(fn)
  else
    subFile := nil;

  FindPackage(editor.GetFileContent,packageName);

  if subFile <> nil then
  begin
    if packageName <> subFile.package then
    begin
      if MessageBox(handle,PChar(Format(getErrorMsg('PackageNotMatch'),[ExtractFileName(fn),subFile.package,#13#10,packageName])),
                    PChar(getErrorMsg('ErrorDlgCaption')),
                    MB_OKCANCEL or MB_ICONWARNING) <> IDOK then
        exit;
    end;
    if (sender as TComponent).Tag = 0 then
      DebugApp(subFile.getClassName,subFile.package,getFileFromSubFile(subFile),false)
    else
      DebugApp(subFile.getClassName,subFile.package,getFileFromSubFile(subFile),true);

    exit;
  end else
  begin
    index:=Pos('.java',LowerCase(ExtractFileName(fn)));
    if index <= 0 then
      exit;
    className:=Copy(ExtractFileName(fn),1,index-1);
    DebugApp(className,packageName,fn,false);
  end;
end;


procedure TIDEFrm.actDebugProjectUpdate(Sender: TObject);
begin
  actDebugProject.Enabled:=G_Project <> nil ;
end;

procedure TIDEFrm.debugWindowMIClick(Sender: TObject);
begin
  if debugWindowMI.Checked then
  begin
    debugWindowMI.Checked:=false;
    debugForm.close;
  end else
  begin
    debugWindowMI.Checked:=true;
    debugForm.show;
  end;
end;

procedure TIDEFrm.configurationMIClick(Sender: TObject);
begin
  EnvSetupForm.setupPageControl.ActivePageIndex:=0;
  EnvSetupForm.ShowModal;
end;

procedure TIDEFrm.AboutMIClick(Sender: TObject);
begin
  aboutDlg.ShowModal;
end;

procedure TIDEFrm.SupportMIClick(Sender: TObject);
begin
  ShellExecute(0, nil, PChar('mailto:gongsh@vip.sina.com?SUBJECT=Some Questions'
                  +'&BODY=I have some question about ... '), nil, nil, SW_NORMAL);

end;

procedure TIDEFrm.ToolButton39Click(Sender: TObject);
begin
  aboutDlg.ShowModal;
end;

procedure TIDEFrm.actFindApointTextExecute(Sender: TObject);
begin
  gsSearchText:=findEdit.Text;
  CommandsDataModule.actSearchFindExecute(Sender);
end;

procedure TIDEFrm.actFindApointTextUpdate(Sender: TObject);
begin
  findBtn.Enabled := (GI_SearchCmds <> nil) and GI_SearchCmds.CanFind;;
end;

procedure TIDEFrm.checkLicenseTimerTimer(Sender: TObject);
begin
  CheckValidLicense;
end;

procedure TIDEFrm.registerMIClick(Sender: TObject);
begin
  g_RegForm.showModal;
end;

procedure TIDEFrm.WMRegister(var Msg: TMessage);
begin
  G_VersionType := msg.WParam;
  if ( G_VersionType = TRAILVERSION ) then
  begin
    unregisterPanel.Visible:=true;
    registerMI.Visible:=true;
    orderingMI.Visible:=true;
  end else if ( G_VersionType = REGISTERVERSION ) then
  begin
    unregisterPanel.Visible:=false;
    registerMI.Visible:=false;
    orderingMI.Visible:=false;
  end else
  begin
    //退出
    MessageBox(handle,'You License is invalid or JDev has passed the trial duration.'#13#10'Application will terminate.',
                             'Error Message',MB_OK or MB_ICONWARNING);
    Close;
  end;
end;

procedure TIDEFrm.bugReportMIClick(Sender: TObject);
begin
  ShellExecute(0, nil, PChar('mailto:gongsh@vip.sina.com?SUBJECT=Bug Reports'
                  +'&BODY=I found some bugs in the current version of JDev.'), nil, nil, SW_NORMAL);
end;


procedure TIDEFrm.DropFiles(var Msg:TMessage);
var
  FileName:array [1..256] of char;
  sFN:String;
  i,Count,p:integer;
begin
  Count:=DragQueryFile(Msg.WParam,$FFFFFFFF,@FileName,256);//得到拖放文件的个数
  For i:=0 to Count-1 do
  begin
    DragQueryFile(Msg.WParam,i,@FileName,256);//查询文件名称
    sFN:=FileName;
    p:=pos(chr(0),sFN);//去掉文件名末尾的ASCII码为0的字符
    sFN:=copy(sFN,1,p-1);
    if DirectoryExists(sFN) then
      exit;
    if isAscii(sFN) then
      DoOpenFile(sFN)
    else
    begin
      //MessageBox(NotAsciiFile,);
      ShowError(handle,Format(GetErrorMsg('NotAsciiFile'),[sFN]),
                             GetErrorMsg('ErrorDlgCaption'),MB_OK or MB_ICONWARNING);

    end;
  end;
  DragFinish(Msg.WParam); //释放所使用的资源

end;

procedure TIDEFrm.packageListBoxDblClick(Sender: TObject);
var
  s:String;
  caretWord:String;
  fSyneditor: TSynEdit;
begin
  fSyneditor:=GI_EditorFactory.Editor[filePageControl.ActivePageIndex].GetSynEditor;
  fSyneditor.SetFocus;

  if (packageListBox.ItemIndex >= 0) then
  begin
    caretWord := fSynEditor.GetWordAtRowCol(fSynEditor.CaretXY);
    s:=packageListBox.items[packageListBox.ItemIndex];
    fSynEditor.BlockBegin := Point(fSynEditor.CaretX - length(caretWord),fSynEditor.CaretY);
    fSynEditor.BlockEnd := Point(fSynEditor.CaretX,fSynEditor.CaretY);
    fSynEditor.SelText:= s;
  end;
  packageListBox.visible:=false;
end;

procedure TIDEFrm.packageListBoxClick(Sender: TObject);
var
  fSyneditor: TSynEdit;
begin
  fSyneditor:=GI_EditorFactory.Editor[filePageControl.ActivePageIndex].GetSynEditor;
  fSyneditor.SetFocus;
end;

procedure TIDEFrm.packageListBoxKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
var
  s:String;
  caretWord:String;
  fSyneditor: TSynEdit;
begin
  fSyneditor:=GI_EditorFactory.Editor[filePageControl.ActivePageIndex].GetSynEditor;
  fSyneditor.SetFocus;

  if packageListBox.Visible then
  begin
    if ( (key in [VK_RETURN,VK_SPACE,VK_TAB] ) and (packageListBox.ItemIndex >= 0) ) then
    begin
      caretWord := fSynEditor.GetWordAtRowCol(fSynEditor.CaretXY);
      s:=packageListBox.items[packageListBox.ItemIndex];
      fSynEditor.BlockBegin := Point(fSynEditor.CaretX - length(caretWord),fSynEditor.CaretY);
      fSynEditor.BlockEnd := Point(fSynEditor.CaretX,fSynEditor.CaretY);
      fSynEditor.SelText:= s;
    end;
    if  ( key in [VK_RETURN,VK_SPACE,VK_TAB] )then
       packageListBox.visible:=false;
  end;
end;


procedure TIDEFrm.findClassBtnClick(Sender: TObject);
var
  className:String;
  i:Integer;
  found:Boolean;
begin
  if InputQuery(getErrorMsg('InputQueryCaption'),getErrorMsg('PleaseInputSearchClassName'),className)then
  begin
    found:=false;
    for i:=0 to jdkApiTV.Items.Count-1 do
    begin
      if Pos(LowerCase(className),LowerCase(jdkApiTV.Items[i].Text)) = 1 then
      begin
        jdkApiTV.Selected:=jdkApiTV.Items[i];
        found:=true;
        break;
      end;
    end;
    if not found then
      ShowError(self.Handle,getErrorMsg('NotFindTheClass'),getErrorMsg('ErrorDlgCaption'),MB_OK OR MB_ICONWARNING);
  end;
end;


procedure TIDEFrm.showJDKHelpBtnClick(Sender: TObject);
begin
  
  if jdkHelpFrm.Visible then
  begin
    jdkHelpFrm.Close;
  end
  else
  begin
    jdkHelpFrm.hideBtn.Left:=jdkHelpFrm.RzPageControl1.Width-jdkHelpFrm.hideBtn.Width;
    jdkHelpFrm.Height:=filePageControl.Height - 50;
    jdkHelpFrm.Width:=filePageControl.Width - 80;
    jdkHelpFrm.Left:=ideFrm.mainPanel.left+ filePageControl.Width -25 - jdkHelpFrm.width;
    jdkHelpFrm.Top:=ideFrm.mainPanel.top+Round((filePageControl.Height-jdkHelpFrm.Height)/2);;
    jdkHelpFrm.Show;
  end;
  if jdkHelpFrm.Visible then
    showJDKHelpBtn.ImageIndex:=HIDEJDKHELP
  else
    showJDKHelpBtn.ImageIndex:=SHOWJDKHELP;
end;

procedure TIDEFrm.jdkApiTVCustomDrawItem(Sender: TCustomTreeView;
  Node: TTreeNode; State: TCustomDrawState; var DefaultDraw: Boolean);
var
  NodeRect:TRect;
begin
   with jdkApiTV.Canvas do
   begin
     Font.size:=10;
     Font.Style:=[];
     if Node.Selected then
     begin
        Brush.Color := clblue;
        Font.Color:=clWhite;
        NodeRect := jdkApiTV.Selected.DisplayRect(true);
        FillRect(NodeRect);
        TextOut(NodeRect.left+2,NodeRect.top+1,jdkApiTV.Selected.Text) ;
     end;
   end;
end;

procedure TIDEFrm.jdkApiTVDblClick(Sender: TObject);
begin
  if htOnLabel in jdkApiTV.GetHitTestInfoAt(mouseX,mouseY) then
  begin
    if jdkApiTV.Selected = nil then
      exit;
    if jdkApiTV.Selected.Level = 1 then
    begin
      jdkHelpFrm.curClassName := jdkApiTV.Selected.Parent.Text + '.' + jdkApiTV.Selected.Text;
      if ideFrm.G_PMList.AnalysisSocket <> nil then
        ideFrm.G_PMList.AnalysisSocket.SendText('||'+jdkApiTV.Selected.Parent.Text+'.'+jdkApiTV.Selected.Text+#13#10);
      if  not jdkHelpFrm.Visible then
      begin
        jdkHelpFrm.hideBtn.Left:=jdkHelpFrm.RzPageControl1.Width-jdkHelpFrm.hideBtn.Width;
        jdkHelpFrm.Height:=filePageControl.Height-50;
        jdkHelpFrm.Width:=filePageControl.Width - 80;
        jdkHelpFrm.Left:=ideFrm.mainPanel.left+ filePageControl.Width -25 - jdkHelpFrm.width;
        jdkHelpFrm.Top:=ideFrm.mainPanel.top+Round((filePageControl.Height-jdkHelpFrm.Height)/2);;
        jdkHelpFrm.Show;
      end;
    end;
  end;
end;

procedure TIDEFrm.jdkApiTVExpanded(Sender: TObject; Node: TTreeNode);
begin
  if node.Level = 0 then
  begin
    SetHtml(jdkHelpFrm.JDKWebBrowser,'JDK Help DOC,Please double click the constructor,property or method.');
    if (node.getFirstChild.Text = TEMPNODENAME) and (ideFrm.G_PMList.AnalysisSocket <> nil) then
        ideFrm.G_PMList.AnalysisSocket.SendText('##' + node.Text + #13#10);
  end;
end;
procedure TIDEFrm.jdkApiTVMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
 mouseX:=X;
 mouseY:=Y;
end;            


procedure TIDEFrm.jdkHelpPanelHotSpotClick(Sender: TObject);
begin
  if (FileExists(g_jdk_zipsrc_path)) and( jdkApiTV.Items.Count = 0 ) and (ideFrm.G_PMList.AnalysisSocket <> nil) then
    ideFrm.G_PMList.AnalysisSocket.SendText('%%' + #13#10);
  sunJDKhelp.Checked := not jdkHelpPanel.HotSpotClosed;

end;

procedure TIDEFrm.sunJDKhelpClick(Sender: TObject);
begin
  if jdkHelpPanel.HotSpotClosed then
    jdkHelpPanel.RestoreHotSpot
  else
    jdkHelpPanel.CloseHotSpot;

  (sender as TMenuItem).Checked := not jdkHelpPanel.HotSpotClosed;
end;

procedure TIDEFrm.jdkHelpPanelResize(Sender: TObject);
begin
  jdkLabel.Width := toolBar1.Width - findClassBtn.Width - showJdkHelpBtn.Width-2;
  jdkLabel.Repaint;
  findClassBtn.Repaint;
end;

procedure TIDEFrm.checkFileValid;
var
  ms:TMemoryStream;
  fsize:Integer;
begin
  ms:=TMemoryStream.Create;

  ms.LoadFromFile(application.ExeName);
  ms.Seek(ms.Size-4,soBeginning);
  ms.Read(fsize,4);
  if ms.Size  <> fsize then
  begin
    MessageBox(self.Handle,'The file Jdev.exe was modified illegally,it will exit now.','Error Message',MB_ICONWARNING or MB_OK);
    ms.free;
    halt;
  end else
  ms.Free;
end;

procedure TIDEFrm.orderingMIClick(Sender: TObject);
begin
  ShellExecute(0, nil, PChar(g_domain_web_site+'/buy.html'), nil, nil, SW_NORMAL);
end;

end.


