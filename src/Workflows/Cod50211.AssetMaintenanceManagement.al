codeunit 50211 "Asset Maintenance Management"
{
    procedure SendToMaintenance(AssetNo: Code[20]; VendorNo: Code[20]; Description: Text[250])
    var
        FixedAsset: Record "Fixed Asset";
        AssetMaintenance: Record "Asset Maintenance";
    begin
        FixedAsset.Get(AssetNo);

        if FixedAsset."IT Asset Blocked" then
            Error('Asset %1 is blocked.', AssetNo);

        if FixedAsset."IT Asset Status" <> FixedAsset."IT Asset Status"::Available then
            Error(
                'Asset %1 must be Available before it can be sent to maintenance (current status: %2). Return or transfer it first if it is assigned.',
                AssetNo, FixedAsset."IT Asset Status");

        AssetMaintenance.Init();
        AssetMaintenance."Asset No." := AssetNo;
        AssetMaintenance."Vendor No." := VendorNo;
        AssetMaintenance.Description := Description;
        AssetMaintenance.Insert(true);

        FixedAsset."IT Asset Status" := FixedAsset."IT Asset Status"::"Under Maintenance";
        FixedAsset.Modify(true);
    end;

    procedure CompleteMaintenance(var AssetMaintenance: Record "Asset Maintenance"; Cost: Decimal)
    var
        FixedAsset: Record "Fixed Asset";
    begin
        if AssetMaintenance.Completed then
            Error('Maintenance record %1 is already completed.', AssetMaintenance."No.");

        AssetMaintenance."End Date" := WorkDate();
        AssetMaintenance.Cost := Cost;
        AssetMaintenance.Completed := true;
        AssetMaintenance.Modify(true);
        FixedAsset.Get(AssetMaintenance."Asset No.");
        FixedAsset."IT Asset Status" := FixedAsset."IT Asset Status"::Available;
        FixedAsset.Modify(true);
    end;
}