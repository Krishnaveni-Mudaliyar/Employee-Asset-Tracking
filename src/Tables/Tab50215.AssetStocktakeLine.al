table 50215 "Asset Stocktake Line"
{
    Caption = 'Asset Stocktake Line';
    DataClassification = CustomerContent;

    fields
    {
        field(1; "Document No."; Code[20])
        {
            Caption = 'Document No.';
            TableRelation = "Asset Stocktake Header"."No.";
        }
        field(2; "Line No."; Integer)
        {
            Caption = 'Line No.';
        }
        field(3; "Asset No."; Code[20])
        {
            Caption = 'Asset No.';
            TableRelation = "Fixed Asset"."No.";
            Editable = false;
        }
        field(4; Description; Text[100])
        {
            Caption = 'Description';
            Editable = false;
        }
        field(5; "Expected Employee No."; Code[20])
        {
            Caption = 'Expected Employee No.';
            Editable = false;
        }
        field(6; "Expected Location Code"; Code[10])
        {
            Caption = 'Expected Location Code';
            Editable = false;
        }
        field(7; Counted; Boolean)
        {
            Caption = 'Counted';
        }
        field(8; "Counted Location Code"; Code[10])
        {
            Caption = 'Counted Location Code';
            TableRelation = Location.Code;
        }
        field(9; Result; Enum "Asset Stocktake Result")
        {
            Caption = 'Result';
            Editable = false;
        }
        field(10; Remarks; Text[100])
        {
            Caption = 'Remarks';
        }
    }
    keys
    {
        key(PK; "Document No.", "Line No.")
        {
            Clustered = true;
        }
    }
}