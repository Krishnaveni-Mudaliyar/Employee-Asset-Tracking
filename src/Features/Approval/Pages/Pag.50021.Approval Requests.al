page 50021 "AST Approval Requests"
{
    ApplicationArea = All;
    Caption = 'Asset Approval Requests';
    PageType = List;
    SourceTable = "AST Approval Request";
    UsageCategory = Lists;
    Editable = false;
    layout
    {
        area(content)
        {
            repeater(Requests)
            {
                field("No."; Rec."No.") { }
                field("Asset No."; Rec."Asset No.") { }
                field("Requested Employee No."; Rec."Requested Employee No.") { }
                field("Request Type"; Rec."Request Type") { }
                field(Status; Rec.Status) { }
                field("Requested By"; Rec."Requested By") { }
                field("Requested At"; Rec."Requested At") { }
                field(Comments; Rec.Comments) { }
            }
        }
    }
    actions
    {
        area(Processing)
        {
            action(Approve)
            {
                ApplicationArea = All;
                Caption = 'Approve';
                Image = Approve;
                trigger OnAction()
                var
                    ApprovalMgt: Codeunit "AST Approval Management";
                begin
                    ApprovalMgt.Approve(Rec);
                    CurrPage.Update(false);
                end;
            }
            action(Reject)
            {
                ApplicationArea = All;
                Caption = 'Reject';
                Image = Reject;
                trigger OnAction()
                var
                    ApprovalMgt: Codeunit "AST Approval Management";
                begin
                    ApprovalMgt.Reject(Rec);
                    CurrPage.Update(false);
                end;
            }
        }
    }
}