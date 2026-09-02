report 50201 "Asset Register"
{
    ApplicationArea = All;
    Caption = 'Asset Register';
    UsageCategory = ReportsAndAnalysis;
    DefaultLayout = Excel;
    ExcelLayout = './src/Reports/Layouts/AssetRegister.xlsx';

    dataset
    {
        dataitem(Asset; Asset)
        {
            RequestFilterFields = "No.", "Category Code", "Sub Category Code", "Brand Code", Status, "Location Code", Blocked;

            column(AssetNo; "No.") { }
            column(Description; Description) { }
            column(CategoryCode; "Category Code") { }
            column(SubCategoryCode; "Sub Category Code") { }
            column(BrandCode; "Brand Code") { }
            column(ModelNo; "Model No.") { }
            column(SerialNo; "Serial No.") { }
            column(AssetTagNo; "Asset Tag No.") { }
            column(PurchaseDate; Format("Purchase Date")) { }
            column(PurchaseCost; "Purchase Cost") { }
            column(VendorNo; "Vendor No.") { }
            column(LocationCode; "Location Code") { }
            column(StatusText; Format(Status)) { }
            column(ConditionText; Format(Condition)) { }
            column(WarrantyStartDate; Format("Warranty Start Date")) { }
            column(WarrantyEndDate; Format("Warranty End Date")) { }
            column(BlockedText; Format(Blocked)) { }
        }
    }

    requestpage
    {
        SaveValues = true;

        layout
        {
            area(Content)
            {
                group(Options)
                {
                    Caption = 'Options';

                    field(IncludeBlocked; IncludeBlocked)
                    {
                        Caption = 'Include Blocked Assets';
                        ApplicationArea = All;
                    }
                }
            }
        }

        trigger OnOpenPage()
        begin
            IncludeBlocked := true;
        end;
    }

    trigger OnPreDataItem()
    begin
        if not IncludeBlocked then
            Asset.SetRange(Blocked, false);
    end;

    var
        IncludeBlocked: Boolean;
}