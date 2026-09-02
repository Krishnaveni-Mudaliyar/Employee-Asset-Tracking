page 50216 "Asset Transfer List"
{
    ApplicationArea = All;
    Caption = 'Asset Transfers';
    PageType = List;
    SourceTable = "Asset Transfer";
    UsageCategory = Lists;
    Editable = false;

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("No."; Rec."No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the No. field.', Comment = '%';
                }
                field("Asset No."; Rec."Asset No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Asset No. field.', Comment = '%';
                }
                field("Transfer Date"; Rec."Transfer Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Transfer Date field.', Comment = '%';
                }
                field("From Employee No."; Rec."From Employee No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the From Employee No. field.', Comment = '%';
                }
                field("To Employee No."; Rec."To Employee No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the To Employee No. field.', Comment = '%';
                }
                field("From Location Code"; Rec."From Location Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the From Location Code field.', Comment = '%';
                }
                field("To Location Code"; Rec."To Location Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the To Location Code field.', Comment = '%';
                }
            }
        }
    }
}