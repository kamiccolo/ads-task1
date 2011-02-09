unit BigNum;

interface

const
	BIGNUM_DIGITS = 256;

type
	BigNumType = record
		data: array [1..BIGNUM_DIGITS] of Byte; // or some arbitrary large number
		positive: Boolean;
	end;
	
	procedure bignum_init(var num: BigNumType);
	
	function bignum_tostring(num: BigNumType): string;
	function bignum_fromstring(str: string): BigNumType;

	function bignum_subtract(a, b: BigNumType): BigNumType;
{	
	function bignum_divide(a, b: BigNumType): BigNumType;
	function bignum_remainder(a, b: BigNumType): BigNumType;
}
	
	function bignum_add(a, b: BigNumType): BigNumType;

implementation

procedure bignum_init(var num: BigNumType);
var
	i: Integer;
begin
	for i := 1 to BIGNUM_DIGITS do
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
	for i := BIGNUM_DIGITS downto 1 do 
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
	if length(str) <= BIGNUM_DIGITS then
		for i := length(str) downto 1 do
		begin
			if (str[i] >= '0') and (str[i] <= '9') then
				num.data[length(str) - i + 1] := ord(str[i]) - ord('0')
			else (if str[i] = '-') then
				num.data[length(str) - i + 1] := 0;
		end;
	
	bignum_fromstring := num;
end;

function bignum_add(a, b: BigNumType): BigNumType;
var
	cf, af: Boolean;
	i: integer;
	sum: BigNumType;
	buf: byte;
	tmp: BigNumType; //don't forget to wipe out this
begin
	bignum_init(sum);
	cf:=false;
	af:=false;
	buf:=0;
	
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

function bignum_subtract(a, b: BigNumType): BigNumType;
var
	carry: Byte;
	i: Integer;
	res: BigNumType;
begin
	bignum_init(res);
	carry := 0;
	if (a.positive = a.positive) then
	begin
		for i := 1 to BIGNUM_DIGITS do
		begin
			res[i] := a[i] - b[i] - carry;
			if res[i] < 0 then
			begin
				res[i] := 10 - res[i];
				carry := 1;
			end 
			else
				carry := 0;
			
		end;
	end;
end;

initialization

end.
