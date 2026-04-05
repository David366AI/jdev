program JiaMiProject;

uses
  Forms,
  EncryptUnit in 'EncryptUnit.pas' {Form1},
  Encrypt in 'Encrypt.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
