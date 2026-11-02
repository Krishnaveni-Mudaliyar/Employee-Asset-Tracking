report 50210 "Asset Assignment History"
{
    ApplicationArea = All;
    Caption = 'Asset Assignment History';
    UsageCategory = ReportsAndAnalysis;
    DefaultLayout = Excel;
    ExcelLayout = './src/Report Layouts/AssetAssignmentHistory.xlsx';

    dataset
    {
        dataitem(Assignment; "Asset Assignment")
        {
            RequestFilterFields = "Asset No.", "Employee No.", "Assignment Date";

            column(AssetNo; "Asset No.") { }
            column(AssetDescription; AssetDescription) { }
            column(EmployeeNo; "Employee No.") { }
            column(EmployeeName; EmployeeName) { }
            column(AssignmentDate; Format("Assignment Date")) { }
            column(ReturnDate; ReturnDateText) { }
            column(StatusText; StatusText) { }
            column(ConditionOnReturn; ConditionText) { }

            trigger OnAfterGetRecord()
            var
                AssetReturn: Record "Asset Return";
            begin
                EmployeeName := GetEmployeeName("Employee No.");
                AssetDescription := GetAssetDescription("Asset No.");
                ReturnDateText := '';
                ConditionText := '';
                StatusText := 'Active';

                if not Active then begin
                    StatusText := 'Returned';
                    AssetReturn.SetRange("Asset No.", "Asset No.");
                    AssetReturn.SetRange("Employee No.", "Employee No.");
                    AssetReturn.SetFilter("Return Date", '>=%1', "Assignment Date");
                    if AssetReturn.FindFirst() then begin
                        ReturnDateText := Format(AssetReturn."Return Date");
                        ConditionText := Format(AssetReturn.Condition);
                    end;
                end;
            end;
        }
    }

    var
        EmployeeName: Text;
        AssetDescription: Text;
        ReturnDateText: Text;
        StatusText: Text;
        ConditionText: Text;

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