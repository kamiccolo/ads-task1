unit bignum;

interface
uses
	fpcunit, testregistry;

type
	TMyTestCase = class(TTestCase)
	Published
		Procedure MySillyTest;
	Protected
		Procedure Setup;
		Procedure Teardown;
	end;
	
implementation

Procedure TMyTestCase.MySillyTest;
begin
	AssertEquals('The compiler cannot count !',2,1+1);
end;

Procedure TMyTestCase.Setup;
begin
	writeln('this is a test initialization');
end;

Procedure TMyTestCase.Teardown;
begin
	writeln('this is a test teardown');
end;

initialization
	RegisterTest(TMyTestCase);
end.