report 50204 "Employee Asset Report"
{
    ApplicationArea = All;
    Caption = 'Employee Asset Report';
    UsageCategory = ReportsAndAnalysis;
    DefaultLayout = Excel;
    ExcelLayout = 'src\Report Layouts\EmployeeAssetReport.xlsx';

    dataset
    {
        dataitem(Employee; Employee)
        {
            RequestFilterFields = "No.", "Global Dimension 1 Code";

            column(EmployeeNo; "No.") { }
            column(EmployeeName; EmployeeNameText) { }
            column(DepartmentCode; "Global Dimension 1 Code") { }
            column(AssetCount; AssetCount) { }

            dataitem("Asset Assignment"; "Asset Assignment")
            {
                DataItemLink = "Employee No." = field("No.");
                DataItemTableView = sorting("Employee No.") where(Active = const(true));

                column(AssetNo; "Asset No.") { }
                column(AssetDescription; AssetDescription) { }
                column(AssetCategoryCode; AssetCategoryCode) { }
                column(AssetBrandCode; AssetBrandCode) { }
                column(AssetSerialNo; AssetSerialNo) { }
                column(AssignmentDate; Format("Assignment Date")) { }
                column(ExpectedReturnDate; Format("Expected Return Date")) { }

                trigger OnAfterGetRecord()
                var
                    FixedAsset: Record "Fixed Asset";
                begin
                    Clear(AssetDescription);
                    Clear(AssetCategoryCode);
                    Clear(AssetBrandCode);
                    Clear(AssetSerialNo);

                    if FixedAsset.Get("Asset Assignment"."Asset No.") then begin
                        AssetDescription := FixedAsset.Description;
                        AssetCategoryCode := FixedAsset."Asset Category Code";
                        AssetBrandCode := FixedAsset."Asset Brand Code";
                        AssetSerialNo := FixedAsset."IT Serial No.";
                    end;
                end;
            }

            trigger OnAfterGetRecord()
            begin
                EmployeeNameText :=
                    CopyStr(
                        DelChr(Employee."First Name" + ' ' + Employee."Last Name", '<>', ' '),
                        1, MaxStrLen(EmployeeNameText));

                AssetAssignment.SetRange("Employee No.", "No.");
                AssetAssignment.SetRange(Active, true);
                AssetCount := AssetAssignment.Count();
            end;
        }
    }

    requestpage
    {
        SaveValues = true;

        layout
        {
            area(Content)
            {
                group(Options)
                {
                    Caption = 'Options';

                    field(AssignedOnly; AssignedOnlyOpt)
                    {
                        Caption = 'Only Employees With Assigned Assets';
                        ApplicationArea = All;
                    }
                }
            }
        }
    }

    trigger OnPreReport()
    begin
        if AssignedOnlyOpt then
            Employee.SetFilter("No.", GetEmployeesWithAssetsFilter());
    end;

    var
        AssetAssignment: Record "Asset Assignment";
        AssetCount: Integer;
        AssignedOnlyOpt: Boolean;
        EmployeeNameText: Text[150];
        AssetDescription: Text[100];
        AssetCategoryCode: Code[20];
        AssetBrandCode: Code[20];
        AssetSerialNo: Code[50];

    local procedure GetEmployeesWithAssetsFilter(): Text
    var
        AssignmentFilter: Record "Asset Assignment";
        EmployeeFilterText: Text;
        LastEmployeeNo: Code[20];
    begin
        AssignmentFilter.SetRange(Active, true);
        AssignmentFilter.SetCurrentKey("Employee No.");

        if AssignmentFilter.FindSet() then
            repeat
                if AssignmentFilter."Employee No." <> LastEmployeeNo then begin
                    if EmployeeFilterText <> '' then
                        EmployeeFilterText += '|';
                    EmployeeFilterText += AssignmentFilter."Employee No.";
                    LastEmployeeNo := AssignmentFilter."Employee No.";
                end;
            until AssignmentFilter.Next() = 0;

        if EmployeeFilterText = '' then
            EmployeeFilterText := '''''';

        exit(EmployeeFilterText);
    end;
}