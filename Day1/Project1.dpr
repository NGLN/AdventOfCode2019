program Project1;

{$APPTYPE CONSOLE}

uses
  System.SysUtils, System.Classes;

var
  List: TStringList;
  Answer1: Integer;
  I: Integer;
  Mass: Integer;
  Fuel: Integer;
  Answer2: Integer;

begin
  List := TStringList.Create;
  try
    List.LoadFromFile(ExtractFilePath(ParamStr(0)) + 'input.txt');
    { Part 1 }
    Answer1 := 0;
    for I := 0 to List.Count - 1 do
      Inc(Answer1, (StrToInt(List[I]) div 3) - 2);
    WriteLn(Answer1);
    { Part 2 }
    Answer2 := 0;
    for I := 0 to List.Count - 1 do
    begin
      Mass := StrToInt(List[I]);
      repeat
        Fuel := Mass div 3 - 2;
        if Fuel > 0 then
          Inc(Answer2, Fuel);
        Mass := Fuel;
      until (Fuel <= 0);
    end;
    WriteLn(Answer2);
  finally
    List.Free;
  end;
  ReadLn;
end.
