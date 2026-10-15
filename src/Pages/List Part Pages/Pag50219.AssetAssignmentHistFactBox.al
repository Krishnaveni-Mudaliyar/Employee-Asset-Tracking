page 50219 "Asset Assignment Hist. FactBox"
{
    PageType = ListPart;
    Caption = 'Assignment History';
    SourceTable = "Asset Assignment";
    Editable = false;

    layout
    {
        area(Content)
        {
            repeater(General)
            {
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
                field(Active; Rec.Active)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies whether this assignment is still current.', Comment = '%';
                }
            }
        }
    }
}