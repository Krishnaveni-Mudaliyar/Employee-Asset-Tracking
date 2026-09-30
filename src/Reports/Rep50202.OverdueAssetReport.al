report 50202 "Overdue Asset Report"
{
    ApplicationArea = All;
    Caption = 'Overdue Asset Report';
    UsageCategory = ReportsAndAnalysis;
    DefaultLayout = Excel;
    ExcelLayout = 'src/Report Layouts/OverdueAssetReport.xlsx';

    dataset
    {
        dataitem("Asset Assignment"; "Asset Assignment")
        {
            RequestFilterFields = "Asset No.", "Employee No.", "Expected Return Date";

            column(AssetNo; "Asset No.") { }
            column(AssetDescription; AssetDescription) { }
            column(EmployeeNo; "Employee No.") { }
            column(EmployeeName; EmployeeName) { }
            column(Assignment_Date; Format("Assignment Date")) { }
            column(Expected_Return_Date; Format("Expected Return Date")) { }
            column(DaysOverdue; DaysOverdue) { }
            column(LocationCode; LocationCode) { }
            column(StatusText; StatusText) { }

            trigger OnPreDataItem()
            begin
                SetRange(Active, true);
                SetFilter("Expected Return Date", '<>%1&<%2', 0D, Today);
            end;

            trigger OnAfterGetRecord()
            var
                FixedAsset: Record "Fixed Asset";
                Employee: Record Employee;
            begin
                Clear(AssetDescription);
                Clear(LocationCode);
                Clear(StatusText);

                if FixedAsset.Get("Asset No.") then begin
                    AssetDescription := FixedAsset.Description;
                    LocationCode := FixedAsset."IT Location Code";
                    StatusText := Format(FixedAsset."IT Asset Status");
                end;

                Clear(EmployeeName);
                if Employee.Get("Employee No.") then
                    EmployeeName := CopyStr(
DelChr(Employee."First Name" +
'' + Employee."Last Name",
'<>', ' '),
1, MaxStrLen(EmployeeName));

                DaysOverdue := Today - "Expected Return Date";
            end;
        }
    }
    var
        AssetDescription: Text[100];
        EmployeeName: Text[150];
        LocationCode: Code[10];
        StatusText: Text[30];
        DaysOverdue: Integer;
}
