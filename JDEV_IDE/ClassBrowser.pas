unit ClassBrowser;

interface
uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, OleServer, PGMRX120Lib_TLB, StdCtrls,
  ComCtrls, ImgList, ExtCtrls,Controls,uCommandData,uEditAppIntfs,SynEditExt;
const
  IMAGE_JAVAFILE     =  0 ;
  IMAGE_PACKAGE      =  1 ;
  IMAGE_IMPORT       =  2 ;
  IMAGE_CLASS        =  3 ;
  IMAGE_INTERFACE    =  4 ;
  IMAGE_FIELD        =  5 ;
  IMAGE_METHOD       =  6 ;
  IMAGE_STATIC       =  7 ;
  IMAGE_CONSTRUCTOR  =  8 ;
  WM_CLASSBROWSER = WM_USER + 10004;

  ROOT_TYPE          = 0 ;
  PACKAGE_TYPE       = 1 ;
  IMPORT_TYPE        = 2 ;
  CLASS_TYPE         = 3 ;
  INTERFACE_TYPE     = 4 ;
  FIELD_TYPE         = 5 ;
  METHOD_TYPE        = 6 ;
  STATIC_TYPE        = 7 ;
  CONSTRUCTOR_TYPE   = 8 ;

  MaxPopListNumber   =  30;
type
  TNodeData = class
   id:Integer;
   nodeType:Integer;
   StartPos:Integer;
   NumChars:Integer;
  end;

  TClassBrowser = class(TThread)
  private
    anaysisCom: TPgmr;
    fTreeView: TTreeView;
    fFileName:String;
    fMemo:TSynEditExt;
    content:WideString;
    editor:IEditor;
    analysisNumber:Integer;
    flag:Integer;
  protected
    procedure refresh;
    procedure Execute; override;
  public
    constructor Create(fgpmr:TPgmr;tv:TTreeView;errorMemo:TSynEditExt);
    destructor Destroy;override;
    function DoParse(fileName,s:String):Boolean;overload;
    procedure DoParse(id:integer;node:TTreeNode);overload;
    procedure Translate(id:integer;node:TTreeNode);
    procedure doPackage(id:Integer;node:TTreeNode);
    procedure doImport(id:Integer;node:TTreeNode);
    procedure doType_Declaration(id:Integer;node:TTreeNode);
    procedure doField_Declarations(id:Integer;node:TTreeNode);
    procedure doVariable_Declarations(id:Integer;node:TTreeNode);
    procedure doContructor_Declaration(id:Integer;node:TTreeNode);
    procedure doMethod_Declaration(id:Integer;node:TTreeNode);
    procedure doStatement_Block(id:Integer;node:TTreeNode);
    function TranslateLongToPoint(x:Integer):TPoint;
  end;

implementation
uses
   ideUnit,Encrypt;
Constructor TClassBrowser.Create(fgpmr:TPgmr;tv:TTreeView;errorMemo:TSynEditExt);
begin
    anaysisCom:=fgpmr;
    fTreeView:= tv;
    fMemo := errorMemo;
    inherited Create(true);
end;

destructor TClassBrowser.Destroy;
var
  i:Integer;
begin
  if not Assigned(fTreeView) then
    exit;
  for i:=fTreeView.Items.Count-1 downto 0 do
  begin
    if fTreeView.Items.Item[i].data <> nil then
    begin
       TNodeData(fTreeView.Items.Item[i].data).Free;
       fTreeView.Items.Item[i].data:=nil;
    end;
    fTreeView.Items.Delete(fTreeView.Items.Item[i]);
  end;
end;

procedure TClassBrowser.Execute;
var
  msgContent:TMsg;
begin
  while( not Terminated) do
  begin
    GetMessage(msgContent,0,WM_CLASSBROWSER,WM_CLASSBROWSER);
    flag:=msgContent.wParam;
    Synchronize(refresh);
  end;
end;

procedure TClassBrowser.refresh;
var
  i:Integer;
begin
  if ( G_VersionType = TRAILVERSION )  and ( analysisNumber >= MaxPopListNumber)  then
  begin
    fMemo.Lines.Add('Trial Version only permit using 30 class analysis.');
    fMemo.Lines.Add('Please login '+g_domain_web_site+' to get license.');
    exit;
  end;

  if not Assigned(fTreeView) then
    exit;

  for i:=0 to  fTreeView.Items.Count - 1 do
  begin
    if fTreeView.Items[i].data <> nil then
    begin
       TNodeData(fTreeView.Items[i].data).Free;
       fTreeView.Items[i].data:= nil;
    end;
  end;
  fTreeView.Items.Clear;

  if flag <> 0 then
  begin
    try
      editor := IEditor(flag);
      DoParse(editor.GetFileName,editor.GetFileContent);
      analysisNumber := analysisNumber + 1;
    except
      exit;
    end;
  end;
end;

function TClassBrowser.DoParse(filename,s:String):Boolean;
var
   id1,id2:Integer;
   ParseStatus:Integer;
   rootNode:TTreeNode;
begin
  try
    content:=s;
    fFileName:=filename;
    if anaysisCom = nil then
      exit;
    anaysisCom.SetInputString(s);
    ParseStatus:=anaysisCom.Parse;
    if (ParseStatus = pgStatusComplete) then
    begin
      id1:=anaysisCom.GetRoot;    //root node
      id2:=anaysisCom.GetChild(id1,0);       //complipation_unit node
      rootNode:=fTreeView.Items.Add(nil,'Root');
      rootNode.ImageIndex := IMAGE_JAVAFILE;
      rootNode.SelectedIndex := IMAGE_JAVAFILE;
      DoParse(id2,rootNode);
      //Translate(id2,rootNode);
    end;
    rootNode.Expand(true);

    if anaysisCom.GetNumErrors > 0 then
    begin
      result:=false;
      fMemo.Lines.Add(filename + getErrorMsg('FileParseError'));
      fMemo.ChangeBreakPoint(fMemo.Lines.Count);
    end
    else
      result:=true;
      
  except
    raise Exception.Create('Parse error!');
  end;
  
end;

procedure TClassBrowser.DoParse(id:Integer;node:TTreeNode);
var
   i:Integer;
begin
     if Terminated then exit;
     for i:=0 to anaysisCom.GetNumChildren(id)-1 do
      if anaysisCom.GetLabel(anaysisCom.GetChild(id,i)) = 'package_statement' then
      begin
        doPackage(anaysisCom.GetChild(id,i),node);
      end else if anaysisCom.GetLabel(anaysisCom.GetChild(id,i)) = 'import_statement' then
      begin
        doImport(anaysisCom.GetChild(id,i),node);
      end else  if anaysisCom.GetLabel(anaysisCom.GetChild(id,i)) = 'type_declaration' then
      begin
        doType_Declaration(anaysisCom.GetChild(id,i),node);
      end;
end;

procedure TClassBrowser.Translate(id:Integer;node:TTreeNode);
var
  i:Integer;
  //SymbolID:Integer;
  p_node:TTreeNode;
begin
  if id = 0 then
    exit;

    p_node:=fTreeView.Items.AddChild(node,anaysisCom.GetLabel(id)+'   '+anaysisCom.GetValue(id));
    for i:=0 to anaysisCom.GetNumChildren(id)-1 do
    begin
      Translate(anaysisCom.GetChild(id,i),p_node);
    end;

end;
procedure TClassBrowser.doPackage(id:Integer;node:TTreeNode);
var
  i:Integer;
  innerNode:TTreeNode;
  nodeData:TNodeData;
begin
  if Terminated then exit;
  for i:=0 to anaysisCom.GetNumChildren(id)-1 do
  if anaysisCom.GetLabel( anaysisCom.GetChild(id,i))='package_name' then
  begin
    innerNode:=fTreeView.Items.AddChild(node,'package  '+anaysisCom.GetValue( anaysisCom.GetChild(id,i)));
    innerNode.ImageIndex := IMAGE_PACKAGE;
    innerNode.SelectedIndex := IMAGE_PACKAGE;
    nodeData:=TNodeData.Create;
    nodeData.id:=id;
    nodeData.nodeType:=PACKAGE_TYPE;
    nodeData.StartPos:=anaysisCom.GetValuePos(id);
    nodeData.NumChars:=anaysisCom.GetValueSize(id);
    innerNode.Data:=nodeData;
    break;
  end;
end;
procedure TClassBrowser.doImport(id:Integer;node:TTreeNode);
var
  index:Integer;
  innerNode:TTreeNode;
  nodeData:TNodeData;
  s:String;
begin
    if Terminated then exit;
    s :=  anaysisCom.GetValue(id);
    index:=pos('import ',s);
    if index > 0 then
      s := copy(s,index+Length('import '),Length(s)-Length('import ')-1)
    else
      ;//ÏÔÊ¾´íÎó£¬importÓï·¨´íÎó£»
    innerNode:=fTreeView.Items.AddChild(node,'import  '+ s);
    innerNode.ImageIndex := IMAGE_IMPORT;
    innerNode.SelectedIndex := IMAGE_IMPORT;
    nodeData:=TNodeData.Create;
    nodeData.id:=id;
    nodeData.nodeType:=IMPORT_TYPE;
    nodeData.StartPos:=anaysisCom.GetValuePos(id);
    nodeData.NumChars:=anaysisCom.GetValueSize(id);
    innerNode.Data:=nodeData;
end;

procedure TClassBrowser.doType_Declaration(id:Integer;node:TTreeNode);
var
  i,j,classID,childID:Integer;
  innerNode:TTreeNode;
  nodeData:TNodeData;
begin
  if Terminated then exit;
  for i:=0 to anaysisCom.GetNumChildren(id)-1 do
  begin
    classID := anaysisCom.GetChild(id,i) ;
    if anaysisCom.GetLabel(classID) = 'class_declaration' then  //class declaration
    begin
       for j:=0 to anaysisCom.GetNumChildren(classID)-1 do
       begin
         childID := anaysisCom.GetChild(classID,j);
         if anaysisCom.GetLabel(childID) = 'class_name' then  //class_name declaration
         begin
           innerNode:=fTreeView.Items.AddChild(node,anaysisCom.GetValue(childID));
           innerNode.ImageIndex := IMAGE_CLASS;
           innerNode.SelectedIndex := IMAGE_CLASS;
           nodeData:=TNodeData.Create;
           nodeData.id:=childID;
           nodeData.nodeType:=CLASS_TYPE;
           nodeData.StartPos:=anaysisCom.GetValuePos(childID);
           nodeData.NumChars:=anaysisCom.GetValueSize(childID);
           innerNode.Data:=nodeData;
         end;
         if anaysisCom.GetLabel(childID) = 'field_declarations' then  //Field declarations
         begin
           doField_Declarations(childID,innerNode);
         end;
       end;
    end;
    if anaysisCom.GetLabel(classID) = 'interface_declaration' then  //interface_declaration declaration
    begin
       for j:=0 to anaysisCom.GetNumChildren(classID)-1 do
       begin
         childID := anaysisCom.GetChild(classID,j);
         if anaysisCom.GetLabel(childID) = 'interface_name' then  //interface_declaration declaration
         begin
           innerNode:=fTreeView.Items.AddChild(node,anaysisCom.GetValue(childID));
           innerNode.ImageIndex := IMAGE_INTERFACE;
           innerNode.SelectedIndex := IMAGE_INTERFACE;
           nodeData:=TNodeData.Create;
           nodeData.id:=childID;
           nodeData.nodeType:=INTERFACE_TYPE;
           nodeData.StartPos:=anaysisCom.GetValuePos(childID);
           nodeData.NumChars:=anaysisCom.GetValueSize(childID);
           innerNode.Data:=nodeData;
         end;
         if anaysisCom.GetLabel(childID) = 'field_declarations' then  //Field declarations
         begin
           doField_Declarations(childID,innerNode);
         end;
       end;
    end;

  end;
end;

procedure TClassBrowser.doField_Declarations(id:Integer;node:TTreeNode);
var
  i,j,m,fieldID,childID:Integer;
  innerNode:TTreeNode;
  nodeData:TNodeData;
begin
  if Terminated then exit;
  for i:=0 to anaysisCom.GetNumChildren(id)-1 do
  begin
    fieldID := anaysisCom.GetChild(id,i) ;
    if anaysisCom.GetLabel(fieldID) = 'field_declaration' then  //field declaration
    begin
       for j:=0 to anaysisCom.GetNumChildren(fieldID)-1 do
       begin
         childID := anaysisCom.GetChild(fieldID,j);
         if anaysisCom.GetLabel(childID) = 'static_initializer' then  //static_initializer
         begin
           innerNode:=fTreeView.Items.AddChild(node,'statc initializer');
           innerNode.ImageIndex := IMAGE_STATIC;
           innerNode.SelectedIndex := IMAGE_STATIC;
           nodeData:=TNodeData.Create;
           nodeData.id:=childID;
           nodeData.nodeType:=STATIC_TYPE;
           nodeData.StartPos:=anaysisCom.GetValuePos(childID);
           nodeData.NumChars:=anaysisCom.GetValueSize(childID);
           innerNode.Data:=nodeData;
         end;
         if anaysisCom.GetLabel(childID) = 'variable_declaration' then  //variable_declaration
         begin
           for m:=0 to anaysisCom.GetNumChildren(childID)-1  do
           if anaysisCom.GetLabel(anaysisCom.GetChild(childID,m)) = 'variable_declarators' then
             doVariable_Declarations(anaysisCom.GetChild(childID,m),node);
         end;
         if anaysisCom.GetLabel(childID) = 'constructor_declaration' then  //Contructor declaration
         begin
           doContructor_Declaration(childID,node);
         end;
         if anaysisCom.GetLabel(childID) = 'method_declaration' then  //method_declaration
         begin
           doMethod_Declaration(childID,node);
         end;
         if anaysisCom.GetLabel(childID) = 'type_declaration' then  //class declaration
         begin
           doType_Declaration(childID,node);
         end;
       end;
    end;

  //Translate(fieldID,node);
  end;
end;
procedure TClassBrowser.doVariable_Declarations(id:Integer;node:TTreeNode);
var
  i,j,fieldID,identID:Integer;
  innerNode:TTreeNode;
  nodeData:TNodeData;
begin
  if Terminated then exit;
  for i:=0 to anaysisCom.GetNumChildren(id)-1 do
  begin
    fieldID := anaysisCom.GetChild(id,i) ;
    if anaysisCom.GetLabel(fieldID) = 'variable_declarator' then  //variable_declarator
    begin
      for j:=0 to anaysisCom.GetNumChildren(fieldID)-1 do
      begin
       identID := anaysisCom.GetChild(fieldID,j) ;
       if anaysisCom.GetLabel(identID) = 'ident' then  //ident declaration
       begin

          innerNode:=fTreeView.Items.AddChild(node,anaysisCom.GetValue(identID));
          innerNode.ImageIndex := IMAGE_FIELD;
          innerNode.SelectedIndex := IMAGE_FIELD;
          nodeData:=TNodeData.Create;
          nodeData.id:=identID;
          nodeData.nodeType:=FIELD_TYPE;
          nodeData.StartPos:=anaysisCom.GetValuePos(identID);
          nodeData.NumChars:=anaysisCom.GetValueSize(identID);
          innerNode.Data:=nodeData;
       end;
      end;
    end;
  end;
end;

procedure TClassBrowser.doStatement_Block(id:Integer;node:TTreeNode);
var
  i,childID:Integer;
  //p_node:TTreeNode;
begin
    if Terminated then exit;
    if id = 0 then
      exit;
    for i:=0 to anaysisCom.GetNumChildren(id)-1 do
    begin
      childID:= anaysisCom.GetChild(id,i);
      if anaysisCom.GetLabel(childID) = 'type_declaration' then  //type_declaration
        doType_Declaration(childID,node)
      else  //others
      begin
        doStatement_Block(childID,node);
      end;

    end;

end;

procedure TClassBrowser.doContructor_Declaration(id:Integer;node:TTreeNode);
var
  index:Integer;
  innerNode:TTreeNode;
  nodeData:TNodeData;
  s:String;
begin
  if Terminated then exit;
  s:= anaysisCom.GetValue(id);
  index:=pos(')',s);
  if index > 0 then
     s:=copy(s,1,index);
  innerNode:=fTreeView.Items.AddChild(node,s);
  innerNode.ImageIndex := IMAGE_CONSTRUCTOR;
  innerNode.SelectedIndex := IMAGE_CONSTRUCTOR;
  nodeData:=TNodeData.Create;
  nodeData.id:=id;
  nodeData.nodeType:=CONSTRUCTOR_TYPE;
  nodeData.StartPos:=anaysisCom.GetValuePos(id);
  nodeData.NumChars:=index;
  innerNode.Data:=nodeData;
end;

procedure TClassBrowser.doMethod_Declaration(id:Integer;node:TTreeNode);
var
  index,i,statmentID:Integer;
  innerNode:TTreeNode;
  nodeData:TNodeData;
  s:String;
begin
  if Terminated then exit;
  s:= anaysisCom.GetValue(id);
  index:=pos(')',s);
  if index > 0 then
     s:=copy(s,1,index);
  innerNode:=fTreeView.Items.AddChild(node,s);
  innerNode.ImageIndex := IMAGE_METHOD;
  innerNode.SelectedIndex := IMAGE_METHOD;

  nodeData:=TNodeData.Create;
  nodeData.id:=id;
  nodeData.nodeType:=METHOD_TYPE;
  nodeData.StartPos:=anaysisCom.GetValuePos(id);
  nodeData.NumChars:=index;
  //nodeData.blockEnd := anaysisCom.GetValuePos(id) + anaysisCom.GetValueSize(id);
  innerNode.Data:=nodeData;

  for i:=0 to anaysisCom.GetNumChildren(id)-1 do
  begin
    statmentID := anaysisCom.GetChild(id,i) ;
    if anaysisCom.GetLabel(statmentID) = 'statement_block' then  //statement_block
    begin
      doStatement_Block(statmentID,innerNode);
    end;
  end;
end;
function TClassBrowser.TranslateLongToPoint(x:Integer):TPoint;
var
 s:String;
 p:TPoint;
 count,index:Integer;
begin
  count:=0;
  p.X:=0;  p.Y:=0;
  s:=content;
  while (true) do
  begin
    index := pos(#13#10,s);
    s:=copy(s,index+2,length(s));
    if index < 0 then
      break;
    p.Y:=p.Y+1;
    count := count + index + 1;
    if count > x then
    begin
      p.x:= x - (count - index - 1 )+1;
      break;
    end;
  end;
  result:=p;
end;
end.

