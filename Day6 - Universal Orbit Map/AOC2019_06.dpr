program AOC2019_06;

{$APPTYPE CONSOLE}

uses
  System.SysUtils,
  System.Classes,
  System.Generics.Collections;

type
  TOrbiters = class(TStringList)
  protected
    Depth: Integer;
    procedure Deepen;
  end;

  TBodies = class(TObjectDictionary<String, TOrbiters>);

var
  Input: TStringList;
  Bodies: TBodies;
  I: Integer;
  Body: String;
  Orbiter: String;
  Orbiters: TOrbiters;
  Answer1: Integer = 0;
  Answer2: Integer;
  YouBodies: TStringList;
  SanBodies: TStringList;

{ TOrbiters }

procedure TOrbiters.Deepen;
var
  LBody: String;
  LOrbiters: TOrbiters;
begin
  for LBody in Self do
  begin
    LOrbiters := Bodies[LBody];
    LOrbiters.Depth := Depth + 1;
    LOrbiters.Deepen;
  end;
end;

function Orbiting(const ABody: String): String;
var
  I: Integer;
begin
  Result := '';
  for I := 0 to Input.Count - 1 do
    if Copy(Input[I], 5, 3) = ABody then
    begin
      Result := Copy(Input[I], 1, 3);
      Break;
    end;
end;

begin
  Input := TStringList.Create;
  Bodies := TBodies.Create;
  YouBodies := TStringList.Create;
  SanBodies := TStringList.Create;
  try
    Input.LoadFromFile('input.txt');
  { Part I }
    Bodies.Add('COM', TOrbiters.Create);
    for I := 0 to Input.Count - 1 do
      Bodies.Add(Copy(Input[I], 5, 3), TOrbiters.Create);
    for I := 0 to Input.Count - 1 do
    begin
      Body := Copy(Input[I], 1, 3);
      Orbiter := Copy(Input[I], 5, 3);
      Bodies[Body].Add(Orbiter);
    end;
    Body := 'COM';
    Orbiters := Bodies[Body];
    Orbiters.Deepen;
    for Orbiters in Bodies.Values do
      Inc(Answer1, Orbiters.Depth);
    WriteLn('Part I: ', Answer1);
  { Part II }
    Body := 'YOU';
    repeat
      Body := Orbiting(Body);
      YouBodies.Add(Body);
    until Body = 'COM';
    Body := 'SAN';
    repeat
      Body := Orbiting(Body);
      SanBodies.Add(Body);
      Answer2 := YouBodies.IndexOf(Body);
    until Answer2 > -1;
    Inc(Answer2, SanBodies.Count - 1);
    WriteLn('Part II: ', Answer2);
  finally
    SanBodies.Free;
    YouBodies.Free;
    Bodies.Free;
    Input.Free;
  end;
  ReadLn;
end.
