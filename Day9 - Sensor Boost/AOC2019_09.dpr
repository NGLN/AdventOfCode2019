program AOC2019_09;

{$APPTYPE CONSOLE}

uses
  System.SysUtils,
  System.Classes,
  System.StrUtils,
  System.Types;

type
  TIntCodeComputer = class(TObject)
  const
    MaxParamCount = 3;
    ocAdd = 1;
    ocMultiply = 2;
    ocInput = 3;
    ocOutput = 4;
    ocJumpIfTrue = 5;
    ocJumpIfFalse = 6;
    ocLessThen = 7;
    ocEquals = 8;
    ocAdjustRelativeBase = 9;
    ocHalt = 99;
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
      ocAdd:
        Prog[Index[3]] := Prog[Index[1]] + Prog[Index[2]];
      ocMultiply:
        Prog[Index[3]] := Prog[Index[1]] * Prog[Index[2]];
      ocInput:
        Prog[Index[1]] := Input;
      ocOutput:
        begin
          Output := Prog[Index[1]];
          WriteLn(Output);
        end;
      ocJumpIfTrue:
        if Prog[Index[1]] <> 0 then
        begin
          Index[0] := Prog[Index[2]];
          Continue;
        end;
      ocJumpIfFalse:
        if Prog[Index[1]] = 0 then
        begin
          Index[0] := Prog[Index[2]];
          Continue;
        end;
      ocLessThen:
        if Prog[Index[1]] < Prog[Index[2]] then
          Prog[Index[3]] := 1
        else
          Prog[Index[3]] := 0;
      ocEquals:
        if Prog[Index[1]] = Prog[Index[2]] then
          Prog[Index[3]] := 1
        else
          Prog[Index[3]] := 0;
      ocAdjustRelativeBase:
        Inc(RelativeBase, Prog[Index[1]]);
      ocHalt:
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
    ocAdd, ocMultiply, ocLessThen, ocEquals:
      Result := 3;
    ocInput, ocOutput, ocAdjustRelativeBase:
      Result := 1;
    ocJumpIfTrue, ocJumpIfFalse:
      Result := 2;
    else
      Result := 0;
  end;
end;

procedure TIntCodeComputer.ReadInstruction;
const
  pmPosition = '0';
  pmImmediate = '1';
  pmRelative = '2';
var
  Instruction: String;
  I: Integer;

  function ParameterMode: Char;
  begin
    Result := Instruction[5 - 2 - I + 1];
  end;

begin
  Instruction := IntToStr(Prog[Index[0]]);
  Instruction := StringOfChar('0', 5 - Length(Instruction)) + Instruction;
  OpCode := StrToInt(RightStr(Instruction, 2));
  EnsureIndex(Index[0] + ParamCount);
  for I := 1 to ParamCount do
  begin
    case ParameterMode of
      pmPosition:
        Index[I] := Prog[Index[0] + I];
      pmImmediate:
        Index[I] := Index[0] + I;
      pmRelative:
        Index[I] := Prog[Index[0] + I] + RelativeBase;
    end;
    EnsureIndex(Index[I] + ParamCount);
  end;
end;

var
  Input: TStringList;
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
