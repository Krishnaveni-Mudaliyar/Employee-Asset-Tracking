codeunit 50006 "AST Notification Management"
{
    trigger OnRun()
    begin
        ScheduleWarrantyCheck();
        ScheduleMaintenanceCheck();
    end;

    procedure SendWarrantyExpiryAlert(AssetNo: Code[20])
    var
        ASTAsset: Record "AST Asset";
        ASTSetup: Record "AST Setup";
        DaysUntilExpiry: Integer;
        AlertText: Text;
    begin
        ASTAsset.Get(AssetNo);
        if ASTAsset."Warranty Expiry Date" = 0D then
            exit;
        ASTSetup := ASTSetup.GetSetup();
        DaysUntilExpiry := ASTAsset."Warranty Expiry Date" - Today();

        if (DaysUntilExpiry <= ASTSetup."Warranty Alert Lead Days") and (DaysUntilExpiry > 0) then begin
            AlertText := StrSubstNo('Warranty Alert: Asset %1 warranty expires in %2 days', AssetNo, DaysUntilExpiry);

            ShowNotification(AlertText, 'Warranty Alert', AssetNo);
        end;
    end;

    procedure SendMaintenanceDueAlert(AssetNo: Code[20])
    var
        ASTAsset: Record "AST Asset";
        ASTSetup: Record "AST Setup";
        DaysRemaining: Integer;
        AlertText: Text;
    begin
        ASTAsset.Get(AssetNo);
        if ASTAsset."Last Maintenance Date" = 0D then
            exit;
        ASTSetup := ASTSetup.GetSetup();
        DaysRemaining := ASTAsset."Maintenance Interval Days" - (Today() - ASTAsset."Last Maintenance Date");
        if DaysRemaining <= ASTSetup."Maintenance Alert Lead Days" then begin
            AlertText := StrSubstNo('Maintenance Due: Asset %1 maintenance due in %2 days', AssetNo, DaysRemaining);

            ShowNotification(AlertText, 'Maintenance Alert', AssetNo);
        end;
    end;

    procedure ScheduleWarrantyCheck()
    var
        ASTAsset: Record "AST Asset";
    begin
        ASTAsset.SetFilter("Warranty Expiry Date", '<%1', Today() + 30);
        ASTAsset.SetFilter("Warranty Expiry Date", '>%1', Today());
        if ASTAsset.FindSet() then
            repeat
                SendWarrantyExpiryAlert(ASTAsset."No.");
            until ASTAsset.Next() = 0;
    end;

    procedure ScheduleMaintenanceCheck()
    var
        ASTAsset: Record "AST Asset";
        MaintenanceMgt: Codeunit "AST Maintenance Management";
    begin
        ASTAsset.SetRange(Active, true);
        if ASTAsset.FindSet() then
            repeat
                if MaintenanceMgt.CheckMaintenanceDue(ASTAsset."No.") then
                    SendMaintenanceDueAlert(ASTAsset."No.");
            until ASTAsset.Next() = 0;
    end;

    local procedure ShowNotification(NotificationText: Text; EventType: Text[50]; AssetNo: Code[20])
    var
        Notif: Notification;
        ASTAuditMgt: Codeunit "AST Audit Management";
    begin
        if GuiAllowed() then begin
            Notif.Message := NotificationText;
            Notif.Scope := NotificationScope::LocalScope;
            Notif.Send();
        end;
        ASTAuditMgt.LogAlert(EventType, AssetNo, NotificationText);
    end;
}