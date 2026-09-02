page 50218 "Asset Disposal List"
{
    ApplicationArea = All;
    Caption = 'Asset Disposals';
    PageType = List;
    SourceTable = "Asset Disposal";
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
                field("Disposal Date"; Rec."Disposal Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Disposal Date field.', Comment = '%';
                }
                field(Reason; Rec.Reason)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Reason field.', Comment = '%';
                }
            }
        }
    }
}