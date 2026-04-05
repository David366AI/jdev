unit WaitAppEndThread;

interface

uses
  Classes,windows,sysutils,ComCtrls,debugUnit,DataInfo,ConstVar;

type
  WaitAppEnd = class(TThread)
  private
    { Private declarations }
    mApp:TAppInfo;
  protected
    procedure refresh;  
    procedure Execute; override;
  public
    //procedure RefreshProfile;
    constructor Create(app:TAppInfo);
  end;

implementation
uses
  common;

constructor WaitAppEnd.Create(app:TAppInfo);
begin
    mApp:=app;
    inherited Create(false);    
end;

procedure WaitAppEnd.Execute;
begin
  { Place thread code here }
  while not (Terminated) do
  begin
     WaitForSingleObject(mApp.ProcessInfo.hProcess, INFINITE);
     try
       if mapp <> nil then
         SendCommand(REQUEST_EXIT,mApp.appID,'exit');
     finally
       ;
     end;
     Synchronize(refresh);
     break;
  end;
end;

procedure WaitAppEnd.refresh;   
begin
  g_CanNotChThreadNode := true;
  debugForm.ThreadListTV.Items.Delete(mApp.appTreeNode);
  debugForm.sourceEdit.Text:='';
  debugForm.sourceEdit.packageName:='';
  debugForm.sourceEdit.ClearBreakPoint;
  debugForm.LocalsListTV.Items.Clear;
  debugForm.varTypeLabel.Caption:='';
  debugForm.varValueMemo.Text:='';
  debugForm.sourceGroupBox.Caption:='source code: ';
  addErrorMsg('Application ' + mapp.name+' terminate.');
  DelApp(mApp);
end;

end.
