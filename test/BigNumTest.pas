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
	num, num2, num3: BigNumType;
begin
	bignum_init(num);
	AssertEquals('BigNum should be initialized to zero.',bignum_tostring(num),'0');
	AssertEquals('BigNumType.positive should be initialized to 1.',num.positive,true);
	
	num.data[1]:=5;
	num2:=bignum_add(num, num);
	AssertEquals('BigNum_add. Adding two positive integers. Sum below 999....99.',bignum_tostring(num2),'10');
	

	
end;

initialization
	RegisterTest(BigNumTestCase);
end.
