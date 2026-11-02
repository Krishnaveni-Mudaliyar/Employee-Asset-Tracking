report 50201 "Asset Register"
{
    ApplicationArea = All;
    Caption = 'Asset Register';
    UsageCategory = ReportsAndAnalysis;
    DefaultLayout = Excel;
    ExcelLayout = 'src\Report Layouts\AssetRegister.xlsx';

    dataset
    {
        dataitem("Fixed Asset"; "Fixed Asset")
        {
            RequestFilterFields = "No.", "Asset Category Code", "Asset Sub Category Code", "Brand Code", "Asset Status", "FA Location Code", Blocked;

            column(AssetNo; "No.") { }
            column(Description; Description) { }
            column(CategoryCode; "Asset Category Code") { }
            column(SubCategoryCode; "Asset Sub Category Code") { }
            column(BrandCode; "Brand Code") { }
            column(ModelNo; "Model No.") { }
            column(SerialNo; "Serial No.") { }
            column(AssetTagNo; "Asset Tag No.") { }
            column(PurchaseDate; Format("Purchase Date")) { }
            column(PurchaseCost; "Purchase Cost") { }
            column(VendorNo; "Vendor No.") { }
            column(LocationCode; "FA Location Code") { }
            column(StatusText; Format("Asset Status")) { }
            column(ConditionText; Format("Asset Condition")) { }
            column(WarrantyStartDate; Format("Warranty Start Date")) { }
            column(WarrantyEndDate; Format("Warranty End Date")) { }
            column(BlockedText; Format(Blocked)) { }

            trigger OnPreDataItem()
            begin
                if not IncludeBlocked then
                    SetRange(Blocked, false);
            end;
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

    var
        IncludeBlocked: Boolean;
}