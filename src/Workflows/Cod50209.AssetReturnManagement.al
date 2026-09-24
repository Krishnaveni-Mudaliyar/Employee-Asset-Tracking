codeunit 50209 "Asset Return Management"
{
    procedure ReturnAsset(AssetNo: Code[20]; Condition: Enum "Asset Condition"; Remarks: Text[250])
    var
        FixedAsset: Record "Fixed Asset";
        AssetAssignment: Record "Asset Assignment";
        AssetReturn: Record "Asset Return";
    begin
        FixedAsset.Get(AssetNo);

        if FixedAsset."IT Asset Status" <> FixedAsset."IT Asset Status"::Assigned then
            Error('Asset %1 is not currently Assigned and cannot be returned.', AssetNo);

        AssetAssignment.SetRange("Asset No.", AssetNo);
        AssetAssignment.SetRange(Active, true);
        if not AssetAssignment.FindLast() then
            Error('No active assignment was found for asset %1.', AssetNo);

        AssetReturn.Init();
        AssetReturn."Asset No." := AssetNo;
        AssetReturn."Employee No." := AssetAssignment."Employee No.";
        AssetReturn.Condition := Condition;
        AssetReturn.Remarks := Remarks;
        AssetReturn.Insert(true);

        AssetAssignment.Active := false;
        AssetAssignment.Modify(true);

        FixedAsset."IT Asset Condition" := Condition;

        // A returned asset in New/Good/Fair condition goes straight back into the
        // available pool; Damaged/Beyond Repair routes it to maintenance instead of
        // silently becoming assignable again.
        case Condition of
            Condition::New, Condition::Good, Condition::Fair:
                FixedAsset."IT Asset Status" := FixedAsset."IT Asset Status"::Available;
            Condition::Damaged, Condition::"Under Repair", Condition::"Beyond Repair":
                FixedAsset."IT Asset Status" := FixedAsset."IT Asset Status"::"Under Maintenance";
        end;

        FixedAsset.Modify(true);
    end;
}