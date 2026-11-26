table 50016 "Asset Clearance Line"
{
    Caption = 'Asset Clearance Line';
    DataClassification = CustomerContent;

    fields
    {
        field(1; "Clearance No."; Code[20])
        {
            Caption = 'Clearance No.';
            TableRelation = "Asset Clearance Header"."No.";
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
        field(4; "Assignment No."; Code[20])
        {
            Caption = 'Assignment No.';
            TableRelation = "Asset Assignment"."No.";
            Editable = false;
        }
        field(5; Description; Text[100])
        {
            Caption = 'Description';
            Editable = false;
        }
        field(6; "Action"; Enum "Asset Clearance Action")
        {
            Caption = 'Action';

            trigger OnValidate()
            begin
                if Action <> Action::Transfer then
                    "Transfer To Employee No." := '';

                if Action <> Action::Return then
                    Clear("Return Condition");
            end;
        }
        field(7; "Transfer to Employee No."; Code[20])
        {
            Caption = 'Transfer to Employee No.';
            TableRelation = Employee."No.";

            trigger OnValidate()
            var
                ClearanceHeader: Record "Asset Clearance Header";
            begin
                if "Transfer To Employee No." = '' then
                    exit;

                TestField(Action, Action::Transfer);

                ClearanceHeader.Get("Clearance No.");
                if "Transfer To Employee No." = ClearanceHeader."Employee No." then
                    Error('The asset cannot be transferred to the employee who is leaving.');
            end;
        }
        field(8; "Return Condition"; Enum "Asset Condition")
        {
            Caption = 'Return Condition';
        }
        field(9; Remarks; Text[250])
        {
            Caption = 'Remarks';
        }
        field(10; "Resolved Date"; Date)
        {
            Caption = 'Resolved Date';
            Editable = false;
        }
    }
    keys
    {
        key(PK; "Clearance No.", "Line No.")
        {
            Clustered = true;
        }
        key(Asset; "Asset No.")
        {
        }
    }
}