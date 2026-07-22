table 50006 "AST Audit Log"
{
    Caption = 'AST Audit Log';
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Entry No."; Integer)
        {
            AutoIncrement = true;
            Caption = 'Entry No.';
        }
        field(2; "Event Type"; Text[50])
        {
            Caption = 'Event Type';
        }
        field(3; "Primary No."; Code[20])
        {
            Caption = 'Primary No.';
        }
        field(4; "Asset No."; Code[20])
        {
            Caption = 'Asset No.';
        }
        field(5; "Employee No."; Code[20])
        {
            Caption = 'Employee No.';
        }
        field(6; Notes; Text[250])
        {
            Caption = 'Notes';
        }
        field(7; "User Id"; Code[50])
        {
            Caption = 'User Id';
        }
        field(8; "Created At"; DateTime)
        {
            Caption = 'Created At';
        }
    }
    keys
    {
        key(PK; "Entry No.")
        {
            Clustered = true;
        }
    }
}
