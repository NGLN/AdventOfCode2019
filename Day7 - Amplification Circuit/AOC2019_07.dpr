program AOC2019_07;

{$APPTYPE CONSOLE}

uses
  System.SysUtils,
  System.Classes,
  System.StrUtils,
  System.Types,
  System.Math;

var
  Input: TStringList;

function Amplify(Phase, Signal: Int64): Int64;
const
  pmPosition = '0';
  pmImmediate = '1';
  ParamCount = 3;
var
  Prog: TInt64DynArray;
  I: Int64;
  Index: array[0..ParamCount] of Int64;
  OpCode: Byte;
  PhaseIsSet: Boolean;

  procedure ReadInstruction;
  var
    S: String;
    J: Int64;
  begin
    S := IntToStr(Prog[Index[0]]);
    S := StringOfChar('0', 5 - Length(S)) + S;
    OpCode := StrToInt(RightStr(S, 2));
    for J := 1 to ParamCount do
      case S[5 - 2 - J + 1] of
        pmPosition:
          Index[J] := Prog[Index[0] + J];
        pmImmediate:
          Index[J] := Index[0] + J;
      end;
  end;

begin
  SetLength(Prog, Input.Count);
  for I := 0 to Input.Count - 1 do
    Prog[I] := StrToInt(Input[I]);
  PhaseIsSet := False;
  Index[0] := 0;
  Result := -1;
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
          if PhaseIsSet then
            Prog[Index[1]] := Signal
          else
            Prog[Index[1]] := Phase;
          PhaseIsSet := True;
          Inc(Index[0], 2);
        end;
      4:
        begin
          Result := Prog[Index[1]];
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
end;

var
  I, J, K, L, M: Integer;
  Output: Int64;
  Answer1: Int64 = 0;
  Answer2: Int64 = 0;

begin
  Input := TStringList.Create;
  try
    Input.LoadFromFile('input.txt');
    Input.CommaText := Input[0];
  { Part I }
    for I := 0 to 4 do
      for J := 0 to 4 do
        if not (J = I) then
          for K := 0 to 4 do
            if not ((K = I) or (K = J)) then
              for L := 0 to 4 do
                if not ((L = I) or (L = J) or (L = K)) then
                  for M := 0 to 4 do
                    if not ((M = I) or (M = J) or (M = K) or (M = L)) then
                    begin
                      Output := Amplify(I, 0);
                      Output := Amplify(J, Output);
                      Output := Amplify(K, Output);
                      Output := Amplify(L, Output);
                      Output := Amplify(M, Output);
                      Answer1 := Max(Answer1, Output);
                    end;
    WriteLn('Part I: ', Answer1);
  { Part II }

    WriteLn('Part II: ', Answer2);
  finally
    Input.Free;
  end;
  ReadLn;
end.
