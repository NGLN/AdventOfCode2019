program AOC2019_07;

{$APPTYPE CONSOLE}

uses
  System.SysUtils,
  System.Classes,
  System.StrUtils,
  System.Types,
  System.Generics.Collections,
  System.Math;

type
  TPhase = Integer;

  TAmplifier = class(TObject)
  const
    ParamCount = 3;
    pmPosition = '0';
    pmImmediate = '1';
  private
    Phase: TPhase;
    Prog: TInt64DynArray;
    Index: array[0..ParamCount] of Int64;
    OpCode: Byte;
    Signal: Int64;
    function Amplify(IsInit: Boolean = False): Boolean;
    procedure Init(APhase: TPhase);
    procedure ReadInstruction;
  end;

  TAmplifiers = class(TObjectDictionary<TPhase, TAmplifier>)
    procedure Init(PhaseFrom, PhaseTo: TPhase);
    function Concatenate(A, B, C, D, E: TPhase; var Signal: Int64): Boolean;
  end;

var
  Input: TStringList;

{ TAmplifier }

function TAmplifier.Amplify(IsInit: Boolean = False): Boolean;
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
          if IsInit then
            Prog[Index[1]] := Phase
          else
            Prog[Index[1]] := Signal;
          Inc(Index[0], 2);
          if IsInit then
            Break;
        end;
      4:
        begin
          Signal := Prog[Index[1]];
          Inc(Index[0], 2);
          Result := True;
          Break;
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
        begin
          Result := False;
          Break;
        end;
    end;
  until False;
end;

procedure TAmplifier.Init(APhase: TPhase);
var
  I: Integer;
begin
  Phase := APhase;
  SetLength(Prog, Input.Count);
  for I := 0 to Input.Count - 1 do
    Prog[I] := StrToInt(Input[I]);
  Index[0] := 0;
  Amplify(True);
end;

procedure TAmplifier.ReadInstruction;
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

{ TAmplifiers }

function TAmplifiers.Concatenate(A, B, C, D, E: TPhase;
  var Signal: Int64): Boolean;
begin
  Items[A].Signal := Signal;
  Items[A].Amplify;
  Items[B].Signal := Items[A].Signal;
  Items[B].Amplify;
  Items[C].Signal := Items[B].Signal;
  Items[C].Amplify;
  Items[D].Signal := Items[C].Signal;
  Items[D].Amplify;
  Items[E].Signal := Items[D].Signal;
  Result := Items[E].Amplify;
  Signal := Items[E].Signal;
end;

procedure TAmplifiers.Init(PhaseFrom, PhaseTo: TPhase);
var
  APhase: TPhase;
  Amplifier: TAmplifier;
begin
  for APhase := PhaseFrom to PhaseTo do
  begin
    if not TryGetValue(APhase, Amplifier) then
    begin
      Amplifier := TAmplifier.Create;
      Add(APhase, Amplifier);
    end;
    Amplifier.Init(APhase);
  end;
end;

var
  Amplifiers: TAmplifiers;
  I, J, K, L, M: Integer;
  Signal: Int64;
  Answer1: Int64 = 0;
  Answer2: Int64 = 0;

begin
  Input := TStringList.Create;
  Amplifiers := TAmplifiers.Create;
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
                      Amplifiers.Init(0, 4);
                      Signal := 0;
                      Amplifiers.Concatenate(I, J, K, L, M, Signal);
                      Answer1 := Max(Answer1, Signal);
                    end;
    WriteLn('Part I: ', Answer1);
  { Part II }
    for I := 5 to 9 do
      for J := 5 to 9 do
        if not (J = I) then
          for K := 5 to 9 do
            if not ((K = I) or (K = J)) then
              for L := 5 to 9 do
                if not ((L = I) or (L = J) or (L = K)) then
                  for M := 5 to 9 do
                    if not ((M = I) or (M = J) or (M = K) or (M = L)) then
                    begin
                      Amplifiers.Init(5, 9);
                      Signal := 0;
                      while Amplifiers.Concatenate(I, J, K, L, M, Signal) do;
                      Answer2 := Max(Answer2, Signal);
                    end;
    WriteLn('Part II: ', Answer2);
  finally
    Amplifiers.Free;
    Input.Free;
  end;
  ReadLn;
end.
