page 50221 "Emp. Active Asset Assgn."
{
    PageType = ListPart;
    Caption = 'Assigned Assets';
    SourceTable = "Asset Assignment";
    Editable = false;

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("Asset No."; Rec."Asset No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Asset No. field.', Comment = '%';
                }
                field("Assignment Date"; Rec."Assignment Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Assignment Date field.', Comment = '%';
                }
            }
        }
    }

    trigger OnOpenPage()
    begin
        Rec.SetRange(Active, true);
    end;
}