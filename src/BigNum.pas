unit BigNum;

interface

type
	BigNumType = record
		data: array [1..256] of Byte;
		positive: Boolean;
	end;
	
	procedure bignum_init(var num: BigNumType);
	
	function bignum_tostring(var num: BigNumType): string;
	
	function bignum_add(var a, b: BigNumType): BigNumType;

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

function bignum_add(var a, b: BigNumType): BigNumType;
var
	cf, af: Boolean;
	i: integer;
	sum: BigNumType;
	buf: byte;
begin
	bignum_init(sum);
	cf:=false;
	af:=false;
	
	if (a.positive xor b.positive) then
	begin

			//kai skirtingų ženklų
	end
	else
	begin
		for i:=1 to 256 do
		begin
			buf:=a.data[i]+b.data[i];
			if (af=true) then
			begin
				buf:=buf+1;
				af:=false;
			end;
			if (buf>9) then af:=true;
			sum.data[i]:=buf mod 10;
		end;
		sum.positive:=a.positive;
		//vienodais ženklais - suma, bet ženklo nekeičia
	end;
	
	bignum_add:=sum;
end;

initialization

end.
