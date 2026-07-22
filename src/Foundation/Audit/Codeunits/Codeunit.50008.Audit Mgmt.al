codeunit 50008 "AST Audit Management"
{
    Access = Public;

    procedure LogAssetAssignment(AssignmentNo: Code[20]; AssetNo: Code[20]; EmployeeNo: Code[20]; Notes: Text[250])
    begin
        LogEvent('Assignment', AssignmentNo, AssetNo, EmployeeNo, Notes);
    end;

    procedure LogAssetReturn(ReturnNo: Code[20]; AssetNo: Code[20]; EmployeeNo: Code[20]; Condition: Enum "AST Asset Condition")
    begin
        LogEvent('Return', ReturnNo, AssetNo, EmployeeNo, 'Condition: ' + Format(Condition));
    end;

    procedure LogAssetTransfer(OldAssignmentNo: Code[20]; NewAssignmentNo: Code[20]; AssetNo: Code[20]; NewEmployeeNo: Code[20])
    begin
        LogEvent('Transfer', NewAssignmentNo, AssetNo, NewEmployeeNo, 'From: ' + OldAssignmentNo);
    end;

    procedure LogMaintenanceStart(MaintenanceNo: Code[20]; AssetNo: Code[20]; Description: Text[250])
    begin
        LogEvent('Maintenance Start', MaintenanceNo, AssetNo, '', Description);
    end;

    procedure LogMaintenanceComplete(MaintenanceNo: Code[20]; AssetNo: Code[20]; CompletionNotes: Text[500])
    begin
        LogEvent('Maintenance Complete', MaintenanceNo, AssetNo, '', CompletionNotes);
    end;

    procedure LogAlert(EventType: Text[50]; AssetNo: Code[20]; AlertText: Text)
    begin
        LogEvent(EventType, AssetNo, AssetNo, '', AlertText);
    end;

    local procedure LogEvent(EventType: Text[50]; PrimaryNo: Code[20]; AssetNo: Code[20]; SecondaryNo: Code[20]; Notes: Text)
    var
        ASTAuditLog: Record "AST Audit Log";
    begin
        ASTAuditLog.Init();
        ASTAuditLog."Event Type" := EventType;
        ASTAuditLog."Primary No." := PrimaryNo;
        ASTAuditLog."Asset No." := AssetNo;
        ASTAuditLog."Employee No." := SecondaryNo;
        ASTAuditLog.Notes := CopyStr(Notes, 1, 250);
        ASTAuditLog."User Id" := CopyStr(UserId(), 1, 50);
        ASTAuditLog."Created At" := CurrentDateTime();
        ASTAuditLog.Insert(true);
    end;
}
