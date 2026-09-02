codeunit 50211 "Asset Maintenance Management"
{
    procedure SendToMaintenance(AssetNo: Code[20]; VendorNo: Code[20]; Description: Text[250])
    var
        Asset: Record Asset;
        AssetMaintenance: Record "Asset Maintenance";
    begin
        Asset.Get(AssetNo);

        if Asset.Blocked then
            Error('Asset %1 is blocked.', AssetNo);

        if Asset.Status <> Asset.Status::Available then
            Error(
                'Asset %1 must be Available before it can be sent to maintenance (current status: %2). Return or transfer it first if it is assigned.',
                AssetNo, Asset.Status);

        AssetMaintenance.Init();
        AssetMaintenance."Asset No." := AssetNo;
        AssetMaintenance."Vendor No." := VendorNo;
        AssetMaintenance.Description := Description;
        AssetMaintenance.Insert(true);

        Asset.Status := Asset.Status::"Under Maintenance";
        Asset.Modify(true);
    end;

    procedure CompleteMaintenance(var AssetMaintenance: Record "Asset Maintenance"; Cost: Decimal)
    var
        Asset: Record Asset;
    begin
        if AssetMaintenance.Completed then
            Error('Maintenance record %1 is already completed.', AssetMaintenance."No.");

        AssetMaintenance."End Date" := WorkDate();
        AssetMaintenance.Cost := Cost;
        AssetMaintenance.Completed := true;
        AssetMaintenance.Modify(true);

        Asset.Get(AssetMaintenance."Asset No.");
        Asset.Status := Asset.Status::Available;
        Asset.Modify(true);
    end;
}