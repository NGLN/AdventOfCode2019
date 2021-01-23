program AOC2019_06;

{$APPTYPE CONSOLE}

uses
  System.SysUtils,
  System.Classes,
  System.Generics.Collections;

var
  Input: TStringList;
  Bodies: TDictionary<String, String>;
  I: Integer;
  Orbiter: String;
  Body: String;
  Answer1: Integer = 0;
  YouTransfers: TStringList;
  YouTransferCount: Integer;
  SanTransferCount: Integer = 0;
  Answer2: Integer;

begin
  Input := TStringList.Create;
  Bodies := TDictionary<String, String>.Create;
  YouTransfers := TStringList.Create;
  try
    Input.LoadFromFile('input.txt');
  { Part I }
    for I := 0 to Input.Count - 1 do
      Bodies.Add(Copy(Input[I], 5, 3), Copy(Input[I], 1, 3));
    for Orbiter in Bodies.Keys do
    begin
      Body := Orbiter;
      repeat
        Body := Bodies[Body];
        Inc(Answer1);
      until Body = 'COM';
    end;
    WriteLn('Part I: ', Answer1);
  { Part II }
    Body := 'YOU';
    repeat
      Body := Bodies[Body];
      YouTransfers.Add(Body);
    until Body = 'COM';
    Body := 'SAN';
    repeat
      Body := Bodies[Body];
      Inc(SanTransferCount);
      YouTransferCount := YouTransfers.IndexOf(Body);
    until YouTransferCount > -1;
    Answer2 := YouTransferCount + SanTransferCount - 1;
    WriteLn('Part II: ', Answer2);
  finally
    YouTransfers.Free;
    Bodies.Free;
    Input.Free;
  end;
  ReadLn;
end.
