unit setPath;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons, ExtCtrls;

type
  TsetSourcePathDlg = class(TForm)
    allPathListBox: TListBox;
    Panel1: TPanel;
    newPathEdit: TEdit;
    Label3: TLabel;
    browseBtn: TBitBtn;
    addPathBtn: TBitBtn;
    deletePathBtn: TBitBtn;
    appNameLbl: TLabel;
    Label1: TLabel;
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
    procedure browseBtnClick(Sender: TObject);
    procedure addPathBtnClick(Sender: TObject);
    procedure deletePathBtnClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  setSourcePathDlg: TsetSourcePathDlg;

implementation
uses
  selectPath;
{$R *.dfm}

procedure TsetSourcePathDlg.browseBtnClick(Sender: TObject);
begin
  if selectPathDlg.ShowModal = mrOK then
     newPathEdit.Text:=selectPathDlg.pathLbl.Caption;
end;

procedure TsetSourcePathDlg.addPathBtnClick(Sender: TObject);
begin
 if newPathEdit.Text <> '' then
   allPathListBox.Items.Add(newPathEdit.Text);
end;

procedure TsetSourcePathDlg.deletePathBtnClick(Sender: TObject);
begin
  if allPathListBox.ItemIndex = -1 then
    exit
  else
    allPathListBox.DeleteSelected;
end;

procedure TsetSourcePathDlg.FormCreate(Sender: TObject);
begin
  //
end;

end.
