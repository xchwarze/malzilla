function AlphaDec1(s: string): string;
var
  CD, EF: Byte;
  A, B, C, F: byte;
  E, D: byte;
  i: Integer;
  t: string;
  r: string;
  unicode: Boolean;
  ascii: Boolean;

begin
  Result := '';
  unicode := False;
  ascii := False;
  t := 'jAXP0A0AkAAQ2AB2BB0BBABXP8ABuJI'; // mixedcase ascii
  if Pos(t, s) > 0 then
  begin
    ascii := True;
    s := Copy(s, Pos(t, s) + Length(t), Length(s));
  end
  else
    t := 'VTX30VX4AP0A3HH0A00ABAABTAAQ2AB2BB0BBXP8ACJJI'; // uppercase ascii
  if Pos(t, s) > 0 then
  begin
    ascii := True;
    s := Copy(s, Pos(t, s) + Length(t), Length(s));
  end
  else
    t :=
      'jXAQADAZABARALAYAIAQAIAQAIAhAAAZ1AIAIAJ11AIAIABABABQI1AIQIAIQI111AIAJQYAZBABABABABkMAGB9u4JB'; // mixedcase unicode
  if Pos(t, s) > 0 then
  begin
    unicode := True;
    s := Copy(s, Pos(t, s) + Length(t), Length(s));
  end
  else
    t :=
      'QATAXAZAPA3QADAZABARALAYAIAQAIAQAPA5AAAPAZ1AI1AIAIAJ11AIAIAXA58AAPAZABABQI1AIQIAIQI1111AIAJQI1AYAZBABABABAB30APB944JB'; // uppercase unicode
  if Pos(t, s) > 0 then
  begin
    unicode := True;
    s := Copy(s, Pos(t, s) + Length(t), Length(s));
  end;

  r := '';
  i := 1;
  while i < Length(s) do
  begin
    CD := Ord(s[i]);
    EF := Ord(s[i + 1]);
    C := (CD and $F0) shr 4;
    D := CD and $0F;
    E := (EF and $F0) shr 4;
    //E1 := (EF and $f0);
    F := EF and $0F;

    B := F;
    {for A := 3 to 7 do
    begin
      if Power(A, E) = D then Break;
    end;         // D := A^E; }
    A := D xor E;
    //r := r + ('A = '+IntToHex(A,2) + ';');
    //r := r + ('B = '+IntToHex(B,2) + ';');
    //r := r + ('C = '+IntToHex(C,2) + ';');
    //r := r + ('D = '+IntToHex(D,2) + ';');
    //r := r + ('E = '+IntToHex(E,2) + ';');
    //r := r + ('F = '+IntToHex(F,2) + ';');
    //r := r + ('AB = '+IntToHex(B + (A shl 4),2) + ';');
    r := r + chr(B + (A shl 4));
    //r := r + IntToStr(B + (A shl 4));
    Inc(i, 2);
  end;
  Result := r;
end;

