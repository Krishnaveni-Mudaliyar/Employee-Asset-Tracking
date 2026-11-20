page 50010 "Asset Assignment List"
{
    ApplicationArea = All;
    Caption = 'Asset Assignments';
    PageType = List;
    SourceTable = "Asset Assignment";
    UsageCategory = Lists;
    Editable = false;

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("No."; Rec."No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the No. field.', Comment = '%';
                }
                field("Document No."; Rec."Document No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Document No. field.', Comment = '%';
                }
                field("Asset No."; Rec."Asset No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Asset No. field.', Comment = '%';
                }
                field("Employee No."; Rec."Employee No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Employee No. field.', Comment = '%';
                }
                field("Assignment Date"; Rec."Assignment Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Assignment Date field.', Comment = '%';
                }
                field("Expected Return Date"; Rec."Expected Return Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the date the asset is expected to be returned.';
                }
                field(Active; Rec.Active)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies whether this assignment is still active.';
                }
                field("Assigned By"; Rec."Assigned By")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Assigned By field.', Comment = '%';
                }
            }
        }
    }
    actions
    {
        area(Processing)
        {
            action(PrintHandover)
            {
                ApplicationArea = All;
                Caption = 'Print Handover';
                Image = Report;
                ToolTip = 'Runs the handover report for the selected assignments.';

                trigger OnAction()
                var
                    SelectedRec: Record "Asset Assignment";
                begin
                    CurrPage.SetSelectionFilter(SelectedRec);
                    Report.Run(Report::"Asset Handover", true, false, SelectedRec);
                end;
            }
            action(ReturnAsset)
            {
                ApplicationArea = All;
                Caption = 'Return Asset';
                Image = ReturnShipment;
                Enabled = Rec.Active;
                ToolTip = 'Return the asset on the selected assignment.';

                trigger OnAction()
                var
                    AssetReturnManagement: Codeunit "Asset Return Management";
                    ReturnAssetDialog: Page "Return Asset Dialog";
                begin
                    if ReturnAssetDialog.RunModal() <> Action::OK then
                        exit;

                    AssetReturnManagement.ReturnAsset(
                        Rec."Asset No.", ReturnAssetDialog.GetCondition(), ReturnAssetDialog.GetRemarks());
                    CurrPage.Update(false);
                end;
            }
            action(TransferAsset)
            {
                ApplicationArea = All;
                Caption = 'Transfer Asset';
                Image = TransferOrder;
                Enabled = Rec.Active;
                ToolTip = 'Transfer the asset on the selected assignment.';

                trigger OnAction()
                var
                    AssetTransferManagement: Codeunit "Asset Transfer Management";
                    TransferAssetDialog: Page "Transfer Asset Dialog";
                begin
                    if TransferAssetDialog.RunModal() <> Action::OK then
                        exit;

                    AssetTransferManagement.TransferAsset(
                        Rec."Asset No.", TransferAssetDialog.GetToEmployeeNo(),
                        TransferAssetDialog.GetToLocationCode(), TransferAssetDialog.GetRemarks());
                    CurrPage.Update(false);
                end;
            }
        }
    }
}