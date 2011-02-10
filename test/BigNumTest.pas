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
		Procedure SubtractionTest;
		Procedure ComparisonTest;
		Procedure DivisionTest;
		Procedure RemainderTest;
	end;
	
implementation

Procedure BigNumTestCase.InitTest;
var
	num: BigNumType;
begin
	bignum_init(num);
	AssertEquals('BigNum should be initialized to zero.', '0', bignum_tostring(num));
	AssertEquals('BigNumType.positive should be initialized to 1.',true ,num.positive);
	
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
	// TODO proper tests for limits
end;

Procedure BigNumTestCase.FromStringTest;
var
	num: BigNumType;
	s1: string;
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
	AssertEquals('negative large number', bignum_tostring(bignum_fromstring('-2134343578439758437589743957439578437598437574385743957843')), '-2134343578439758437589743957439578437598437574385743957843');
	// TODO proper tests for limits
	
	// 254x '9'
	s1 := '99999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999';
	AssertEquals('254 digits, positive', s1, bignum_tostring(bignum_fromstring(s1)));
	s1 := '-99999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999';
	AssertEquals('254 digits and a sign symbol', s1, bignum_tostring(bignum_fromstring(s1)));
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
	AssertEquals('9+1 == 10.', '10', bignum_tostring(bignum_add(bignum_fromstring('9'), bignum_fromstring('1'))));
	for i:=1 to BIGNUM_DIGITS do num.data[i]:=9;
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
	AssertEquals('Adding positive and negative numbers. Part 3.','-3',bignum_tostring(bignum_add(bignum_fromstring('5'), bignum_fromstring('-8'))));
	
	AssertEquals('<Hugenum> + <Hugenum>.', '109999999999999999999999999999999999999999990', bignum_tostring(bignum_add(bignum_fromstring('9999999999999999999999999999999999999999999'), bignum_fromstring('99999999999999999999999999999999999999999991'))));
end;

Procedure BigNumTestCase.SubtractionTest;
var
	num, num2: BigNumType;
begin
	AssertEquals('1 - 1 == 0', '0', bignum_tostring(bignum_subtract(bignum_fromstring('1'), bignum_fromstring('1'))));
	AssertEquals('(-1) - (-1) == 0', '0', bignum_tostring(bignum_subtract(bignum_fromstring('-1'), bignum_fromstring('-1'))));
	AssertEquals('2 - 1 == 1', '1', bignum_tostring(bignum_subtract(bignum_fromstring('2'), bignum_fromstring('1'))));
	AssertEquals('digit carry test: 10 - 1 == 9', '9', bignum_tostring(bignum_subtract(bignum_fromstring('10'), bignum_fromstring('1'))));
	AssertEquals('global carry 2 - 3 == -1', '-1', bignum_tostring(bignum_subtract(bignum_fromstring('2'), bignum_fromstring('3'))));
	AssertEquals('10 - 11 == -1', '-1', bignum_tostring(bignum_subtract(bignum_fromstring('10'), bignum_fromstring('11'))));
	
	// as of now we support up to 254 digits. Add moar and we fail :-)
	num := bignum_fromstring('99999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999');	
	AssertEquals('maxnum - maxnum == 0', '0', bignum_tostring(bignum_subtract(num, num)));
	num2 := bignum_fromstring('99999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999998');
	AssertEquals('maxnum - (maxnum - 1) == 1', '1', bignum_tostring(bignum_subtract(num, num2)));
	num := bignum_fromstring('-99999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999');
	AssertEquals('(-maxnum) - (-maxnum) == 0', '0', bignum_tostring(bignum_subtract(num, num)));
end;

Procedure BigNumTestCase.ComparisonTest;
var
	n1, n2: BigNumType;
begin
	AssertEquals('0 == 0', 0, bignum_compare(bignum_fromstring('0'), bignum_fromstring('0')));
	AssertEquals('1 == 1', 0, bignum_compare(bignum_fromstring('1'), bignum_fromstring('1')));
	AssertEquals('2 == 2', 0, bignum_compare(bignum_fromstring('2'), bignum_fromstring('2')));
	AssertEquals('10 == 10', 0, bignum_compare(bignum_fromstring('10'), bignum_fromstring('10')));
	AssertEquals('-1 == -1', 0, bignum_compare(bignum_fromstring('-1'), bignum_fromstring('-1')));
	
	// TODO: test maxnum
	n1 := bignum_fromstring('99999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999');	
	AssertEquals('maxnum == maxnum', 0, bignum_compare(n1, n1));
	
	AssertEquals('1 > 0', 1, bignum_compare(bignum_fromstring('1'), bignum_fromstring('0')));
	AssertEquals('1 > -1', 1, bignum_compare(bignum_fromstring('1'), bignum_fromstring('-1')));
	AssertEquals('-1 < 1', -1, bignum_compare(bignum_fromstring('-1'), bignum_fromstring('1')));
	AssertEquals('21 > 11', 1, bignum_compare(bignum_fromstring('21'), bignum_fromstring('11')));
	AssertEquals('10101 > 10001', 1, bignum_compare(bignum_fromstring('10101'), bignum_fromstring('10001')));
	
	n1 := bignum_fromstring('99999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999');	
	n2 := bignum_fromstring('99999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999998');	
	
	AssertEquals('maxnum -1 < maxnum', -1, bignum_compare(n2, n1));
	AssertEquals('maxnum > maxnum-1', 1, bignum_compare(n1, n2));
	
	n2 := bignum_fromstring('19999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999');	
	
	AssertEquals('almost maxnum < maxnum', -1, bignum_compare(n2, n1));
	AssertEquals('maxnum > almost maxnum', 1, bignum_compare(n1, n2));
end;

Procedure BigNumTestCase.DivisionTest;
begin
	AssertEquals('4 / 2 == 2', '2', bignum_tostring(bignum_divide(bignum_fromstring('4'), bignum_fromstring('2'))));
	AssertEquals('5 / 2 == 2', '2', bignum_tostring(bignum_divide(bignum_fromstring('5'), bignum_fromstring('2'))));
	AssertEquals('2 / 3 == 2', '0', bignum_tostring(bignum_divide(bignum_fromstring('2'), bignum_fromstring('3'))));
	AssertEquals('12 / 2 == 2', '6', bignum_tostring(bignum_divide(bignum_fromstring('12'), bignum_fromstring('2'))));
	AssertEquals('12 / 2 == 2', '6', bignum_tostring(bignum_divide(bignum_fromstring('12'), bignum_fromstring('2'))));
	
	// Limits
	AssertEquals('maxnum / maxnum == 1', '1', bignum_tostring(bignum_divide(bignum_fromstring('99999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999'), bignum_fromstring('99999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999'))));
	AssertEquals('maxnum / (maxnum/10) == 1', '10', bignum_tostring(bignum_divide(bignum_fromstring('99999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999'), bignum_fromstring('9999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999'))));
end;

Procedure BigNumTestCase.RemainderTest;
begin
	Fail('not implemented!');
end;

initialization
	RegisterTest(BigNumTestCase);
end.
