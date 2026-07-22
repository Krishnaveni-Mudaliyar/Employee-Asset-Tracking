pageextension 50000 "AST Employee Extension" extends "Employee Card"
{
    layout
    {
        addafter(Status)
        {
            group("Asset Tracking")
            {
                Caption = 'Asset Tracking';
                field(PendingAssets; GetPendingAssetCount())
                {
                    ApplicationArea = All;
                    Caption = 'Pending Assets';
                    Editable = false;
                    DrillDownPageId = "AST Assignment List";

                    trigger OnDrillDown()
                    begin
                        ShowPendingAssets(Rec."No.");
                    end;
                }
                field(LastAssignmentDate; GetLastAssignmentDate())
                {
                    ApplicationArea = All;
                    Caption = 'Last Assignment';
                    Editable = false;
                }
            }
        }
    }

    actions
    {
        addafter(Attachments)
        {
            action("Employee Assets")
            {
                ApplicationArea = All;
                Caption = 'Employee Assets';
                Image = Resource;
                RunObject = page "AST Assignment List";
                RunPageLink = "Employee No." = FIELD("No.");
            }
        }
    }

    local procedure GetPendingAssetCount(): Integer
    var
        ASTAssignment: Record "AST Assignment";
    begin
        ASTAssignment.SetRange("Employee No.", Rec."No.");
        ASTAssignment.SetRange(Status, ASTAssignment.Status::"Active");
        exit(ASTAssignment.Count);
    end;

    local procedure GetLastAssignmentDate(): Date
    var
        ASTAssignment: Record "AST Assignment";
    begin
        ASTAssignment.SetRange("Employee No.", Rec."No.");
        ASTAssignment.SetRange(Status, ASTAssignment.Status::"Active");
        ASTAssignment.SetCurrentKey("Assignment Date");
        if ASTAssignment.FindLast() then
            exit(ASTAssignment."Assignment Date");
        exit(0D);
    end;

    local procedure ShowPendingAssets(EmployeeNo: Code[20])
    var
        ASTAssignment: Record "AST Assignment";
    begin
        ASTAssignment.SetRange("Employee No.", EmployeeNo);
        ASTAssignment.SetRange(Status, ASTAssignment.Status::"Active");
        Page.Run(Page::"AST Assignment List", ASTAssignment);
    end;
}