report 50008 "Asset Handover"
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
            column(AssetNo; "Asset No.") { }
            column(AssetDescription; AssetDescription) { }
            column(EmployeeNo; "Employee No.") { }
            column(EmployeeName; EmployeeName) { }
            column(AssignmentDate; Format("Assignment Date")) { }
            column(ExpectedReturnDate; Format("Expected Return Date")) { }
            column(AssignedBy; "Assigned By") { }
            column(SerialNo; SerialNo) { }
            column(AssetTagNo; AssetTagNo) { }
            column(BrandCode; BrandCode) { }
            column(ModelNo; ModelNo) { }
            column(CompanyName; CompanyProperty.DisplayName()) { }

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
        EmployeeName, AssetDescription, SerialNo, AssetTagNo, BrandCode, ModelNo : Text;

    local procedure GetEmployeeName(EmployeeNo: Code[20]): Text
    var
        Employee: Record Employee;
    begin
        if Employee.Get(EmployeeNo) then
            exit(Employee.FullName());
    end;
}