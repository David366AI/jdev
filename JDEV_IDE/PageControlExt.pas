unit PageControlExt;

interface

uses
  Windows, Messages, SysUtils, Classes, Controls, ComCtrls,Graphics;

type
  TPageControlExt = class(TPageControl)
  private
    { Private declarations }
  protected
    procedure Paint;
  public
    { Public declarations }
  published
    { Published declarations }
  end;

procedure Register;

implementation

procedure Register;
begin
  RegisterComponents('Win32', [TPageControlExt]);
end;

procedure  TPageControlExt.Paint;
var
  rect:TRect;
begin
  rect.Left:=left;
  rect.Top:=top;
  rect.Right:=left+Width;
  rect.Bottom:=top+height;
  self.Canvas.Pen.Color:=clGray ;
  self.Canvas.FillRect(Rect);
  inherited;  
end;

end.
