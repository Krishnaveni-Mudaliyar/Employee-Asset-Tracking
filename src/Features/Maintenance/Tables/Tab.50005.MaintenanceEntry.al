table 50005 "AST Maintenance Entry"
{
    DataClassification = ToBeClassified;
    Caption = 'Maintenance Entry';

    fields
    {
        field(1; "Maintenance No."; Code[20])
        {
            DataClassification = CustomerContent;
        }
        field(2; "Entry No."; Integer)
        {
            DataClassification = SystemMetadata;
            Editable = false;
            AutoIncrement = true;
        }
        field(3; "Asset No."; Code[20])
        {
            DataClassification = CustomerContent;
            TableRelation = "AST Asset";
        }
        field(4; Description; Text[250])
        {
            DataClassification = CustomerContent;
        }
        field(5; "Start Date"; Date)
        {
            DataClassification = CustomerContent;
        }
        field(6; "End Date"; Date)
        {
            DataClassification = CustomerContent;
        }
        field(7; Status; Enum "AST Maintenance Entry Status")
        {
            DataClassification = CustomerContent;
        }
        field(8; "Completion Notes"; Text[500])
        {
            DataClassification = CustomerContent;
        }
        field(9; "Posting Date"; Date)
        {
            DataClassification = SystemMetadata;
        }
        field(10; "Posted By"; Code[20])
        {
            DataClassification = SystemMetadata;
        }
    }
    keys
    {
        key(PK; "Maintenance No.", "Entry No.") { }
    }
}