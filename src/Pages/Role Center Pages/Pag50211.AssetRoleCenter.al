page 50211 "Asset Role Center"
{
    ApplicationArea = All;
    Caption = 'Asset Management';
    PageType = RoleCenter;

    layout
    {
        area(RoleCenter)
        {
            part(Cues; "Asset Cues")
            {
                ApplicationArea = All;
            }
        }
    }

    actions
    {
        area(Sections)
        {
            group(Assets)
            {
                Caption = 'Assets';

                action(FixedAssets)
                {
                    ApplicationArea = All;
                    Caption = 'Fixed Assets';
                    RunObject = page "Fixed Asset List";
                    ToolTip = 'Opens Fixed Assets.';
                }

                action(Requests)
                {
                    ApplicationArea = All;
                    Caption = 'Asset Requests';
                    RunObject = page "Asset Request List";
                    ToolTip = 'Opens Asset Requests.';
                }

                action(Assignments)
                {
                    ApplicationArea = All;
                    Caption = 'Assignments';
                    RunObject = page "Asset Assignment List";
                    ToolTip = 'Opens Assignments.';
                }

                action(Returns)
                {
                    ApplicationArea = All;
                    Caption = 'Returns';
                    RunObject = page "Asset Return List";
                    ToolTip = 'Opens Returns.';
                }

                action(Transfers)
                {
                    ApplicationArea = All;
                    Caption = 'Transfers';
                    RunObject = page "Asset Transfer List";
                    ToolTip = 'Opens Transfers.';
                }

                action(Maintenance)
                {
                    ApplicationArea = All;
                    Caption = 'Maintenance';
                    RunObject = page "Asset Maintenance List";
                    ToolTip = 'Opens Maintenance.';
                }

                action(Disposals)
                {
                    ApplicationArea = All;
                    Caption = 'Disposals';
                    RunObject = page "Asset Disposal List";
                    ToolTip = 'Opens Disposals.';
                }
            }

            group(Setup)
            {
                Caption = 'Setup';

                action(AssetSetup)
                {
                    ApplicationArea = All;
                    Caption = 'Asset Setup';
                    RunObject = page "Asset Setup";
                    ToolTip = 'Opens Asset Setup.';
                }

                action(Categories)
                {
                    ApplicationArea = All;
                    Caption = 'Categories';
                    RunObject = page "Asset Category List";
                    ToolTip = 'Opens Categories.';
                }

                action(Brands)
                {
                    ApplicationArea = All;
                    Caption = 'Brands';
                    RunObject = page "Asset Brand List";
                    ToolTip = 'Opens Brands.';
                }
            }
        }
        area(Embedding)
        {
            action(EmbedFixedAssets)
            {
                ApplicationArea = All;
                Caption = 'Fixed Assets';
                RunObject = page "Fixed Asset List";
                ToolTip = 'Opens Fixed Assets.';
            }

            action(EmbedRequests)
            {
                ApplicationArea = All;
                Caption = 'Asset Requests';
                RunObject = page "Asset Request List";
                ToolTip = 'Opens Asset Requests.';
            }

            action(EmbedNotifications)
            {
                ApplicationArea = All;
                Caption = 'Notifications';
                RunObject = page "Asset Notifications";
                ToolTip = 'Opens Notifications.';
            }
        }
        area(Reporting)
        {
            action(RepRegister)
            {
                ApplicationArea = All;
                Caption = 'Asset Register';
                RunObject = report "Asset Register";
                ToolTip = 'Opens Asset Register.';
            }

            action(RepOverdue)
            {
                ApplicationArea = All;
                Caption = 'Overdue Assets';
                RunObject = report "Overdue Asset Report";
                ToolTip = 'Opens Overdue Assets.';
            }

            action(RepPending)
            {
                ApplicationArea = All;
                Caption = 'Pending Requests';
                RunObject = report "Pending Asset Request Report";
                ToolTip = 'Opens Pending Requests.';
            }

            action(RepEmployee)
            {
                ApplicationArea = All;
                Caption = 'Employee Assets';
                RunObject = report "Employee Asset Report";
                ToolTip = 'Opens Employee Assets.';
            }

            action(RepAssignment)
            {
                ApplicationArea = All;
                Caption = 'Assignments';
                RunObject = report "Asset Assignment Report";
                ToolTip = 'Opens Assignments.';
            }

            action(RepHandover)
            {
                ApplicationArea = All;
                Caption = 'Handover';
                RunObject = report "Asset Handover Report";
                ToolTip = 'Opens Handover.';
            }

            action(RepReturn)
            {
                ApplicationArea = All;
                Caption = 'Returns';
                RunObject = report "Asset Return Report";
                ToolTip = 'Opens Returns.';
            }

            action(RepHistory)
            {
                ApplicationArea = All;
                Caption = 'Asset History';
                RunObject = report "Asset History Report";
                ToolTip = 'Opens Asset History.';
            }
        }
    }
}