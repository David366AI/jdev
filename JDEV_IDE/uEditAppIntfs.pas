unit uEditAppIntfs;

{$I SynEdit.inc}

interface

uses
  Windows, Classes, Forms, ComCtrls,menus,SynEditExt;

type
  IEditCommands = interface
    function CanCopy: boolean;
    function CanCut: boolean;
    function CanDelete: boolean;
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
  end;

  IFileCommands = interface
    function CanClose: boolean;
    function CanPrint: boolean;
    function CanSave: boolean;
    function CanSaveAs:boolean;
    procedure ExecClose;
    procedure ExecPrint;
    procedure ExecSave;
    procedure ExecSaveAs;
  end;

  ISearchCommands = interface
    function CanFind: boolean;
    function CanFindNext: boolean;
    function CanFindPrev: boolean;
    function CanReplace: boolean;
    procedure ExecFind;
    procedure ExecFindNext;
    procedure ExecFindPrev;
    procedure ExecReplace;
  end;

  IEditor = interface
    procedure Activate;
    function AskSaveChanges: boolean;
    function CanClose: boolean;
    procedure Close;
    procedure Save;
    function GetSynEditor:TSynEditExt;
    function GetFileContent:String;
    function GetCaretPos: TPoint;
    function GetEditorState: string;
    function GetFileName: string;
    function GetPageIndex: Integer;
    procedure SetPageIndex(index:Integer);
    procedure SetFileName(afile: string);
    function GetFileTitle: string;
    function GetModified: boolean;
    procedure OpenFile(AFileName: string;packageName:String);
    procedure SetMenuItem(item:TMenuItem);
    function GetMenuItem:TMenuItem;
    procedure SetFileCmds;
  end;

  IEditorFactory = interface
    function CanCloseAll: boolean;
    procedure CloseAll;
    function CreateBorderless(AOwner: TForm;Index:Integer): IEditor;
    function CreateMDIChild(AOwner: TForm;Index:Integer): IEditor;
    function CreateTabSheet(AOwner: TPageControl;Index:integer): IEditor;
    function GetEditorCount: integer;
    function GetEditor(Index: integer): IEditor;
    function GetEditorByName(fn:String): IEditor;
    procedure RemoveEditor(AEditor: IEditor);
    property Editor[Index: integer]: IEditor read GetEditor;
  end;


var
  GI_EditorFactory: IEditorFactory;

  GI_ActiveEditor: IEditor;

  GI_EditCmds: IEditCommands;
  GI_FileCmds: IFileCommands;
  GI_SearchCmds: ISearchCommands;

implementation

end.

