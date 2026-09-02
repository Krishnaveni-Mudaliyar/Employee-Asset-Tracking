page 50220 "Asset Maintenance Hist. FctBox"
{
    PageType = ListPart;
    Caption = 'Maintenance History';
    SourceTable = "Asset Maintenance";
    Editable = false;

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("Start Date"; Rec."Start Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Start Date field.', Comment = '%';
                }
                field("End Date"; Rec."End Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the End Date field.', Comment = '%';
                }
                field(Cost; Rec.Cost)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Cost field.', Comment = '%';
                }
                field(Completed; Rec.Completed)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Completed field.', Comment = '%';
                }
            }
        }
    }
}