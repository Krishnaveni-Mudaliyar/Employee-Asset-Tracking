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
            RequestFilterFields = "No.", "Asset Category Code", "Asset Sub Category Code", "Asset Brand Code", "IT Asset Status", "IT Location Code", "IT Asset Blocked";

            column(AssetNo; "No.") { }
            column(Description; Description) { }
            column(CategoryCode; "Asset Category Code") { }
            column(SubCategoryCode; "Asset Sub Category Code") { }
            column(BrandCode; "Asset Brand Code") { }
            column(ModelNo; "IT Model No.") { }
            column(SerialNo; "IT Serial No.") { }
            column(AssetTagNo; "IT Asset Tag No.") { }
            column(LocationCode; "IT Location Code") { }
            column(StatusText; Format("IT Asset Status")) { }
            column(ConditionText; Format("IT Asset Condition")) { }
            column(WarrantyStartDate; Format("Warranty Start Date")) { }
            column(WarrantyEndDate; Format("Warranty End Date")) { }
            column(BlockedText; Format("IT Asset Blocked")) { }

            trigger OnPreDataItem()
            begin
                if not IncludeBlocked then
                    SetRange("IT Asset Blocked", false);
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