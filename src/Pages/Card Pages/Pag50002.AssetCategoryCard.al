page 50002 "Asset Category Card"
{
    ApplicationArea = All;
    Caption = 'Asset Category';
    PageType = Card;
    SourceTable = "Asset Category";
    UsageCategory = None;

    layout
    {
        area(Content)
        {
            group(General)
            {
                Caption = 'General';

                field(Code; Rec.Code)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the code of the asset category.';
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the description of the asset category.';
                }
                field(Blocked; Rec.Blocked)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies whether the asset category is blocked from use.';
                }
            }
        }
    }
}