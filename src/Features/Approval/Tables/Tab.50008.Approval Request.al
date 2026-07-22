table 50008 "AST Approval Request"
{
    Caption = 'Asset Approval Request';
    DataClassification = CustomerContent;
    DrillDownPageId = "AST Approval Requests";
    LookupPageId = "AST Approval Requests";

    fields
    {
        field(1; "No."; Code[20])
        {
            Caption = 'No.';
        }
        field(2; "Asset No."; Code[20])
        {
            Caption = 'Asset No.';
            TableRelation = "AST Asset";
        }
        field(3; "Requested Employee No."; Code[20])
        {
            Caption = 'Requested Employee No.';
            TableRelation = Employee;
        }
        field(4; "Request Type"; Option)
        {
            Caption = 'Request Type';
            OptionMembers = Assignment,Transfer,Disposal;
            OptionCaption = 'Assignment,Transfer,Disposal';
        }
        field(5; Status; Enum "AST Approval Status")
        {
            Caption = 'Status';
        }
        field(6; "Requested By"; Code[50])
        {
            Caption = 'Requested By';
        }
        field(7; "Requested At"; DateTime)
        {
            Caption = 'Requested At';
        }
        field(8; "Decision By"; Code[50])
        {
            Caption = 'Decision By';
        }
        field(9; "Decision At"; DateTime)
        {
            Caption = 'Decision At';
        }
        field(10; Comments; Text[250])
        {
            Caption = 'Comments';
        }
        field(11; "Assignment No."; Code[20])
        {
            Caption = 'Assignment No.';
            TableRelation = "AST Assignment";
        }
    }
    keys
    {
        key(PK; "No.")
        {
            Clustered = true;
        }
        key(Status; Status, "Requested At") { }
    }
}