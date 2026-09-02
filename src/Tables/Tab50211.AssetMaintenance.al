table 50211 "Asset Maintenance"
{
    Caption = 'Asset Maintenance';
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
        field(3; "Start Date"; Date)
        {
            Caption = 'Start Date';
        }
        field(4; "End Date"; Date)
        {
            Caption = 'End Date';
        }
        field(5; "Vendor No."; Code[20])
        {
            Caption = 'Vendor No.';
            TableRelation = Vendor."No.";
        }
        field(6; Cost; Decimal)
        {
            Caption = 'Cost';
            DecimalPlaces = 0 : 2;
        }
        field(7; Description; Text[250])
        {
            Caption = 'Description';
        }
        field(8; Completed; Boolean)
        {
            Caption = 'Completed';
            Editable = false;
        }
        field(9; "Logged By"; Code[50])
        {
            Caption = 'Logged By';
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
        key(OpenAsset; "Asset No.", Completed) { }
    }

    trigger OnInsert()
    var
        AssetSetupManagement: Codeunit "Asset Setup Management";

    begin
        if "No." = '' then
            "No." := AssetSetupManagement.GetMaintenanceNo();

        if "Start Date" = 0D then
            "Start Date" := WorkDate();

        "Logged By" := CopyStr(UserId(), 1, MaxStrLen("Logged By"));
        "Created Date-Time" := CurrentDateTime();
    end;
}