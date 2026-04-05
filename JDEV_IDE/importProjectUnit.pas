unit importProjectUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, FileCtrl, DirDialog,uCommandData,UnZip32;

type
  TimportProjectFrm = class(TForm)
    GroupBox1: TGroupBox;
    jarFileListBox: TFileListBox;
    GroupBox2: TGroupBox;
    importBtn: TButton;
    cancelBtn: TButton;
    commentMemo: TMemo;
    jarFilePathEdit: TEdit;
    browserJarBtn: TButton;
    Label4: TLabel;
    Label1: TLabel;
    projectSavePathEdit: TEdit;
    browserSaveBtn: TButton;
    jarDirDialog: TDirDialog;
    projectDirDialog: TDirDialog;
    procedure FormCreate(Sender: TObject);
    procedure browserJarBtnClick(Sender: TObject);
    procedure jarFileListBoxChange(Sender: TObject);
    procedure importBtnClick(Sender: TObject);
    procedure browserSaveBtnClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
  public
    jarFileName:String;
    destPath:String;
    projectName:String;
    projectFileName:String;
  end;

    { user functions for use with the TUserFunctions structure }
    procedure Set_UserFunctions(var Z: TUserFunctions);
    function DllPrnt(Buffer: PChar; Size: ULONG): integer; stdcall;
    function DllPassword(P: PChar; N: Integer; M, Name: PChar): integer; stdcall;
    function DllService(CurFile: PChar; Size: ULONG): integer; stdcall;
    function DllReplace(FileName: PChar): integer; stdcall;
    procedure DllMessage(UnCompSize : ULONG;
                         CompSize   : ULONG;
                         Factor     : UINT;
                         Month      : UINT;
                         Day        : UINT;
                         Year       : UINT;
                         Hour       : UINT;
                         Minute     : UINT;
                         C          : Char;
                         FileName   : PChar;
                         MethBuf    : PChar;
                         CRC        : ULONG;
                         Crypt      : Char); stdcall;



implementation
uses
  ideUnit;
{$R *.dfm}

procedure TimportProjectFrm.FormCreate(Sender: TObject);
begin
   jarDirDialog.Directory:=g_versionDataPath ;
end;

procedure TimportProjectFrm.browserJarBtnClick(Sender: TObject);
begin
  if jarDirDialog.Execute then
  begin
    jarFilePathEdit.Text:= jarDirDialog.Directory;
    jarFileListBox.Directory:=jarDirDialog.Directory;
    if jarFileListBox.Items.Count > 0 then
      jarFileListBox.ItemIndex:=0;
  end;
end;

procedure TimportProjectFrm.jarFileListBoxChange(Sender: TObject);
var
  UF   : TUserFunctions;
  Opt     : TDCL;
begin
  if jarFileListBox.Items.Count > 0 then
  begin
    commentMemo.Lines.Clear;
    if jarFileListBox.itemIndex < 0 then
      jarFileListBox.itemIndex:=0;
    { set user functions }
    Set_UserFunctions(UF);

    with Opt do
    begin
    ExtractOnlyNewer  := Integer(false);
    SpaceToUnderscore := Integer(false);
    PromptToOverwrite := Integer(false);
    fQuiet            := 0;
    nCFlag            := Integer(false);
    nTFlag            := Integer(false);
    nVFlag            := Integer(false);
    nUFlag            := Integer(false);
    nZFlag            := Integer(true);
    nDFlag            := Integer(false);
    nOFlag            := Integer(false);
    nAFlag            := Integer(false);
    nZIFlag           := Integer(false);
    C_flag            := Integer(false);
    fPrivilege        := 1;
    lpszExtractDir    := PChar(g_tempFilePath);
    jarFileName:=     GetRealPath(jarFilePathEdit.Text)+jarFileListBox.items[jarFileListBox.itemIndex];
    lpszZipFN         := PChar(jarFileName);
  end;


    Wiz_SingleEntryUnzip(0,    { number of file names being passed }
                         nil,  { file names to be unarchived }
                         0,    { number of "file names to be excluded from processing" being  passed }
                         nil,  { file names to be excluded from the unarchiving process }
                         Opt,  { pointer to a structure with the flags for setting the  various options }
                         UF);  { pointer to a structure that contains pointers to user functions }

  end else
    commentMemo.Lines.Clear;
end;
function DllPrnt(Buffer: PChar; Size: ULONG): integer;
var
  index:Integer;
  s:String;
begin
  s:=Buffer;
  while true do
  begin
    index:=pos(#10,s);
    if index <= 0 then
      break;
    importProjectFrm.commentMemo.lines.add(copy(s,1,index-1));
    s:=Copy(s,index+1,length(s));
  end;
  importProjectFrm.commentMemo.CaretPos:=Point(1,1);
  Result := Size;
end;
{----------------------------------------------------------------------------------}
function DllPassword(P: PChar; N: Integer; M, Name: PChar): integer;
begin
  Result := 1;
end;
{----------------------------------------------------------------------------------}
function DllService(CurFile: PChar; Size: ULONG): integer;
begin
  Result := 0;
end;
{----------------------------------------------------------------------------------}
function DllReplace(FileName: PChar): integer;
begin
  Result := 1;
end;
{----------------------------------------------------------------------------------}
procedure DllMessage(UnCompSize : ULONG;
                     CompSize   : ULONG;
                     Factor     : UINT;
                     Month      : UINT;
                     Day        : UINT;
                     Year       : UINT;
                     Hour       : UINT;
                     Minute     : UINT;
                     C          : Char;
                     FileName   : PChar;
                     MethBuf    : PChar;
                     CRC        : ULONG;
                     Crypt      : Char);
begin
end;
procedure Set_UserFunctions(var Z:TUserFunctions);
begin
  { prepare TUserFunctions structure }
  with Z do
  begin
    @Print                  := @DllPrnt;
    @Sound                  := nil;
    @Replace                := @DllReplace;
    @Password               := @DllPassword;
    @SendApplicationMessage := @DllMessage;
    @ServCallBk             := @DllService;
  end;      
end;

procedure TimportProjectFrm.importBtnClick(Sender: TObject);
var
  index:Integer;
begin
  if jarFileListBox.ItemIndex < 0 then
  begin
    showerror(self.Handle,getErrorMsg('PleaseSlectOneVersion'),getErrorMsg('ErrorDlgCaption'),MB_OK );
    self.ModalResult:=mrNone;
    exit;
  end;
  if projectSavePathEdit.Text = '' then
  begin
    showerror(self.Handle,getErrorMsg('PleaseSelectDirectory'),getErrorMsg('ErrorDlgCaption'),MB_OK );
    self.ModalResult:=mrNone;
    exit;
  end;
  if (commentMemo.Lines.Count < 0)  or (Pos(JDEVJARFILETAG,commentMemo.Lines[0]) <=0 ) then
  begin
    showerror(self.Handle,getErrorMsg('NotJdevVersion'),getErrorMsg('ErrorDlgCaption'),MB_OK );
    self.ModalResult:=mrNone;
    exit;
  end;
  if commentMemo.Lines.Count >=2 then
  begin
    index:=Pos(JDEVJARFILETAG,commentMemo.Lines[0]);
    projectFileName:=Copy(commentMemo.Lines[0],index+length(JDEVJARFILETAG),length(commentMemo.Lines[0]));
    index:=Pos('project name=',commentMemo.Lines[1]);
    projectName:=Copy(commentMemo.Lines[1],index+length('project name='),length(commentMemo.Lines[1]));
    if DirectoryExists(GetRealPath(destPath)+ projectName) then
    begin
      showerror(self.Handle,Format(getErrorMsg('ProjectExists'),[projectName,destPath]),getErrorMsg('ErrorDlgCaption'),MB_OK );
      self.ModalResult:=mrNone;
    end;
  end;
end;

procedure TImportProjectFrm.browserSaveBtnClick(Sender: TObject);
begin
  if projectDirDialog.Execute then
  begin
    projectSavePathEdit.Text:= projectDirDialog.Directory;
    destPath:=projectDirDialog.Directory;
  end;

end;

procedure TimportProjectFrm.FormShow(Sender: TObject);
begin
  jarFileListBox.Update;
end;

end.
