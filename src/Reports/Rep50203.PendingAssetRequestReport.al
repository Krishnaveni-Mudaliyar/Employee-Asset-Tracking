report 50203 "Pending Asset Request Report"
{
    ApplicationArea = All;
    Caption = 'Pending Asset Request Report';
    UsageCategory = ReportsAndAnalysis;
    DefaultLayout = Excel;
    ExcelLayout = 'src\Report Layouts\PendingAssetRequestReport.xlsx';

    dataset
    {
        dataitem(AssetRequestHeader; "Asset Request Header")
        {
            RequestFilterFields = "No.", "Employee No.", Status, "Department Code", "Location Code";

            column(No; "No.") { }
            column(EmployeeNo; "Employee No.") { }
            column(EmployeeName; EmployeeName) { }
            column(RequestDate; Format("Request Date")) { }
            column(RequiredDate; Format("Required Date")) { }
            column(DepartmentCode; "Department Code") { }
            column(LocationCode; "Location Code") { }
            column(HdrStatusText; Format(Status)) { }
            column(DaysPending; DaysPending) { }

            dataitem("Asset Request Line"; "Asset Request Line")
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
            end;
        }
    }

    var
        EmployeeName: Text[150];
        DaysPending: Integer;
        RemainingQuantity: Decimal;
}