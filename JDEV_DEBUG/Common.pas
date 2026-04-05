unit Common;

interface
uses
  windows,SysUtils,StrUtils,Graphics,Classes,StdCtrls,IniFiles,ComCtrls,Contnrs,XmlDoc,
  XMLIntf,DataInfo,ReadOutput,WaitAppEndThread,debugunit,ConstVar,uEditAppIntfs;


  procedure parsePath(pathList:String;con:TStringList);

  procedure InitGlobalData;
  procedure FreeGlobalData;
  procedure AddApp(app:TAppInfo;appName:String);
  procedure DelApp(app:TAppInfo) ;overload;
  procedure DelApp(pid:String); overload;
  procedure CreateApplication;
  procedure BeginAppDebug;
  procedure startDebugServer;
  function  ShowMessageBox(msg:String;id:Integer):Integer;
  procedure SendCommand(commandID:Integer;pid:String;content:TStringList); overload;
  procedure SendCommand(commandID:Integer;app:TAppInfo;content:TStringList); overload;
  procedure SendCommand(commandID:Integer;app:TAppInfo;content:String); overload;
  procedure SendCommand(commandID:Integer;pid:String;content:String); overload;

  procedure parsePackage(pack:WideString;var command,pid,rs:WideString;var con:WideString);
  procedure parseThreadContents(con:WideString;var result:TStringList);
  function  parseThreadFrame(pid,con:WideString;var id:String;var frames:TStringList):TDebugThread;
  function  parseFrameLocals(pid:String;con:WideString;var sourceName:String;var curLine:Integer):TThreadFrame;

  procedure doAllThreads(pid:String;con:String);
  procedure addThread(pid:String;con:String);
  procedure delThread(pid,con:String);
  procedure refreshThreadFrames(pid,con:String);
  procedure refreshLocals(pid,con:String);
  procedure refreshLocalByDump(rs:String;con:String);
  procedure refreshLocalByDumpBatch(con:String);
  procedure refreshSingleLocal(rs,con:String);
  procedure refreshClassListBox(pid,con:String);
  procedure refreshWatchVar(con:String);
  procedure resumeReply(pid,con:String);
  procedure suspendReply(pid,con:String);
  procedure replySetBreakpoint(rs,pid,con:string);
  procedure replyClearBreakpoint(rs,pid,con:string);
  function  ts_int2str(status:String):String;
  function  setThreadIcon(status:String):Integer;

  function  getFilePathName(path,name:String):String;
  function  getTextByNode(node:TTreeNode):String;
  function  getNodeByText(name:String):TTreeNode;

  function  getCurNodePID:String;

  function  getCurApp:TAppInfo;
  function  getCurThread:TDebugThread;
  function  getCurThreadFrame:TThreadFrame;
  function  getAppByNode(node:TTreeNode):TAppInfo;
  procedure setCurAppNode(app:TAppInfo);
  function  getAppByName(name,fn:String):TAppInfo;
  function  getThreadByNode(node:TTreeNode):TDebugThread;
  function  getThreadFrameByNode(node:TTreeNode):TThreadFrame;

  function  getContent(con:TStringList):String;
  function  findApp(pid:String):TAppInfo;
  function  findThread(pid,threadID:String):TDebugThread;
  function  findThreadFrame(pid,threadID,frameID:String):TThreadFrame;
  procedure setSelectedVar;
  procedure setBreakpoint(line:integer);
  procedure addErrorMsg(msg:String);overload;
  procedure addErrorMsg(msg:String;isBeep:Boolean);overload;
  //procedure deleteNodeRecurse(Node:TTreeNode);
  //procedure deleteChildrenData(Node:TTreeNode);
  function isLegalVar(VarName:String):Boolean;
  function getThreadNodeText(mythread:TDebugThread):String;

  procedure SeparateTerms(s : string;Separator : char; var Terms : TStringList);
  procedure SeparateSubTerms(s : string;SeparatorBegin : char; SeparatorEnd : char;var Terms : TStringList);
  function getChildNodeBySubText(name:String;parent:TTreeNode):TTreeNode;
  function getDirByStr(fileName:String):String;
  procedure UpdateJavaSourceBp(app:TAppInfo;packageName:String);

implementation
uses
  ideUnit,uCommandData;
  
resourcestring
  rs_ThreadSuspend='The thread has been suspended already.';
  rs_DebugServerHasStarted='The debug server has startup already.';
  rs_CannotFindToolsJar='Can''t find tools.jar in the $JAVA_HOME$\lib';
  rs_DebugServerStartOK='The debug server started successfully.';
  rs_DebugServerStartFail='The debug server started failed.';

 procedure parsePath(pathList:String;con:TStringList);
 var
   index:Integer;
 begin
   while (true) do
   begin
     index:=Pos(';',pathList);
     if index <=0 then
       break;
     con.Add(copy(pathList,1,index-1));
     pathList:=copy(pathList,index+1,Length(pathList));
   end;
   if trim(pathList) <> '' then
    con.Add(trim(pathList));
 end;

 function  ShowMessageBox(msg:String;id:Integer):Integer;
 begin
   result := MessageBox(debugForm.Handle,PChar(msg),ErrorDlgCaption,id);
 end;

 procedure AddApp(app:TAppInfo;appName:String);
 begin
    //如果成功，将新建的进程加入到‘程序/线程’列表
    if app = nil then
      exit;
    try
      app.name:=appName;
      AppList.AddObject(app.appID,app);
      app.appTreeNode := DebugForm.ThreadListTV.Items.add(nil,'Application : '+appName);
      app.appTreeNode.data := app;
      g_CanNotChThreadNode:=true;
      DebugForm.threadListTV.selected:= app.appTreeNode;
      app.appTreeNode.ImageIndex:=0;
      app.appTreeNode.SelectedIndex:=0;
      debugForm.consoleInputMemo.text:='';
      debugForm.consoleOutputMemo.text:='';
      debugForm.MainMenu.Items[4].Items[2].Enabled:=true;
    except
      ;
    end;
 end;

 procedure DelApp(app:TAppInfo);
 var
  i:Integer;
  mApp:TAppInfo;
 begin
    if (app <> nil  )then
    begin
       for i:=0 to AppList.Count-1 do
       begin
         mApp:=AppList.Objects[i] as TAppInfo ;
         if (mApp.appID = app.appID) then
         begin
           try
             AppList.Delete(i);
             mApp.EndApp;
           except
             ;
           end;
           break;
         end;
       end;
    end;
    if ( getCurApp = nil ) then
     begin
       //debugForm.consoleInputMemo.text:='';
       //debugForm.consoleOutputMemo.text:='';
       //清除类列表
       debugForm.classListBox.Items.Clear;
       //清除源代码列表
       debugForm.sourceEdit.Breakpoints.Clear;
       debugForm.sourceEdit.Lines.Clear;
       //清除断点
       debugForm.BreakpointListTV.TopItem.getNextSibling.getNextSibling.DeleteChildren;
       debugForm.BreakpointListTV.TopItem.getNextSibling.DeleteChildren;
       debugForm.BreakpointListTV.TopItem.DeleteChildren;
       //设置菜单为disable
       debugForm.MainMenu.Items[4].Items[2].Enabled:=false;
     end
 end;

 procedure DelApp(pid:String);
 var
  i:Integer;
  mApp:TAppInfo;
 begin
   for i:=0 to AppList.Count-1 do
   begin
     mApp:=AppList.Objects[i] as TAppInfo ;
     if (pid = mApp.appID) then
     begin
       mApp.EndApp;
       AppList.Delete(i);
       break;
     end;
   end;
   if ( getCurApp = nil ) then
   begin
       //清除类列表
       debugForm.classListBox.Items.Clear;
       //清除源代码列表
       debugForm.sourceEdit.Breakpoints.Clear;
       debugForm.sourceEdit.Lines.Clear;
       //清除断点
       debugForm.BreakpointListTV.TopItem.getNextSibling.getNextSibling.DeleteChildren;
       debugForm.BreakpointListTV.TopItem.getNextSibling.DeleteChildren;
       debugForm.BreakpointListTV.TopItem.DeleteChildren;
       //设置菜单为disable
       debugForm.MainMenu.Items[4].Items[2].Enabled:=false;
   end;
 end;


 procedure InitGlobalData;
 begin
      AppList  := TStringList.Create;
      LocalsList := TObjectList.Create(false);
 end;

 procedure FreeGlobalData;
 var
  i:Integer;
  app:TAppInfo;
  exitCode:DWord;
 begin
    for i:=0 to AppList.count-1 do
    begin
        app:= appList.Objects[i] as TAppInfo;
        app.EndApp;
    end;
    AppList.Destroy;
    LocalsList.Destroy;

    Sleep(200);//为了防止监视线程还没有运行结束，所以主线程休眠一段时间，让监视线程结束；
    //通知调试中心退出
    SendCommand(REQUEST_EXIT,'-1','exit server');
    addErrorMsg('Debug center terminate.',false);

    //清空变量列表区，同时释放变量内存区（依赖于treeView控件的deletion事件）
    //debugForm.LocalsListTV.Items.clear;

    //if Assigned(g_debugServerApp) then
    //  exit;
      
    GetExitCodeProcess(g_debugServerApp.hProcess, exitcode);
    //结束监视输出线程
    if ( exitcode = STILL_ACTIVE ) then //如果当前进程没有结束
    begin
      //强制结束
      TerminateProcess(g_debugServerApp.hProcess,0);
      WriteCfgString('DebugServer','debug_server_id','0');      
      addErrorMsg('Debug center was forced to terminate.',false);
    end;
    
    if debugForm.CommSocket <> nil then
      debugForm.CommSocket.Close;
 end;

 procedure BeginAppDebug;
 var
   con:TStringList;
   hasBp:Boolean;
   editor:IEditor;
   i,j,index:Integer;
   filename,allClassName:String;
 begin
    con := TStringList.Create;
    hasBp:=false;
    //必要情况下，设置断点
    if appParam.isMainStop then
    begin
      if appParam.style =1 then
      begin
         con.Add('stopin '+ appParam.className +' main');
         hasBp:=true;
      end
      else if  appParam.style =2 then
      begin
         con.Add('stopin ' + appparam.appletClass +' init');
         hasBp:=true;
      end
      else if  appParam.style =3 then
      begin
         con.Add('stopin '+ appParam.className +' main');
         hasBp:=true;
      end;
    end;
    for i:=0 to GI_EditorFactory.GetEditorCount-1 do
    begin
      editor:= GI_EditorFactory.Editor[i];
      if editor.GetSynEditor.BreakpointEnable then
      begin
        for j:=0 to editor.GetSynEditor.Breakpoints.Count-1 do
        begin
          filename := editor.GetFileName;
          if G_Project <> nil then
          begin
            index := Pos(G_Project.Path,fileName);
            if index <= 0 then
            begin
              index := LastDelimiter('\',filename);
              allClassName:=Copy(filename,index+1,length(filename));
              index := Pos('.',allClassName);
              allClassName := copy(allClassName,1,index-1);
            end
            else
            begin
              allClassName:=Copy(filename,length(G_Project.Path)+1,length(filename));
              index := Pos('.',allClassName);
              allClassName := copy(allClassName,1,index-1);
              allClassName:=AnsiReplaceStr(allClassName,'\','.');
            end;
          end else
          begin
            index := LastDelimiter('\',filename);
            allClassName:=Copy(filename,index+1,length(filename));
            index := Pos('.',allClassName);
            allClassName := copy(allClassName,1,index-1);
          end;
          con.Add('stopat ' + allClassName + ' '+ editor.GetSynEditor.Breakpoints[j]);
          hasBp:=true;
        end;
      end;
    end;

    if not hasBp then
      Sleep(100);

    con.Add('run');

    //发送消息
    SendCommand(REQUEST_RUN,appParam.theLatestPid,con);

    con.Destroy;
 end;

 //创建一个应用程序
 procedure CreateApplication;
 var
  newApp:TAppInfo;
  commandLine:String;
  transport:String;
  pathLen:Integer;
 begin
      transport :='';
      pathLen:=length(appParam.initialPath);
      if (appParam.initialPath<>'') then
        appParam.initialPath[pathLen+1]:=#0;

      if (appParam.link = lmSocket)  then
         transport:='dt_socket,address='+appParam.address
      else
         transport:='dt_shmem,address='+appParam.address;


      commandLine:=g_javaw
                   +' -cp "'+appParam.cp
                   +'" -Xdebug -Xnoagent -Djava.compiler=NONE '
                   +' -Xrunjdwp:transport='+transport
                   +',suspend=y '
                   + appParam.className + ' '+ appParam.parameters + #0;
      newApp := TAppInfo.create;
      newApp.filename:=appParam.fileName;
      newApp.iniPath:=appParam.initialPath;
      //第一步首先建立两个匿名管道
      {创建一个命名管道用来捕获console程序的输出}
      Createpipe(newApp.ReadPipeInput, newApp.WritePipeInput, @g_Security, 0);
      Createpipe(newApp.ReadPipeOutput, newApp.WritePipeOutput, @g_Security, 0);

      newApp.InitStartUpInfo;

      //配置源文件路径
      parsePath(g_IDE_SourcePath,newApp.sourceFilePathList);

      //配置本应用程序的路径

      //将当前java应用程序的路径加入到源文件路径列表中
      //newApp.sourceFilePathList.Add(appParam.initialPath);

      //创建进程
      if  CreateProcess(nil,@commandLine[1], @g_Security, @g_Security, true,
        CREATE_NEW_CONSOLE or NORMAL_PRIORITY_CLASS,nil, @appParam.initialPath[1], newApp.start, newApp.ProcessInfo) then
      begin
        newApp.appID := IntToStr(newApp.ProcessInfo.hProcess);
        appParam.theLatestPid := IntToStr(newApp.ProcessInfo.hProcess);
        newApp.getOutputThread := GetOutput.Create(newApp);
        {等待进程运行结束}
        newapp.waitingAppEndThread := WaitAppEnd.Create(newapp);
        //如果成功，将新建的进程加入到列表
        AddApp(newApp,appParam.className);

      end;
 end;

  procedure SendCommand(commandID:Integer;pid:String;content:TStringList);
  begin
    if g_debugServerSocket <> nil then
      g_debugServerSocket.SendText('{'+IntToStr(commandID)+'}{'+pid+'}{'+getContent(content)+'}'+#13#10);
  end;

  procedure SendCommand(commandID:Integer;app:TAppInfo;content:TStringList);
  begin
    if g_debugServerSocket <> nil then
      g_debugServerSocket.SendText('{'+IntToStr(commandID)+'}{'+app.appID+'}{'+getContent(content)+'}'+#13#10);
  end;

  procedure SendCommand(commandID:Integer;app:TAppInfo;content:String);
  begin
    if g_debugServerSocket <> nil then
      g_debugServerSocket.SendText('{'+IntToStr(commandID)+'}{'+app.appID+'}{<'+content+'>}'+#13#10);
  end;

  procedure SendCommand(commandID:Integer;pid:String;content:String);
  begin
    if g_debugServerSocket <> nil then
      g_debugServerSocket.SendText('{'+IntToStr(commandID)+'}{'+pid+'}{<'+content+'>}'+#13#10);
  end;

  function  getContent(con:TStringList):String;
  var
    rs :String;
    i:Integer;
  begin
    rs:='';
    for i:=0 to con.Count-1 do
    begin
      rs:=rs+'<'+con.Strings[i]+'>';
    end;
    result := rs;
  end;

  procedure replyClearBreakpoint(rs,pid,con:string);
  var
    xmlDocument:TXMLDocument;
    tempComponent:TComponent;
    stream:TStringStream;
    app:TAppInfo;
    bpid,bptype:String;
    editor:IEditor;
    i,j,index:Integer;
    filename,allClassName:String;
    bp:TBreakpoint;
  begin
     app:=findApp(pid);
     if app = nil then
       Exit;
     stream :=  TStringStream.Create('<?xml version="1.0" encoding="GBK"?>'+con);
     tempComponent:=TComponent.Create(nil);
     xmlDocument:=TXMLDocument.Create(tempComponent);
     try
         try
           xmlDocument.LoadFromStream(stream);
         except
           ;
         end;
         if rs = '-1' then
         begin
           //MessageBox(debugForm.Handle,'断点删除失败！','提示信息',0);
           exit;
         end else //如果删除断点成功
         begin
           bpid := XMLDocument.DocumentElement.ChildNodes['id'].Text;
           bptype:=XMLDocument.DocumentElement.ChildNodes['c'].Text;
           if bptype = LINEBREAKPOINT then
           for i:=0 to debugForm.BreakpointListTV.Items.count-1 do
           begin
             if  debugForm.BreakpointListTV.Items[i].Level = 1 then
             begin
               bp:=TBreakpoint(debugForm.BreakpointListTV.Items[i].Data);
               if (bpid = bp.id) and (bp.classType = LINEBREAKPOINT) then
               begin
                 debugForm.sourceEdit.removeBreakPoint(StrToInt(bp.addtional));
                 debugForm.BreakpointListTV.Items.Delete(debugForm.BreakpointListTV.Items[i]);
                 break;
               end;
             end;
           end;
           if bptype = LINEBREAKPOINT then  //去掉断点
           begin
              for i:=0 to GI_EditorFactory.GetEditorCount-1 do
              begin
                editor:= GI_EditorFactory.Editor[i];
                if editor.GetSynEditor.BreakpointEnable then
                begin
                  for j:=0 to editor.GetSynEditor.Breakpoints.Count-1 do
                  begin
                    filename := editor.GetFileName;
                    if G_Project <> nil then
                    begin
                      index := Pos(G_Project.Path,fileName);
                      if index <= 0 then
                      begin
                        index := LastDelimiter('\',filename);
                        allClassName:=Copy(filename,index+1,length(filename));
                        index := Pos('.',allClassName);
                        allClassName := copy(allClassName,1,index-1);
                      end
                      else
                      begin
                        allClassName:=Copy(filename,length(G_Project.Path)+1,length(filename));
                        index := Pos('.',allClassName);
                        allClassName := copy(allClassName,1,index-1);
                        allClassName:=AnsiReplaceStr(allClassName,'\','.');
                      end;
                    end else
                    begin
                      index := LastDelimiter('\',filename);
                      allClassName:=Copy(filename,index+1,length(filename));
                      index := Pos('.',allClassName);
                      allClassName := copy(allClassName,1,index-1);
                    end;
                    if ( allClassName=bp.name ) and (editor.GetSynEditor.Breakpoints[j]=bp.addtional) then
                    begin
                      editor.GetSynEditor.RemoveBreakPoint(StrToInt(bp.addtional));
                      break;
                    end;
                  end;
                end;
              end;
           end;

           for i:=0 to app.breakpointList.count-1 do
           begin
             if bpid = TBreakpoint(app.breakpointList.Items[i]).id then
             begin
                TBreakpoint(app.breakpointList.Items[i]).Free; //释放
                app.breakpointList.Delete(i);
                break;
             end;
           end;

           UpdateJavaSourceBp(app,debugForm.sourceEdit.packageName);
         end;
     finally
       stream.Destroy;
       xmlDocument.Destroy;
       tempComponent.Destroy;
     end;
     
  end;

  procedure replySetBreakpoint(rs,pid,con:string);
  var
    xmlDocument:TXMLDocument;
    tempComponent:TComponent;
    stream:TStringStream;
    app:TAppInfo;
    bpType,bpName,bpAddtional:String;
    bp:TBreakpoint;
    i:Integer;
    found:Boolean;
  begin
     app:=findApp(pid);
     if app = nil then
       Exit;
     stream :=  TStringStream.Create('<?xml version="1.0" encoding="GBK"?>'+con);
     tempComponent:=TComponent.Create(nil);
     xmlDocument:=TXMLDocument.Create(tempComponent);
     try
       try
         xmlDocument.LoadFromStream(stream);
       except
         ;
       end;
       bpType := XMLDocument.DocumentElement.ChildNodes['c'].Text;
       bpName := XMLDocument.DocumentElement.ChildNodes['n'].Text;
       bpAddtional := XMLDocument.DocumentElement.ChildNodes['a'].Text;

       if rs = '-1' then
       begin
         if bpType = LINEBREAKPOINT then
            debugForm.sourceEdit.ChangeBreakPoint(g_MouseClickLine);
       end else //如果添加断点成功
       begin
         found:=false;
         for i:=0 to app.breakpointList.Count-1 do
         begin
           if ( TBreakpoint(app.breakpointList[i]).classType =  bpType )
             and  ( TBreakpoint(app.breakpointList[i]).name =  bpName )
               and ( TBreakpoint(app.breakpointList[i]).addtional =  bpAddtional ) then
           begin
             found:=true;
             break;
           end;
         end;
         if not found then
         begin
           if bpType = LINEBREAKPOINT then
           begin
               bp:=TBreakpoint.Create;
               bp.classType:= LINEBREAKPOINT;
               bp.id := FormatDateTime('yyyymmddhhnnsszzz',now);
               bp.name := bpName;
               bp.addtional := bpAddtional;
               app.breakpointList.Add(bp);
           end else if bpType = METHODBREAKPOINT then
           begin
               bp:=TBreakpoint.Create;
               bp.classType:= METHODBREAKPOINT;
               bp.id := FormatDateTime('yyyymmddhhnnsszzz',now);
               bp.name := bpName;
               bp.addtional := bpAddtional;
               app.breakpointList.Add(bp);
           end else if bpType = EXCEPTIONBREAKPOINT then
           begin
               bp:=TBreakpoint.Create;
               bp.classType:= EXCEPTIONBREAKPOINT;
               bp.id := FormatDateTime('yyyymmddhhnnsszzz',now);
               bp.name := bpName;
               bp.addtional := bpAddtional;
               app.breakpointList.Add(bp);
           end;
           UpdateJavaSourceBp(app,debugForm.sourceEdit.packageName);
         end;
       end;
     finally
       stream.Destroy;
       xmlDocument.Destroy;
       tempComponent.Destroy;
     end;
  end;

  procedure resumeReply(pid,con:String);
  var
    xmlDocument:TXMLDocument;
    tempComponent:TComponent;
    stream:TStringStream;
    threadID,rs:String;
    mythread:TDebugThread;
  begin
     stream :=  TStringStream.Create('<?xml version="1.0" encoding="GBK"?>'+con);
     tempComponent:=TComponent.Create(nil);
     xmlDocument:=TXMLDocument.Create(tempComponent);
     try
       try
         xmlDocument.LoadFromStream(stream);
       except
         ;
       end;
       threadID := XMLDocument.DocumentElement.ChildNodes['id'].Text;
       rs := XMLDocument.DocumentElement.ChildNodes['v'].Text;
       mythread:=findThread(pid,threadID);
       if mythread = nil then
         exit;
       if (rs = '1') then
       begin
         mythread.isSuspended := false;
         mythread.threadTreeNode.Text:=getThreadNodeText(mythread);
         mythread.threadTreeNode.ImageIndex:=setThreadIcon(mythread.status);
         mythread.threadTreeNode.SelectedIndex:=setThreadIcon(mythread.status);
       end;
     finally
       stream.Destroy;
       xmlDocument.Destroy;
       tempComponent.Destroy;
     end;
  end;

  procedure suspendReply(pid,con:String);
  var
    xmlDocument:TXMLDocument;
    tempComponent:TComponent;
    stream:TStringStream;
    threadID,rs:String;
    mythread:TDebugThread;
  begin
     stream :=  TStringStream.Create('<?xml version="1.0" encoding="GBK"?>'+con);
     tempComponent:=TComponent.Create(nil);
     xmlDocument:=TXMLDocument.Create(tempComponent);
     try
       try
         xmlDocument.LoadFromStream(stream);
       except
         ;
       end;
       threadID := XMLDocument.DocumentElement.ChildNodes['id'].Text;
       rs := XMLDocument.DocumentElement.ChildNodes['v'].Text;
       mythread:=findThread(pid,threadID);
       if mythread = nil then
         exit;
       if (rs = '1') then
       begin
         mythread.isSuspended := true;
         mythread.threadTreeNode.Text:=getThreadNodeText(mythread);
         mythread.threadTreeNode.ImageIndex:=THREAD_ICON_SUSPEND;
         mythread.threadTreeNode.SelectedIndex:=THREAD_ICON_SUSPEND;
       end else
       begin
         ShowMessageBox(rs_ThreadSuspend,0);
       end;
     finally
       stream.Destroy;
       xmlDocument.Destroy;
       tempComponent.Destroy;
     end;
  end;

  procedure parsePackage(pack:WideString;var command,pid,rs:WideString;var con:WideString);
  var
    xmlDocument:TXMLDocument;
    tempComponent:TComponent;
    stream:TStringStream;
  begin
     stream :=  TStringStream.Create('<?xml version="1.0" encoding="GBK"?>'+pack);
     tempComponent:=TComponent.Create(nil);
     xmlDocument:=TXMLDocument.Create(tempComponent);
     try
       try
         xmlDocument.LoadFromStream(stream);
       except
         ;
       end;
       command := XMLDocument.DocumentElement.ChildNodes['command'].Text;
       pid := XMLDocument.DocumentElement.ChildNodes['PID'].Text;
       rs := XMLDocument.DocumentElement.ChildNodes['result'].Text;
       con := XMLDocument.DocumentElement.ChildNodes['contents'].XML;
     finally
       stream.Destroy;
       xmlDocument.Destroy;
       tempComponent.Destroy;
     end;
  end;

  procedure parseThreadContents(con:WideString;var result:TStringList);
  var
    xmlDocument:TXMLDocument;
    tempComponent:TComponent;
    stream:TStringStream;
  begin
     stream :=  TStringStream.Create('<?xml version="1.0" encoding="GBK"?>'+con);
     tempComponent:=TComponent.Create(nil);
     xmlDocument:=TXMLDocument.Create(tempComponent);
     try
       try
         xmlDocument.LoadFromStream(stream);
       except
         ;
       end;
       result.Add(XMLDocument.DocumentElement.ChildNodes['id'].Text);
       result.add(XMLDocument.DocumentElement.ChildNodes['name'].Text);
       result.Add(XMLDocument.DocumentElement.ChildNodes['status'].Text);
       result.add(XMLDocument.DocumentElement.ChildNodes['group'].Text);
     finally
       stream.Destroy;
       xmlDocument.Destroy;
       tempComponent.Destroy;
     end;
  end;

  function parseThreadFrame(pid,con:WideString;var id:String;var frames:TStringList):TDebugThread;
  var
    xmlDocument:TXMLDocument;
    tempComponent:TComponent;
    stream:TStringStream;
    frameNode:IXMLNode;
    i:Integer;
    style,exception:String ;
  begin
     stream :=  TStringStream.Create('<?xml version="1.0" encoding="GBK"?>'+con);
     tempComponent:=TComponent.Create(nil);
     xmlDocument:=TXMLDocument.Create(tempComponent);
     try
       try
         xmlDocument.LoadFromStream(stream);
       except
         ;
       end;
       id:=XMLDocument.DocumentElement.ChildNodes['threadID'].Text;
       result:=findThread(pid,id);
       if result = nil then
         exit;
       style := XMLDocument.DocumentElement.ChildNodes['s'].Text;
       exception:=XMLDocument.DocumentElement.ChildNodes['e'].Text;

       if style = '1' then
       begin
          result.threadTreeNode.Text:=result.threadTreeNode.Text+' Catched Exception:'+ exception;
          addErrorMsg('application'+result.parent.name+' thread'+result.name+':Catched Exception'+ exception);
       end
       else if  style = '2' then
       begin
          result.threadTreeNode.Text:=result.threadTreeNode.Text+' Uncatched Exception:'+ exception;
          addErrorMsg('application'+result.parent.name+' thread'+result.name+':ncatched Exception:'+ exception);
       end;


       for i:=3 to XMLDocument.DocumentElement.ChildNodes.Count-1 do
       begin
          frameNode := XMLDocument.DocumentElement.ChildNodes[i];
          frames.add(frameNode.ChildNodes['id'].Text+'='+frameNode.ChildNodes['name'].Text);
       end;
     finally
       stream.Destroy;
       xmlDocument.Destroy;
       tempComponent.Destroy;
     end;
  end;

  function findApp(pid:String):TAppInfo;
  var
    app:TAppInfo;
    i:integer;
  begin
    for i:=0 to AppList.Count-1 do
    begin
      app:=TAppInfo(AppList.Objects[i]);
      if (app.appID = pid) then
      begin
         result:=app;
         exit;
      end;
    end;
    result:=nil;
  end;

  function ts_int2str(status:String):String;
  begin
    case StrToInt(status) of
      THREAD_STATUS_UNKNOWN     :
                                 result:='unknown';
      THREAD_STATUS_ZOMBIE      :
                                 result:='zombie';
      THREAD_STATUS_RUNNING     :
                                 result:='running';
      THREAD_STATUS_SLEEPING    :
                                 result:='sleeping';
      THREAD_STATUS_MONITOR     :
                                 result:='monitor';
      THREAD_STATUS_WAIT        :
                                 result:='wait';
      THREAD_STATUS_NOT_STARTED :
                                 result:='started';
    end;
  end;
  function setThreadIcon(status:String):Integer;
  begin
    result:=THREAD_ICON_UNKNOWN;
    case StrToInt(status) of
      THREAD_STATUS_UNKNOWN     :
                                 result:=THREAD_ICON_UNKNOWN;
      THREAD_STATUS_ZOMBIE      :
                                 result:=THREAD_ICON_ZOMBIE;
      THREAD_STATUS_RUNNING     :
                                 result:=THREAD_ICON_RUNNING;
      THREAD_STATUS_SLEEPING    :
                                 result:=THREAD_ICON_SLEEPING;
      THREAD_STATUS_MONITOR     :
                                 result:=THREAD_ICON_MONITOR;
      THREAD_STATUS_WAIT        :
                                 result:=THREAD_ICON_WAIT;
      THREAD_STATUS_NOT_STARTED :
                                 result:=THREAD_ICON_NOT_STARTED;
    end;
  end;


  procedure doAllThreads(pid:String;con:String);
  var
    xmlDocument:TXMLDocument;
    tempComponent:TComponent;
    stream:TStringStream;
    i,j:Integer;
    app:TAppInfo;
    threadID,status:String;
    threadNode:IXMLNode;
    finded:Boolean;
    tempThreadList:TStringList;
    mythread:TDebugThread;
  begin
     app:=findApp(pid);
     if app=nil then
       exit;
     stream :=  TStringStream.Create('<?xml version="1.0" encoding="GBK"?>'+con);
     tempComponent:=TComponent.Create(nil);
     xmlDocument:=TXMLDocument.Create(tempComponent);
     tempThreadList:=TStringList.Create;
     try
       xmlDocument.LoadFromStream(stream);
       for i:=0 to XMLDocument.DocumentElement.ChildNodes.Count-1 do
       begin
         threadNode:=XMLDocument.DocumentElement.ChildNodes[i];
         threadID:=threadNode.ChildNodes['id'].Text;
         status:=threadNode.ChildNodes['s'].Text;
         tempThreadList.Add(threadID+'='+status);
       end;

       //开始从tempThreadList中查找app中的每一个线程，如果找到，更新数据，如果没有找到，则删除
       i:=app.threads.Count-1;
       while(i>=0)do
       begin
         finded:=false;
         myThread:=TDebugThread(app.threads.Objects[i]);
         for j:=0 to tempThreadList.Count-1 do
         begin
           if myThread.threadID = tempThreadList.Names[j] then
           begin
             finded:=true;
             break;
           end;
         end;

         if finded then  //如果找到，刷新
         begin
           mythread.status:=tempThreadList.Values[tempThreadList.Names[j]];
           mythread.threadTreeNode.Text:=getThreadNodeText(myThread);
           mythread.threadTreeNode.ImageIndex:=setThreadIcon(mythread.status);
           mythread.threadTreeNode.SelectedIndex:=mythread.threadTreeNode.ImageIndex;
         end else        //如果没有找到，删除之
         begin
           //删除节点
           g_CanNotChThreadNode:=true;
           debugForm.ThreadListTV.Items.Delete(mythread.threadTreeNode);
           //释放该线程占用的内存区
           mythread.free;
           //从进程的线程列表中删除该线程
           App.threads.Delete(i);
         end;
         i:=i-1;
       end;
     finally
       tempThreadList.Destroy;
       stream.Destroy;
       xmlDocument.Destroy;
       tempComponent.Destroy;
     end;
  end;

{  procedure doAllThreads(pid:String;con:String);
  var
    xmlDocument:TXMLDocument;
    tempComponent:TComponent;
    stream:TStringStream;
    i,j:Integer;
    app:TAppInfo;
    threadID,susp:String;
    threadNode:IXMLNode;
    finded:Boolean;
    simpleThread:TSimpleThread;
    tempThreadList:TObjectList;
    mythread,newThread:TDebugThread;
  begin
     app:=findApp(pid);
     if app=nil then
       exit;
     stream :=  TStringStream.Create('<?xml version="1.0" encoding="GBK"?>'+con);
     tempComponent:=TComponent.Create(nil);
     xmlDocument:=TXMLDocument.Create(tempComponent);
     xmlDocument.LoadFromStream(stream);
     tempThreadList:=TObjectList.Create(false);
     try
       for i:=0 to XMLDocument.DocumentElement.ChildNodes.Count-1 do
       begin
         simpleThread:=TSimpleThread.Create;
         threadNode:=XMLDocument.DocumentElement.ChildNodes[i];
         simpleThread.threadID:=threadNode.ChildNodes['id'].Text;
         simpleThread.name:=threadNode.ChildNodes['n'].Text;
         simpleThread.status:=threadNode.ChildNodes['s'].Text;
         simpleThread.threadGroup:=threadNode.ChildNodes['g'].Text;
         susp:=threadNode.ChildNodes['p'].Text;
         if susp = '1' then
           simpleThread.isSuspended:=true
         else
           simpleThread.isSuspended:=false;
         tempThreadList.Add(simpleThread);
       end;

       //开始从tempThreadList中查找app中的每一个线程，如果找到，更新数据，如果没有找到，则删除
       i:=app.threads.Count-1;
       while(i>=0)do
       begin
         finded:=false;
         myThread:=TDebugThread(app.threads.Objects[i]);
         for j:=0 to tempThreadList.Count-1 do
         begin
           if myThread.threadID = TSimpleThread(tempThreadList.Items[j]).threadID then
           begin
             finded:=true;
             break;
           end;
         end;

         if finded then  //如果找到，刷新
         begin
           mythread.status:=TSimpleThread(tempThreadList.Items[j]).status;
           mythread.isSuspended:=TSimpleThread(tempThreadList.Items[j]).isSuspended;
           mythread.threadTreeNode.Text:=getThreadNodeText(myThread);
         end else        //如果没有找到，删除之
         begin
           //删除节点
           g_CanNotChThreadNode:=true;
           debugForm.ThreadListTV.Items.Delete(mythread.threadTreeNode);
           //释放该线程占用的内存区
           mythread.free;
           //从进程的线程列表中删除该线程
           App.threads.Delete(i);
         end;
         i:=i-1;
       end;

       for i:=0 to tempThreadList.Count-1 do
       begin
         finded:=false;
         simpleThread:=TSimpleThread(tempThreadList.Items[i]);
         for j:=0 to app.threads.Count-1 do
         begin
           if simpleThread.threadID = TDebugThread(app.threads.Objects[j]).threadID then
           begin
             finded:=true;
             break;
           end;
         end;

         if not finded then
         begin
              newThread:=TDebugThread.create(simpleThread.threadID);
              newThread.name:=simpleThread.name;
              newThread.isSuspended:=simpleThread.isSuspended;
              newThread.status:=simpleThread.status;
              newThread.threadGroup:=simpleThread.threadGroup ;
              newThread.threadTreeNode :=DebugForm.ThreadListTV.Items.addChild(app.appTreeNode,getThreadNodeText(newThread));
              newThread.threadTreeNode.Data := newThread;
              newThread.parent := app;
              //在该线程所属的进程中，增加一个线程
              app.threads.AddObject(threadID,newThread);
         end;
       end;

     finally
       for i:=0 to tempThreadList.Count-1 do
         if tempThreadList.Items[i] <> nil then
           TSimpleThread(tempThreadList.Items[i]).Free;
       tempThreadList.Destroy;
       stream.Destroy;
       xmlDocument.Destroy;
       tempComponent.Destroy;
     end;
  end;
}
  procedure addThread(pid:String;con:String);
  var
    newThread:TDebugThread;
    contents:TStringList;
    app:TAppInfo;
  begin
    contents:=TStringList.Create;
    parseThreadContents(con,contents)  ;
    newThread:=TDebugThread.create(contents[0]);
    newThread.name:=contents[1];
    newThread.status:= contents[2];
    newThread.threadGroup:=contents[3];
    app:=findApp(pid);
    newThread.threadTreeNode :=DebugForm.ThreadListTV.Items.addChild(app.appTreeNode,getThreadNodeText(newThread));
    newThread.threadTreeNode.ImageIndex:=1;
    newThread.threadTreeNode.SelectedIndex:=1;
    newThread.threadTreeNode.Data := newThread;
    newThread.parent := app;
    //在该线程所属的进程中，增加一个线程
    app.threads.AddObject(contents[0],newThread);
    contents.Destroy;
    app.appTreeNode.Expand(true);
  end;

  function findThread(pid,threadID:String):TDebugThread;
  var
    i,j:Integer;
    app:TAppInfo;
  begin
    result:=nil;
    for i:=0 to AppList.Count-1 do
    begin
      app:=TAppInfo(AppList.Objects[i]);
      if (app.appID = pid) then
      begin
          for j:=0 to app.threads.Count-1 do
          begin
              if ( TDebugThread(app.threads.Objects[j]).threadID = threadID ) then
              begin  //find the thread
                 result:=TDebugThread(app.threads.Objects[j]);
                 exit;
              end;
          end;
          Break;
      end;
    end;
  end;

  //根据进程id，线程id，帧id查找响应的帧
  function  findThreadFrame(pid,threadID,frameID:String):TThreadFrame;
  var
    i,j,k:Integer;
    app:TAppInfo;
    myThread:TDebugThread;
  begin
    result:=nil;
    for i:=0 to AppList.Count-1 do
    begin
      app:=TAppInfo(AppList.Objects[i]);
      if (app.appID = pid) then
      begin

          for j:=0 to app.threads.Count-1 do
          begin
              if ( TDebugThread(app.threads.Objects[j]).threadID = threadID ) then
              begin  //find the thread
                 myThread:=TDebugThread(app.threads.Objects[j]);
                    for k:=0 to myThread.frames.Count-1 do
                    begin
                      if TThreadFrame(myThread.frames.Objects[k]).id = frameID  then
                      begin
                        result := TThreadFrame(myThread.frames.Objects[k]);
                        exit;
                      end;
                    end;
                 break;
              end;
          end;
          Break;
      end;
    end;
  end;

  procedure delThread(pid,con:String);
  var
    yourThread:TDebugThread;
    yourApp:TAppInfo;
    j:Integer;
    contents:TStringList;
  begin
    yourApp:=findApp(pid);
    contents:=TStringList.Create;
    parseThreadContents(con,contents)  ;
    if (yourApp = nil) then
      exit;
    for j:=0 to yourApp.threads.Count-1 do
    begin
        yourThread :=  TDebugThread(yourApp.threads.Objects[j]);
        if ( yourThread.threadID = contents[0] ) then
        begin  //find the thread
           //从进程的线程列表中删除该线程
           g_CanNotChThreadNode:=true;
           yourApp.threads.Delete(j);
           //刷新界面,删除节点
           debugForm.ThreadListTV.Items.Delete(yourThread.threadTreeNode);
           //释放该线程占用的内存区
           yourThread.free;
           break;
        end;
    end;
    contents.Destroy;
  end;


  procedure refreshThreadFrames(pid,con:String);
  var
    yourThread:TDebugThread;
    i,j:Integer;
    threadID:String;
    contents:TStringList;
    frame:TThreadFrame;
    finded:Boolean;
    tempFrameList:TStringList;
  begin
    contents := TStringList.Create;
    yourThread:=parseThreadFrame(pid,con,threadID,contents);
    if yourThread = nil then
      exit;

    if ( yourThread.frames <> nil )then
    begin
     //1、删除不存在的节点
     i:=yourThread.frames.Count-1;
     while (i >=0 ) do
     begin
       finded := false;
       for j:=0 to contents.Count-1 do
       begin
          if ( TThreadFrame(yourThread.frames.Objects[i]).id = contents.Names[j]) then
          begin
            finded:=true;
            break;
          end;
       end;
       g_CanNotChThreadNode:=true;
       debugForm.ThreadListTV.Items.Delete(TThreadFrame(yourThread.frames.Objects[i]).frameTreeNode);//删除节点

       if not (finded) then                                     //如果没有找到
       begin
          TThreadFrame(yourThread.frames.Objects[i]).free;      //释放每个帧对象
          yourThread.frames.Delete(i);
       end;
       i:=i-1;
     end;
    end;

    tempFrameList:=TStringList.Create;
    tempFrameList.Assign(yourThread.frames);
    yourThread.frames.Clear;

   //2、增加原来没有的节点
    if ( ( tempFrameList <> nil ) and (contents.Count > 0 ) )then
    begin
       for i:=0 to contents.Count-1 do
       begin
         finded := false;
         for j:=0 to tempFrameList.Count-1 do
         begin
           if ( TThreadFrame(tempFrameList.Objects[j]).id = contents.Names[i]) then
           begin
             finded:=true;
             frame:=TThreadFrame(tempFrameList.Objects[j]);
             frame.frameTreeNode := debugForm.ThreadListTV.Items.AddChild(yourThread.threadTreeNode,frame.name);
             frame.frameTreeNode.Data := frame;
             yourThread.frames.AddObject(contents.Names[i],frame);
             break;
           end;
         end;
         if not finded then
         begin
           frame := TThreadFrame.create(contents.Names[i]);
           frame.name:=contents.Values[contents.names[i]];
           frame.frameTreeNode := debugForm.ThreadListTV.Items.AddChild(yourThread.threadTreeNode,frame.name);
           frame.frameTreeNode.Data := frame;
           frame.parent:= yourThread;
           yourThread.frames.AddObject(contents.Names[i],frame);
         end;
         if frame <> nil then
         begin
           frame.frameTreeNode.ImageIndex:=2;
           frame.frameTreeNode.SelectedIndex:=2;
         end;
       end;
    end;
    tempFrameList.Destroy;

    //展开该线程节点
    yourThread.threadTreeNode.Expand(true);
    debugForm.ThreadListTV.items.endUpdate;    //开始刷新

    if (yourThread.threadTreeNode.Count > 0) then
     begin
       //设置当前帧为treeview的选中节点
       g_CanNotChThreadNode:=true;
       debugForm.ThreadListTV.Selected:=yourThread.threadTreeNode.getFirstChild;
     end;
    contents.destroy;
  end;

  function  parseFrameLocals(pid:String;con:WideString;var sourceName:String;var curLine:Integer):TThreadFrame;
  var
    local:TLocal;
    xmlDocument:TXMLDocument;
    tempComponent:TComponent;
    stream:TStringStream;
    varNode:IXMLNode;
    i:Integer;
    frameID,threadID:String;
  begin
     stream :=  TStringStream.Create('<?xml version="1.0" encoding="GBK"?>'+con);
     tempComponent:=TComponent.Create(nil);
     xmlDocument:=TXMLDocument.Create(tempComponent);
     try
       try
         xmlDocument.LoadFromStream(stream);
       except
         ;
       end;
       threadID:=XMLDocument.DocumentElement.ChildNodes['threadID'].Text;
       frameID:=XMLDocument.DocumentElement.ChildNodes['frameID'].Text;
       result:=findThreadFrame(pid,threadID,frameID);
       if (result = nil)then
       begin
         //debugForm.debugMsg.lines.Add('Can not find the assign frame!');
         exit;
       end;

       sourceName:=XMLDocument.DocumentElement.ChildNodes['sourceName'].Text;
       curLine:=StrToInt(XMLDocument.DocumentElement.ChildNodes['curLine'].Text);

       LocalsList.clear;

       for i:=4 to XMLDocument.DocumentElement.ChildNodes.Count-1 do
       begin
          local := TLocal.Create;

          varNode := XMLDocument.DocumentElement.ChildNodes[i];
          local.name:=varNode.ChildNodes['n'].Text;
          local.varType:=varNode.ChildNodes['t'].Text;
          local.value:=varNode.ChildNodes['v'].Text;
          local.style:=StrToInt(varNode.ChildNodes['s'].Text);
          local.isArray:=StrToInt(varNode.ChildNodes['a'].Text);
          local.arrayLength:=StrToInt(varNode.ChildNodes['l'].Text);
          LocalsList.add(local);
       end;
     finally
       stream.Destroy;
       xmlDocument.Destroy;
       tempComponent.Destroy;
     end;
  end;

  function getFilePathName(path,name:String):String;
  begin
    path:=trim(path);
    name:=AnsiReplaceStr(name,'.','\')+'.java';
    if path[length(path)]<>'\' then
       path:=path+'\';
    result:=path+name;
  end;

  procedure refreshLocals(pid,con:String);
  var
    i,j,curLine:Integer;
    packageName,pathAndName,allWatchVar:String;
    app:TAppInfo;
    myFrame:TThreadFrame;
    point:TPoint;
    findSourceFile:Bool;
    tempNode:TTreeNode;
    sourceMan:TSourceManager;
    tempLines:TStringList;

    lastTopLine:Integer;
    msgID:Integer;
  begin
     //解析包内容
     myFrame:=parseFrameLocals(pid,con,packageName,curLine);
     if myFrame = nil then
     begin
       //清空所有的节点
       debugForm.LocalsListTV.Items.Clear;
       //变量类型和值为空
       debugForm.varTypeLabel.caption := '';
       debugForm.varValueMemo.Text := '';
       //初始化源文件区
       debugForm.sourceEdit.packageName:= '';
       debugForm.sourceEdit.findSourceFile:=false;
       debugForm.sourceEdit.Lines.Text:='';
       debugForm.sourceEdit.Breakpoints.Clear;

       debugForm.sourceGroupBox.caption:='';

       //addErrorMsg('无法找到指定的帧');
       exit;
     end;

     app:=myFrame.parent.parent;
     //清空变量显示区
     debugForm.varTypeLabel.caption := '';
     debugForm.varValueMemo.Text := '';

     //删除所有超过SHOW_MAX_CHILDNODE个子节点的节点,以加快刷新速度
     j:= debugForm.LocalsListTV.Items.count-1 ;
     while (j >= 0) do
     begin
       if debugForm.localsListTV.items[j].Count > SHOW_MAX_CHILDNODE then
          debugForm.localsListTV.items[j].Delete;           
       j:=j-1;
     end;
     
     //记忆所有已经展开的节点；
     g_expandedNodeList :='';
     for j:=0 to debugForm.LocalsListTV.Items.count-1 do
       if  (( debugForm.localsListTV.items[j].expanded)
              and (debugForm.localsListTV.items[j].data<> nil) ) then
       begin
         g_expandedNodeList := g_expandedNodeList + ' '+TLocal(debugForm.localsListTV.items[j].Data).name
       end;
       
     //记忆上次的选中节点
     if (( debugForm.localsListTV.selected <> nil) and ( TLocal(debugForm.LocalsListTV.selected.Data)<> nil) ) then
        curVarName :=TLocal(debugForm.LocalsListTV.selected.Data).name
     else
        curVarName :='';
     //清空所有的节点
     debugForm.localsListTV.Items.BeginUpdate;
     debugForm.LocalsListTV.Items.Clear;

      //更新源文件显示列表
      findSourceFile:=false;
      //tempBreakpoints:= TStringList.Create;
      tempLines:= TStringList.Create;
      if (curLine > 0) then
      begin
        if  ( ( pid <> debugForm.sourceEdit.appID ) or ( packageName <> debugForm.sourceEdit.packageName) )  then  //如果源文件名称改变，需要读取新的源文件
        begin

           for  j:=0 to app.catheSourceFileList.Count-1 do
           begin
             if packageName = TSourceManager(app.catheSourceFileList.Items[j]).packageName then
             begin
               //tempBreakpoints.Assign(TSourceManager(app.catheSourceFileList.Items[j]).breakpointList);
               tempLines.Assign(TSourceManager(app.catheSourceFileList.Items[j]).sourceCode);
               pathAndName:=TSourceManager(app.catheSourceFileList.Items[j]).sourceFile;

               findSourceFile:=true;
               break;
             end;
           end;

           if not  findSourceFile then
           begin
             app.sourceFilePathList.Insert(0,app.iniPath);
             for j:=0 to app.sourceFilePathList.Count-1 do
             begin
               pathAndName := getFilePathName(app.sourceFilePathList[j],packageName);
               if FileExists(pathAndName) then
               begin
                 sourceMan:=TSourceManager.create(pathAndName,packageName);
                 app.catheSourceFileList.Add(sourceMan);
                 if JavaIsNewerThanClass(pathAndName) then
                 begin
                   msgID:=MessageBox(debugForm.Handle,PChar(Format(getErrorMsg('SourceBeenModified'),[pathAndName,#13#10])),PChar(getErrorMsg('ConfirmCaption')),MB_YESNO or MB_ICONWARNING);
                   if msgID = IDYES then
                   begin
                     SendCommand(REQUEST_EXIT,app,'exit');
                     exit;
                   end;
                 end;
                 tempLines.LoadFromFile(pathAndName);
                 sourceMan.sourceCode.Assign(tempLines);
                 findSourceFile:=true;
                 break;
               end;
             end;
             if app.sourceFilePathList.Count > 0 then
               app.sourceFilePathList.Delete(0);
           end;

           if not findSourceFile then
           begin
               debugForm.sourceEdit.Text := 'Can''t find source file in the assigned paths.';
               debugForm.sourceEdit.Breakpoints.Clear;
           end;
        end
        else if debugForm.sourceEdit.findSourceFile then   //如果类没有变化，看看上次是否找到源文件
        begin
          findSourceFile := true;
          //tempBreakpoints.Assign(debugForm.sourceEdit.Breakpoints);
          tempLines.Assign(debugForm.sourceEdit.Lines);
        end;

      end
      else  if (curLine = -1  ) then
      begin
          //debugForm.sourceEdit.Font.Color:=clRed;
          debugForm.sourceEdit.Text := 'native method,can''t browser source file';
          debugForm.sourceEdit.Breakpoints.Clear;
      end;

      if findSourceFile then
      begin
        //保存内容
        {lastApp := findApp(debugForm.sourceEdit.appID);
        if lastApp <> nil then
        for  j:=0 to lastApp.catheSourceFileList.Count-1 do
        begin
          if debugForm.sourceEdit.packageName = TSourceManager(lastApp.catheSourceFileList.Items[j]).packageName then
          begin
            //TSourceManager(lastApp.catheSourceFileList.Items[j]).breakpointList.Assign(debugForm.sourceEdit.Breakpoints);
            if Trim(debugForm.sourceEdit.Lines.Text) <> '' then
              TSourceManager(lastApp.catheSourceFileList.Items[j]).sourceCode.Assign(debugForm.sourceEdit.Lines);
            TSourceManager(lastApp.catheSourceFileList.Items[j]).sourceFile:=pathAndName;
            break;
          end;
        end;
        }
        lastTopLine := debugForm.sourceEdit.TopLine;
        debugForm.sourceEdit.findSourceFile:=true;
        debugForm.sourceEdit.Lines.Assign(tempLines);
        //debugForm.sourceEdit.Breakpoints.Assign(tempBreakpoints);
        UpdateJavaSourceBp(app,packageName);

        //如果找到源文件，设置当前行为选择状态
        point.X := 0;
        point.Y := curLine;
        debugForm.sourceEdit.BlockBegin := point;
        point.X := length(debugForm.sourceEdit.Lines[curLine])+100;
        point.Y := curLine;
        debugForm.sourceEdit.BlockEnd   := point;
        //设置当前行可见
        if ( ( curLine < lastTopLine ) or ( curLine > (lastTopLine + debugForm.sourceEdit.LinesInWindow) )  ) then
            debugForm.sourceEdit.TopLine := curLine
        else
            debugForm.sourceEdit.TopLine := lastTopLine;

      end
      else
        debugForm.sourceEdit.findSourceFile:=false;

      debugForm.sourceGroupBox.caption:= 'Source Code:' + packageName ;
      debugForm.sourceEdit.appID:=pid;
      debugForm.sourceEdit.packageName:= packageName;
      //tempBreakpoints.Destroy;
      tempLines.Destroy;

     //增加变量节点
     for i:=0 to localsList.Count-1 do
     begin
         tempNode:=debugForm.LocalsListTV.Items.Add(nil,TLocal(localsList.Items[i]).name);
         tempNode.Data := localsList.items[i];
                                                        
         //style为1表示带有子节点；
            if (  ( TLocal(localsList.Items[i]).style = 1 )
                    or  ( (TLocal(localsList.Items[i]).isArray = 1) and (TLocal(localsList.Items[i]).arrayLength >0) )  )then
            debugForm.LocalsListTV.Items.AddChild(tempNode,'1');
     end;
     //发送消息，通知服务器更新带'-'的节点，即已经展开的节点；
     if (      g_expandedNodeList  <> '' ) then
     begin
        SendCommand(REQUEST_DEBUG,getCurNodePID,'dumpbatch '+ g_expandedNodeList);
     end
     else
     begin
        debugForm.LocalsListTV.Items.EndUpdate;
        setSelectedVar;
     end;

      //发送消息获取该变量的最新值
      allWatchVar:='';
      for i:=0 to  debugForm.watchVarLV.Items.Count-1 do
       allWatchVar:=allWatchVar + ' ' + debugForm.watchVarLV.Items[i].Caption;
      allWatchVar := trim(allWatchVar);
      if allWatchVar <> '' then
        SendCommand(REQUEST_DEBUG,pid,'getValue ' + allWatchVar);
  end;

  procedure refreshLocalByDump(rs:String;con:String);
  var
    local:TLocal;
    xmlDocument:TXMLDocument;
    tempComponent:TComponent;
    stream:TStringStream;
    varNode:IXMLNode;
    i:Integer;
    tempNode:TTreeNode;
    parentNode:TTreeNode;
  begin

     parentNode := getNodeByText(rs);
     if parentNode = nil then
        exit;

     stream :=  TStringStream.Create('<?xml version="1.0" encoding="GBK"?>'+con);
     tempComponent:=TComponent.Create(nil);
     xmlDocument:=TXMLDocument.Create(tempComponent);
     try
       try
         xmlDocument.LoadFromStream(stream);
       except
         ;
       end;
       for i:=0 to XMLDocument.DocumentElement.ChildNodes.Count-1 do
       begin
          local := TLocal.Create;
          varNode := XMLDocument.DocumentElement.ChildNodes[i];
          local.name:=varNode.ChildNodes['n'].Text;
          local.varType:=varNode.ChildNodes['t'].Text;
          local.value:=varNode.ChildNodes['v'].Text;
          local.style:=StrToInt(varNode.ChildNodes['s'].Text);
          local.isArray:=StrToInt(varNode.ChildNodes['a'].Text);
          local.arrayLength:=StrToInt(varNode.ChildNodes['l'].Text);
          tempNode:=debugForm.LocalsListTV.Items.AddChild(parentNode,local.name);

          local.name := getTextByNode(tempNode);
          tempNode.Data := local ;

          if (  (local.style = 1 )
                or  ( (local.isArray = 1) and (local.arrayLength >0)  ) )then
            debugForm.LocalsListTV.Items.AddChild(tempNode,'1');
       end;

       TLocal(parentNode.Data).hasRefresh := true;

       parentNode.Expand(false);
     finally
       stream.Destroy;
       xmlDocument.Destroy;
       tempComponent.Destroy;
     end;
  end;

  procedure refreshSingleLocal(rs,con:String);
  var
    xmlDocument:TXMLDocument;
    tempComponent:TComponent;
    stream:TStringStream;
    tempNode,childNode:TTreeNode;
    local:TLocal;
    fromWhere:String;
    i:Integer;
  begin
     tempNode := getNodeByText(rs);
     if tempNode = nil then
        exit;

     stream :=  TStringStream.Create('<?xml version="1.0" encoding="GBK"?>'+con);
     tempComponent:=TComponent.Create(nil);
     xmlDocument:=TXMLDocument.Create(tempComponent);
     try
       try
         xmlDocument.LoadFromStream(stream);
       except
         ;
       end;
       local := TLocal(tempNode.Data);
       fromWhere := xmlDocument.DocumentElement.ChildNodes['f'].Text;
       local.varType:=xmlDocument.DocumentElement.ChildNodes['t'].Text;
       local.value:=xmlDocument.DocumentElement.ChildNodes['v'].Text;
       local.style:=StrToInt(xmlDocument.DocumentElement.ChildNodes['s'].Text);
       local.isArray:=StrToInt(xmlDocument.DocumentElement.ChildNodes['a'].Text);
       local.arrayLength:=StrToInt(xmlDocument.DocumentElement.ChildNodes['l'].Text);
       //local.hasRefresh := true;
       {//栓新监视变量列表区
       for j:=0 to debugForm.watchVarLV.Items.count-1 do
          if debugForm.watchVarLV.Items[j].Caption = local.name then
          begin
            debugForm.watchVarLV.Items[j].subItems[0]:=local.value;
            break;
       end;}

       if (  (local.style = 1 )
             or  ( (local.isArray = 1) and (local.arrayLength >0)  ) )then
       begin
          if (( tempNode.count <> 1) or (tempNode.getFirstChild.text <> '1') )then
             debugForm.LocalsListTV.Items.AddChild(tempNode,'1');
       end
       else
       begin
          if (( tempNode.count = 1) and (tempNode.getFirstChild.text = '1') )then
             debugForm.LocalsListTV.Items.Delete(tempNode.getFirstChild);
       end;

       if fromWhere = 'expand' then
        begin
            tempNode.DeleteChildren;

            if ( local.isArray = 1 )  then
            begin
              debugForm.localsListTV.Items.BeginUpdate;
              for i:=0 to local.arrayLength-1 do
              begin
                childNode:=debugForm.localsListTV.Items.AddChild(tempNode,'['+ IntToStr(i) +']');
                if (local.style = 1) then
                  debugForm.localsListTV.Items.AddChild(childNode,'1');
              end;
              local.hasRefresh := true;
              tempNode.Expand(false);
              debugForm.localsListTV.Items.endUpdate;
            end;
        end;

       //g_is_deleteLocalNode := false;
       debugForm.LocalsListTV.Selected:=tempNode;
       debugForm.varTypeLabel.Caption := local.varType ;
       debugForm.varValueMemo.text := local.value ;
     finally
       stream.Destroy;
       xmlDocument.Destroy;
       tempComponent.Destroy;
     end;
  end;

  procedure refreshClassListBox(pid,con:String);
  var
    xmlDocument:TXMLDocument;
    tempComponent:TComponent;
    stream:TStringStream;
    i:Integer;
    //varNode:IXMLNode;
    app:TAppInfo;
  begin
     stream :=  TStringStream.Create('<?xml version="1.0" encoding="GBK"?>'+con);
     tempComponent:=TComponent.Create(nil);
     xmlDocument:=TXMLDocument.Create(tempComponent);
     try
       try
         xmlDocument.LoadFromStream(stream);
       except
         ;
       end;
       app:=findApp(pid);
       if app = nil then
         exit;

       app.loadedClassList.Clear;  
       for i:=0 to XMLDocument.DocumentElement.ChildNodes.Count-1 do
       begin
          app.loadedClassList.Add(XMLDocument.DocumentElement.ChildNodes[i].Text);
       end;
     
       if app.appID = getCurApp.appID then
          debugForm.classListBox.Items.Assign(app.loadedClassList);
     finally
       stream.Destroy;
       xmlDocument.Destroy;
       tempComponent.Destroy;
     end;
  end;

  procedure refreshWatchVar(con:String);
  var
    xmlDocument:TXMLDocument;
    tempComponent:TComponent;
    stream:TStringStream;
    i,j:Integer;
    varNode:IXMLNode;
    varName:String;
  begin
     stream :=  TStringStream.Create('<?xml version="1.0" encoding="GBK"?>'+con);
     tempComponent:=TComponent.Create(nil);
     xmlDocument:=TXMLDocument.Create(tempComponent);
     try
       try
         xmlDocument.LoadFromStream(stream);
       except
         ;
       end;
       for i:=0 to XMLDocument.DocumentElement.ChildNodes.Count-1 do
       begin
          varNode  := XMLDocument.DocumentElement.ChildNodes[i];
          varName  := varNode.ChildNodes['n'].Text;
          for j:=0 to debugForm.watchVarLV.Items.count-1 do
             if debugForm.watchVarLV.Items[j].Caption = trim(varName) then
             begin
               debugForm.watchVarLV.Items[j].subItems[0]:=varNode.ChildNodes['v'].text;
               break;
         end;
       end;
     finally
       stream.Destroy;
       xmlDocument.Destroy;
       tempComponent.Destroy;
     end;
  end;

  procedure refreshLocalByDumpBatch(con:String);
  var
    local:TLocal;
    xmlDocument:TXMLDocument;
    tempComponent:TComponent;
    stream:TStringStream;
    varNode,vNode:IXMLNode;
    i,j:Integer;
    varID,isArray:String;
    tempNode,newNode,parentNode:TTreeNode;
  begin
     stream :=  TStringStream.Create('<?xml version="1.0" encoding="GBK"?>'+con);
     tempComponent:=TComponent.Create(nil);
     xmlDocument:=TXMLDocument.Create(tempComponent);
     try
       try
         xmlDocument.LoadFromStream(stream);
       except
         ;
       end;
       for i:=0 to XMLDocument.DocumentElement.ChildNodes.Count-1 do
       begin
          varNode :=XMLDocument.DocumentElement.ChildNodes[i];
          varID := varNode.ChildNodes['id'].Text;
          isArray := varNode.ChildNodes['a'].Text;
          parentNode := getNodeByText(varID);
          if (parentNode=nil) then
           continue;

          parentNode.DeleteChildren;

          if (isArray = '1') then //如果为数组
          begin
            if parentNode.Data = nil then
            begin
                local := TLocal.Create;
                local.name:=varID;
                local.varType:=varNode.ChildNodes['t'].Text;
                local.value:=varNode.ChildNodes['v'].Text;
                local.style:=StrToInt(varNode.ChildNodes['s'].Text);
                local.isArray:=StrToInt(isArray);
                local.arrayLength:=StrToInt(varNode.ChildNodes['l'].Text);
                parentNode.Data:=local;
              
                 {//栓新监视变量列表区
                 for k:=0 to debugForm.watchVarLV.Items.count-1 do
                    if debugForm.watchVarLV.Items[k].Caption = local.name then
                    begin
                      debugForm.watchVarLV.Items[k].subItems[0]:=local.value;
                      break;
                 end; }

            end;

            for j:=0 to TLocal(parentNode.Data).arrayLength-1 do
            begin
              tempNode:=debugForm.localsListTV.Items.AddChild(parentNode,'['+ IntToStr(j) +']');
              if (TLocal(parentNode.Data).style =1 ) then
                debugForm.localsListTV.Items.AddChild(tempNode,'1');
            end;
          end
          else
          begin
              for j:=2 to varNode.ChildNodes.Count-1 do
              begin
                  vNode :=varNode.ChildNodes[j];
                  local := TLocal.Create;
                  local.name:=vNode.ChildNodes['n'].Text;
                  local.varType:=vNode.ChildNodes['t'].Text;
                  local.value:=vNode.ChildNodes['v'].Text;
                  local.style:=StrToInt(vNode.ChildNodes['s'].Text);
                  local.isArray:=StrToInt(vNode.ChildNodes['a'].Text);
                  local.arrayLength:=StrToInt(vNode.ChildNodes['l'].Text);
                  newNode:=debugForm.LocalsListTV.Items.AddChild(parentNode,local.name);
                  local.name := getTextByNode(newNode);
                  newNode.Data := local;

                  {//栓新监视变量列表区
                  for k:=0 to debugForm.watchVarLV.Items.count-1 do
                     if debugForm.watchVarLV.Items[k].Caption = local.name then
                     begin
                       debugForm.watchVarLV.Items[k].subItems[0]:=local.value;
                       break;
                  end;}

                  //是否带有子节点；
                    if (  ( local.style = 1 )
                            or ( ( local.isArray = 1) and (local.arrayLength > 0) )  )then
                      debugForm.LocalsListTV.Items.AddChild(newNode,'1');
               end;
          end;


          TLocal(parentNode.Data).hasRefresh := true;
          parentNode.expand(false);
       end;

       //如果没有选择节点，或者没有找到以前选择的节点，则，当前选择节点默认为第一个

       if g_expandedNodeList  <> '' then
       debugForm.localsListTV.Items.endUpdate;
       setSelectedVar;
     finally
       stream.Destroy;
       xmlDocument.Destroy;
       tempComponent.Destroy;
     end;
  end;

  procedure setSelectedVar;
  var
    tempNode:TTreeNode;
  begin
     if debugForm.localsListTV.items.Count > 0 then
     begin
        tempNode:=getNodeByText(curVarName);
        if tempNode = nil then
           debugForm.LocalsListTV.Selected:= debugForm.LocalsListTV.Items[0]
        else
           debugForm.LocalsListTV.Selected:= tempNode;

        //debugForm.LocalsListTV.Selected.Focused:=true;
        {  if debugForm.LocalsListTV.Selected.data <> nil then
        begin
          debugForm.varTypeLabel.Caption:= TLocal(debugForm.LocalsListTV.Selected.Data).varType;
          debugForm.varValueMemo.text:= TLocal(debugForm.LocalsListTV.Selected.Data).value;
          debugForm.LocalsListTV.Selected.Focused:=true;
        end;
        }
     end;
  end;

  function getTextByNode(node:TTreeNode):String;
  var
    tempNode:TTreeNode;
  begin
    result := node.Text;
    tempNode:=node;
    while (tempNode.Parent <> nil) do
    begin
      if ( Pos('[',tempNode.text) = 0) then
          result := tempNode.Parent.Text+'.'+  result
      else
          result := tempNode.Parent.Text +  result;
      tempNode := tempNode.Parent;
    end;
  end;

{  function getNodeByText(name:String):TTreeNode;
  var
   i:Integer;
  begin
     result:=nil ;
     if name='' then
      exit;

     for i:=0 to debugForm.LocalsListTV.Items.Count-1 do
       if ( name= getTextByNode(debugForm.LocalsListTV.Items[i])  ) then
       begin
           result:=debugForm.LocalsListTV.Items[i];
           break;
       end;
  end;
}
  function getNodeByText(name:String):TTreeNode;
  var
   i:Integer;
   node:TTreeNode;
   finded:Boolean;
   term:TStringList;
  begin
     result:=nil ;
     if name='' then
      exit;
     term:=TStringList.Create;
     SeparateTerms(name,'.',term);

     if term.Count <=0 then exit;
     if debugForm.LocalsListTV.Items.Count <= 0 then
       exit;
     finded:=false;
     node:=debugForm.LocalsListTV.items[0];
     while node <> nil do
     begin
       if node.Text = term[0] then
       begin
         finded:=true;
         break;
       end;
       node:=node.getNextSibling;
     end;
     if not finded then
       exit;
     if ((term.count=1) and (finded)) then
     begin
       result:=node;
       exit;
     end;
     for i:=1 to term.Count-1 do
     begin
       node:=getChildNodeBySubText(term[i],node);
       if node = nil then
         exit;
     end;
     result:=node;
     term.Destroy;
  end;

function getChildNodeBySubText(name:String;parent:TTreeNode):TTreeNode;
var
  node:TTreeNode;
begin
  result:=nil;
  node:=parent.getFirstChild;
  while node <> nil  do
  begin
    if node.Text = name then
    begin
      result:=node;
      exit;
    end;
    node:=parent.GetNextChild(node);
  end;
end;

procedure setBreakpoint(line:integer);
var
  pid,pack,command,bpid :String;
  app:TAppInfo;
  flag,i:Integer;
  found:Boolean;
begin
  app:= getCurApp;
  if app = nil then
   exit;
  pid:=app.appID;
  bpid:='0';
  pack:=debugForm.sourceEdit.packageName;
  flag:=debugForm.sourceEdit.ChangeBreakPoint(line);
  if ( flag > 0) then
  begin
      found:=false;
      for i:=0 to app.breakpointList.Count-1 do
      begin
        if ( (TBreakpoint(app.breakpointList.Items[i]).name = debugForm.SourceEdit.packageName)
           and (TBreakpoint(app.breakpointList.Items[i]).addtional = IntToStr(line)) ) then
        begin
          found:=true;
          break;
        end;
      end;
      if not found then
      begin
        command:='stopat '+ pack +' '+IntToStr(Line);
        SendCommand(REQUEST_DEBUG,pid,command);
        g_MouseClickLine := line;
      end;
  end
  else  if (flag < 0) then
  begin
      for i:=0 to app.breakpointList.Count-1 do
      begin
        if ( (TBreakpoint(app.breakpointList.Items[i]).name = debugForm.SourceEdit.packageName)
           and (TBreakpoint(app.breakpointList.Items[i]).addtional = IntToStr(line)) ) then
        begin
          bpid:=TBreakpoint(app.breakpointList.Items[i]).id;
          break;
        end;
      end;
      command:='clear linebp ' +  bpid + ' '  +  pack  + ' ' + IntToStr(Line);
      SendCommand(REQUEST_DEBUG,pid,command);
  end;
end;

  function  getCurApp:TAppInfo;
  begin
    result:=getAppByNode(debugForm.ThreadListTV.Selected);
  end;

  function  getCurThread:TDebugThread;
  begin
    result:=getThreadByNode(debugForm.ThreadListTV.Selected);;
  end;

  function  getCurThreadFrame:TThreadFrame;
  begin
    result:=getThreadFrameByNode(debugForm.ThreadListTV.Selected);
  end;

  function  getAppByName(name,fn:String):TAppInfo;
  var
    i:Integer;
    app:TAppInfo;
  begin
    result:=nil ;
    for i:=0 to appList.Count-1 do
    begin
      app:=TAppInfo(applist.Objects[i]);
      if ( app.name = name) and ( app.filename = fn) then
      begin
        result:=app;
        exit;
      end;
    end;
  end;

  procedure setCurAppNode(app:TAppInfo);
  begin
    if app <> nil then
    begin
      if app.lastSelNode <> nil then
        debugForm.ThreadListTV.Selected:= app.lastSelNode
      else
        debugForm.ThreadListTV.Selected:= app.appTreeNode;      
    end;
  end;

  function  getAppByNode(node:TTreeNode):TAppInfo;
  var
    tempNode:TMyNode;
    tempApp:TAppInfo;
  begin
    tempApp:=nil;
    if Node = nil then
    begin
      result:=nil;
      exit;
    end;
    if TMyNode(node.Data) <> nil then
    begin
      tempNode:=TMyNode(node.Data);
      case (tempNode.level) of
        1:
            tempApp:=TAppInfo(node.Data);
        2:
            tempApp:=TAppInfo(node.Parent.Data);
        3:
            tempApp:=TAppInfo(node.Parent.Parent.Data);
      end;
    end;
    result:=tempApp;
  end;

  function  getThreadByNode(node:TTreeNode):TDebugThread;
  var
    tempNode:TMyNode;
    tempThread:TDebugThread;
  begin
    tempThread:=nil;
    if TMyNode(node.Data) <> nil then
    begin
      tempNode:=TMyNode(node.Data);
      case (tempNode.level) of
        2:
            tempThread:=TDebugThread(node.Data);
        3:
            tempThread:=TDebugThread(node.parent.Data);
      end;
    end;
    result:=tempThread;
  end;

  function  getThreadFrameByNode(node:TTreeNode):TThreadFrame;
  var
    tempNode:TMyNode;
    tempThreadFrame:TThreadFrame;
  begin
    tempThreadFrame:=nil;
    if (( node <> nil) and (node.Data <> nil) ) then
    begin
      tempNode:=TMyNode(node.Data);
      if tempNode.level = 3 then
        tempThreadFrame:=TThreadFrame(node.Data);
    end;
    result:=tempThreadFrame;
  end;

  function getCurNodePID:String;
  var
    node:TMyNode;
    pid:String;
  begin
    if (   debugForm.ThreadListTV.Selected <> nil)  then
    begin
      node:=TMyNode(debugForm.ThreadListTV.Selected.Data);
      case (node.level) of
        1:
            pid:=TAppInfo(debugForm.ThreadListTV.Selected.Data).appID;
        2:
            pid:=TAppInfo(debugForm.ThreadListTV.Selected.Parent.Data).appID;
        3:
            pid:=TAppInfo(debugForm.ThreadListTV.Selected.Parent.Parent.Data).appID;
      end;
      result :=pid;
    end
    else
       result :='';
  end;

  procedure addErrorMsg(msg:String);overload;
  begin
    debugForm.debugMsg.Lines.Add(FormatDateTime('yyyy-mm-dd hh:nn:ss:zzz    ',now)+msg);
    Beep;
  end;
  procedure addErrorMsg(msg:String;isBeep:Boolean);overload;
  begin
    debugForm.debugMsg.Lines.Add(FormatDateTime('yyyy-mm-dd hh:nn:ss:zzz    ',now)+msg);
    if isBeep then
      Beep;
  end;

  {procedure deleteNodeRecurse(Node:TTreeNode);
  var
   tempNode:TTreeNode;
  begin
    //删除数据
    if (Node.Data <> nil) then
      TLocal(Node.Data).Free;
    tempNode := Node.getFirstChild;
    //删除子节点
    while (tempNode <> nil) do
    begin
      deleteNodeRecurse(tempNode);
      tempNode:=Node.GetNextChild(tempNode);
    end;
    //删除本节点
    //debugForm.LocalsListTV.Items.Delete(Node);
  end;

  procedure deleteChildrenData(Node:TTreeNode);
  var
   tempNode:TTreeNode;
  begin
    //删除数据
    tempNode := Node.getFirstChild;
    //删除子节点
    while (tempNode <> nil) do
    begin
      if (tempNode.Data <> nil) then
        TLocal(tempNode.Data).Free;
      deleteChildrenData(tempNode);
      tempNode:=Node.GetNextChild(tempNode);
    end;
    //删除本节点
    //debugForm.LocalsListTV.Items.Delete(Node);
  end;}
function isLegalVar(VarName:String):Boolean;
var
   Ch: Char;
   Source: PChar;
   i:integer;
begin
     result:=true;
     VarName:=trim(VarName);
     if VarName='' then
     begin
          result:=false;
          exit;
     end;
     Source := Pointer(VarName);
     for i:=0 to Length(VarName)-1 do
     begin
          Ch := Source^;
     if i=0 then
        if ( Ch in ['1'..'9']) then
        begin
             result:=false;
             break;
        end;
     if  ((Ch in ['A'..'Z']) or  ( Ch in ['a'..'z'])
         or  ( Ch in ['1'..'9']) or ( Ch in ['_','-','$','.','['])) then
      Inc(Source)
      else begin
                result:=false;
                break;
           end;
   end;

end ;

function getThreadNodeText(mythread:TDebugThread):String;
begin
  if mythread.isSuspended then
    result:='Thread '+myThread.name +': '+ ts_int2str(myThread.status)+'  Suspended'
  else
    result:='Thread '+myThread.name +': '+ ts_int2str(myThread.status);
end;

procedure startDebugServer;
var
  toolsPath,commandLine,curDir:String;
  StartupInfo:TStartupInfo;
begin

  if g_debugServerSocket <> nil then
  begin
     ShowMessageBox(rs_DebugServerHasStarted,0);
     exit;
  end;


  curDir := g_debugServerPath+#0;

  toolsPath := g_javaHome + 'lib\tools.jar';

  if not FileExists(toolsPath) then
  begin
    ShowMessageBox(rs_CannotFindToolsJar,0);
    exit;
  end;

  commandLine:=g_javaw +' -classpath ".;.\extlib\jdom.jar;.\extlib\xerces.jar;.\debugServer.jar;'
                + toolsPath +'" '+DEBUGSERVERCENTERCLASS+#0;
  FillChar(StartupInfo,Sizeof(StartupInfo),#0);
  StartupInfo.cb := Sizeof(StartupInfo);
  StartupInfo.dwFlags := STARTF_USESHOWWINDOW;
  StartupInfo.wShowWindow := SW_HIDE;
  //启动调试控制台
  if  CreateProcess
                 (nil,
                  @commandLine[1],
                  @g_Security,
                  @g_Security,
                  true,
                  CREATE_NEW_CONSOLE or NORMAL_PRIORITY_CLASS,
                  nil,
                  @curDir[1],
                  StartupInfo, g_debugServerApp) then
  begin
    //表明已经启动调试服务器进程
    addErrorMsg(rs_DebugServerStartOK,false);
    WriteCfgString('DebugServer','debug_server_id',IntToStr(g_debugServerApp.dwProcessId));
  end else
    addErrorMsg(rs_DebugServerStartFail);
end;

procedure SeparateSubTerms(s : string;SeparatorBegin : char; SeparatorEnd : char;var Terms : TStringList);
 var
  hs : string;
  pBegin,pEnd : integer;
begin
  pBegin:=Pos(SeparatorBegin,s);
  pEnd:=Pos(SeparatorEnd,s);
  while (pBegin>0) and (pEnd>0) do
  begin
    if pBegin<>1 then
    begin
      hs:=Copy(s,1,pBegin-1);   // Copy term
      Terms.Add(hs);
    end;
    hs:=Copy(s,pBegin,pEnd-pBegin+1);   // Copy term
    Terms.Add(hs);       // Add to list
    Delete(s,1,pEnd);       // Remove term and separator
    pBegin:=Pos(SeparatorBegin,s);
    pEnd:=Pos(SeparatorEnd,s);
  end;
end;


procedure SeparateTerms(s : string;Separator : char; var Terms : TStringList);
var
  hs : string;
  p : integer;
begin
  Terms.Clear;
  if Length(s)=0 then
    Exit;
  p:=Pos(Separator,s);
  while P<>0 do
  begin
    hs:=Copy(s,1,p-1);     // Copy term
    if (pos('[',hs)>0) and (pos(']',hs)>0) then    //If contains char '['and ']'
    begin
       SeparateSubTerms(hs,'[',']',Terms);        //Parse [*] from a String
    end else     Terms.Add(hs);
    Delete(s,1,p);                                //Remove term and separator
    p:=Pos(Separator,s);                          //Get the  position of next Separator
  end;
  if Length(s)>0 then
  begin
    if (pos('[',s)>0) and (pos(']',s)>0) then
       SeparateSubTerms(s,'[',']',Terms)
    else  Terms.Add(s);
  end
end;

function getDirByStr(fileName:String):String;
begin
 result:='';
 if fileName='' then
    exit;
 if fileName[length(fileName)] <> '\' then
   result:=fileName+'\'
 else
   result:=fileName;
end;

procedure UpdateJavaSourceBp(app:TAppInfo;packageName:String);
var
  i:Integer;
  bp:TBreakpoint;
  bpNode:TTreeNode;
begin
  try
     debugForm.sourceEdit.ClearBreakPoint;
     debugForm.BreakpointListTV.TopItem.getNextSibling.getNextSibling.DeleteChildren;
     debugForm.BreakpointListTV.TopItem.getNextSibling.DeleteChildren;
     debugForm.BreakpointListTV.TopItem.DeleteChildren;

     for i:=0 to app.breakpointList.Count-1 do
     begin
       bp:=TBreakpoint(app.breakpointList.Items[i]);
       if bp.classType = LINEBREAKPOINT then
       begin
         bpNode:=debugForm.BreakpointListTV.Items.AddChildObject(DebugForm.BreakpointListTV.TopItem,
         ' Line ' + bp.addtional + '(' + bp.name + ')',bp);
         if bp.name = packageName then
           debugForm.sourceEdit.AddBreakPoint(StrToInt(bp.addtional))
       end else  if TBreakpoint(app.breakpointList.Items[i]).classType = METHODBREAKPOINT then
       begin
         bpNode:=debugForm.BreakpointListTV.Items.AddChildObject(DebugForm.BreakpointListTV.TopItem.getNextSibling,
         bp.addtional + '('+ bp.name+')',bp);
       end else  if TBreakpoint(app.breakpointList.Items[i]).classType = EXCEPTIONBREAKPOINT then
       begin
         bpNode:=debugForm.BreakpointListTV.Items.AddChildObject(DebugForm.BreakpointListTV.TopItem.getNextSibling.getNextSibling,
         bp.name,bp);
       end;
       if bpNode <> nil then
       begin
         bpNode.StateIndex:=bpNode.Parent.StateIndex;
         bpNode.ImageIndex:=bpNode.Parent.ImageIndex;
         bpNode.SelectedIndex:=bpNode.Parent.SelectedIndex;
       end;
     end;

     debugForm.BreakpointListTV.TopItem.Expand(false);
     debugForm.BreakpointListTV.TopItem.getNextSibling.Expand(false);
     debugForm.BreakpointListTV.TopItem.getNextSibling.getNextSibling.Expand(false);
  finally
    ;
  end;
end;



end.
