unit BigNumTest;

{$mode objfpc}{$H+}

interface
uses
	fpcunit, testregistry, BigNum;

type
	BigNumTestCase = class(TTestCase)
	Published
		Procedure InitTest;
		
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

initialization
	RegisterTest(BigNumTestCase);
end.