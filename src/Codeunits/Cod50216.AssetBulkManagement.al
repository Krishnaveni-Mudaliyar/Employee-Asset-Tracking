codeunit 50216 "Asset Bulk Management"
{
    procedure BulkReturn(var FixedAsset: Record "Fixed Asset";
    Condition: Enum "Asset Condition"; Remarks: Text[250];
    var Skipped: Integer): Integer
    var
        AssetReturnManagement: Codeunit "Asset Return Management";
        Processed: Integer;
    begin
        Skipped := 0;
        if FixedAsset.FindSet() then
            repeat
                if FixedAsset."IT Asset Status" = FixedAsset."IT Asset Status"::Assigned then begin
                    AssetReturnManagement.ReturnAsset(FixedAsset."No.", Condition, Remarks);
                    Processed += 1;
                end else
                    Skipped += 1;
            until FixedAsset.Next() = 0;
        exit(Processed);
    end;

    procedure BulkTransfer(var FixedAsset: Record "Fixed Asset"; ToEmployeeNo: Code[20]; ToLocationCode: Code[20]; Remarks: Text[250]; var Skipped: Integer): Integer
    var
        AssetTransferManagement: Codeunit "Asset Transfer Management";
        Processed: Integer;
    begin
        Skipped := 0;
        if FixedAsset.FindSet() then
            repeat
                if FixedAsset."IT Asset Status" = FixedAsset."IT Asset Status"::Assigned then begin
                    AssetTransferManagement.TransferAsset(FixedAsset."No.", ToEmployeeNo, ToLocationCode, Remarks);
                    Processed += 1;
                end else
                    Skipped += 1;
            until FixedAsset.Next() = 0;
        exit(Processed);
    end;
}