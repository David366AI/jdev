unit PGMRX120Lib_TLB;

// ************************************************************************ //
// WARNING                                                                    
// -------                                                                    
// The types declared in this file were generated from data read from a       
// Type Library. If this type library is explicitly or indirectly (via        
// another type library referring to this type library) re-imported, or the   
// 'Refresh' command of the Type Library Editor activated while editing the   
// Type Library, the contents of this file will be regenerated and all        
// manual modifications will be lost.                                         
// ************************************************************************ //

// PASTLWTR : $Revision:   1.130  $
// File generated on 2003-6-27 9:42:50 from Type Library described below.

// ************************************************************************  //
// Type Lib: D:\ProGrammar120\Lib\PgmrX120.tlb (1)
// LIBID: {243BE363-0AC0-40F2-9D6D-1AD6939BE5BC}
// LCID: 0
// Helpfile: 
// DepndLst: 
//   (1) v2.0 stdole, (C:\WINNT\System32\stdole2.tlb)
//   (2) v4.0 StdVCL, (C:\WINNT\System32\stdvcl40.dll)
// Errors:
//   Error creating palette bitmap of (TPgmr) : Server d:\ProGrammar120\Lib\PgmrX120.dll contains no icons
// ************************************************************************ //
// *************************************************************************//
// NOTE:                                                                      
// Items guarded by $IFDEF_LIVE_SERVER_AT_DESIGN_TIME are used by properties  
// which return objects that may need to be explicitly created via a function 
// call prior to any access via the property. These items have been disabled  
// in order to prevent accidental use from within the object inspector. You   
// may enable them by defining LIVE_SERVER_AT_DESIGN_TIME or by selectively   
// removing them from the $IFDEF blocks. However, such items must still be    
// programmatically created via a method of the appropriate CoClass before    
// they can be used.                                                          
{$TYPEDADDRESS OFF} // Unit must be compiled without type-checked pointers. 
{$WARN SYMBOL_PLATFORM OFF}
{$WRITEABLECONST ON}

interface

uses ActiveX, Classes, Graphics, OleServer, StdVCL, Variants, Windows;
  


// *********************************************************************//
// GUIDS declared in the TypeLibrary. Following prefixes are used:        
//   Type Libraries     : LIBID_xxxx                                      
//   CoClasses          : CLASS_xxxx                                      
//   DISPInterfaces     : DIID_xxxx                                       
//   Non-DISP interfaces: IID_xxxx                                        
// *********************************************************************//
const
  // TypeLibrary Major and minor versions
  PGMRX120LibMajorVersion = 1;
  PGMRX120LibMinorVersion = 0;

  LIBID_PGMRX120Lib: TGUID = '{243BE363-0AC0-40F2-9D6D-1AD6939BE5BC}';

  IID_IPgmr: TGUID = '{A11DE5F0-E4B2-48A6-91B0-4022F58420BC}';
  CLASS_Pgmr: TGUID = '{65D9B90A-3FAA-4B2C-A8B5-E691D3399F69}';

// *********************************************************************//
// Declaration of Enumerations defined in Type Library                    
// *********************************************************************//
// Constants for enum __MIDL_IPgmr_0001
type
  __MIDL_IPgmr_0001 = TOleEnum;
const
  pgStatusUnknown = $00000000;
  pgStatusComplete = $00000001;
  pgStatusError = $00000002;
  pgStatusBreak = $00000003;
  pgStatusExternal = $00000004;

// Constants for enum __MIDL_IPgmr_0002
type
  __MIDL_IPgmr_0002 = TOleEnum;
const
  pgEventUnknown = $00000000;
  pgEventPush = $00000001;
  pgEventParse = $00000002;
  pgEventFail = $00000004;
  pgEventInputPos = $00000100;
  pgEventStep = $00000200;
  pgEventStepInc = $00000400;
  pgEventParsePos = $00000800;
  pgEventStackAll = $00000007;

// Constants for enum __MIDL_IPgmr_0003
type
  __MIDL_IPgmr_0003 = TOleEnum;
const
  pgAttrBacktrack = $00002000;
  pgAttrHidden = $00000002;
  pgAttrMatchCase = $00000004;
  pgAttrShowDelimiters = $00000400;
  pgAttrShowLiterals = $00000100;
  pgAttrShowRepeaters = $00001000;
  pgAttrTerminal = $00000001;
  pgAttrError = $00008000;
  pgAttrExternal = $00000020;
  pgAttrIgnoreCase = $00000008;
  pgAttrHideLiterals = $00000080;
  pgAttrHideDelimiters = $00000200;
  pgAttrHideRepeaters = $00000800;
  pgAttrNoBacktrack = $00004000;

// Constants for enum __MIDL_IPgmr_0004
type
  __MIDL_IPgmr_0004 = TOleEnum;
const
  pgTextAscii = $00000001;
  pgTextUnicode = $00000002;
  pgTextAutoDetect = $00000004;
  pgTextError = $00000000;

type

// *********************************************************************//
// Forward declaration of types defined in TypeLibrary                    
// *********************************************************************//
  IPgmr = interface;
  IPgmrDisp = dispinterface;

// *********************************************************************//
// Declaration of CoClasses defined in Type Library                       
// (NOTE: Here we map each CoClass to its Default Interface)              
// *********************************************************************//
  Pgmr = IPgmr;


// *********************************************************************//
// Declaration of structures, unions and aliases.                         
// *********************************************************************//

  PGStatus = __MIDL_IPgmr_0001; 
  PGEvent = __MIDL_IPgmr_0002; 
  PGAttr = __MIDL_IPgmr_0003; 
  PGTextFlags = __MIDL_IPgmr_0004; 

// *********************************************************************//
// Interface: IPgmr
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {A11DE5F0-E4B2-48A6-91B0-4022F58420BC}
// *********************************************************************//
  IPgmr = interface(IDispatch)
    ['{A11DE5F0-E4B2-48A6-91B0-4022F58420BC}']
    function  GetAPIVersion: WideString; safecall;
    function  GetParserVersion: WideString; safecall;
    function  GetDefProjectDir: WideString; safecall;
    function  SetGrammar(const GrammarPathName: WideString): SYSINT; safecall;
    function  SetStartSymbol(SymbolID: Integer): SYSINT; safecall;
    function  GetStartSymbolID: Integer; safecall;
    function  GetDefStartSymbolID: Integer; safecall;
    function  GetSymbolID(const SymbolName: WideString): Integer; safecall;
    function  GetSymbolName(SymbolID: Integer): WideString; safecall;
    function  GetGrammarVersion: WideString; safecall;
    function  LoadBinaryGrammar(const GrammarBuffer: IUnknown): SYSINT; safecall;
    function  SetInputString(const InputString: WideString): SYSINT; safecall;
    function  SetInputFilename(const PathName: WideString): SYSINT; safecall;
    function  GetInputFilename: WideString; safecall;
    function  GetInputChar(Position: Integer): Smallint; safecall;
    function  GetInputBuffer(Position: Integer; NumChars: Integer): WideString; safecall;
    function  GetInputLength: Integer; safecall;
    function  GetInputLineNumber(Position: Integer): Integer; safecall;
    function  GetInputNumLines: Integer; safecall;
    function  GetInputLinePos(LineNumber: Integer): Integer; safecall;
    function  GetInputLine(LineNumber: Integer): WideString; safecall;
    function  Parse: PGStatus; safecall;
    function  EndParse: PGStatus; safecall;
    function  SetBreakpoint(EventMask: PGEvent; EventParam: Integer): Integer; safecall;
    procedure RemoveBreakpoint(BreakpointID: Integer); safecall;
    procedure RemoveAllBreakpoints; safecall;
    function  GetCurrStatus: PGStatus; safecall;
    function  GetCurrBreakpointID: Integer; safecall;
    function  GetCurrEventType: PGEvent; safecall;
    function  GetCurrInputPos: Integer; safecall;
    function  GetCurrNodeID: Integer; safecall;
    function  GetCurrSymbolID: Integer; safecall;
    function  GetCurrStep: Integer; safecall;
    function  ParseCurrSymbol(NumChars: Integer): Integer; safecall;
    function  FailCurrSymbol: SYSINT; safecall;
    function  GetNumNodes: Integer; safecall;
    function  GetRoot: Integer; safecall;
    function  GetParent(NodeID: Integer): Integer; safecall;
    function  GetChild(NodeID: Integer; ChildIndex: Integer): Integer; safecall;
    function  GetNextSibling(NodeID: Integer): Integer; safecall;
    function  GetPrevSibling(NodeID: Integer): Integer; safecall;
    function  GetNumChildren(NodeID: Integer): Integer; safecall;
    function  GetNumDescendants(NodeID: Integer): Integer; safecall;
    function  IsLeafNode(NodeID: Integer): SYSINT; safecall;
    function  GetNodeDepth(NodeID: Integer): Integer; safecall;
    function  GetNodeIndex(NodeID: Integer): Integer; safecall;
    function  GetLabel(NodeID: Integer): WideString; safecall;
    function  GetValue(NodeID: Integer): WideString; safecall;
    function  GetValuePos(NodeID: Integer): Integer; safecall;
    function  GetValueSize(NodeID: Integer): Integer; safecall;
    function  GetNodeSymbolID(NodeID: Integer): Integer; safecall;
    function  StartSearch(const SearchPattern: WideString; StartNodeID: Integer): Integer; safecall;
    procedure EndSearch(SearchID: Integer); safecall;
    function  FindNext(SearchID: Integer): Integer; safecall;
    function  Find(const SearchPattern: WideString; StartNodeID: Integer): Integer; safecall;
    function  GetNumErrors: Integer; safecall;
    function  GetErrorSeverity(ErrorIndex: Smallint): Integer; safecall;
    function  GetErrorCode(ErrorIndex: Smallint): Integer; safecall;
    function  GetErrorDescription(ErrorIndex: Smallint): WideString; safecall;
    function  GetErrorDetails(ErrorIndex: Smallint): WideString; safecall;
    function  GetErrorDetail(ErrorIndex: Smallint; const DetailName: WideString): WideString; safecall;
    function  LoadFromCache(const CachePathName: WideString): SYSINT; safecall;
    function  SaveToCache(const CachePathName: WideString): SYSINT; safecall;
    function  PostErrorsFromTree: SYSINT; safecall;
    procedure SetStackItemData(ItemData: Integer); safecall;
    function  GetStackItemData(SearchPrevious: SYSINT): Integer; safecall;
    function  GetStackAttr(AttrID: PGAttr): SYSINT; safecall;
    function  GetSpaceChars: WideString; safecall;
    function  GetSpaceSymbolID: Integer; safecall;
    function  GetFileSize(const Filename: WideString): Integer; safecall;
    function  LoadFile(const Filename: WideString): WideString; safecall;
    procedure SetInputMode(TextFlags: PGTextFlags); safecall;
    function  LoadBinaryGrammarFromBSTR(const GrammarBuffer: WideString): SYSINT; safecall;
    function  Get_Status: PGStatus; safecall;
    property Status: PGStatus read Get_Status;
  end;

// *********************************************************************//
// DispIntf:  IPgmrDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {A11DE5F0-E4B2-48A6-91B0-4022F58420BC}
// *********************************************************************//
  IPgmrDisp = dispinterface
    ['{A11DE5F0-E4B2-48A6-91B0-4022F58420BC}']
    function  GetAPIVersion: WideString; dispid 1;
    function  GetParserVersion: WideString; dispid 2;
    function  GetDefProjectDir: WideString; dispid 3;
    function  SetGrammar(const GrammarPathName: WideString): SYSINT; dispid 4;
    function  SetStartSymbol(SymbolID: Integer): SYSINT; dispid 5;
    function  GetStartSymbolID: Integer; dispid 6;
    function  GetDefStartSymbolID: Integer; dispid 7;
    function  GetSymbolID(const SymbolName: WideString): Integer; dispid 8;
    function  GetSymbolName(SymbolID: Integer): WideString; dispid 9;
    function  GetGrammarVersion: WideString; dispid 10;
    function  LoadBinaryGrammar(const GrammarBuffer: IUnknown): SYSINT; dispid 11;
    function  SetInputString(const InputString: WideString): SYSINT; dispid 12;
    function  SetInputFilename(const PathName: WideString): SYSINT; dispid 13;
    function  GetInputFilename: WideString; dispid 14;
    function  GetInputChar(Position: Integer): Smallint; dispid 15;
    function  GetInputBuffer(Position: Integer; NumChars: Integer): WideString; dispid 16;
    function  GetInputLength: Integer; dispid 17;
    function  GetInputLineNumber(Position: Integer): Integer; dispid 18;
    function  GetInputNumLines: Integer; dispid 19;
    function  GetInputLinePos(LineNumber: Integer): Integer; dispid 20;
    function  GetInputLine(LineNumber: Integer): WideString; dispid 21;
    function  Parse: PGStatus; dispid 22;
    function  EndParse: PGStatus; dispid 23;
    function  SetBreakpoint(EventMask: PGEvent; EventParam: Integer): Integer; dispid 24;
    procedure RemoveBreakpoint(BreakpointID: Integer); dispid 25;
    procedure RemoveAllBreakpoints; dispid 26;
    function  GetCurrStatus: PGStatus; dispid 27;
    function  GetCurrBreakpointID: Integer; dispid 28;
    function  GetCurrEventType: PGEvent; dispid 29;
    function  GetCurrInputPos: Integer; dispid 30;
    function  GetCurrNodeID: Integer; dispid 31;
    function  GetCurrSymbolID: Integer; dispid 32;
    function  GetCurrStep: Integer; dispid 33;
    function  ParseCurrSymbol(NumChars: Integer): Integer; dispid 34;
    function  FailCurrSymbol: SYSINT; dispid 35;
    function  GetNumNodes: Integer; dispid 36;
    function  GetRoot: Integer; dispid 37;
    function  GetParent(NodeID: Integer): Integer; dispid 38;
    function  GetChild(NodeID: Integer; ChildIndex: Integer): Integer; dispid 39;
    function  GetNextSibling(NodeID: Integer): Integer; dispid 40;
    function  GetPrevSibling(NodeID: Integer): Integer; dispid 41;
    function  GetNumChildren(NodeID: Integer): Integer; dispid 42;
    function  GetNumDescendants(NodeID: Integer): Integer; dispid 43;
    function  IsLeafNode(NodeID: Integer): SYSINT; dispid 44;
    function  GetNodeDepth(NodeID: Integer): Integer; dispid 45;
    function  GetNodeIndex(NodeID: Integer): Integer; dispid 46;
    function  GetLabel(NodeID: Integer): WideString; dispid 47;
    function  GetValue(NodeID: Integer): WideString; dispid 48;
    function  GetValuePos(NodeID: Integer): Integer; dispid 49;
    function  GetValueSize(NodeID: Integer): Integer; dispid 50;
    function  GetNodeSymbolID(NodeID: Integer): Integer; dispid 51;
    function  StartSearch(const SearchPattern: WideString; StartNodeID: Integer): Integer; dispid 52;
    procedure EndSearch(SearchID: Integer); dispid 53;
    function  FindNext(SearchID: Integer): Integer; dispid 54;
    function  Find(const SearchPattern: WideString; StartNodeID: Integer): Integer; dispid 55;
    function  GetNumErrors: Integer; dispid 56;
    function  GetErrorSeverity(ErrorIndex: Smallint): Integer; dispid 57;
    function  GetErrorCode(ErrorIndex: Smallint): Integer; dispid 58;
    function  GetErrorDescription(ErrorIndex: Smallint): WideString; dispid 59;
    function  GetErrorDetails(ErrorIndex: Smallint): WideString; dispid 60;
    function  GetErrorDetail(ErrorIndex: Smallint; const DetailName: WideString): WideString; dispid 61;
    function  LoadFromCache(const CachePathName: WideString): SYSINT; dispid 62;
    function  SaveToCache(const CachePathName: WideString): SYSINT; dispid 63;
    function  PostErrorsFromTree: SYSINT; dispid 64;
    procedure SetStackItemData(ItemData: Integer); dispid 65;
    function  GetStackItemData(SearchPrevious: SYSINT): Integer; dispid 66;
    function  GetStackAttr(AttrID: PGAttr): SYSINT; dispid 67;
    function  GetSpaceChars: WideString; dispid 68;
    function  GetSpaceSymbolID: Integer; dispid 69;
    function  GetFileSize(const Filename: WideString): Integer; dispid 70;
    function  LoadFile(const Filename: WideString): WideString; dispid 71;
    procedure SetInputMode(TextFlags: PGTextFlags); dispid 72;
    function  LoadBinaryGrammarFromBSTR(const GrammarBuffer: WideString): SYSINT; dispid 73;
    property Status: PGStatus readonly dispid 74;
  end;

// *********************************************************************//
// The Class CoPgmr provides a Create and CreateRemote method to          
// create instances of the default interface IPgmr exposed by              
// the CoClass Pgmr. The functions are intended to be used by             
// clients wishing to automate the CoClass objects exposed by the         
// server of this typelibrary.                                            
// *********************************************************************//
  CoPgmr = class
    class function Create: IPgmr;
    class function CreateRemote(const MachineName: string): IPgmr;
  end;


// *********************************************************************//
// OLE Server Proxy class declaration
// Server Object    : TPgmr
// Help String      : Pgmr Class
// Default Interface: IPgmr
// Def. Intf. DISP? : No
// Event   Interface: 
// TypeFlags        : (2) CanCreate
// *********************************************************************//
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
  TPgmrProperties= class;
{$ENDIF}
  TPgmr = class(TOleServer)
  private
    FIntf:        IPgmr;
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
    FProps:       TPgmrProperties;
    function      GetServerProperties: TPgmrProperties;
{$ENDIF}
    function      GetDefaultInterface: IPgmr;
  protected
    procedure InitServerData; override;
    function  Get_Status: PGStatus;
  public
    constructor Create(AOwner: TComponent); override;
    destructor  Destroy; override;
    procedure Connect; override;
    procedure ConnectTo(svrIntf: IPgmr);
    procedure Disconnect; override;
    function  GetAPIVersion: WideString;
    function  GetParserVersion: WideString;
    function  GetDefProjectDir: WideString;
    function  SetGrammar(const GrammarPathName: WideString): SYSINT;
    function  SetStartSymbol(SymbolID: Integer): SYSINT;
    function  GetStartSymbolID: Integer;
    function  GetDefStartSymbolID: Integer;
    function  GetSymbolID(const SymbolName: WideString): Integer;
    function  GetSymbolName(SymbolID: Integer): WideString;
    function  GetGrammarVersion: WideString;
    function  LoadBinaryGrammar(const GrammarBuffer: IUnknown): SYSINT;
    function  SetInputString(const InputString: WideString): SYSINT;
    function  SetInputFilename(const PathName: WideString): SYSINT;
    function  GetInputFilename: WideString;
    function  GetInputChar(Position: Integer): Smallint;
    function  GetInputBuffer(Position: Integer; NumChars: Integer): WideString;
    function  GetInputLength: Integer;
    function  GetInputLineNumber(Position: Integer): Integer;
    function  GetInputNumLines: Integer;
    function  GetInputLinePos(LineNumber: Integer): Integer;
    function  GetInputLine(LineNumber: Integer): WideString;
    function  Parse: PGStatus;
    function  EndParse: PGStatus;
    function  SetBreakpoint(EventMask: PGEvent; EventParam: Integer): Integer;
    procedure RemoveBreakpoint(BreakpointID: Integer);
    procedure RemoveAllBreakpoints;
    function  GetCurrStatus: PGStatus;
    function  GetCurrBreakpointID: Integer;
    function  GetCurrEventType: PGEvent;
    function  GetCurrInputPos: Integer;
    function  GetCurrNodeID: Integer;
    function  GetCurrSymbolID: Integer;
    function  GetCurrStep: Integer;
    function  ParseCurrSymbol(NumChars: Integer): Integer;
    function  FailCurrSymbol: SYSINT;
    function  GetNumNodes: Integer;
    function  GetRoot: Integer;
    function  GetParent(NodeID: Integer): Integer;
    function  GetChild(NodeID: Integer; ChildIndex: Integer): Integer;
    function  GetNextSibling(NodeID: Integer): Integer;
    function  GetPrevSibling(NodeID: Integer): Integer;
    function  GetNumChildren(NodeID: Integer): Integer;
    function  GetNumDescendants(NodeID: Integer): Integer;
    function  IsLeafNode(NodeID: Integer): SYSINT;
    function  GetNodeDepth(NodeID: Integer): Integer;
    function  GetNodeIndex(NodeID: Integer): Integer;
    function  GetLabel(NodeID: Integer): WideString;
    function  GetValue(NodeID: Integer): WideString;
    function  GetValuePos(NodeID: Integer): Integer;
    function  GetValueSize(NodeID: Integer): Integer;
    function  GetNodeSymbolID(NodeID: Integer): Integer;
    function  StartSearch(const SearchPattern: WideString; StartNodeID: Integer): Integer;
    procedure EndSearch(SearchID: Integer);
    function  FindNext(SearchID: Integer): Integer;
    function  Find(const SearchPattern: WideString; StartNodeID: Integer): Integer;
    function  GetNumErrors: Integer;
    function  GetErrorSeverity(ErrorIndex: Smallint): Integer;
    function  GetErrorCode(ErrorIndex: Smallint): Integer;
    function  GetErrorDescription(ErrorIndex: Smallint): WideString;
    function  GetErrorDetails(ErrorIndex: Smallint): WideString;
    function  GetErrorDetail(ErrorIndex: Smallint; const DetailName: WideString): WideString;
    function  LoadFromCache(const CachePathName: WideString): SYSINT;
    function  SaveToCache(const CachePathName: WideString): SYSINT;
    function  PostErrorsFromTree: SYSINT;
    procedure SetStackItemData(ItemData: Integer);
    function  GetStackItemData(SearchPrevious: SYSINT): Integer;
    function  GetStackAttr(AttrID: PGAttr): SYSINT;
    function  GetSpaceChars: WideString;
    function  GetSpaceSymbolID: Integer;
    function  GetFileSize(const Filename: WideString): Integer;
    function  LoadFile(const Filename: WideString): WideString;
    procedure SetInputMode(TextFlags: PGTextFlags);
    function  LoadBinaryGrammarFromBSTR(const GrammarBuffer: WideString): SYSINT;
    property  DefaultInterface: IPgmr read GetDefaultInterface;
    property Status: PGStatus read Get_Status;
  published
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
    property Server: TPgmrProperties read GetServerProperties;
{$ENDIF}
  end;

{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
// *********************************************************************//
// OLE Server Properties Proxy Class
// Server Object    : TPgmr
// (This object is used by the IDE's Property Inspector to allow editing
//  of the properties of this server)
// *********************************************************************//
 TPgmrProperties = class(TPersistent)
  private
    FServer:    TPgmr;
    function    GetDefaultInterface: IPgmr;
    constructor Create(AServer: TPgmr);
  protected
    function  Get_Status: PGStatus;
  public
    property DefaultInterface: IPgmr read GetDefaultInterface;
  published
  end;
{$ENDIF}


procedure Register;

resourcestring
  dtlServerPage = 'ActiveX';

implementation

uses ComObj;

class function CoPgmr.Create: IPgmr;
begin
  Result := CreateComObject(CLASS_Pgmr) as IPgmr;
end;

class function CoPgmr.CreateRemote(const MachineName: string): IPgmr;
begin
  Result := CreateRemoteComObject(MachineName, CLASS_Pgmr) as IPgmr;
end;

procedure TPgmr.InitServerData;
const
  CServerData: TServerData = (
    ClassID:   '{65D9B90A-3FAA-4B2C-A8B5-E691D3399F69}';
    IntfIID:   '{A11DE5F0-E4B2-48A6-91B0-4022F58420BC}';
    EventIID:  '';
    LicenseKey: nil;
    Version: 500);
begin
  ServerData := @CServerData;
end;

procedure TPgmr.Connect;
var
  punk: IUnknown;
begin
  if FIntf = nil then
  begin
    punk := GetServer;
    Fintf:= punk as IPgmr;
  end;
end;

procedure TPgmr.ConnectTo(svrIntf: IPgmr);
begin
  Disconnect;
  FIntf := svrIntf;
end;

procedure TPgmr.DisConnect;
begin
  if Fintf <> nil then
  begin
    FIntf := nil;
  end;
end;

function TPgmr.GetDefaultInterface: IPgmr;
begin
  if FIntf = nil then
    Connect;
  Assert(FIntf <> nil, 'DefaultInterface is NULL. Component is not connected to Server. You must call ''Connect'' or ''ConnectTo'' before this operation');
  Result := FIntf;
end;

constructor TPgmr.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
  FProps := TPgmrProperties.Create(Self);
{$ENDIF}
end;

destructor TPgmr.Destroy;
begin
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
  FProps.Free;
{$ENDIF}
  inherited Destroy;
end;

{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
function TPgmr.GetServerProperties: TPgmrProperties;
begin
  Result := FProps;
end;
{$ENDIF}

function  TPgmr.Get_Status: PGStatus;
begin
  Result := DefaultInterface.Status;
end;

function  TPgmr.GetAPIVersion: WideString;
begin
  Result := DefaultInterface.GetAPIVersion;
end;

function  TPgmr.GetParserVersion: WideString;
begin
  Result := DefaultInterface.GetParserVersion;
end;

function  TPgmr.GetDefProjectDir: WideString;
begin
  Result := DefaultInterface.GetDefProjectDir;
end;

function  TPgmr.SetGrammar(const GrammarPathName: WideString): SYSINT;
begin
  Result := DefaultInterface.SetGrammar(GrammarPathName);
end;

function  TPgmr.SetStartSymbol(SymbolID: Integer): SYSINT;
begin
  Result := DefaultInterface.SetStartSymbol(SymbolID);
end;

function  TPgmr.GetStartSymbolID: Integer;
begin
  Result := DefaultInterface.GetStartSymbolID;
end;

function  TPgmr.GetDefStartSymbolID: Integer;
begin
  Result := DefaultInterface.GetDefStartSymbolID;
end;

function  TPgmr.GetSymbolID(const SymbolName: WideString): Integer;
begin
  Result := DefaultInterface.GetSymbolID(SymbolName);
end;

function  TPgmr.GetSymbolName(SymbolID: Integer): WideString;
begin
  Result := DefaultInterface.GetSymbolName(SymbolID);
end;

function  TPgmr.GetGrammarVersion: WideString;
begin
  Result := DefaultInterface.GetGrammarVersion;
end;

function  TPgmr.LoadBinaryGrammar(const GrammarBuffer: IUnknown): SYSINT;
begin
  Result := DefaultInterface.LoadBinaryGrammar(GrammarBuffer);
end;

function  TPgmr.SetInputString(const InputString: WideString): SYSINT;
begin
  Result := DefaultInterface.SetInputString(InputString);
end;

function  TPgmr.SetInputFilename(const PathName: WideString): SYSINT;
begin
  Result := DefaultInterface.SetInputFilename(PathName);
end;

function  TPgmr.GetInputFilename: WideString;
begin
  Result := DefaultInterface.GetInputFilename;
end;

function  TPgmr.GetInputChar(Position: Integer): Smallint;
begin
  Result := DefaultInterface.GetInputChar(Position);
end;

function  TPgmr.GetInputBuffer(Position: Integer; NumChars: Integer): WideString;
begin
  Result := DefaultInterface.GetInputBuffer(Position, NumChars);
end;

function  TPgmr.GetInputLength: Integer;
begin
  Result := DefaultInterface.GetInputLength;
end;

function  TPgmr.GetInputLineNumber(Position: Integer): Integer;
begin
  Result := DefaultInterface.GetInputLineNumber(Position);
end;

function  TPgmr.GetInputNumLines: Integer;
begin
  Result := DefaultInterface.GetInputNumLines;
end;

function  TPgmr.GetInputLinePos(LineNumber: Integer): Integer;
begin
  Result := DefaultInterface.GetInputLinePos(LineNumber);
end;

function  TPgmr.GetInputLine(LineNumber: Integer): WideString;
begin
  Result := DefaultInterface.GetInputLine(LineNumber);
end;

function  TPgmr.Parse: PGStatus;
begin
  Result := DefaultInterface.Parse;
end;

function  TPgmr.EndParse: PGStatus;
begin
  Result := DefaultInterface.EndParse;
end;

function  TPgmr.SetBreakpoint(EventMask: PGEvent; EventParam: Integer): Integer;
begin
  Result := DefaultInterface.SetBreakpoint(EventMask, EventParam);
end;

procedure TPgmr.RemoveBreakpoint(BreakpointID: Integer);
begin
  DefaultInterface.RemoveBreakpoint(BreakpointID);
end;

procedure TPgmr.RemoveAllBreakpoints;
begin
  DefaultInterface.RemoveAllBreakpoints;
end;

function  TPgmr.GetCurrStatus: PGStatus;
begin
  Result := DefaultInterface.GetCurrStatus;
end;

function  TPgmr.GetCurrBreakpointID: Integer;
begin
  Result := DefaultInterface.GetCurrBreakpointID;
end;

function  TPgmr.GetCurrEventType: PGEvent;
begin
  Result := DefaultInterface.GetCurrEventType;
end;

function  TPgmr.GetCurrInputPos: Integer;
begin
  Result := DefaultInterface.GetCurrInputPos;
end;

function  TPgmr.GetCurrNodeID: Integer;
begin
  Result := DefaultInterface.GetCurrNodeID;
end;

function  TPgmr.GetCurrSymbolID: Integer;
begin
  Result := DefaultInterface.GetCurrSymbolID;
end;

function  TPgmr.GetCurrStep: Integer;
begin
  Result := DefaultInterface.GetCurrStep;
end;

function  TPgmr.ParseCurrSymbol(NumChars: Integer): Integer;
begin
  Result := DefaultInterface.ParseCurrSymbol(NumChars);
end;

function  TPgmr.FailCurrSymbol: SYSINT;
begin
  Result := DefaultInterface.FailCurrSymbol;
end;

function  TPgmr.GetNumNodes: Integer;
begin
  Result := DefaultInterface.GetNumNodes;
end;

function  TPgmr.GetRoot: Integer;
begin
  Result := DefaultInterface.GetRoot;
end;

function  TPgmr.GetParent(NodeID: Integer): Integer;
begin
  Result := DefaultInterface.GetParent(NodeID);
end;

function  TPgmr.GetChild(NodeID: Integer; ChildIndex: Integer): Integer;
begin
  Result := DefaultInterface.GetChild(NodeID, ChildIndex);
end;

function  TPgmr.GetNextSibling(NodeID: Integer): Integer;
begin
  Result := DefaultInterface.GetNextSibling(NodeID);
end;

function  TPgmr.GetPrevSibling(NodeID: Integer): Integer;
begin
  Result := DefaultInterface.GetPrevSibling(NodeID);
end;

function  TPgmr.GetNumChildren(NodeID: Integer): Integer;
begin
  Result := DefaultInterface.GetNumChildren(NodeID);
end;

function  TPgmr.GetNumDescendants(NodeID: Integer): Integer;
begin
  Result := DefaultInterface.GetNumDescendants(NodeID);
end;

function  TPgmr.IsLeafNode(NodeID: Integer): SYSINT;
begin
  Result := DefaultInterface.IsLeafNode(NodeID);
end;

function  TPgmr.GetNodeDepth(NodeID: Integer): Integer;
begin
  Result := DefaultInterface.GetNodeDepth(NodeID);
end;

function  TPgmr.GetNodeIndex(NodeID: Integer): Integer;
begin
  Result := DefaultInterface.GetNodeIndex(NodeID);
end;

function  TPgmr.GetLabel(NodeID: Integer): WideString;
begin
  Result := DefaultInterface.GetLabel(NodeID);
end;

function  TPgmr.GetValue(NodeID: Integer): WideString;
begin
  Result := DefaultInterface.GetValue(NodeID);
end;

function  TPgmr.GetValuePos(NodeID: Integer): Integer;
begin
  Result := DefaultInterface.GetValuePos(NodeID);
end;

function  TPgmr.GetValueSize(NodeID: Integer): Integer;
begin
  Result := DefaultInterface.GetValueSize(NodeID);
end;

function  TPgmr.GetNodeSymbolID(NodeID: Integer): Integer;
begin
  Result := DefaultInterface.GetNodeSymbolID(NodeID);
end;

function  TPgmr.StartSearch(const SearchPattern: WideString; StartNodeID: Integer): Integer;
begin
  Result := DefaultInterface.StartSearch(SearchPattern, StartNodeID);
end;

procedure TPgmr.EndSearch(SearchID: Integer);
begin
  DefaultInterface.EndSearch(SearchID);
end;

function  TPgmr.FindNext(SearchID: Integer): Integer;
begin
  Result := DefaultInterface.FindNext(SearchID);
end;

function  TPgmr.Find(const SearchPattern: WideString; StartNodeID: Integer): Integer;
begin
  Result := DefaultInterface.Find(SearchPattern, StartNodeID);
end;

function  TPgmr.GetNumErrors: Integer;
begin
  Result := DefaultInterface.GetNumErrors;
end;

function  TPgmr.GetErrorSeverity(ErrorIndex: Smallint): Integer;
begin
  Result := DefaultInterface.GetErrorSeverity(ErrorIndex);
end;

function  TPgmr.GetErrorCode(ErrorIndex: Smallint): Integer;
begin
  Result := DefaultInterface.GetErrorCode(ErrorIndex);
end;

function  TPgmr.GetErrorDescription(ErrorIndex: Smallint): WideString;
begin
  Result := DefaultInterface.GetErrorDescription(ErrorIndex);
end;

function  TPgmr.GetErrorDetails(ErrorIndex: Smallint): WideString;
begin
  Result := DefaultInterface.GetErrorDetails(ErrorIndex);
end;

function  TPgmr.GetErrorDetail(ErrorIndex: Smallint; const DetailName: WideString): WideString;
begin
  Result := DefaultInterface.GetErrorDetail(ErrorIndex, DetailName);
end;

function  TPgmr.LoadFromCache(const CachePathName: WideString): SYSINT;
begin
  Result := DefaultInterface.LoadFromCache(CachePathName);
end;

function  TPgmr.SaveToCache(const CachePathName: WideString): SYSINT;
begin
  Result := DefaultInterface.SaveToCache(CachePathName);
end;

function  TPgmr.PostErrorsFromTree: SYSINT;
begin
  Result := DefaultInterface.PostErrorsFromTree;
end;

procedure TPgmr.SetStackItemData(ItemData: Integer);
begin
  DefaultInterface.SetStackItemData(ItemData);
end;

function  TPgmr.GetStackItemData(SearchPrevious: SYSINT): Integer;
begin
  Result := DefaultInterface.GetStackItemData(SearchPrevious);
end;

function  TPgmr.GetStackAttr(AttrID: PGAttr): SYSINT;
begin
  Result := DefaultInterface.GetStackAttr(AttrID);
end;

function  TPgmr.GetSpaceChars: WideString;
begin
  Result := DefaultInterface.GetSpaceChars;
end;

function  TPgmr.GetSpaceSymbolID: Integer;
begin
  Result := DefaultInterface.GetSpaceSymbolID;
end;

function  TPgmr.GetFileSize(const Filename: WideString): Integer;
begin
  Result := DefaultInterface.GetFileSize(Filename);
end;

function  TPgmr.LoadFile(const Filename: WideString): WideString;
begin
  Result := DefaultInterface.LoadFile(Filename);
end;

procedure TPgmr.SetInputMode(TextFlags: PGTextFlags);
begin
  DefaultInterface.SetInputMode(TextFlags);
end;

function  TPgmr.LoadBinaryGrammarFromBSTR(const GrammarBuffer: WideString): SYSINT;
begin
  Result := DefaultInterface.LoadBinaryGrammarFromBSTR(GrammarBuffer);
end;

{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
constructor TPgmrProperties.Create(AServer: TPgmr);
begin
  inherited Create;
  FServer := AServer;
end;

function TPgmrProperties.GetDefaultInterface: IPgmr;
begin
  Result := FServer.DefaultInterface;
end;

function  TPgmrProperties.Get_Status: PGStatus;
begin
  Result := DefaultInterface.Status;
end;

{$ENDIF}

procedure Register;
begin
  RegisterComponents(dtlServerPage, [TPgmr]);
end;

end.
