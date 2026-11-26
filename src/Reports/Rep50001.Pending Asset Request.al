report 50001 "Pending Asset Requests"
{
    ApplicationArea = All;
    Caption = 'Pending Asset Requests';
    UsageCategory = ReportsAndAnalysis;
    DefaultLayout = Excel;
    ExcelLayout = 'src\Report Layouts\PendingAssetRequestReport.xlsx';

    dataset
    {
        dataitem(AssetRequestHeader; "Asset Request Header")
        {
            DataItemTableView = where(Status = const("Pending Approval"));
            RequestFilterFields = "No.", "Employee No.", "Request Date";

            column(RequestNo; "No.") { }
            column(EmployeeNo; "Employee No.") { }
            column(EmployeeName; EmployeeName) { }
            column(RequestDate; Format("Request Date")) { }
            column(RequiredDate; Format("Required Date")) { }
            column(DepartmentCode; "Department Code") { }
            column(LocationCode; "Location Code") { }
            column(Reason; Reason) { }
            column(RequestedBy; "Requested By") { }

            trigger OnAfterGetRecord()
            begin
                EmployeeName := GetEmployeeName("Employee No.");
            end;

        }
    }

    var
        EmployeeName: Text[150];

    local procedure GetEmployeeName(EmployeeNo: Code[20]): Text
    var
        Employee: Record Employee;
    begin
        if Employee.Get(EmployeeNo) then
            exit(Employee.FullName());
    end;
}