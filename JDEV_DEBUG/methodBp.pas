unit methodBp;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Buttons, StdCtrls, ExtCtrls, Menus;

type
  TaddMethodBpForm = class(TForm)
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    GroupBox1: TGroupBox;
    packageEdit: TEdit;
    classEdit: TEdit;
    functionEdit: TEdit;
    Panel1: TPanel;
    paramListBox: TListBox;
    paramEdit: TEdit;
    Label4: TLabel;
    Button1: TButton;
    okBtn: TBitBtn;
    closeBtn: TBitBtn;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    paramPopupMenu: TPopupMenu;
    N1: TMenuItem;
    procedure FormShow(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure paramListBoxMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure N1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  addMethodBpForm: TaddMethodBpForm;
  clickIndex:Integer;
implementation

{$R *.dfm}

procedure TaddMethodBpForm.FormShow(Sender: TObject);
begin
  packageEdit.SetFocus;
end;

procedure TaddMethodBpForm.Button1Click(Sender: TObject);
begin
  paramListBox.Items.Add(paramEdit.Text);
end;

procedure TaddMethodBpForm.paramListBoxMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var
  pt:TPoint;
begin
  pt:=paramListBox.ClientToScreen(point(x,y));
  clickIndex:=paramListBox.ItemAtPos(point(x,y),true);
  if clickIndex >=0 then
    paramPopupMenu.Popup(pt.x,pt.y);
end;

procedure TaddMethodBpForm.N1Click(Sender: TObject);
begin
  paramListBox.Items.Delete(clickIndex);
end;

procedure TaddMethodBpForm.FormCreate(Sender: TObject);
begin
  //
end;

end.
