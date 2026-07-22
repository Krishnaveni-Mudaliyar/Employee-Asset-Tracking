page 50002 "AST Asset Category List"
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Administration;
    SourceTable = "AST Asset Category";
    Caption = 'Asset Categories';

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(Code; Rec.Code)
                {
                    ToolTip = 'Code';
                }
                field(Description; Rec.Description)
                {
                    ToolTip = 'Description';
                }
                field("Require Approval"; Rec."Require Approval")
                {
                    ToolTip = 'Require Approval';
                }
                field("Default Maintenance Interval"; Rec."Default Maintenance Interval")
                {
                    ToolTip = 'Default Maintenance Interval';
                }
            }
        }
    }
}