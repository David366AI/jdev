unit jdkHelpUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, OleCtrls, SHDocVw, StdCtrls, ComCtrls,XMLDoc,XMLIntf,uCommandData,
  StrUtils, ExtCtrls, SynEditHighlighter, SynHighlighterJava, SynEdit,
  SynEditExt, RzTabs, RzButton;
type
  TjdkHelpFrm = class(TForm)
    Panel1: TPanel;
    SynJavaSyn: TSynJavaSyn;
    RzPageControl1: TRzPageControl;
    TabSheet3: TRzTabSheet;
    Splitter1: TSplitter;
    JDKWebBrowser: TWebBrowser;
    methodHelpTV: TTreeView;
    TabSheet4: TRzTabSheet;
    SynEditor: TSynEditExt;
    hideBtn: TRzButton;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure methodhelpTVDblClick(Sender: TObject);
    procedure hideBtnClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    lastAnalysisClass:String;
    lastAnalysisPack:String;
  public
    curClassName:String;
    procedure refreshMethod(s:WideString;pack:String);
  end;

implementation
uses
  ideUnit;
{$R *.dfm}

procedure TjdkHelpFrm.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  ideFrm.showJDKHelpBtn.ImageIndex := SHOWJDKHELP;
  action:=caHide;
end;

procedure TjdkHelpFrm.refreshMethod(s:WideString;pack:String);
var
  xmlDocument:TXMLDocument;
  tempComponent:TComponent;
  stream:TStringStream;
  childNode:IXMLNode;
  node1:TTreeNode;
  i,j:Integer;
begin
     lastAnalysisClass:=Copy(pack,LastDelimiter('.',pack)+1,length(pack));
     lastAnalysisPack:=Copy(pack,1,LastDelimiter('.',pack)-1);

     methodHelpTV.Items.BeginUpdate ;
     methodHelpTV.Items.Clear;
     stream :=  TStringStream.Create(s);
     tempComponent:=TComponent.Create(nil);
     xmlDocument:=TXMLDocument.Create(tempComponent);
     xmlDocument.LoadFromStream(stream);

     for i:=2 to XMLDocument.DocumentElement.ChildNodes.Count-1 do
     begin
       if  XMLDocument.DocumentElement.ChildNodes[i].Attributes['name'] = 'cons' then
       begin
         childNode:= XMLDocument.DocumentElement.ChildNodes[i];
         node1:=methodHelpTV.Items.Add(nil,getErrorMsg('Constructors'));
         for j:=0 to childNode.ChildNodes.Count-1 do
         begin
           methodHelpTV.Items.AddChild(node1,childNode.ChildNodes[j].Text);
         end;
         node1.Expand(false);
         node1.AlphaSort;
       end else if  XMLDocument.DocumentElement.ChildNodes[i].Attributes['name'] = 'fs' then
       begin
         childNode:= XMLDocument.DocumentElement.ChildNodes[i];
         node1:=methodHelpTV.Items.Add(nil,getErrorMsg('Attributes'));
         for j:=0 to childNode.ChildNodes.Count-1 do
         begin
           methodHelpTV.Items.AddChild(node1,childNode.ChildNodes[j].Text);
         end;
         node1.Expand(false);
         node1.AlphaSort;
       end else if  XMLDocument.DocumentElement.ChildNodes[i].Attributes['name'] = 'ms' then
       begin
         childNode:= XMLDocument.DocumentElement.ChildNodes[i];
         node1:=methodHelpTV.Items.Add(nil,getErrorMsg('Methods'));
         for j:=0 to childNode.ChildNodes.Count-1 do
         begin
           methodHelpTV.Items.AddChild(node1,childNode.ChildNodes[j].Text);
         end;
         node1.Expand(false);
         node1.AlphaSort;
       end;
     end;

     methodHelpTV.Items.EndUpdate;
     stream.Destroy;
     xmlDocument.Destroy;
     tempComponent.Destroy;
end;

{$O-}
procedure TjdkHelpFrm.methodhelpTVDblClick(Sender: TObject);
var
  tempStr:String;
  sl:TStringList;
  i:Integer;
begin
  if methodhelpTV.Selected = nil then
    exit;
  if not FileExists(g_jdk_zipsrc_path) then
  begin
    setHtml(self.JDKWebBrowser,'Can''t find jdk source file.');
    exit;
  end;


  if methodhelpTV.Selected.Level =  1 then
  begin
    setHtml(self.JDKWebBrowser,'Please waiting for a moment...');
    sl:=TStringList.Create;
    try
      tempStr:=methodhelpTV.Selected.Text;
      while true do
      begin
        i:=Pos(#9,tempStr);
        if i <=0 then
        begin
          sl.Add(tempStr);
          break;
        end else
        begin
          sl.Add(Copy(tempStr,1,i-1));
          tempStr := Copy(tempStr,i+1,length(tempStr));
        end;
      end;

      g_jdkHelpRegr := sl[0];
      g_jdkHelpRegr := AnsiReplaceStr(g_jdkHelpRegr,' ','');
      if methodhelpTV.Selected.Parent.Text = getErrorMsg('Constructors') then //构造函数
      begin
        g_jdkHelpRegr := AnsiReplaceStr(g_jdkHelpRegr,'$','\$');
        g_jdkHelpRegr := AnsiReplaceStr(g_jdkHelpRegr,'-','\-');
        g_jdkHelpRegr := AnsiReplaceStr(g_jdkHelpRegr,'(','\s*\(');
        g_jdkHelpRegr := AnsiReplaceStr(g_jdkHelpRegr,'[],','\s*[a-zA-Z\-_\$]+\[\]&\s*');
        g_jdkHelpRegr := AnsiReplaceStr(g_jdkHelpRegr,',','\s*[a-zA-Z\-_\$]+&\s*');
        if Pos('[])',g_jdkHelpRegr) > 0 then
          g_jdkHelpRegr := AnsiReplaceStr(g_jdkHelpRegr,'[])','\s*[a-zA-Z\-_\$]+\[\]\)')
        else
          g_jdkHelpRegr := AnsiReplaceStr(g_jdkHelpRegr,')','(\s*[a-zA-Z\-_\$]+)*\)');
        g_jdkHelpRegr := AnsiReplaceStr(g_jdkHelpRegr,'&',',');
      end else if methodhelpTV.Selected.Parent.Text = getErrorMsg('Attributes') then //属性
      begin
        g_jdkHelpRegr := AnsiReplaceStr(g_jdkHelpRegr,'$','\$');
        g_jdkHelpRegr := AnsiReplaceStr(g_jdkHelpRegr,'-','\-');
      end else if methodhelpTV.Selected.Parent.Text = getErrorMsg('Methods') then //方法
      begin
        g_jdkHelpRegr := AnsiReplaceStr(g_jdkHelpRegr,'$','\$');
        g_jdkHelpRegr := AnsiReplaceStr(g_jdkHelpRegr,'-','\-');
        g_jdkHelpRegr := AnsiReplaceStr(g_jdkHelpRegr,'(','\s*\(');
        g_jdkHelpRegr := AnsiReplaceStr(g_jdkHelpRegr,'[],','\s*[a-zA-Z\-_\$]+\[\]&\s*');
        g_jdkHelpRegr := AnsiReplaceStr(g_jdkHelpRegr,',','\s*[a-zA-Z\-_\$]+&\s*');
        if Pos('[])',g_jdkHelpRegr) > 0 then
          g_jdkHelpRegr := AnsiReplaceStr(g_jdkHelpRegr,'[])','\s*[a-zA-Z\-_\$]+\[\]\)')
        else
          g_jdkHelpRegr := AnsiReplaceStr(g_jdkHelpRegr,')','(\s*[a-zA-Z\-_\$]+)*\)');
        g_jdkHelpRegr := AnsiReplaceStr(g_jdkHelpRegr,'&',',');
      end;

      if sl.Count = 3 then
      begin
        sl[1] := AnsiReplaceStr(sl[1],'[','\[');
        sl[1] := AnsiReplaceStr(sl[1],']','\]');
      end;

      for i:=1 to sl.Count-1 do
      begin
        if i = sl.Count-1 then
        begin
          sl[i] := AnsiReplaceStr(sl[i],'public ','(public)? ');
          sl[i] := AnsiReplaceStr(sl[i],' native','( native)?');
          sl[i] := AnsiReplaceStr(sl[i],' abstract','( abstract)?');
        end;
        g_jdkHelpRegr :=  sl[i] + '\s+' + g_jdkHelpRegr;
      end;

      //sendstr := curClassName + '|' + sendstr + '|' + proto ;
      if ( ideFrm.G_PMList <> nil ) and (ideFrm.G_PMList.AnalysisSocket<>nil ) then
        ideFrm.G_PMList.AnalysisSocket.SendText('$$'+  curClassName + #13#10);
    finally
      sl.Free;
    end;
  end;
end;

procedure TjdkHelpFrm.hideBtnClick(Sender: TObject);
begin
  close;
end;

procedure TjdkHelpFrm.FormShow(Sender: TObject);
begin
  jdkHelpFrm.hideBtn.Left:=jdkHelpFrm.RzPageControl1.Width-jdkHelpFrm.hideBtn.Width;
  ideFrm.showJDKHelpBtn.ImageIndex:=HIDEJDKHELP;
end;

end.
