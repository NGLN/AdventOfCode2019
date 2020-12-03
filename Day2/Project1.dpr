program Project1;

{$APPTYPE CONSOLE}

uses
  System.SysUtils,
  System.Classes;

var
  List: TStringList;
  Answer1: Integer;
  Answer2: Integer;
  Prog: array of Integer;
  I: Integer;
  Noun: Integer;
  Verb: Integer;

const
  EndValue = 19690720;

begin
  List := TStringList.Create;
  try
    List.LoadFromFile(ExtractFilePath(ParamStr(0)) + 'input.txt');
    { Part 1 }
    List.CommaText := List[0];
    SetLength(Prog, List.Count);
    for I := 0 to List.Count - 1 do
      Prog[I] := StrToInt(List[I]);
    Prog[1] := 12;
    Prog[2] := 2;
    I := 0;
    while I < List.Count - 4 - 1 do
    begin
      case Prog[I] of
        1:
          Prog[Prog[I + 3]] := Prog[Prog[I + 1]] + Prog[Prog[I + 2]];
        2:
          Prog[Prog[I + 3]] := Prog[Prog[I + 1]] * Prog[Prog[I + 2]];
        99:
          Break;
      end;
      Inc(I, 4);
    end;
    Answer1 := Prog[0];
    WriteLn(Answer1);
    { Part 2 }
    for Noun := 0 to 99 do
    begin
      for Verb := 0 to 99 do
      begin
        for I := 0 to List.Count - 1 do
          Prog[I] := StrToInt(List[I]);
        Prog[1] := Noun;
        Prog[2] := Verb;
        I := 0;
        while I < List.Count - 4 - 1 do
        begin
          case Prog[I] of
            1:
              Prog[Prog[I + 3]] := Prog[Prog[I + 1]] + Prog[Prog[I + 2]];
            2:
              Prog[Prog[I + 3]] := Prog[Prog[I + 1]] * Prog[Prog[I + 2]];
            99:
              Break;
          end;
          Inc(I, 4);
        end;
        if Prog[0] = EndValue then
          Break;
      end;
      if Prog[0] = EndValue then
        Break;
    end;
    Answer2 := 100 * Noun + Verb;
    WriteLn(Answer2);
  finally
    List.Free;
  end;
  ReadLn;
end.
