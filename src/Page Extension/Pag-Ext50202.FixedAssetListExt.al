pageextension 50202 "Fixed Asset Card Ext" extends "Fixed Asset Card"
{
    layout
    {
        addafter(General)
        {
            group(AssetTracking)
            {
                Caption = 'Asset Tracking';

                field("Asset Category Code"; Rec."Asset Category Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the IT asset category of this fixed asset.', Comment = '%';
                }
                field("Asset Sub Category Code"; Rec."Asset Sub Category Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the IT asset sub category of this fixed asset.', Comment = '%';
                }
                field("Brand Code"; Rec."Brand Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the brand of this fixed asset.', Comment = '%';
                }
                field("Model No."; Rec."Model No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the model number of this fixed asset.', Comment = '%';
                }
                field("Asset Tag No."; Rec."Asset Tag No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the internal asset tag number of this fixed asset.', Comment = '%';
                }
                field("Asset Status"; Rec."Asset Status")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the IT asset lifecycle status of this fixed asset.', Comment = '%';
                }
                field("Asset Condition"; Rec."Asset Condition")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the physical condition of this fixed asset.', Comment = '%';
                }
                field("Purchase Date"; Rec."Purchase Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the purchase date of the asset.';
                }
                field("Purchase Cost"; Rec."Purchase Cost")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the purchase cost of the asset.';
                }
                field("Warranty Start Date"; Rec."Warranty Start Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Warranty Start Date field.', Comment = '%';
                }
                field("Warranty End Date"; Rec."Warranty End Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Warranty End Date field.', Comment = '%';
                }
            }
        }
        addlast(factboxes)
        {
            part(AssignmentHistory; "Asset Assignment Hist. FactBox")
            {
                ApplicationArea = All;
                Caption = 'Assignment History';
                SubPageLink = "Asset No." = field("No.");
            }
            part(MaintenanceHistory; "Asset Maintenance Hist. FctBox")
            {
                ApplicationArea = All;
                Caption = 'Maintenance History';
                SubPageLink = "Asset No." = field("No.");
            }
        }
    }
    actions
    {
        addlast(Processing)
        {
            action(ReturnAsset)
            {
                ApplicationArea = All;
                Caption = 'Return Asset';
                Image = ReturnShipment;
                ToolTip = 'Return this asset from the employee it is currently assigned to.';

                trigger OnAction()
                var
                    AssetReturnManagement: Codeunit "Asset Return Management";
                    ReturnAssetDialog: Page "Return Asset Dialog";
                begin
                    if ReturnAssetDialog.RunModal() <> Action::OK then
                        exit;

                    AssetReturnManagement.ReturnAsset(
                        Rec."No.",
                        ReturnAssetDialog.GetCondition(),
                        ReturnAssetDialog.GetRemarks());
                    CurrPage.Update(false);
                end;
            }
            action(TransferAsset)
            {
                ApplicationArea = All;
                Caption = 'Transfer Asset';
                Image = TransferOrder;
                ToolTip = 'Transfer this asset to a different employee or location.';

                trigger OnAction()
                var
                    AssetTransferManagement: Codeunit "Asset Transfer Management";
                    TransferAssetDialog: Page "Transfer Asset Dialog";
                begin
                    if TransferAssetDialog.RunModal() <> Action::OK then
                        exit;

                    AssetTransferManagement.TransferAsset(
                        Rec."No.",
                        TransferAssetDialog.GetToEmployeeNo(),
                        TransferAssetDialog.GetToLocationCode(),
                        TransferAssetDialog.GetRemarks());
                    CurrPage.Update(false);
                end;
            }
            action(SendToMaintenance)
            {
                ApplicationArea = All;
                Caption = 'Send to Maintenance';
                Image = ServiceItem;
                ToolTip = 'Send this asset for maintenance.';

                trigger OnAction()
                var
                    AssetMaintenanceManagement: Codeunit "Asset Maintenance Management";
                    SendToMaintenanceDialog: Page "Send To Maintenance Dialog";
                begin
                    if SendToMaintenanceDialog.RunModal() <> Action::OK then
                        exit;

                    AssetMaintenanceManagement.SendToMaintenance(
                        Rec."No.",
                        SendToMaintenanceDialog.GetVendorNo(),
                        SendToMaintenanceDialog.GetDescription());
                    CurrPage.Update(false);
                end;
            }
            action(DisposeAsset)
            {
                ApplicationArea = All;
                Caption = 'Dispose Asset (IT)';
                Image = Delete;
                ToolTip = 'Retire this asset from IT asset tracking and block it from further requests. This does NOT post an FA disposal entry — use standard Fixed Asset disposal for that.';

                trigger OnAction()
                var
                    AssetDisposalManagement: Codeunit "Asset Disposal Management";
                    DisposeAssetDialog: Page "Dispose Asset Dialog";
                begin
                    if not Confirm('Do you want to dispose of asset %1?', false, Rec."No.") then
                        exit;

                    if DisposeAssetDialog.RunModal() <> Action::OK then
                        exit;

                    AssetDisposalManagement.DisposeAsset(
                        Rec."No.",
                        DisposeAssetDialog.GetReason());
                    CurrPage.Update(false);
                end;
            }
            // action(AssetHistoryReport)
            // {
            //     ApplicationArea = All;
            //     Caption = 'Asset History';
            //     Image = Report;
            //     ToolTip = 'Runs the asset history report for this asset.';

            //     trigger OnAction()
            //     var
            //         FixedAsset: Record "Fixed Asset";
            //     begin
            //         FixedAsset.SetRange("No.", Rec."No.");
            //         Report.Run(Report::"Asset History Report", true, false, FixedAsset);
            //     end;
            // }
            // action(ShowAssignments)
            // {
            //     ApplicationArea = All;
            //     Caption = 'Assignment History';
            //     Image = History;
            //     RunObject = page "Asset Assignment List";
            //     RunPageLink = "Asset No." = field("No.");
            //     ToolTip = 'Opens all assignments for this asset.';
            // }
            // action(ShowMaintenance)
            // {
            //     ApplicationArea = All;
            //     Caption = 'Maintenance History';
            //     Image = History;
            //     RunObject = page "Asset Maintenance List";
            //     RunPageLink = "Asset No." = field("No.");
            //     ToolTip = 'Opens all maintenance entries for this asset.';
            // }
        }
    }
}