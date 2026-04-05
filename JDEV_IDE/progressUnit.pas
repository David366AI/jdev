unit progressUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls;

type
  TProgressFrm = class(TForm)
    Label1: TLabel;
    Label2: TLabel;
    filename_lbl: TLabel;
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  ProgressFrm: TProgressFrm;

implementation

{$R *.dfm}

procedure TProgressFrm.FormCreate(Sender: TObject);
begin
  //
end;

end.
