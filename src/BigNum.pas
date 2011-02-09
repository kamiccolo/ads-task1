unit BigNum;

interface

type
	BigNumType = record
		data: array [1..256] of Byte; // or some arbitrary large number
		positive: Boolean;
	end;
	
	procedure bignum_init(var num: BigNumType);
	
	function bignum_tostring(num: BigNumType): string;
	function bignum_fromstring(str: string): BigNumType;
{	
	function bignum_add(var a, b: BigNumType): BigNumType;
	function bignum_substract(var a, b: BigNumType): BigNumType;
	
	function bignum_divide(var a, b: BigNumType): BigNumType;
	function bignum_remainder(var a, b: BigNumType): BigNumType;
}
implementation

procedure bignum_init(var num: BigNumType);
var
	i: Integer;
begin
	for i := 1 to 256 do
		num.data[i] := 0;
		num.positive := true;
end;

function bignum_tostring(num: BigNumType): string;
var
	i: Integer;
	found_num: Boolean;
	res: string;
begin
	found_num := false;
	res := '';
	for i := 256 downto 1 do 
	begin
		if (not found_num) and (num.data[i] <> 0) then
			found_num := true;
		if (found_num) or (i = 1) then
		begin
			res := res + chr(ord('0') + num.data[i]);
		end;
	end;
	bignum_tostring := res;
end;

function bignum_fromstring(str: string): BigNumType;
var
	i: Integer;
	num: BigNumType;
begin
	bignum_init(num);
	for i := length(str) downto 1 do
	begin
		if (str[i] >= '0') and (str[i] <= '9') then
			num.data[length(str) - i + 1] := ord(str[i]) - ord('0')
		else
			num.data[length(str) - i + 1] := 0;
	end;
	
	bignum_fromstring := num;
end;

{function bignum_substract(var a, b: BigNumType): BigNumType;
var
	carry: Byte;
	res: BigNumType;
begin
	carry := -1;
	bignum_init(res);
	for i := length(str) downto 1 do
	begin
		if (str[i] >= '0') and (str[i] <= '9') then
			num.data[length(str) - i + 1] := ord(str[i]) - ord('0')
		else
			num.data[length(str) - i + 1] := 0;
	end;
	
	bignum_substract := num;
end;}

initialization

end.