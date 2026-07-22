page 50010 "AST Setup"
{
    PageType = Card;
    ApplicationArea = All;
    UsageCategory = Administration;
    SourceTable = "AST Setup";
    Caption = 'Asset Tracking Setup';
    InsertAllowed = false;
    DeleteAllowed = false;

    layout
    {
        area(content)
        {
            group(NumberSeries)
            {
                Caption = 'Number Series';

                field("Asset Nos."; Rec."Asset Nos.")
                {
                    ToolTip = 'Specifies the number series used to assign Asset numbers.';
                }
                field("Assignment Nos."; Rec."Assignment Nos.")
                {
                    ToolTip = 'Specifies the number series used to assign Assignment numbers.';
                }
                field("Return Nos."; Rec."Return Nos")
                {
                    ToolTip = 'Specifies the number series used to assign Return numbers.';
                }
                field("Maintenance Nos."; Rec."Maintenance Nos.")
                {
                    ToolTip = 'Specifies the number series used to assign Maintenance numbers.';
                }
            }
            group(Alerts)
            {
                Caption = 'Alert Thresholds';

                field("Warranty Alert Lead Days"; Rec."Warranty Alert Lead Days")
                {
                    ToolTip = 'Specifies how many days before warranty expiry an alert is raised.';
                }
                field("Maintenance Alert Lead Days"; Rec."Maintenance Alert Lead Days")
                {
                    ToolTip = 'Specifies how many days before a maintenance due date an alert is raised.';
                }
            }
        }
    }

    trigger OnOpenPage()
    var
        ASTSetupTable: Record "AST Setup";
    begin
        Rec := ASTSetupTable.GetSetup();
    end;
}
