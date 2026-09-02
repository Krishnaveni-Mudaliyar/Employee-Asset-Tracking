page 50214 "Asset Assignment List"
{
    ApplicationArea = All;
    Caption = 'Asset Assignments';
    PageType = List;
    SourceTable = "Asset Assignment";
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
                field("Document No."; Rec."Document No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Document No. field.', Comment = '%';
                }
                field("Asset No."; Rec."Asset No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Asset No. field.', Comment = '%';
                }
                field("Employee No."; Rec."Employee No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Employee No. field.', Comment = '%';
                }
                field("Assignment Date"; Rec."Assignment Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Assignment Date field.', Comment = '%';
                }
                field("Assigned By"; Rec."Assigned By")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Assigned By field.', Comment = '%';
                }
            }
        }
    }
}