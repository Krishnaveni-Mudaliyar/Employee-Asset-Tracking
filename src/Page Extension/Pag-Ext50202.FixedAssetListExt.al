pageextension 50202 "Fixed Asset Card Ext" extends "Fixed Asset Card"
{
    layout
    {
        addlast(General)
        {
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
            field("Asset Brand Code"; Rec."Asset Brand Code")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the brand of this fixed asset.', Comment = '%';
            }
            field("IT Model No."; Rec."IT Model No.")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the model number of this fixed asset.', Comment = '%';
            }
            field("IT Serial No."; Rec."IT Serial No.")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the serial number of this fixed asset.', Comment = '%';
            }
            field("IT Asset Tag No."; Rec."IT Asset Tag No.")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the internal asset tag number of this fixed asset.', Comment = '%';
            }
            field("IT Asset Status"; Rec."IT Asset Status")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the IT asset lifecycle status of this fixed asset.', Comment = '%';
            }
            field("IT Asset Condition"; Rec."IT Asset Condition")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the physical condition of this fixed asset.', Comment = '%';
            }
            field("IT Location Code"; Rec."IT Location Code")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies where this fixed asset is physically located.', Comment = '%';
            }
            field("IT Asset Blocked"; Rec."IT Asset Blocked")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies whether this fixed asset is blocked from IT asset requests/assignment.', Comment = '%';
            }
        }
        addlast(General)
        {
            group("IT Warranty")
            {
                Caption = 'IT Warranty';

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
        addlast(FactBoxes)
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
        }
    }
}