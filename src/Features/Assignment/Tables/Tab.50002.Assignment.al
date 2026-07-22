table 50002 "AST Assignment"
{
    DataClassification = ToBeClassified;
    Caption = 'Assignment';

    fields
    {
        field(1; "Assignment No."; Code[20])
        {
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(2; "Asset No."; Code[20])
        {
            DataClassification = CustomerContent;
            TableRelation = "AST Asset";
        }
        field(3; "Asset Description"; Text[100])
        {
            Editable = false;
            FieldClass = FlowField;
            CalcFormula = lookup("AST Asset".Description where("No." = field("Asset No.")));
        }
        field(4; "Employee No."; Code[20])
        {
            DataClassification = CustomerContent;
            TableRelation = Employee;
        }
        field(5; "Employee Name"; Text[100])
        {
            Editable = false;
            FieldClass = FlowField;
            CalcFormula = lookup(Employee."First Name" where("No." = field("Employee No.")));
        }
        field(6; "Assignment Date"; Date)
        {
            DataClassification = CustomerContent;
        }
        field(7; "Return Date"; Date)
        {
            DataClassification = CustomerContent;
        }
        field(8; Status; Enum "AST Assignment Status")
        {
            DataClassification = CustomerContent;
        }
        field(9; "Assignment Notes"; Text[250])
        {
            DataClassification = CustomerContent;
        }
        field(10; "Assigned By"; Code[20])
        {
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(11; "Return Condition"; Enum "AST Asset Condition")
        {
            DataClassification = CustomerContent;
        }
    }
    keys
    {
        key(PK; "Assignment No.") { }
        key(Asset; "Asset No.") { }
        key(Employee; "Employee No.", Status) { }
    }
}