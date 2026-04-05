unit filePanel;

interface

uses
  Windows, Messages, SysUtils, Classes, Controls, Menus,ComCtrls,ExtCtrls,SynEdit,ShDocVw,
  SynEditExt, SynEditHighlighter, SynHighlighterJava,SynHighlighterHtml,Graphics,uCommandData;

type
  TCommonFilePanel = class(TPanel)
  public
    synEdit:TSynEditExt;
    fileSyn:TSynCustomHighlighter;
    fileType:Integer;
    fileName:String;
    subFile:TSubFile;
    item:TMenuItem;
    Constructor Create(aowner:TComponent;subFile:TSubFile);
    procedure ClickEvent(Sender: TObject);
  end;

  TJavaPanel = class(TCommonFilePanel)
  public
    fileSyn:TSynJavaSyn;
    Constructor Create(aowner:TComponent;subFile:TSubFile);
    destructor destroy;override;
  end;

  TJspPanel = class(TCommonFilePanel)
  public
    fileSyn:TSynHtmlSyn;
    Constructor Create(aowner:TComponent;subFile:TSubFile);
    destructor destroy;override;
  end;

  TUnknownPanel = class(TCommonFilePanel)
  public
    fileSyn:TSynJavaSyn;
    Constructor Create(aowner:TComponent;subFile:TSubFile);
    destructor destroy;override;
  end;

  THtmlPanel = class(TCommonFilePanel)
  public
    fileSyn:TSynHtmlSyn;
    webBrowser:TWebBrowser;
    page:TPageControl;
    tab1:TTabSheet;
    tab2:TTabSheet;
    Constructor Create(aowner:TComponent;subFile:TSubFile);
    destructor destroy;override;
    procedure showEvent(Sender: TObject);
  end;

  TFilePanel = class
  public
    fileName:String;
    parentWin:TTabSheet;
    javaPanel:TJavaPanel;
    htmlPanel:THtmlPanel;
    jspPanel:TJspPanel;
    unknownTypePanel:TUnknownPanel;
    commonPanel:TCommonFilePanel;
    Constructor Create(aowner:TComponent;subFile:TSubFile);
    destructor destroy;override;
  end;

//procedure Register;

implementation
uses
  common,ideUnit;
{procedure Register;
begin
  RegisterComponents('Standard', [TJavaPanel]);
end;
}

Constructor TCommonFilePanel.Create(aowner:TComponent;subFile:TSubFile);
var
  i:Integer;
begin
  inherited create(aowner);
  self.subFile:=subFile;
  fileType:=subFile.fileType;
  fileName:=getFileFromSubFile(subFile);

  synEdit:=TSynEditExt.Create(self);
  //自动缩进
  synEdit.SetOptionFlag(eoAutoIndent, true);
  //tab 缩进3个字的宽度
  synEdit.WantTabs := true;
  synEdit.TabWidth := 3;
  
  synEdit.Color:=$00D6F3F2;
  synEdit.Gutter.Color:=$00B1D3E4;
  synEdit.Gutter.digitCount:=6;
  synEdit.Gutter.LeadingZeros:=false;
  synEdit.Gutter.ShowLineNumbers:=true;
  synEdit.packageName:=fileName;
  if FileExists(fileName) then
    synEdit.Lines.LoadFromFile(fileName)
  else
    synEdit.Lines.Text:='';

  self.Align:=alClient;
  self.Parent:=TWinControl(aowner);
  self.Show;

  for i:=0 to ideFrm.windowsMI.Count-1 do
    ideFrm.windowsMI.Items[i].Checked:=false;
  item:=TMenuItem.Create(self);
  item.Caption:=subFile.name;
  item.Checked:=true;

  ideFrm.windowsMI.Add(item);

  item.OnClick:=ClickEvent;
end;

procedure TCommonFilePanel.ClickEvent(Sender: TObject);
var
  i:Integer;
begin
  for i:=0 to ideFrm.windowsMI.Count-1 do
    ideFrm.windowsMI.Items[i].Checked:=false;
  item.Checked:=true;

  for i:=0 to filePanelList.Count-1 do
  begin
    if fileName = TFilePanel(filePanelList.Items[i]).fileName then
    begin
      ideFrm.FilePageControl.ActivePageIndex:=i;
    end;
  end;

end;


Constructor TJavaPanel.Create(aowner:TComponent;subFile:TSubFile);
begin
  inherited create(aowner,subfile);
  fileSyn:=TSynJavaSyn.Create(nil);
  fileSyn.CommentAttri.Foreground:=clGreen;
  fileSyn.DocumentAttri.Foreground:=clGreen;
  fileSyn.IdentifierAttri.Foreground:=clNone;
  fileSyn.KeyAttri.Foreground:=clBlue;
  fileSyn.NumberAttri.Foreground:=clPurple;
  fileSyn.StringAttri.Foreground:=clRed;
  fileSyn.SymbolAttri.Foreground:=clNone;

  synEdit.Highlighter:=fileSyn;

  synEdit.Parent:=self;
  synEdit.Align:=alClient;
  synEdit.Show;
end;

Destructor TJavaPanel.destroy;
begin
  if synEdit<>nil then
  begin
    if synEdit.Highlighter <> nil then
      synEdit.Highlighter.free;
    synEdit.free;
  end;

  inherited Destroy;
end;

Constructor THtmlPanel.Create(aowner:TComponent;subFile:TSubFile);
begin
  inherited create(aowner,subfile);
  fileSyn:=TSynHtmlSyn.Create(nil);
  synEdit.Highlighter:=fileSyn;

  page:=TPageControl.Create(nil);
  page.Parent:=self;
  tab1:=TTabSheet.Create(self);
  tab1.PageControl:= page;
  tab1.Caption:='preview';
  tab2:=TTabSheet.Create(self);
  tab2.PageControl:= page;
  tab2.Caption:='source';
  page.Align:=alClient;
  page.Visible:=true;
  page.TabPosition:=tpBottom;
  page.Show;
  tab1.Visible:=true;
  tab2.Visible:=true;

  page.ActivePage:=tab2;

  synEdit.Parent:=tab2;
  synEdit.Align:=alClient;
  synEdit.Show;

  webBrowser:=TWebBrowser.Create(tab1);
  TControl(webBrowser).Parent:=tab1;
  WebBrowser.Navigate('about:blank');
  SetHtml(webbrowser,synEdit.Lines.Text);
  webBrowser.Align:=alClient;
  webBrowser.Visible:=true;

  tab1.OnShow:=self.showEvent;
end;

Destructor THtmlPanel.destroy;
begin
  tab2.OnShow:=nil;
  if synEdit<>nil then
  begin
    if synEdit.Highlighter <> nil then
      synEdit.Highlighter.free;
    synEdit.free;
  end;

  if webBrowser <>nil then
    webBrowser.Free;
  if tab1 <> nil then
    tab1.Free;
  if tab2 <> nil then
    tab2.Free;
  if page <> nil then
    page.Free;

  inherited Destroy;

end;

procedure THtmlPanel.showEvent(Sender: TObject);
begin
  SetHtml(webbrowser,synEdit.Lines.Text);
end;

Constructor TJspPanel.Create(aowner:TComponent;subFile:TSubFile);
begin
  inherited create(aowner,subfile);
  fileSyn:=TSynHtmlSyn.Create(nil);
  synEdit.Highlighter:=fileSyn;
  synEdit.Parent:=self;
  synEdit.Align:=alClient;
  synEdit.Show;
end;

Destructor TJspPanel.destroy;
begin
  if synEdit<>nil then
  begin
    if synEdit.Highlighter <> nil then
      synEdit.Highlighter.free;
    synEdit.free;
  end;

  inherited Destroy;
end;


Constructor TUnknownPanel.Create(aowner:TComponent;subFile:TSubFile);
begin
  inherited create(aowner,subfile);

  synEdit.Parent:=self;
  synEdit.Align:=alClient;
  synEdit.Show;
end;

Destructor TUnknownPanel.destroy;
begin
  if synEdit<>nil then
  begin
    if synEdit.Highlighter <> nil then
      synEdit.Highlighter.free;
    synEdit.free;
  end;

  inherited Destroy;
end;


Constructor TFilePanel.Create(aowner:TComponent;subFile:TSubFile);
begin
  parentWin:=TTabSheet(aowner);
  fileName:=getFileFromSubFile(subFile);
  case subFile.fileType of
    0,1,2,4: begin javaPanel:=TJavaPanel.Create(aowner,subFile);commonPanel:=javaPanel;end;
    3:       begin jspPanel:=TJspPanel.Create(aowner,subFile);commonPanel:=jspPanel; end;
    5,6:     begin htmlPanel:=THtmlPanel.Create(aowner,subFile);commonPanel:=htmlPanel;end;
  else
    begin unknownTypePanel:=TUnknownPanel.Create(aowner,subFile);commonPanel:=unknownTypePanel;end;
  end;

end;

destructor TFilePanel.destroy;
begin
  commonPanel.item.Free;
  if  javaPanel <> nil then
    javaPanel.destroy;
  if  htmlPanel <> nil then
    htmlPanel.destroy;
  if  jspPanel <> nil then
    jspPanel.destroy;
  if  unknownTypePanel <> nil then
    unknownTypePanel.destroy;
  parentWin.Free;
  inherited destroy;
end;


end.

