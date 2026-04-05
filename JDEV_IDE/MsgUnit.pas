unit MsgUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ComCtrls,ExtCtrls,uCommandData,uEditAppIntfs,synedit,
  Menus, SynEditExt, ImgList, ActnList;


const
   RESULTPAGE = 1;
   BUILDPAGE  = 2;
   FINDPAGE   = 3;
type
  TMsgFrm = class(TForm)
    PageControl: TPageControl;
    resultTS: TTabSheet;
    findTS: TTabSheet;
    findResultListBox: TListBox;
    msgPopupMenu: TPopupMenu;
    clearRecordMI: TMenuItem;
    buildTS: TTabSheet;
    operatorMemo: TSynEditExt;
    errorImageList: TImageList;
    ConsoleInputGroupBox: TGroupBox;
    ConsoleInputMemo: TMemo;
    Splitter1: TSplitter;
    GroupBox2: TGroupBox;
    ConsoleOutputMemo: TMemo;
    ActionList1: TActionList;
    actCopy: TAction;
    C1: TMenuItem;
    actClearAll: TAction;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormShow(Sender: TObject);
    procedure FormHide(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure findResultListBoxDblClick(Sender: TObject);
    procedure operatorMemoDblClick(Sender: TObject);
    procedure ConsoleInputMemoKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure actClearAllExecute(Sender: TObject);
    procedure actCopyExecute(Sender: TObject);
    procedure actCopyUpdate(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    procedure WMNCLButtonDblClk(var M:TWMNCLButtonDblClk);message WM_NCLBUTTONDBLCLK;
  public
    procedure addFindResult(s:String;data:TFindTextData);
    procedure ClearFindItems;
    procedure ClearOperatorItems;
    procedure setActivePage(index:Integer);
  end;

implementation
uses
  ideUnit;
{$R *.dfm}
procedure TMsgFrm.WMNCLButtonDblClk(var M:TWMNCLButtonDblClk);
begin
  //inherited ;
  //单击标题栏时，将消息对话框放入MsgPanel
  ManualDock(ideFrm.MsgPanel, nil, alClient);
end;

procedure TMsgFrm.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  //将视图中的‘消息窗口’checked设置为false

  if (HostDockSite is TPanel) then
    IDEFrm.ShowDockPanel(HostDockSite as TPanel, False, nil);

  Action := caHide;
end;

procedure TMsgFrm.FormShow(Sender: TObject);
begin
  ideFrm.msgMenuItem.Checked:=true;
  ideFrm.FindResultMenuItem.Checked:=true;
  pagecontrol.ActivePageIndex:=0;
end;

procedure TMsgFrm.FormHide(Sender: TObject);
begin
  ideFrm.msgMenuItem.Checked:=false;
  ideFrm.FindResultMenuItem.Checked:=false;
end;
procedure TMsgFrm.addFindResult(s:String;data:TFindTextData);
begin
  findResultListBox.AddItem(s,data);
end;
procedure TMsgFrm.FormDestroy(Sender: TObject);
begin
  ClearFindItems;
  ClearOperatorItems;
end;

procedure TMsgFrm.ClearFindItems;
var
  i:Integer;
begin
  for i:=0 to findResultListBox.Items.Count-1 do
  begin
    if TFindTextData(findResultListBox.Items.Objects[0])<>nil then
     TFindTextData(findResultListBox.Items.Objects[0]).free;
    findResultListBox.Items.Delete(0);
  end;
end;

procedure TMsgFrm.ClearOperatorItems;
var
  i:Integer;
begin
  if operatorMemo.Breakpoints.Count > 0 then
  for i:=operatorMemo.Breakpoints.Count-1 downto 0  do
    operatorMemo.RemoveBreakPoint(StrToInt(operatorMemo.Breakpoints[i]));
  for i:=0 to operatorMemo.lines.Count-1 do
  begin
    if operatorMemo.lines.Objects[0] <> nil then
    begin
     TCompileErrorData(operatorMemo.lines.Objects[0]).reference:= TCompileErrorData(operatorMemo.lines.Objects[0]).reference - 1;
     if TCompileErrorData(operatorMemo.lines.Objects[0]).reference <= 0 then
       TCompileErrorData(operatorMemo.lines.Objects[0]).free;
    end;
    operatorMemo.lines.Delete(0);
  end;
end;

procedure TMsgFrm.findResultListBoxDblClick(Sender: TObject);
var
  edit: TSynEdit;
  data:TFindTextData;
begin
  if findResultListBox.SelCount = 0 then
    exit;

  data := TFindTextData(findResultListBox.Items.Objects[findResultListBox.ItemIndex]);
  //检测文件是否已经打开
  if data = nil then
    exit;

  ideFrm.DoOpenFile(data.FileName);
  edit := GI_EditorFactory.Editor[ideFrm.filePageControl.activePageIndex].GetSynEditor;

    if ( ( data.BlockBegin.Y > edit.TopLine + edit.LinesInWindow )
        or (data.BlockBegin.Y < edit.TopLine) ) then
       edit.TopLine:=data.BlockBegin.Y;

  edit.BlockBegin:=data.BlockBegin;
  edit.BlockEnd:=data.BlockEnd;
end;

procedure TMsgFrm.setActivePage(index:Integer);
begin
  if index = RESULTPAGE then
  begin
    PageControl.ActivePage:=resultTS;
    operatorMemo.CaretY:=operatorMemo.Lines.Count;
  end
  else if index = FINDPAGE then
    PageControl.ActivePage:=findTS
  else if index = BUILDPAGE then
    PageControl.ActivePage:=buildTS;

end;

procedure TMsgFrm.operatorMemoDblClick(Sender: TObject);
var
  data:TCompileErrorData;
  edit: TSynEdit;
begin
  if(operatorMemo.Lines.Count >= operatorMemo.CaretY ) then
  begin
    if TCompileErrorData(operatorMemo.lines.Objects[operatorMemo.CaretY-1])<>nil then
    begin
      data := TCompileErrorData(operatorMemo.lines.Objects[operatorMemo.CaretY-1]);
      //检测文件是否已经打开
      if data = nil then
        exit;

      ideFrm.DoOpenFile(data.FileName);
      edit := GI_EditorFactory.Editor[ideFrm.filePageControl.activePageIndex].GetSynEditor;

        if ( ( data.line > edit.TopLine + edit.LinesInWindow )
            or (data.line < edit.TopLine) ) then
           edit.TopLine:=data.line;

      edit.BlockBegin:=Point(1,data.line);
      edit.BlockEnd:=Point(Length(edit.lines[data.line-1])+1,data.line);;
    end;
  end;
end;

procedure TMsgFrm.ConsoleInputMemoKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
var
  BytesWrite:DWord;
  sendMsg,tempStr:String;
  Buffer: array[0..255] of char;
  i:Integer;
begin
  if ( key = VK_RETURN ) then
  begin
          tempStr :=ConsoleInputMemo.Lines[ConsoleInputMemo.Lines.Count-1];
          sendMsg  := tempStr+#13#10;
          ConsoleInputMemo.SetFocus;
          if (G_CurAPP <> nil) and (G_CurAPP.isRuning ) then
          begin
            fillchar(buffer,sizeof(buffer),0);
            for i:=0 to length(sendMsg)-1 do
            begin
                  buffer[i] := sendMsg[i+1];
            end;
            BytesWrite := 0;

            WriteFile(G_CurAPP.WritePipeInput,buffer[0],length(sendMsg), BytesWrite, nil);
          end;
  end;
  if key = VK_UP then
      key := 0;
  if ( key = VK_BACK ) and (ConsoleInputMemo.CaretPos.X = 0) then
      key := 0;

end;

procedure TMsgFrm.actClearAllExecute(Sender: TObject);
begin
  if pagecontrol.ActivePage = findTS then
    ClearFindItems
  else if pagecontrol.ActivePage = buildTS then
  begin
    ConsoleOutputMemo.Clear;
  end
  else if pagecontrol.ActivePage = resultTS then
  begin
    ClearOperatorItems;
  end;
end;

procedure TMsgFrm.actCopyExecute(Sender: TObject);
begin
  if pagecontrol.ActivePage = resultTS then
  begin
    operatorMemo.CopyToClipboard;
  end;
end;

procedure TMsgFrm.actCopyUpdate(Sender: TObject);
begin
  actCopy.Enabled:= (pagecontrol.ActivePage = resultTS)
                    and ( operatorMemo.SelAvail );

end;

procedure TMsgFrm.FormCreate(Sender: TObject);
begin
  //
end;

end.
