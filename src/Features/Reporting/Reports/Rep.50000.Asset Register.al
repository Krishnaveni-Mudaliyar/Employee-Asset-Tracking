report 50000 "AST Asset Register"
{
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;
    Caption = 'Asset Register';
    DefaultRenderingLayout = AssetRegisterRDLC;

    dataset
    {
        dataitem(ASTAsset; "AST Asset")
        {
            DataItemTableView = where(Active = const(true));
            RequestFilterFields = "No.", Category, Status;

            column(CompanyName_Col; CompanyInfo.Name)
            {
                IncludeCaption = true;
            }
            column(AssetNo_Col; "No.") { }
            column(Description_Col; Description) { }
            column(Category_Col; Category) { }
            column(Status_Col; Status) { }
            column(CurrentEmployee_Col; "Current Employee") { }
            column(AssignmentDate_Col; "Assignment Date") { }
            column(Cost_Col; Cost) { }
            column(WarrantyExpiryDate_Col; "Warranty Expiry Date") { }
            column(MaintenanceStatus_Col; "Maintenance Status") { }
            column(LastMaintenanceDate_Col; "Last Maintenance Date") { }
            column(AssetCondition_Col; "Asset Condition") { }
            column(SerialNumber_Col; "Serial Number") { }

            dataitem(ASTAssignment; "AST Assignment")
            {
                DataItemLink = "Asset No." = ASTAsset."No.";
                DataItemTableView = where(Status = const("Active"));

                column(AssignmentNo_Col; "Assignment No.") { }
                column(EmployeeName_Col; "Employee Name") { }
                column(EmployeeNo_Col; "Employee No.") { }
                column(AssignmentNotes_Col; "Assignment Notes") { }
            }
        }
    }
    rendering
    {
        layout(AssetRegisterRDLC)
        {
            Type = RDLC;
            LayoutFile = 'Report Layout\Asset Register.rdlc';
            Caption = 'Asset Register (RDLC)';
            Summary = 'Default layout for Asset Register';
        }
    }
    requestpage
    {
        SaveValues = true;
        layout
        {
            area(content)
            {
                group(Filters)
                {
                    Caption = 'Filters';
                    field(AssetNo; AssetNoFilter)
                    {
                        Caption = 'Asset No.';
                        ApplicationArea = All;
                    }
                    field(CategoryFilter; CategoryFilter)
                    {
                        Caption = 'Category';
                        ApplicationArea = All;
                        TableRelation = "AST Asset Category".Code;
                    }
                                       field(StatusFilter; StatusFilterEnum)
                    {
                        Caption = 'Status';
                        ApplicationArea = All;
                    }
                }
            }
        }
    }

    trigger OnPreReport()
    begin
        CompanyInfo.Get();
     
        if AssetNoFilter <> '' then
            ASTAsset.SetFilter("No.", AssetNoFilter);

        if CategoryFilter <> '' then
            ASTAsset.SetFilter(Category, CategoryFilter);

           if StatusFilterEnum <> ASTAsset.Status::Available then
            ASTAsset.SetRange(Status, StatusFilterEnum);
    end;

    var
        CompanyInfo: Record "Company Information";
        AssetNoFilter: Code[20];
        CategoryFilter: Code[20];
        StatusFilterEnum: Enum "Asset Status";
}