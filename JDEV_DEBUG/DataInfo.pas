unit DataInfo;

interface
uses
  windows,SysUtils,Classes,Contnrs,ComCtrls,ScktComp;

type
  TLinkMethod = (lmSocket,lmShmem);
  TAppStatus = (Waiting,Ready);

type
  TSourceManager = class
    public
      sourceFile:String;
      packageName:String;
      sourceCode:TStringList;
      //breakpointList:TStringList;
    public
      Constructor create(name,pack:String);
      procedure free;
  end;

  TMyNode =class
    level:Integer;
    id:String;
  end;

  TBreakpoint = class
    classType:String;
    id:String;
    name:String;
    addtional:String;
  end;


  TLocal = class
    name:String;
    varType:String;
    value:String;
    isArray:Integer;
    arrayLength:Integer;
    style:Integer;
    hasRefresh:Boolean;
  end;
type
  TDebugThread = class;
  TAppInfo = class;

  TThreadFrame = class
    public
        level:Integer;
        id:String;
        name:String;
        curVar:String;
        frameTreeNode:TTreeNode;
        sourceFile:String;
        parent:TDebugThread;
    public
        Constructor create(id:String);
        procedure free;
  end;

  TDebugThread = class
    public
        level:Integer;
        threadID:String;
        isSuspended:Boolean;
        name:String;
        status:String;
        threadGroup:String;
        currentFrame:TThreadFrame;
        frames:TStringList;
        threadTreeNode:TTreeNode;
        parent:TAppInfo;
    public
        constructor create(threadID:String);
        procedure free;
  end;
  TSimpleThread = class
        threadID:String;
        name:String;
        status:String;
        threadGroup:String;
        isSuspended:Boolean;
  end;

  TAppInfo = class
     public
        level:Integer;
        appID:String;
        name:String;
        filename:String;
        status:TAppStatus;      //标识应用程序的状态，是否在等待服务器的响应
        isOpenLink:boolean;
        iniPath:String;
        linkMethod:TLinkMethod;
        currentThread:TDebugThread;
        ReadPipeInput, WritePipeInput: THandle;
        ReadPipeOutput, WritePipeOutput: THandle;
        start: TStartUpInfo;
        ProcessInfo: TProcessInformation;
        getOutputThread:TThread;
        waitingAppEndThread:TThread;
        threads:TStringList;
        g_curThreadID:String;
        g_curThreadFrameID:String;
        appTreeNode:TTreeNode;
        lastSelNode:TTreeNode;
        consoleInStrings:TStringList;//输入控制台Strings
        consoleOutStrings:TStringList;//输出控制台Strings
        sourceFilePathList:TStringList;//源文件路径列表
        catheSourceFileList:TObjectList;//源文件内容缓存
        breakpointList:TObjectList;//断点列表
        loadedClassList:TStringList;//装载类
        //监视变量列表
     public
        Constructor create;
        procedure InitStartUpInfo;
        procedure EndApp;
  end;

  TAppParam = record
     style:Integer; //1.java application 2.java applet 3.web application
     className:String;
     appletClass:String;
     fileName:String;
     parameters:String;
     address:String;
     initialPath:String;
     cp:String;
     isMainStop:boolean;
     link:TLinkMethod;
     theLatestPid:String;
  end;
  
var
  AppList:TStringList;
  //Security: TSecurityAttributes;

  //SystemClassPath:PChar;
  //g_javaHome:String;
  //g_javaBin:String;
  //configList:TStringList;
  g_debugServerSocket:TCustomWinSocket; //调试服务器的socket端口
  LocalsList:TObjectList;

  g_MouseClickLine:Integer;

  g_CanNotChThreadNode:Boolean;  //作为判断是否手动改变线程节点的标志，如果为程序代码改变selected属性，则为true；
                           //如果用鼠标或者键盘改变selected，则为false；

  g_expandedNodeList:String;
  curVarName:String;
  appParam:TAppParam;

  //g_isDumpingOrPrint:Boolean;
  g_is_deleteLocalNode:Boolean;
  g_NetPackage:String;

  g_debugServerApp:TProcessInformation;

implementation
uses
  debugunit;

 Constructor TSourceManager.create(name,pack:String);
 begin
   sourceFile:=name;
   //isOpen :=false;
   packageName:=pack;
   sourceCode:=TStringList.Create;
   //breakpointList:=TStringList.Create;
 end;
 procedure  TSourceManager.free;
 begin
   sourceCode.Destroy;
   //breakpointList.Destroy;
   inherited destroy;
 end;

 Constructor TThreadFrame.create(id:String);
 begin
   self.id := id;
   level := 3;
 end;

 procedure TThreadFrame.free;
 begin
   inherited destroy;
 end;

 Constructor TDebugThread.create(threadID:String);
 begin
   level := 2;
   self.threadID := threadID;
   frames := TStringList.Create;
 end;

 procedure TDebugThread.free;
 var
  i:integer;
 begin
   if ( frames <> nil ) then
   begin
     for i:=0 to frames.Count-1 do
        TThreadFrame(frames.Objects[i]).free;      //释放每个帧对象

     frames.Destroy;                               //释放帧列表
   end;

   inherited Destroy;
 end;

 Constructor TAppInfo.create;
 begin
   level := 1;
   name := '';
   linkMethod:= lmShmem;
   ReadPipeInput :=0;
   ReadPipeOutput :=0;
   WritePipeInput:=0;
   WritePipeOutput :=0;
   status:=Waiting;
   threads := TStringList.Create;
   consoleInStrings:=TStringList.Create;//输入控制台Strings
   consoleOutStrings:=TStringList.Create;//输出控制台Strings
   sourceFilePathList:=TStringList.Create;
   catheSourceFileList:=TObjectList.Create(false);
   loadedClassList:=TStringList.Create;
   breakpointList:=TObjectList.Create(false);
 end;

 procedure TAppInfo.EndApp;
 var
  exitcode:DWord;
  i:Integer;
 begin
        //先通知两个监视进程结束
        getOutputThread.Terminate ;
        waitingAppEndThread.Terminate;

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
        CloseHandle(WritePipeInput);
        CloseHandle(ReadPipeInput);
        CloseHandle(WritePipeOutput);
        CloseHandle(ReadPipeOutput);
        
        if (threads <>nil) then
        begin
            for i:=0 to threads.Count-1 do
              TDebugThread(threads.Objects[i]).free;      //释放每个线程对象

            threads.Destroy;                              //释放线程列表
        end;

       consoleInStrings.Destroy;//输入控制台Strings
       consoleOutStrings.Destroy;//输出控制台Strings
       sourceFilePathList.Destroy; //清除源文件路径列表
       for i:=0 to catheSourceFileList.Count-1 do
       if catheSourceFileList.Items[i]<>nil then
         TSourceManager(catheSourceFileList.Items[i]).free;
       catheSourceFileList.Destroy;//清除源文件

       for i:=0 to breakpointList.Count-1 do
       if breakpointList.Items[i]<>nil then
         TBreakpoint(breakpointList.Items[i]).free;
       breakpointList.Destroy;   //清除断点列表
       
       loadedClassList.Destroy;
       inherited Destroy;
 end;


 procedure TAppInfo.InitStartUpInfo;
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

end.





