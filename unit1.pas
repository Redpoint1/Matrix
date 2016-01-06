unit Unit1;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, StdCtrls,
  ExtCtrls, unit2;

type

  { TForm1 }

  TForm1 = class(TForm)
    Button1: TButton;
    Button2: TButton;
    Image1: TImage;
    ScrollBox1: TScrollBox;
    Timer1: TTimer;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
  private
    { private declarations }
  public
    test: TAsciinator;
  end;

var
  Form1: TForm1;

implementation

{$R *.lfm}

{ TForm1 }

procedure TForm1.Button1Click(Sender: TObject);
var
  image: TBitmap;
  i,j,x,y,count,grayI,r,g,b: Integer;
  average,conversion,grayR,interval: Real;
  pixel: TColor;
  gray: Byte;
  clr: String;
begin

  count := 16;
  conversion := 255 / (count-1);
  //interval := 255 / count;
  image:=TBitmap.Create;
  image.LoadFromFile('C:\Users\Redpoint1\Desktop\test.bmp');

  Image1.Height:=image.Height;
  Image1.Width:=image.Width;
  Image1.Canvas.Draw(0,0,image);

  test := TAsciinator.Create(Image1, Timer1, 8);
  test.paint();
  //for i:=0 to (image.Width-9) div 8 do
  //begin
  //    for j:=0 to (image.Height-9) div 8 do
  //    begin
  //         pixel:=image.Canvas.Pixels[i*8, j*8];
  //         r:=Red(pixel);
  //         g:=Green(pixel);
  //         b:=Blue(pixel);
  //
  //         pixel:=image.Canvas.Pixels[(i+1)*8-1, (j+1)*8-1];
  //         r:=r+Red(pixel);
  //         g:=g+Green(pixel);
  //         b:=b+Blue(pixel);
  //
  //         pixel:=image.Canvas.Pixels[i*8, (j+1)*8-1];
  //         r:=r+Red(pixel);
  //         g:=g+Green(pixel);
  //         b:=b+Blue(pixel);
  //
  //         pixel:=image.Canvas.Pixels[(i+1)*8-1, j*8];
  //         r:=r+Red(pixel);
  //         g:=g+Green(pixel);
  //         b:=b+Blue(pixel);
  //
  //         average := (r/4 + g/4 + b/4) / 3;
  //         //grayR := round((average / conversion) + 0.5) * conversion;
  //         grayI:= round(average) mod 255;
  //         gray := grayI;
  //         pixel := RGBToColor(gray, gray, gray);
  //         clr := ColorToString(pixel);
  //         //for x:=i*8 to (i+1)*8-1 do
  //         //begin
  //         //     for y:=j*8 to (j+1)*8-1 do
  //         //     begin
  //         //          image.Canvas.Pixels[x, y] := pixel;
  //         //     end;
  //         //end;
  //    end;
  //end;
end;

procedure TForm1.Button2Click(Sender: TObject);
var
  saveTo: TBitmap;
begin
  saveTo := TBitmap.Create;
  saveTo.SetSize(Image1.Width, Image1.Height);
  saveTo.Canvas.CopyRect(saveTo.Canvas.ClipRect, Image1.Canvas, Image1.Canvas.ClipRect);
  saveTo.Canvas.CopyRect(saveTo.Canvas.ClipRect, Image1.Canvas, Image1.Canvas.ClipRect);
  showMessage(IntToStr(Image1.Canvas.ClipRect.Right) + ' --> ' + IntToStr(Image1.Canvas.ClipRect.Bottom));
  saveTo.SaveToFile('C:\Users\Redpoint1\Desktop\result.bmp');
  FreeAndNil(saveTo);
end;

procedure TForm1.Timer1Timer(Sender: TObject);
begin
  if test <> nil then
     test.paint;
end;

end.

