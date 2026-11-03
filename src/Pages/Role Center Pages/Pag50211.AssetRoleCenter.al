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
            part(Headline; "Asset Headline")
            {
                ApplicationArea = All;
            }
            part(Activities; "Asset Activities")
            {
                ApplicationArea = All;
            }
        }
    }

    actions
    {
        area(Sections)
        {
            group(AssetsSection)
            {
                Caption = 'Assets';

                action(Assets)
                {
                    ApplicationArea = All;
                    Caption = 'Assets';
                    RunObject = page "Fixed Asset List";
                    ToolTip = 'Open the list of assets.';
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
                action(Stocktakes)
                {
                    ApplicationArea = All;
                    Caption = 'Stocktakes';
                    RunObject = page "Asset Stocktake List";
                    ToolTip = 'Opens the asset stocktakes.';
                }

                action(Disposals)
                {
                    ApplicationArea = All;
                    Caption = 'Disposals';
                    RunObject = page "Asset Disposal List";
                    ToolTip = 'Opens Disposals.';
                }

                action(Notifications)
                {
                    ApplicationArea = All;
                    Caption = 'Notifications';
                    RunObject = page "Asset Notifications";
                    ToolTip = 'Open your asset notifications.';
                }
            }

            group(SetupSection)
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

                action(SubCategories)
                {
                    ApplicationArea = All;
                    Caption = 'Sub Categories';
                    RunObject = page "Asset Sub Category List";
                    ToolTip = 'Open the list of asset sub categories.';
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

        area(Creation)
        {
            action(NewRequest)
            {
                ApplicationArea = All;
                Caption = 'New Asset Request';
                Image = NewDocument;
                RunObject = page "Asset Request Card";
                RunPageMode = Create;
                ToolTip = 'Create a new asset request.';
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
                RunObject = report "Overdue Assets";
                ToolTip = 'Opens Overdue Assets.';
            }

            action(RepPending)
            {
                ApplicationArea = All;
                Caption = 'Pending Requests';
                RunObject = report "Pending Asset Requests";
                ToolTip = 'Opens Pending Requests.';
            }

            action(RepEmployee)
            {
                ApplicationArea = All;
                Caption = 'Employee Assets';
                RunObject = report "Employee Assets";
                ToolTip = 'Opens Employee Assets.';
            }

            action(RepAssignment)
            {
                ApplicationArea = All;
                Caption = 'Assignments';
                RunObject = report "Asset Assignments";
                ToolTip = 'Opens Assignments.';
            }

            action(RepHandover)
            {
                ApplicationArea = All;
                Caption = 'Handover';
                RunObject = report "Asset Handover";
                ToolTip = 'Opens Handover.';
            }

            action(RepReturn)
            {
                ApplicationArea = All;
                Caption = 'Returns';
                RunObject = report "Asset Return";
                ToolTip = 'Opens Returns.';
            }

            action(RepHistory)
            {
                ApplicationArea = All;
                Caption = 'Asset History';
                RunObject = report "Asset History";
                ToolTip = 'Opens Asset History.';
            }
        }

        area(Processing)
        {
            action(RegisterReport)
            {
                ApplicationArea = All;
                Caption = 'Asset Register';
                Image = Report;
                RunObject = report "Asset Register";
                ToolTip = 'Run the asset register report.';
            }
            action(OverdueReport)
            {
                ApplicationArea = All;
                Caption = 'Overdue Assets';
                Image = Report;
                RunObject = report "Overdue Assets";
                ToolTip = 'Run the overdue assets report.';
            }
            action(AssignmentsReport)
            {
                ApplicationArea = All;
                Caption = 'Asset Assignments';
                Image = Report;
                RunObject = report "Asset Assignments";
                ToolTip = 'Run the asset assignments report.';
            }
            action(PendingReport)
            {
                ApplicationArea = All;
                Caption = 'Pending Asset Requests';
                Image = Report;
                RunObject = report "Pending Asset Requests";
                ToolTip = 'Run the pending asset requests report.';
            }
        }
    }
}