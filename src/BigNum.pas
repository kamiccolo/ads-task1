unit BigNum;

interface

type
	BigNumType = record
		data: array [1..256] of Byte;
		positive: Boolean;
	end;
	
	procedure bignum_init(var num: BigNumType);
	
	function bignum_tostring(var num: BigNumType): string;

implementation

procedure bignum_init(var num: BigNumType);
var
	i: Integer;
begin
	for i := 1 to 256 do
		num.data[i] := 0;
		num.positive := true;
end;

function bignum_tostring(var num: BigNumType): string;
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

initialization

end.