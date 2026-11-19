report 50205 "Asset Assignments"
{
    ApplicationArea = All;
    Caption = 'Asset Assignments';
    UsageCategory = ReportsAndAnalysis;
    DefaultLayout = Excel;
    ExcelLayout = 'src\Report Layouts\AssetAssignmentReport.xlsx';

    dataset
    {
        dataitem(AssetAssignment; "Asset Assignment")
        {
            DataItemTableView = where(Active = const(true));

            RequestFilterFields = "Asset No.", "Employee No.", "Assignment Date";

            column(AssignmentNo; "No.") { }
            // column(DocumentNo; "Document No.") { }
            // column(RequestNo; "Document No.") { }
            column(AssetNo; "Asset No.") { }
            column(AssetDescription; AssetDescription) { }
            column(EmployeeNo; "Employee No.") { }
            column(EmployeeName; EmployeeName) { }
            column(AssignmentDate; Format("Assignment Date")) { }
            column(ExpectedReturnDate; Format("Expected Return Date")) { }
            column(AssignedBy; "Assigned By") { }
            // column(ActiveText; Format(Active)) { }

            // trigger OnAfterGetRecord()
            // var
            //     FixedAsset: Record "Fixed Asset";
            //     Employee: Record Employee;
            // begin
            //     Clear(AssetDescription);
            //     if FixedAsset.Get("Asset No.") then
            //         AssetDescription := FixedAsset.Description;

            //     Clear(EmployeeName);
            //     if Employee.Get("Employee No.") then
            //         EmployeeName :=
            //         CopyStr(
            //             DelChr(Employee."First Name" + ' ' + Employee."Last Name", '<>', ' '),
            //             1, MaxStrLen(EmployeeName));
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