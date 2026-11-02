page 50206 "Asset Request Card"
{
    ApplicationArea = All;
    Caption = 'Asset Request';
    PageType = Card;
    SourceTable = "Asset Request Header";
    UsageCategory = Documents;

    layout
    {
        area(Content)
        {
            group(General)
            {
                Caption = 'General';

                field("No."; Rec."No.")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Specifies the value of the No. field.', Comment = '%';
                }
                field("Employee No."; Rec."Employee No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Employee No. field.', Comment = '%';
                }
                field("Request Date"; Rec."Request Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Request Date field.', Comment = '%';
                }
                field("Required Date"; Rec."Required Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Required Date field.', Comment = '%';
                }
                field("Department Code"; Rec."Department Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Department Code field.', Comment = '%';
                }
                field("Location Code"; Rec."Location Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Location Code field.', Comment = '%';
                }
                field(Reason; Rec.Reason)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Reason field.', Comment = '%';
                }
                field("Shortcut Dimension 1 Code"; Rec."Shortcut Dimension 1 Code")
                {
                    ApplicationArea = Dimensions;
                    ToolTip = 'Specifies the value of the Shortcut Dimension 1 Code field.', Comment = '%';
                }
                field("Shortcut Dimension 2 Code"; Rec."Shortcut Dimension 2 Code")
                {
                    ApplicationArea = Dimensions;
                    ToolTip = 'Specifies the value of the Shortcut Dimension 2 Code field.', Comment = '%';
                }
                field(Status; Rec.Status)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Status field.', Comment = '%';
                    Editable = false;
                }
            }
            part(Lines; "Asset Request Subpage")
            {
                ApplicationArea = All;
                SubPageLink = "Document No." = field("No.");
            }

            group(Approvals)
            {
                Caption = 'Approval'
;
                field("Requested By"; Rec."Requested By")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Specifies the value of the Requested By field.', Comment = '%';
                }
                field("Created Date-Time"; Rec."Created Date-Time")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Specifies the value of the Created Date-Time field.', Comment = '%';
                }
                field("Approved By"; Rec."Approved By")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Specifies the value of the Approved By field.', Comment = '%';
                }
                field("Approval Date-Time"; Rec."Approval Date-Time")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Specifies the value of the Approval Date-Time field.', Comment = '%';
                }
            }
        }
    }
    actions
    {
        area(Navigation)
        {
            action(Dimensions)
            {
                ApplicationArea = Dimensions;
                Caption = 'Dimensions';
                Image = Dimensions;
                Promoted = true;
                PromotedCategory = Category5;
                ShortCutKey = 'Ctrl+Alt+D';
                ToolTip = 'View or edit dimensions that are assigned to this asset request.';

                trigger OnAction()
                begin
                    Rec.ShowDimensions();
                end;
            }
        }
        area(Processing)
        {
            group(Approval)
            {
                Caption = 'Approval';

                action(SendForApproval)
                {
                    ApplicationArea = All;
                    Caption = 'Send for Approval';
                    Image = SendApprovalRequest;
                    Promoted = true;
                    PromotedCategory = Process;
                    ToolTip = 'Send the asset request for approval.';

                    trigger OnAction()
                    var
                        AssetRequestManagement: Codeunit "Asset Request Management";
                    begin
                        CurrPage.SaveRecord();
                        AssetRequestManagement.SendForApproval(Rec);
                        CurrPage.Update(false);
                    end;
                }

                action(CancelApproveRequest)
                {
                    ApplicationArea = All;
                    Caption = 'Cancel Approve Request';
                    Image = CancelApprovalRequest;
                    Promoted = true;
                    PromotedCategory = Process;
                    ToolTip = 'Cancel the approval request for the asset request.';
                    trigger OnAction()
                    var
                        AssetRequestApprovalMgmt: Codeunit "Asset Request Approval Mgmt.";
                    begin
                        if not Confirm(
                            'Do you want to cancel the approval request for asset request %1?',
                            false,
                            Rec."No.")
                        then
                            exit;

                        CurrPage.SaveRecord();
                        AssetRequestApprovalMgmt.CancelApprovalRequest(Rec);
                        CurrPage.Update(false);
                    end;
                }
            }
        }
    }
}