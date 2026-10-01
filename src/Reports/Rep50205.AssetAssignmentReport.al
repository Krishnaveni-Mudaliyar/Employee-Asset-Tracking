report 50205 "Asset Assignment Report"
{
    ApplicationArea = All;
    Caption = 'Asset Assignment Report';
    UsageCategory = ReportsAndAnalysis;
    DefaultLayout = Excel;
    ExcelLayout = 'src\Report Layouts\AssetAssignmentReport.xlsx';

    dataset
    {
        dataitem(AssetAssignment; "Asset Assignment")
        {
            RequestFilterFields = "No.", "Asset No.", "Employee No.", "Assignment Date", Active;
            column(No; "No.") { }
            column(DocumentNo; "Document No.") { }
            column(Asset_No_; "Asset No.") { }
            column(AssetDescription; AssetDescription) { }
            column(EmployeeNo; "Employee No.") { }
            column(EmployeeName; EmployeeName) { }
            column(AssignmentDate; Format("Assignment Date")) { }
            column(ExpectedReturnDate; Format("Expected Return Date")) { }
            column(AssignedBy; "Assigned By") { }
            column(ActiveText; Format(Active)) { }

            trigger OnAfterGetRecord()
            var
                FixedAsset: Record "Fixed Asset";
                Employee: Record Employee;
            begin
                Clear(AssetDescription);
                if FixedAsset.Get("Asset No.") then
                    AssetDescription := FixedAsset.Description;

                Clear(EmployeeName);
                if Employee.Get("Employee No.") then
                    EmployeeName :=
                    CopyStr(
                        DelChr(Employee."First Name" + ' ' + Employee."Last Name", '<>', ' '),
                        1, MaxStrLen(EmployeeName));
            end;
        }
    }
    var
        AssetDescription: Text[100];
        EmployeeName: Text[150];
}