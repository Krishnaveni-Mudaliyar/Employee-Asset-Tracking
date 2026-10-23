page 50201 "Asset Setup"
{
    ApplicationArea = All;
    Caption = 'Asset Setup';
    PageType = Card;
    SourceTable = "Asset Setup";
    UsageCategory = Administration;

    layout
    {
        area(Content)
        {
            group(Numbering)
            {
                Caption = 'Numbering';

                field("Asset Nos."; Rec."Asset Nos.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Asset Nos. field.', Comment = '%';
                }
                field("Asset Request Nos."; Rec."Asset Request Nos.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Asset Request Nos. field.', Comment = '%';
                }
                field("Assignment Nos."; Rec."Assignment Nos.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Assignment Nos. field.', Comment = '%';
                }
                field("Return Nos."; Rec."Return Nos.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Return Nos. field.', Comment = '%';
                }
                field("Transfer Nos."; Rec."Transfer Nos.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Transfer Nos. field.', Comment = '%';
                }
                field("Maintenance Nos."; Rec."Maintenance Nos.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Maintenance Nos. field.', Comment = '%';
                }
                field("Disposal Nos."; Rec."Disposal Nos.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Disposal Nos. field.', Comment = '%';
                }
            }
            group(StocktakeSetup)
            {
                Caption = 'Stocktake';

                field("Stocktake Nos."; Rec."Stocktake Nos.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the number series used for asset stocktakes.';
                }
            }
            group(Alerts)
            {
                Caption = 'Alerts';

                field("Warranty Alert Days"; Rec."Warranty Alert Days")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies how many days before warranty end a notification is raised.';
                }
                field("Warranty Alert User ID"; Rec."Warranty Alert User ID")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the user who receives warranty expiry notifications.';
                }
            }
        }
    }
    actions
    {
        area(Processing)
        {
            action(EnableChangeLog)
            {
                ApplicationArea = All;
                Caption = 'Enable Change Log';
                Image = Setup;
                ToolTip = 'Activates the change log and logs inserts, changes and deletes on all asset tracking tables.';

                trigger OnAction()
                var
                    AssetChangeLogMgt: Codeunit "Asset Change Log Management";
                begin
                    AssetChangeLogMgt.EnableChangeLog();
                    Message('Change log enabled for asset tracking tables.');
                end;
            }
            action(ChangeLogEntries)
            {
                ApplicationArea = All;
                Caption = 'Change Log Entries';
                Image = ChangeLog;
                RunObject = page "Change Log Entries";
                ToolTip = 'Opens the change log entries.';
            }
        }
    }
}