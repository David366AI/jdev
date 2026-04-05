unit frmEditor;

{$I SynEdit.inc}

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, ComCtrls,Forms, Menus,
  uEditAppIntfs,  SynEditExt, SynEdit,uCommandData,ShDocVw,SynEditHighlighter,
  ImgList, StdCtrls, Buttons,DTestPrintPreview,Math,classBrowser,dataInfo,
  SynEditKeyCmds,inifiles,StrUtils;
const
  TEMPHEMLFILE  = '090E98RQ0WE8R0QWE8R0QW98ERQWERQ08WER9Q8WER.html';

type
  TEditorKind = (ekBorderless, ekInTabsheet, ekMDIChild);

  TEditor = class;

  TEditorForm = class(TForm)
    pmnuEditor: TPopupMenu;
    lmiEditCut: TMenuItem;
    lmiEditCopy: TMenuItem;
    lmiEditPaste: TMenuItem;
    lmiEditDelete: TMenuItem;
    N1: TMenuItem;
    lmiEditSelectAll: TMenuItem;
    lmiEditUndo: TMenuItem;
    lmiEditRedo: TMenuItem;
    N2: TMenuItem;
    SynEditor: TSynEditExt;
    N3: TMenuItem;
    compileMI: TMenuItem;
    runMI: TMenuItem;
    debugRunMI: TMenuItem;
    BookMarkImageList: TImageList;
    closeBtn: TBitBtn;
    bpImageList: TImageList;
    runAppletMI: TMenuItem;
    debugAppletMI: TMenuItem;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure FormDestroy(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure FormDeactivate(Sender: TObject);
    procedure SynEditorChange(Sender: TObject);
    procedure SynEditorEnter(Sender: TObject);
    procedure SynEditorExit(Sender: TObject);
    procedure SynEditorReplaceText(Sender: TObject; const ASearch,
      AReplace: String; Line, Column: Integer;
      var Action: TSynReplaceAction);
    procedure SynEditorStatusChange(Sender: TObject;
      Changes: TSynStatusChanges);
    procedure FormCreate(Sender: TObject);
    procedure SynEditorKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure SynEditorKeyPress(Sender: TObject; var Key: Char);
    procedure SynEditorKeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure SynEditorDblClick(Sender: TObject);
    procedure SynEditorClick(Sender: TObject);
    procedure pmnuEditorPopup(Sender: TObject);
    procedure runMIClick(Sender: TObject);
    procedure debugAppletMIClick(Sender: TObject);
    procedure SynEditorGutterClick(Sender: TObject; X, Y, Line: Integer;
      mark: TSynEditMark);
    procedure closeBtnClick(Sender: TObject);
  private
    fEditor: TEditor;
    fKind: TEditorKind;
  private
    webBrowser:TWebBrowser;
    page:TPageControl;
    tab1:TTabSheet;
    tab2:TTabSheet;
    fileType:Integer;
    fSearchFromCaret: boolean;
    mouseDownCaretXY:TPoint;
    function DoAskSaveChanges: boolean;
    procedure DoAssignInterfacePointer(AActive: boolean);
    function DoSave: boolean;
    function DoSaveFile: boolean;
    function DoSaveAs: boolean;
    procedure DoSearchReplaceText(AReplace: boolean; ABackwards: boolean);
    procedure DoUpdateCaption;
    procedure DoUpdateHighlighter;
    procedure ShowSearchReplaceDialog(AReplace: boolean);
  public
    constructor Create(owner:TComponent;filetype:Integer);
    procedure showEvent(Sender: TObject);
    procedure DoActivate;
  end;

  TEditor = class(TInterfacedObject, IEditor, IEditCommands, IFileCommands,
    ISearchCommands)
  private
    // IEditor implementation
    procedure Activate;
    function AskSaveChanges: boolean;
    procedure Close;
    procedure Save;
    function GetCaretPos: TPoint;
    function GetEditorState: string;
    function GetFileName: string;
    function GetPageIndex: Integer;
    procedure SetPageIndex(index:Integer);
    procedure SetFileName(afile: string);
    function GetFileTitle: string;
    function GetModified: boolean;
    procedure OpenFile(AFileName: string;packageName:String);
    procedure SetFileCmds;
    function GetSynEditor:TSynEditExt;
    // IEditCommands implementation
    function CanCopy: boolean;
    function CanCut: boolean;
    function IEditCommands.CanDelete = CanCut;
    function CanPaste: boolean;
    function CanRedo: boolean;
    function CanSelectAll: boolean;
    function CanUndo: boolean;
    procedure ExecCopy;
    procedure ExecCut;
    procedure ExecDelete;
    procedure ExecPaste;
    procedure ExecRedo;
    procedure ExecSelectAll;
    procedure ExecUndo;
    // IFileCommands implementation
    function CanClose: boolean;
    function CanPrint: boolean;
    function CanSave: boolean;
    function CanSaveAs: boolean;
    procedure IFileCommands.ExecClose = Close;
    procedure ExecPrint;
    procedure ExecSave;
    procedure ExecSaveAs;

    // ISearchCommands implementation
    function CanFind: boolean;
    function CanFindNext: boolean;
    function ISearchCommands.CanFindPrev = CanFindNext;
    function CanReplace: boolean;
    procedure ExecFind;
    procedure ExecFindNext;
    procedure ExecFindPrev;
    procedure ExecReplace;
  private
    fFileName: string;
    fPage:TPageControl;
    fFileType:Integer;
    fForm: TEditorForm;
    fHasSelection: boolean;
    fIsEmpty: boolean;
    fIsReadOnly: boolean;
    fModified: boolean;
    fUntitledNumber: integer;
    constructor Create(AForm: TEditorForm;Index:Integer);
    procedure DoSetFileName(AFileName: string);
  public
    menuItem:TMenuItem;
    procedure SetMenuItem(item:TMenuItem);
    function GetMenuItem:TMenuItem;
    destructor Destroy; override;
    function GetFileContent:String;
  end;

const
  WM_DELETETHIS  =  WM_USER + 42;
var
  gbSearchBackwards: boolean;
  gbSearchCaseSensitive: boolean;
  gbSearchFromCaret: boolean;
  gbSearchSelectionOnly: boolean;
  gbSearchTextAtCaret: boolean;
  gbSearchWholeWords: boolean;

  gsSearchText: string;
  gsSearchTextHistory: string;
  gsReplaceText: string;
  gsReplaceTextHistory: string;
resourcestring
  SInsert = 'Insert';
  SOverwrite = 'Overwrite';
  SReadOnly = 'Read Only';
  SEditorCaption = 'Editor';
implementation

{$R *.DFM}

uses
  dlgSearchText, dlgReplaceText, dlgConfirmReplace,dmCommands,ConstVar, ideUnit,  common;
{ TEditor }

constructor TEditor.Create(AForm: TEditorForm;Index:Integer);
var
  inifile:TInifile;
begin
  Assert(AForm <> nil);
  inherited Create;
  fForm := AForm;
  fPage := AForm.page;
  fFileType := index;
  fUntitledNumber := -1;
  iniFile:=TiniFile.Create(g_exeFilePath  +  CONFIGFILE);
  try
    fForm.SynEditor.TabWidth := iniFile.ReadInteger('Editor_CFG','tab_length',4);;
    fForm.SynEditor.Color:=iniFile.ReadInteger('Editor_CFG','editor_bg_color',$00D6F3F2);
    fForm.SynEditor.Gutter.Color:=iniFile.ReadInteger('Editor_CFG','gutter_color',$00B1D3E4);
    fForm.SynEditor.Gutter.digitCount:=iniFile.ReadInteger('Editor_CFG','gutter_digitalcount',6);
    fForm.SynEditor.Gutter.LeadingZeros:=getBoolByInt(iniFile.ReadInteger('Editor_CFG','gutter_leadingzeros',0));
    fForm.SynEditor.Gutter.ShowLineNumbers:=getBoolByInt(iniFile.ReadInteger('Editor_CFG','gutter_number',1));
    fForm.SynEditor.SetOptionFlag(eoAutoIndent,getBoolByInt(iniFile.ReadInteger('Editor_CFG','autoIndent',1)));
    fForm.SynEditor.MaxUndo:=iniFile.ReadInteger('Editor_CFG','undoNumber',1024);
  finally
    inifile.Free;
  end;
end;

function TEditor.GetPageIndex: Integer;
begin
  if fPage <> nil then
    result:=fPage.ActivePageIndex
  else
    result:=-1;
end;

procedure TEditor.SetPageIndex(index:Integer);
begin
  if fPage <> nil then
    fPage.ActivePageIndex:=index;
end;

function TEditor.GetFileContent:String;
begin
  if fForm <> nil then
    result:=fForm.SynEditor.Lines.Text;
end;

procedure TEditor.SetFileName(afile: string);
begin
  fFileName :=afile;
end;

function TEditor.GetSynEditor:TSynEditExt;
begin
  if fForm <> nil then
    result:=fForm.SynEditor
  else
    result:=nil;
end;

procedure TEditor.SetFileCmds;
begin
  GI_FileCmds := self;
end;

procedure TEditor.SetMenuItem(item:TMenuItem);
begin
  menuItem:=item;
end;

function TEditor.GetMenuItem:TMenuItem;
begin
  result:=menuItem;
end;

destructor TEditor.Destroy;
begin
  inherited;
end;
procedure TEditor.Activate;
begin
  if fForm <> nil then
    fForm.DoActivate;
end;

function TEditor.AskSaveChanges: boolean;
begin
  if fForm <> nil then
    Result := fForm.DoAskSaveChanges
  else
    Result := TRUE;
end;

function TEditor.CanClose: boolean;
begin
  Result := fForm <> nil;
end;

procedure TEditor.Close;
begin
  if (fFileName <> '') and ( CommandsDataModule <> nil) then
    CommandsDataModule.AddMRUEntry(fFileName);
  if fUntitledNumber <> -1 then
    CommandsDataModule.ReleaseUntitledNumber(fUntitledNumber);
  if fForm <> nil then
  begin
    fForm.Close;
  end;
end;

procedure TEditor.Save;
begin
  if fForm <> nil then begin
    if fFileName <> '' then
      fForm.DoSave
    else
      fForm.DoSaveAs
  end;
end;

procedure TEditor.DoSetFileName(AFileName: string);
begin
  if AFileName <> fFileName then begin
    fFileName := AFileName;
    if fUntitledNumber <> -1 then begin
      CommandsDataModule.ReleaseUntitledNumber(fUntitledNumber);
      fUntitledNumber := -1;
    end;
  end;
end;

function TEditor.GetCaretPos: TPoint;
begin
  if fForm <> nil then
    Result := fForm.SynEditor.CaretXY
  else
    Result := Point(-1, -1);
end;

function TEditor.GetEditorState: string;
begin
  if fForm <> nil then begin
    if fForm.SynEditor.ReadOnly then
      Result := SReadOnly
    else if fForm.SynEditor.InsertMode then
      Result := SInsert
    else
      Result := SOverwrite;
  end else
    Result := '';
end;

function TEditor.GetFileName: string;
begin
  Result := fFileName;
end;

function TEditor.GetFileTitle: string;
begin
  if fFileName <> '' then
    Result := ExtractFileName(fFileName)
  else
  begin
    if fUntitledNumber = -1 then
      fUntitledNumber := CommandsDataModule.GetUntitledNumber;
    Result := SNonameFileTitle + IntToStr(fUntitledNumber)+ getFileTypeByIndex(fFileType);
  end;
end;

function TEditor.GetModified: boolean;
begin
  if fForm <> nil then
    Result := fForm.SynEditor.Modified
  else
    Result := FALSE;
end;

procedure TEditor.OpenFile(AFileName: string;packageName:String);  
var
  tempStr:TStringList;
begin
  GI_ActiveEditor:=self;
  fFileName := AFileName;
  if fForm <> nil then begin
    fForm.SynEditor.packageName:=packageName;
    if (AFileName <> '') and FileExists(AFileName) then
      fForm.SynEditor.Lines.LoadFromFile(AFileName)
    else
    begin
      fForm.SynEditor.Lines.Clear;
      if packageName <> '####' then
      begin
        if fFileType = 4 then
        begin
          if FileExists(g_templatePath+'ServletTemplate') then
          begin
            tempStr:=TStringList.Create;
            tempstr.LoadFromFile(g_templatePath+'ServletTemplate');
            if packageName = '' then
              tempStr.Text:=AnsiReplaceStr(tempStr.Text,'<package>'#13#10,'')
            else
              tempStr.Text:=AnsiReplaceStr(tempStr.Text,'<package>','package '+ packageName +' ;');
            tempStr.Text:=AnsiReplaceStr(tempStr.Text,'<ServletName>',getClassName(ExtractFileName(fFileName)));
            fForm.SynEditor.BeginUpdate;
            fForm.SynEditor.CaretXY:=Point(1,1);
            fForm.SynEditor.BlockBegin:=Point(1,1);
            fForm.SynEditor.BlockEnd:=Point(1,1);
            fForm.SynEditor.SelText:=tempStr.Text;
            fForm.SynEditor.EndUpdate;
            tempStr.Free;
          end;
        end else if fFileType = 0 then
        begin
          if FileExists(g_templatePath+'CommonJavaTemplate') then
          begin
            tempStr:=TStringList.Create;
            tempstr.LoadFromFile(g_templatePath+'CommonJavaTemplate');
            if packageName = '' then
              tempStr.Text:=AnsiReplaceStr(tempStr.Text,'<package>'#13#10,'')
            else
              tempStr.Text:=AnsiReplaceStr(tempStr.Text,'<package>','package '+ packageName +' ;');
            tempStr.Text:=AnsiReplaceStr(tempStr.Text,'<ClassName>',getClassName(ExtractFileName(fFileName)));
            fForm.SynEditor.BeginUpdate;
            fForm.SynEditor.CaretXY:=Point(1,1);
            fForm.SynEditor.BlockBegin:=Point(1,1);
            fForm.SynEditor.BlockEnd:=Point(1,1);
            fForm.SynEditor.SelText:=tempStr.Text;
            fForm.SynEditor.EndUpdate;
            tempStr.Free;
          end;
        end else if fFileType = 1 then
        begin
          if FileExists(g_templatePath+'InterfaceTemplate') then
          begin
            tempStr:=TStringList.Create;
            tempstr.LoadFromFile(g_templatePath+'InterfaceTemplate');
            if packageName = '' then
              tempStr.Text:=AnsiReplaceStr(tempStr.Text,'<package>'#13#10,'')
            else
              tempStr.Text:=AnsiReplaceStr(tempStr.Text,'<package>','package '+ packageName +' ;');
            tempStr.Text:=AnsiReplaceStr(tempStr.Text,'<InterfaceName>',getClassName(ExtractFileName(fFileName)));
            fForm.SynEditor.BeginUpdate;
            fForm.SynEditor.CaretXY:=Point(1,1);
            fForm.SynEditor.BlockBegin:=Point(1,1);
            fForm.SynEditor.BlockEnd:=Point(1,1);
            fForm.SynEditor.SelText:=tempStr.Text;
            fForm.SynEditor.EndUpdate;
            tempStr.Free;
          end;
        end else if fFileType = 2 then
        begin
          if FileExists(g_templatePath+'AppletTemplate') then
          begin
            tempStr:=TStringList.Create;
            tempstr.LoadFromFile(g_templatePath+'AppletTemplate');
            if packageName = '' then
              tempStr.Text:=AnsiReplaceStr(tempStr.Text,'<package>'#13#10,'')
            else
              tempStr.Text:=AnsiReplaceStr(tempStr.Text,'<package>','package '+ packageName +' ;');
            tempStr.Text:=AnsiReplaceStr(tempStr.Text,'<AppletName>',getClassName(ExtractFileName(fFileName)));
            fForm.SynEditor.BeginUpdate;
            fForm.SynEditor.CaretXY:=Point(1,1);
            fForm.SynEditor.BlockBegin:=Point(1,1);
            fForm.SynEditor.BlockEnd:=Point(1,1);
            fForm.SynEditor.SelText:=tempStr.Text;
            fForm.SynEditor.EndUpdate;
            tempStr.Free;
          end;
        end;
      end;
    end;
    fForm.DoUpdateCaption;
    fForm.DoUpdateHighlighter;
  end;
end;

// IEditCommands implementation

function TEditor.CanCopy: boolean;
begin
  Result := (fForm <> nil) and fHasSelection;
end;

function TEditor.CanCut: boolean;
begin
  Result := (fForm <> nil) and fHasSelection and not fIsReadOnly;
end;

function TEditor.CanPaste: boolean;
begin
  Result := (fForm <> nil) and fForm.SynEditor.CanPaste;
end;

function TEditor.CanRedo: boolean;
begin
  Result := (fForm <> nil) and fForm.SynEditor.CanRedo;
end;

function TEditor.CanSelectAll: boolean;
begin
  Result := fForm <> nil;
end;

function TEditor.CanUndo: boolean;
begin
  Result := (fForm <> nil) and fForm.SynEditor.CanUndo;
end;

procedure TEditor.ExecCopy;
begin
  if fForm <> nil then
    fForm.SynEditor.CopyToClipboard;
end;

procedure TEditor.ExecCut;
begin
  if fForm <> nil then
    fForm.SynEditor.CutToClipboard;
end;

procedure TEditor.ExecDelete;
begin
  if fForm <> nil then
    fForm.SynEditor.SelText := '';
end;

procedure TEditor.ExecPaste;
begin
  if fForm <> nil then
    fForm.SynEditor.PasteFromClipboard;
end;

procedure TEditor.ExecRedo;
begin
  if fForm <> nil then
    fForm.SynEditor.Redo;
end;

procedure TEditor.ExecSelectAll;
begin
  if fForm <> nil then
    fForm.SynEditor.SelectAll;
end;

procedure TEditor.ExecUndo;
begin
  if fForm <> nil then
    fForm.SynEditor.Undo;
end;

// IFileCommands implementation

function TEditor.CanPrint: boolean;
begin
  Result := (fForm <> nil) and (fForm.SynEditor.Lines.Text <> '');
end;

function TEditor.CanSave: boolean;
begin
  Result := (fForm <> nil) and (fModified or (fFileName = ''));
end;

function TEditor.CanSaveAs: boolean;
begin
  Result := fForm <> nil;
end;

procedure TEditor.ExecPrint;
begin
  if fForm <> nil then
  begin
    CommandsDataModule.SynEditPrinter.SynEdit := fForm.SynEditor;
    CommandsDataModule.SynEditPrinter.Title := GetFileName;
    with TestPrintPreviewDlg do begin
      SynEditPrintPreview.SynEditPrint:= CommandsDataModule.SynEditPrinter;
      ShowModal;
    end;
  end;
end;

procedure TEditor.ExecSave;
begin
  if fForm <> nil then begin
    if fFileName <> '' then
      fForm.DoSave
    else
      fForm.DoSaveAs
  end;
end;


procedure TEditor.ExecSaveAs;
begin
  if fForm <> nil then
    fForm.DoSaveAs;
end;

// ISearchCommands implementation

function TEditor.CanFind: boolean;
begin
  Result := (fForm <> nil) and not fIsEmpty;
end;

function TEditor.CanFindNext: boolean;
begin
  Result := (fForm <> nil) and not fIsEmpty and (gsSearchText <> '');
end;

function TEditor.CanReplace: boolean;
begin
  Result := (fForm <> nil) and not fIsReadOnly and not fIsEmpty;
end;

procedure TEditor.ExecFind;
begin
  if fForm <> nil then
    fForm.ShowSearchReplaceDialog(FALSE);
end;

procedure TEditor.ExecFindNext;
begin
  if fForm <> nil then
    fForm.DoSearchReplaceText(FALSE, FALSE);
end;

procedure TEditor.ExecFindPrev;
begin
  if fForm <> nil then
    fForm.DoSearchReplaceText(FALSE, TRUE);
end;

procedure TEditor.ExecReplace;
begin
  if fForm <> nil then
    fForm.ShowSearchReplaceDialog(TRUE);
end;

{ TEditorTabSheet }

type
  TEditorTabSheet = class(TTabSheet)
  private
    procedure WMDeleteThis(var Msg: TMessage);
      message WM_DELETETHIS;
  end;

procedure TEditorTabSheet.WMDeleteThis(var Msg: TMessage);
var
  ed:IEditor;
begin
  Free;
  if GI_EditorFactory.GetEditorCount > 0 then
  begin
     ed:=GI_EditorFactory.Editor[ideFrm.filePageControl.ActivePageIndex];
     if not IsJavaFile(ed.GetFileName) then
     begin
       ed.SetPageIndex(1);
       classBrowserFrm.ClassBrowserTV.Items.Clear;
     end;
     ed.GetSynEditor.setFocus;
  end;
end;

{ TEditorFactory }

type
  TEditorFactory = class(TInterfacedObject, IEditorFactory)
  private
    // IEditorFactory implementation
    function CanCloseAll: boolean;
    procedure CloseAll;
    function CreateBorderless(AOwner: TForm;Index:Integer): IEditor;
    function CreateMDIChild(AOwner: TForm;Index:Integer): IEditor;
    function CreateTabSheet(AOwner: TPageControl;Index:Integer): IEditor;
    function GetEditorCount: integer;
    function GetEditorByName(fn:String): IEditor;
    function GetEditor(Index: integer): IEditor;
    procedure RemoveEditor(AEditor: IEditor);
  private
    fEditors: TInterfaceList;
    constructor Create;
    destructor Destroy; override;
  end;

constructor TEditorFactory.Create;
begin
  inherited Create;
  fEditors := TInterfaceList.Create;
end;

destructor TEditorFactory.Destroy;
begin
  fEditors.Free;
  inherited Destroy;
end;

function TEditorFactory.CanCloseAll: boolean;
var
  i: integer;
  LEditor: IEditor;
begin
  i := fEditors.Count - 1;
  while i >= 0 do begin
    LEditor := IEditor(fEditors[i]);
    if not LEditor.AskSaveChanges then begin
      Result := FALSE;
      exit;
    end;
    Dec(i);
  end;
  Result := TRUE;
end;

procedure TEditorFactory.CloseAll;
var
  i: integer;
begin
  i := fEditors.Count - 1;
  while i >= 0 do begin
    IEditor(fEditors[i]).Close;
    Dec(i);
  end;
end;

function TEditorFactory.CreateBorderless(AOwner: TForm;Index:Integer): IEditor;
var
  LForm: TEditorForm;
begin
  LForm := TEditorForm.Create(AOwner,index);
  with LForm do begin
    fEditor := TEditor.Create(LForm,index);
    Result := fEditor;
    fKind := ekBorderless;
    BorderStyle := bsNone;
    Parent := AOwner;
    Align := alClient;
    Visible := TRUE;
  end;
  if Result <> nil then
    fEditors.Add(Result);
end;

function TEditorFactory.CreateMDIChild(AOwner: TForm;Index:Integer): IEditor;
var
  LForm: TEditorForm;
begin
  LForm := TEditorForm.Create(AOwner,index);
  with LForm do begin
    fEditor := TEditor.Create(LForm,index);
    Result := fEditor;
    fKind := ekMDIChild;
    FormStyle := fsMDIChild;
  end;
  if Result <> nil then
    fEditors.Add(Result);
end;

function TEditorFactory.CreateTabSheet(AOwner: TPageControl;Index:Integer): IEditor;
var
  Sheet: TTabSheet;
  LForm: TEditorForm;
begin
  Sheet := TEditorTabSheet.Create(AOwner);
  try
    Sheet.PageControl := AOwner;
    LForm := TEditorForm.Create(Sheet,index);
    commandDataDM.SynAutoComplete.AddEditor(LForm.SynEditor);
    LForm.SynEditor.AddKey(ecAutoCompletion, word('J'), [ssCtrl], 0, []);

    with LForm do begin
      fEditor := TEditor.Create(LForm,index);

      Result := fEditor;
      fKind := ekInTabsheet;
      BorderStyle := bsNone;
      Parent := Sheet;
      Align := alClient;

      Visible := TRUE;
      AOwner.ActivePage := Sheet;
      LForm.SynEditor.SetFocus;
      //LForm.SynEditor.SetFocus;
    end;
    // fix for Delphi 4 (???)
    LForm.Realign;
    if Result <> nil then
      fEditors.Add(Result);
    sheet.ImageIndex:=index+1;  
  except
    Sheet.Free;
  end;
end;

function TEditorFactory.GetEditorCount: integer;
begin
  Result := fEditors.Count;
end;

function TEditorFactory.GetEditor(Index: integer): IEditor;
begin
  Result := IEditor(fEditors[Index]);
end;

function TEditorFactory.GetEditorByName(fn:String): IEditor;
var
  i:Integer;
begin
  Result := nil;
  for i:=0 to fEditors.Count-1 do
  begin
    if fn = IEditor(fEditors[i]).GetFileName  then
    begin
      result := IEditor(fEditors[i]);
      break;
    end;
  end;
end;
procedure TEditorFactory.RemoveEditor(AEditor: IEditor);
var
  i: integer;
  mi:TMenuItem;
  fn:String;
begin
  i := fEditors.IndexOf(AEditor);
  if i > -1 then
    fEditors.Delete(i);

  mi:=AEditor.GetMenuItem.Parent;
  if mi <> nil then
  begin
    mi.Delete(AEditor.GetMenuItem.MenuIndex);
    if mi.Count = 0 then
       mi.Clear;
  end;
  if ideFrm.filePageControl.pageCount >=1 then
  begin
     fn:=GI_EditorFactory.Editor[ideFrm.filePageControl.ActivePageIndex].GetFileName;
      if isJavaFile(fn) then
      begin
        if ideFrm.G_PMList.AnalysisSocket <> nil then
           ideFrm.G_PMList.AnalysisSocket.SendText('@@' + fn + #13#10)
        else if  (G_CB<>nil ) and ( ideFrm.filePageControl.PageCount > 0) then
           PostThreadMessage(G_CB.ThreadID,WM_CLASSBROWSER,Integer(GI_EditorFactory.Editor[ideFrm.filePageControl.ActivePageIndex]),0);

      end
      else
      begin
         if ( ClassBrowserFrm <> nil ) and (classBrowserFrm.classBrowserTV <> nil) then
           //classBrowserFrm.classBrowserTV.items.clear;
           PostThreadMessage(G_CB.ThreadID,WM_CLASSBROWSER,0,0);
      end;
  end
  else if ( (classBrowserFrm<> nil) and (classBrowserFrm.classBrowserTV <> nil )) then
    //classBrowserFrm.classBrowserTV.items.clear;
    PostThreadMessage(G_CB.ThreadID,WM_CLASSBROWSER,0,0);
end;

{ TEditorForm }
constructor TEditorForm.Create(owner:TComponent;filetype:Integer);
begin
  inherited create(owner);
  self.fileType:=filetype;
end;

procedure TEditorForm.FormActivate(Sender: TObject);
begin
  DoAssignInterfacePointer(TRUE);
end;

procedure TEditorForm.FormDeactivate(Sender: TObject);
begin
  DoAssignInterfacePointer(FALSE);
end;

procedure TEditorForm.FormShow(Sender: TObject);
begin
  DoUpdateCaption;
end;

procedure TEditorForm.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  if fKind = ekInTabSheet then
  begin
    PostMessage(Parent.Handle, WM_DELETETHIS, 0, 0);
    Action := caNone;
  end else
    Action := caFree;
end;

procedure TEditorForm.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
  // need to prevent this from happening more than once (e.g. with MDI childs)
  if not (csDestroying in ComponentState) then
    CanClose := DoAskSaveChanges
end;

procedure TEditorForm.FormDestroy(Sender: TObject);
var
  LEditor: IEditor;
begin
  if ( ( filetype = HTML_FILE) or (filetype = JSP_FILE) )then
  begin
    if webBrowser <>nil then
      webBrowser.Free;
    if tab1 <> nil then
      tab1.Free;
    if tab2 <> nil then
      tab2.Free;
    if page <> nil then
      page.Free;
  end;
  if (( ideFrm.G_PMList <> nil) and (ideFrm.G_PMList.SynEditor = Syneditor)) then
    ideFrm.G_PMList.Visible:=false;
  LEditor := fEditor;
  Assert(fEditor <> nil);
  fEditor.fForm := nil;
  Assert(GI_EditorFactory <> nil);
  GI_EditorFactory.RemoveEditor(LEditor);
end;

procedure TEditorForm.SynEditorChange(Sender: TObject);
var
  Empty: boolean;
  i: integer;
begin
  Assert(fEditor <> nil);
  Empty := TRUE;
  for i := SynEditor.Lines.Count - 1 downto 0 do
    if SynEditor.Lines[i] <> '' then begin
      Empty := FALSE;
      break;
    end;
  fEditor.fIsEmpty := Empty;
end;

procedure TEditorForm.SynEditorEnter(Sender: TObject);
begin
  DoAssignInterfacePointer(TRUE);
end;

procedure TEditorForm.SynEditorExit(Sender: TObject);
begin
  //DoAssignInterfacePointer(FALSE);
end;

procedure TEditorForm.SynEditorReplaceText(Sender: TObject; const ASearch,
  AReplace: String; Line, Column: Integer; var Action: TSynReplaceAction);
var
  APos: TPoint;
  EditRect: TRect;
begin
  if ASearch = AReplace then
    Action := raSkip
  else begin
    APos := Point(Column, Line);
    APos := SynEditor.ClientToScreen(SynEditor.RowColumnToPixels(APos));
    EditRect := ClientRect;
    EditRect.TopLeft := ClientToScreen(EditRect.TopLeft);
    EditRect.BottomRight := ClientToScreen(EditRect.BottomRight);

    if ConfirmReplaceDialog = nil then
      ConfirmReplaceDialog := TConfirmReplaceDialog.Create(Application);
    ConfirmReplaceDialog.PrepareShow(EditRect, APos.X, APos.Y,
      APos.Y + SynEditor.LineHeight, ASearch);
    case ConfirmReplaceDialog.ShowModal of
      mrYes: Action := raReplace;
      mrYesToAll: Action := raReplaceAll;
      mrNo: Action := raSkip;
      else Action := raCancel;
    end;
  end;
end;

procedure TEditorForm.SynEditorStatusChange(Sender: TObject;
  Changes: TSynStatusChanges);
begin
  Assert(fEditor <> nil);
  if Changes * [scAll, scSelection] <> [] then
    fEditor.fHasSelection := SynEditor.SelAvail;
  if Changes * [scAll, scSelection] <> [] then
    fEditor.fIsReadOnly := SynEditor.ReadOnly;
  if Changes * [scAll, scModified] <> [] then
    fEditor.fModified := SynEditor.Modified;
end;

procedure TEditorForm.DoActivate;
var
  Sheet: TTabSheet;
  PCtrl: TPageControl;
begin
  if FormStyle = fsMDIChild then
    BringToFront
  else if Parent is TTabSheet then begin
    Sheet := TTabSheet(Parent);
    PCtrl := Sheet.PageControl;
    if PCtrl <> nil then
      PCtrl.ActivePage := Sheet;
  end;
end;

function TEditorForm.DoAskSaveChanges: boolean;
const
  MBType = MB_YESNOCANCEL or MB_ICONQUESTION;
var
  s: string;
begin
  // this is necessary to prevent second confirmation when closing MDI childs
  if SynEditor.Modified then
  begin
    DoActivate;
    MessageBeep(MB_ICONQUESTION);
    Assert(fEditor <> nil);
    s := Format(getErrorMsg('SAskSaveChanges'), [ExtractFileName(fEditor.GetFileTitle)]);
    case Application.MessageBox(PChar(s), PChar(getErrorMsg('ErrorDlgCaption')), MBType) of
      IDYes: begin Result := DoSave;g_CancelSave :=false; end;
      IDNo: begin Result := TRUE;g_CancelSave :=false; end;
    else
      begin Result := FALSE;g_CancelSave :=true; end;
    end;
  end else
  begin
    Result := TRUE;
    g_CancelSave :=false;
  end;
end;

procedure TEditorForm.DoAssignInterfacePointer(AActive: boolean);
begin
  if AActive then begin
    GI_ActiveEditor := fEditor;
    GI_EditCmds := fEditor;
    GI_FileCmds := fEditor;
    GI_SearchCmds := fEditor;
  end else begin
    if GI_ActiveEditor = IEditor(fEditor) then
      GI_ActiveEditor := nil;
    if GI_EditCmds = IEditCommands(fEditor) then
      GI_EditCmds := nil;
    if GI_FileCmds = IFileCommands(fEditor) then
      GI_FileCmds := nil;
    if GI_SearchCmds = ISearchCommands(fEditor) then
      GI_SearchCmds := nil;
  end;
end;

function TEditorForm.DoSave: boolean;
begin
  Assert(fEditor <> nil);
  if fEditor.fFileName <> '' then
    Result := DoSaveFile
  else
    Result := DoSaveAs;
end;

function TEditorForm.DoSaveFile: boolean;
begin
  Assert(fEditor <> nil);
  try
    SynEditor.Lines.SaveToFile(fEditor.fFileName);
    SynEditor.Modified := FALSE;
    Result := TRUE;
  except
    Application.HandleException(Self);
    Result := FALSE;
  end;
end;

function TEditorForm.DoSaveAs: boolean;
var
  NewName: string;
begin
  Assert(fEditor <> nil);
  NewName := fEditor.GetFileName;
  if CommandsDataModule.GetSaveFileName(NewName, SynEditor.Highlighter) then
  begin
    fEditor.DoSetFileName(NewName);
    DoUpdateCaption;
    DoUpdateHighlighter;
    Result := DoSaveFile;
  end else
    Result := FALSE;
end;

procedure TEditorForm.DoSearchReplaceText(AReplace: boolean;
  ABackwards: boolean);
var
  Options: TSynSearchOptions;
begin
  if AReplace then
    Options := [ssoPrompt, ssoReplace, ssoReplaceAll]
  else
    Options := [];
  if ABackwards then
    Include(Options, ssoBackwards);
  if gbSearchCaseSensitive then
    Include(Options, ssoMatchCase);
  if not fSearchFromCaret then
    Include(Options, ssoEntireScope);
  if gbSearchSelectionOnly then
    Include(Options, ssoSelectedOnly);
  if gbSearchWholeWords then
    Include(Options, ssoWholeWord);
  if SynEditor.SearchReplace(gsSearchText, gsReplaceText, Options) = 0 then
  begin
    MessageBeep(MB_ICONASTERISK);
    if ssoBackwards in Options then
      SynEditor.BlockEnd := SynEditor.BlockBegin
    else
      SynEditor.BlockBegin := SynEditor.BlockEnd;
    SynEditor.CaretXY := SynEditor.BlockBegin;
  end;

  if ConfirmReplaceDialog <> nil then
    ConfirmReplaceDialog.Free;
end;

procedure TEditorForm.DoUpdateCaption;
begin
  Assert(fEditor <> nil);
  case fKind of
    ekInTabsheet:
    begin
      (Parent as TTabSheet).Caption := fEditor.GetFileTitle;
    end;
    ekMDIChild:
      Caption := fEditor.GetFileTitle + ' - ' + SEditorCaption;
  end;
end;

procedure TEditorForm.DoUpdateHighlighter;
begin
  Assert(fEditor <> nil);
  if fEditor.GetFileTitle <> '' then begin
    SynEditor.Highlighter := CommandsDataModule.GetHighlighterForFile(fEditor.GetFileTitle);
    //SynEditor.Highlighter := getHighlighterByFileType;
  end else
  SynEditor.Highlighter := nil;
end;


procedure TEditorForm.ShowSearchReplaceDialog(AReplace: boolean);
var
  dlg: TTextSearchDialog;
begin
  if AReplace then
    dlg := TTextReplaceDialog.Create(Self)
  else
    dlg := TTextSearchDialog.Create(Self);
  with dlg do try
    // assign search options
    SearchBackwards := gbSearchBackwards;
    SearchCaseSensitive := gbSearchCaseSensitive;
    SearchFromCursor := gbSearchFromCaret;
    SearchInSelectionOnly := gbSearchSelectionOnly;
    // start with last search text
    SearchText := gsSearchText;
    if gbSearchTextAtCaret then begin
      // if something is selected search for that text
      if SynEditor.SelAvail and (SynEditor.BlockBegin.Y = SynEditor.BlockEnd.Y)
      then
        SearchText := SynEditor.SelText
      else
        SearchText := SynEditor.GetWordAtRowCol(SynEditor.CaretXY);
    end;
    SearchTextHistory := gsSearchTextHistory;
    if AReplace then with dlg as TTextReplaceDialog do begin
      ReplaceText := gsReplaceText;
      ReplaceTextHistory := gsReplaceTextHistory;
    end;
    SearchWholeWords := gbSearchWholeWords;
    if ShowModal = mrOK then begin
      gbSearchBackwards := SearchBackwards;
      gbSearchCaseSensitive := SearchCaseSensitive;
      gbSearchFromCaret := SearchFromCursor;
      gbSearchSelectionOnly := SearchInSelectionOnly;
      gbSearchWholeWords := SearchWholeWords;
      gsSearchText := SearchText;
      gsSearchTextHistory := SearchTextHistory;
      if AReplace then with dlg as TTextReplaceDialog do begin
        gsReplaceText := ReplaceText;
        gsReplaceTextHistory := ReplaceTextHistory;
      end;
      fSearchFromCaret := gbSearchFromCaret;
      if gsSearchText <> '' then begin
        DoSearchReplaceText(AReplace, gbSearchBackwards);
        fSearchFromCaret := TRUE;
      end;
    end;
  finally
    dlg.Free;
  end;
end;

procedure TEditorForm.FormCreate(Sender: TObject);
begin
  if (( filetype = CLASS_FILE) or
    ( filetype = INTERFACE_FILE) or
    ( filetype = APPLET_FILE)or
     ( filetype = SERVLET_FILE) )then
    synEditor.BreakpointEnable := true;
  if ( ( filetype = HTML_FILE) or (filetype = JSP_FILE) )then
  begin
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

    synEditor.Parent:=tab2;
    synEditor.Align:=alClient;
    synEditor.Show;

    webBrowser:=TWebBrowser.Create(tab1);
    TControl(webBrowser).Parent:=tab1;
    WebBrowser.Navigate('about:blank');
    //SetHtml(webbrowser,synEditor.Lines.Text);
    webBrowser.Align:=alClient;
    webBrowser.Visible:=true;

    tab1.OnShow:=self.showEvent;
  end;
end;
procedure TEditorForm.showEvent(Sender: TObject);
var
  s:String;
  index:integer;
begin
  //SetHtml(webbrowser,synEditor.Lines.Text);
  s:= ExtractFilePath(fEditor.GetFileName) + TEMPHEMLFILE;
  if not G_tempHtmlFileList.Find(s,index) then
    G_tempHtmlFileList.add(s);
  synEditor.Lines.SaveToFile(s);
  webBrowser.Navigate(s);

end;

procedure TEditorForm.SynEditorKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if (ideFrm.G_PMList.Visible)  then
  begin
    if  key  in [VK_RETURN,VK_UP,VK_DOWN,VK_HOME, VK_PRIOR, VK_NEXT,VK_END,VK_TAB,VK_SPACE] then
    begin
       PostMessage(ideFrm.G_PMList.Handle,WM_KEYDOWN,key,0);
       Key := 0;
    end else if key in [VK_LEFT, VK_RIGHT]  then
       key := 0;
    if  key = VK_ESCAPE then
    begin
      ideFrm.G_PMList.Visible:=false;
    end;
  end;

  if (ideFrm.packageListBox.Visible)  then
  begin
    if  key  in [VK_RETURN,VK_UP,VK_DOWN,VK_HOME, VK_PRIOR, VK_NEXT,VK_END,VK_TAB,VK_SPACE] then
    begin
       PostMessage(ideFrm.packageListBox.Handle,WM_KEYDOWN,key,0);
       Key := 0;
    end else if key in [VK_LEFT, VK_RIGHT]  then
       key := 0;
    if  key = VK_ESCAPE then
    begin
      ideFrm.packageListBox.Visible:=false;
    end;
  end;
end;

procedure TEditorForm.SynEditorKeyPress(Sender: TObject; var Key: Char);
var
  p:TPoint;
  s:String;
begin
  if (key = '.')  then
  begin
    s:=trim(SynEditor.LineText);
    g_dotPosition := SynEditor.CaretX;
    if  ( Pos('import ',s) > 0) or  (Pos('import'+#9,s) > 0) then
    begin
      if ( not FileExists(g_jdk_zipsrc_path))  or ( ideFrm.jdkApiTV.Items.Count = 0 ) then
        exit;
      getPackageList(SynEditor.GetWord);
      p.x := SynEditor.CaretXPix;
      p.y := SynEditor.CaretYPix;
      p := SynEditor.ClientToScreen(p) ;

      p := ( parent as TWinControl).ScreenToClient(p);
      ideFrm.packageListBox.Left := p.x + 12;
      ideFrm.packageListBox.top:=p.Y + 2*SynEditor.LineHeight + 8;
      if ( (parent as TWinControl).Height - ideFrm.packageListBox.top ) <= (ideFrm.packageListBox.Height - 2*SynEditor.LineHeight) then
      begin
        ideFrm.packageListBox.top := p.Y  - ideFrm.packageListBox.Height  + 2*SynEditor.LineHeight + 8;
      end;

      refreshPackageList('',ideFrm.packageListBox);
      if ideFrm.packageListBox.Items.Count > 0 then
      begin
        ideFrm.packageListBox.ItemIndex:=0;
        ideFrm.packageListBox.visible:=true;
      end else
        ideFrm.packageListBox.visible:=false;
      SynEditor.SetFocus;
    end else
    begin
      if ideFrm.G_PMList.Visible then
      ideFrm.G_PMList.Visible := false;

      begin
        ideFrm.G_PMList.filename:=GI_EditorFactory.Editor[ideFrm.filePageControl.ActivePageIndex].getFileName;
        ideFrm.G_PMList.SynEditor:=GI_EditorFactory.Editor[ideFrm.filePageControl.ActivePageIndex].GetSynEditor;
        ideFrm.G_PMList.allItems.Clear;
        if ( G_VersionType = TRAILVERSION )  and ( g_poplistNumber >= MaxAnalysisNumber)  then
        begin
          msgFrm.operatorMemo.Lines.Add('Trial Version only permit using 30 class analysis.');
          msgFrm.operatorMemo.Lines.Add('Please login '+g_domain_web_site+' to get license.');
          exit;
        end;

        ideFrm.G_PMList.doAnalysis;
        g_poplistNumber:=g_poplistNumber + 1;
      end;
    end;
  end;

  if ( ideFrm.packageListBox.Visible) and ( key = char(VK_SPACE) ) then
  begin
    key := #0;
  end;

  if ( ideFrm.G_PMList.Visible and  ( key = char(VK_SPACE) ) ) then
  begin
    key:=#0;
  end;

  if ( key = ')') and ideFrm.G_PMList.EditHintWnd.Visible then
  begin
    ideFrm.G_PMList.EditHintWnd.Visible:=false;
    ideFrm.G_PMList.EditHintWnd.ActivateHint(Rect(0, 0, 0, 0), '');
    ideFrm.G_PMList.Update;
  end;
  
end;

procedure TEditorForm.SynEditorKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
   if ideFrm.packageListBox.Visible then
   begin
     if SynEditor.CaretX < g_dotPosition   then
     begin
       ideFrm.packageListBox.Visible:=false;
       exit;
     end;
     if not( key in [VK_RETURN,VK_UP,VK_DOWN,VK_HOME, VK_PRIOR, VK_NEXT,VK_SPACE,VK_END,VK_TAB] )then
       refreshPackageList(SynEditor.GetWordAtRowCol(SynEditor.CaretXY),ideFrm.packageListBox);
   end;

   if ideFrm.G_PMList.Visible then
   begin
     if SynEditor.CaretX < ( ideFrm.G_PMList.dotPosition + 1) then
     begin
       ideFrm.G_PMList.Visible:=false;
       exit;
     end;
     if not( key  in [VK_RETURN,VK_UP,VK_DOWN,VK_HOME, VK_PRIOR, VK_NEXT,VK_SPACE,VK_END,VK_TAB] )then
       ideFrm.G_PMList.getFilterResult;
   end;
end;

procedure TEditorForm.SynEditorDblClick(Sender: TObject);
var
  s:String;
  index,i:Integer;
  label nextFound;
begin
  //get the line text of mouse down line
  s := SynEditor.Lines[mouseDownCaretXY.Y-1];
  s := copy(s,1,mouseDownCaretXY.x-1);
  index := LastDelimiter('{',s);

  if ( index <= 0  ) then
    goto nextFound;

  //s := Copy(s,index+1,length(s));

  for i:=index + 1 to length(s) do
  begin
    if ( ( s[i]<>' ') and (s[i] <> '') and (s[i] <> #9) ) then
      goto nextFound;
  end;
  //need select
  SynEditor.BlockBegin:=Point(index+1,mouseDownCaretXY.Y);
  SynEditor.CaretXY:=SynEditor.BlockBegin;
  //find next '}'
  index:=FindNextRightKuohao(SynEditor.TranslatePointToLong(mouseDownCaretXY),SynEditor.Lines.text);
  if index >= 0 then
  begin
    SynEditor.BlockEnd:=SynEditor.TranslateLongToPoint(index);
  end;
  nextFound:
  //second find '}'
  s := SynEditor.Lines[mouseDownCaretXY.Y-1];
  s := copy(s,mouseDownCaretXY.x,length(s));
  index := Pos('}',s);

  if ( index <= 0  ) then
    exit;

  for i:=1 to index-1 do
  begin
    if ( ( s[i]<>' ') and (s[i] <> '') and (s[i] <> #9) ) then
      exit;
  end;
  //need select
  SynEditor.BlockBegin:=Point(index+mouseDownCaretXY.x-1,mouseDownCaretXY.Y);
  SynEditor.CaretXY:=SynEditor.BlockBegin;
  //find next '}'
  index:=FindNextLeftKuohao(SynEditor.TranslatePointToLong(mouseDownCaretXY),SynEditor.Lines.text);
  if index >= 0 then
  begin
    SynEditor.BlockEnd:=SynEditor.TranslateLongToPoint(index);
  end;
end;

procedure TEditorForm.SynEditorClick(Sender: TObject);
begin
  mouseDownCaretXY := SynEditor.CaretXY ;
end;

procedure TEditorForm.pmnuEditorPopup(Sender: TObject);
var
  className,packageName:String;
begin
    debugAppletMi.Enabled:=false;
    runAppletMI.Enabled:=false;
    if isJavaFile(fEditor.GetFileName) then
    begin
      compileMI.Enabled:=true;
      if not findMainMethod(fEditor.getFileContent) then
      begin
        debugRunMI.Enabled:=false;
        RunMI.Enabled:=false;
      end
      else
      begin
        debugRunMI.Enabled:=true;
        RunMI.Enabled:=true;
      end;
      className := ExtractFileName(fEditor.GetFileName);
      className := Copy(className,1,length(className)-length('.java'));
      if not FindAppointedString(fEditor.getFileContent,
                  'class\s+'+className+'\s+extends\s+(Applet|JApplet|java.applet.Applet|javax.swing.JApplet)\s*\{') then
      begin
        //发送一个命令，测试是不是Applet类的子类
        if  ideFrm.G_PMList.AnalysisSocket <> nil then
        begin
          if not FindPackage(fEditor.getFileContent,packageName) then
            ideFrm.G_PMList.AnalysisSocket.SendText('!!'
                  + className +';'
                  + findPathNoPackage(fEditor.GetFileName,packageName)
                  + #13#10)
          else
            ideFrm.G_PMList.AnalysisSocket.SendText('!!'
                  + packageName+'.' + className + ';'
                  + findPathNoPackage(fEditor.GetFileName,packageName)
                  + #13#10);
        end;
      end else
      begin
        debugAppletMi.Enabled:=true;
        runAppletMI.Enabled:=true;
      end;
    end else
    begin
      compileMI.Enabled:=false;
      debugRunMI.Enabled:=false;
      RunMI.Enabled:=false;
    end;
end;

procedure TEditorForm.runMIClick(Sender: TObject);
var
  subFile:TSubFile;
  editor:IEditor;
  fn,className,packageName:String;
  index:Integer;
begin
  editor:=GI_EditorFactory.Editor[ideFrm.FilePageControl.ActivePageIndex];
  fn:=editor.GetFileName;
  if  G_Project <> nil then
    subFile := G_Project.findSubFileByName(fn)
  else
    subFile := nil;

  FindPackage(editor.GetFileContent,packageName);

  if subFile <> nil then
  begin
    if packageName <> subFile.package then
    begin
      if MessageBox(handle,PChar(Format(getErrorMsg('PackageNotMatch'),[ExtractFileName(fn),subFile.package,#13#10,packageName])),
                    PChar(getErrorMsg('ErrorDlgCaption')),
                    MB_OKCANCEL or MB_ICONWARNING) <> IDOK then
        exit;
    end;
    if (sender as TMenuItem).Tag = 0 then
      G_curApp.RunApp(subFile.getClassName,subFile.package,getFileFromSubFile(subFile),false,false)
    else
      G_curApp.RunApp(subFile.getClassName,subFile.package,getFileFromSubFile(subFile),false,true);


    exit;
  end else
  begin
    index:=Pos('.java',LowerCase(ExtractFileName(fn)));
    if index <= 0 then
      exit;
    className:=Copy(ExtractFileName(fn),1,index-1);
    G_curApp.RunApp(className,packageName,fn,false,false);
  end;
end;

procedure TEditorForm.debugAppletMIClick(Sender: TObject);
var
  subFile:TSubFile;
  editor:IEditor;
  fn,className,packageName:String;
  index:Integer;
begin
  editor:=GI_EditorFactory.Editor[ideFrm.FilePageControl.ActivePageIndex];
  fn:=editor.GetFileName;
  if  G_Project <> nil then
    subFile := G_Project.findSubFileByName(fn)
  else
    subFile := nil;

  FindPackage(editor.GetFileContent,packageName);

  if subFile <> nil then
  begin
    if packageName <> subFile.package then
    begin
      if MessageBox(handle,PChar(Format(getErrorMsg('PackageNotMatch'),[ExtractFileName(fn),subFile.package,#13#10,packageName])),
                    PChar(getErrorMsg('ErrorDlgCaption')),
                    MB_OKCANCEL or MB_ICONWARNING) <> IDOK then
        exit;
    end;
    if (sender as TMenuItem).Tag = 0 then
      DebugApp(subFile.getClassName,subFile.package,getFileFromSubFile(subFile),false)
    else
      DebugApp(subFile.getClassName,subFile.package,getFileFromSubFile(subFile),true);


    exit;
  end else
  begin
    index:=Pos('.java',LowerCase(ExtractFileName(fn)));
    if index <= 0 then
      exit;
    className:=Copy(ExtractFileName(fn),1,index-1);
    DebugApp(className,packageName,fn,false);
  end;
end;
                             
procedure TEditorForm.SynEditorGutterClick(Sender: TObject; X, Y,
  Line: Integer; mark: TSynEditMark);
begin
  setBreakPointInEditor(fEditor,IntToStr(line));
end;



procedure TEditorForm.closeBtnClick(Sender: TObject);
begin
  if GI_FileCmds <> nil then
  begin
    GI_FileCmds.ExecClose;
  end;
end;

initialization
  GI_EditorFactory := TEditorFactory.Create;
finalization
  GI_EditorFactory := nil;
end.


