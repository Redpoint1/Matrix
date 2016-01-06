unit unit2;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Graphics, ExtCtrls, Dialogs, Math;

type

  { THighlighter }

  THighlighter = class(TObject)
    x,y: integer;
    constructor Create(xx,yy:integer);
    procedure fall();
  end;

  { TAsciiCode }

  TAsciiCode = class(TObject)
    znak: Char;
    level: Byte;
    currentLevel: Byte;
    highlighted: Boolean;
    constructor Create(znakk:Char; grey:Byte);
    procedure print(x, y: integer; obr: TImage);
    procedure down();
  end;

  { TAsciinator }

  TAsciinator = class(TObject)
    mother: integer;
    radius: Integer;
    originalCanvas: TImage;
    matrix: Array of Array of TAsciiCode;
    highlighters: Array of THighlighter;
    casovac:TTimer;
    constructor Create(canv:TImage; cas:TTimer; radiuss:integer);
    procedure greyscale();
    procedure paint();
    procedure randomLine();
    procedure fallLines();
  end;


implementation

{ THighlighter }

constructor THighlighter.Create(xx, yy: integer);
begin
  y:=yy;
  x:=xx;
end;

procedure THighlighter.fall;
begin
  y:=y+1;
end;

{ TAsciiCode }

constructor TAsciiCode.Create(znakk: Char; grey: Byte);
begin
   znak:=znakk;
   level:=grey;
   currentLevel:=0;
end;

procedure TAsciiCode.print(x, y: integer; obr: TImage);
begin
     if highlighted then
     begin
          obr.Canvas.Font.Color:=RGBToColor(110,255,110);
          highlighted:=False;
     end
     else
     begin
          obr.Canvas.Font.Color:=RGBToColor(0,currentLevel,0);
     end;
     obr.Canvas.TextOut(x,y,znak);
end;

procedure TAsciiCode.down;
begin
  currentLevel:=Max(0,currentLevel-1);
end;


{ TAsciinator }

constructor TAsciinator.Create(canv: TImage; cas: TTimer; radiuss: integer);
begin
     mother:=0;
     originalCanvas := canv;
     originalCanvas.Transparent:= True;
     originalCanvas.Canvas.Font.Color:= clGreen;
     originalCanvas.Canvas.Font.Size:= radiuss-2;
     originalCanvas.Canvas.Font.Style:= [fsBold];
     originalCanvas.Canvas.Brush.Color:= clBlack;
     radius:=radiuss;
     greyscale();
     casovac:=cas;
     casovac.Enabled:=True;

end;

procedure TAsciinator.greyscale;
var
  x,y,r,g,b: integer;
  pixel: TColor;
  average: Byte;
begin
  Randomize;
  SetLength(matrix, round(originalCanvas.Width/radius), round(originalCanvas.Height/radius));
  for x:=0 to Length(matrix)-2 do
  begin
      for y:=0 to Length(matrix[x])-2 do
      begin
          pixel:=originalCanvas.Canvas.Pixels[x*radius, y*radius];
          r:=Red(pixel);
          g:=Green(pixel);
          b:=Blue(pixel);

          pixel:=originalCanvas.Canvas.Pixels[(x+1)*radius-1, (y+1)*radius-1];
          r:=r+Red(pixel);
          g:=g+Green(pixel);
          b:=b+Blue(pixel);

          pixel:=originalCanvas.Canvas.Pixels[x*radius, (y+1)*radius-1];
          r:=r+Red(pixel);
          g:=g+Green(pixel);
          b:=b+Blue(pixel);

          pixel:=originalCanvas.Canvas.Pixels[(x+1)*radius-1, y*radius];
          r:=r+Red(pixel);
          g:=g+Green(pixel);
          b:=b+Blue(pixel);

          average := round((r/4 + g/4 + b/4) / 3) mod 255;

          matrix[x,y] := TAsciiCode.Create(Char(33+random(93)), average);
      end;
  end;


end;

procedure TAsciinator.paint;
var
  x,y: integer;
begin
     originalCanvas.Canvas.FillRect(originalCanvas.Canvas.ClipRect);
     originalCanvas.Canvas.Brush.Style:=bsClear;
     for x:=0 to Length(matrix)-2 do
         for y:=0 to Length(matrix[x])-2 do
         begin
             matrix[x,y].print(x*radius,y*radius, originalCanvas);
             matrix[x,y].down;
         end;
     originalCanvas.Canvas.Brush.Style:=bsSolid;
     randomLine;
     fallLines;
end;

procedure TAsciinator.randomLine();
var
  posX:integer;
begin
  if mother mod 1 = 0 then
  begin
    SetLength(highlighters, Length(highlighters)+1);
    posX:=Random(Length(matrix)-1);
    highlighters[High(highlighters)]:= THighlighter.Create(posX, 0);
    mother:=0;
  end;
  inc(mother)
end;

procedure TAsciinator.fallLines();
var
  i,j: integer;
begin
  for i:=0 to Length(highlighters)-1 do
  begin
    matrix[highlighters[i].x,highlighters[i].y].currentLevel:=matrix[highlighters[i].x,highlighters[i].y].level;
    matrix[highlighters[i].x,highlighters[i].y].highlighted:=True;
    highlighters[i].fall;
    if highlighters[i].y >= Length(matrix[highlighters[i].x])-2 then
    begin
       FreeAndNil(highlighters[i]);
    end;
  end;
  j:=0;
  for i:=0 to Length(highlighters)-1 do
  begin
    if highlighters[i] <> nil then
    begin
         highlighters[j] := highlighters[i];
         Inc(j);
    end;
  end;
  SetLength(highlighters, j);

end;

end.

