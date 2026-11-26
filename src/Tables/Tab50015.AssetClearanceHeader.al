table 50015 "Asset Clearance Header"
{
    Caption = 'Asset Clearance Header';
    DataClassification = CustomerContent;

    fields
    {
        field(1; "No."; Code[20])
        {
            Caption = 'No.';
            Editable = false;
        }
        field(2; "Employee No."; Code[20])
        {
            Caption = 'Employee No.';
            TableRelation = Employee."No.";

            trigger OnValidate()
            var
                Employee: Record Employee;
                OtherClearance: Record "Asset Clearance Header";
            begin
                Clear("Employee Name");
                if "Employee No." = '' then
                    exit;

                OtherClearance.SetRange("Employee No.", "Employee No.");
                OtherClearance.SetRange(Status, OtherClearance.Status::Open);
                OtherClearance.SetFilter("No.", '<>%1', "No.");

                if not OtherClearance.IsEmpty() then
                    Error('Employee %1 already has an open asset clearance.', "Employee No.");

                if Employee.Get("Employee No.") then
                    "Employee Name" := CopyStr(Employee.FullName(), 1, MaxStrLen("Employee Name"));
            end;
        }
        field(3; "Employee Name"; Text[100])
        {
            Caption = 'Employee Name';
            Editable = false;
        }
        field(4; "Last Working Date"; Date)
        {
            Caption = 'Last Working Date';
        }
        field(5; Status; Enum "Asset Clearance Status")
        {
            Caption = 'Status';
            Editable = false;
        }
        field(6; "Created Date"; Date)
        {
            Caption = 'Created Date';
            Editable = false;
        }
        field(7; "Created By"; Code[50])
        {
            Caption = 'Created By';
            DataClassification = EndUserIdentifiableInformation;
            Editable = false;
        }
        field(8; "Cleared Date"; Date)
        {
            Caption = 'Cleared Date';
            Editable = false;
        }
        field(9; Remarks; Text[250])
        {
            Caption = 'Remarks';
        }
    }
    keys
    {
        key(PK; "No.")
        {
            Clustered = true;
        }
        key(Employee; "Employee No.", Status)
        {
        }
    }
    trigger OnInsert()
    var
        AssetSetup: Record "Asset Setup";
        NoSeries: Codeunit "No. Series";
    begin
        if "No." = '' then begin
            AssetSetup.Get();
            AssetSetup.TestField("Clearance Nos.");
            "No." := NoSeries.GetNextNo(AssetSetup."Clearance Nos.", WorkDate(), true);
        end;

        "Created Date" := Today();
        "Created By" := CopyStr(UserId(), 1, MaxStrLen("Created By"));
    end;
}