table 50208 "Asset Assignment"
{
    Caption = 'Asset Assignment';
    DataClassification = CustomerContent;

    fields
    {
        field(1; "No."; Code[20])
        {
            Caption = 'No.';
        }
        field(2; "Document No."; Code[20])
        {
            Caption = 'Document No.';
            TableRelation = "Asset Request Header"."No.";
        }
        field(3; "Document Line No."; Integer)
        {
            Caption = 'Document Line No.';
        }
        field(4; "Asset No."; Code[20])
        {
            Caption = 'Asset No.';
            TableRelation = Asset."No.";
        }
        field(5; "Employee No."; Code[20])
        {
            Caption = 'Employee No.';
            TableRelation = Employee."No.";
        }
        field(6; "Assignment Date"; Date)
        {
            Caption = 'Assignment Date';
        }
        field(7; "Assigned By"; Code[50])
        {
            Caption = 'Assigned By';
            DataClassification = EndUserIdentifiableInformation;
            Editable = false;
        }
        field(8; "Created Date-Time"; DateTime)
        {
            Caption = 'Created Date-Time';
            DataClassification = SystemMetadata;
            Editable = false;
        }
        field(9; Active; Boolean)
        {
            Caption = 'Active';
            InitValue = true;
        }
    }
    keys
    {
        key(PK; "No.")
        {
            Clustered = true;
        }
        key(Document; "Document No.", "Document Line No.") { }
        key(Asset; "Asset No.") { }
        key(Employee; "Employee No.") { }
        key(ActiveAsset; "Asset No.", Active) { }
    }

    trigger OnInsert()
    var
        AssetSetupManagement: Codeunit "Asset Setup Management";

    begin
        if "No." = '' then
            "No." := AssetSetupManagement.GetAssignmentNo();

        if "Assignment Date" = 0D then
            "Assignment Date" := WorkDate();

        "Assigned By" := CopyStr(UserId(), 1, MaxStrLen("Assigned By"));
        "Created Date-Time" := CurrentDateTime();
    end;
}