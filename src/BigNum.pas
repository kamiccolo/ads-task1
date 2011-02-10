unit BigNum;

interface

const
	BIGNUM_DIGITS = 254;

type
	BigNumType = record
		data: array [1..BIGNUM_DIGITS] of Byte; // or some arbitrary large number
		positive: Boolean;
	end;

	procedure bignum_init(var num: BigNumType);
	
	function bignum_tostring(num: BigNumType): string;
	function bignum_fromstring(str: string): BigNumType;

	function bignum_subtract(a, b: BigNumType): BigNumType;
	
	// behaves like C style compare: returns 0 if equal, -1 if a < b and 1 if a > b
	function bignum_compare(a, b: BigNumType): Integer;
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
	
	if found_num and (not num.positive) then
		res := '-' + res;
	
	bignum_tostring := res;
end;

function bignum_fromstring(str: string): BigNumType;
var
	i: Integer;
	num: BigNumType;
begin
	bignum_init(num);
	
	if (length(str) <= BIGNUM_DIGITS) or ((length(str) = (BIGNUM_DIGITS+1)) and (str[1] = '-')) then
	begin	
		for i := length(str) downto 1 do
		begin
			if (str[i] >= '0') and (str[i] <= '9') then
				num.data[length(str) - i + 1] := ord(str[i]) - ord('0')
			else if (str[i] = '-') then
				num.positive := false
			else
				num.data[length(str) - i + 1] := 0;
		end;
	end;
	bignum_fromstring := num;
end;

function bignum_compare(a, b: BigNumType): Integer;
var
	i: Integer;
begin
	if a.positive <> b.positive then
	begin
		if a.positive then
			bignum_compare := 1
		else
			bignum_compare := -1;
	end
	else
	begin
		i := BIGNUM_DIGITS;
		while (i > 1) and (a.data[i] = b.data[i]) do
			i := i - 1;
		
		if a.data[i] > b.data[i] then
			bignum_compare := 1
		else
		if a.data[i] < b.data[i] then
			bignum_compare := -1
		else
			bignum_compare := 0;
	end;
end;

function bignum_add(a, b: BigNumType): BigNumType;
var
	cf, af: Boolean;
	i: integer;
	sum: BigNumType;
	buf: byte;
	tmp: BigNumType;
begin
	bignum_init(sum);
	cf:=false;  //not used
	af:=false;
	buf:=0;
	
	if (a.positive xor b.positive) then
	begin  //adding numbers with different signs
		tmp:=a;
		if(a.positive=false) then  //let a be positive number and b - negative
		begin
			a:=b;
			b:=tmp;
		end;
		
		for i:=1 to BIGNUM_DIGITS do
			begin
			if (i<>1) then
			begin
				if (af) then
				begin
					if (a.data[i]=0) then  //borrowing from zero
					begin
						af:=true;
						a.data[i]:=9;
					end
					else
					begin
						a.data[i]:=a.data[i]-1;  //still no need to borrow
						af:=false;
					end;
				end;
			end;
			
			if (a.data[i]<b.data[i]) then
			begin
				sum.data[i]:=a.data[i]+10-b.data[i];
				af:=true;
			end
			else
			begin
				sum.data[i]:=a.data[i]-b.data[i];
				//af:=false;
			end;
		end;
		sum.positive:=true;
		
		
		if (af) then  //negative number!
		begin
			a:=b;
			b:=tmp;
			a.positive:=true;
			b.positive:=false;
			
			sum:=bignum_add(a, b);
			sum.positive:=false;
		end;	        
	end
	else
	begin  //adding numbers with same signs
		for i:=1 to BIGNUM_DIGITS do
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
	end;
	
	bignum_add:=sum;
end;

function bignum_subtract(a, b: BigNumType): BigNumType;
begin
	b.positive := not b.positive;
	bignum_subtract := bignum_add(a, b);
end;

initialization

end.
