page 50025 "Asset Activities"
{
    Caption = 'Activities';
    PageType = CardPart;
    SourceTable = "Asset Cue";
    RefreshOnActivate = true;

    layout
    {
        area(Content)
        {
            cuegroup(OngoingRequests)
            {
                Caption = 'Ongoing Requests';

                field("Open Requests"; Rec."Open Requests")
                {
                    ApplicationArea = All;
                    DrillDownPageId = "Asset Request List";
                    ToolTip = 'Specifies the number of asset requests that are still open.';
                }
                field("Pending Approvals"; Rec."Pending Approvals")
                {
                    ApplicationArea = All;
                    DrillDownPageId = "Asset Request List";
                    StyleExpr = PendingStyle;
                    ToolTip = 'Specifies the number of asset requests waiting for approval.';
                }
                field("Approved Requests"; Rec."Approved Requests")
                {
                    ApplicationArea = All;
                    DrillDownPageId = "Asset Request List";
                    ToolTip = 'Specifies the number of approved asset requests that still need assets assigned.';
                }
            }
            cuegroup(AssetStatus)
            {
                Caption = 'Asset Status';

                field("Available Assets"; Rec."Available Assets")
                {
                    ApplicationArea = All;
                    DrillDownPageId = "Fixed Asset List";
                    ToolTip = 'Specifies the number of assets that are available for assignment.';
                }
                field("Assigned Assets"; Rec."Assigned Assets")
                {
                    ApplicationArea = All;
                    DrillDownPageId = "Asset Assignment List";
                    ToolTip = 'Specifies the number of assets that are currently assigned.';
                }
                field("Assets Under Maintenance"; Rec."Assets Under Maintenance")
                {
                    ApplicationArea = All;
                    DrillDownPageId = "Asset Maintenance List";
                    ToolTip = 'Specifies the number of assets under maintenance.';
                }
                field("Disposed Assets"; Rec."Disposed Assets")
                {
                    ApplicationArea = All;
                    DrillDownPageId = "Asset Disposal List";
                    ToolTip = 'Specifies the number of assets that have been disposed.';
                }
            }
            cuegroup(ReturnsAndWarranty)
            {
                Caption = 'Returns and Warranty';

                field("Overdue Returns"; Rec."Overdue Returns")
                {
                    ApplicationArea = All;
                    DrillDownPageId = "Asset Assignment List";
                    StyleExpr = OverdueStyle;
                    ToolTip = 'Specifies the number of assignments past their expected return date.';
                }
                field("Due This Week"; Rec."Due This Week")
                {
                    ApplicationArea = All;
                    DrillDownPageId = "Asset Assignment List";
                    ToolTip = 'Specifies the number of assignments due back within the next 7 days.';
                }
                field("Expiring Warranties"; Rec."Expiring Warranties")
                {
                    ApplicationArea = All;
                    DrillDownPageId = "Fixed Asset List";
                    StyleExpr = WarrantyStyle;
                    ToolTip = 'Specifies the number of assets whose warranty ends within the alert lead days.';
                }
                field("Unread Notifications"; Rec."Unread Notifications")
                {
                    ApplicationArea = All;
                    DrillDownPageId = "Asset Notifications";
                    ToolTip = 'Specifies the number of unread notifications for you.';
                }
            }
            cuegroup(QuickActions)
            {
                Caption = 'Quick Actions';

                actions
                {
                    action(NewRequest)
                    {
                        ApplicationArea = All;
                        Caption = 'New Asset Request';
                        Image = TileNew;
                        RunObject = page "Asset Request Card";
                        RunPageMode = Create;
                        ToolTip = 'Create a new asset request.';
                    }
                    action(NewStocktake)
                    {
                        ApplicationArea = All;
                        Caption = 'New Stocktake';
                        Image = TileNew;
                        RunObject = page "Asset Stocktake Card";
                        RunPageMode = Create;
                        ToolTip = 'Start a new asset stocktake.';
                    }
                    action(OpenNotifications)
                    {
                        ApplicationArea = All;
                        Caption = 'My Notifications';
                        Image = TileInfo;
                        RunObject = page "Asset Notifications";
                        ToolTip = 'Open your asset notifications.';
                    }
                }
            }
        }
    }

    trigger OnOpenPage()
    var
        AssetSetup: Record "Asset Setup";
        LeadDays: Integer;

    begin
        if not Rec.Get() then begin
            Rec.Init();
            Rec.Insert();
        end;

        LeadDays := 30;
        if AssetSetup.Get() then
            if AssetSetup."Warranty Alert Lead Days" > 0 then
                LeadDays := AssetSetup."Warranty Alert Lead Days";

        Rec.SetFilter("Overdue Date Filter", '>%1&<%2', 0D, Today());
        Rec.SetRange("Due Date Filter", Today(), Today() + 7);
        Rec.SetRange("Warranty Date Filter", Today(), Today() + LeadDays);
        Rec.SetRange("User ID Filter", UserId());
    end;

    trigger OnAfterGetRecord()
    begin
        Rec.CalcFields("Pending Approvals", "Overdue Returns", "Expiring Warranties");

        PendingStyle := 'None';
        if Rec."Pending Approvals" > 0 then
            PendingStyle := 'Ambiguous';

        OverdueStyle := 'Favorable';
        if Rec."Overdue Returns" > 0 then
            OverdueStyle := 'Unfavorable';

        WarrantyStyle := 'Favorable';
        if Rec."Expiring Warranties" > 0 then
            WarrantyStyle := 'Ambiguous';
    end;

    var
        PendingStyle, OverdueStyle, WarrantyStyle : Text;
}