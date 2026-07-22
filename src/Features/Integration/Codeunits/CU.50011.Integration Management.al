codeunit 50011 "AST Integration Management"
{
    procedure GetAssetSummary(AssetNo: Code[20]; var Asset: Record "AST Asset")
    begin
        Asset.Get(AssetNo);
        Asset.CalcFields();
    end;

    procedure IsWarrantyExpiring(Asset: Record "AST Asset"; DaysAhead: Integer): Boolean
    begin
        if Asset."Warranty Expiry Date" = 0D then
            exit(false);
        exit(Asset."Warranty Expiry Date" <= CalcDate('<+' + Format(DaysAhead) + 'D>', WorkDate()));
    end;
}