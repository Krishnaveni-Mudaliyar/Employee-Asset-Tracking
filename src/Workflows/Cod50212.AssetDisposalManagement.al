codeunit 50212 "Asset Disposal Management"
{
    procedure DisposeAsset(AssetNo: Code[20]; Reason: Text[250])
    var
        Asset: Record Asset;
        AssetDisposal: Record "Asset Disposal";
    begin
        Asset.Get(AssetNo);

        if Asset.Status = Asset.Status::Assigned then
            Error('Asset %1 is currently assigned. Return or transfer it before disposing of it.', AssetNo);

        if Asset.Status = Asset.Status::Disposed then
            Error('Asset %1 has already been disposed.', AssetNo);

        AssetDisposal.Init();
        AssetDisposal."Asset No." := AssetNo;
        AssetDisposal.Reason := Reason;
        AssetDisposal.Insert(true);

        Asset.Status := Asset.Status::Disposed;
        Asset.Blocked := true;
        Asset.Modify(true);
    end;
}