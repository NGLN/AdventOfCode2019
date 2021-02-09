program AOC2019_08;

{$APPTYPE CONSOLE}

uses
  System.SysUtils,
  System.Classes,
  System.StrUtils,
  System.Generics.Collections;

const
  ColCount = 25;
  RowCount = 6;
  CharsPerLayer = ColCount * RowCount;

type
  TPixels = array[1..RowCount] of String;

  TLayer = class(TObject)
    Data: String;
    function Pixel(Col, Row: Integer): Char;
    function Count(Digit: Char): Integer;
  end;

  TLayers = class(TObjectList<TLayer>)
    Pixels: TPixels;
    function LayerWithFewestZeros: TLayer;
    function ImageMessage: String;
  end;

{ TLayer }

function TLayer.Count(Digit: Char): Integer;
var
  C: Char;
begin
  Result := 0;
  for C in Data do
    if C = Digit then
      Inc(Result);
end;

function TLayer.Pixel(Col, Row: Integer): Char;
begin
  Result := Data[Col + (Row - 1) * ColCount];
end;

{ TLayers }

function TLayers.ImageMessage: String;
var
  Layer: TLayer;
  Col: Integer;
  Row: Integer;
begin
  for Row := 1 to RowCount do
    SetLength(Pixels[Row], ColCount);
  for Layer in Self do
    for Col := 1 to ColCount do
      for Row := 1 to RowCount do
        if not ((Pixels[Row][Col] = '0') or (Pixels[Row][Col] = '1')) then
          Pixels[Row, Col] := Layer.Pixel(Col, Row);
  Result := '';
  for Row := 1 to RowCount do
    Result := Result + Pixels[Row] + #13#10;
  Result := StringReplace(Result, '0', ' ', [rfReplaceAll]);
  Result := StringReplace(Result, '1', '#', [rfReplaceAll]);
end;

function TLayers.LayerWithFewestZeros: TLayer;
var
  Layer: TLayer;
  MinZeros: Integer;
begin
  Result := nil;
  MinZeros := CharsPerLayer;
  for Layer in Self do
    if Layer.Count('0') < MinZeros then
    begin
      MinZeros := Layer.Count('0');
      Result := Layer;
    end;
end;

var
  Input: TStringList;
  Index: Integer = 1;
  Layers: TLayers;
  Layer: TLayer;

begin
  Input := TStringList.Create;
  Layers := TLayers.Create;
  try
    Input.LoadFromFile('input.txt');
  { Part I }
    while Index < Length(Input[0]) do
    begin
      Layer := TLayer.Create;
      Layer.Data := Copy(Input[0], Index, CharsPerLayer);
      Layers.Add(Layer);
      Inc(Index, CharsPerLayer);
    end;
    Layer := Layers.LayerWithFewestZeros;
    WriteLn('Part I: ', Layer.Count('1') * Layer.Count('2'));
  { Part II }
    WriteLn('Part II: ');
    WriteLn(Layers.ImageMessage);
  finally
    Layers.Free;
    Input.Free;
  end;
  ReadLn;
end.
