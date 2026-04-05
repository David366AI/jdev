unit EnvUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, ComCtrls, SynEditHighlighter,StrUtils,
  SynHighlighterJava, Buttons, SynEdit,iniFiles,uEditAppIntfs,dmCommands,
  DirDialog,DataInfo,SynEditAutoComplete,setJavaHomeUnit;

type
  TEnvSetupForm = class(TForm)
    setupPageControl: TPageControl;
    TabSheet1: TTabSheet;
    TabSheet2: TTabSheet;
    TabSheet3: TTabSheet;
    TabSheet4: TTabSheet;
    TabSheet5: TTabSheet;
    Label1: TLabel;
    tabLengthEdit: TEdit;
    UpDown1: TUpDown;
    GroupBox1: TGroupBox;
    Label2: TLabel;
    commentsColor: TColorBox;
    documentsColor: TColorBox;
    Label3: TLabel;
    identifiersColor: TColorBox;
    Label4: TLabel;
    invalidsColor: TColorBox;
    Label5: TLabel;
    keyWordsColor: TColorBox;
    Label6: TLabel;
    numbersColor: TColorBox;
    Label7: TLabel;
    Label8: TLabel;
    stringsColor: TColorBox;
    OkBtn: TBitBtn;
    cancelBtn: TBitBtn;
    editordefaultBtn: TButton;
    GroupBox4: TGroupBox;
    addDirBtn: TButton;
    addJarBtn: TButton;
    cpListBox: TListBox;
    deleteBtn: TButton;
    clearBtn: TButton;
    GroupBox2: TGroupBox;
    addDirBtn2: TButton;
    srcListBox: TListBox;
    deleteBtn2: TButton;
    clearBtn2: TButton;
    GroupBox3: TGroupBox;
    CommonToolBarCB: TCheckBox;
    ExtToolBarCB: TCheckBox;
    WorkspaceCB: TCheckBox;
    ClassBrowserCB: TCheckBox;
    MessageCB: TCheckBox;
    DebugCB: TCheckBox;
    Label10: TLabel;
    tabPosDropList: TComboBox;
    Label9: TLabel;
    Label11: TLabel;
    undoNumberEdit: TEdit;
    UpDown2: TUpDown;
    autoIndentCB: TCheckBox;
    Label12: TLabel;
    gutterNumberCB: TCheckBox;
    leadingZerosCB: TCheckBox;
    digitalCountEdit: TEdit;
    digCountUpDown: TUpDown;
    Label13: TLabel;
    AutoCompList: TListBox;
    CompletionNameEdit: TEdit;
    AutoCodeMemo: TMemo;
    Label14: TLabel;
    addAutoCompBtn: TButton;
    modifyAutoCompBtn: TButton;
    deleteAutoCompBtn: TButton;
    Label15: TLabel;
    Label16: TLabel;
    Label17: TLabel;
    Label18: TLabel;
    Button8: TButton;
    Label19: TLabel;
    Button10: TButton;
    Label20: TLabel;
    Button12: TButton;
    profileDefaultBtn: TButton;
    colorDlg: TColorDialog;
    sampleSynedit: TSynEdit;
    SynJava: TSynJavaSyn;
    gutterColor: TPanel;
    statusBarCB: TCheckBox;
    jdkpathEdit: TEdit;
    servletpathEdit: TEdit;
    jspPathEdit: TEdit;
    jarzipDlg: TOpenDialog;
    cpDirDialog: TDirDialog;
    srcDirDialog: TDirDialog;
    Label21: TLabel;
    Label22: TLabel;
    commentsEdit: TEdit;
    editorBGColor: TPanel;
    Panel1: TPanel;
    Label23: TLabel;
    javaHomeLbl: TLabel;
    setJavaHomeBtn: TButton;
    procedure gutterColorClick(Sender: TObject);
    procedure profileDefaultBtnClick(Sender: TObject);
    procedure editordefaultBtnClick(Sender: TObject);
    procedure editorBGColorChange(Sender: TObject);
    procedure commentsColorChange(Sender: TObject);
    procedure documentsColorChange(Sender: TObject);
    procedure tabLengthEditChange(Sender: TObject);
    procedure identifiersColorChange(Sender: TObject);
    procedure invalidsColorChange(Sender: TObject);
    procedure keyWordsColorChange(Sender: TObject);
    procedure numbersColorChange(Sender: TObject);
    procedure stringsColorChange(Sender: TObject);
    procedure gutterNumberCBClick(Sender: TObject);
    procedure leadingZerosCBClick(Sender: TObject);
    procedure digitalCountEditClick(Sender: TObject);
    procedure digCountUpDownClick(Sender: TObject; Button: TUDBtnType);
    procedure OkBtnClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure Button8Click(Sender: TObject);
    procedure Button10Click(Sender: TObject);
    procedure Button12Click(Sender: TObject);
    procedure addJarBtnClick(Sender: TObject);
    procedure addDirBtnClick(Sender: TObject);
    procedure deleteBtnClick(Sender: TObject);
    procedure clearBtnClick(Sender: TObject);
    procedure addDirBtn2Click(Sender: TObject);
    procedure deleteBtn2Click(Sender: TObject);
    procedure clearBtn2Click(Sender: TObject);
    procedure AutoCompListClick(Sender: TObject);
    procedure addAutoCompBtnClick(Sender: TObject);
    procedure modifyAutoCompBtnClick(Sender: TObject);
    procedure deleteAutoCompBtnClick(Sender: TObject);
    procedure autoIndentCBClick(Sender: TObject);
    procedure editorBGColorClick(Sender: TObject);
    procedure setJavaHomeBtnClick(Sender: TObject);
    procedure TabSheet2Show(Sender: TObject);
    //procedure generateServletBtnClick(Sender: TObject);
  private
    { Private declarations }
    cpChanged:Boolean;
  public
    { Public declarations }
    procedure setSyneditProperty(synedit:TSynEdit);
  end;

var
  EnvSetupForm: TEnvSetupForm;

implementation
uses
  ideUnit,uCommandData;
{$R *.dfm}

procedure TEnvSetupForm.gutterColorClick(Sender: TObject);
begin
  colorDlg.Color:=gutterColor.Color;
  if  colorDlg.Execute then
  begin
    gutterColor.Color:=colorDlg.Color;
    sampleSynedit.Gutter.Color:=colorDlg.Color;
  end;
end;

procedure TEnvSetupForm.profileDefaultBtnClick(Sender: TObject);
begin
  commonToolBarCB.Checked :=false;
  extToolBarCB.Checked:=false;
  workSpaceCB.Checked:=false;
  classbrowserCB.Checked:=false;
  messageCB.Checked:=false;
  debugCB.Checked:=false;
  statusBarCB.Checked:=false;

  tabPosDropList.ItemIndex:=0;
  editorBGColor.color:=$00D6F3F2;         sampleSynedit.Color:=editorBGColor.color;
  gutterColor.color:=$00B1D3E4;         sampleSynedit.Gutter.Color:=$00B1D3E4;
  gutterNumberCB.Checked:=true;         sampleSynedit.Gutter.ShowLineNumbers:=true;
  leadingZerosCB.Checked:=false;        sampleSynedit.Gutter.LeadingZeros:=false;
  digitalCountEdit.Text:='6';           sampleSynedit.Gutter.DigitCount:=StrToInt(digitalCountEdit.text);

end;

procedure TEnvSetupForm.editordefaultBtnClick(Sender: TObject);
begin
  tabLengthEdit.Text:='4';
  commentsColor.Selected:=clGreen;      SynJava.CommentAttri.Foreground:=commentsColor.Selected;
  documentsColor.Selected:=clGreen;     SynJava.DocumentAttri.Foreground:=documentsColor.Selected;
  identifiersColor.Selected:=clBlack;   SynJava.IdentifierAttri.Foreground:=identifiersColor.Selected;
  invalidsColor.Selected:=clRed;        SynJava.InvalidAttri.Foreground:=invalidsColor.Selected;
  keywordsColor.Selected:=clBlue;       SynJava.KeyAttri.Foreground:=keywordsColor.Selected;
  numbersColor.Selected:=clFuchsia;     SynJava.NumberAttri.Foreground:=numbersColor.Selected;
  stringsColor.Selected:=clRed;         SynJava.StringAttri.Foreground:=stringsColor.Selected;
  undoNumberEdit.Text:='1024';          sampleSynEdit.MaxUndo:=1024;
  autoIndentCB.Checked:=true;           sampleSynEdit.SetOptionFlag(eoAutoIndent, true);
end;

procedure TEnvSetupForm.editorBGColorChange(Sender: TObject);
begin
  sampleSynedit.Color := editorBGColor.color;
end;

procedure TEnvSetupForm.commentsColorChange(Sender: TObject);
begin
  SynJava.CommentAttribute.Foreground:=commentsColor.Selected;
end;

procedure TEnvSetupForm.documentsColorChange(Sender: TObject);
begin
  SynJava.DocumentAttri.Foreground:=documentsColor.Selected;
end;

procedure TEnvSetupForm.tabLengthEditChange(Sender: TObject);
begin
  //sampleSynEdit.TabWidth:=StrToInt(tabLengthEdit.text);
end;

procedure TEnvSetupForm.identifiersColorChange(Sender: TObject);
begin
  SynJava.IdentifierAttri.Foreground:=identifiersColor.Selected;
end;

procedure TEnvSetupForm.invalidsColorChange(Sender: TObject);
begin
  SynJava.IdentifierAttri.Foreground:=identifiersColor.Selected;
end;

procedure TEnvSetupForm.keyWordsColorChange(Sender: TObject);
begin
  SynJava.KeyAttri.Foreground:=keywordsColor.Selected;
end;

procedure TEnvSetupForm.numbersColorChange(Sender: TObject);
begin
  SynJava.NumberAttri.Foreground:=numbersColor.Selected;
end;

procedure TEnvSetupForm.stringsColorChange(Sender: TObject);
begin
  SynJava.StringAttri.Foreground:=stringsColor.Selected;
end;

procedure TEnvSetupForm.gutterNumberCBClick(Sender: TObject);
begin
  if not gutterNumberCB.Checked then
  begin
    leadingZerosCB.Enabled:=false;
    digitalCountEdit.Enabled:=false;
    digCountUpDown.Enabled:=false;
    sampleSynEdit.Gutter.ShowLineNumbers:=false;
  end else
  begin
    leadingZerosCB.Enabled:=true;
    digitalCountEdit.Enabled:=true;
    digCountUpDown.Enabled:=true;
    sampleSynEdit.Gutter.ShowLineNumbers:=true;
    sampleSynEdit.Gutter.DigitCount:=StrToInt(digitalCountEdit.text);
  end;
end;

procedure TEnvSetupForm.leadingZerosCBClick(Sender: TObject);
begin
  sampleSynEdit.Gutter.LeadingZeros:=leadingZerosCB.Checked;
end;

procedure TEnvSetupForm.digitalCountEditClick(Sender: TObject);
begin
  sampleSynEdit.Gutter.DigitCount:=StrToInt(digitalCountEdit.text);
end;

procedure TEnvSetupForm.digCountUpDownClick(Sender: TObject;
  Button: TUDBtnType);
begin
  sampleSynEdit.Gutter.DigitCount:=StrToInt(digitalCountEdit.text);
end;

procedure TEnvSetupForm.OkBtnClick(Sender: TObject);
var
  iniFile:TIniFile;
  i:Integer;
  app:TAppInfo;
begin
  commandDataDM.SynAutoComplete.SaveAutoCompleteList(g_exeFilePath + AUTOCOMPLETEFILE);
  //if not FileExists(g_exeFilePath  +  CONFIGFILE) then
  //  exit;
  iniFile:=TiniFile.Create(g_exeFilePath  +  CONFIGFILE);
  try
    //Profile_CFG
    iniFile.WriteInteger('Profile_CFG','fileTabPos',tabPosDropList.ItemIndex);
    if tabPosDropList.ItemIndex = 0 then ideFrm.filePageControl.TabPosition:=tpTop
    else if tabPosDropList.ItemIndex = 1 then ideFrm.filePageControl.TabPosition:=tpBottom
    else if tabPosDropList.ItemIndex = 2 then ideFrm.filePageControl.TabPosition:=tpLeft
    else if tabPosDropList.ItemIndex = 3 then ideFrm.filePageControl.TabPosition:=tpRight;

    if commonToolBarCB.Checked then
    begin
      iniFile.WriteInteger('Profile_CFG','commonToolBar',1);
      ideFrm.commonToolBar.Visible:=false;
    end
    else
    begin
      iniFile.WriteInteger('Profile_CFG','commonToolBar',0);
      ideFrm.commonToolBar.Visible:=true;
    end;
    if extToolBarCB.Checked then
    begin
      iniFile.WriteInteger('Profile_CFG','extToolBar',1);
      ideFrm.commonExtToolBar.Visible:=false;
    end
    else
    begin
      iniFile.WriteInteger('Profile_CFG','extToolBar',0);
      ideFrm.commonExtToolBar.Visible:=true;
    end;
    if workSpaceCB.Checked then
    begin
      iniFile.WriteInteger('Profile_CFG','workSpace',1);
      workSpaceFrm.Visible:=false;
    end
    else
    begin
      iniFile.WriteInteger('Profile_CFG','workSpace',0);
      workSpaceFrm.Visible:=true;
    end;
    if classbrowserCB.Checked then
    begin
      iniFile.WriteInteger('Profile_CFG','classbrowser',1);
      classBrowserFrm.Visible:=false;
    end
    else
    begin
      iniFile.WriteInteger('Profile_CFG','classbrowser',0);
      classBrowserFrm.Visible:=true;
    end;
    if messageCB.Checked then
    begin
      iniFile.WriteInteger('Profile_CFG','messageWin',1);
      msgFrm.Visible:=false;
    end
    else
    begin
      iniFile.WriteInteger('Profile_CFG','messageWin',0);
      msgFrm.Visible:=true;
    end;
    {if debugCB.Checked then
    begin
      iniFile.WriteInteger('Profile_CFG','debugWin',1);
    end
    else
    begin
      iniFile.WriteInteger('Profile_CFG','debugWin',0);
    end;}
    if statusBarCB.Checked then
    begin
      iniFile.WriteInteger('Profile_CFG','statusBar',1);
      ideFrm.StatusBar.Visible:=false;
    end
    else
    begin
      iniFile.WriteInteger('Profile_CFG','statusBar',0);
      ideFrm.StatusBar.Visible:=true;
    end;

    //Editor_CFG
    iniFile.WriteString('Editor_CFG','editor_bg_color',IntToStr(editorBGColor.color));
    iniFile.WriteString('Editor_CFG','gutter_color',IntToStr(gutterColor.Color));
    if gutterNumberCB.Checked then
      iniFile.WriteInteger('Editor_CFG','gutter_number',1)
    else
      iniFile.WriteInteger('Editor_CFG','gutter_number',0);
    if leadingZerosCB.Checked then
      iniFile.WriteInteger('Editor_CFG','gutter_leadingzeros',1)
    else
      iniFile.WriteInteger('Editor_CFG','gutter_leadingzeros',0);

    iniFile.WriteString('Editor_CFG','gutter_digitalcount',digitalCountEdit.text);
    iniFile.WriteString('Editor_CFG','tab_length',tabLengthEdit.Text);
    iniFile.WriteString('Editor_CFG','commentsColor',IntToStr(commentsColor.Selected));
    iniFile.WriteString('Editor_CFG','documentsColor',IntToStr(documentsColor.Selected));
    iniFile.WriteString('Editor_CFG','identifiersColor',IntToStr(identifiersColor.Selected));
    iniFile.WriteString('Editor_CFG','invalidsColor',IntToStr(invalidsColor.Selected));
    iniFile.WriteString('Editor_CFG','keywordsColor',IntToStr(keywordsColor.Selected));
    iniFile.WriteString('Editor_CFG','numbersColor',IntToStr(numbersColor.Selected));
    iniFile.WriteString('Editor_CFG','stringsColor',IntToStr(stringsColor.Selected));
    iniFile.WriteString('Editor_CFG','undoNumber',undoNumberEdit.Text);

    if autoIndentCB.Checked then
      iniFile.WriteInteger('Editor_CFG','autoIndent',1)
    else
      iniFile.WriteInteger('Editor_CFG','autoIndent',0);


    g_jdkdocpath:=jdkpathEdit.text;
    g_servletdocpath:=servletpathEdit.text;
    g_jspdocpath:=jsppathEdit.text;
    iniFile.WriteString('JDK_CFG','jdk_srczip_path',jdkpathEdit.text);
    iniFile.WriteString('Help_CFG','servlet_doc_path',servletpathEdit.text);
    iniFile.WriteString('Help_CFG','jsp_doc_path',jsppathEdit.text);
    g_IDE_ClassPath:=AnsiReplaceStr(cpListBox.Items.Text,#13#10,';');
    g_IDE_SourcePath:=AnsiReplaceStr(srcListBox.Items.Text,#13#10,';');

    for i:=0 to appList.Count-1 do
    begin
      app:=TAppInfo(appList.Objects[i]);
      app.sourceFilePathList.Assign(srcListBox.Items);
    end;
    //如果classpath IDE 改变
    if cpChanged then
    begin
      iniFile.WriteString('JDK_CFG','class_path',g_IDE_ClassPath);
      StartupAnalysisProcess;
    end;
    
    iniFile.WriteString('JDK_CFG','source_path',g_IDE_SourcePath);
    //设置java关键字色彩
    CommandsDataModule.SynJavaSyn1.CommentAttri.Foreground:=commentsColor.Selected;
    CommandsDataModule.SynJavaSyn1.DocumentAttri.Foreground:=documentsColor.Selected;
    CommandsDataModule.SynJavaSyn1.IdentifierAttri.Foreground:=identifiersColor.Selected;
    CommandsDataModule.SynJavaSyn1.InvalidAttri.Foreground:=invalidsColor.Selected;
    CommandsDataModule.SynJavaSyn1.KeyAttri.Foreground:=keywordsColor.Selected;
    CommandsDataModule.SynJavaSyn1.NumberAttri.Foreground:=numbersColor.Selected;
    CommandsDataModule.SynJavaSyn1.StringAttri.Foreground:=stringsColor.Selected;

    for i:=0 to ideFrm.filePageControl.PageCount-1 do
    begin
      setSyneditProperty(GI_EditorFactory.Editor[i].GetSynEditor);
    end;
  finally
    iniFile.Free;
  end;
end;

procedure TEnvSetupForm.FormShow(Sender: TObject);
var
  iniFile:TIniFile;
  s:String;
  j:Integer;
begin
  self.cpChanged:=false;
  
  commandDataDM.SynAutoComplete.ParseCompletionList;
  autoCompList.Clear;
  for j:=0 to commandDataDM.SynAutoComplete.Completions.count-1 do
  begin
    autoCompList.Items.Add(commandDataDM.SynAutoComplete.Completions[j]);
  end;

  //if not FileExists(g_exeFilePath  +  CONFIGFILE) then
  //  exit;
  iniFile:=TiniFile.Create(g_exeFilePath  +  CONFIGFILE);
  jdkpathEdit.text:= g_jdk_zipsrc_path;
  servletpathEdit.text:=g_servletdocpath;
  jsppathEdit.text:=g_jspdocpath;

  cpListBox.Items.Clear;

  s := g_IDE_ClassPath;
  while true do
  begin
    j:=Pos(';',s);
    if j<=0 then
    begin
      if trim(s) <> '' then
        cpListBox.Items.Add(s);
      break;
    end;
    if trim(Copy(s,1,j-1)) <> ''  then
      cpListBox.Items.Add(Copy(s,1,j-1));
    s:=Copy(s,j+1,length(s));
  end;

  srcListBox.Items.Clear;
  s := g_IDE_SourcePath;
  while true do
  begin
    j:=Pos(';',s);
    if j<=0 then
    begin
      if trim(s) <> '' then
        srcListBox.Items.Add(s);
      break;
    end;
    if trim(Copy(s,1,j-1)) <> ''  then
      srcListBox.Items.Add(Copy(s,1,j-1));
    s:=Copy(s,j+1,length(s));
  end;
  try
    //Profile_CFG
    tabPosDropList.ItemIndex:=iniFile.ReadInteger('Profile_CFG','fileTabPos',0);
    if  iniFile.ReadInteger('Profile_CFG','commonToolBar',0) = 0 then
      commonToolBarCB.Checked:=false
    else
      commonToolBarCB.Checked:=true;
    if  iniFile.ReadInteger('Profile_CFG','extToolBar',0) = 0 then
      extToolBarCB.Checked:=false
    else
      extToolBarCB.Checked:=true;
    if  iniFile.ReadInteger('Profile_CFG','workSpace',0) = 0 then
      workSpaceCB.Checked:=false
    else
      workSpaceCB.Checked:=true;
    if  iniFile.ReadInteger('Profile_CFG','classbrowser',0) = 0 then
      classbrowserCB.Checked:=false
    else
      classbrowserCB.Checked:=true;

    if  iniFile.ReadInteger('Profile_CFG','messageWin',0) = 0 then
      messageCB.Checked:=false
    else
      messageCB.Checked:=true;

    if  iniFile.ReadInteger('Profile_CFG','debugWin',0) = 0 then
      debugCB.Checked:=false
    else
      debugCB.Checked:=true;

    if  iniFile.ReadInteger('Profile_CFG','statusBar',0) = 0 then
      statusBarCB.Checked:=false
    else
      statusBarCB.Checked:=true;

    //Editor_CFG
    editorBGColor.color:=iniFile.ReadInteger('Editor_CFG','editor_bg_color',$00D6F3F2);
    gutterColor.Color:=iniFile.ReadInteger('Editor_CFG','gutter_color',$00B1D3E4);
    if  iniFile.ReadInteger('Editor_CFG','gutter_number',1) = 0 then
      gutterNumberCB.Checked:=false
    else
      gutterNumberCB.Checked:=true;
    if  iniFile.ReadInteger('Editor_CFG','gutter_leadingzeros',0) = 0 then
      leadingZerosCB.Checked:=false
    else
      leadingZerosCB.Checked:=true;

    digitalCountEdit.text:=iniFile.ReadString('Editor_CFG','gutter_digitalcount','6');
    tabLengthEdit.Text:=iniFile.ReadString('Editor_CFG','tab_length','4');
    commentsColor.Selected:=iniFile.ReadInteger('Editor_CFG','commentsColor',clGreen);
    documentsColor.Selected:=iniFile.ReadInteger('Editor_CFG','documentsColor',clGreen);
    identifiersColor.Selected:=iniFile.ReadInteger('Editor_CFG','identifiersColor',clBlack);
    invalidsColor.Selected:=iniFile.ReadInteger('Editor_CFG','invalidsColor',clRed);
    keywordsColor.Selected:=iniFile.ReadInteger('Editor_CFG','keywordsColor',clBlue);
    numbersColor.Selected:=iniFile.ReadInteger('Editor_CFG','numbersColor',clFuchsia);
    stringsColor.Selected:=iniFile.ReadInteger('Editor_CFG','stringsColor',clRed);
    undoNumberEdit.text:=iniFile.ReadString('Editor_CFG','undoNumber','1024');
    if  iniFile.ReadInteger('Editor_CFG','autoIndent',1) = 0 then
      autoIndentCB.Checked:=false
    else
      autoIndentCB.Checked:=true;

  finally
    iniFile.Free;
  end;

  sampleSynEdit.TabWidth:=StrToInt(tablengthEdit.text);
  sampleSynEdit.MaxUndo:=StrToInt(undoNumberEdit.Text);
  sampleSynEdit.SetOptionFlag(eoAutoIndent, autoIndentCB.Checked);
  sampleSynedit.Color:=editorBGColor.color;
  sampleSynedit.Gutter.Color:=gutterColor.Color;
  sampleSynedit.Gutter.ShowLineNumbers:=gutterNumberCB.Checked;
  sampleSynedit.Gutter.LeadingZeros:=leadingZerosCB.Checked;
  sampleSynedit.Gutter.DigitCount:=StrToInt(digitalCountEdit.text);

  SynJava.CommentAttri.Foreground:=commentsColor.Selected;
  SynJava.DocumentAttri.Foreground:=documentsColor.Selected;
  SynJava.IdentifierAttri.Foreground:=identifiersColor.Selected;
  SynJava.InvalidAttri.Foreground:=invalidsColor.Selected;
  SynJava.KeyAttri.Foreground:=keywordsColor.Selected;
  SynJava.NumberAttri.Foreground:=numbersColor.Selected;
  SynJava.StringAttri.Foreground:=stringsColor.Selected;

end;

procedure TEnvSetupForm.setSyneditProperty(synedit:TSynEdit);
begin
  synedit.TabWidth:=StrToInt(tablengthEdit.text);
  synedit.MaxUndo:=StrToInt(undoNumberEdit.Text);
  synedit.SetOptionFlag(eoAutoIndent, autoIndentCB.Checked);
  synedit.Color:=editorBGColor.color;
  synedit.Gutter.Color:=gutterColor.Color;
  synedit.Gutter.ShowLineNumbers:=gutterNumberCB.Checked;
  synedit.Gutter.LeadingZeros:=leadingZerosCB.Checked;
  synedit.Gutter.DigitCount:=StrToInt(digitalCountEdit.text);
end;

procedure TEnvSetupForm.Button8Click(Sender: TObject);
var
  jdkDirDialog:TDirDialog;
begin
  jdkDirDialog:=TDirDialog.Create(self);
  jdkDirDialog.Directory:=jdkpathEdit.Text;
  if jdkDirDialog.Execute then
    jdkpathEdit.Text:=jdkDirDialog.Directory;
  jdkDirDialog.Free;
end;

procedure TEnvSetupForm.Button10Click(Sender: TObject);
var
  servletDirDialog:TDirDialog;
begin
  servletDirDialog:=TDirDialog.Create(self);
  servletDirDialog.Directory:=servletpathEdit.Text;
  if servletDirDialog.Execute then
    servletpathEdit.Text:=servletDirDialog.Directory;
  servletDirDialog.Free;
end;

procedure TEnvSetupForm.Button12Click(Sender: TObject);
var
  jspDirDialog:TDirDialog;
begin
  jspDirDialog:=TDirDialog.Create(self);
  jspDirDialog.Directory:=jsppathEdit.Text;
  if jspDirDialog.Execute then
    jsppathEdit.Text:=jspDirDialog.Directory;
  jspDirDialog.Free;
end;

procedure TEnvSetupForm.addJarBtnClick(Sender: TObject);
var
  i:Integer;
begin
 if  jarzipDlg.Execute then
 begin
   for i:=0 to cpListBox.items.Count-1 do
   begin
     if cpListBox.items[i] = jarzipDlg.FileName then
       exit;
   end;
   cpListBox.items.add(jarzipDlg.FileName);
   cpChanged:=true;
 end;
end;

procedure TEnvSetupForm.addDirBtnClick(Sender: TObject);
var
  i:Integer;
begin
 if  cpDirDialog.Execute then
 begin
   for i:=0 to cpListBox.items.Count-1 do
   begin
     if cpListBox.items[i] = cpDirDialog.Directory then
       exit;
   end;
   cpListBox.items.add(cpDirDialog.Directory);
   cpChanged:=true;
 end;
end;


procedure TEnvSetupForm.deleteBtnClick(Sender: TObject);
begin
  cpListBox.items.Delete(cpListBox.ItemIndex);
  cpChanged:=true;
end;

procedure TEnvSetupForm.clearBtnClick(Sender: TObject);
begin
  cpListBox.Items.Clear;
  cpChanged:=true;
end;

procedure TEnvSetupForm.addDirBtn2Click(Sender: TObject);
var
  i:Integer;
begin
 if  srcDirDialog.Execute then
 begin
   for i:=0 to srcListBox.items.Count-1 do
   begin
     if srcListBox.items[i] = srcDirDialog.Directory then
       exit;
   end;
   srcListBox.items.add(srcDirDialog.Directory);
 end;
end;
procedure TEnvSetupForm.deleteBtn2Click(Sender: TObject);
begin
  srcListBox.items.Delete(srcListBox.ItemIndex);
end;

procedure TEnvSetupForm.clearBtn2Click(Sender: TObject);
begin
  srcListBox.Items.Clear;
end;



procedure TEnvSetupForm.AutoCompListClick(Sender: TObject);
begin
  if autoComplist.ItemIndex >= 0 then
  begin
    CompletionNameEdit.Text:=commandDataDM.SynAutoComplete.Completions[autoComplist.ItemIndex];
    CommentsEdit.Text:=commandDataDM.SynAutoComplete.CompletionComments[autoComplist.ItemIndex];
    AutoCodeMemo.Text:=commandDataDM.SynAutoComplete.CompletionValues[autoComplist.ItemIndex];
  end;
end;

procedure TEnvSetupForm.modifyAutoCompBtnClick(Sender: TObject);
var
  i:Integer;
  found:Boolean;
begin
  if trim(CompletionNameEdit.Text) = '' then
  begin
    ShowError(self.Handle,getErrorMsg('PleaseInputCompletionCode'),getErrorMsg('ErrorDlgCaption'),MB_OK or MB_ICONWARNING);
    exit;
  end;

  if trim(autocodeMemo.Text) = '' then
  begin
    ShowError(self.Handle,getErrorMsg('PleaseInputCompletionName'),getErrorMsg('ErrorDlgCaption'),MB_OK or MB_ICONWARNING);
    exit;
  end;

  found:=false;
  for i:=0 to AutoCompList.Items.Count-1 do
  begin
    if AutoCompList.Items[i] = CompletionNameEdit.Text then
    begin
      commandDataDM.SynAutoComplete.Completions[i]:=CompletionNameEdit.Text;
      commandDataDM.SynAutoComplete.CompletionComments[i]:=commentsEdit.Text;
      commandDataDM.SynAutoComplete.CompletionValues[i]:=autocodeMemo.Text;
      found:=true;
      exit;
    end;
  end;
  if not found then
  begin
    if ShowError(self.Handle,Format(getErrorMsg('AutoCompleteNameNotFound'),[CompletionNameEdit.Text]),getErrorMsg('ConfirmCaption'),MB_OKCANCEL or MB_ICONWARNING) = IDOK then
      addAutoCompBtnClick(self);
  end;
end;

procedure TEnvSetupForm.addAutoCompBtnClick(Sender: TObject);
var
  i:Integer;
begin
  if trim(CompletionNameEdit.Text) = '' then
  begin
    ShowError(self.Handle,getErrorMsg('PleaseInputCompletionCode'),getErrorMsg('ErrorDlgCaption'),MB_OK or MB_ICONWARNING);
    exit;
  end;

  if trim(autocodeMemo.Text) = '' then
  begin
    ShowError(self.Handle,getErrorMsg('PleaseInputCompletionName'),getErrorMsg('ErrorDlgCaption'),MB_OK or MB_ICONWARNING);
    exit;
  end;

  for i:=0 to AutoCompList.Items.Count-1 do
  begin
    if AutoCompList.Items[i] = CompletionNameEdit.Text then
    begin
      ShowError(self.Handle,Format(getErrorMsg('CompletionNameHasExist'),[CompletionNameEdit.Text]),getErrorMsg('ErrorDlgCaption'),MB_OK or MB_ICONWARNING);
      exit;
    end;
  end;
  commandDataDM.SynAutoComplete.Completions.Add(CompletionNameEdit.Text);
  commandDataDM.SynAutoComplete.CompletionComments.add(commentsEdit.Text);
  commandDataDM.SynAutoComplete.CompletionValues.Add(autocodeMemo.Text);
  autoCompList.Items.Add(CompletionNameEdit.Text);
end;

procedure TEnvSetupForm.deleteAutoCompBtnClick(Sender: TObject);
begin
  if autoCompList.ItemIndex >=0 then
  begin
    commandDataDM.SynAutoComplete.Completions.delete(autoCompList.ItemIndex);
    autoCompList.DeleteSelected;
    CompletionNameEdit.Text:='';
    commentsEdit.Text:='';
    autoCodeMemo.Text:='';
  end;
end;

procedure TEnvSetupForm.autoIndentCBClick(Sender: TObject);
begin
  sampleSynedit.SetOptionFlag(eoAutoIndent,autoIndentCB.checked);
end;

procedure TEnvSetupForm.editorBGColorClick(Sender: TObject);
begin
  colorDlg.Color:=EditorBGColor.Color;
  if  colorDlg.Execute then
  begin
    EditorBGColor.Color:=colorDlg.Color;
    sampleSynedit.Color:=colorDlg.Color;
  end;

end;



procedure TEnvSetupForm.setJavaHomeBtnClick(Sender: TObject);
var
  setFrm:TsetJavaHomeForm;
  version:string;
begin
  setFrm:=TsetJavaHomeForm.create(nil,1);
  setFrm.DirDialog.Directory:=javaHomeLbl.Caption;
  if setFrm.showModal = mrOK then
  begin
    if Not Fileexists(getRealPath(Trim(setFrm.pathNameEdit.Text))+'bin\java.exe') then
    begin
      MessageBox(handle,PChar(getErrorMsg('JavaHomeWrong')),
                   PChar(getErrorMsg('ErrorDlgCaption')),MB_OK or MB_ICONWARNING);
      exit;
    end;
     SetJavaHomeEnv(getRealPath(Trim(setFrm.pathNameEdit.Text)));
     javaHomeLbl.Caption:=setFrm.pathNameEdit.Text;
     MessageBox(self.Handle,'You need start JDev to make the change invalidate.','Confirm Infomation',MB_ICONWARNING or MB_OK);
  end;
  setFrm.free;

end;

procedure TEnvSetupForm.TabSheet2Show(Sender: TObject);
begin
  javaHomeLbl.Caption:=ReadCfgString('JDK_CFG','JAVA_HOME');

end;

end.
