page 50205 "Asset Card"
{
    ApplicationArea = All;
    Caption = 'Asset Card';
    PageType = Card;
    SourceTable = Asset;
    UsageCategory = None;

    layout
    {
        area(Content)
        {
            group(General)
            {
                Caption = 'General';

                field("No."; Rec."No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the No. field.', Comment = '%';
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Description field.', Comment = '%';
                }
                field("Category Code"; Rec."Category Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Category Code field.', Comment = '%';
                }
                field("Sub Category Code"; Rec."Sub Category Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Sub Category Code field.', Comment = '%';
                }
                field("Brand Code"; Rec."Brand Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Brand Code field.', Comment = '%';
                }
                field("Model No."; Rec."Model No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Model No. field.', Comment = '%';
                }
                field("Serial No."; Rec."Serial No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Serial No. field.', Comment = '%';
                }
                field("Asset Tag No."; Rec."Asset Tag No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Asset Tag No. field.', Comment = '%';
                }
                field(Status; Rec.Status)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Status field.', Comment = '%';
                }
                field(Condition; Rec.Condition)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Condition field.', Comment = '%';
                }
                field(Blocked; Rec.Blocked)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Blocked field.', Comment = '%';
                }
            }
            group(Purchase)
            {
                Caption = 'Purchase';

                field("Purchase Date"; Rec."Purchase Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Purchase Date field.', Comment = '%';
                }
                field("Purchase Cost"; Rec."Purchase Cost")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Purchase Cost field.', Comment = '%';
                }
                field("Vendor No."; Rec."Vendor No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Vendor No. field.', Comment = '%';
                }
            }
            group(Location)
            {
                Caption = 'Location';

                field("Location Code"; Rec."Location Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Location Code field.', Comment = '%';
                }
            }
            group(Warranty)
            {
                Caption = 'Warranty';

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
        area(FactBoxes)
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
        area(Processing)
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
                    if ReturnAssetDialog.RunModal() <>
                    Action::OK then
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
                    if TransferAssetDialog.RunModal() <>
                    Action::OK then
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
                    if SendToMaintenanceDialog.RunModal() <>
                    Action::OK then
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
                Caption = 'Dispose Asset';
                Image = Delete;
                ToolTip = 'Retire this asset and block it from further use.';

                trigger OnAction()
                var
                    AssetDisposalManagement: Codeunit "Asset Disposal Management";
                    DisposeAssetDialog: Page "Dispose Asset Dialog";

                begin
                    if not Confirm(
                        'Do you want to dispose of asset %1?',
                        false,
                        Rec."No.") then
                        exit;

                    if DisposeAssetDialog.RunModal() <>
                    Action::OK then
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