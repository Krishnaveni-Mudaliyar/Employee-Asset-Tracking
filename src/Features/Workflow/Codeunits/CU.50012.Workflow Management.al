codeunit 50012 "AST Workflow Management"
{
    procedure IsApprovalRequired(Asset: Record "AST Asset"): Boolean
    begin
        // Keep the policy isolated so a customer extension can replace it without changing assignment logic.
        exit(Asset.Cost > 0);
    end;

    procedure CanAssign(Asset: Record "AST Asset"; EmployeeNo: Code[20]): Boolean
    begin
        exit((Asset.Status = Asset.Status::Available) and (EmployeeNo <> ''));
    end;
}