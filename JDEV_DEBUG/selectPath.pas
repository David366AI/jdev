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
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  selectPathDlg: TselectPathDlg;

implementation

{$R *.dfm}

end.
