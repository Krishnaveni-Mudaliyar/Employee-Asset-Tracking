codeunit 50053 "AST Test Data Library"
{
    procedure CreateAsset(var Asset: Record "AST Asset"; Description: Text[100])
    begin
        Asset.Init();
        Asset."No." := CopyStr(Format(CreateGuid()), 1, MaxStrLen(Asset."No."));
        Asset.Description := Description;
        Asset.Insert(true);
    end;

    procedure CreateCategory(var Category: Record "AST Asset Category"; Code: Code[20]; Description: Text[100])
    begin
        Category.Init();
        Category.Code := Code;
        Category.Description := Description;
        Category.Insert(true);
    end;
}
