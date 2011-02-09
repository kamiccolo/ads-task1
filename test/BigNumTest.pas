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
	AssertEquals('Simple 42 test.', bignum_tostring(num), '42');
	
	bignum_init(num);
	num.data[1] := 0;
	num.data[2] := 2;
	num.data[3] := 4;
	AssertEquals('Number ending with a zero.', bignum_tostring(num), '420');
	
	bignum_init(num);
	num.data[1] := 1;
	num.data[2] := 0;
	num.data[3] := 2;
	num.data[4] := 4;
	AssertEquals('Number with a zero digit in the middle.', bignum_tostring(num), '4201');
end;

Procedure BigNumTestCase.FromStringTest;
var
	num: BigNumType;
begin
	num := bignum_fromstring('1');
	
	AssertEquals('1!', bignum_tostring(bignum_fromstring('1')), '1');
	AssertEquals('0!', bignum_tostring(bignum_fromstring('0')), '0');
	AssertEquals('passing empty string should yield zero', bignum_tostring(bignum_fromstring('')), '0');
	num := bignum_fromstring('1232112423');
	AssertEquals('Medium length string test', bignum_tostring(num), '1232112423');
	num := bignum_fromstring('0000');
	AssertEquals('Bunch of zeroes test.', bignum_tostring(num), '0');
	num := bignum_fromstring('2132132001223232132111123213213211');
	AssertEquals('Number with a zero in the middle', bignum_tostring(num), '2132132001223232132111123213213211');
end;

Procedure BigNumTestCase.AdditionTest;
var
	num, num2: BigNumType;
begin
	num := bignum_fromstring('5');
	num2:=bignum_add(num, num);
	AssertEquals('BigNum_add. Adding two positive integers. Sum below 999....99.',bignum_tostring(num2),'10');
	AssertEquals('0+0 == 0', bignum_tostring(bignum_add(bignum_fromstring('0'), bignum_fromstring('0'))), '0');
	AssertEquals('1+0 == 1.', bignum_tostring(bignum_add(bignum_fromstring('1'), bignum_fromstring('0'))), '1');
	AssertEquals('1+0 == 1.', bignum_tostring(bignum_add(bignum_fromstring('1'), bignum_fromstring('0'))), '1');
	AssertEquals('<Hugenum> + <Hugenum>.', bignum_tostring(bignum_add(bignum_fromstring('9999999999999999999999999999999999999999999'), bignum_fromstring('99999999999999999999999999999999999999999991'))), '109999999999999999999999999999999999999999990');
end;

initialization
	RegisterTest(BigNumTestCase);
end.
