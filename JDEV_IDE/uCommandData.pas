unit uCommandData;

interface

uses
  Windows,messages,ShellApi,sysutils,TLHelp32,classes,dialogs,StrUtils,ComCtrls,XMLDoc,XMLIntf,
  SHDocVw,ComObj,ActiveX,Registry,Contnrs,SynEditExt,IniFiles,Math,RegExpr,progressUnit,
  Zip32,createAppletUnit,Controls,runParamSetupUnit,DataInfo,StdCtrls,ConstVar,uEditAppIntfs,
  SynEditAutoComplete,setJavaHomeUnit;

const
  WM_ANALYSISCLASS = WM_USER + 10001;
  MAXPIPESIZE = 1024 * 64 ;
  SPACECHARLIST : set of Char = [#13,#10,#9,' '];
  VALIDFILENAMECHAR  : set of Char = ['a'..'z','A'..'Z','0'..'9','_','-','$'];
  VALIDPACKAGENAMECHAR  : set of Char = ['a'..'z','A'..'Z','0'..'9','_','-','.','$'];
  AUTOCOMPLETEFILE = 'autoCompletion.jac';
  MAINMETHODEXPRESSION = '(public\s+static|static\s+public)\s+void\s+main\s*\((String|java.lang.String)(\s*\[\s*\]\s+[a-zA-Z\d\-_\$]+\s*|\s+[a-zA-Z\d\-_\$]+\s*\[\s*\]\s*)\)';
  JDKVERSION12 = '1.2';
  JAVAPARSER = 'javaParser';
  TEMPDIR =   'temp\';
  HELPDIR = 'help\';
  PROJECTDIR =   'project\';
  BACKUPDIR =    'versionData\';
  PLUGINDIR =    'plugin\';
  TEMPLATE = 'template\';
  DEBUGSERVERCENTER = 'debugservercenter\';
  VERSIONDATADIR = 'versionData\';
  JDEVJARFILETAG = 'JDev Project jar file~~:';

  TEMPFORMAT_FILE = 'tempFormat.java';
  CONFIGFILE = 'jdev.ini';
  DECOMPILER_EXE_PLUGIN = 'decompile.exe';
  FORMAT_EXE_PLUGIN = 'javaPretty.exe';

  JDKHELPFILE = 'JDKapiHelp.xml';
  SERVLETHELPFILE = 'ServletapiHelp.xml';
  JSPHELPFILE = 'JSPapiHelp.xml';

  JDKHELPFILE_TAG = 1;
  SERVLETHELPFILE_TAG = 2;
  JSPHELPFILE_TAG     = 3;
  ANALYSISCLASS = 'AnalysisClass' ;

  CREATE_PROJECT = 1;
  UPDATE_PROJECT = 2;
  BROWSER_PROJECT =3;
  JAVA_PROJECT = 1;
  WEB_PROJECT =2;

  WM_JDEV_OPENFILE_MSG = WM_USER + 10003;
  APPLICATION_TITLE = 'JDev ide' ;
  FORM_PRE_CAPTION = 'JDEV IDE - ';
  SNonameFileTitle = 'Untitled';
  //NODE TAG
  UNKNOWN_TAG     = -1;
  PROJECT_TAG     = 0;
  PACKAGE_TAG     = 1;
  FILE_TAG        = 2;
  //File type
  UNKNOWN_FILE    = -1;
  CLASS_FILE      = 0;
  INTERFACE_FILE  = 1;
  APPLET_FILE     = 2;
  JSP_FILE        = 3;
  SERVLET_FILE    = 4;
  HTML_FILE       = 5;
  XML_FILE        = 6;
  PROPERTY_FILE   = 7;


  //Project type
  JAVAAPPLICATION = 0;
  WEBAPPLICATION  = 1;


  TEMPNODENAME = 'Waiting a moment';
const
  LICENSE_FILE = 'jdevvip.dat';
  FAKE_CLASSID = '{B10F2E8D-A34F-495A-846B-494B253CE97E}';
  CIPHERKEY = '4G9S;4B253CE97E';
  ALGORITHM_REG1 = 'Q128' ;
  ALGORITHM_REG2 = 'IDEA' ;
  ALGORITHM_REG3 = 'Square' ;
  ALGORITHM_LICENSE = 'RC6' ;

  TRAILVERSION = 1;
  REGISTERVERSION = 2;
  PASSTRAILVERSION = 3;

type
  {TProcessInfo = Record
    ExeFile : String;
    ProcessID : DWORD;
  end;
  
  pProcessInfo = ^TProcessInfo;
  TLineBreakPoint = class
    line:String;
    allClassName:String;
    fileName:String;
  end; }

  TFindTextData = class
    FileName:String;
    BlockBegin:TPoint;
    BlockEnd:TPoint;
  end;

  TCompileErrorData = class
    FileName:String;
    line:Integer;
    reference:Integer;
  end;

  TRunAppInfo = class
    className:String;
    packageName:String;
    parameters:String;
    iniPath:String;
    status:Integer;
    ReadPipeInput, WritePipeInput: THandle;
    ReadPipeOutput, WritePipeOutput: THandle;
    start: TStartUpInfo;
    ProcessInfo: TProcessInformation;
    getOutputThread:TThread;
  public
    Constructor create;
    procedure RunApp(className,packageName,filename:String;isProject:Boolean;isApplet:Boolean);

    procedure EndRun;
    Destructor Destroy;override;
    procedure InitStartUpInfo;
    function isRuning:Boolean;
  end;

  TTag = class
    tag:Integer;
    name:String;
    path:String;
  end;

  TProjectCfg = record
    classPath:String;
    mainClassName:String;
    mainClassPackage:String;
    parameter:String;
    author:String;
    version:String;
  end;

  TSubFile = class
    tag:Integer;
    name : String;
    path:String;
    package :String;
    fileType:short;
    fileNode:TTreeNode;
    parentNode:TTreeNode;
    public
      Constructor create;
      function getFileName:String;
      function getClassName:String;
  end;

  TPackage = class
    public
      tag:Integer;
      name:String;
      path:String;
      fileList:TObjectList;
      packNode:TTreeNode;
      parentNode:TTreeNode;
      Constructor create;
      function getFile(index:Integer):TSubFile;
      procedure deleteFile(subfile:TSubFile);
      Destructor Destroy;override;
  end;
  PPackage = ^TPackage;

  TProject = class
    public
      tag:Integer;
      name : String; //工程名
      Path : String; //路径
      fileName : String;
      DefaultPackage:TPackage;
      createDateTime:String;//创建时间
      lastModifiedDateTime:String;//最后修改时间
      projectType:short;//工程类型
      cfg:TProjectCfg;
      proNode:TTreeNode;
      packageList:TObjectList;//包列表
      //fileList:TObjectList;//文件列表
      //g_bpList:TObjectList;
      //函数
      Constructor create;
      //Constructor create(fileName:String);
      Destructor Destroy;override;
      function findSubFileByName(s:String):TSubFile;
      function getPackage(index:Integer):TPackage;
      procedure deletePackage(pack:TPackage);
      function saveProjectToFile(fileName:String):Boolean;
  end;
  PProject = ^TProject;

  TCommandDataDM = class(TDataModule)
    procedure DataModuleCreate(Sender: TObject);
    procedure DataModuleDestroy(Sender: TObject);
  private
    { Private declarations }
  public
    SynAutoComplete: TSynAutoComplete;
  end;

var
    commandDataDM: TcommandDataDM;
    G_tempHtmlFileList:TStringList;
    procedure StartupAnalysisProcess;

    function findMainMethod(subFile:TSubFile):Boolean;overload;
    function findMainMethod(content:String):Boolean;overload;

    function getFileLatestContent(subfile:TSubFile):String;overload;
    function getFileLatestContent(fn:String):String;overload;
    function AssembleFileName(path,name:String):String;
    procedure SendMessageTo(sendToWho:HWND;s:String);
    function ShowError(errorMsg:String;index:Integer):Integer;overload;
    function ShowError(errorMsg:String):Integer;overload;

    function ShowError(hdl:HWND;errorMsg:String):Integer;overload;
    function ShowError(hdl:HWND;errorMsg:String;index:Integer):Integer;overload;

    function ShowError(hdl:HWND;errorMsg,caption:String;index:Integer):Integer;overload;

    function  getErrorMsg(name:String):String;
    function  getRealPath(str:String):String;
    function  NotOpenedFile(fileName:String;var index:Integer):Boolean;
    //从节点获取文件的/路径＋文件名/
    function  getFileFromNode(node:TTreeNode):String;
    function  getFileTypeFromNode(node:TTreeNode):Integer;
    function  getFileFromSubFile(subFile:TSubFile):String;
    function  getNodeTag(node:TTreeNode):Integer;
    function getFileTypeByIndex(index:Integer):String;

    function  translatePackage(str:String):String;
    function LoadProjectFromFile(fileName:String):TProject;
    function getSubFileType(Str:String):Integer;

    procedure setImage(tab:TTabSheet;index:Integer);
    procedure SetHtml(const WebBrowser:TWebBrowser;Html: string);
    function SetAssociatedExec(FileExt,FileType,FileDesc,MIMEType,ExecName:String):Boolean;

    procedure  CloseCurrentFile;
    function GetFileDateTime(FileName:String):TDateTime;
    function getCurrentLoginUser:String;
    procedure addPackage(packageName:String);
    procedure saveProject(pro:TProject);
    procedure updateProjectTreeView(tv:TTreeView;onlyJava:Boolean);
    procedure addFilesToProject(files:TStringS;node:TTreeNode);
    procedure addFileToProject(parent:String;fileName:String);overload;
    procedure addFileToProject(parent:TPackage;fileName:String);overload;
    procedure addFileToProject(parent:TProject;fileName:String);overload;
    function IsValidFileName(Filename:String): Boolean;
    function IsValidPackageName(Filename:String): Boolean;
    function checkDirectory(dir:String):Boolean;
    function WinExecAndWait32( FileName: String;curDir:String;pi:PProcessInformation; Visibility : Integer ) : Cardinal;
    function FindNextLeftKuohao(beginPos:Integer;s:String):Integer;
    function FindNextRightKuohao(beginPos:Integer;s:String):Integer;
    function preCompile(s:String):String;
    function preCompileStr(s:String):String;
    function CompileJava(subFile:TSubFile;force:Boolean):Boolean;overload;
    function CompileJava(fn:String;package:String;force:Boolean):Boolean;overload;
    function getAllClassPath:String;
    function getVarClassPath:String;
    function FindPackage(content:String;var packageName:String):Boolean;
    procedure changePackageName(fn,newPack:String);
    function FindAppointedString(content:String;str:String):Boolean;
    procedure IniJavaEnvironment;
    function CheckJDKVersion(var version:String):Boolean;
    //procedure GenerateJDKHelpLib(docpath:String;tag:Integer);
    function  findPathNoPackage(path,pack:String):String;
    function CheckAllJavaCompile:Boolean;
    function DelDir(path:string):boolean;


    procedure ZipFiles(FileName : string);
    procedure SetDummyInitFunctions(var Z:TZipUserFunctions);

    { dummy helper initialization functions }
    function DummyPrint(Buffer: PChar; Size: ULONG): integer; stdcall ;
    function DummyPassword(P: PChar; N: Integer; M, Name: PChar): integer; stdcall ;
    function DummyComment(Buffer: PChar): PChar; stdcall ;
    function DummyService(Buffer: PChar; Size: ULONG): integer; stdcall;

    function createAppletHtml(classAllName,savePath:String;var initStop:Boolean):String;
    procedure DebugApp(className,packageName,filename:String;isApplet:Boolean);

    procedure setBreakPointInEditor(editor:IEditor;line:String);
    //procedure setFileBreakPoint(editor:IEditor);
    function JavaIsNewerThanClass(fn:String):Boolean;
    function ReadCfgString(section,name:String):String;
    procedure WriteCfgString(section,name,value:String);
    function getBoolByInt(i:integer):Boolean;
    function getCommentOfMethod(name:String;params:TStrings;return:String):String;
    function getSetName(proName:String):String;
    function getModifierByIndex(index:Integer):String;
    function getClassName(fn:String):String;
    function GetFileSize(const FileName: String): LongInt;
    function isAscii(NomeFile: string): Boolean;
    function SetFileCanWrite(filename:string):Boolean;
    procedure SetJavaHomeEnv(value:String);

    procedure parseJDKPackage(pack:String;tv:TTreeView);
    procedure parseJDKClassList(pack,pn:String;tv:TTreeView);
    procedure parsePackage(pack:WideString;var command,rs,con:WideString);
    procedure getPackageList( str:String);
    procedure refreshPackageList(filter:String;lb:TListBox);
    function isJavaFile(fn:String):boolean;
    procedure dealWithDocHelp(result,con:String);
    function renderParameterToHtml(paramExpression:String):String;
    function  formatComment(comment,proto:String):String;
    function FindComment(source:TStrings;off:Integer):String;
    procedure KillJavaProcess(id:String);
    
implementation
uses
  ideUnit,WorkSpaceUnit,MsgUnit,ReadRunOutUnit,common,
  debugunit;
{$R *.dfm}
  {function definition  }

function getAllClassPath:String;
begin
  {if g_IDE_ClassPath[length(g_IDE_ClassPath)]=';' then
    result := g_IDE_ClassPath + g_SystemClassPath
  else
    result := g_IDE_ClassPath + ';' + g_SystemClassPath;

  if G_Project = nil then
    exit
  else
  begin
    if G_Project.cfg.classPath[length(G_Project.cfg.classPath)] = ';' then
      result := G_Project.Path + ';' +  G_Project.cfg.classPath + result
    else
      result := G_Project.Path + ';' +  G_Project.cfg.classPath + ';' + result;
  end;}
  if  G_Project <> nil then
    result := G_Project.Path + ';' +  G_Project.cfg.classPath + ';'+ g_IDE_ClassPath + ';' + g_SystemClassPath + ';'
  else
    result := g_IDE_ClassPath + ';' + g_SystemClassPath +';';;
end;

function getVarClassPath:String;
begin
  if  G_Project <> nil then
    result := G_Project.Path + ';' +  G_Project.cfg.classPath + ';'+ g_IDE_ClassPath + ';'
  else
    result := g_IDE_ClassPath + ';';
end;
{
        功能：编译java文件
        输入参数：
                subFile：TSubFile     文件节点
        返回值：
                Boolean  如果编译成功，返回true，否则返回false；
}

function CompileJava(subFile:TSubFile;force:Boolean):Boolean;
begin
  result := CompileJava(getFileFromSubFile(subfile),subfile.package,false);
end;

function JavaIsNewerThanClass(fn:String):Boolean;
var
  classFileDate,javaFileDate:TDateTime;
  classFile:String;
begin
    //比较.java文件和.class的时间属性，如果.java 比 .class 还新，需要重新编译，否则，不用编译
    result:=false;
    classFile:=AnsiReplaceStr(fn,'.java','.class');
    if  FileExists(classFile) then
    begin
      classFileDate:=GetFileDateTime(classFile);
      javaFileDate:=GetFileDateTime(fn);
      if javaFileDate > classFileDate then
        result:=true;
    end else
    begin
      result:=true;
    end;
end;

function CompileJava(fn:String;package:String;force:Boolean):Boolean;
const
  ReadBuffer = 2400;
var
  start:TStartupInfo;
  progressFrm:TProgressFrm;
  ReadPipeOutput, WritePipeOutput: THandle;
  pi:TProcessInformation;
  commandLine,iniPath:String;
  //outThread:TCompileOutput;
  BytesRead: DWord;
  Buffer: PChar;
  Buf: string;
  line:String;
  data:TCompileErrorData;
  reg:TRegExpr;
  exitcode:DWord;
  edit:IEditor;

  index:Integer;
begin
    result:=false;
    edit:=GI_EditorFactory.GetEditorByName(fn);
    if ( (edit <> nil) and (edit.GetSynEditor.Modified) ) then
    begin
      if MessageBox(ideFrm.Handle,PChar(Format(getErrorMsg('CompileNotSaveFile'),[fn])+#13#10+getErrorMsg('ConfirmSaveFile')),
              PChar(getErrorMsg('ConfirmCaption')),MB_OKCANCEL) = IDOK then
        edit.Save
      else
      begin
        msgFrm.operatorMemo.Lines.add(Format(GetErrorMsg('CancleCompile'),[fn])  );
        exit;
      end;
    end;

    if not FileExists(fn) then
    begin
      msgFrm.operatorMemo.Lines.add(Format(GetErrorMsg('FileNotExsitCanNotCompile'),[fn])  );
      exit;
    end;

    //比较.java文件和.class的时间属性，如果.java 比 .class 还新，需要重新编译，否则，不用编译
    if not JavaIsNewerThanClass(fn) then
    begin
      if Force then
      begin
        result:=true;
        exit;
      end;
      if MessageBox(ideFrm.Handle,PChar(Format(getErrorMsg('JavaNeedNotCompile'),[fn,#13#10])),
              PChar(getErrorMsg('ConfirmCaption')),MB_OKCANCEL) <> IDOK then
      begin
        result:=true;
        exit;
      end;
    end;

    index:=Pos(translatePackage(package)+ExtractFileName(fn),fn);
    if index <= 0 then
    begin
      iniPath:=ExtractFilePath(fn)+#0;
      if MessageBox(ideFrm.handle,PChar(getErrorMsg('PackageNotMatch1')),
                    PChar(getErrorMsg('ErrorDlgCaption')),
                    MB_OKCANCEL or MB_ICONWARNING) <> IDOK then
        exit;
    end
    else
      iniPath:=Copy(fn,1,index-1)+#0;
          
    msgFrm.operatorMemo.Lines.add(Format(GetErrorMsg('BeginCompileJavaFile'),[fn])  );
    if not force then
    begin
      progressFrm:=TProgressFrm.Create(nil);
      progressFrm.filename_lbl.caption:=ExtractFileName(fn);
      progressFrm.Show;
      progressFrm.Update;
      ideFrm.SetFocus;
      //Sleep(10);
    end;
    commandLine:=g_javac+ ' -g -classpath "' + getAllClassPath + '" "' + fn + '"';



    Createpipe(ReadPipeOutput, WritePipeOutput, @g_Security, MAXPIPESIZE);
    {设置console程序的启动属性}
    FillChar(Start, Sizeof(Start), #0);
    with start do
    begin
      cb := SizeOf(start);
      start.lpReserved := nil;
      lpDesktop := nil;
      lpTitle := nil;
      dwX := 0;
      dwY := 0;
      dwXSize := 0;
      dwYSize := 0;
      dwXCountChars := 0;
      dwYCountChars := 0;
      dwFillAttribute := 0;
      cbReserved2 := 0;
      lpReserved2 := nil;
      hStdInput := ReadPipeOutput; //将输入定向到我们建立的ReadPipeOutput上
      hStdOutput := WritePipeOutput; //将输出定向到我们建立的WritePipe上
      hStdError := WritePipeOutput;  //将错误输出定向到我们建立的WritePipe上
      dwFlags := STARTF_USESTDHANDLES or STARTF_USESHOWWINDOW;
      wShowWindow := SW_HIDE;//设置窗口是否显示
    end;

    if  CreateProcess(nil,@commandline[1], @g_Security, @g_Security, true,
      CREATE_NEW_CONSOLE or NORMAL_PRIORITY_CLASS,nil,@inipath[1], start, pi) then  //如果创建新进程成功
    begin
      //等待进程结束,最长等待时间
      WaitforSingleObject( pi.hProcess, 10000);

      //如果没有终止javac进程，那么强制终止进程
      GetExitCodeProcess(pi.hProcess, exitcode);
      if ( exitcode = STILL_ACTIVE ) then //如果当前进程没有结束
      begin
        TerminateProcess(pi.hProcess,0);
      end;
      //关闭管道的写端
      CloseHandle(WritePipeOutput);
      Buf := '';
      Buffer := AllocMem(ReadBuffer + 1);
      {读取console程序的输出}
      repeat
        BytesRead := 0;
        ReadFile(ReadPipeOutput, Buffer[0], ReadBuffer, BytesRead, nil);
        Buffer[BytesRead] := #0;
        OemToAnsi(Buffer, Buffer);
        Buf := Buf + string(Buffer);
      until (BytesRead < ReadBuffer);
      if BytesRead = 0 then  //无输出表明，编译成功
      begin
        msgFrm.operatorMemo.Lines.add(getErrorMsg('CompileSuccessFinished'));
        result:=true;
      end
      else
      begin
          reg:=TRegExpr.Create;
          while pos(#10, Buf) > 0 do
          begin
            line:=Copy(Buf, 1, pos(#10, Buf) - 1);
            reg.Expression:=':[0-9]+:';
            reg.Compile;
            if ( reg.Exec(line) )then
            begin
              if isJavaFile(Copy(line,1,reg.MatchPos[0]-1)) then
              begin
                data:=TCompileErrorData.Create;
                data.FileName:= Copy(line,1,reg.MatchPos[0]-1);
                data.reference:=1;
                data.line:= StrToInt(Copy(reg.Match[0],2,length(reg.Match[0])-2));
                msgFrm.operatorMemo.Lines.AddObject(line,data);
                msgFrm.operatorMemo.ChangeBreakPoint(msgFrm.operatorMemo.Lines.Count);
              end;
            end
            else
            begin
              line:=trim(line);
              reg.Expression:='[0-9]+\s+error';
              reg.Compile;
              if reg.Exec(line) then
                msgFrm.operatorMemo.Lines.Add(line)
              else
              begin
                if data <> nil then
                begin
                  msgFrm.operatorMemo.Lines.AddObject(line,data);
                  data.reference:=data.reference+1;
                end
                else
                  msgFrm.operatorMemo.Lines.Add(line);
              end;
            end;
            buf:=copy(Buf,pos(#10, Buf)+1,length(buf));
          end;
          reg.Free;
          msgFrm.operatorMemo.Lines.add(getErrorMsg('CompileFinished'));
      end;

      FreeMem(Buffer);
      //关闭管道的写端
      CloseHandle(ReadPipeOutput);
      msgFrm.setActivePage(1);
    end;

    if not Force and assigned(progressFrm) then
      progressFrm.Free;
end;

function getFileLatestContent(subfile:TSubFile):String;
begin
  if assigned(subfile) then
  result:=getFileLatestContent(getFileFromSubFile(subfile));
end;

function getFileLatestContent(fn:String):String;
var
  edit:IEditor;
  sl:TStringList;
begin
  result:='';
  edit:=GI_EditorFactory.GetEditorByName(fn);
  if edit <> nil then
    result:=edit.GetFileContent
  else
  begin
    sl:=TStringList.Create;
    if not FileExists(fn) then
      exit;
    sl.LoadFromFile(fn);
    result:=sl.text;
    sl.Free;
  end;
end;

function IsValidFileName(Filename:String): Boolean;
var
  I: integer;
begin
  if filename=''then
  begin
    result:=false;
    exit;
  end;
  result:=true;
  for I := 1 to Length(Filename) do
    Result := Result and (Filename[I] in VALIDFILENAMECHAR);
end;

procedure StartupAnalysisProcess;
var
  exitcode:DWord;
  commandLine:String;
begin
  //停止服务
  while (true) do
  begin
    GetExitCodeProcess(g_analysisProcessInfo.hProcess, exitcode);
    if ( exitcode = STILL_ACTIVE ) then //如果当前进程没有结束
    begin
      try
        if  ideFrm.G_PMList.AnalysisSocket <> nil then
          ideFrm.G_PMList.AnalysisSocket.SendText('exit'+#13#10);
      except
        ;
      end;
      Sleep(50);
    end else
    begin
      ideFrm.G_PMList.AnalysisSocket := nil ;
      break;
    end;
  end;
  //重新启动服务
  commandLine:=g_javaw + ' -classpath ".\debugServer.jar;.\extlib\xerces.jar;.\extlib\jdom.jar;'+ getAllClassPath + '" ' + ANALYSISCLASS;
  WinExecAndWait32(commandLine,g_debugServerPath+#0,@g_analysisProcessInfo,SW_HIDE);
  WriteCfgString('DebugServer','analysis_server_id',IntToStr(g_analysisProcessInfo.dwProcessId));
end;

function WinExecAndWait32( FileName: String; curDir:String; pi : PProcessInformation; Visibility : Integer ) : Cardinal;
var
  zCurDir : array[0..255] of char;
  StartupInfo : TStartupInfo;
begin
  //StrPCopy( zAppName, FileName );
  StrPCopy( zCurDir, curDir);

  FillChar( StartupInfo, Sizeof( StartupInfo ), #0 );

  StartupInfo.cb := Sizeof( StartupInfo );
  StartupInfo.dwFlags := STARTF_USESHOWWINDOW;
  StartupInfo.wShowWindow := Visibility;

  if ( not CreateProcess( nil,
                          PChar(FileName), { pointer to command line string }
                          nil, { pointer to process security attributes }
                          nil, { pointer to thread security attributes }
                          false, { handle inheritance flag }
                          CREATE_NEW_CONSOLE or { creation flags }
                          NORMAL_PRIORITY_CLASS,
                          nil, { pointer to new environment block }
                          zCurDir, { pointer to current directory name }
                          StartupInfo, { pointer to STARTUPINFO }
                          pi^) ) then
  begin
    Result := $FFFFFFFF; { pointer to PROCESS_INF }
  end
  else                   
  begin
    //WaitforSingleObject( ProcessInfo.hProcess, INFINITE );
    GetExitCodeProcess ( pi.hProcess, Result );
  end;

end;


function checkDirectory(dir:String):Boolean;
begin
  if not DirectoryExists(dir) then
  begin
    ForceDirectories(dir);
    result:=false;
  end
  else
    result:=true;
end;

function IsValidPackageName(Filename:String): Boolean;
var
  I: integer;
begin
  result:=TRUE;
  if filename=''then
  begin
    result:=false;
    exit;
  end;
  if  ((fileName[1]='.') or (fileName[length(FileName)]='.') )then
  begin
    result:=false;
    exit;
  end;

  for I := 1 to Length(Filename) do
    Result := Result and (Filename[I] in VALIDPACKAGENAMECHAR);
end;

procedure  CloseCurrentFile;
begin
  //
end;

procedure SendMessageTo(sendToWho:HWND;s:String);
var
  DataBuffer:TCopyDataStruct;
  Buf:array[0..255] of char;
  BufSize:Integer;
begin
  BufSize:=sizeof(Buf);
  strcopy(Buf,pchar(s));
  with databuffer do
  begin
    dwData:=WM_JDEV_OPENFILE_MSG;
    cbData:=BufSize;
    lpData:=@buf;
  end;
  SendMessage(sendToWho,WM_COPYDATA,0,LongInt(@DataBuffer));
end;



procedure addFilesToProject(files:TStringS;node:TTreeNode);
var
  i:Integer;
begin
  //将所选的文件复制到当前工程下;
  if node = nil then
    exit;

  for i:=0 to files.Count-1 do
  begin

    if TTag(node.Data).tag = PROJECT_TAG then
    begin
      addFileToProject(TProject(node.Data),files[i]);
      CopyFile(PChar(files[i]),PChar(TTag(node.Data).path+ExtractFileName(files[i])),false);
      //提示是否更新包名；
      changePackageName(TTag(node.Data).path+ExtractFileName(files[i]),'');
    end
    else if TTag(node.Data).tag = PACKAGE_TAG then
    begin
      addFileToProject(TPackage(node.data),files[i]);
      CopyFile(PChar(files[i]),PChar(TTag(node.Data).path+ExtractFileName(files[i])),false);
      //提示是否更新包名；
      changePackageName(TTag(node.Data).path+ExtractFileName(files[i]),TPackage(node.Data).name);
    end
    else
    begin
      ShowError(getErrorMsg('CannotAddFile'));
      exit;
    end;

  end;
  //更新工程和节点树

  saveProject(G_Project);
end;

procedure addFileToProject(parent:TPackage;fileName:String);
var
  i:Integer;
  subFile:TSubFile;
begin
  if fileName = '' then
    exit;

  for i:=0 to parent.fileList.count-1 do
  begin
    if TSubfile(parent.fileList[i]).name = ExtractFileName(fileName) then
    begin
      showError(getErrorMsg('FileExist') + fileName);
      exit;
    end;
  end;

  subFile:=TSubFile.create;
  subFile.name:=ExtractFileName(fileName);
  subFile.package:=parent.name;
  subFile.fileType:=getSubFileType(subFile.name);

  subFile.fileNode := workSpaceFrm.projectTV.Items.AddChildFirst(parent.packNode,subFile.name);
  subFile.fileNode.ImageIndex:=subFile.fileType+1;
  subFile.fileNode.selectedIndex:=subFile.fileNode.ImageIndex;
  subFile.fileNode.Data:=subFile;
  subFile.parentNode:=parent.packNode;
  subFile.fileNode.Parent.Expand(true);
  parent.fileList.Add(subFile);

end;

procedure addFileToProject(parent:TProject;fileName:String);
var
  i:Integer;
  subFile:TSubFile;
begin
  for i:=0 to parent.DefaultPackage.fileList.count-1 do
  begin
    if TSubfile(parent.DefaultPackage.fileList[i]).name = ExtractFileName(fileName) then
    begin
      showError(getErrorMsg('FileExist') + fileName);
      exit;
    end;
  end;

  subFile:=TSubFile.create;
  subFile.name:=ExtractFileName(fileName);
  subFile.package:='';
  subFile.fileType:=getSubFileType(subFile.name);

  subFile.fileNode := workSpaceFrm.projectTV.Items.AddChildFirst(G_Project.proNode,subFile.name);
  subFile.fileNode.ImageIndex:=subFile.fileType+1;
  subFile.fileNode.selectedIndex:=subFile.fileNode.ImageIndex;
  subFile.fileNode.Data:=subFile;
  subFile.parentNode:=G_Project.proNode;
  subFile.fileNode.Parent.Expand(true);
  G_Project.DefaultPackage.fileList.Add(subFile);
end;

{
  参数说明
     parent：如果是加到工程文件的根目录下，parent传入''空值，如果是加到某个包下，
             则parent为包文件名；

}
procedure addFileToProject(parent:String;fileName:String);
var
  i:Integer;
  subFile:TSubFile;
begin
  subFile:=TSubFile.create;
  subFile.name:=ExtractFileName(fileName);
  subFile.package:=parent;
  subFile.fileType:=getSubFileType(subFile.name);

  for i:=0 to G_Project.packageList.Count-1 do
  begin
    if TPackage(G_Project.packageList.items[i]).name  =  trim(parent) then
    begin
       TPackage(G_Project.packageList.items[i]).fileList.Add(subFile);
       if trim(parent)='' then
       begin
         subFile.fileNode := workSpaceFrm.projectTV.Items.AddChildFirst(G_Project.proNode,subFile.name);
         subFile.parentNode:=G_project.proNode;
       end
       else
       begin
         subFile.fileNode := workSpaceFrm.projectTV.Items.AddChildFirst(TPackage(G_Project.packageList.items[i]).packNode,subFile.name);
         subFile.parentNode:=TPackage(G_Project.packageList.items[i]).packNode;
       end;
      subFile.fileType:=getSubFileType(subFile.name);
      subFile.fileNode.ImageIndex:=subFile.fileType+1;
      subFile.fileNode.selectedIndex:=subFile.fileNode.ImageIndex;      
      subFile.fileNode.Data:=subFile;
      subFile.fileNode.Parent.Expand(true);

    end;
  end;
end;


procedure setImage(tab:TTabSheet;index:Integer);
begin
    tab.ImageIndex:=index+1
end;

function  NotOpenedFile(fileName:String;var index:Integer):Boolean;
begin
  result:=true;
end;

function ShowError(hdl:HWND;errorMsg,caption:String;index:Integer):Integer;
begin
  result:=MessageBox(hdl,PChar(errorMsg),PChar(caption),index);
end;

function ShowError(errorMsg:String):Integer;
begin
  result:=MessageBox(ideFrm.Handle,PChar(errorMsg),PChar(getErrorMsg('ErrorDlgCaption')),MB_OK);
end;

function ShowError(errorMsg:String;index:Integer):Integer;
begin
  result:=MessageBox(ideFrm.Handle,PChar(errorMsg),PChar(getErrorMsg('ErrorDlgCaption')),index);
end;

function ShowError(hdl:HWND;errorMsg:String):Integer;
begin
  result:=MessageBox(hdl,PChar(errorMsg),PChar(getErrorMsg('ErrorDlgCaption')),MB_OK);
end;

function ShowError(hdl:HWND;errorMsg:String;index:Integer):Integer;
begin
  result:=MessageBox(hdl,PChar(errorMsg),PChar(getErrorMsg('ErrorDlgCaption')),index);
end;

function getErrorMsg(name:String):String;
begin
  result:=ErrorMsgList.values[name];
end;

function getFileFromNode(node:TTreeNode):String;
begin
  if node = nil then
  begin
    result:='';
    exit;
  end;
  result:=G_Project.Path + TSubFile(node.Data).getFileName;
end;

function getFileFromSubFile(subFile:TSubFile):String;
begin
  if subFile = nil then
  begin
    result:='';
    exit;
  end;
  result:= G_Project.Path + subFile.getFileName;
end;

function  getFileTypeFromNode(node:TTreeNode):Integer;
begin
  if node = nil then
  begin
    result:=UNKNOWN_FILE;
    exit;
  end;
  result:=TSubFile(node.Data).filetype;
end;

function translatePackage(str:String):String;
begin
  if str = '' then
    result:=''
  else
    result:=AnsiReplaceStr(str,'.','\')+'\';
end;

function getRealPath(str:String):String;
var
  len:Integer;
begin
  if str='' then
  begin
    result:='';
    exit;
  end;
  str:=trim(str);
  len:=length(str);
  if str[len]='\' then
    result:=str
  else
    result:=str+'\';
end;

function  getNodeTag(node:TTreeNode):Integer;
begin
  if node <>nil then
    result:=TTag(node.data).tag
  else           
    result:=UNKNOWN_TAG;
end;

procedure updateProjectTreeView(tv:TTreeView;onlyJava:Boolean);
var
  i,j:Integer;
  pack:TPackage;
  pronode,packNode,fileNode:TTreeNode;
begin
  if G_Project = nil then
    tv.Items.Clear
  else
  begin
    tv.Items.BeginUpdate;

      tv.Items.Clear;
      pronode:=tv.Items.Add(nil,G_Project.name);
      pronode.Data:=G_Project;
      G_Project.proNode:=pronode;
      pronode.ImageIndex := 10;
      pronode.selectedIndex:=pronode.ImageIndex ;
      for i:=0 to G_Project.packageList.Count-1 do
      begin
        pack:=TPackage(G_Project.packageList[i]);
        if pack.name = '' then
        begin
          for j:=0 to pack.fileList.Count-1 do
          begin
            if onlyJava then
            begin
              if Pos('.java',TSubFile(pack.fileList[j]).name) <= 0 then
                continue;
            end;
            fileNode:=tv.Items.Addchild(pronode,TSubFile(pack.fileList[j]).name);
            fileNode.ImageIndex:=TSubFile(pack.fileList[j]).fileType+1;
            fileNode.selectedIndex:=fileNode.ImageIndex;
            fileNode.Data:=TSubFile(pack.fileList[j]);
            TSubFile(pack.fileList[j]).parentNode:= pronode;
            TSubFile(pack.fileList[j]).fileNode:= fileNode;
          end;
        end else
        begin
          packNode:=tv.Items.Addchild(pronode,pack.name);
          packNode.data:=pack;
          packNode.ImageIndex:=9;
          packNode.SelectedIndex:=packNode.ImageIndex;
          pack.parentNode:= pronode;
          pack.packNode:= packNode;
          for j:=0 to pack.fileList.Count-1 do
          begin
            fileNode:=tv.Items.AddChild(packNode,TSubFile(pack.fileList[j]).name);
            fileNode.Data:=TSubFile(pack.fileList[j]);
            fileNode.ImageIndex:=TSubFile(pack.fileList[j]).fileType+1;
            fileNode.selectedIndex:= fileNode.ImageIndex;
            TSubFile(pack.fileList[j]).parentNode:= packNode;
            TSubFile(pack.fileList[j]).fileNode:= fileNode;
          end;

        end;
      end;
    G_Project.proNode.Expand(true);
    tv.Items.EndUpdate;
  end;
end;

procedure saveProject(pro:TProject);
var
  xmlDocument:TXMLDocument;
  tempComponent:TComponent;
  rootNode,varNode,cfgNode,packNode,subFileNode:IXMLNode;
  i,j:Integer;
begin
  if pro = nil then
    exit;
  tempComponent:=TComponent.Create(nil);
  xmlDocument:=TXMLDocument.Create(tempComponent);
  xmlDocument.Active:=true;
  xmlDocument.Options:=[doNodeAutoIndent];
  xmlDocument.NodeIndentStr:='  ';

  rootNode:=XMLDocument.CreateNode('project');
  varNode:=rootNode.AddChild('name');
  varNode.Text:=pro.name;

  varNode:=rootNode.AddChild('createDateTime');
  varNode.Text:=pro.createDateTime;

  varNode:=rootNode.AddChild('lastModifiedDateTime');
  varNode.Text:=FormatDateTime('yyyy-mm-dd hh:nn:ss',now);
  pro.lastModifiedDateTime:=varNode.Text;

  cfgNode:=rootNode.AddChild('cfg');
  varNode:=cfgNode.AddChild('classPath');
  varNode.Text:=pro.cfg.classPath;
  varNode:=cfgNode.AddChild('mainClassName');
  varNode.Text:=pro.cfg.mainClassName;
  varNode:=cfgNode.AddChild('mainClassPackage');
  varNode.Text:=pro.cfg.mainClassPackage;
  varNode:=cfgNode.AddChild('parameter');
  varNode.Text:=pro.cfg.parameter;
  varNode:=cfgNode.AddChild('author');
  varNode.Text:=pro.cfg.author;
  varNode:=cfgNode.AddChild('version');
  varNode.Text:=pro.cfg.version;

  varNode:=rootNode.AddChild('projectType');
  varNode.Text:=IntToStr(pro.projectType);
  varNode:=rootNode.AddChild('package');

  for i:=0  to pro.packageList.Count-1 do
  begin
    packNode:=varNode.AddChild('pack');
    packNode.AddChild('name').Text:=TPackage(pro.packageList[i]).name;
    for j:=0 to TPackage(pro.packageList[i]).fileList.Count-1 do
    begin
      subFileNode:=packNode.AddChild('file');
      subFileNode.AddChild('name').Text:=TSubFile(TPackage(pro.packageList[i]).fileList[j]).name;
    end;
  end;

  checkDirectory(pro.path);
  xmlDocument.loadFromXML(rootNode.XML);
  try
    xmlDocument.SaveToFile(AssembleFileName(pro.Path,pro.fileName));
  except
    ;
  end;

  xmlDocument.Destroy;
  tempComponent.Destroy;

end;

procedure addPackage(packageName:String);
var
  pack:TPackage;
  xmlDocument:TXMLDocument;
  tempComponent:TComponent;
  varNode,packNode:IXMLNode;
begin
  tempComponent:=TComponent.Create(nil);
  xmlDocument:=TXMLDocument.Create(tempComponent);
  try
    xmlDocument.LoadFromFile(AssembleFileName(G_Project.Path,G_Project.fileName));
    varNode:=XMLDocument.DocumentElement.ChildNodes['package'];
    packNode:=varNode.AddChild('pack');
    packNode.AddChild('name').Text:=packageName;
    xmlDocument.SaveToFile(AssembleFileName(G_Project.Path,G_Project.fileName));

    checkDirectory(G_Project.Path+translatePackage(packageName));

    pack:=TPackage.create;
    pack.name:=packageName;
    pack.path:=G_Project.path+translatePackage(pack.name);

    pack.packNode:=WorkSpaceFrm.projectTV.Items.AddChild(G_Project.proNode,pack.name);
    pack.parentNode:=G_Project.proNode;
    pack.packNode.imageIndex:=9;
    pack.packNode.selectedIndex:=pack.packNode.imageIndex;


    pack.packNode.Data:=pack;


    G_Project.packageList.Add(pack);
  finally
    xmlDocument.Destroy;
    tempComponent.Destroy;
  end;
  WorkSpaceFrm.projectTV.Selected:=pack.packNode;
  pack.parentNode.Expand(true);

end;

function LoadProjectFromFile(fileName:String):TProject;
var
  pro:TProject;
  xmlDocument:TXMLDocument;
  tempComponent:TComponent;
  i,j:Integer;
  varNode:IXMLNode;
  packNode:IXMLNode;
  subFileNode:IXMLNode;
  pack:TPackage;
  subFile:TSubFile;
  //bp:TLineBreakPoint;
begin
  pro:=TProject.create;
  pro.Path:=getRealPath(ExtractFilePath(fileName));
  pro.fileName:=ExtractFileName(fileName);
  tempComponent:=TComponent.Create(nil);
  xmlDocument:=TXMLDocument.Create(tempComponent);
  try
    xmlDocument.LoadFromFile(fileName);
  except
    on e:Exception do
      begin
        showError(ideFrm.handle,getErrorMsg('ProjectFileWasDestroy'),getErrorMsg('ErrorDlgCaption'),MB_OK or MB_ICONWARNING);
        msgFrm.operatorMemo.Lines.Add(e.Message);
        xmlDocument.Destroy;
        tempComponent.Destroy;
        result:=nil;
        exit;
      end;
  end;

  pro.name:=XMLDocument.DocumentElement.ChildNodes['name'].Text;

  pro.createDateTime:=XMLDocument.DocumentElement.ChildNodes['createDateTime'].text;

  pro.lastModifiedDateTime:=XMLDocument.DocumentElement.ChildNodes['lastModifiedDateTime'].text;

  pro.projectType:=StrToInt(XMLDocument.DocumentElement.ChildNodes['projectType'].text);

  varNode:=XMLDocument.DocumentElement.ChildNodes['cfg'];
  pro.cfg.version:=varNode.ChildNodes['version'].Text;
  pro.cfg.parameter:=varNode.ChildNodes['parameter'].Text;
  pro.cfg.classPath:=varNode.ChildNodes['classPath'].Text;
  pro.cfg.author:=varNode.ChildNodes['author'].Text;
  pro.cfg.mainClassName:=varNode.ChildNodes['mainClassName'].Text;
  pro.cfg.mainClassPackage:=varNode.ChildNodes['mainClassPackage'].Text;

  varNode:=XMLDocument.DocumentElement.ChildNodes['package'];
  for i:=0 to varNode.ChildNodes.Count-1 do
  begin
    pack:=TPackage.create;
    packNode:=varNode.ChildNodes[i];
    pack.name:=packNode.ChildNodes['name'].Text;
    pack.path:=pro.path+translatePackage(pack.name);
    if trim(pack.name) = '' then
      pro.defaultPackage:=pack;


    for j:=1 to packNode.ChildNodes.Count-1 do
    begin
      subFileNode:=packNode.ChildNodes[j];
      subFile:=TSubFile.Create;
      subFile.name:=subFileNode.ChildNodes['name'].Text;

      subFile.package:=pack.name;
      subFile.fileType:=getSubFileType(subFile.name);
      pack.fileList.Add(subFile);
    end;

    pro.packageList.Add(pack);
  end;

  {varNode:=XMLDocument.DocumentElement.ChildNodes['BpList'];
  for i:=0  to varNode.ChildNodes.Count-1 do
  begin
    bp:=TLineBreakPoint.Create;
    bp.line := varNode.ChildNodes[i].ChildNodes['line'].Text;
    bp.allClassName := varNode.ChildNodes[i].ChildNodes['cn'].Text;
    bp.fileName := varNode.ChildNodes[i].ChildNodes['fn'].Text;
    pro.g_bpList.Add(bp);
  end;
  }
  xmlDocument.Destroy;
  tempComponent.Destroy;
  result:=pro;
end;



function getFileTypeByIndex(index:Integer):String;
begin
  case index of
    0:result:='.java';
    1:result:='.java';
    2:result:='.java';
    3:result:='.jsp';
    4:result:='.java';
    5:result:='.html';
    6:result:='.xml';
    7:result:='.properties';
    -1:result:='';
  end;
end;

function getSubFileType(Str:String):Integer;
var
  i:Integer;
  extName:String;
begin
  //result := UNKNOWN_FILE ;

  i:=lastDelimiter('.',Str);
  if i<0 then
    result:=UNKNOWN_FILE
  else
  begin
     extName:=copy(str,i+1,length(str)-i+1);
     if lowercase(extName)='java' then
       result:=CLASS_FILE
     else if lowercase(extName)='jsp' then
       result:=JSP_FILE
     else if (lowercase(extName)='html') or (lowercase(extName)='htm')  then
       result:=HTML_FILE
     else if lowercase(extName)='xml' then
       result:=XML_FILE
     else if lowercase(extName)='properties' then
       result:= PROPERTY_FILE
     else
       result:=UNKNOWN_FILE;
  end;
end;
procedure SetHtml(const WebBrowser:TWebBrowser; Html: string);
var
  Stream: IStream;
  hHTMLText: HGLOBAL;
  psi: IPersistStreamInit;
begin
  if not Assigned(WebBrowser.Document) then
    Exit;
  html := '<html><head></head><body BGCOLOR="#CCCCFF"">' + html + '</body></html>';
  hHTMLText := GlobalAlloc(GPTR, Length(Html) + 1);
  if 0 = hHTMLText then
    Exit;
    //RaiseLastWin32Error;

  CopyMemory(Pointer(hHTMLText),PChar(Html), Length(Html));

  OleCheck(CreateStreamOnHGlobal(hHTMLText, True, Stream));
  try
    OleCheck(WebBrowser.Document.QueryInterface(IPersistStreamInit, psi));
    OleCheck(psi.InitNew);
    OleCheck(psi.Load(Stream));
  finally
    psi := nil;
    Stream := nil;
  end;
end;

function SetAssociatedExec(FileExt,FileType,FileDesc,MIMEType,ExecName:String):Boolean;
var
  reg:TRegistry;
begin
  result:=false;
  if (FileExt='') or (ExecName='') then exit;
  reg:=TRegistry.Create;
  try
    reg.RootKey:=HKEY_CLASSES_ROOT;
    if not Reg.OpenKey(FileExt,true) then
      exit;
    reg.WriteString('',FileType);
    if MIMEType <> '' then
      reg.WriteString('Content Type',MIMEType);
    reg.CloseKey;
    if not Reg.OpenKey('shell\open\command',true)  then exit;
    reg.WriteString('',ExecName);
    reg.CloseKey;
  finally
    reg.Free;
  end;
end;

Constructor TSubFile.create;
begin
  tag:=FILE_TAG;
end;

function TSubFile.getClassName:String;
var
  index:Integer;
begin
  index := Pos('.java',name);
  if index <=0 then
    result:=''
  else
    result:=Copy(name,1,index-1);
end;

function TSubFile.getFileName:String;
begin
  if package = '' then
    result:=name
  else
    result:=translatePackage(package) + name;
end;

Constructor TPackage.create;
begin
  tag:=PACKAGE_TAG;
  fileList:=TObjectList.Create(false);//文件列表
end;

Destructor TPackage.Destroy;
var
  i:Integer;
begin
  if fileList <> nil then
  begin
    for i:=0 to fileList.Count-1 do
    begin
      TSubFile(fileList.Items[i]).free;
    end;
    fileList.Clear;
    fileList.Free;
  end;
  inherited;
end;
procedure TPackage.deleteFile(subfile:TSubFile);
var
  i:integer;
begin
  for i:=0 to fileList.Count-1 do
  begin
    if TSubFile(fileList[i]) = subfile then
    begin
       fileList.Delete(i);
       break;
    end;
  end;
end;

function TPackage.getFile(index:Integer):TSubFile;
begin
  if ( fileList <> nil )
      and ( index <= fileList.Count-1) then
    result := TSubFile(fileList.Items[index])
  else
    result := nil;
end;

Constructor TProject.create;
begin
  inherited;
  packageList:=TObjectList.Create(false);//包列表
  //g_bpList:=TObjectList.Create(false);
  tag := PROJECT_TAG
end;


Destructor TProject.Destroy;
var
  i:integer;
begin

  if packageList <> nil then
  begin
    for i:=0 to packageList.Count-1 do
    begin
      TPackage(packageList.Items[i]).Destroy;
    end;
    packageList.Clear;
    packageList.Free;
  end;
  {if g_bpList <> nil then
  begin
    for i:=0 to g_bpList.Count-1 do
    begin
      TLineBreakPoint(g_bpList.Items[i]).Free;
    end;
  end;
  }
  inherited;

end;

function TProject.findSubFileByName(s:String):TSubFile;
var
  i,j:Integer;
  subfile:TSubFile;
  pack:TPackage;
begin
  result:=nil;
  for i:=0 to self.packageList.Count-1 do
  begin
    pack:=TPackage(packageList[i]);
    for j:=0 to pack.fileList.Count-1 do
    begin
      subFile:=TSubFile(pack.fileList[j]);
      if s = getFileFromSubFile(subFile) then
      begin
        result:=subFile;
        exit;
      end;
    end;
  end;
end;

procedure TProject.deletePackage(pack:TPackage);
var
  i:Integer;
begin
  for i:=0 to self.packageList.Count-1 do
  begin
    if TPackage(packageList[i]) = pack then
    begin
      packageList.Delete(i);
      if pack.packNode <> nil then
         pack.packNode.Delete;      
      pack.Destroy;
      break;
    end;
  end;
end;

function TProject.getPackage(index:Integer):TPackage;
begin
  if ( packageList <> nil )
      and ( index <= packageList.Count-1) then
    result := TPackage(packageList.Items[index])
  else
    result := nil;
end;

function TProject.saveProjectToFile(fileName:String):Boolean;
begin
  result:=false;
end;

function getCurrentLoginUser:String;
Var
  Reg:TRegistry;
begin
  Reg:=TRegistry.Create;
  try
    Reg.RootKey:=HKEY_LOCAL_MACHINE;
    Reg.OpenKey('Software\Microsoft\Windows NT\CurrentVersion',False);
    result:=Reg.ReadString('RegisteredOwner');
    Reg.CloseKey;

  finally
    Reg.Free;
  end;
end;

function AssembleFileName(path,name:String):String;
begin
  result:=GetRealPath(path)+name;
end;
procedure WriteCfgString(section,name,value:String);
var
  iniFile: TIniFile;
begin
  iniFile := TIniFile.Create(g_exeFilePath + CONFIGFILE);
  try
    iniFile.WriteString(section,name,value);
  finally
    iniFile.Free;
  end;
end;

function ReadCfgString(section,name:String):String;
var
  iniFile: TIniFile;
begin
  iniFile := TIniFile.Create(g_exeFilePath + CONFIGFILE);
  try
    result:=iniFile.ReadString(section,name,'');
  finally
    iniFile.Free;
  end;
end;

function FindNextLeftKuohao(beginPos:Integer;s:String):Integer;
var
  i,len,count:Integer;
begin
  s:=preCompile(s);
  len:= Min(beginPos,length(s));
  count:=0;
  result:=-1;
  for i:=len downto 0 do
  begin
    if s[i] = '{' then
      count := count + 1;
    if s[i] = '}' then
      count := count - 1;
    if count > 0 then
    begin
      result:=i;
      exit;
    end;
  end;
end;
function FindNextRightKuohao(beginPos:Integer;s:String):Integer;
var
  i,count:Integer;
begin
  s:=preCompile(s);
  count:=0;
  result:=-1;
  for i:=beginPos+1 to length(s) do
  begin
    if s[i] = '}' then
      count := count + 1;
    if s[i] = '{' then
      count := count - 1;
    if count > 0 then
    begin
      result:=i-1;
      exit;
    end;
  end;
end;
function preCompileStr(s:String):String;
var
  pos1,pos2,i:Integer;
  findZhushi1,findZhushi2:Boolean;
  rs:String;
begin
  rs:=s;
  while true do
  begin
    pos1:=Pos('//',rs);
    if pos1 > 0 then
    begin
      rs[pos1]:='!';
      rs[pos1+1]:='!';
      for i:=pos1+2 to Length(rs) do
      begin

        if ( (rs[i]=#13) and (rs[i+1]=#10) ) then
          break;
        rs[i]:=' ';
      end;
      findZhushi1:=true;
    end else
      findZhushi1:=false;

    pos2:=Pos('/*',rs);
    if pos2 > 0 then
    begin
      rs[pos2]:='!';
      rs[pos2+1]:='!';
      for i:=pos2+2 to Length(rs) do
      begin
        if ( (rs[i]='*') and (rs[i+1]='/') ) then
          break;
        rs[i]:=' ';
      end;
      findZhushi2:=true;
    end else
      findZhushi2:=false;

    if  not findZhushi1 and not findZhushi2  then
       break;
  end;
  result := rs;
end;

function preCompile(s:String):String;
var
  pos1,pos2,i:Integer;
  findZhushi1,findZhushi2:Boolean;
  rs:String;
begin
  rs:=s;
  while true do
  begin
    pos1:=Pos('//',rs);
    if pos1 > 0 then
    begin
      for i:=pos1 to Length(rs) do
      begin
        if ( (rs[i]=#13) and (rs[i+1]=#10) ) then
          break;
        rs[i]:=' ';
      end;
      findZhushi1:=true;
    end else
      findZhushi1:=false;

    pos2:=Pos('/*',rs);
    if pos2 > 0 then
    begin
      for i:=pos2 to Length(rs) do
      begin
        if ( (rs[i]='*') and (rs[i+1]='/') ) then
          break;
        rs[i]:=' ';
      end;
      findZhushi2:=true;
    end else
      findZhushi2:=false;

    if  not findZhushi1 and not findZhushi2  then
       break;
  end;
  result := rs;
end;



function findMainMethod(subFile:TSubFile):Boolean;
var
  reg:TRegExpr;
  content:String;
begin
  content:=getFileLatestContent(subFile);
  reg:=TRegExpr.Create;
  reg.Expression:=MAINMETHODEXPRESSION;
  reg.Compile;
  if reg.Exec(preCompile(content)) then
    result:=true
  else
    result:=false;
end;

function findMainMethod(content:String):Boolean;
var
  reg:TRegExpr;
begin
  reg:=TRegExpr.Create;
  reg.Expression:=MAINMETHODEXPRESSION;
  reg.Compile;
  if reg.Exec(preCompile(content)) then
    result:=true
  else
    result:=false;
end;

Constructor TRunAppInfo.create;
begin
    inherited;
    className:='';
    packageName:='';
    parameters:='';
    status:=0;
end;

procedure DebugApp(className,packageName,filename:String;isApplet:Boolean);
var
  runParamSetupDlg:TRunParamSetupDlg;
  ClassAllName,iniPath:String;
  index:Integer;
  linkParam:String;
  htmlFileName:String;
  app:TAppInfo;
  initStop:Boolean;
begin
   if ( G_VersionType = TRAILVERSION )  and ( applist.Count >= MaxDebugApplication)  then
   begin
     msgFrm.operatorMemo.Lines.Add('You are using Trial Version,you can''t debug over 2 application at the same time.');
     msgFrm.operatorMemo.Lines.Add('Please login '+g_domain_web_site+' to get license.');
     exit;
   end;

   if packageName =  '' then
     ClassAllName:=className
   else
     ClassAllName:=packageName + '.' + className;

    //必要的情况下编译该文件
    if not CompileJava(fileName,packageName,true) then
      exit;

   index:=Pos(translatePackage(packageName)+className+'.java',fileName);
   if index <= 0 then
     exit;
   iniPath:=Copy(fileName,1,index-1);
   app:= getAppByName(ClassAllName,fileName);
   if app  <> nil then
   begin
     setCurAppNode(app);
     DebugForm.Show;
     DebugForm.Update;
     if MessageBox(DebugForm.handle,PChar(Format(getErrorMsg('AppDebugIsRunning'),[ClassAllName])),
                   PChar(getErrorMsg('ConfirmCaption')),
                   MB_OKCANCEL or MB_ICONWARNING) = IDOK then
     begin
       //终止程序
       SendCommand(REQUEST_EXIT,app.appID,'exit');
       //重新启动
     end else
       exit;
   end;

   if isApplet  then
   begin
     appParam.style:=2;
     initStop:=true;
     htmlFileName:=createAppletHtml(ClassAllName,iniPath,initStop);
     if htmlFileName = '' then
       exit;
     appParam.style:=2;
     appParam.className:='sun.applet.Main';
     appParam.appletClass:=ClassAllName;
     appParam.parameters:=ExtractFileName(htmlFileName);
     appParam.cp:=getAllClassPath;
     appParam.initialPath:=iniPath;
     appParam.isMainStop:=initStop;
     appParam.address :=FormatDateTime('hhnnsszzz',now);
     appParam.link:=lmShmem;
     //appParam.address :='6666';
     //appParam.link:=socket;
     if (appParam.link = lmSocket)  then
       linkParam:='-connect com.sun.jdi.SocketListen:port='+appParam.address
     else
       linkParam:='-connect com.sun.jdi.SharedMemoryListen:name='+ appParam.address;
     //通知debug server center建立listen
     SendCommand(REQUEST_CREATE,'0',LinkParam);
   end else
   begin
     runParamSetupDlg :=TRunParamSetupDlg.Create(nil);
     runParamSetupDlg.appNameLbl.Caption:='java ' + ClassAllName;
     RunParamSetupDlg.mainStopChecked.Enabled:=true;
     if (runParamSetupDlg.ShowModal = mrOK  ) then
     begin
      appParam.style:=1;
      appParam.fileName:=filename;
      appParam.className:=ClassAllName;
      appParam.parameters:=runParamSetupDlg.paramsEdit.Text;

      appParam.cp := getAllClassPath ;
      appParam.initialPath := iniPath;
      appParam.isMainStop :=  RunParamSetupDlg.mainStopChecked.Checked;
      appParam.link := lmShmem;
      appParam.address:=FormatDateTime('hhnnsszzz',now);
      //appParam.address :='6666';
      //appParam.link:=lmSocket;

      if (appParam.link = lmSocket)  then
         linkParam:='-connect com.sun.jdi.SocketListen:port='+appParam.address
      else
         linkParam:='-connect com.sun.jdi.SharedMemoryListen:name='+appParam.address ;
      //通知debug server center建立listen
      SendCommand(REQUEST_CREATE,'0',LinkParam);
     end;
     runParamSetupDlg.free;
   end;
   DebugForm.Show;
   DebugForm.Update;

end;

procedure TRunAppInfo.RunApp(className,packageName,filename:String;isProject:Boolean;isApplet:Boolean);
var
  index:Integer;
  runParamSetupDlg:TRunParamSetupDlg;
  commandLine:String;
  ClassAllName:String;
  htmlFileName:String;
  initStop:Boolean;
begin
    //kill以前的进程
    EndRun;

    self.className:=trim(className);
    self.packageName:=trim(packageName);

    if packageName =  '' then
      ClassAllName:=className
    else
      ClassAllName:=packageName + '.' + className;

    //不是java文件
    if Pos('.java',lowerCase(fileName)) <= 0 then
      exit;
    if not isApplet and not isProject then
    begin
      runParamSetupDlg:=TRunParamSetupDlg.Create(nil);
      runParamSetupDlg.appNameLbl.Caption:='java ' + ClassAllName;
      RunParamSetupDlg.mainStopChecked.Enabled:=false;
      if runParamSetupDlg.ShowModal = mrOK then
      begin
        parameters := runParamSetupDlg.paramsEdit.Text ;
        runParamSetupDlg.Free;
      end else
      begin
        runParamSetupDlg.Free;
        exit;
      end;
    end;
    //  if  not InputQuery(getErrorMsg('PleaseInputParamCaption'),getErrorMsg('PleaseInputParameters'),parameters)  then
    //    exit;

    //必要的情况下编译该文件
    if not CompileJava(fileName,packageName,true) then
      exit;
    index:=Pos(translatePackage(packageName)+className+'.java',fileName);
    if index <= 0 then
      exit;

    iniPath:=Copy(fileName,1,index-1);
    //do your thing;

    if isApplet then
    begin
      initStop:=false;    
      htmlFileName:=createAppletHtml(ClassAllName,iniPath,initStop);
      if htmlFileName = '' then
        exit;
    end;

    if isApplet then //applet
      commandLine := g_javaw
                   +' -cp ".;'+ getAllClassPath
                   +'"  sun.applet.Main ' + ExtractFileName(htmlFileName) + #0
    else             //main
      commandLine := g_javaw
                   +' -cp ".;'+ getAllClassPath
                   +'" '+ ClassAllName + ' '+ parameters + #0;

    {创建一个命名管道用来捕获console程序的输出}
    Createpipe(ReadPipeInput, WritePipeInput, @g_Security, 0);
    Createpipe(ReadPipeOutput, WritePipeOutput, @g_Security, 0);
    InitStartUpInfo;

    //创建应用进程
    msgFrm.ConsoleOutputMemo.Lines.Add('Begin Run: '+ g_javaw + ' ' + ClassAllName + ' ' + parameters);
    msgFrm.ConsoleOutputMemo.Lines.Add('-----------------------------------------------------------------------------');
    if  CreateProcess(nil,@commandLine[1], @g_Security, @g_Security, true,
      CREATE_NEW_CONSOLE or NORMAL_PRIORITY_CLASS,nil, @iniPath[1], start, ProcessInfo) then
    begin
      //如果创建应用成功，创建监视输出线程
      status:=1;
      getOutputThread := TReadRunOutput.Create(msgFrm.ConsoleOutputMemo,G_curApp);
      msgFrm.setActivePage(BUILDPAGE);
    end;

end;

procedure TRunAppInfo.InitStartUpInfo;
begin
  {设置console程序的启动属性}
  FillChar(Start, Sizeof(Start), #0);
  with start do
  begin
    cb := SizeOf(start);
    start.lpReserved := nil;
    lpDesktop := nil;
    lpTitle := nil;
    dwX := 0;
    dwY := 0;
    dwXSize := 0;
    dwYSize := 0;
    dwXCountChars := 0;
    dwYCountChars := 0;
    dwFillAttribute := 0;
    cbReserved2 := 0;
    lpReserved2 := nil;
    hStdInput := ReadPipeInput; //将输入定向到我们建立的ReadPipe上
    hStdOutput := WritePipeOutput; //将输出定向到我们建立的WritePipe上
    hStdError := WritePipeOutput;//将错误输出定向到我们建立的WritePipe上
    dwFlags := STARTF_USESTDHANDLES or STARTF_USESHOWWINDOW;
    wShowWindow := SW_SHOW;//设置窗口为hide
  end;
end;
Destructor TRunAppInfo.Destroy;
begin
  EndRun;
  inherited;
end;

function TRunAppInfo.isRuning:Boolean;
var
  exitcode:DWord;
begin
  GetExitCodeProcess(ProcessInfo.hProcess, exitcode);
  //结束监视输出线程
  if ( exitcode = STILL_ACTIVE ) then //如果当前进程没有结束
    result := true
  else
    result := false;
end;

procedure TRunAppInfo.EndRun;
var
  exitCode:DWord;
begin
  //先通知监视进程结束
  if Assigned(getOutputThread) then
  begin   
    getOutputThread.Terminate ;
    getOutputThread:=nil;
  end;
  GetExitCodeProcess(ProcessInfo.hProcess, exitcode);
  //结束监视输出线程
  if ( exitcode = STILL_ACTIVE ) then //如果当前进程没有结束
  begin
          //强制结束
          TerminateProcess(ProcessInfo.hProcess,0);
          CloseHandle(ProcessInfo.hProcess);
          CloseHandle(ProcessInfo.hThread);
  end;
  //关闭匿名管道
  if WritePipeInput <> 0 then
  begin
    CloseHandle(WritePipeInput);
    WritePipeInput := 0;
  end;
  if ReadPipeInput <> 0  then
  begin
    CloseHandle(ReadPipeInput);
    ReadPipeInput := 0;
  end;
  if WritePipeOutput <> 0 then
  begin
    CloseHandle(WritePipeOutput);
    WritePipeOutput := 0;
  end;
  if ReadPipeOutput <> 0  then
  begin
    CloseHandle(ReadPipeOutput);
    ReadPipeOutput := 0;
  end;

  className:='';
  packageName:='';
  parameters:='';
  status:=0;
end;

Function GetFileDateTime(FileName:String):TDateTime;
Var
  FStruct : TOFSTRUCT;
  TheDate : TDateTime;
  Han1 : Integer;
  I : Integer;
begin
  Han1 := OpenFile(PChar(FileName), FStruct, OF_SHARE_DENY_NONE);
  I := FileGetDate(Han1);
  TheDate := FileDateToDateTime(I);
  Result := TheDate;
  _lclose(Han1);
end;

function FindAppointedString(content:String;str:String):Boolean;
var
  regExr:TRegExpr;
begin
   preCompile(content);
   regExr:= TRegExpr.Create;
   regExr.Expression := str;
   regExr.Compile;
   if regExr.Exec (content) then
   begin
     result:=true
   end else
    result:=false;
end;

function FindPackage(content:String;var packageName:String):Boolean;
var
  s:String;
  regExr:TRegExpr;
begin
   preCompile(content);
   regExr:= TRegExpr.Create;
   regExr.Expression := 'package\s+[\$_a-zA-Z\d_\-\.]+';
   regExr.Compile;
   if regExr.Exec (content) then
   begin
     s:=regExr.Match[0];
     s:=ansiReplaceStr(s,#9,' ');
     s:=ansiReplaceStr(s,#13#10,' ');
     if Copy(s,1,8) = 'package ' then
     begin
       packageName := Copy(s,9,length(s));
       result:=true;
       exit;
     end;
   end;
   if assigned (regExr) then
     regExr.Free;
  result:=false;
end;

procedure TCommandDataDM.DataModuleCreate(Sender: TObject);
begin
    G_tempHtmlFileList:=TStringList.Create;
    SynAutoComplete:= TSynAutoComplete.Create(self);
    SynAutoComplete.AutoCompleteList.LoadFromFile(g_exeFilePath + AUTOCOMPLETEFILE);
end;

procedure TCommandDataDM.DataModuleDestroy(Sender: TObject);
var
  i:Integer;
begin
  for i:=0 to G_tempHtmlFileList.Count-1 do
  begin
    if FileExists(G_tempHtmlFileList[i]) then
      deleteFile(G_tempHtmlFileList[i]);
  end;
  G_tempHtmlFileList.Free;
  SynAutoComplete.Destroy;
end;

procedure IniJavaEnvironment;
var
  javaHome:array[0..255] of Char;
  version:String;
  setFrm:TsetJavaHomeForm;
begin
  FillChar(javaHome,sizeof(javaHome),#0);
  g_SystemClassPath := AllocMem(2048 );
  GetEnvironmentVariable('CLASSPATH',g_SystemClassPath,2048);
  if g_status = '1' then
  begin
    GetEnvironmentVariable('JAVA_HOME',javaHome,sizeof(javaHome));
    g_javaHome:=GetRealPath(trim(javaHome));
    if  Fileexists(g_javaHome+'bin\java.exe') then
    begin
      SetJavaHomeEnv(g_javaHome);
    end;    
  end
  else
    g_javaHome := trim(ReadCfgString('JDK_CFG','JAVA_HOME'));
  g_javaHome:=GetRealPath(g_javaHome);
  //g_javaHome:=trim(javaHome);
  //检查是否设置环境变量
  if  Not Fileexists(g_javaHome+'bin\java.exe') then
  begin
    MessageBox(ideFrm.handle,PChar(getErrorMsg('PleaseCheckIfSetupJavaHome')),
                 PChar(getErrorMsg('ErrorDlgCaption')),MB_OK or MB_ICONWARNING);
    setFrm:=TsetJavaHomeForm.create(nil,0);
    setFrm.showModal;
    setFrm.free;
    SetJavaHomeEnv(g_javaHome);
  end;


  g_java:= '"' + g_javaHome + 'bin\java"';
  g_javaw:= '"' + g_javaHome + 'bin\javaw"';
  g_javac:= '"' + g_javaHome + 'bin\javac"';
  g_javaJar:= '"' + g_javaHome + 'bin\jar"';
  //检查jdk版本
  if not CheckJDKVersion(version) then
  begin
    if MessageBox(ideFrm.handle,PChar(Format(getErrorMsg('JavaVersionCheck'),[version,#13#10,#13#10])),
                 PChar(getErrorMsg('ErrorDlgCaption')),MB_OKCANCEL or MB_ICONWARNING) <> IDOK  then
    begin
      FreeMem(g_SystemClassPath,2048);
      halt;
    end;
  end;
  ideFrm.caption := FORM_PRE_CAPTION + 'JDK version ' +  version;
end;

function CheckJDKVersion(var version:String):Boolean;
const
  ReadBuffer = 1024;
var
  start:TStartupInfo;
  ReadPipeOutput, WritePipeOutput: THandle;
  pi:TProcessInformation;
  commandLine:String;
  BytesRead,exitcode: DWord;
  Buffer: PChar;
  Buf: string;
  index1,index2:Integer;
begin
    commandLine:=g_java +' -version'+#0;
    Createpipe(ReadPipeOutput, WritePipeOutput, @g_Security, MAXPIPESIZE);
    {设置console程序的启动属性}
    FillChar(Start, Sizeof(Start), #0);
    with start do
    begin
      cb := SizeOf(start);
      start.lpReserved := nil;
      lpDesktop := nil;
      lpTitle := nil;
      dwX := 0;
      dwY := 0;
      dwXSize := 0;
      dwYSize := 0;
      dwXCountChars := 0;
      dwYCountChars := 0;
      dwFillAttribute := 0;
      cbReserved2 := 0;
      lpReserved2 := nil;
      hStdInput := ReadPipeOutput; //将输入定向到我们建立的ReadPipeOutput上
      hStdOutput := WritePipeOutput; //将输出定向到我们建立的WritePipe上
      hStdError := WritePipeOutput;  //将错误输出定向到我们建立的WritePipe上
      dwFlags := STARTF_USESTDHANDLES or STARTF_USESHOWWINDOW;
      wShowWindow := SW_HIDE;//设置窗口是否显示
    end;

    if  CreateProcess(nil,@commandLine[1], @g_Security, @g_Security, true,
      CREATE_NEW_CONSOLE or NORMAL_PRIORITY_CLASS,nil,nil, start, pi) then  //如果创建新进程成功
    begin
      //等待进程结束,最长等待时间
      WaitforSingleObject( pi.hProcess, 10000);

      //如果没有终止javac进程，那么强制终止进程
      GetExitCodeProcess(pi.hProcess, exitcode);
      if ( exitcode = STILL_ACTIVE ) then //如果当前进程已经结束
      begin
        TerminateProcess(pi.hProcess,0);
      end;
      //关闭管道的写端
      CloseHandle(WritePipeOutput);
      Buf := '';
      Buffer := AllocMem(ReadBuffer + 1);
      {读取console程序的输出}
      repeat
        BytesRead := 0;
        ReadFile(ReadPipeOutput, Buffer[0], ReadBuffer, BytesRead, nil);
        Buffer[BytesRead] := #0;
        OemToAnsi(Buffer, Buffer);
        Buf := Buf + string(Buffer);
      until (BytesRead < ReadBuffer);


      if buf = '' then
        result := false
      else
      begin
        index1:=Pos(#13#10,buf);
        if index1 <=0 then
          result:=false
        else
        begin
          buf:=trim(Copy(buf,1,index1-1));
          index1:=Pos('"',buf);
          buf := Copy(buf,index1+1,length(buf));
          index2:=Pos('"',buf);
          version:=Copy(buf,1,index2-1);

          if CompareStr(JDKVERSION12,version) > 0 then
          begin
            result:=false;
          end else
          begin
            result:=true;
          end;
        end;
      end;
      FreeMem(Buffer);
      //关闭管道的写端
      CloseHandle(ReadPipeOutput);
    end
    else
      result:=false;

end;
procedure changePackageName(fn,newPack:String);
var
  oldPack:String;
  regExr:TRegExpr;
  edit:IEditor;
  isOpenNow:Boolean;
  sl:TStrings;
begin
  if not SetFileCanWrite(fn) then
    exit; 
  if isJavaFile(ExtractFileName(fn) ) then
  begin
    edit:=GI_EditorFactory.GetEditorByName(fn);
    if edit <> nil then
    begin
      isOpenNow:=true;
      sl:=edit.GetSyneditor.Lines;
    end
    else
    begin
      if not FileExists(fn) then
        exit;
      sl:=TStringList.Create;
      sl.LoadFromFile(fn);
      isOpenNow:=false;
    end;

    findPackage(sl.Text,oldpack);
    if oldpack <> newpack then
    begin
      if ( MessageBox(idefrm.handle,PChar(Format(getErrorMsg('ModifiedPackage'),[fn])),
              PChar(getErrorMsg('ErrorDlgCaption')),
              MB_OKCANCEL or MB_ICONWARNING) <> IDOK ) then
      exit;
      if oldpack = '' then
      begin
        //insert into a line of 'package ...;'
        sl.Insert(0,'package'#9 + newpack+' ;');
      end else
      begin
        //preCompile(sl.Text);
        regExr:= TRegExpr.Create;
        regExr.Expression := 'package\s+'+oldpack+'\s*;';
        regExr.Compile;
        if newpack = '' then
        begin
          sl.Text:=regExr.Replace(sl.Text,'');
        end else
        begin
          sl.Text:=regExr.Replace(sl.text,'package'#9+newpack+ ' ;');
        end;
      end;
      if assigned(regExr) then
        regExr.Free;
    end;
    if isOpenNow then
      edit.GetSynEditor.Modified := true;
    if not isOpenNow and assigned(sl) then
    begin
      sl.SaveToFile(fn);
    end;
    if assigned(sl) then
      sl.Free;
  end;
end;

{procedure GenerateJDKHelpLib(docpath:String;tag:Integer);
var
  xmlDocument:TXMLDocument;
  tempComponent:TComponent;
  rootNode,packNode,classNode:IXMLNode;
  //i,j:Integer;
  //fl:TStringList;
  packagelist,classList:TStringList;
  regexr,regexr2:TRegExpr;
  packageName,className,helpFileName:String;
begin
  if not FileExists(getRealPath(docpath)+'overview-frame.html') then
  begin
    //
    exit;
  end;

  tempComponent:=TComponent.Create(nil);
  xmlDocument:=TXMLDocument.Create(tempComponent);
  xmlDocument.Active:=true;
  rootNode:=XMLDocument.CreateNode('helpLib');


  if tag = JDKHELPFILE_TAG then
    rootNode.Attributes['name']:='JDK api'
  else  if tag = SERVLETHELPFILE_TAG then
    rootNode.Attributes['name']:='Servlet api'
  else  if tag = JSPHELPFILE_TAG then
    rootNode.Attributes['name']:='JSP api';

  regexr:=TRegExpr.Create;
  regexr.Expression:='>[a-zA-Z0-9_\-\$]+(\.[a-zA-Z0-9_\-\$]+)+<';
  regexr.Compile;
  packagelist:=TStringList.Create;
  classList:=TStringList.Create;
  regexr2:=TRegExpr.Create;
  regexr2.Expression:='>[a-zA-Z0-9_\-\$]+<';
  regexr2.Compile;

  try
    packageList.LoadFromFile(getRealPath(docpath)+'overview-frame.html');
    if regExr.Exec(packageList.Text) then
    REPEAT
        packageName:=Copy(regExr.Match[0],2,length(regExr.Match[0])-2);
        if packagename = '' then
          continue;
        //添加包结点
        packNode:=rootNode.AddChild('package');
        packNode.Attributes['name']:=packageName;

        classList.Clear;
        if not FileExists(getRealPath(docpath)+translatePackage(packageName)+'package-frame.html') then
          continue;
        classList.LoadFromFile(getRealPath(docpath)+translatePackage(packageName)+'package-frame.html');

        if regexr2.Exec(classList.Text) then
        REPEAT
        //添加类结点
          className:=Copy(regExr2.Match[0],2,length(regExr2.Match[0])-2);
          classNode:=packNode.AddChild('class');
          classNode.Attributes['name']:=className;
        UNTIL not regexr2.ExecNext;
    UNTIL not regExr.ExecNext;
  finally
     regExr.Free;
     regexr2.Free;
  end;
  if tag = JDKHELPFILE_TAG then
    helpFileName:=g_helpFilePath + JDKHELPFILE
  else  if tag = SERVLETHELPFILE_TAG then
    helpFileName:=g_helpFilePath + SERVLETHELPFILE
  else  if tag = JSPHELPFILE_TAG then
    helpFileName:=g_helpFilePath + JSPHELPFILE;

  packageList.Clear;
  packageList.Text := rootNode.XML;
  packageList.SaveToFile(helpFileName);

  if assigned (classList) then
    classList.Free;
  if assigned (packageList) then
    packageList.Free;
  xmlDocument.Destroy;
  tempComponent.Destroy;
end;
}
function  findPathNoPackage(path,pack:String):String;
var
  index:Integer;
begin
  if pack = '' then
  begin
    result:=ExtractFilePath(path);
    exit;
  end;
  index:=Pos(translatePackage(pack)+ExtractFileName(path),path);
  if index > 0 then
    result:=Copy(path,1,index-1)
  else
    result:= ExtractFilePath(path);
end;

function CheckAllJavaCompile:Boolean;
var
  i,j:Integer;
  pack:TPackage;
  subfile:TSubFile;
  classFileName:String;
begin
  result := true;
  for i := 0 to G_Project.packageList.Count-1 do
  begin
    pack:=TPackage(G_Project.packageList[i]);
    for j:=0 to pack.fileList.Count-1 do
    begin
      subfile:=TSubFile(pack.fileList[j]);
      if isJavaFile(subfile.name)   then
      begin
        classFileName:=Copy(getFileFromSubFile(subFile),1,length(getFileFromSubFile(subFile))-5) + '.class';
        if not FileExists(classFileName) then
        begin
          result:=false;
          exit;
        end;
      end;
    end;
  end;
end;

function DelDir(path:string):boolean;
var SHFileOpStruct: TSHFileOpStruct;
begin
 fillchar(SHFileOpStruct,sizeof(TSHFileOpStruct),0);
 with SHFileOpStruct do
 begin
   Wnd:=ideFrm.handle;
   wFunc:=FO_DELETE;
   pFrom:=pchar(path+#0);
   pTo:=nil;
   fFlags:=FOF_NOCONFIRMATION or FOF_SILENT;
   lpszProgressTitle:=PChar('Deleting '+ path);
 end;
 result:=SHFileOperation(SHFileOpStruct)=0;
end;

procedure ZipFiles(FileName : string);
var
  ZipRec   : TZCL;
  ZUF      : TZipUserFunctions;
  FNVStart : PCharArray;
begin

  { precaution }
  //if Trim(FileName) = '' then Exit;
  //if FileList.Count <= 0 then Exit;

  { initialize the dll with dummy functions }
  SetDummyInitFunctions(ZUF);

  { number of files to zip }
  ZipRec.argc := 0;

  { name of zip file - allocate room for null terminated string  }
  GetMem(ZipRec.lpszZipFN, Length(FileName) + 1 );
  ZipRec.lpszZipFN := StrPCopy( ZipRec.lpszZipFN, FileName);
  try
    { dynamic array allocation }
    GetMem(ZipRec.FNV, ZipRec.argc * SizeOf(PChar));
    FNVStart := ZipRec.FNV;
    try
      { copy the file names from FileList to ZipRec.FNV dynamic array }

      try
        { send the data to the dll }
        ZpArchive(ZipRec);
      finally
        { release the memory for the file list }
        ZipRec.FNV := FNVStart;
      end;

    finally
      { release the memory for the ZipRec.FNV dynamic array }
      ZipRec.FNV := FNVStart;
      FreeMem(ZipRec.FNV, ZipRec.argc * SizeOf(PChar));
    end;
  finally
    { release the memory for the FileName }
    FreeMem(ZipRec.lpszZipFN, Length(FileName) + 1 );
  end;
end;
{----------------------------------------------------------------------------------}
procedure SetDummyInitFunctions(var Z:TZipUserFunctions);
var
  ZipOptions : TZPOpt;
begin

  { prepare ZipUserFunctions structure }
  with Z do
  begin
    @Print     := @DummyPrint;
    @Comment   := @DummyComment;
    @Password  := @DummyPassword;
    @Service   := @DummyService;
  end;
  { send it to dll }
  ZpInit(Z);

  ZipOptions.Date           := nil;
  ZipOptions.szRootDir      := nil;
  ZipOptions.szTempDir      := nil;
  ZipOptions.fSuffix        := false;
  ZipOptions.fEncrypt       := false;
  ZipOptions.fSystem        := false;
  ZipOptions.fVolume        := false;
  ZipOptions.fExtra         := false;
  ZipOptions.fNoDirEntries  := false;
  ZipOptions.fExcludeDate   := false;
  ZipOptions.fIncludeDate   := false;
  ZipOptions.fVerbose       := false;
  ZipOptions.fQuiet         := false;
  ZipOptions.fCRLF_LF       := false;
  ZipOptions.fLF_CRLF       := false;
  ZipOptions.fJunkDir       := false;
  ZipOptions.fGrow          := false;
  ZipOptions.fForce         := false;
  ZipOptions.fMove          := false;
  ZipOptions.fDeleteEntries := false;

  ZipOptions.fFreshen       := false;
  ZipOptions.fJunkSFX       := false;
  ZipOptions.fLatestTime    := false;
  ZipOptions.fOffsets       := false;
  ZipOptions.fPrivilege     := false;
  ZipOptions.fEncryption    := false;
  ZipOptions.fRecurse       := 0;
  ZipOptions.fRepair        := 0;
  ZipOptions.fUpdate        := true;
  ZipOptions.fComment       := true;
  ZipOptions.fLevel := '0';
  if not ZpSetOptions(ZipOptions) then
    ShowMessage('Error setting Zip Options');
    
end;
{----------------------------------------------------------------------------------}
function DummyPrint(Buffer: PChar; Size: ULONG): integer;
begin
  Result := Size;
end;
{----------------------------------------------------------------------------------}
function DummyPassword(P: PChar; N: Integer; M, Name: PChar): integer;
begin
  Result := 1;
end;
{----------------------------------------------------------------------------------}
function DummyComment(Buffer: PChar): PChar;
begin
  StrPCopy(Buffer,g_JarComment);
  Result    := Buffer;

end;
{----------------------------------------------------------------------------------}
function DummyService(Buffer: PChar; Size: ULONG): integer;
begin
  Result := 0;
end;

{
        if function return '' then
           generate html file fail
        else
           return the html file name(include path)
}
function createAppletHtml(classAllName,savePath:String;var initStop:Boolean):String;
var
  content:TStringList;
  appletParam:String;
  i,index:Integer;
  appletFrm: TcreateAppletFrm;
  htmlFileName,className:String;
begin
  //生成applet 的html文件
  appletFrm := TcreateAppletFrm.Create(ideFrm);
  appletFrm.appletNameLbl.Caption:=classAllName;
  index:=LastDelimiter('.',classAllName);
  if index <= 0 then
    className := ClassAllName
  else
    className:=Copy(classAllName,index+1,length(classAllName));

  appletFrm.appletNameEdit.Text:=className;

  htmlFileName := getRealPath(savepath) + className +'.html';

  appletFrm.isStopAtInit.Enabled := initStop;
  
  if appletFrm.ShowModal = mrOK then
  begin
    if appletFrm.isStopAtInit.Checked then
      initStop:=true
    else
      initStop:=false;
    content:=TStringList.Create;
    content.LoadFromFile(g_templatePath + 'AppletTemplate.html');
    appletParam:='<applet code='+ ClassAllName +' codebase='+ appletFrm.codebaseEdit.Text +' width='+trim(appletFrm.widthEdit.Text)
                 +' height='+trim(appletFrm.heightEdit.Text);
    if appletFrm.appletNameEdit.Text <> '' then
      appletParam:=appletParam+' name='+trim(appletFrm.appletNameEdit.Text);
    if appletFrm.useArchive.Checked  then
      appletParam:=appletParam+' archive='+trim(appletFrm.archiveClassEdit.Text);
    appletParam:=appletParam + ' >';
    if appletFrm.paramList.Strings.Count > 0  then
    begin
      for i:=0 to appletFrm.paramList.Strings.Count-1 do
        if ((trim(appletFrm.paramList.Strings.Names[i])<>'') and (trim(appletFrm.paramList.Strings.Values[appletFrm.paramList.Strings.Names[i]])<>'') ) then
          appletParam:=appletParam+ '<param name="'+appletFrm.paramList.Strings.Names[i] +'" value="'+appletFrm.paramList.Strings.Values[appletFrm.paramList.Strings.Names[i]]+'">';
    end;
    appletParam:=appletParam +#13#10+'</applet>';
    content.text:=AnsiReplaceStr(content.text,'<APPLETNAME>',className);
    content.text:=AnsiReplaceStr(content.text,'<APPLETCONFIG>',appletParam);
    content.SaveToFile(htmlFileName);
    content.free;

    if not FileExists(htmlFileName) then
    begin
      showerror(ideFrm.Handle,getErrorMsg('GenerateHtmlFail'),getErrorMsg('ErrorDlgCaption'),MB_OK);
      result:='';
    end
    else
      result:=htmlFileName;
  end;
  appletFrm.free;
end;

procedure setBreakPointInEditor(editor:IEditor;line:String);
var
  i,j:Integer;
  flag:Integer;
  command,bpid:String;
  subFile:TSubFile;
  fn,className,classAllName,packageName:String;
  index:Integer;
  found:Boolean;
begin
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
      if MessageBox(ideFrm.handle,PChar(Format(getErrorMsg('PackageNotMatch'),[ExtractFileName(fn),subFile.package,#13#10,packageName])),
                    PChar(getErrorMsg('ErrorDlgCaption')),
                    MB_OKCANCEL or MB_ICONWARNING) <> IDOK then
        exit;
    end;
    className:=subFile.getClassName;
  end else
  begin
    index:=Pos('.java',LowerCase(ExtractFileName(fn)));
    if index <= 0 then
      exit;
    className:=Copy(ExtractFileName(fn),1,index-1);
    //DebugApp(className,packageName,fn,false);
  end;

  if packageName =  '' then
    ClassAllName:=className
  else
    ClassAllName:=packageName + '.' + className;

  if editor.GetSynEditor.BreakpointEnable then
  begin
    flag:=editor.GetSynEditor.ChangeBreakPoint(editor.GetSynEditor.CaretY);
    //向各个应用程序发送断点通知；
    for i:=0 to appList.Count-1 do
    begin
      if flag > 0 then
      begin
        found:=false;
        for j:=0 to TAppInfo(applist.Objects[i]).breakpointList.Count-1 do
        begin
          if ( (TBreakpoint(TAppInfo(applist.Objects[i]).breakpointList.Items[j]).name = ClassAllName )
             and (TBreakpoint(TAppInfo(applist.Objects[i]).breakpointList.Items[j]).addtional = line) ) then
          begin
            found:=true;
            break;
          end;
        end;
        if not found then
        begin
          command:='stopat ' + ClassAllName +' '+ line;
          SendCommand(REQUEST_DEBUG,TAppInfo(applist.Objects[i]).appID,command);
        end;
      end
      else if flag < 0 then
      begin
        bpid := '';
        for j:=0 to TAppInfo(applist.Objects[i]).breakpointList.Count-1 do
        begin
          if ( (TBreakpoint(TAppInfo(applist.Objects[i]).breakpointList.Items[j]).name = ClassAllName )
             and (TBreakpoint(TAppInfo(applist.Objects[i]).breakpointList.Items[j]).addtional = line) ) then
          begin
            bpid:=TBreakpoint(TAppInfo(applist.Objects[i]).breakpointList.Items[j]).id;
            break;
          end;
        end;
        if bpid <> ''  then
        begin
          command:='clear linebp '+ bpid + ' ' + ClassAllName + ' ' + line;
          SendCommand(REQUEST_DEBUG,TAppInfo(applist.Objects[i]).appID,command);
        end;
      end;
    end;
  end;
end;

{procedure setFileBreakPoint(editor:IEditor);
var
  i:Integer;
begin
  if isJavaFile(editor.GetFileName) then
  begin
    for i:=0 to g_bpList.Count-1 do
    begin
      if TLineBreakPoint(g_bpList.Items[i]).fileName = editor.GetFileName then
        try
          editor.GetSynEditor.AddBreakPoint(StrToInt(TLineBreakPoint(g_bpList.Items[i]).line));
        except
          ;
        end;
    end;
  end;
end;  }

function getBoolByInt(i:integer):Boolean;
begin
  if i = 1 then
    result:=true
  else
    result:=false;
end;
{ generate the following infomation
 /*
 method:       setName
 params:
               1. String name
 return type:  void
 create time:  2002-12-12 23:23
 author:       gshd
*/
}
function getCommentOfMethod(name:String;params:TStrings;return:String):String;
var
  i:Integer;
begin
  result:='/*'+#13#10;
  result:= result + 'method:       ' + name+#13#10;
  result:= result + 'params:' + #13#10;
  if ( params = nil ) or (params.Count = 0) then
    result:= result + '              none' + #13#10
  else
    for i:=0 to params.Count-1 do
      result:= result + '              '+ IntToStr(i+1)+'. ' + params[i] + #13#10;
  result:= result + 'return type:  '+return+#13#10;
  result:= result + 'create time:  '+FormatDateTime('yyyy-mm-dd hh:nn:ss',now)+#13#10;
  if G_Project <> nil then
    result:= result + 'author:       ' + G_Project.cfg.author +#13#10
  else
    result:= result + 'author:       ' + getCurrentLoginUser +#13#10;

  result:= result + '*/'+#13#10;
end;

function getSetName(proName:String):String;
var
  s:String;
begin
  if proname = '' then
    result:=''
  else begin
    s:=UpperCase(Copy(proName,1,1));
    result:=s+Copy(proName,2,length(proName));
  end;
end;
function getModifierByIndex(index:Integer):String;
begin
  if index=0 then
    result:='private '
  else if index=1 then
    result:='protected '
  else if index=2 then
    result:=''
  else if index=3 then
    result:='public ';

end;

function getClassName(fn:String):String;
var
  index:Integer;
begin
  index := Pos('.java',fn);
  if index <=0 then
    result:=''
  else
    result:=Copy(fn,1,index-1);
end;

function GetFileSize(const FileName: String): LongInt;

var

SearchRec: TSearchRec;

begin

if FindFirst(ExpandFileName(FileName), faAnyFile, SearchRec) = 0 then

Result := SearchRec.Size

else

Result := -1;

end;


function isAscii(NomeFile: string): Boolean;
const
  SETT = 2048; 
var 
  i: Integer; 
  F: file; 
  a: Boolean; 
  TotSize, IncSize, ReadSize: Integer; 
  c: array[0..Sett] of Byte;
  title:array[1..2] of Byte;
begin 
  if FileExists(NomeFile) then 
  begin 
    {$I-} 
    AssignFile(F, NomeFile); 
    Reset(F, 1);
    BlockRead(F,title,2);
    if (title[1] = $FF)  and (title[2] = $FE) then
    begin
      MessageBox(ideFrm.Handle,PChar(NomeFile +' is  a unicode file,Can''t open and edit it.'),'Confirm Infomation',MB_OK or MB_ICONWARNING);
      CloseFile(F);
      result:=false;
      exit;
    end;
    Reset(F, 1);
    TotSize := FileSize(F);
    IncSize := 0;
    a       := True;
    while (IncSize < TotSize) and (a = True) do 
    begin 
      ReadSize := SETT; 
      if IncSize + ReadSize > TotSize then ReadSize := TotSize - IncSize; 
      IncSize := IncSize + ReadSize; 
      BlockRead(F, c, ReadSize); 
      // Iterate 
      for i := 0 to ReadSize - 1 do 
        if (c[i] < 32) and (not (c[i] in [9, 10, 13, 26])) then a := False; 
    end; { while } 
    CloseFile(F); 
    {$I+} 
    if IOResult <> 0 then Result := False 
    else  
      Result := a; 
  end; 
end;

function SetFileCanWrite(filename:string):Boolean;
var
 attr:Word;
begin
  if not FileExists(filename) then
  begin
    result:=false;
    exit;
  end;
  attr := FileGetAttr(FileName);
  if  attr and FaReadOnly  <> 0 then
    FileSetAttr(FileName, Attr - FaReadOnly);
  result:=true;
end;

procedure SetJavaHomeEnv(value:String);
begin
  if FileExists(g_javaHome+'src.zip') then
    g_jdk_zipsrc_path := g_javaHome + 'src.zip'
  else if FileExists(g_javaHome+'src.jar') then
    g_jdk_zipsrc_path := g_javaHome + 'src.jar'
  else
    g_jdk_zipsrc_path := g_javaHome + 'src.zip';

  WriteCfgString('JDK_CFG','jdk_srczip_path',g_jdk_zipsrc_path);
  WriteCfgString('JDK_CFG','JAVA_HOME',value);
end;

procedure parseJDKPackage(pack:String;tv:TTreeView);
var
    pl:TStringList;
    i:Integer;
    node:TTreeNode;
begin
    pl:=TStringList.Create;
    try

      pl.Delimiter:=';';
      pl.DelimitedText:=pack;
      tv.Items.Clear;
      for i:=0 to pl.Count-1 do
      begin
        //pl[i]:=trim(pl[i]);
        //if Pos('src.',pl[i]) = 1 then
        //  pl[i]:=Copy(pl[i],5,length(pl[i]));
        if Pos('com.',pl[i]) <> 1 then
        begin
          node := tv.Items.Add(nil,pl[i]);
          tv.Items.AddChild(node,TEMPNODENAME);
        end;
      end;
      for i:=0 to pl.Count-1 do
      begin
        if Pos('com.',pl[i]) = 1 then
        begin
          node := tv.Items.Add(nil,pl[i]);
          tv.Items.AddChild(node,TEMPNODENAME);
        end;
      end;
    finally
      pl.Free;
    end;
end;

procedure parseJDKClassList(pack,pn:String;tv:TTreeView);
var
    pl:TStringList;
    i:Integer;
    node:TTreeNode;
begin
    pl:=TStringList.Create;
    try
      pl.Delimiter:=';';
      pl.DelimitedText:=pack;
      node:=nil;
      for i:=0 to tv.Items.Count-1 do
      begin
        if tv.Items[i].Level = 0 then
        begin
          if tv.Items[i].Text = pn then
          begin
            node:=tv.Items[i];
            break;
          end;
        end;
      end;

      if node = nil then
        exit;

      node.DeleteChildren;
      for i:=0 to pl.Count-1 do
      begin
        //pl[i]:=trim(pl[i]);
        //if Pos('src.',pl[i]) = 1 then
        //  pl[i]:=Copy(pl[i],5,length(pl[i]));
        tv.Items.AddChild(node,pl[i]);
      end;
      node.Expand(true);
    finally
      pl.Free;
    end;
end;

procedure parsePackage(pack:WideString;var command,rs,con:WideString);
var
  xmlDocument:TXMLDocument;
  tempComponent:TComponent;
  stream:TStringStream;
begin
   stream :=  TStringStream.Create('<?xml version="1.0" encoding="GBK"?>'+pack);
   tempComponent:=TComponent.Create(nil);
   xmlDocument:=TXMLDocument.Create(tempComponent);
   try
     xmlDocument.LoadFromStream(stream);

     command := XMLDocument.DocumentElement.ChildNodes['command'].Text;
     rs := XMLDocument.DocumentElement.ChildNodes['result'].Text;
     con := XMLDocument.DocumentElement.ChildNodes['p'].text;
   except
   end;
   stream.Destroy;
   xmlDocument.Destroy;
   tempComponent.Destroy;
end;

  procedure getPackageList( str:String);
  var
    i,j:Integer;
    package:String;
  begin
    if g_packageList = nil then
    begin
      g_packageList := TStringList.Create;
    end;

    g_packageList.Clear;
    for i:=0 to ideFrm.jdkApiTV.Items.Count-1 do
    begin
      if ideFrm.jdkApiTV.Items[i].Level = 0 then
      begin
        package:= ideFrm.jdkApiTV.Items[i].Text;
        if LowerCase(str) = LowerCase(package) then
        begin
          g_packageList.Add('*');
          if (ideFrm.jdkApiTV.Items[i].Count = 1) and (ideFrm.jdkApiTV.Items[i].Item[0].Text = TEMPNODENAME) then
            continue
          else
          begin
            for j:=0 to  ideFrm.jdkApiTV.Items[i].Count - 1  do
            begin
              g_packageList.add(ideFrm.jdkApiTV.Items[i].Item[j].Text);
            end;
          end;
        end
        else if Pos(LowerCase(str)+'.',LowerCase(package)) = 1 then
        begin
          //index:=Pos(LowerCase(str)+'.',LowerCase(package));
          g_packageList.Add(Copy(package,length(str)+2,length(package)));
        end; //else if end
      end;//if end
    end; //for end;
  end;

  procedure refreshPackageList(filter:String;lb:TListBox);
  var
    i:Integer;
    len:Integer;
  begin
    lb.items.clear;
    len:=Length(filter);
    if len = 0 then
    begin
      lb.items.Assign(g_packageList);
    end else
    for i:=0 to g_packageList.Count-1 do
    begin
      if LowerCase(copy(g_packageList[i],1,len))=LowerCase(filter) then
         lb.items.Add(g_packageList[i]);
    end;
    if lb.items.Count > 0 then
      lb.ItemIndex:=0;
  end;

  function isJavaFile(fn:String):boolean;
  begin
    fn:=trim(fn);
    if length(fn) < 5 then
      result:=false
    else if LowerCase(Copy(fn,length(fn)-4,5)) = '.java' then
      result:=true
    else
      result:=false;
  end;

  procedure dealWithDocHelp(result,con:String);
  var
    reg:TRegExpr;
    comment:String;
    lineNum:Integer;
  begin
    if con <> '' then
    begin
      if Assigned(jdkHelpFrm) then
      begin
        jdkHelpFrm.SynEditor.Lines.Text := con;
      end;
    end;

    if result = '1' then
    begin
      if Assigned(jdkHelpFrm) then
      begin
        reg:=TRegExpr.Create;
        try
          reg.Expression:=g_jdkHelpRegr;
          if reg.Exec(jdkHelpFrm.SynEditor.Lines.Text) then
          begin
            lineNum:=jdkHelpFrm.SynEditor.TranslateLongToPoint(reg.MatchPos[0]).Y;
            comment:=FindComment(jdkHelpFrm.SynEditor.Lines,lineNum-1);
            comment:=formatComment(comment,reg.Match[0]);
            SetHtml(jdkHelpFrm.JDKWebBrowser,comment);
          end else
          begin
            SetHtml(jdkHelpFrm.JDKWebBrowser,'Can''t find the help of the function or attribute.');
          end;
        finally
          reg.Free;
        end;
      end;
    end else
    begin
      SetHtml(jdkHelpFrm.JDKWebBrowser,con);
    end;
  end;

  function renderParameterToHtml(paramExpression:String):String;
  var
    index,index1,index2:Integer;
    paramName,paramDocu:String;
  begin
        paramExpression := trim(paramExpression);
        index1:=Pos(' ',paramExpression);
        index2:=Pos(#9,paramExpression);
        if (index1 = index2) and (index1 = 0 ) then
        begin
			result := paramExpression;
        end else
        begin
          if min(index1,index2) = 0 then
            index := max(index1,index2)
          else
          begin
            if index1 >= index2  then
              index:=index2
            else
              index:=index1;
          end;
          paramName:= Copy(paramExpression,1,index-1);
          paramDocu:= Copy(paramExpression,index+2,length(paramExpression));
          paramName := '&nbsp;&nbsp;&nbsp;&nbsp;' + paramName;
          result:='<font color="#0000ff">' + paramName + '</font>' + ' : ' + paramDocu;
        end;
  end;

    function  formatComment(comment,proto:String):String;
    var
        sb,subString,line,newLine:String;
        sl:TStringList;
        bFirstParam,bFirstEX:Boolean;
        i,aPos:Integer;
    begin
        bFirstParam:=false;
        bFirstEX:=false;
        sl:=TStringList.Create;
        sb := '<b><font color="#0000ff">' + proto + '</font></b>';
        sl.Text:=comment;
        result:='&nbsp;&nbsp;&nbsp;';
        for i:=0 to sl.Count-1 do
        begin
            line := sl[i];
            line := trim(line);

            if ( Pos('/**',line) >= 1 ) then
            	continue;
            if ( Pos('*/',line) >= 1 )  then
            	continue;

            if Pos('*',line) = 1 then
              line := Copy(line,2,length(line));

            aPos := Pos('@',line);
            if (aPos <= 0) then
            begin
                result := result + line + ' ';
                continue;
            end;
            subString := Copy(line,aPos,length(line));

            if ( Pos('@param',subString) = 1)  then
            begin
                //indexEnd := aPos + 8;
                newLine := '';
                if (not bFirstParam) then
                begin
                    newLine := newLine + '<br><b>Parameter:</b><br>';
                    newLine := newLine + renderParameterToHtml(Copy(subString,Pos(' ',subString),length(subString)));

                    bFirstParam := true;
                end
                else
                begin
                    newLine := newLine + '<br>' + renderParameterToHtml(Copy(subString,Pos(' ',subString),length(subString)));
                end;

                result:=result+newLine+' ';
            end
            else if( Pos('@return',subString) = 1 )then
            begin
                //indexEnd := aPos + 7;
                newLine := '<br><b>Return:</b><br>&nbsp;&nbsp;&nbsp;' + Copy(subString,Pos(' ',subString),length(subString));
                result:=result+newLine+' ';
            end
            else if( Pos('@throws',subString) = 1 ) or ( Pos('@exception',subString) = 1 ) then
            begin
                //indexEnd := aPos + 8;
                newLine := '';
                if (not bFirstEX) then
                begin
                    newLine := newLine + '<br><b>Exception:</b><br>';
                    newLine := newLine + renderParameterToHtml(Copy(subString,Pos(' ',subString),length(subString)));
                    bFirstEX := true;
                end else
                begin
                    newLine := newLine + '<br>' + renderParameterToHtml(Copy(subString,Pos(' ',subString),length(subString)));
                end;
                result:=result+newLine+' ';
            end  else if ( Pos('@since',subString) = 1 ) then begin
            end else if ( Pos('@see',subString) = 1) then begin
            end else if ( Pos('@beaninfo',subString) = 1) then begin
            end else if ( Pos('@deprecated',subString) = 1 ) then begin
                result:=result+ '<font color="#ff2020">deprecated</font><br>&nbsp;&nbsp;&nbsp;' +
                    Copy(subString,Pos(' ',subString),length(subString));
            end else begin
                result:=result+newLine+' ';
            end;
        end;
        result := sb + '<p>' + result ;
        sl.free;
    end;

  function FindComment(source:TStrings;off:Integer):String;
  var
    i:Integer;
  begin
    result:='';
    if source.Count <= 0 then
      exit;
    for i:=off-1 downto 0 do
    begin
      result:= source[i] + #13#10 + result;
      if Pos('/**',source[i]) >= 1 then
        break;
    end;
  end;
  {
    kill java process
  }
  procedure KillJavaProcess(id:String);
  var
    IsLoopContinue:BOOL;
    FSnapshotHandle:THandle;
    FProcessEntry32:TProcessEntry32;
    exefile:String;
    idInt:Integer;
  begin
    id := trim(id);
    if id = '0'  then
      exit;

    FSnapshotHandle := CreateToolhelp32Snapshot(TH32CS_SNAPPROCESS,0); // 创建系统快照
    FProcessEntry32.dwSize := Sizeof(FProcessEntry32); // 必须先设置结构的大小
    IsLoopContinue:=Process32First(FSnapshotHandle,FProcessEntry32); //得到第一个进程信息
    while integer(IsLoopContinue)<>0 do
    begin
      exefile:=LowerCase(FProcessEntry32.szExeFile);
      if ( Pos('javaw.exe',exefile) > 0 )
            and (IntToStr(FProcessEntry32.th32ProcessID) = id)  then
      begin
        try
          idInt:=OpenProcess(PROCESS_ALL_ACCESS,true,StrToInt(id));
          TerminateProcess(idInt,0);
          break;
        except
          ;
        end;
      end;
      IsLoopContinue:=Process32Next(FSnapshotHandle,FProcessEntry32); // 继续枚举
    end;
    CloseHandle(FSnapshotHandle); // 释放快照句柄
  end;

end.
