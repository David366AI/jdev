unit aboutUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, jpeg, ExtCtrls,ShellApi;

type
  TaboutDlg = class(TForm)
    Button1: TButton;
    Image1: TImage;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    maillbl: TLabel;
    webSiteLbl: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    Panel1: TPanel;
    procedure maillblClick(Sender: TObject);
    procedure webSiteLblClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  aboutDlg: TaboutDlg;

implementation
uses
  ideUnit;
{$R *.dfm}

procedure TaboutDlg.maillblClick(Sender: TObject);
begin
  ShellExecute(0, nil, PChar('mailto:gongsh@vip.sina.com?SUBJECT=Some Questions'
                  +'&BODY=I have some question about ... '), nil, nil, SW_NORMAL);
end;

procedure TaboutDlg.webSiteLblClick(Sender: TObject);
begin
  ShellExecute(0, nil, PChar(g_domain_web_site), nil, nil, SW_NORMAL);

end;

procedure TaboutDlg.FormShow(Sender: TObject);
begin
  webSiteLbl.Caption:= g_domain_web_site;
end;

end.
