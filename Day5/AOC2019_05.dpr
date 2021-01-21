program AOC2019_05;

{$APPTYPE CONSOLE}

uses
  System.SysUtils,
  System.Classes,
  System.StrUtils;

const
  pmPosition = '0';
  pmImmediate = '1';
  ParamCount = 3;

var
  Input: TStringList;
  Answer1: Integer;
  Answer2: Integer;
  I: Integer;
  Prog: array of Integer;
  Index: array[0..ParamCount] of Integer;
  OpCode: Byte;
  ProgInput: Integer;

procedure ReadInstruction;
var
  S: String;
  I: Integer;
begin
  S := IntToStr(Prog[Index[0]]);
  S := StringOfChar('0', 5 - Length(S)) + S;
  OpCode := StrToInt(RightStr(S, 2));
  for I := 1 to ParamCount do
    case S[5 - 2 - I + 1] of
      pmPosition:
        Index[I] := Prog[Index[0] + I];
      pmImmediate:
        Index[I] := Index[0] + I;
    end;
end;

begin
  Input := TStringList.Create;
  try
    Input.LoadFromFile('input.txt');
    Input.CommaText := Input[0];
    SetLength(Prog, Input.Count);
  { Part I }
    for I := 0 to Input.Count - 1 do
      Prog[I] := StrToInt(Input[I]);
    Index[0] := 0;
    ProgInput := 1;
    Answer1 := -1;
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
            Prog[Index[1]] := ProgInput;
            Inc(Index[0], 2);
          end;
        4:
          begin
            Answer1 := Prog[Index[1]];
            Inc(Index[0], 2);
          end;
        99:
          Break;
      end;
    until False;
    WriteLn('Part I: ', Answer1);
  { Part II }
    Input.LoadFromFile('input.txt');
    Input.CommaText := Input[0];
    SetLength(Prog, Input.Count);
    for I := 0 to Input.Count - 1 do
      Prog[I] := StrToInt(Input[I]);
    Index[0] := 0;
    ProgInput := 5;
    Answer2 := -1;
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
            Prog[Index[1]] := ProgInput;
            Inc(Index[0], 2);
          end;
        4:
          begin
            Answer2 := Prog[Index[1]];
            Inc(Index[0], 2);
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
        99:
          Break;
      end;
    until False;
    WriteLn('Part II: ', Answer2);
  finally
    Input.Free;
  end;
  ReadLn;
end.
