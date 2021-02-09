program AOC2019_09;

{$APPTYPE CONSOLE}

uses
  System.SysUtils,
  System.Classes,
  System.StrUtils,
  System.Types;

var
  Input: TStringList;

type
  TIntCodeComputer = class(TObject)
  const
    MaxParamCount = 3;
    pmPosition = '0';
    pmImmediate = '1';
    pmRelative = '2';
  private
    Prog: TInt64DynArray;
    Index: array[0..MaxParamCount] of Integer;
    OpCode: Byte;
    RelativeBase: Integer;
    Input: Int64;
    Output: Int64;
    procedure Boost;
    procedure EnsureIndex(AIndex: Integer);
    procedure Init(ProgLines: TStrings);
    function ParamCount: Integer;
    procedure ReadInstruction;
  end;

procedure TIntCodeComputer.Boost;
begin
  repeat
    ReadInstruction;
    case OpCode of
      1:
        Prog[Index[3]] := Prog[Index[1]] + Prog[Index[2]];
      2:
        Prog[Index[3]] := Prog[Index[1]] * Prog[Index[2]];
      3:
        Prog[Index[1]] := Input;
      4:
        begin
          Output := Prog[Index[1]];
          WriteLn(Output);
        end;
      5:
        if Prog[Index[1]] <> 0 then
        begin
          Index[0] := Prog[Index[2]];
          Continue;
        end;
      6:
        if Prog[Index[1]] = 0 then
        begin
          Index[0] := Prog[Index[2]];
          Continue;
        end;
      7:
        if Prog[Index[1]] < Prog[Index[2]] then
          Prog[Index[3]] := 1
        else
          Prog[Index[3]] := 0;
      8:
        if Prog[Index[1]] = Prog[Index[2]] then
          Prog[Index[3]] := 1
        else
          Prog[Index[3]] := 0;
      9:
        Inc(RelativeBase, Prog[Index[1]]);
      99:
        Break;
    end;
    Inc(Index[0], ParamCount + 1);
  until False;
end;

procedure TIntCodeComputer.EnsureIndex(AIndex: Integer);
begin
  if Length(Prog) <= AIndex then
    SetLength(Prog, AIndex + 1);
end;

procedure TIntCodeComputer.Init(ProgLines: TStrings);
var
  I: Integer;
begin
  SetLength(Prog, ProgLines.Count);
  for I := 0 to ProgLines.Count - 1 do
    Prog[I] := StrToInt64(ProgLines[I]);
  Index[0] := 0;
  RelativeBase := 0;
  Input := 0;
  Output := 0;
end;

function TIntCodeComputer.ParamCount: Integer;
begin
  case OpCode of
    1, 2, 7, 8:
      Result := 3;
    3, 4, 9:
      Result := 1;
    5, 6:
      Result := 2;
    else
      Result := 0;
  end;
end;

procedure TIntCodeComputer.ReadInstruction;
var
  S: String;
  J: Integer;
begin
  S := IntToStr(Prog[Index[0]]);
  S := StringOfChar('0', 5 - Length(S)) + S;
  OpCode := StrToInt(RightStr(S, 2));
  EnsureIndex(Index[0] + ParamCount);
  for J := 1 to ParamCount do
  begin
    case S[5 - 2 - J + 1] of
      pmPosition:
        Index[J] := Prog[Index[0] + J];
      pmImmediate:
        Index[J] := Index[0] + J;
      pmRelative:
        Index[J] := Prog[Index[0] + J] + RelativeBase;
    end;
    EnsureIndex(Index[J] + ParamCount);
  end;
end;

var
  Computer: TIntCodeComputer;

begin
  Input := TStringList.Create;
  Computer := TIntCodeComputer.Create;
  try
    Input.LoadFromFile('input.txt');
    Input.CommaText := Input[0];
  { Part I }
    Write('Part I: ');
    Computer.Init(Input);
    Computer.Input := 1;
    Computer.Boost;
  { Part II }
    Write('Part II: ');
    Computer.Init(Input);
    Computer.Input := 2;
    Computer.Boost;
  finally
    Computer.Free;
    Input.Free;
  end;
  ReadLn;
end.
