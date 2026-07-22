table 50001 "AST Asset Category"
{
    DataClassification = ToBeClassified;
    Caption = 'Asset Category';
    LookupPageId = "AST Asset Category List";

    fields
    {
        field(1; "Code"; Code[20])
        {
            DataClassification = CustomerContent;
            NotBlank = true;
        }
        field(2; Description; Text[100])
        {
            DataClassification = CustomerContent;
        }
        field(3; "Require Approval"; Boolean)
        {
            DataClassification = CustomerContent;
        }
        field(4; "Default Maintenance Interval"; Integer)
        {
            DataClassification = CustomerContent;
        }

    }
    keys
    {
        key(PK; "Code") { }
    }
}
