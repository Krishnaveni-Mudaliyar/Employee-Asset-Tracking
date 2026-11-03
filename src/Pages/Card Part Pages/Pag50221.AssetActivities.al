page 50221 "Asset Activities"
{
    Caption = 'Activities';
    PageType = CardPart;
    SourceTable = "Asset Cue";
    RefreshOnActivate = true;

    layout
    {
        area(Content)
        {
            cuegroup(Requests)
            {
                Caption = 'Requests';

                field("Pending Approvals"; Rec."Pending Approvals")
                {
                    ApplicationArea = All;
                    DrillDownPageId = "Asset Request List";
                    ToolTip = 'Specifies the number of asset requests waiting for approval.';
                }
                field("Approved Requests"; Rec."Approved Requests")
                {
                    ApplicationArea = All;
                    DrillDownPageId = "Asset Request List";
                    ToolTip = 'Specifies the number of approved asset requests that still need assets assigned.';
                }
            }
            cuegroup(Assets)
            {
                Caption = 'Assets';

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
                field("Overdue Returns"; Rec."Overdue Returns")
                {
                    ApplicationArea = All;
                    DrillDownPageId = "Asset Assignment List";
                    ToolTip = 'Specifies the number of assignments that are past their expected return date.';
                }
                field("Under Maintenance"; Rec."Under Maintenance")
                {
                    ApplicationArea = All;
                    DrillDownPageId = "Asset Maintenance List";
                    ToolTip = 'Specifies the number of assets that are under maintenance.';
                }
            }
            cuegroup(Notifications)
            {
                Caption = 'Notifications';

                field("Unread Notifications"; Rec."Unread Notifications")
                {
                    ApplicationArea = All;
                    DrillDownPageId = "Asset Notifications";
                    ToolTip = 'Specifies the number of unread notifications for you.';
                }
            }
        }
    }

    trigger OnOpenPage()
    begin
        if not Rec.Get() then begin
            Rec.Init();
            Rec.Insert();
        end;

        Rec.SetFilter("Overdue Date Filter", '>%1&<%2', 0D, Today());
        Rec.SetRange("User ID Filter", UserId());
    end;
}