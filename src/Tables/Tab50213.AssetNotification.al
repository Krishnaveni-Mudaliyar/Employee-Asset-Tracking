table 50213 "Asset Notification"
{
    Caption = 'Asset Notification';
    DataClassification = CustomerContent;

    fields
    {
        field(1; "Entry No."; Integer)
        {
            Caption = 'Entry No.';
            AutoIncrement = true;
        }
        field(2; "Recipient User ID"; Code[50])
        {
            Caption = 'Recipient User ID';
            DataClassification = EndUserIdentifiableInformation;
        }
        field(3; Message; Text[250])
        {
            Caption = 'Message';
        }
        field(4; "Related Document No."; Code[20])
        {
            Caption = 'Related Document No.';
        }
        field(5; "Created Date-Time"; DateTime)
        {
            Caption = 'Created Date-Time';
            DataClassification = SystemMetadata;
            Editable = false;
        }
        field(6; Read; Boolean)
        {
            Caption = 'Read';
        }
    }
    keys
    {
        key(PK; "Entry No.")
        {
            Clustered = true;
        }
        key(Recipient; "Recipient User ID", Read) { }
    }

    trigger OnInsert()
    begin
        "Created Date-Time" := CurrentDateTime();
    end;
}