report 50203 "Pending Asset Requests"
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
            // column(HdrStatusText; Format(Status)) { }
            // column(DaysPending; DaysPending) { }

            /*  dataitem("Asset Request Line"; "Asset Request Line")
              {
                  DataItemLink = "Document No." = field("No.");
                  DataItemTableView = sorting("Document No.", "Line No.");

                  column(LineCategoryCode; "Asset Category Code") { }
                  column(LineSubCategoryCode; "Asset Sub Category Code") { }
                  column(LineDescription; Description) { }
                  column(LineQuantity; Quantity) { }
                  column(LineApprovedQuantity; "Approved Quantity") { }
                  column(LineAssignedQuantity; "Assigned Quantity") { }
                  column(LineRemainingQuantity; RemainingQuantity) { }

                  trigger OnAfterGetRecord()
                  begin
                      RemainingQuantity := "Approved Quantity" - "Assigned Quantity";
                  end;
              }

            trigger OnPreDataItem()
            begin
                SetFilter(
                    Status, '%1|%2|%3',
                    Status::Open,
                    Status::"Pending Approval",
                    Status::Approved);
            end;

            trigger OnAfterGetRecord()
            var
                Employee: Record Employee;
            begin
                Clear(EmployeeName);
                if Employee.Get("Employee No.") then
                    EmployeeName :=
                    CopyStr(
                        DelChr(Employee."First Name" + '' + Employee."Last Name", '<>', ' '),
                        1, MaxStrLen(EmployeeName));
                if "Request Date" <> 0D then
                    DaysPending := Today - "Request Date"
                else
                    DaysPending := 0;
            end; */

            trigger OnAfterGetRecord()
            begin
                EmployeeName := GetEmployeeName("Employee No.");
            end;

        }
    }

    var
        EmployeeName: Text[150];
    // DaysPending: Integer;
    // RemainingQuantity: Decimal;

    local procedure GetEmployeeName(EmployeeNo: Code[20]): Text
    var
        Employee: Record Employee;
    begin
        if Employee.Get(EmployeeNo) then
            exit(Employee.FullName());
    end;
}