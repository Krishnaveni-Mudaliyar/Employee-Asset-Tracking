report 50207 "Asset Return"
{
    ApplicationArea = All;
    Caption = 'Asset Return';
    UsageCategory = ReportsAndAnalysis;
    DefaultLayout = Excel;
    ExcelLayout = 'src\Report Layouts\AssetReturnReport.xlsx';

    dataset
    {
        dataitem(AssetReturn; "Asset Return")
        {
            // RequestFilterFields = "No.", "Asset No.", "Employee No.", "Return Date", Condition;
            RequestFilterFields = "Return Date", "Asset No.", "Employee No.";

            column(ReturnNo; "No.") { }
            column(AssetNo; "Asset No.") { }
            column(AssetDescription; AssetDescription) { }
            column(EmployeeNo; "Employee No.") { }
            column(EmployeeName; EmployeeName) { }
            column(ReturnDate; Format("Return Date")) { }
            column(ConditionText; Format(Condition)) { }
            column(Remarks; Remarks) { }
            column(ReturnedBy; "Returned By") { }

            // trigger OnAfterGetRecord()
            // var
            //     FixedAsset: Record "Fixed Asset";
            //     Employee: Record Employee;
            // begin
            //     Clear(AssetDescription);
            //     if FixedAsset.Get("Asset No.")
            //     then
            //         AssetDescription := FixedAsset.Description;

            //     Clear(EmployeeName);
            //     if Employee.Get("Employee No.")
            //     then
            //         EmployeeName := CopyStr(DelChr(Employee."First Name" + ' ' + Employee."Last Name", '<>', ' '), 1, MaxStrLen(EmployeeName));
            // end;


            trigger OnAfterGetRecord()
            begin
                EmployeeName := GetEmployeeName("Employee No.");
                AssetDescription := GetAssetDescription("Asset No.");
            end;
        }
    }
    var
        AssetDescription: Text[100];
        EmployeeName: Text[150];

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