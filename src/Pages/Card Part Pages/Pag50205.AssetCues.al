page 50205 "Asset Cues"
{
    ApplicationArea = All;
    Caption = 'Asset Cues';
    PageType = CardPart;
    SourceTable = "Asset Cue";

    layout
    {
        area(Content)
        {
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
                    DrillDownPageId = "Fixed Asset List";
                    ToolTip = 'Specifies the number of assets that are currently assigned.';
                }
                field("Assets Under Maintenance"; Rec."Assets Under Maintenance")
                {
                    ApplicationArea = All;
                    DrillDownPageId = "Fixed Asset List";
                    ToolTip = 'Specifies the number of assets that are under maintenance.';
                }
            }
            cuegroup(Requests)
            {
                Caption = 'Requests';

                field("Pending Requests"; Rec."Pending Requests")
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
            cuegroup(Alerts)
            {
                Caption = 'Alerts';

                field("Overdue Returns"; Rec."Overdue Returns")
                {
                    ApplicationArea = All;
                    Style = Unfavorable;
                    StyleExpr = Rec."Overdue Returns" > 0;
                    DrillDownPageId = "Asset Assignment List";
                    ToolTip = 'Specifies the number of active assignments past their expected return date.';
                }
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
        Rec.Reset();
        if not Rec.Get() then begin
            rec.Init();
            Rec.Insert();
        end;

        Rec.SetFilter("Overdue Date Filter", '%1..%2', 00010101D, CalcDate('<-1D', Today()));
        Rec.SetRange("User ID Filter", UserId());
    end;
}
