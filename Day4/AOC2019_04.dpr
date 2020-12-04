program AOC2019_04;

{$APPTYPE CONSOLE}

uses
  System.SysUtils;

var
  Answer1: Integer = 0;
  Answer2: Integer = 0;
  Password: Integer;
  S: String;
  Valid: Boolean;
  I: Integer;
  MatchCount: Integer;

begin
  { Part I }
  for Password := 246515 to 739105 do
  begin
    S := IntToStr(Password);
    Valid := False;
    for I := 2 to 6 do
      if S[I] = S[I - 1] then
        Valid := True;
    if not Valid then
      Continue;
    Valid := True;
    for I := 2 to 6 do
      if S[I] < S[I - 1] then
        Valid := False;
    if Valid then
      Inc(Answer1);
  end;
  WriteLn('Part I: ', Answer1);
  { Part II }
  for Password := 246515 to 739105 do
  begin
    S := IntToStr(Password);
    MatchCount := 1;
    for I := 2 to 6 do
      if S[I] = S[I - 1] then
        Inc(MatchCount)
      else
      begin
        if MatchCount = 2 then
          Break;
        MatchCount := 1;
      end;
    if MatchCount <> 2 then
      Continue;
    Valid := True;
    for I := 2 to 6 do
      if S[I] < S[I - 1] then
        Valid := False;
    if Valid then
      Inc(Answer2);
  end;
  WriteLn('Part II: ', Answer2);
  ReadLn;
end.
