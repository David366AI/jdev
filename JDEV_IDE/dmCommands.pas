unit dmCommands;

{$I SynEdit.inc}

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ActnList,  SynEditHighlighter,iniFiles,
  SynHighlighterHTML, SynHighlighterJava, ImgList,
  SynEditPrint,classBrowser, SynEditAutoComplete, SynCompletionProposal;

type
  TCommandsDataModule = class(TDataModule)
    actlMain: TActionList;
    actFileSave: TAction;
    actFileSaveAs: TAction;
    actFileClose: TAction;
    actFilePrint: TAction;
    actEditCut: TAction;
    actEditCopy: TAction;
    actEditPaste: TAction;
    actEditDelete: TAction;
    actEditUndo: TAction;
    actEditRedo: TAction;
    actEditSelectAll: TAction;
    actSearchFind: TAction;
    actSearchFindNext: TAction;
    actSearchFindPrev: TAction;
    actSearchReplace: TAction;
    dlgFileSave: TSaveDialog;
    SynHTMLSyn1: TSynHTMLSyn;
    SynJavaSyn1: TSynJavaSyn;
    dlgFileOpen: TOpenDialog;
    SynHTMLSyn2: TSynHTMLSyn;
    SynHTMLSyn3: TSynHTMLSyn;
    dlgPrinterSetup: TPrinterSetupDialog;
    dlgPrint: TPrintDialog;
    actPrintSetup: TAction;
    SynEditPrinter: TSynEditPrint;
    actPrintReview: TAction;
    procedure DataModuleCreate(Sender: TObject);
    procedure DataModuleDestroy(Sender: TObject);
    procedure actFileSaveExecute(Sender: TObject);
    procedure actFileSaveUpdate(Sender: TObject);
    procedure actFileSaveAsExecute(Sender: TObject);
    procedure actFileSaveAsUpdate(Sender: TObject);
    procedure actFilePrintExecute(Sender: TObject);
    procedure actFilePrintUpdate(Sender: TObject);
    procedure actFileCloseExecute(Sender: TObject);
    procedure actFileCloseUpdate(Sender: TObject);
    procedure actEditCutExecute(Sender: TObject);
    procedure actEditCutUpdate(Sender: TObject);
    procedure actEditCopyExecute(Sender: TObject);
    procedure actEditCopyUpdate(Sender: TObject);
    procedure actEditPasteExecute(Sender: TObject);
    procedure actEditPasteUpdate(Sender: TObject);
    procedure actEditDeleteExecute(Sender: TObject);
    procedure actEditDeleteUpdate(Sender: TObject);
    procedure actEditSelectAllExecute(Sender: TObject);
    procedure actEditSelectAllUpdate(Sender: TObject);
    procedure actEditRedoExecute(Sender: TObject);
    procedure actEditRedoUpdate(Sender: TObject);
    procedure actEditUndoExecute(Sender: TObject);
    procedure actEditUndoUpdate(Sender: TObject);
    procedure actSearchFindExecute(Sender: TObject);
    procedure actSearchFindUpdate(Sender: TObject);
    procedure actSearchFindNextExecute(Sender: TObject);
    procedure actSearchFindNextUpdate(Sender: TObject);
    procedure actSearchFindPrevExecute(Sender: TObject);
    procedure actSearchFindPrevUpdate(Sender: TObject);
    procedure actSearchReplaceExecute(Sender: TObject);
    procedure actSearchReplaceUpdate(Sender: TObject);
    procedure actFileSaveAllExecute(Sender: TObject);
    procedure actFileSaveAllUpdate(Sender: TObject);
    procedure actPrintSetupExecute(Sender: TObject);
    procedure actPrintReviewExecute(Sender: TObject);
    procedure actPrintReviewUpdate(Sender: TObject);
  private
    fHighlighters: TStringList;
    fMRUFiles: TStringList;
    fProjectMRUFiles: TStringList;
    fUntitledNumbers: TBits;
  public
    procedure AddMRUEntry(AFileName: string);
    function GetMRUEntries: integer;
    function GetMRUEntry(Index: integer): string;
    procedure RemoveMRUEntry(AFileName: string);

    procedure AddProjectMRUEntry(AFileName: string);
    function GetProjectMRUEntries: integer;
    function GetProjectMRUEntry(Index: integer): string;
    procedure RemoveProjectMRUEntry(AFileName: string);

    function GetHighlighterForFile(AFileName: string): TSynCustomHighlighter;
    function GetSaveFileName(var ANewName: string;
      AHighlighter: TSynCustomHighlighter): boolean;
    function GetUntitledNumber: integer;
    procedure ReleaseUntitledNumber(ANumber: integer);
  end;

var
  CommandsDataModule: TCommandsDataModule;

implementation

{$R *.DFM}

uses
  ideUnit,uHighlighterProcs,uCommandData, uEditAppIntfs;

const
  MAX_MRU = 8;
  MAX_PROJECTMRU = 4;

resourcestring
  SFilterAllFiles = 'All files|*.*|';

{ TCommandsDataModule }

procedure TCommandsDataModule.DataModuleCreate(Sender: TObject);
var
  inifile:TInifile;
begin
  fHighlighters := TStringList.Create;
  GetHighlighters(Self, fHighlighters, FALSE);
  //dlgFileOpen.Filter := GetHighlightersFilter(fHighlighters) + SFilterAllFiles;
  fMRUFiles := TStringList.Create;
  fProjectMRUFiles := TStringList.Create;
  iniFile:=TiniFile.Create(g_exeFilePath  +  CONFIGFILE);
  try
    SynJavaSyn1.CommentAttri.Foreground:=iniFile.ReadInteger('Editor_CFG','commentsColor',clGreen);
    SynJavaSyn1.DocumentAttri.Foreground:=iniFile.ReadInteger('Editor_CFG','documentsColor',clGreen);
    SynJavaSyn1.IdentifierAttri.Foreground:=iniFile.ReadInteger('Editor_CFG','identifiersColor',clBlack);
    SynJavaSyn1.InvalidAttri.Foreground:=iniFile.ReadInteger('Editor_CFG','invalidsColor',clRed);
    SynJavaSyn1.KeyAttri.Foreground:=iniFile.ReadInteger('Editor_CFG','keywordsColor',clBlue);
    SynJavaSyn1.NumberAttri.Foreground:=iniFile.ReadInteger('Editor_CFG','numbersColor',clFuchsia);
    SynJavaSyn1.StringAttri.Foreground:=iniFile.ReadInteger('Editor_CFG','stringsColor',clRed);
  finally
    inifile.Free;
  end;
end;

procedure TCommandsDataModule.DataModuleDestroy(Sender: TObject);
begin
  fMRUFiles.Free;
  fProjectMRUFiles.Free;
  fHighlighters.Free;
  fUntitledNumbers.Free;
  CommandsDataModule := nil;
end;

// implementation

procedure TCommandsDataModule.AddMRUEntry(AFileName: string);
begin
  if AFileName <> '' then begin
    RemoveMRUEntry(AFileName);
    fMRUFiles.Insert(0, AFileName);
    while fMRUFiles.Count > MAX_MRU do
      fMRUFiles.Delete(fMRUFiles.Count - 1);
  end;
end;

procedure TCommandsDataModule.AddProjectMRUEntry(AFileName: string);
begin
  if AFileName <> '' then begin
    RemoveProjectMRUEntry(AFileName);
    fProjectMRUFiles.Insert(0, AFileName);
    while fProjectMRUFiles.Count > MAX_PROJECTMRU do
      fProjectMRUFiles.Delete(fProjectMRUFiles.Count - 1);
  end;
end;

function TCommandsDataModule.GetHighlighterForFile(
  AFileName: string): TSynCustomHighlighter;
begin
  if AFileName <> '' then
    Result := GetHighlighterFromFileExt(fHighlighters, ExtractFileExt(AFileName))
  else
    Result := nil;
end;

function TCommandsDataModule.GetMRUEntries: integer;
begin        
  Result := fMRUFiles.Count;
end;

function TCommandsDataModule.GetProjectMRUEntries: integer;
begin
  Result := fProjectMRUFiles.Count;
end;

function TCommandsDataModule.GetMRUEntry(Index: integer): string;
begin
  if (Index >= 0) and (Index < fMRUFiles.Count) then
    Result := fMRUFiles[Index]
  else
    Result := '';
end;

function TCommandsDataModule.GetProjectMRUEntry(Index: integer): string;
begin
  if (Index >= 0) and (Index < fProjectMRUFiles.Count) then
    Result := fProjectMRUFiles[Index]
  else
    Result := '';
end;

function TCommandsDataModule.GetSaveFileName(var ANewName: string;
  AHighlighter: TSynCustomHighlighter): boolean;
begin
  with dlgFileSave do begin
    if ANewName <> '' then begin
      InitialDir := ExtractFileDir(ANewName);
      FileName := ExtractFileName(ANewName);
    end else begin
      InitialDir := '';
      FileName := '';
    end;
    if AHighlighter <> nil then
      Filter := AHighlighter.DefaultFilter
    else
      Filter := SFilterAllFiles;
    if Execute then begin
      ANewName := FileName;
      Result := TRUE;
    end else
      Result := FALSE;
  end;
end;

function TCommandsDataModule.GetUntitledNumber: integer;
begin
  if fUntitledNumbers = nil then
    fUntitledNumbers := TBits.Create;
  Result := fUntitledNumbers.OpenBit;
  if Result = fUntitledNumbers.Size then
    fUntitledNumbers.Size := fUntitledNumbers.Size + 32;
  fUntitledNumbers[Result] := TRUE;
  Inc(Result);
end;

procedure TCommandsDataModule.ReleaseUntitledNumber(ANumber: integer);
begin
  Dec(ANumber);
  if (fUntitledNumbers <> nil) and (ANumber >= 0)
    and (ANumber < fUntitledNumbers.Size)
  then
    fUntitledNumbers[ANumber] := FALSE;
end;

procedure TCommandsDataModule.RemoveMRUEntry(AFileName: string);
var
  i: integer;
begin
  for i := fMRUFiles.Count - 1 downto 0 do begin
    if CompareText(AFileName, fMRUFiles[i]) = 0 then
      fMRUFiles.Delete(i);
  end;
end;

procedure TCommandsDataModule.RemoveProjectMRUEntry(AFileName: string);
var
  i: integer;
begin
  for i := fProjectMRUFiles.Count - 1 downto 0 do begin
    if CompareText(AFileName, fProjectMRUFiles[i]) = 0 then
      fProjectMRUFiles.Delete(i);
  end;
end;

procedure TCommandsDataModule.actFileSaveExecute(Sender: TObject);
var
  fn:String;
begin

  if ( ideFrm.filePageControl.PageCount > 0 ) then
  begin
    fn:=GI_EditorFactory.Editor[ideFrm.filePageControl.ActivePageIndex].GetFileName;
    if ( G_VersionType = TRAILVERSION )  and ( Length(GI_EditorFactory.Editor[ideFrm.filePageControl.ActivePageIndex].GetFileContent) >= MaxSaveFileSize)  then
    begin
      msgFrm.operatorMemo.Lines.Add('You are using Trial Version,you can''t save file over 2500 bytes.');
      msgFrm.operatorMemo.Lines.Add('Please login '+g_domain_web_site+' to get license.');
      exit;
    end;
    
    if (isJavaFile(fn)  and (G_CB<>nil) ) then
    begin
      if ideFrm.G_PMList.AnalysisSocket <> nil then
         ideFrm.G_PMList.AnalysisSocket.SendText('@@' + fn + #13#10)
      else if  (G_CB <> nil ) and ( ideFrm.filePageControl.PageCount > 0) then
         PostThreadMessage(G_CB.ThreadID,WM_CLASSBROWSER,Integer(GI_EditorFactory.Editor[ideFrm.filePageControl.ActivePageIndex]),0);
    end
    else
      //classBrowserFrm.classBrowserTV.items.clear;
      PostThreadMessage(G_CB.ThreadID,WM_CLASSBROWSER,0,0);
  end;

  if GI_FileCmds <> nil then
    GI_FileCmds.ExecSave;
  
end;

procedure TCommandsDataModule.actFileSaveUpdate(Sender: TObject);
begin
  actFileSave.Enabled := (GI_FileCmds <> nil) and GI_FileCmds.CanSave;
  ideFrm.actFileSaveAll.Enabled := actFileSave.Enabled;
end;

procedure TCommandsDataModule.actFileSaveAsExecute(Sender: TObject);
var
  fn:String;
begin

  if ( ideFrm.filePageControl.PageCount > 0 ) then
  begin
    fn:=GI_EditorFactory.Editor[ideFrm.filePageControl.ActivePageIndex].GetFileName;
    if ( G_VersionType = TRAILVERSION )  and ( Length(GI_EditorFactory.Editor[ideFrm.filePageControl.ActivePageIndex].GetFileContent) >= MaxSaveFileSize)  then
    begin
      msgFrm.operatorMemo.Lines.Add('You are using Trial Version,you can''t save file over 2500 bytes.');
      msgFrm.operatorMemo.Lines.Add('Please login '+g_domain_web_site+' to get license.');
      exit;
    end;
    
    if ((isJavaFile(fn)) and (G_CB<>nil) ) then
    begin
      if ideFrm.G_PMList.AnalysisSocket <> nil then
         ideFrm.G_PMList.AnalysisSocket.SendText('@@' + fn + #13#10)
      else if  (G_CB <> nil ) and ( ideFrm.filePageControl.PageCount > 0) then
         PostThreadMessage(G_CB.ThreadID,WM_CLASSBROWSER,Integer(GI_EditorFactory.Editor[ideFrm.filePageControl.ActivePageIndex]),0);
    end
    else
      //classBrowserFrm.classBrowserTV.items.clear;
      PostThreadMessage(G_CB.ThreadID,WM_CLASSBROWSER,0,0);
  end;

  if GI_FileCmds <> nil then
    GI_FileCmds.ExecSaveAs;
end;

procedure TCommandsDataModule.actFileSaveAsUpdate(Sender: TObject);
begin
  actFileSaveAs.Enabled := (GI_FileCmds <> nil) and GI_FileCmds.CanSaveAs;
end;

procedure TCommandsDataModule.actFilePrintExecute(Sender: TObject);
begin
  if GI_FileCmds <> nil then
    if dlgPrint.Execute then
    begin
      SynEditPrinter.SynEdit := GI_ActiveEditor.GetSynEditor;
      SynEditPrinter.Title := GI_ActiveEditor.GetFileName;
      SynEditPrinter.Print;
    end;
end;

procedure TCommandsDataModule.actFilePrintUpdate(Sender: TObject);
begin
  actFilePrint.Enabled := (GI_FileCmds <> nil) and GI_FileCmds.CanPrint;
end;

procedure TCommandsDataModule.actFileCloseExecute(Sender: TObject);
begin
  if GI_FileCmds <> nil then
  begin
    GI_FileCmds.ExecClose;
  end;
end;

procedure TCommandsDataModule.actFileCloseUpdate(Sender: TObject);
begin
  actFileClose.Enabled := (GI_FileCmds <> nil) and GI_FileCmds.CanClose;
end;

procedure TCommandsDataModule.actEditCutExecute(Sender: TObject);
begin
  if GI_EditCmds <> nil then
    GI_EditCmds.ExecCut;
end;

procedure TCommandsDataModule.actEditCutUpdate(Sender: TObject);
begin
  actEditCut.Enabled := (GI_EditCmds <> nil) and GI_EditCmds.CanCut;
end;

procedure TCommandsDataModule.actEditCopyExecute(Sender: TObject);
begin
  if GI_EditCmds <> nil then
    GI_EditCmds.ExecCopy;
end;

procedure TCommandsDataModule.actEditCopyUpdate(Sender: TObject);
begin
  actEditCopy.Enabled := (GI_EditCmds <> nil) and GI_EditCmds.CanCopy;
end;

procedure TCommandsDataModule.actEditPasteExecute(Sender: TObject);
begin
  if GI_EditCmds <> nil then
    GI_EditCmds.ExecPaste;
end;

procedure TCommandsDataModule.actEditPasteUpdate(Sender: TObject);
begin
  actEditPaste.Enabled := (GI_EditCmds <> nil) and GI_EditCmds.CanPaste;
end;

procedure TCommandsDataModule.actEditDeleteExecute(Sender: TObject);
begin
  if GI_EditCmds <> nil then
    GI_EditCmds.ExecDelete;
end;

procedure TCommandsDataModule.actEditDeleteUpdate(Sender: TObject);
begin
  actEditDelete.Enabled := (GI_EditCmds <> nil) and GI_EditCmds.CanDelete;
end;

procedure TCommandsDataModule.actEditSelectAllExecute(Sender: TObject);
begin
  if GI_EditCmds <> nil then
    GI_EditCmds.ExecSelectAll;
end;

procedure TCommandsDataModule.actEditSelectAllUpdate(Sender: TObject);
begin
  actEditSelectAll.Enabled := (GI_EditCmds <> nil) and GI_EditCmds.CanSelectAll;
end;

procedure TCommandsDataModule.actEditRedoExecute(Sender: TObject);
begin
  if GI_EditCmds <> nil then
    GI_EditCmds.ExecRedo;
end;

procedure TCommandsDataModule.actEditRedoUpdate(Sender: TObject);
begin
  actEditRedo.Enabled := (GI_EditCmds <> nil) and GI_EditCmds.CanRedo;
end;

procedure TCommandsDataModule.actEditUndoExecute(Sender: TObject);
begin
  if GI_EditCmds <> nil then
    GI_EditCmds.ExecUndo;

  if ( ideFrm.filePageControl.PageCount > 0) and (G_CB <> nil )then
  begin
     if not GI_EditorFactory.Editor[ideFrm.filePageControl.ActivePageIndex].GetSynEditor.Modified then
      PostThreadMessage(G_CB.ThreadID,WM_CLASSBROWSER,Integer(GI_EditorFactory.Editor[ideFrm.filePageControl.ActivePageIndex]),0);
  end;
end;

procedure TCommandsDataModule.actEditUndoUpdate(Sender: TObject);
begin
  actEditUndo.Enabled := (GI_EditCmds <> nil) and GI_EditCmds.CanUndo;
end;

procedure TCommandsDataModule.actSearchFindExecute(Sender: TObject);
begin
  if GI_SearchCmds <> nil then
    GI_SearchCmds.ExecFind;
end;

procedure TCommandsDataModule.actSearchFindUpdate(Sender: TObject);
begin
  actSearchFind.Enabled := (GI_SearchCmds <> nil) and GI_SearchCmds.CanFind;
end;

procedure TCommandsDataModule.actSearchFindNextExecute(Sender: TObject);
begin
  if GI_SearchCmds <> nil then
    GI_SearchCmds.ExecFindNext;
end;

procedure TCommandsDataModule.actSearchFindNextUpdate(Sender: TObject);
begin
  actSearchFindNext.Enabled := (GI_SearchCmds <> nil)
    and GI_SearchCmds.CanFindNext;
end;

procedure TCommandsDataModule.actSearchFindPrevExecute(Sender: TObject);
begin
  if GI_SearchCmds <> nil then
    GI_SearchCmds.ExecFindPrev;
end;

procedure TCommandsDataModule.actSearchFindPrevUpdate(Sender: TObject);
begin
  actSearchFindPrev.Enabled := (GI_SearchCmds <> nil) and GI_SearchCmds.CanFindPrev;
end;

procedure TCommandsDataModule.actSearchReplaceExecute(Sender: TObject);
begin
  if GI_SearchCmds <> nil then
    GI_SearchCmds.ExecReplace;
end;

procedure TCommandsDataModule.actSearchReplaceUpdate(Sender: TObject);
begin
  actSearchReplace.Enabled := (GI_SearchCmds <> nil)
    and GI_SearchCmds.CanReplace;
end;

procedure TCommandsDataModule.actFileSaveAllExecute(Sender: TObject);
begin
  if GI_FileCmds <> nil then
    GI_FileCmds.ExecSave;

end;

procedure TCommandsDataModule.actFileSaveAllUpdate(Sender: TObject);
begin
  actFileSaveUpdate(Sender);
end;

procedure TCommandsDataModule.actPrintSetupExecute(Sender: TObject);
begin
  dlgPrinterSetup.Execute;
end;

procedure TCommandsDataModule.actPrintReviewExecute(Sender: TObject);
begin
  if GI_FileCmds <> nil then
    GI_FileCmds.ExecPrint;
end;

procedure TCommandsDataModule.actPrintReviewUpdate(Sender: TObject);
begin
  actPrintReview.Enabled := (GI_FileCmds <> nil) and GI_FileCmds.CanPrint;
end;

end.

