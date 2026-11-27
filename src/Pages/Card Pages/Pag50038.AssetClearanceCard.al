page 50038 "Asset Clearance Card"
{
    Caption = 'Asset Clearance';
    PageType = Card;
    SourceTable = "Asset Clearance Header";
    UsageCategory = None;

    layout
    {
        area(Content)
        {
            group(General)
            {
                Caption = 'General';
                Editable = IsOpen;

                field("No."; Rec."No.")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Specifies the number of this clearance.', Comment = '%';
                }
                field("Employee No."; Rec."Employee No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the employee who is leaving.', Comment = '%';
                }
                field("Employee Name"; Rec."Employee Name")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the name of the employee.', Comment = '%';
                }
                field("Last Working Date"; Rec."Last Working Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the employee''s last working day. All assets should be resolved by this date.', Comment = '%';
                }
                field(Status; Rec.Status)
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Specifies whether the clearance is open, cleared or cancelled.', Comment = '%';
                }
                field(Remarks; Rec.Remarks)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies a general note about this clearance.', Comment = '%';
                }
            }
            group(Progress)
            {
                Caption = 'Progress';

                field("Total Lines"; Rec."Total Lines")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies how many assets the employee held when the clearance was started.';
                }
                field("Open Lines"; Rec."Open Lines")
                {
                    ApplicationArea = All;
                    StyleExpr = OpenLinesStyle;
                    ToolTip = 'Specifies how many assets still have no action chosen. The clearance can only be cleared when this is zero.';
                }
                field("Cleared Date"; Rec."Cleared Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the date the clearance was completed.';
                }
            }
            part(Lines; "Asset Clearance Subpage")
            {
                ApplicationArea = All;
                Editable = IsOpen;
                SubPageLink = "Clearance No." = field("No.");
            }
        }
    }
    actions
    {
        area(Processing)
        {
            action(LoadAssets)
            {
                ApplicationArea = All;
                Caption = 'Load Assets';
                Image = Refresh;
                Enabled = IsOpen;
                ToolTip = 'Reloads the lines from the assets the employee currently holds. Existing lines are replaced.';

                trigger OnAction()
                var
                    AssetClearanceManagement: Codeunit "Asset Clearance Management";
                begin
                    AssetClearanceManagement.LoadAssets(Rec);
                    CurrPage.Update(false);
                end;
            }
            action(CompleteClearance)
            {
                ApplicationArea = All;
                Caption = 'Complete Clearance';
                Image = Approve;
                Enabled = IsOpen;
                ToolTip = 'Carries out the chosen action on every line and marks the clearance as cleared.';

                trigger OnAction()
                var
                    AssetClearanceManagement: Codeunit "Asset Clearance Management";
                begin
                    if not Confirm('Complete clearance %1? The chosen action will be carried out on every asset.', false, Rec."No.") then
                        exit;

                    AssetClearanceManagement.CompleteClearance(Rec);
                    CurrPage.Update(false);
                end;
            }
            action(CancelClearance)
            {
                ApplicationArea = All;
                Caption = 'Cancel Clearance';
                Image = Cancel;
                Enabled = IsOpen;
                ToolTip = 'Cancels this clearance without changing any asset.';

                trigger OnAction()
                var
                    AssetClearanceManagement: Codeunit "Asset Clearance Management";
                begin
                    if not Confirm('Cancel clearance %1?', false, Rec."No.") then
                        exit;

                    AssetClearanceManagement.CancelClearance(Rec);
                    CurrPage.Update(false);
                end;
            }
        }
    }
    trigger OnAfterGetRecord()
    begin
        SetPageState();
    end;

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        IsOpen := true;
    end;

    var
        IsOpen: Boolean;
        OpenLinesStyle: Text;

    local procedure SetPageState()
    begin
        IsOpen := Rec.Status = Rec.Status::Open;

        Rec.CalcFields("Open Lines");
        OpenLinesStyle := 'Favorable';
        if Rec."Open Lines" > 0 then
            OpenLinesStyle := 'Unfavorable';
    end;
}