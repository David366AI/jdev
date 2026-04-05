unit selectPath;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons, FileCtrl;

type
  TselectPathDlg = class(TForm)
    pathLbl: TLabel;
    DriveComboBox1: TDriveComboBox;
    DirectoryListBox1: TDirectoryListBox;
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
    Label2: TLabel;
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  selectPathDlg: TselectPathDlg;

implementation

{$R *.dfm}

procedure TselectPathDlg.FormCreate(Sender: TObject);
begin
  //
end;

end.
