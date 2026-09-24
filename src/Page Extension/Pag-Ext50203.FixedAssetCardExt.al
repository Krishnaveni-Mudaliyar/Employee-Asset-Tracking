pageextension 50203 "Fixed Asset List Ext" extends "Fixed Asset List"
{
    layout
    {
        addlast(Control1)
        {
            field("Asset Category Code"; Rec."Asset Category Code")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Asset Category Code field.', Comment = '%';
            }
            field("Asset Sub Category Code"; Rec."Asset Sub Category Code")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Asset Sub Category Code field.', Comment = '%';
            }
            field("Asset Brand Code"; Rec."Asset Brand Code")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Asset Brand Code field.', Comment = '%';
            }
            field("IT Model No."; Rec."IT Model No.")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Model No. field.', Comment = '%';
            }
            field("IT Serial No."; Rec."IT Serial No.")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Serial No. field.', Comment = '%';
            }
            field("IT Asset Tag No."; Rec."IT Asset Tag No.")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Asset Tag No. field.', Comment = '%';
            }
            field("IT Asset Status"; Rec."IT Asset Status")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the IT Asset Status field.', Comment = '%';
            }
            field("IT Asset Condition"; Rec."IT Asset Condition")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the IT Asset Condition field.', Comment = '%';
            }
            field("IT Location Code"; Rec."IT Location Code")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the IT Location Code field.', Comment = '%';
            }
            field("IT Asset Blocked"; Rec."IT Asset Blocked")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the IT Asset Blocked field.', Comment = '%';
            }
        }
    }
}