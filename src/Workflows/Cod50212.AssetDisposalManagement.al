codeunit 50212 "Asset Disposal Management"
{
    procedure DisposeAsset(AssetNo: Code[20]; Reason: Text[250])
    var
        FixedAsset: Record "Fixed Asset";
        AssetDisposal: Record "Asset Disposal";
    begin
        FixedAsset.Get(AssetNo);

        if FixedAsset."IT Asset Status" = FixedAsset."IT Asset Status"::Assigned then
            Error('Asset %1 is currently assigned. Return or transfer it before disposing of it.', AssetNo);

        if FixedAsset."IT Asset Status" = FixedAsset."IT Asset Status"::Disposed then
            Error('Asset %1 has already been disposed.', AssetNo);

        AssetDisposal.Init();
        AssetDisposal."Asset No." := AssetNo;
        AssetDisposal.Reason := Reason;
        AssetDisposal.Insert(true);

        FixedAsset."IT Asset Status" := FixedAsset."IT Asset Status"::Disposed;
        FixedAsset."IT Asset Blocked" := true;
        FixedAsset.Modify(true);
    end;
}