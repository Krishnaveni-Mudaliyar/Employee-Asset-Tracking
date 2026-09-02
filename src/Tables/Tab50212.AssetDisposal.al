table 50212 "Asset Disposal"
{
    Caption = 'Asset Disposal';
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
        field(3; "Disposal Date"; Date)
        {
            Caption = 'Disposal Date';
        }
        field(4; Reason; Text[250])
        {
            Caption = 'Reason';
        }
        field(5; "Disposed By"; Code[50])
        {
            Caption = 'Disposed By';
            DataClassification = EndUserIdentifiableInformation;
            Editable = false;
        }
        field(6; "Created Date-Time"; DateTime)
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
            "No." := AssetSetupManagement.GetDisposalNo();

        if "Disposal Date" = 0D then
            "Disposal Date" := WorkDate();

        "Disposed By" := CopyStr(UserId(), 1, MaxStrLen("Disposed By"));
        "Created Date-Time" := CurrentDateTime();
    end;
}