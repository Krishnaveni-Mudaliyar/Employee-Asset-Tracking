query 50004 "AST Warranty Expiry Report"
{
    QueryType = API;
    APIPublisher = 'krishnavenimudaliyar';
    APIGroup = 'assetTracking';
    APIVersion = 'v1.0';
    EntityName = 'warrantyExpiryReport';
    EntitySetName = 'warrantyExpiryReport';
    Caption = 'Warranty Expiry Report';

    elements
    {
        dataitem(ASTAsset; "AST Asset")
        {
            DataItemTableFilter = "Warranty Expiry Date" = FILTER('<>0D');
            column(No; "No.") { }
            column(Description; Description) { }
            column(Category; Category) { }
            column(WarrantyExpiryDate; "Warranty Expiry Date") { }
            column(DaysUntilExpiry; GetDaysUntilExpiry()) { }
            column(CurrentEmployee; "Current Employee") { }
            column(Cost; Cost) { }
        }
    }

    procedure GetDaysUntilExpiry(): Integer
    var
        Days: Integer;
    begin
        Days := ASTAsset."Warranty Expiry Date" - Today();
        exit(Days);
    end;
}