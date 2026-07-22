page 50007 "AST Return Asset Dialog"
{
    PageType = StandardDialog;
    Caption = 'Return Asset';

    layout
    {
        area(content)
        {
            group(AssetInfo)
            {
                Caption = 'Asset Information';
                field(AssignmentNo; AssignmentNo_Var)
                {
                    ApplicationArea = All;
                    Caption = 'Assignment No.';
                    Editable = false;
                }
                field(AssetNo; AssetNo_Var)
                {
                    ApplicationArea = All;
                    Caption = 'Asset No.';
                    Editable = false;
                }
                field(EmployeeNo; EmployeeNo_Var)
                {
                    ApplicationArea = All;
                    Caption = 'Employee No.';
                    Editable = false;
                }
            }
            group(Returns)
            {
                Caption = 'Return Details';
                field(Condition; Condition_Var)
                {
                    ApplicationArea = All;
                    Caption = 'Asset Condition';
                }
                field(ReturnNotes; ReturnNotes_Var)
                {
                    ApplicationArea = All;
                    Caption = 'Return Notes';
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            action(ReturnAssets)
            {
                ApplicationArea = All;
                Caption = 'Return Asset';
                Image = Action;
                InFooterBar = true;
                trigger OnAction()
                begin
                    ProcessReturn();
                end;
            }
        }
    }

    procedure SetAssignment(ASTAssignment: Record "AST Assignment")
    begin
        AssignmentNo_Var := ASTAssignment."Assignment No.";
        AssetNo_Var := ASTAssignment."Asset No.";
        EmployeeNo_Var := ASTAssignment."Employee No.";
    end;

    local procedure ProcessReturn()
    var
        ASTAssignment: Record "AST Assignment";
        AssetAssignmentMgt: Codeunit "AST Asset Assignment";
        Condition: Enum "AST Asset Condition";
    begin
        ASTAssignment.Get(AssignmentNo_Var);

        if not Confirm('Confirm asset return:\Asset: %1\Employee: %2\Condition:%3\Notes:%4\n\ This action cannot be undone.',
        true,
        AssetNo_Var,
        EmployeeNo_Var,
        Condition_Var,
        ReturnNotes_Var) then
            exit;

        Condition := "AST Asset Condition".FromInteger(Condition_Var);
        AssetAssignmentMgt.ReturnAsset(ASTAssignment, Condition, ReturnNotes_Var);
        Message('Asset returned successfully.');
    end;

    var
        AssignmentNo_Var, AssetNo_Var, EmployeeNo_Var : Code[20];
        Condition_Var: Enum "AST Asset Condition";
        ReturnNotes_Var: Text[250];
}