page 50235 "Asset Headline"
{
    Caption = 'Headline';
    PageType = HeadlinePart;
    SourceTable = "Asset Cue";
    RefreshOnActivate = true;

    layout
    {
        area(Content)
        {
            group(Control1)
            {
                ShowCaption = false;

                field(ApprovalHeadline; ApprovalHeadlineText)
                {
                    ApplicationArea = All;
                    Caption = 'Approvals';
                    Editable = false;
                    ShowCaption = false;
                    ToolTip = 'Specifies how many asset requests are waiting for approval.';
                }
                field(OverdueHeadline; OverdueHeadlineText)
                {
                    ApplicationArea = All;
                    Caption = 'Overdue returns';
                    Editable = false;
                    ShowCaption = false;
                    ToolTip = 'Specifies how many assigned assets are overdue for return.';
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
        Rec.CalcFields("Pending Approvals", "Overdue Returns");

        ApprovalHeadlineText := StrSubstNo('%1 asset request(s) waiting for approval.', Rec."Pending Approvals");
        OverdueHeadlineText := StrSubstNo('%1 asset(s) overdue for return.', Rec."Overdue Returns");
    end;

    var
        ApprovalHeadlineText: Text;
        OverdueHeadlineText: Text;
}