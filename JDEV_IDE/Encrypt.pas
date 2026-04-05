unit Encrypt;

interface
uses
  SysUtils,windows,Classes,DateUtils,Registry,HCMngr,ideUnit,IniFiles,uCommandData;

type
  TLicenseData = record
    produceID:array[0..100] of char;
    guidMys1:array[0..100] of char;
    firstDate:array[0..100] of char;
    guidMys2:array[0..100] of char;
    license:array[0..100] of char;
  end;

  TRegData = record
    produceID:String;
    guidMys1:String;
    firstDate:String;
    guidMys2:String;
    license:String;
  end;

  procedure SaveReg(index:Integer;s1,s2,s3,s4,s5:String);
  procedure InitSaveReg(index:Integer;s:String;force:Boolean);
  function readReg(index:Integer):TRegData;
  procedure CheckValidLicense;
  procedure InitCheckLicense;
  procedure RegisterSoftware(produceID,license:String);
  
implementation
uses
  registerUnit;

  function readReg(index:Integer):TRegData;
  var
    reg:TRegistry;
    regStr:String;
  begin

    Reg := TRegistry.Create;

    if index = 1 then
    begin
      ideFrm.CipherManager.Algorithm:=ALGORITHM_REG1;
      reg.RootKey := HKEY_CLASSES_ROOT ;
      regStr:='\CLSID\' + FAKE_CLASSID;
    end else
    if index = 2 then
    begin
      ideFrm.CipherManager.Algorithm:=ALGORITHM_REG2;
      reg.RootKey := HKEY_CURRENT_USER ;
      regStr:='\Software\CLSID\' + FAKE_CLASSID;
    end else
    if index = 3 then
    begin
      ideFrm.CipherManager.Algorithm:=ALGORITHM_REG3;
      reg.RootKey := HKEY_LOCAL_MACHINE ;
      regStr:='\Software\CLSID\' + FAKE_CLASSID;
    end;

    ideFrm.CipherManager.InitKey(CIPHERKEY,nil);

    try
      if Reg.OpenKey(regStr, True) then
      begin
        result.produceID:= ideFrm.CipherManager.DecodeString(Reg.ReadString('produceID1'));
        result.guidMys1:= ideFrm.CipherManager.DecodeString(Reg.ReadString('produceID2'));
        result.firstDate:= ideFrm.CipherManager.DecodeString(Reg.ReadString('produceID3'));
        result.guidMys2:= ideFrm.CipherManager.DecodeString(Reg.ReadString('produceID4'));
        result.license:= ideFrm.CipherManager.DecodeString(Reg.ReadString('produceID5'));
        Reg.CloseKey;
      end;
    finally
      Reg.Free;
    end;
  end;

  //save register key
  procedure SaveReg(index:Integer;s1,s2,s3,s4,s5:String);
  var
    reg:TRegistry;
    regStr:String;
  begin

    Reg := TRegistry.Create;

    if index = 1 then
    begin
      ideFrm.CipherManager.Algorithm:=ALGORITHM_REG1;
      reg.RootKey := HKEY_CLASSES_ROOT ;
      regStr:='\CLSID\' + FAKE_CLASSID;
    end  else
    if index = 2 then
    begin
      ideFrm.CipherManager.Algorithm:=ALGORITHM_REG2;
      reg.RootKey := HKEY_CURRENT_USER ;
      regStr:='\Software\CLSID\' + FAKE_CLASSID;
    end else
    if index = 3 then
    begin
      ideFrm.CipherManager.Algorithm:=ALGORITHM_REG3;
      reg.RootKey := HKEY_LOCAL_MACHINE ;
      regStr:='\Software\CLSID\' + FAKE_CLASSID;
    end;

    ideFrm.CipherManager.InitKey(CIPHERKEY,nil);

    try
      if Reg.OpenKey(regStr, True) then
      begin
        Reg.WriteString('produceID1',ideFrm.CipherManager.EncodeString(s1));
        Reg.WriteString('produceID2',ideFrm.CipherManager.EncodeString(s2));
        //Reg.WriteString('produceID3',ideFrm.CipherManager.EncodeString(s3));
        //Reg.WriteString('produceID4',ideFrm.CipherManager.EncodeString(s4));
        Reg.WriteString('produceID5',ideFrm.CipherManager.EncodeString(s5));
        Reg.CloseKey;
      end;
    finally
      Reg.Free;
    end;
  end;

  procedure InitSaveReg(index:Integer;s:String;force:Boolean);
  var
    reg:TRegistry;
    regStr:String;
  begin

    Reg := TRegistry.Create;

    if index = 1 then
    begin
      ideFrm.CipherManager.Algorithm:=ALGORITHM_REG1;
      reg.RootKey := HKEY_CLASSES_ROOT ;
      regStr:='\CLSID\' + FAKE_CLASSID;
    end else
    if index = 2 then
    begin
      ideFrm.CipherManager.Algorithm:=ALGORITHM_REG2;
      reg.RootKey := HKEY_CURRENT_USER ;
      regStr:='\Software\CLSID\' + FAKE_CLASSID;
    end else
    if index = 3 then
    begin
      ideFrm.CipherManager.Algorithm:=ALGORITHM_REG3;
      reg.RootKey := HKEY_LOCAL_MACHINE ;
      regStr:='\Software\CLSID\' + FAKE_CLASSID;
    end;

    ideFrm.CipherManager.InitKey(CIPHERKEY,nil);

    try
      if Reg.OpenKey(regStr, True) then
      begin
        if force or (reg.ReadString('produceID3') = '')  then
          Reg.WriteString('produceID3',ideFrm.CipherManager.EncodeString(s));
        Reg.WriteString('produceID4',ideFrm.CipherManager.EncodeString(IntToStr(g_filesize)));

        Reg.CloseKey;
      end;
    finally
      Reg.Free;
    end;
  end;

  procedure InitCheckLicense;
  var
    reg1,reg2,reg3,lic:TRegData;
    licData:TLicenseData;
    fs:TMemoryStream;
    firstDate:TDateTime;
    iniFile: TIniFile;
    status:String;
    nowTime:String;

  begin
    iniFile := TIniFile.Create(g_exeFilePath + CONFIGFILE );
    try
      g_status:=inifile.ReadString('IDE','status','0');
      if g_status = '1' then
      begin
        //表明是第一次运行，写注册表
        nowTime:=DateTimeToStr(now);
        InitSaveReg(1,nowTime,false);
        InitSaveReg(2,nowTime,false);
        InitSaveReg(3,nowTime,false);
      end;
      inifile.DeleteKey('IDE','status');
    finally
      iniFile.Free;
    end;

    //if status = '1'  then
    //  exit;

    reg1:=ReadReg(1);
    reg2:=ReadReg(2);
    reg3:=ReadReg(3);
    //文件大小被改变，可能有人crack
    //if ( reg1.guidMys2 <> reg2.guidMys2 ) or ( reg1.guidMys2 <> reg3.guidMys2 ) or ( IntToStr(g_filesize) <> reg1.guidMys2 )then
    if ( reg1.guidMys2 <> reg2.guidMys2 )
        or ( reg1.guidMys2 <> reg3.guidMys2 )
         or ( reg1.firstDate <> reg2.firstDate )
          or ( reg1.firstDate <> reg3.firstDate )
    then
    begin
      MessageBox(ideFrm.handle,'The jdev.exe was modified invalid.'#13#10'Application will terminate.',
                               'Error Message',MB_OK or MB_ICONWARNING);
      if g_RegForm <> nil then
      begin
        g_RegForm.Free;
        g_RegForm:=nil;
      end;
      halt;
    end;


    if not FileExists(g_exeFilePath + LICENSE_FILE) then
    begin
      //检测是不是试用版
      //首先检测是不是相同，不相同，表示有人改过，就认为过了,定为试用版期
      if ( reg1.firstDate = reg2.firstDate ) and ( reg1.firstDate = reg3.firstDate ) then
      begin
        try
        firstDate:=StrToDateTime(reg1.firstDate);
        except
            MessageBox(ideFrm.handle,'The register db was modified invalid.'#13#10'Application will terminate.',
                                     'Error Message',MB_OK or MB_ICONWARNING);
            if g_RegForm <> nil then
            begin
              g_RegForm.Free;
              g_RegForm:=nil;
            end;
            halt;
        end;

        if DaysBetween(now , firstDate) >= 30 then
        begin
          nowTime:=DateTimeToStr(now+ 365 * 1000);
          InitSaveReg(1,nowTime,true);
          InitSaveReg(2,nowTime,true);
          InitSaveReg(3,nowTime,true);
          G_VersionType:= PASSTRAILVERSION;
        end
        else
        begin
          ideFrm.registerLbl.Caption:='Unregistered Version:' + IntToStr( 30 - DaysBetween(firstDate , now)) + ' days leave';
          G_VersionType:= TRAILVERSION ;
        end;
      end else
      begin
        MessageBox(ideFrm.handle,'The register db was modified invalid.'#13#10'Application will terminate.',
                                 'Error Message',MB_OK or MB_ICONWARNING);
        if g_RegForm <> nil then
        begin
          g_RegForm.Free;
          g_RegForm:=nil;
        end;
        halt;
      end;

    end else
    begin
      //检测是不是正式版
      fs:=TMemoryStream.Create;
      fs.LoadFromFile( g_exeFilePath + LICENSE_FILE );
      if fs.Size <> 505 then
      begin
        MessageBox(ideFrm.handle,'The license was modified invalid.'#13#10'Application will terminate.',
                                 'Error Message',MB_OK or MB_ICONWARNING);
        if g_RegForm <> nil then
        begin
          g_RegForm.Free;
          g_RegForm:=nil;
        end;                                 
        halt;
      end;
      ideFrm.CipherManager.Algorithm:=ALGORITHM_LICENSE;
      ideFrm.CipherManager.InitKey(CIPHERKEY,nil);
      fs.Read(licData,505);
      lic.produceID := Copy(licData.produceID,2, Integer(licData.produceID[0]) );
      lic.produceID:=ideFrm.CipherManager.DecodeString(lic.produceID);
      lic.license := Copy(licData.license,2, Integer(licData.license[0]) );
      lic.license:=ideFrm.CipherManager.DecodeString(lic.license);
      fs.Free;

      if ( lic.produceID = reg1.produceID ) and ( lic.produceID = reg2.produceID ) and ( lic.produceID = reg3.produceID )
         and ( lic.license = reg1.license ) and ( lic.license = reg2.license ) and ( lic.license = reg3.license )
      then
      begin
        //检测 licenses 是否和 product 配对
        if lic.license  <>  ideFrm.CipherManager.EncodeString(lic.produceID)then
        begin //非法版本
          G_VersionType:= PASSTRAILVERSION ;
        end else   //正式版本
          G_VersionType:= REGISTERVERSION ;

      end else
        G_VersionType:= PASSTRAILVERSION ;
    end;

    if ( G_VersionType = TRAILVERSION ) then
    begin
      idefrm.unregisterPanel.Visible:=true;
      idefrm.registerMI.Visible:=true;
      idefrm.orderingMI.Visible:=true;
    end else if ( G_VersionType = REGISTERVERSION ) then
    begin
      idefrm.unregisterPanel.Visible:=false;
      idefrm.registerMI.Visible:=false;
      idefrm.orderingMI.Visible:=false;
    end else
    begin
      //退出
      if MessageBox(ideFrm.handle,'You License is invalid or JDev has passed the trial duration.'#13#10'Would you register now?',
                               'Error Message',MB_OKCANCEL or MB_ICONWARNING) = IDOK then
      begin
        g_RegForm.FirstFlag:=true;
        g_RegForm.showModal;
      end
      else
      begin
        if g_RegForm <> nil then
        begin
          g_RegForm.Free;
          g_RegForm:=nil;
        end;
        halt;
      end;
    end;
    ideFrm.checkLicenseTimer.Enabled:=true;
  end;

  //check licese is valid or not;
  procedure CheckValidLicense;
  var
    reg1,reg2,reg3,lic:TRegData;
    licData:TLicenseData;
    fs:TMemoryStream;
    firstDate:TDateTime;
    nowTime:String;
  begin
    reg1:=readReg(1);
    reg2:=readReg(2);
    reg3:=readReg(3);
    
    //if ( reg1.guidMys2 <> reg2.guidMys2 ) or ( reg1.guidMys2 <> reg3.guidMys2 ) or ( IntToStr(g_filesize) <> reg1.guidMys2 )then
    if ( reg1.guidMys2 <> reg2.guidMys2 ) or ( reg1.guidMys2 <> reg3.guidMys2 ) then
    begin
      MessageBox(ideFrm.handle,'The jdev.exe was modified illegally.'#13#10'Application will terminate.',
                               'Error Message',MB_OK or MB_ICONWARNING);
      halt;
    end;

    if not FileExists(g_exeFilePath + LICENSE_FILE) then
    begin
      //检测是不是试用版
      //首先检测是不是相同，不相同，表示有人改过，就认为过了,定为试用版期
      if ( reg1.firstDate = reg2.firstDate ) and ( reg1.firstDate = reg3.firstDate ) then
      begin
        try
        firstDate:=StrToDateTime(reg1.firstDate);
        except
            postMessage( ideFrm.handle, WM_REGISTER_LICENSE, PASSTRAILVERSION,0 );
            exit;
        end;

        if DaysBetween(now , firstDate) >= 30 then
        begin
          nowTime:=DateTimeToStr(now + 365 * 1000);
          InitSaveReg(1,nowTime,true);
          InitSaveReg(2,nowTime,true);
          InitSaveReg(3,nowTime,true);       
          postMessage( ideFrm.handle, WM_REGISTER_LICENSE, PASSTRAILVERSION,0 );
        end
        else
        begin
          ideFrm.registerLbl.Caption:='Unregistered Version:' + IntToStr( 30 - DaysBetween(firstDate , now)) + ' days leave';
          postMessage( ideFrm.handle, WM_REGISTER_LICENSE, TRAILVERSION,0 );
        end;
      end else
        postMessage( ideFrm.handle, WM_REGISTER_LICENSE, PASSTRAILVERSION,0 );
        
    end else
    begin
      //检测是不是正式版
      fs:=TMemoryStream.Create;
      fs.LoadFromFile( g_exeFilePath + LICENSE_FILE );
      if fs.Size <> 505 then
      begin
        postMessage( ideFrm.handle, WM_REGISTER_LICENSE, PASSTRAILVERSION,0 );
        exit;
      end;
      ideFrm.CipherManager.Algorithm:=ALGORITHM_LICENSE;
      ideFrm.CipherManager.InitKey(CIPHERKEY,nil);
      fs.Read(licData,505);
      lic.produceID := Copy(licData.produceID,2, Integer(licData.produceID[0]) );
      lic.produceID:=ideFrm.CipherManager.DecodeString(lic.produceID);
      lic.license := Copy(licData.license,2, Integer(licData.license[0]) );
      lic.license:=ideFrm.CipherManager.DecodeString(lic.license);
      fs.Free;


      if ( lic.produceID = reg1.produceID ) and ( lic.produceID = reg2.produceID ) and ( lic.produceID = reg3.produceID )
         and ( lic.license = reg1.license ) and ( lic.license = reg2.license ) and ( lic.license = reg3.license )
      then
      begin
        //检测 licenses 是否和 product 配对
        if lic.license  <>  ideFrm.CipherManager.EncodeString(lic.produceID)then
        begin //非法版本
          postMessage( ideFrm.handle, WM_REGISTER_LICENSE, PASSTRAILVERSION , 0 );
          exit;
        end else   //正式版本
          postMessage( ideFrm.handle, WM_REGISTER_LICENSE, REGISTERVERSION , 0 );

      end else
        postMessage( ideFrm.handle, WM_REGISTER_LICENSE, PASSTRAILVERSION , 0 );

    end;
  end;


  //register my software with id and license
  procedure RegisterSoftware(produceID,license:String);
  var
    lic:TLicenseData;
    fs:TFileStream;
    i,count:Integer;
    tempStr:String;
  begin
    for i:=0 to 20 do
    begin
      if i < i-100 then
        exit;
    end;
    ideFrm.CipherManager.Algorithm:=ALGORITHM_LICENSE;
    ideFrm.CipherManager.InitKey(CIPHERKEY,nil);

    //首先检测 productID 与 license 是否配对，如果配对表明注册成功，否则，失败，提示错误信息
    //write license file
    tempStr := ideFrm.CipherManager.EncodeString(produceID);
    count:=length(tempStr);
    if count <> length(license) then
    begin
        if not g_RegForm.FirstFlag  then
          postMessage(g_RegForm.handle,WM_REGISTER_RESULT,0,0)
        else
        begin
          MessageBox(ideFrm.handle,'You input invalidate license,JDev will halt now.','Register Error',MB_OK or MB_ICONWARNING);
          halt;
        end;
    end;

    for i:=0 to 20 do
    begin
      if i < i-100 then
        exit;
    end;
    

    for i:=1 to count do
    begin
      if tempstr[i] <> license[i] then
      begin
        //MessageBox(ideFrm.handle,'You License is invalid,please be sure your license is valide.','Error Message',MB_OK or MB_ICONWARNING);
        if not g_RegForm.FirstFlag  then
          postMessage(g_RegForm.handle,WM_REGISTER_RESULT,0,0)
        else
        begin
          MessageBox(ideFrm.handle,'You input invalidate license,JDev will halt now.','Register Error',MB_OK or MB_ICONWARNING);
          halt;
        end;
      end;
    end;

    postMessage(g_RegForm.handle,WM_REGISTER_RESULT,1,0);
    postMessage(ideFrm.handle,WM_REGISTER_LICENSE,REGISTERVERSION,0);

    lic.produceID[0]:=Char(length(tempStr));
    for i:=1 to Length(tempStr) do
      lic.produceID[i]:=tempStr[i];

    tempstr:=  ideFrm.CipherManager.DecodeString(Copy(lic.produceID,2,ord(lic.produceID[0])));
    tempStr := ideFrm.CipherManager.EncodeString('{06C23B14-9099-4207-882A-AF59BBB700B2}');
    lic.guidMys1[0]:=Char(length(tempStr));
    for i:=1 to Length(tempStr) do
      lic.guidMys1[i]:=tempStr[i];

    tempStr := ideFrm.CipherManager.EncodeString('2020-12-12');
    lic.firstDate[0]:=Char(length(tempStr));
    for i:=1 to Length(tempStr) do
      lic.firstDate[i]:=tempStr[i];

    tempStr := ideFrm.CipherManager.EncodeString('{FE7AF7C4-4607-4742-85F4-BB0D47968EE4}');
    lic.guidMys2[0]:=Char(length(tempStr));
    for i:=1 to Length(tempStr) do
      lic.guidMys2[i]:=tempStr[i];

    tempStr := ideFrm.CipherManager.EncodeString(license);
    lic.license[0]:=Char(length(tempStr));
    for i:=1 to Length(tempStr) do
      lic.license[i]:=tempStr[i];

    fs:=TFileStream.Create( g_exeFilePath + LICENSE_FILE , fmCreate );
    //fs:=TFileStream.Create( LICENSE_FILE , fmCreate );
    fs.WriteBuffer(lic,sizeof(lic));
    fs.Free;
    //write register key
    SaveReg(1,produceID,'{06C23B14-9099-4207-882A-AF59BBB700B2}',
              '2020-12-12' , '{FE7AF7C4-4607-4742-85F4-BB0D47968EE4}',license);
    SaveReg(2,produceID,'{06C23B14-9099-4207-882A-AF59BBB700B2}',
              '2020-12-12' , '{FE7AF7C4-4607-4742-85F4-BB0D47968EE4}',license);
    SaveReg(3,produceID,'{06C23B14-9099-4207-882A-AF59BBB700B2}',
              '2020-12-12' , '{FE7AF7C4-4607-4742-85F4-BB0D47968EE4}',license);
  end;
end.
