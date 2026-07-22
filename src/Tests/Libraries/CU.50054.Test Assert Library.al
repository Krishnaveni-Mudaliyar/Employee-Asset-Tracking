codeunit 50054 "AST Test Assert Library"
{
    procedure AreEqual(Expected: Text; Actual: Text; Context: Text)
    begin
        if Expected <> Actual then
            Error('%1. Expected %2 but found %3.', Context, Expected, Actual);
    end;

    procedure IsTrue(Condition: Boolean; Context: Text)
    begin
        if not Condition then
            Error(Context);
    end;
}
