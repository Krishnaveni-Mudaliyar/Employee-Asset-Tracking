pageextension 50203 "Fixed Asset List Ext" extends "Fixed Asset List"
{
    layout
    {
        addafter(Description)
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
            field("Brand Code"; Rec."Brand Code")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Asset Brand Code field.', Comment = '%';
            }
            field("Asset Status"; Rec."Asset Status")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the IT Asset Status field.', Comment = '%';
            }
            field("Asset Condition"; Rec."Asset Condition")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the IT Asset Condition field.', Comment = '%';
            }
        }
    }
    // actions
    // {
    //     addlast(processing)
    //     {
    //         action(AssetHistoryReport)
    //         {
    //             ApplicationArea = All;
    //             Caption = 'Asset History';
    //             Image = Report;
    //             ToolTip = 'Runs the asset history report for the selected assets.';

    //             trigger OnAction()
    //             var
    //                 FixedAsset: Record "Fixed Asset";
    //             begin
    //                 CurrPage.SetSelectionFilter(FixedAsset);
    //                 Report.Run(Report::"Asset History Report", true, false, FixedAsset);
    //             end;
    //         }

    //         action(BulkReturnAssets)
    //         {
    //             ApplicationArea = All;
    //             Caption = 'Return Selected Assets';
    //             Image = ReturnOrder;
    //             ToolTip = 'Returns all selected assigned assets with the same condition and remarks.';

    //             trigger OnAction()
    //             var
    //                 FixedAsset: Record "Fixed Asset";
    //                 ReturnAssetDialog: Page "Return Asset Dialog";
    //                 AssetBulkManagement: Codeunit "Asset Bulk Management";
    //                 Processed: Integer;
    //                 Skipped: Integer;

    //             begin
    //                 CurrPage.SetSelectionFilter(FixedAsset);
    //                 if ReturnAssetDialog.RunModal() <>
    //                 Action::OK then
    //                     exit;

    //                 Processed := AssetBulkManagement.BulkReturn(FixedAsset,
    //                 ReturnAssetDialog.GetCondition(),
    //                 ReturnAssetDialog.GetRemarks(),
    //                 Skipped);
    //                 CurrPage.Update(false);
    //             end;
    //         }

    //         action(BulkTransferAssets)
    //         {
    //             ApplicationArea = All;
    //             Caption = 'Transfer Selected Assets';
    //             Image = TransferOrder;
    //             ToolTip = 'Transfers all selected assigned assets to the same employee.';

    //             trigger OnAction()
    //             var
    //                 FixedAsset: Record "Fixed Asset";
    //                 TransferAssetDialog: Page "Transfer Asset Dialog";
    //                 AssetBulkManagement: Codeunit "Asset Bulk Management";
    //                 Processed: Integer;
    //                 Skipped: Integer;

    //             begin
    //                 CurrPage.SetSelectionFilter(FixedAsset);
    //                 if TransferAssetDialog.RunModal() <> Action::OK then
    //                     exit;

    //                 Processed := AssetBulkManagement.BulkTransfer(
    //                     FixedAsset,
    //                     TransferAssetDialog.GetToEmployeeNo(),
    //                     TransferAssetDialog.GetToLocationCode(),
    //                     TransferAssetDialog.GetRemarks(),
    //                     Skipped);

    //                 Message('%1 asset(s) transferred. %2 skipped because they are not assigned',
    //                 Processed, Skipped);
    //                 CurrPage.Update(false);
    //             end;
    //         }

    //         action(ImportAssetsFromExcel)
    //         {
    //             ApplicationArea = All;
    //             Caption = 'Import Assets from Excel';
    //             Image = ImportExcel;
    //             ToolTip = 'Creates assets from an Excel File.Columns: Description,Category, Sub Category, Brand, Model, Serial No., Tag No., Location, Warranty Start, Warranty End';

    //             trigger OnAction()
    //             var
    //                 AssetExcelImport: Codeunit "Asset Excel Import";
    //                 InStr: InStream;
    //                 FileName: Text;
    //                 Created: Integer;
    //             begin
    //                 if not UploadIntoStream('Select the Excel file', '', 'Excel Files (*.xlsx)|*.xlsx',
    //                 FileName, InStr) then
    //                     exit;

    //                 Created := AssetExcelImport.ImportFromStream(InStr);
    //                 Message('%1 asset(s) imported.', Created);
    //                 CurrPage.Update(false);
    //             end;
    //         }

    //         action(OverdueAssetReport)
    //         {
    //             ApplicationArea = All;
    //             Caption = 'Overdue Assets';
    //             Image = Report;
    //             RunObject = report "Overdue Asset Report";
    //             ToolTip = 'Runs the overdue asset report.';
    //         }

    //         action(PrintAssetLabels)
    //         {
    //             ApplicationArea = All;
    //             Caption = 'Print Asset Labels';
    //             Image = BarCode;
    //             RunObject = report "Asset Label Report";
    //             ToolTip = 'Prints asset labels with a code 39 barcode of the asset tag (or asset no. if no tag).';
    //         }
    //     }
    // }
}