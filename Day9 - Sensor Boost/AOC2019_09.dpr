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
    ParamCount = 3;
    pmPosition = '0';
    pmImmediate = '1';
    pmRelative = '2';
  private
    Prog: TInt64DynArray;
    // TODO: Index array should be of type Integer, but then ParamCount should
    //       be made dependend on OpCode first!!
    Index: array[0..ParamCount] of Int64;
    OpCode: Byte;
    RelativeBase: Integer;
    Input: Int64;
    Output: Int64;
    function Boost(BreakOnInput: Boolean = False): Boolean;
    procedure EnsureIndex(AIndex: Int64);
    procedure Init(ProgLines: TStrings);
    procedure ReadInstruction;
  end;

function TIntCodeComputer.Boost(BreakOnInput: Boolean = False): Boolean;
begin
  Result := False;
  repeat
    ReadInstruction;
    case OpCode of
      1:
        begin
          Prog[Index[3]] := Prog[Index[1]] + Prog[Index[2]];
          Inc(Index[0], 4);
        end;
      2:
        begin
          Prog[Index[3]] := Prog[Index[1]] * Prog[Index[2]];
          Inc(Index[0], 4);
        end;
      3:
        begin
          Prog[Index[1]] := Input;
          Inc(Index[0], 2);
          if BreakOnInput then
            Break;
        end;
      4:
        begin
          Output := Prog[Index[1]];
          Inc(Index[0], 2);
          Result := True;
          WriteLn(Output);
        end;
      5:
        if Prog[Index[1]] <> 0 then
          Index[0] := Prog[Index[2]]
        else
          Inc(Index[0], 3);
      6:
        if Prog[Index[1]] = 0 then
          Index[0] := Prog[Index[2]]
        else
          Inc(Index[0], 3);
      7:
        begin
          if Prog[Index[1]] < Prog[Index[2]] then
            Prog[Index[3]] := 1
          else
            Prog[Index[3]] := 0;
          Inc(Index[0], 4);
        end;
      8:
        begin
          if Prog[Index[1]] = Prog[Index[2]] then
            Prog[Index[3]] := 1
          else
            Prog[Index[3]] := 0;
          Inc(Index[0], 4);
        end;
      9:
        begin
          Inc(RelativeBase, Prog[Index[1]]);
          Inc(Index[0], 2);
        end;
      99:
        begin
          Result := False;
          Break;
        end;
    end;
  until False;
end;

procedure TIntCodeComputer.EnsureIndex(AIndex: Int64);
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

procedure TIntCodeComputer.ReadInstruction;
var
  S: String;
  J: Integer;
begin
  S := IntToStr(Prog[Index[0]]);
  S := StringOfChar('0', 5 - Length(S)) + S;
  OpCode := StrToInt(RightStr(S, 2));
  EnsureIndex(Index[0] + ParamCount);
  // TODO: ParamCount should depend on OpCode!! Array might be set too long!!
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
    Computer.Init(Input);
    Computer.Input := 1;
    Computer.Boost;
    WriteLn('Part I: ', Computer.Output);
  { Part II }
    Computer.Init(Input);
    Computer.Input := 2;
    Computer.Boost;
    WriteLn('Part II: ', Computer.Output);
  finally
    Computer.Free;
    Input.Free;
  end;
  ReadLn;
end.
