program AOC2019_10;

{$APPTYPE CONSOLE}

uses
  System.Classes,
  System.Generics.Collections,
  System.Types;

var
  Input: TStringList;

type
  TAngles = class(TList<Double>)
    FFrom: TPoint;
    procedure AddTo(const APoint: TPoint);
    procedure SetFrom(const Value: TPoint);
    property From: TPoint read FFrom write SetFrom;
  end;

procedure TAngles.AddTo(const APoint: TPoint);
var
  Angle: Double;
begin
  Angle := From.Angle(APoint);
  if not Contains(Angle) then
    Add(Angle);
end;

procedure TAngles.SetFrom(const Value: TPoint);
var
  X: Integer;
  Y: Integer;
begin
  if FFrom <> Value then
  begin
    FFrom := Value;
    Clear;
    for X := 1 to Length(Input[0]) do
      for Y := 0 to Input.Count - 1 do
        if Input[Y][X] = '#' then
          if not ((X = Value.X) and (Y = Value.Y)) then
            AddTo(Point(X, Y));
  end;
end;

var
  Angles: TAngles;
  X: Integer;
  Y: Integer;
  MaxAngleCount: Integer = -1;
  Asteroid: TPoint;

begin
  Input := TStringList.Create;
  Angles := TAngles.Create;
  try
    Input.LoadFromFile('input.txt');
  { Part I }
    for X := 1 to Length(Input[0]) do
      for Y := 0 to Input.Count - 1 do
        if Input[Y][X] = '#' then
        begin
          Angles.From := Point(X, Y);
          if Angles.Count > MaxAngleCount then
          begin
            MaxAngleCount := Angles.Count;
            Asteroid := Angles.From;
          end;
        end;
    WriteLn('Part I: ', MaxAngleCount);
  { Part II }
    Write('Part II: ');
  finally
    Angles.Free;
    Input.Free;
  end;
  ReadLn;
end.
