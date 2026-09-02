page 50217 "Asset Maintenance List"
{
    ApplicationArea = All;
    Caption = 'Asset Maintenance';
    PageType = List;
    SourceTable = "Asset Maintenance";
    UsageCategory = Lists;

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("No."; Rec."No.")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Specifies the value of the No. field.', Comment = '%';
                }
                field("Asset No."; Rec."Asset No.")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Specifies the value of the Asset No. field.', Comment = '%';
                }
                field("Start Date"; Rec."Start Date")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Specifies the value of the Start Date field.', Comment = '%';
                }
                field("End Date"; Rec."End Date")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Specifies the value of the End Date field.', Comment = '%';
                }
                field("Vendor No."; Rec."Vendor No.")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Specifies the value of the Vendor No. field.', Comment = '%';
                }
                field(Cost; Rec.Cost)
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Specifies the value of the Cost field.', Comment = '%';
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Specifies the value of the Description field.', Comment = '%';
                }
                field(Completed; Rec.Completed)
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Specifies the value of the Completed field.', Comment = '%';
                }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(CompleteMaintenance)
            {
                ApplicationArea = All;
                Caption = 'Complete Maintenance';
                Image = Approve;
                ToolTip = 'Mark this maintenance record as completed and set the asset back to Available.';

                trigger OnAction()
                var
                    AssetMaintenanceManagement: Codeunit "Asset Maintenance Management";
                    CompleteMaintenanceDialog: Page "Complete Maintenance Dialog";
                begin
                    if Rec.Completed then
                        Error('Maintenance record %1 is already completed.', Rec."No.");

                    if CompleteMaintenanceDialog.RunModal() <> Action::OK then
                        exit;

                    AssetMaintenanceManagement.CompleteMaintenance(Rec, CompleteMaintenanceDialog.GetCost());
                    CurrPage.Update(false);
                end;
            }
        }
    }
}