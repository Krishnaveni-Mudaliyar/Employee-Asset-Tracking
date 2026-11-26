report 50003 "Overdue Assets"
{
    ApplicationArea = All;
    Caption = 'Overdue Assets';
    UsageCategory = ReportsAndAnalysis;
    DefaultLayout = Excel;
    ExcelLayout = 'src/Report Layouts/OverdueAssetReport.xlsx';

    dataset
    {
        dataitem("Asset Assignment"; "Asset Assignment")
        {
            DataItemTableView = where(Active = const(true));

            RequestFilterFields = "Asset No.", "Employee No.";

            column(AssignmentNo; "No.") { }
            column(AssetNo; "Asset No.") { }
            column(AssetDescription; AssetDescription) { }
            column(EmployeeNo; "Employee No.") { }
            column(EmployeeName; EmployeeName) { }
            column(Assignment_Date; Format("Assignment Date")) { }
            column(Expected_Return_Date; Format("Expected Return Date")) { }
            column(AssignedBy; "Assigned By") { }
            column(DaysOverdue; DaysOverdue) { }

            trigger OnPreDataItem()
            begin
                SetFilter("Expected Return Date", '<>%1&<%2', 0D, Today);
            end;

            trigger OnAfterGetRecord()
            begin
                EmployeeName := GetEmployeeName("Employee No.");
                AssetDescription := GetAssetDescription("Asset No.");
                DaysOverdue := Today() - "Expected Return Date";
            end;
        }
    }
    var
        AssetDescription: Text[100];
        EmployeeName: Text[150];
        LocationCode: Code[10];
        StatusText: Text[30];
        DaysOverdue: Integer;

    local procedure GetEmployeeName(EmployeeNo: Code[20]): Text
    var
        Employee: Record Employee;
    begin
        if Employee.Get(EmployeeNo) then
            exit(Employee.FullName());
    end;

    local procedure GetAssetDescription(AssetNo: Code[20]): Text
    var
        FixedAsset: Record "Fixed Asset";
    begin
        if FixedAsset.Get(AssetNo) then
            exit(FixedAsset.Description);
    end;
}