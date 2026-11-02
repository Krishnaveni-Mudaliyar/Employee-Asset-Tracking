report 50206 "Asset Handover Report"
{
    ApplicationArea = All;
    Caption = 'Asset Handover Report';
    UsageCategory = ReportsAndAnalysis;
    DefaultLayout = Excel;
    ExcelLayout = 'src\Report Layouts\AssetHandoverReport.xlsx';

    dataset
    {
        dataitem(AssetAssignment; "Asset Assignment")
        {
            column(AssignmentNo; "No.") { }
            column(RequestNo; "Document No.") { }
            column(AssetNo; "Asset No.") { }
            column(AssetDescription; AssetDescription) { }
            column(AssetSerialNo; AssetSerialNo) { }
            column(AssetTagNo; AssetTagNo) { }
            column(AssetCondition; AssetCondition) { }
            column(EmployeeNo; "Employee No.") { }
            column(EmployeeName; EmployeeName) { }
            column(DepartmentCode; DepartmentCode) { }
            column(AssignmentDate; Format("Assignment Date")) { }
            column(ExpectedReturnDate; Format("Expected Return Date")) { }
            column(AssignedBy; "Assigned By") { }

            trigger OnAfterGetRecord()
            var
                FixedAsset: Record "Fixed Asset";
                Employee: Record Employee;
            begin
                Clear(AssetDescription);
                Clear(AssetSerialNo);
                Clear(AssetTagNo);
                Clear(AssetCondition);
                if FixedAsset.Get("Asset No.")
                then begin
                    AssetDescription := FixedAsset.Description;
                    AssetSerialNo := FixedAsset."IT Serial No.";
                    AssetTagNo := FixedAsset."IT Asset Tag No.";
                    AssetCondition := Format(FixedAsset."IT Asset Condition");
                end;

                Clear(EmployeeName);
                Clear(DepartmentCode);
                if Employee.Get("Employee No.")
                then begin
                    EmployeeName := CopyStr(DelChr(Employee."First Name" + ' ' + Employee."Last Name", '<>', ' '), 1, MaxStrLen(EmployeeName));
                    ;
                    ;
                    DepartmentCode := Employee."Global Dimension 1 Code";
                end;
            end;
        }
    }
    var
        AssetDescription: Text[100];
        AssetSerialNo: Code[50];
        AssetTagNo: Code[50];
        AssetCondition: Text[30];
        EmployeeName: Text[150];
        DepartmentCode: Code[20];
}