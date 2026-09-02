table 50210 "Asset Transfer"
{
    Caption = 'Asset Transfer';
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
        field(3; "Transfer Date"; Date)
        {
            Caption = 'Transfer Date';
        }
        field(4; "From Employee No."; Code[20])
        {
            Caption = 'From Employee No.';
            TableRelation = Employee."No.";
            Editable = false;
        }
        field(5; "To Employee No."; Code[20])
        {
            Caption = 'To Employee No.';
            TableRelation = Employee."No.";
        }
        field(6; "From Location Code"; Code[20])
        {
            Caption = 'From Location Code';
            Editable = false;
        }
        field(7; "To Location Code"; Code[20])
        {
            Caption = 'To Location Code';
        }
        field(8; Remarks; Text[250])
        {
            Caption = 'Remarks';
        }
        field(9; "Transferred By"; Code[50])
        {
            Caption = 'Transferred By';
            DataClassification = EndUserIdentifiableInformation;
            Editable = false;
        }
        field(10; "Created Date-Time"; DateTime)
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
            "No." := AssetSetupManagement.GetTransferNo();

        if "Transfer Date" = 0D then
            "Transfer Date" := WorkDate();

        "Transferred By" := CopyStr(UserId(), 1, MaxStrLen("Transferred By"));
        "Created Date-Time" := CurrentDateTime();
    end;
}
