page 50009 "AST Maintenance Dialog"
{
    PageType = StandardDialog;
    Caption = 'Maintenance';

    layout
    {
        area(content)
        {
            group(AssetInfo)
            {
                Caption = 'Asset Information';
                field(AssetNo; AssetNo_Var)
                {
                    ApplicationArea = All;
                    Caption = 'Asset No.';
                    Editable = false;
                }
                field(Description; Description_Var)
                {
                    ApplicationArea = All;
                    Caption = 'Description';
                    Editable = false;
                }
            }
            group(Maintenance)
            {
                Caption = 'Maintenance Details';
                field(MaintenanceDesc; MaintenanceDesc_Var)
                {
                    ApplicationArea = All;
                    Caption = 'Maintenance Description';
                }
                field(CompletionNotes; CompletionNotes_Var)
                {
                    ApplicationArea = All;
                    Caption = 'Completion Notes';
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            action(Start)
            {
                ApplicationArea = All;
                Caption = 'Start Maintenance';
                InFooterBar = true;
                Visible = IsStart;
                Image = Start;

                trigger OnAction()
                begin
                    ProcessStartMaintenance();
                end;
            }
            action(Complete)
            {
                ApplicationArea = All;
                Caption = 'Complete Maintenance';
                InFooterBar = true;
                Visible = not ISstart;

                trigger OnAction()
                begin
                    ProcessCompleteMaintenance();
                end;
            }
        }
    }

    procedure SetAsset(ASTAsset: Record "AST Asset"; StartProcess: Boolean)
    begin
        AssetNo_Var := ASTAsset."No.";
        Description_Var := ASTAsset.Description;
        IsStart := StartProcess;
    end;

    local procedure ProcessStartMaintenance()
    var
        MaintenanceMgt: Codeunit "AST Maintenance Management";
    begin
        if MaintenanceDesc_Var = '' then
            Error('Maintenance description is required.');
        MaintenanceMgt.StartMaintenance(AssetNo_Var, MaintenanceDesc_Var);
        Message('Maintenance started for asset %1', AssetNo_Var);
    end;

    local procedure ProcessCompleteMaintenance()
    var
        MaintenanceMgt: Codeunit "AST Maintenance Management";
        ASTMaintenanceEntry: Record "AST Maintenance Entry";
    begin
        ASTMaintenanceEntry.SetRange("Asset No.", AssetNo_Var);
        ASTMaintenanceEntry.SetRange(Status, ASTMaintenanceEntry.Status::"In Progress");
        if not ASTMaintenanceEntry.FindFirst() then
            Error('No active maintenance found for asset %1', AssetNo_Var);

        MaintenanceMgt.CompleteMaintenance(ASTMaintenanceEntry."Maintenance No.", CompletionNotes_Var);
        Message('Maintenance completed for asset %1', AssetNo_Var);
    end;

    var
        AssetNo_Var: Code[20];
        Description_Var: Text[100];
        MaintenanceDesc_Var: Text[250];
        CompletionNotes_Var: Text[500];
        IsStart: Boolean;
}