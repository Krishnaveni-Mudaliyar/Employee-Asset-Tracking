report 50206 "Asset Handover"
{
    ApplicationArea = All;
    Caption = 'Asset Handover';
    UsageCategory = ReportsAndAnalysis;
    DefaultLayout = Excel;
    ExcelLayout = 'src\Report Layouts\AssetHandoverReport.xlsx';

    dataset
    {
        dataitem(AssetAssignment; "Asset Assignment")
        {
            column(AssignmentNo; "No.") { }
            // column(RequestNo; "Document No.") { }
            column(AssetNo; "Asset No.") { }
            column(AssetDescription; AssetDescription) { }
            column(EmployeeNo; "Employee No.") { }
            column(EmployeeName; EmployeeName) { }
            // column(DepartmentCode; DepartmentCode) { }
            column(AssignmentDate; Format("Assignment Date")) { }
            column(ExpectedReturnDate; Format("Expected Return Date")) { }
            column(AssignedBy; "Assigned By") { }
            column(SerialNo; SerialNo) { }
            column(AssetTagNo; AssetTagNo) { }
            column(BrandCode; BrandCode) { }
            column(ModelNo; ModelNo) { }
            column(CompanyName; CompanyProperty.DisplayName()) { }


            // trigger OnAfterGetRecord()
            // var
            //     FixedAsset: Record "Fixed Asset";
            //     Employee: Record Employee;
            // begin
            //     Clear(AssetDescription);
            //     Clear(AssetSerialNo);
            //     Clear(AssetTagNo);
            //     Clear(AssetCondition);
            //     if FixedAsset.Get("Asset No.")
            //     then begin
            //         AssetDescription := FixedAsset.Description;
            //         AssetSerialNo := FixedAsset."IT Serial No.";
            //         AssetTagNo := FixedAsset."Asset Tag No.";
            //         AssetCondition := Format(FixedAsset."Asset Condition");
            //     end;

            //     Clear(EmployeeName);
            //     Clear(DepartmentCode);
            //     if Employee.Get("Employee No.")
            //     then begin
            //         EmployeeName := CopyStr(DelChr(Employee."First Name" + ' ' + Employee."Last Name", '<>', ' '), 1, MaxStrLen(EmployeeName));
            //         ;
            //         ;
            //         DepartmentCode := Employee."Global Dimension 1 Code";
            //     end;
            // end;

            trigger OnAfterGetRecord()
            var
                FixedAsset: Record "Fixed Asset";
            begin
                EmployeeName := GetEmployeeName("Employee No.");
                Clear(SerialNo);
                Clear(AssetTagNo);
                Clear(BrandCode);
                Clear(ModelNo);
                AssetDescription := '';

                if FixedAsset.Get("Asset No.") then begin
                    AssetDescription := FixedAsset.Description;
                    SerialNo := FixedAsset."Serial No.";
                    AssetTagNo := FixedAsset."Asset Tag No.";
                    BrandCode := FixedAsset."Brand Code";
                    ModelNo := FixedAsset."Model No.";
                end;
            end;
        }
    }
    var
        // AssetDescription: Text[100];
        // AssetSerialNo: Code[50];
        // AssetTagNo: Code[50];
        // AssetCondition: Text[30];
        // EmployeeName: Text[150];
        // DepartmentCode: Code[20];
        EmployeeName: Text;
        AssetDescription: Text;
        SerialNo: Text;
        AssetTagNo: Text;
        BrandCode: Text;
        ModelNo: Text;

    local procedure GetEmployeeName(EmployeeNo: Code[20]): Text
    var
        Employee: Record Employee;
    begin
        if Employee.Get(EmployeeNo) then
            exit(Employee.FullName());
    end;
}