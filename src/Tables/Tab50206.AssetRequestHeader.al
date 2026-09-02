table 50206 "Asset Request Header"
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
        field(13; "Shortcut Dimension 1 Code"; Code[20])
        {
            CaptionClass = '1,2,1';
            Caption = 'Shortcut Dimension 1 Code';
            TableRelation = "Dimension Value".Code where("Global Dimension No." = const(1));

            trigger OnValidate()
            begin
                DimMgt.ValidateShortcutDimValues(1, "Shortcut Dimension 1 Code", "Dimension Set ID");
            end;
        }
        field(14; "Shortcut Dimension 2 Code"; Code[20])
        {
            CaptionClass = '1,2,2';
            Caption = 'Shortcut Dimension 2 Code';
            TableRelation = "Dimension Value".Code where("Global Dimension No." = const(2));

            trigger OnValidate()
            begin
                DimMgt.ValidateShortcutDimValues(2, "Shortcut Dimension 2 Code", "Dimension Set ID");
            end;
        }
        field(15; "Dimension Set ID"; Integer)
        {
            Caption = 'Dimension Set ID';
            Editable = false;
            TableRelation = "Dimension Set Entry"."Dimension Set ID";

            trigger OnLookup()
            begin
                ShowDimensions();
            end;
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

    var
        DimMgt: Codeunit DimensionManagement;

    procedure ShowDimensions()
    begin
        // NOTE: see the same caveat as on the Asset table — verify EditDimensionSet's
        // signature against your BC 28 symbols before relying on this.
        "Dimension Set ID" :=
            DimMgt.EditDimensionSet(Database::"Asset Request Header", "Dimension Set ID", "No.", "Shortcut Dimension 1 Code", "Shortcut Dimension 2 Code");
        Modify(true);
    end;

    [IntegrationEvent(false, false)]
    procedure OnSendAssetRequestForApproval(
        var
        AssetRequestHeader: Record "Asset Request Header")
    begin
    end;
}