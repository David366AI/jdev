unit changVarName;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons;

type
  TchangeVarForm = class(TForm)
    Label1: TLabel;
    varNameEdit: TEdit;
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  changeVarForm: TchangeVarForm;

implementation

{$R *.dfm}

end.
