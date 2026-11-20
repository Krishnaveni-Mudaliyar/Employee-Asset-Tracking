pageextension 50001 "Fixed Asset List Ext" extends "Fixed Asset List"
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
    actions
    {
        addlast(Processing)
        {
            action(AssetRegisterReport)
            {
                ApplicationArea = All;
                Caption = 'Asset Register';
                Image = Report;
                ToolTip = 'Runs the asset register for all assets.';

                trigger OnAction()
                begin
                    Report.Run(Report::"Asset Register", true, false);
                end;
            }
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
                    Report.Run(Report::"Asset History", true, false, FixedAsset);
                end;
            }
            action(OverdueAssetReport)
            {
                ApplicationArea = All;
                Caption = 'Overdue Assets';
                Image = Report;
                RunObject = report "Overdue Assets";
                ToolTip = 'Runs the overdue assets report.';
            }
            action(PrintAssetLabels)
            {
                ApplicationArea = All;
                Caption = 'Print Asset Labels';
                Image = BarCode;
                ToolTip = 'Prints labels for the selected assets.';

                trigger OnAction()
                var
                    FixedAsset: Record "Fixed Asset";
                begin
                    CurrPage.SetSelectionFilter(FixedAsset);
                    Report.Run(Report::"Asset Label", true, false, FixedAsset);
                end;
            }
            action(ShowAssignments)
            {
                ApplicationArea = All;
                Caption = 'Assignment History';
                Image = History;
                RunObject = page "Asset Assignment List";
                RunPageLink = "Asset No." = field("No.");
                ToolTip = 'Opens all assignments for the selected asset.';
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
                    if ReturnAssetDialog.RunModal() <> Action::OK then
                        exit;

                    Processed := AssetBulkManagement.BulkReturn(
                        FixedAsset,
                        ReturnAssetDialog.GetCondition(),
                        ReturnAssetDialog.GetRemarks(),
                        Skipped);

                    Message('%1 asset(s) returned. %2 skipped because they are not assigned.', Processed, Skipped);
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
                    AssetBulkManagement: Codeunit "Asset Bulk Management";
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

                    Message('%1 asset(s) transferred. %2 skipped because they are not assigned.', Processed, Skipped);
                    CurrPage.Update(false);
                end;
            }
            action(ImportAssetsFromExcel)
            {
                ApplicationArea = All;
                Caption = 'Import Assets from Excel';
                Image = ImportExcel;
                ToolTip = 'Creates assets from an Excel file. Columns: Description, Category, Sub Category, Brand, Model, Serial No., Tag No., Location, Warranty Start, Warranty End.';

                trigger OnAction()
                var
                    AssetExcelImport: Codeunit "Asset Excel Import";
                    InStr: InStream;
                    FileName: Text;
                    Created: Integer;
                begin
                    if not UploadIntoStream('Select the Excel file', '', 'Excel Files (*.xlsx)|*.xlsx', FileName, InStr) then
                        exit;

                    Created := AssetExcelImport.ImportFromStream(InStr);
                    Message('%1 asset(s) imported.', Created);
                    CurrPage.Update(false);
                end;
            }
        }
    }
}