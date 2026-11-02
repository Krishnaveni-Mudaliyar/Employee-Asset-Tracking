report 50207 "Asset Return Report"
{
    ApplicationArea = All;
    Caption = 'Asset Return Report';
    UsageCategory = ReportsAndAnalysis;
    DefaultLayout = Excel;
    ExcelLayout = 'src\Report Layouts\AssetReturnReport.xlsx';

    dataset
    {
        dataitem(AssetReturn; "Asset Return")
        {
            RequestFilterFields = "No.", "Asset No.", "Employee No.", "Return Date", Condition;
            column(ReturnNo; "No.") { }
            column(AssetNo; "Asset No.") { }
            column(AssetDescription; AssetDescription) { }
            column(EmployeeNo; "Employee No.") { }
            column(EmployeeName; EmployeeName) { }
            column(ReturnDate; Format("Return Date")) { }
            column(ConditionText; Format(Condition)) { }
            column(Remarks; Remarks) { }
            column(ReturnedBy; "Returned By") { }

            trigger OnAfterGetRecord()
            var
                FixedAsset: Record "Fixed Asset";
                Employee: Record Employee;
            begin
                Clear(AssetDescription);
                if FixedAsset.Get("Asset No.")
                then
                    AssetDescription := FixedAsset.Description;

                Clear(EmployeeName);
                if Employee.Get("Employee No.")
                then
                    EmployeeName := CopyStr(DelChr(Employee."First Name" + ' ' + Employee."Last Name", '<>', ' '), 1, MaxStrLen(EmployeeName));
            end;
        }
    }
    var
        AssetDescription: Text[100];
        EmployeeName: Text[150];
}