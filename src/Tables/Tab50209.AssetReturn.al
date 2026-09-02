table 50209 "Asset Return"
{
    Caption = 'Asset Return';
    DataClassification = CustomerContent;

    fields
    {
        field(1; "No."; Code[20])
        {
            Caption = 'No.';
        }
        field(2; "Asset No."; Code[20])
        {
            Caption = 'Asset No.';
            TableRelation = Asset."No.";
        }
        field(3; "Employee No."; Code[20])
        {
            Caption = 'Employee No.';
            TableRelation = Employee."No.";
            Editable = false;
        }
        field(4; "Return Date"; Date)
        {
            Caption = 'Return Date';
        }
        field(5; Condition; Enum "Asset Condition")
        {
            Caption = 'Condition';
        }
        field(6; Remarks; Text[250])
        {
            Caption = 'Remarks';
        }
        field(7; "Returned By"; Code[50])
        {
            Caption = 'Returned By';
            DataClassification = EndUserIdentifiableInformation;
            Editable = false;
        }
        field(8; "Created Date-Time"; DateTime)
        {
            Caption = 'Created Date-Time';
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
        key(Asset; "Asset No.") { }
    }

    trigger OnInsert()
    var
        AssetSetupManagement: Codeunit "Asset Setup Management";

    begin
        if "No." = '' then
            "No." := AssetSetupManagement.GetReturnNo();

        if "Return Date" = 0D then
            "Return Date" := WorkDate();

        "Returned By" := CopyStr(UserId(), 1, MaxStrLen("Returned By"));
        "Created Date-Time" := CurrentDateTime();
    end;
}
