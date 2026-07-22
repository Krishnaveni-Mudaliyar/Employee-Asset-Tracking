table 50004 "AST Return Entry"
{
    DataClassification = ToBeClassified;
    Caption = 'Return Entry';

    fields
    {
        field(1; "Return No."; Code[20])
        {
            DataClassification = CustomerContent;
        }
        field(2; "Entry No."; Integer)
        {
            DataClassification = SystemMetadata;
            Editable = false;
            AutoIncrement = true;
        }
        field(3; "Assignment No."; Code[20])
        {
            DataClassification = CustomerContent;
        }
        field(4; "Asset No."; Code[20])
        {
            DataClassification = CustomerContent;
            TableRelation = "AST Asset";
        }
        field(5; "Return Date"; Date)
        {
            DataClassification = CustomerContent;
        }
        field(6; Condition; Enum "AST Asset Condition")
        {
            DataClassification = CustomerContent;
        }
        field(7; Notes; Text[250])
        {
            DataClassification = CustomerContent;
        }
        field(8; "Posting Date"; Date)
        {
            DataClassification = SystemMetadata;
        }
        field(9; "Posted By"; Code[20])
        {
            DataClassification = SystemMetadata;
        }
    }
    keys
    {
        key(PK; "Return No.", "Entry No.") { }
    }
}
