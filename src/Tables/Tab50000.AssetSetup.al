table 50000 "Asset Setup"
{
    Caption = 'Asset Setup';
    DataClassification = CustomerContent;

    fields
    {
        field(1; "Primary Key"; Code[10])
        {
            Caption = 'Primary Key';
            DataClassification = SystemMetadata;
        }
        field(10; "Asset Nos."; Code[20])
        {
            Caption = 'Asset Nos.';
            TableRelation = "No. Series".Code;
        }
        field(11; "Asset Request Nos."; Code[20])
        {
            Caption = 'Asset Request Nos.';
            TableRelation = "No. Series".Code;
        }
        field(12; "Assignment Nos."; Code[20])
        {
            Caption = 'Assignment Nos.';
            TableRelation = "No. Series".Code;
        }
        field(13; "Return Nos."; Code[20])
        {
            Caption = 'Return Nos.';
            TableRelation = "No. Series".Code;
        }
        field(14; "Transfer Nos."; Code[20])
        {
            Caption = 'Transfer Nos.';
            TableRelation = "No. Series".Code;
        }
        field(15; "Maintenance Nos."; Code[20])
        {
            Caption = 'Maintenance Nos.';
            TableRelation = "No. Series".Code;
        }
        field(16; "Disposal Nos."; Code[20])
        {
            Caption = 'Disposal Nos.';
            TableRelation = "No. Series".Code;
        }
    }
    keys
    {
        key(PK; "Primary Key")
        {
            Clustered = true;
        }
    }
}