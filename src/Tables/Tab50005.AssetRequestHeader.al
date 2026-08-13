table 50005 "Asset Request Header"
{
    Caption = 'Asset Request Header';
    DataClassification = CustomerContent;

    fields
    {
        field(1; "No."; Code[20])
        {
            Caption = 'No.';
        }
        field(2; "Employee No."; Code[20])
        {
            Caption = 'Employee No.';
            TableRelation = Employee."No.";

            trigger OnValidate()
            var
                Employee: Record Employee;
            begin
                if "Employee No." = '' then
                    exit;

                Employee.Get("Employee No.");
            end;
        }
        field(3; "Request Date"; Date)
        {
            Caption = 'Request Date';
        }
        field(4; "Required Date"; Date)
        {
            Caption = 'Required Date';

            trigger OnValidate()
            begin
                if ("Required Date" <> 0D) and
                   ("Request Date" <> 0D) and
                    ("Required Date" < "Request Date")
                then
                    Error(
                        'Required Date cannot be earlier than Request Date');
            end;
        }
        field(5; "Department Code"; Code[20])
        {
            Caption = 'Department Code';
        }
        field(6; "Location Code"; Code[20])
        {
            Caption = 'Location Code';
        }
        field(7; Reason; Text[250])
        {
            Caption = 'Reason';
        }
        field(8; Status; Enum "Asset Request Status")
        {
            Caption = 'Status';
        }
        field(9; "Requested By"; Code[50])
        {
            Caption = 'Requested By';
            DataClassification = EndUserIdentifiableInformation;
        }
        field(10; "Created Date-Time"; DateTime)
        {
            Caption = 'Created Date-Time';
            DataClassification = SystemMetadata;
            Editable = false;
        }
        field(11; "Approved By"; Code[50])
        {
            Caption = 'Approved By';
            DataClassification = EndUserIdentifiableInformation;
        }
        field(12; "Approval Date-Time"; DateTime)
        {
            Caption = 'Approval Date-Time';
            DataClassification = SystemMetadata;
            Editable = false;
        }
    }
    keys
    {
        key(PK; "No.")
        {
            Clustered = true;
        }
        key(Employee; "Employee No.", Status) { }
        key(Status; Status) { }
    }

    trigger OnInsert()
    var
        AssetSetupManagement: Codeunit "Asset Setup Management";
    begin
        if "No." = '' then
            "No." := AssetSetupManagement.GetAssetRequestNo();

        if "Request Date" = 0D then
            "Request Date" := WorkDate();

        "Requested By" := CopyStr(UserId(), 1, MaxStrLen("Requested By"));
        "Created Date-Time" := CurrentDateTime();

        Status := Status::Open;
    end;
}