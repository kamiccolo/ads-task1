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
	AssertEquals('Medium length string test', bignum_tostring(num), '1');
	num := bignum_fromstring('1232112423');
	AssertEquals('Medium length string test', bignum_tostring(num), '1232112423');
	num := bignum_fromstring('0000');
	AssertEquals('Bunch of zeroes test.', bignum_tostring(num), '0');
	num := bignum_fromstring('2132132001223232132111123213213211');
	AssertEquals('Number with a zero in the middle', bignum_tostring(num), '2132132001223232132111123213213211');
	
end;

initialization
	RegisterTest(BigNumTestCase);
end.