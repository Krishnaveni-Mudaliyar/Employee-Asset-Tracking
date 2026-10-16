pageextension 50203 "Fixed Asset List Ext" extends "Fixed Asset List"
{
    layout
    {
        addlast(Control1)
        {
            field("Asset Category Code"; Rec."Asset Category Code")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Asset Category Code field.', Comment = '%';
            }
            field("Asset Sub Category Code"; Rec."Asset Sub Category Code")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Asset Sub Category Code field.', Comment = '%';
            }
            field("Asset Brand Code"; Rec."Asset Brand Code")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Asset Brand Code field.', Comment = '%';
            }
            field("IT Model No."; Rec."IT Model No.")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Model No. field.', Comment = '%';
            }
            field("IT Serial No."; Rec."IT Serial No.")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Serial No. field.', Comment = '%';
            }
            field("IT Asset Tag No."; Rec."IT Asset Tag No.")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Asset Tag No. field.', Comment = '%';
            }
            field("IT Asset Status"; Rec."IT Asset Status")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the IT Asset Status field.', Comment = '%';
            }
            field("IT Asset Condition"; Rec."IT Asset Condition")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the IT Asset Condition field.', Comment = '%';
            }
            field("IT Location Code"; Rec."IT Location Code")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the IT Location Code field.', Comment = '%';
            }
            field("IT Asset Blocked"; Rec."IT Asset Blocked")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the IT Asset Blocked field.', Comment = '%';
            }
        }
    }
    actions
    {
        addlast(processing)
        {
            action(AssetHistoryReport)
            {
                ApplicationArea = All;
                Caption = 'Asset History';
                Image = Report;
                ToolTip = 'Runs the asset history report for the selected assets.';

                trigger OnAction()
                var
                    FixedAsset: Record "Fixed Asset";
                begin
                    CurrPage.SetSelectionFilter(FixedAsset);
                    Report.Run(Report::"Asset History Report", true, false, FixedAsset);
                end;
            }

            action(BulkReturnAssets)
            {
                ApplicationArea = All;
                Caption = 'Return Selected Assets';
                Image = ReturnOrder;
                ToolTip = 'Returns all selected assigned assets with the same condition and remarks.';

                trigger OnAction()
                var
                    FixedAsset: Record "Fixed Asset";
                    ReturnAssetDialog: Page "Return Asset Dialog";
                    AssetBulkManagement: Codeunit "Asset Bulk Management";
                    Processed: Integer;
                    Skipped: Integer;

                begin
                    CurrPage.SetSelectionFilter(FixedAsset);
                    if ReturnAssetDialog.RunModal() <>
                    Action::OK then
                        exit;

                    Processed := AssetBulkManagement.BulkReturn(FixedAsset,
                    ReturnAssetDialog.GetCondition(),
                    ReturnAssetDialog.GetRemarks(),
                    Skipped);
                    CurrPage.Update(false);
                end;
            }

            action(BulkTransferAssets)
            {
                ApplicationArea = All;
                Caption = 'Transfer Selected Assets';
                Image = TransferOrder;
                ToolTip = 'Transfers all selected assigned assets to the same employee.';

                trigger OnAction()
                var
                    FixedAsset: Record "Fixed Asset";
                    TransferAssetDialog: Page "Transfer Asset Dialog";
                    AssetBulkManagement: "Asset Bulk Management";
                    Processed: Integer;
                    Skipped: Integer;

                begin
                    CurrPage.SetSelectionFilter(FixedAsset);
                    if TransferAssetDialog.RunModal() <> Action::OK then
                        exit;

                    Processed := AssetBulkManagement.BulkTransfer(
                        FixedAsset,
                        TransferAssetDialog.GetToEmployeeNo(),
                        TransferAssetDialog.GetToLocationCode(),
                        TransferAssetDialog.GetRemarks(),
                        Skipped);

                    Message('%1 asset(s) transferred. %2 skipped because they are not assigned',
                    Processed, Skipped);
                    CurrPage.Update(false);
                end;
            }

            action(ImportAssetsFromExcel)
            {
                ApplicationArea = All;
                Caption = 'Import Assets from Excel';
                Image = ImportExcel;
                ToolTip = 'Creates assets from an Excel File.Columns: Description,Category, Sub Category, Brand, Model, Serial No., Tag No., Location, Warranty Start, Warranty End';

                trigger OnAction()
                var
                    AssetExcelImport: Codeunit "Asset Excel Import";
                    InStr: InStream;
                    FileName: Text;
                    Created: Integer;
                begin
                    if not UploadIntoStream('Select the Excel file', '', 'Excel Files (*.xlsx)|*.xlsx',
                    FileName, InStr) then
                        exit;

                    Created := AssetExcelImport.ImportFromStream(InStr);
                    Message('%1 asset(s) imported.', Created);
                    CurrPage.Update(false);
                end;
            }

            action(OverdueAssetReport)
            {
                ApplicationArea = All;
                Caption = 'Overdue Assets';
                Image = Report;
                RunObject = report "Overdue Asset Report";
                ToolTip = 'Runs the overdue asset report.';
            }
        }
    }
}