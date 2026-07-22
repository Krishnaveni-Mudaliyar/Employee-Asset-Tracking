page 50004 "AST Assignment Card"
{
    PageType = Card;
    ApplicationArea = All;
    SourceTable = "AST Assignment";
    Caption = 'Assignment Card';

    layout
    {
        area(content)
        {
            group(General)
            {
                field("Assignment No."; Rec."Assignment No.")
                {
                    ToolTip = 'Assignment No.';
                }
                field("Asset No."; Rec."Asset No.")
                {
                    ToolTip = 'Asset No.';
                }
                field("Asset Description"; Rec."Asset Description")
                {
                    ToolTip = 'Asset Description';
                }
                field("Employee No."; Rec."Employee No.")
                {
                    ToolTip = 'Employee No.';
                }
                field("Employee Name"; Rec."Employee Name")
                {
                    ToolTip = 'Employee Name';
                }
            }
            group(Dates)
            {
                field("Assignment Date"; Rec."Assignment Date")
                {
                    ToolTip = 'Assignment Date';
                }
                field("Return Date"; Rec."Return Date")
                {
                    ToolTip = 'Return Date';
                }
                field(Status; Rec.Status)
                {
                    ToolTip = 'Status';
                }
            }
            group(Details)
            {
                field("Assignment Notes"; Rec."Assignment Notes")
                {
                    ToolTip = 'Assignment Notes';
                }
                field("Return Condition"; Rec."Return Condition")
                {
                    ToolTip = 'Return Condition';
                }
                field("Assigned By"; Rec."Assigned By")
                {
                    ToolTip = 'Assigned By';
                    Editable = false;
                }
            }
        }
    }
}