unit parseExp;

interface
uses
   SysUtils, StrUtils,Variants, Classes,ComCtrls,Controls;
type

  TParseExp = class
    public
      desString:String;
      tree:TTreeView;
      dotPos :Integer;
      parseString:String;
      objType:String;
      constructor Create(des:String;owner:TComponent);
      destructor destroy;override;
      procedure  parse(node:TTreeNode;des:String);
      function getParseString:String;


  end;

  TParseNode = class
      startIndex:Integer;
      endIndex:Integer;
  end;

  function FindNextRightKuohao(beginPos:Integer;s:String):Integer;

implementation

constructor TParseExp.Create(des:String;owner:TComponent);
var
  root:TTreeNode;
begin
  inherited create;
  objType:='';
  tree:=TTreeView.Create(nil);
  tree.Parent:=TWinControl(owner);
  tree.Visible:=false;
  root:=tree.Items.Add(nil,des);
  des:=trim(des);

  if Pos('return ',des) > 0 then
    des:=trim(Copy(des,length('return ')+1,Length(des)))
  else if Pos('if ',des) > 0 then
    des:=trim(Copy(des,length('if ')+1,Length(des)))
  else if Pos('while ',des) > 0 then
    des:=trim(Copy(des,length('while ')+1,Length(des)))
  else if Pos('for ',des) > 0 then
    des:=trim(Copy(des,length('for ')+1,Length(des)))
  else if Pos('try ',des) > 0 then
    des:=trim(Copy(des,length('try ')+1,Length(des)));

  desString:=des;
  self.dotPos:=dotPos;
  parse(root,des);
  getParseString;  
end;

function TParseExp.getParseString:String;
var
  node,tempNode:TTreeNode;
  i:Integer;
begin
  try
    parseString:='';
    node:=tree.Items[tree.Items.count-1];

    if Pos(',',node.Text) > 0 then
    begin
      parseString:=trim(Copy(node.text,LastDelimiter(',',node.Text)+1,Length(node.text)));
    end
    else
    begin
      for i:=node.Parent.Count-1 downto 0 do
      begin
        if node.Parent.Item[i].Text <> '()' then
        begin
          parseString:= node.Parent.Item[i].Text + parseString;
        end else
        begin
           node:=node.Parent.Item[i];
           tempNode:=node;
           while ( tempNode.Count >= 1) do
           begin
             if tempNode.Count >= 2 then
               break;
             tempNode:=tempNode.item[0];
             if tempNode = nil then
               break;
           end;
           if ( tempNode = nil ) or (tempNode.Count<=1) then
             exit;
           node:=tempNode;
           tempNode:=node.Item[0];
           while (tempNode <> nil ) and (tempNode.Text = '()') do
           begin
             if tempNode.Count <= 0 then
               break;
             tempNode:=tempNode.Item[0];
           end;
           if (tempNode <> nil) and (tempNode.Text<>'()') then
             objType:=tempNode.Text;

           tempNode:=node.Item[1];
           while (tempNode <> nil ) and (tempNode.Text = '()') do
           begin
             if tempNode.Count <= 0 then
               break;
             tempNode:=tempNode.Item[0];
           end;
           if tempNode <> nil then
             parseString := tempNode.Text +  parseString ;

           break;
        end;
      end;
      if Pos(',',parseString) > 0 then
      begin
        parseString:=trim(Copy(parseString,LastDelimiter(',',parseString)+1,Length(parseString)));
      end;
    end;
    parseString:=Copy(parseString,1,length(parseString)-1);
    parseString:=AnsiReplaceStr(parseString,' ','');
    result:=parseString;
  except
    result:='';
  end;
end;

procedure TParseExp.parse(node:TTreeNode;des:String);
var
  index1,index2,i:Integer;
  s:String;
  nextNode:TTreeNode;
begin
  if trim(des) = '' then
    exit;
  while true do
  begin
    index1:= Pos('(',des);
    if index1 <= 0 then
    begin
      if trim(des) <> '' then
        tree.Items.AddChild(node,trim(des));
      break;
    end;
    index2 := FindNextRightKuohao(index1,des);

    nextNode:=tree.Items.AddChild(node, trim(Copy(des,1,index1)) + ')' );

    s:='';
    for i:=1 to length(des) do
      if (i>index1) and (i<index2) then
        s := s + des[i]
      else
        s := s + ' ';

    parse(nextNode,s);

    for i:=1 to index2 do
      des[i] := ' ';
  end;
end;

destructor TParseExp.destroy;
begin
  tree.Free;
  inherited;
end;


function FindNextRightKuohao(beginPos:Integer;s:String):Integer;
var
  i,count:Integer;
  found:Boolean;
begin
  count:=0;
  result:=1;
  found:=false;
  for i:=beginPos to length(s) do
  begin
    if s[i] = ')' then
      count := count - 1;
    if s[i] = '(' then
      count := count + 1;
    if count = 0 then
    begin
      result:=i;
      found:=true;
      break;
    end;
  end;
  if not found then
    result:=length(s)+1;
end;

end.
