unit ReadOutput;

interface

uses
  Classes,windows,sysutils,StdCtrls,DebugUnit,DataInfo;
const
  {设置ReadBuffer的大小}
  ReadBuffer = 2400;
type
  GetOutput = class(TThread)
  private
    { Private declarations }
  protected
    procedure refresh;
    procedure Execute; override;
  public
    mApp:TAppInfo;
    Buffer: array[0..ReadBuffer-1] of char;
    Buf: string;
    lastwith0D0A:Boolean;
    constructor Create(app:TAppInfo);
  end;

implementation
uses
 common;
constructor GetOutput.Create(app:TAppInfo);
begin
  inherited Create(false);
  mApp := app;
  lastwith0D0A:=false;
end;

procedure GetOutput.Execute;
var
  BytesRead: DWord;
  exitcode:DWord;
  i:Integer;
begin
   //first:=true;
   lastwith0D0A:=true;
   while( not Terminated) do
   begin
        Sleep(10);
        GetExitCodeProcess(mApp.ProcessInfo.hProcess, exitcode);
        if ( exitcode <> STILL_ACTIVE ) then //如果当前进程已经结束
        begin
          break;
        end;
        BytesRead := 0;
        PeekNamedPipe(mApp.ReadPipeOutput,@buffer[0],ReadBuffer,@BytesRead,nil,nil);
        if (BytesRead = 0)   then
        begin
         continue;
        end;
        Buf := '';
        {读取console程序的输出}
        repeat
          BytesRead := 0;
          ReadFile(mApp.ReadPipeOutput, Buffer, ReadBuffer, BytesRead, nil);
          for i:=0 to BytesRead-1 do
            if Buffer[i] = #0 then
              buf := buf + ' '
            else
              buf := buf + Buffer[i];

        until (BytesRead < ReadBuffer);
        Synchronize(refresh);
       {按照换行符进行分割，并在Memo中显示出来
        while pos(#10, Buf) > 0 do
        begin
          Synchronize(refresh);
          Delete(Buf, 1, pos(#10, Buf));
        end;       }
   end;
end;

procedure GetOutput.refresh;
{begin
  mapp.consoleOutStrings.add(Copy(Buf, 1, pos(#10, Buf) - 1));
  if mapp = getCurApp then
  debugForm.ConsoleOutputMemo.Lines.Add(Copy(Buf, 1, pos(#10, Buf) - 1));

  //debugForm.debugMsg.lines.add(Copy(Buf, 1, pos(#10, Buf) - 1));
  mapp.consoleOutStrings.text:=mapp.consoleOutStrings.text+buf;
  if mapp = getCurApp then
  debugForm.ConsoleOutputMemo.text:=debugForm.ConsoleOutputMemo.text+buf;
  debugForm.debugMsg.text:=debugForm.debugMsg.text+buf;
}
var
  position:Integer;
  line:String;
  first:Boolean;
begin
   {按照换行符进行分割，并在Memo中显示出来}
   line:=buf;
   first:=true;
   while true do
   begin
     position:=Pos(#10,line);
     if position <= 0 then
       break;
          
     if first and not lastwith0D0A then
     begin
       first := false;
       if mapp.consoleOutStrings.Count > 0 then
       begin
         mapp.consoleOutStrings[mapp.consoleOutStrings.Count-1] := mapp.consoleOutStrings[mapp.consoleOutStrings.Count-1] + Copy(Line, 1, pos(#10, Line) - 1);
         if mapp = getCurApp then
         begin
           if debugForm.ConsoleOutputMemo.lines.Count > 0 then
             debugForm.ConsoleOutputMemo.Lines[debugForm.ConsoleOutputMemo.lines.Count-1] := debugForm.ConsoleOutputMemo.Lines[debugForm.ConsoleOutputMemo.lines.Count-1] + Copy(Line, 1, pos(#10, Line) - 1)
           else
             debugForm.ConsoleOutputMemo.lines.add(Copy(Line, 1, pos(#10, Line) - 1));
         end
       end
       else
       begin
         mapp.consoleOutStrings.Add( Copy(Line, 1, pos(#10, Line) - 1)  );
         if mapp = getCurApp then
            debugForm.ConsoleOutputMemo.lines.add( Copy(Line, 1, pos(#10, Line) - 1));
       end;
     end else
     begin
       mapp.consoleOutStrings.add( Copy(Line, 1, pos(#10, Line) - 1) );
       if mapp = getCurApp then
          debugForm.ConsoleOutputMemo.Lines.Add(Copy(Line, 1, pos(#10, Line) - 1));
     end;
     line := Copy(Line, pos(#10, Line) + 1,length(line));
   end;

   if length(line) > 0 then
   begin
     if lastwith0D0A then
     begin
       mapp.consoleOutStrings.add( line );
       if mapp = getCurApp then
          debugForm.ConsoleOutputMemo.Lines.Add(line);
     end
     else
     begin
       if mapp.consoleOutStrings.Count > 0 then
       begin
         mapp.consoleOutStrings[mapp.consoleOutStrings.Count-1] := mapp.consoleOutStrings[mapp.consoleOutStrings.Count-1] + line;
         if mapp = getCurApp then
         begin
           if debugForm.ConsoleOutputMemo.lines.Count > 0 then
             debugForm.ConsoleOutputMemo.Lines[debugForm.ConsoleOutputMemo.lines.Count-1] := debugForm.ConsoleOutputMemo.Lines[debugForm.ConsoleOutputMemo.lines.Count-1] + line
           else
             debugForm.ConsoleOutputMemo.lines.add(line);
         end
       end
       else
       begin
         mapp.consoleOutStrings.Add( line  );
         if mapp = getCurApp then
            debugForm.ConsoleOutputMemo.lines.add( line);
       end;
     end;
   end;
   if ( length(buf) > 0 ) and ( buf[length(buf)] = #10 ) then
     lastwith0D0A := true
   else
     lastwith0D0A := false;

   debugForm.ConsoleOutputMemo.CaretPos:=Point(0,debugForm.ConsoleOutputMemo.Lines.count-1);
end;

end.
