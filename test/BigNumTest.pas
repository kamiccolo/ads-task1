unit BigNumTest;
{$mode objfpc}

interface
uses
	fpcunit, testregistry, BigNum;

type
	BigNumTestCase = class(TTestCase)
	Published
		Procedure InitTest;
		Procedure ToStringTest;
		Procedure FromStringTest;
		Procedure AdditionTest;
	end;
	
implementation

Procedure BigNumTestCase.InitTest;
var
	num: BigNumType;
begin
	bignum_init(num);
	AssertEquals('BigNum should be initialized to zero.',bignum_tostring(num),'0');
	AssertEquals('BigNumType.positive should be initialized to 1.',num.positive,true);
	
end;

Procedure BigNumTestCase.ToStringTest;
var
	num: BigNumType;
begin
	bignum_init(num);
	num.data[1] := 2;
	num.data[2] := 4;
	AssertEquals('Simple 42 test.', '42', bignum_tostring(num));
	
	bignum_init(num);
	num.data[1] := 0;
	num.data[2] := 2;
	num.data[3] := 4;
	AssertEquals('Number ending with a zero.', '420', bignum_tostring(num));
	
	bignum_init(num);
	num.data[1] := 1;
	num.data[2] := 0;
	num.data[3] := 2;
	num.data[4] := 4;
	AssertEquals('Number with a zero digit in the middle.', '4201', bignum_tostring(num));
	
	bignum_init(num);
	num.positive := False;
	num.data[1] := 1;
	AssertEquals('minus one', '-1', bignum_tostring(num));
	
	bignum_init(num);
	num.positive := False;
	num.data[1] := 2;
	num.data[2] := 4;
	AssertEquals('mainus fourty two', '-42', bignum_tostring(num));
	
end;

Procedure BigNumTestCase.FromStringTest;
var
	num: BigNumType;
begin
	num := bignum_fromstring('1');
	
	AssertEquals('1!', '1', bignum_tostring(bignum_fromstring('1')));
	AssertEquals('0!', '0', bignum_tostring(bignum_fromstring('0')));
	AssertEquals('passing empty string should yield zero', '0', bignum_tostring(bignum_fromstring('')));
	num := bignum_fromstring('1232112423');
	AssertEquals('Medium length string test', '1232112423', bignum_tostring(num));
	num := bignum_fromstring('0000');
	AssertEquals('Bunch of zeroes test.', '0', bignum_tostring(num));
	num := bignum_fromstring('2132132001223232132111123213213211');
	AssertEquals('Number with a zero in the middle', '2132132001223232132111123213213211', bignum_tostring(num));
	num:=bignum_fromstring('-5');
	AssertEquals('Tostring-fromstring with negative numbers.','-5',bignum_tostring(num));
end;

Procedure BigNumTestCase.AdditionTest;
var
	num, num2: BigNumType;
	i: integer;
begin
	num := bignum_fromstring('5');
	num2:=bignum_add(num, num);
	AssertEquals('BigNum_add. Adding two positive integers. Sum below 999....99.','10', bignum_tostring(num2));
	AssertEquals('0+0 == 0', '0', bignum_tostring(bignum_add(bignum_fromstring('0'), bignum_fromstring('0'))));
	AssertEquals('1+0 == 1.', '1', bignum_tostring(bignum_add(bignum_fromstring('1'), bignum_fromstring('0'))));
	AssertEquals('1+0 == 1.', '1', bignum_tostring(bignum_add(bignum_fromstring('1'), bignum_fromstring('0'))));
	for i:=1 to 256 do num.data[i]:=9;
	num2:=bignum_fromstring('1');
	AssertEquals('Adding biggest possible number with 1, (causing an overflow).','0',bignum_tostring(bignum_add(num, num2)));
	AssertEquals('Adding biggest possible number with 1, (causing an overflow). Part 2.','0',bignum_tostring(bignum_add(bignum_fromstring(bignum_tostring(num)), num2)));
	num:=bignum_fromstring('-5');
	num2:=bignum_fromstring('8');
	AssertEquals('Adding positive and negative numbers.','3',bignum_tostring(bignum_add(num2, num)));
	
	bignum_init(num);
	num.data[1]:=5;
	num.positive:=false;
	num2:=bignum_fromstring('3');
	AssertEquals('Adding positive and negative numbers. Part 2.','-2',bignum_tostring(bignum_add(num2, num)));
	num2:=bignum_fromstring('8');
	AssertEquals('Adding positive and negative numbers. Part 3.','-3',bignum_tostring(bignum_add(num2, num)));
	
	AssertEquals('<Hugenum> + <Hugenum>.', '109999999999999999999999999999999999999999990', bignum_tostring(bignum_add(bignum_fromstring('9999999999999999999999999999999999999999999'), bignum_fromstring('99999999999999999999999999999999999999999991'))));
end;

initialization
	RegisterTest(BigNumTestCase);
end.
