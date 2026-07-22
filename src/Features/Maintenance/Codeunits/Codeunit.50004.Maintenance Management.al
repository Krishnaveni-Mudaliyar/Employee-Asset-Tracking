codeunit 50004 "AST Maintenance Management"
{
    procedure StartMaintenance(AssetNo: Code[20]; Description: Text[250]): Code[20]
    var
        ASTAsset: Record "AST Asset";
        ASTMaintenanceEntry: Record "AST Maintenance Entry";
        ASTSetup: Record "AST Setup";
        NoSeries: Codeunit "No. Series";
        ASTAuditMgt: Codeunit "AST Audit Management";
        MaintenanceNo: Code[20];
    begin
        ASTAsset.Get(AssetNo);
        if ASTAsset.Status = ASTAsset.Status::Assigned then
            Error('Asset %1 is currently assigned to an employee and must be returned before maintenance can begin.', AssetNo);

        ASTMaintenanceEntry.Init();

        ASTSetup := ASTSetup.GetSetup();
        MaintenanceNo := NoSeries.GetNextNo(ASTSetup."Maintenance Nos.", WorkDate());
        ASTMaintenanceEntry."Maintenance No." := MaintenanceNo;
        ASTMaintenanceEntry."Asset No." := AssetNo;
        ASTMaintenanceEntry."Start Date" := WorkDate();
        ASTMaintenanceEntry.Description := Description;
        ASTMaintenanceEntry.Status := ASTMaintenanceEntry.Status::"In Progress";
        ASTMaintenanceEntry."Posting Date" := WorkDate();
        ASTMaintenanceEntry."Posted By" := UserId;
        ASTMaintenanceEntry.Insert(true);

        ASTAsset."Maintenance Status" := ASTAsset."Maintenance Status"::"In Maintenance";
        ASTAsset.Status := ASTAsset.Status::"In Maintenance";
        ASTAsset.Modify(true);
        ASTAuditMgt.LogMaintenanceStart(MaintenanceNo, AssetNo, Description);
        exit(MaintenanceNo);
    end;

    procedure CompleteMaintenance(MaintenanceNo: Code[20]; CompletionNotes: Text[500])
    var
        ASTMaintenanceEntry: Record "AST Maintenance Entry";
        ASTAsset: Record "AST Asset";
        ASTAuditMgt: Codeunit "AST Audit Management";
    begin
        ASTMaintenanceEntry.SetRange("Maintenance No.", MaintenanceNo);
        if not ASTMaintenanceEntry.FindFirst() then
            Error('Maintenance %1 not found.', MaintenanceNo);

        ASTMaintenanceEntry."End Date" := WorkDate();
        ASTMaintenanceEntry."Completion Notes" := CompletionNotes;
        ASTMaintenanceEntry.Status := ASTMaintenanceEntry.Status::Completed;
        ASTMaintenanceEntry.Modify(true);

        ASTAsset.Get(ASTMaintenanceEntry."Asset No.");
        ASTAsset."Maintenance Status" := ASTAsset."Maintenance Status"::"Not In Maintenance";
        ASTAsset.Status := ASTAsset.Status::"Available";
        ASTAsset."Last Maintenance Date" := WorkDate();
        ASTAsset.Modify(true);

        ASTAuditMgt.LogMaintenanceComplete(MaintenanceNo, ASTMaintenanceEntry."Asset No.", CompletionNotes);
    end;

    procedure CheckMaintenanceDue(AssetNo: Code[20]): Boolean
    var
        ASTAsset: Record "AST Asset";
        DaysSinceMaintenance: Integer;
    begin
        ASTAsset.Get(AssetNo);
        if ASTAsset."Last Maintenance Date" = 0D then
            exit(false);
        if ASTAsset."Maintenance Interval Days" = 0 then
            exit(false);
        DaysSinceMaintenance := Today() - ASTAsset."Last Maintenance Date";
        exit(DaysSinceMaintenance >= ASTAsset."Maintenance Interval Days");
    end;

    procedure IsAvailableForAssignment(AssetNo: Code[20]): Boolean
    var
        ASTAsset: Record "AST Asset";
    begin
        if ASTAsset.Get(AssetNo) then
            exit(ASTAsset."Maintenance Status" <> ASTAsset."Maintenance Status"::"In Maintenance");
        exit(false);
    end;
}