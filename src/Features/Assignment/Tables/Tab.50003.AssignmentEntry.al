table 50003 "AST Assignment Entry"
{
    DataClassification = ToBeClassified;
    Caption = 'Assignment Entry';

    fields
    {
        field(1; "Entry No."; Integer)
        {
            DataClassification = SystemMetadata;
            Editable = false;
            AutoIncrement = true;
        }
        field(2; "Assignment No."; Code[20])
        {
            DataClassification = CustomerContent;
        }
        field(3; "Asset No."; Code[20])
        {
            DataClassification = CustomerContent;
            TableRelation = "AST Asset";
        }
        field(4; "Employee No."; Code[20])
        {
            DataClassification = CustomerContent;
            TableRelation = Employee;
        }
        field(5; "Assignment Date"; Date)
        {
            DataClassification = CustomerContent;
        }
        field(6; "Posting Date"; Date)
        {
            DataClassification = SystemMetadata;
        }
        field(7; "Posted By"; Code[20])
        {
            DataClassification = SystemMetadata;
        }
    }
    keys
    {
        key(PK; "Entry No.") { }
    }
}