unit runParamSetupUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons, Grids, ValEdit;

type
  TRunParamSetupDlg = class(TForm)
    runBtn: TBitBtn;
    BitBtn2: TBitBtn;
    Label1: TLabel;
    appNameLbl: TLabel;
    Label2: TLabel;
    paramsEdit: TEdit;
    mainStopChecked: TCheckBox;
    procedure FormCreate(Sender: TObject);
  private

  public
    { Public declarations }
  end;

var
  RunParamSetupDlg: TRunParamSetupDlg;

implementation

{$R *.dfm}

procedure TRunParamSetupDlg.FormCreate(Sender: TObject);
begin
  //
end;

end.
