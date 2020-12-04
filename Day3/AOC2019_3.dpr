program AOC2019_3;

{$APPTYPE CONSOLE}

uses
  System.SysUtils,
  System.Classes,
  System.Types,
  System.Math;

var
  Input: TStringList;
  Wire1: TStringList;
  Wire2: TStringList;
  Bounds: TRect;
  Origin: TPoint;
  Grid: array of array of Integer;
  X: Integer;
  Y: Integer;
  Answer1: Integer;
  Answer2: Integer;

  procedure UpdateBounds(AWire: TStringList);
  var
    Pos: TPoint;
    I: Integer;
    StepCount: Integer;
  begin
    Pos := Point(0, 0);
    for I := 0 to AWire.Count - 1 do
    begin
      StepCount := StrToInt(Copy(AWire[I], 2, Length(AWire[I]) - 1));
      case AWire[I][1] of
        'U': Dec(Pos.Y, StepCount);
        'D': Inc(Pos.Y, StepCount);
        'L': Dec(Pos.X, StepCount);
        'R': Inc(Pos.X, StepCount);
      end;
      Bounds.Left := Min(Bounds.Left, Pos.X);
      Bounds.Top := Min(Bounds.Top, Pos.Y);
      Bounds.Right := Max(Bounds.Right, Pos.X);
      Bounds.Bottom := Max(Bounds.Bottom, Pos.Y);
    end;
  end;

  procedure DrawWire(AWire: TStringList; AValue: Byte);
  var
    Pos: TPoint;
    I: Integer;
    StepCount: Integer;
    J: Integer;
  begin
    Pos := Origin;
    for I := 0 to AWire.Count - 1 do
    begin
      StepCount := StrToInt(Copy(AWire[I], 2, Length(AWire[I]) - 1));
      for J := 0 to StepCount - 1 do
      begin
        case AWire[I][1] of
          'U': Dec(Pos.Y);
          'D': Inc(Pos.Y);
          'L': Dec(Pos.X);
          'R': Inc(Pos.X);
        end;
        Grid[Pos.X, Pos.Y] := Grid[Pos.X, Pos.Y] or AValue;
      end;
    end;
  end;

  procedure CombineSteps(AWire: TStringList);
  var
    Pos: TPoint;
    I: Integer;
    StepCount: Integer;
    J: Integer;
    WireLength: Integer;
  begin
    Pos := Origin;
    WireLength := 0;
    for I := 0 to AWire.Count - 1 do
    begin
      StepCount := StrToInt(Copy(AWire[I], 2, Length(AWire[I]) - 1));
      for J := 0 to StepCount - 1 do
      begin
        case AWire[I][1] of
          'U': Dec(Pos.Y);
          'D': Inc(Pos.Y);
          'L': Dec(Pos.X);
          'R': Inc(Pos.X);
        end;
        Inc(WireLength);
        if Grid[Pos.X, Pos.Y] = 3 then
          Grid[Pos.X, Pos.Y] := -WireLength
        else if Grid[Pos.X, Pos.Y] < 0 then
          Dec(Grid[Pos.X, Pos.Y], WireLength);
      end;
    end;
  end;

begin
  Input := TStringList.Create;
  Wire1 := TStringList.Create;
  Wire2 := TStringList.Create;
  try
    Input.LoadFromFile(ExtractFilePath(ParamStr(0)) + 'input.txt');
{   Examples:
    Wire1.CommaText := 'R75,D30,R83,U83,L12,D49,R71,U7,L72';
    Wire2.CommaText := 'U62,R66,U55,R34,D71,R55,D58,R83';
    Wire1.CommaText := 'R98,U47,R26,D63,R33,U87,L62,D20,R33,U53,R51';
    Wire2.CommaText := 'U98,R91,D20,R16,D67,R40,U7,R15,U6,R7';
}   Wire1.CommaText := Input[0];
    Wire2.CommaText := Input[1];
    { Part I }
    UpdateBounds(Wire1);
    UpdateBounds(Wire2);
    Origin.X := -Bounds.Left;
    Origin.Y := -Bounds.Top;
    SetLength(Grid, Bounds.Width + 1, Bounds.Height + 1);
    DrawWire(Wire1, 1);
    DrawWire(Wire2, 2);
    Answer1 := MaxInt;
    for X := 0 to Bounds.Width do
      for Y := 0 to Bounds.Height do
        if Grid[X, Y] = 3 then
          Answer1 := Min(Answer1, Abs(Origin.X - X) + Abs(Origin.Y - Y));
    WriteLn(Answer1);
    { Part II }
    CombineSteps(Wire1);
    CombineSteps(Wire2);
    Answer2 := MaxInt;
    for X := 0 to Bounds.Width do
      for Y := 0 to Bounds.Height do
        if Grid[X, Y] < 0 then
          Answer2 := Min(Answer2, -Grid[X, Y]);
    WriteLn(Answer2);
  finally
    Wire2.Free;
    Wire1.Free;
    Input.Free;
  end;
  ReadLn;
end.
