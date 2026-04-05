unit ReadRunOutUnit;

interface

uses
  Classes,windows,sysutils,strutils,StdCtrls,uCommandData,aboutUnit;
const
  {设置ReadBuffer的大小}
  ReadBuffer = 2400;
type
  TReadRunOutput = class(TThread)
  private
    { Private declarations }
  protected
    procedure refresh;
    procedure Execute; override;
  public
    fMemo:TMemo;

    Buf: string;
    app:TRunAppInfo;
    Buffer: array[0..ReadBuffer-1] of char;
    lastwith0D0A:Boolean;
    constructor Create(m:TMemo;app:TRunAppInfo);
  end;

implementation

constructor TReadRunOutput.Create(m:TMemo;app:TRunAppInfo);
begin
  fMemo := m;
  self.app:=app;
  inherited Create(false);
end;

procedure TReadRunOutput.Execute;
var
  BytesRead: DWord;
  exitcode:DWord;
  first:Boolean;
  i:Integer;
begin
  { Place thread code here }
   first:=true;
   lastwith0D0A:=true;
   while( not Terminated) do
   begin
        Sleep(10);
        if first then
        begin
          GetExitCodeProcess(app.ProcessInfo.hProcess, exitcode);
          if ( exitcode <> STILL_ACTIVE ) then //如果当前进程已经结束
          begin
            fMemo.Lines.Add('-----------------------------------------------------------------------------');
            first:=false;
            app.status:=0;
          end;
        end;
        BytesRead := 0;
        PeekNamedPipe(app.ReadPipeOutput,@buffer[0],ReadBuffer,@BytesRead,nil,nil);
        if (BytesRead = 0)   then
        begin
         continue;
        end;
        Buf := '';
        FillChar(Buffer,ReadBuffer,0);
        {读取console程序的输出}
        repeat
          BytesRead := 0;
          ReadFile(app.ReadPipeOutput, buffer, ReadBuffer, BytesRead, nil);
          for i:=0 to BytesRead-1 do
            if Buffer[i] = #0 then
              buf := buf + ' '
            else
              buf := buf + Buffer[i];

        until (BytesRead < ReadBuffer);
        Synchronize(refresh);
   end;

end;

procedure TReadRunOutput.refresh;
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
       if fMemo.Lines.Count > 0 then
         fMemo.Lines[fMemo.Lines.Count-1] := fMemo.Lines[fMemo.Lines.Count-1] + Copy(Line, 1, pos(#10, Line) - 1)
       else
         fMemo.Lines.add(Copy(Line, 1, pos(#10, Line) - 1));
       first:=false;
     end else
     begin
       fMemo.Lines.add(Copy(Line, 1, pos(#10, Line) - 1));
     end;
     line := Copy(Line, pos(#10, Line) + 1,length(line));
   end;
   if length(line) > 0 then
     fMemo.Lines.add(line);
   if ( length(buf) > 0 ) and ( buf[length(buf)] = #10 ) then
     lastwith0D0A := true
   else
     lastwith0D0A := false;

   fMemo.CaretPos:=Point(0,fMemo.Lines.count-1);

end;

end.
