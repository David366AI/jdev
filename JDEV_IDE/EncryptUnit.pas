unit EncryptUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs,Encrypt, StdCtrls, HCMngr;

type
  TForm1 = class(TForm)
    Button1: TButton;
    Memo1: TMemo;
    CipherManager1: TCipherManager;
    procedure Button1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;
  index:Integer;
implementation

{$R *.dfm}

procedure TForm1.Button1Click(Sender: TObject);
begin
  //RegisterSoftware('gsh','gsh');
  if index = 0 then
    CipherManager1.Algorithm:='Blowfish'
  else
    CipherManager1.Algorithm:='Gost';

  CipherManager1.InitKey('gsh',nil);
  caption:=CipherManager1.EncodeString('gshgsh');

  index:=index+1;
  memo1.Lines.add(caption+' '+CipherManager1.DecodeString(caption));

end;

end.
