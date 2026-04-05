unit MoveFileUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons;

type
  TMoveFileForm = class(TForm)
    Label1: TLabel;
    fileNameLbl: TLabel;
    Label2: TLabel;
    destPackComboBox: TComboBox;
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  MoveFileForm: TMoveFileForm;

implementation

{$R *.dfm}

procedure TMoveFileForm.FormCreate(Sender: TObject);
begin
  //
end;

end.
