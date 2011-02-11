unit BigNum;

interface

const
	BIGNUM_DIGITS = 254;

type
	BigNumType = record
		data: array [1..BIGNUM_DIGITS] of Byte; // or some arbitrary large number
		positive: Boolean;
	end;

	Procedure bignum_init(var num: BigNumType);
	
	Function bignum_tostring(num: BigNumType): string;
	Function bignum_fromstring(str: string): BigNumType;

	Function bignum_subtract(a, b: BigNumType): BigNumType;
	
	// behaves like a C style compare: returns 0 if equal, -1 if a < b and 1 if a > b
	Function bignum_compare(a, b: BigNumType): Integer;

	Function bignum_div(a, b: BigNumType): BigNumType;
	Function bignum_mod(a, b: BigNumType): BigNumType; 

	Function bignum_add(a, b: BigNumType): BigNumType;
	Function bignum_mul(a, b: BigNumType): BigNumType;

implementation

Procedure bignum_init(var num: BigNumType);
var
	i: Integer;
begin
	for i := 1 to BIGNUM_DIGITS do
		num.data[i] := 0;
		num.positive := true;
end;

Function bignum_tostring(num: BigNumType): string;
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

Function bignum_fromstring(str: string): BigNumType;
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

Function bignum_compare(a, b: BigNumType): Integer;
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

Function bignum_add(a, b: BigNumType): BigNumType;
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

Function bignum_subtract(a, b: BigNumType): BigNumType;
begin
	b.positive := not b.positive;
	bignum_subtract := bignum_add(a, b);
end;

Function digit_count(a: BigNumType): Integer;
var
	i: Integer;
begin
	i := BIGNUM_DIGITS;
	while (i <> 1) and (a.data[i] = 0) do
		i := i - 1;
	digit_count := i;
end;

Function shift_left(a: BigNumType): BigNumType;
var
	i: Integer;
begin
	for i := BIGNUM_DIGITS downto 2 do
		a.data[i] := a.data[i-1];
	a.data[1] := 0;
	shift_left := a;
end;

Function shift_right(a: BigNumType): BigNumType;
var
	i: Integer;
begin
	for i := 1 to (BIGNUM_DIGITS-1) do
		a.data[i] := a.data[i+1];
	a.data[BIGNUM_DIGITS] := 0;
	shift_right := a;
end;

Function bn_abs(a: BigNumType): BigNumType;
begin
	a.positive := True;
	bn_abs := a;
end;

Function divide_internal(a, b: BigNumType; remainder: Boolean): BigNumType;
var
	digit_dif: Integer;
	i: Integer;
	res, ONE: BigNumType;
	positive: Boolean;
begin
	if bignum_compare(b, bignum_fromstring('0')) = 0 then
		divide_internal := bignum_fromstring('0')
	else
	if bignum_compare(bn_abs(a), bn_abs(b)) < 0 then
	begin
		if remainder then
			divide_internal := a
		else
			divide_internal := bignum_fromstring('0');
	end
	else
	begin
		ONE := bignum_fromstring('1');
		digit_dif := digit_count(a) - digit_count(b);
		i := 0;
		while i < digit_dif do
		begin
			b := shift_left(b);
			i := i + 1;
		end;
		
		bignum_init(res);
		if remainder then // when doing mod with negative divisors, Pascal uses sign of dividend for the resulting sign
			positive := (a.positive = b.positive) or a.positive
		else
			positive := (a.positive = b.positive);
		a := bn_abs(a);
		b := bn_abs(b);
		
		for i := 0 to digit_dif do
		begin
			res := shift_left(res);
			while bignum_compare(a, b) >= 0 do
			begin
				a := bignum_subtract(a, b);
				res := bignum_add(res, ONE);
			end;
			b := shift_right(b);
		end;
		
		if remainder then
		begin
			a.positive := positive;
			divide_internal := a;
		end
		else
		begin
			res.positive := positive;
			divide_internal := res;
		end;
	end;
end;

Function bignum_div(a, b: BigNumType): BigNumType;
begin
	bignum_div := divide_internal(a, b, false);
end;

Function bignum_mod(a, b: BigNumType): BigNumType; 
begin
	bignum_mod := divide_internal(a, b, true);
end;

Function bignum_mul(a, b: BigNumType): BigNumType;
var
	i, j, k, carry, buf: Byte;
	res, tmp: BigNumType;
	adigit, bdigit: Integer;
begin
	adigit:=digit_count(a);
	bdigit:=digit_count(b);
	bignum_init(res);
	tmp:=res;
	carry:=0;
	
	for i:=1 to bdigit do
	begin
		for j:=1 to adigit do
		begin
			buf:=a.data[j]*b.data[i];
			if(carry<>0) then
			begin
				buf:=buf+carry;
			end;
			if(buf>9) then
			begin
				carry:=buf div 10;
				buf:=buf mod 10;
			end
			else carry:=0;
			tmp.data[j]:=buf;
		end;
		if (carry<>0) and (BIGNUM_DIGITS>j) then tmp.data[j+1]:=carry;
		for k:=2 to i do tmp:=shift_left(tmp);
		res:=bignum_add(res, tmp);
	end;
	if (a.positive xor b.positive) then res.positive:=false
	else tmp.positive:=true;
	bignum_mul:=res;
end;
initialization

end.
