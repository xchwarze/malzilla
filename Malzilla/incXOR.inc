function incHexStr(inHexStr: string): string;
var
  HexMap: string;
  i: integer;
  j: integer;
  s: string;
  carry: integer;
begin
  result := '';
  s := '';
  carry := 0;
  HexMap := '0123456789abcdef0123456789abcdef';

  for j := 1 to 16 do
    if AnsiLowerCase(inHexStr[length(inHexStr)]) = HexMap[j] then
    begin
      if j > 15 then carry := 1;
      inHexStr[length(inHexStr)] := HexMap[(j + 1)];
      break;
    end;
  if carry = 1 then
    for i := (length(inHexStr) - 1) downto 1 do
    begin
      if carry = 1 then
        for j := 1 to 16 do
          if AnsiLowerCase(inHexStr[i]) = HexMap[j] then
          begin
            carry := 0;
            if j > 15 then carry := 1;
            inHexStr[i] := HexMap[(j + 1)];
            break;
          end;
    end;
  if carry = 1 then inHexStr := '01' + inHexStr;
  result := inHexStr;
end;

function isHexStr(inHexStr: string): boolean;
var
  HexMap: string;
  i: integer;
begin
  result := false;
  HexMap := '0123456789abcdef';
  for i := 1 to 16 do
    if AnsiLowerCase(inHexStr) = HexMap[i] then result := true;
end;

function sHexToInt(inHexStr: string): integer;
var
  HexMap: string;
  i: integer;
begin
  result := 0;
  HexMap := '0123456789abcdef';
  for i := 1 to 16 do
    if (AnsiLowerCase(inHexStr) = HexMap[i]) then result := i - 1;
end;

function sIntToDHex(inInt: integer): string;
var
  Hi1: integer;
  Lo1: integer;
  HexMap: string;
begin
  result := '';
  Hi1 := inInt div 16;
  Lo1 := inInt mod 16;
  HexMap := '0123456789abcdef';
  result := HexMap[Hi1 + 1];
  result := result + HexMap[Lo1 + 1];
end;

function sIntToSHex(inInt: integer): string;
var
  HexMap: string;
begin
  result := '';
  HexMap := '0123456789abcdef';
  result := HexMap[inInt + 1];
end;

function BFxorit(HexSrc, HexMap: string): string;
var
  i: integer;
  s: string;
begin
  s := '';
  for i := 1 to length(HexSrc) do
  begin
    s := s + sIntToSHex(sHexToInt(HexMap[i]) xor sHexToInt(HexSrc[i]));
  end;
  result := s;
end;