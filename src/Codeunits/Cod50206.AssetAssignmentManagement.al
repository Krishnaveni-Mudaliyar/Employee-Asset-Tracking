codeunit 50206 "Asset Assignment Management"
{
    procedure AssignAsset(var AssetRequestLine: Record "Asset Request Line"; AssetNo: Code[20])
    var
        AssetRequestHeader: Record "Asset Request Header";
        Asset: Record Asset;
        AssetAssignment: Record "Asset Assignment";
    begin
        AssetRequestHeader.Get(AssetRequestLine."Document No.");

        if AssetRequestHeader.Status <> AssetRequestHeader.Status::Approved then
            Error(
                'Asset request %1 must be Approved before assets can be assigned.',
                AssetRequestHeader."No.");

        if AssetRequestLine."Assigned Quantity" >= AssetRequestLine."Approved Quantity" then
            Error(
                'Asset request line for %1 is already fully assigned (%2 of %3).',
                AssetRequestLine."Asset Category Code",
                AssetRequestLine."Assigned Quantity",
                AssetRequestLine."Approved Quantity");

        Asset.Get(AssetNo);

        if Asset.Blocked then
            Error('Asset %1 is blocked and cannot be assigned.', AssetNo);

        if Asset.Status <> Asset.Status::Available then
            Error('Asset %1 is not Available (current status: %2).', AssetNo, Asset.Status);

        if (AssetRequestLine."Asset Category Code" <> '') and
           (Asset."Category Code" <> AssetRequestLine."Asset Category Code")
        then
            Error(
                'Asset %1 does not belong to the requested category %2.',
                AssetNo, AssetRequestLine."Asset Category Code");

        if (AssetRequestLine."Asset Sub Category Code" <> '') and
           (Asset."Sub Category Code" <> AssetRequestLine."Asset Sub Category Code")
        then
            Error(
                'Asset %1 does not belong to the requested sub category %2.',
                AssetNo, AssetRequestLine."Asset Sub Category Code");

        AssetAssignment.Init();
        AssetAssignment."Document No." := AssetRequestLine."Document No.";
        AssetAssignment."Document Line No." := AssetRequestLine."Line No.";
        AssetAssignment."Asset No." := AssetNo;
        AssetAssignment."Employee No." := AssetRequestHeader."Employee No.";
        AssetAssignment.Insert(true);

        Asset.Status := Asset.Status::Assigned;
        Asset.Modify(true);

        AssetRequestLine.Validate("Assigned Quantity", AssetRequestLine."Assigned Quantity" + 1);
        AssetRequestLine.Modify(true);

        CloseHeaderIfFullyAssigned(AssetRequestHeader);
    end;

    local procedure CloseHeaderIfFullyAssigned(var AssetRequestHeader: Record "Asset Request Header")
    var
        AssetRequestLine: Record "Asset Request Line";
        AllLinesFullyAssigned: Boolean;
    begin
        AssetRequestLine.SetRange("Document No.", AssetRequestHeader."No.");

        if not AssetRequestLine.FindSet() then
            exit;

        AllLinesFullyAssigned := true;

        repeat
            if AssetRequestLine."Assigned Quantity" < AssetRequestLine."Approved Quantity" then
                AllLinesFullyAssigned := false;
        until AssetRequestLine.Next() = 0;

        if AllLinesFullyAssigned then begin
            AssetRequestHeader.Status := AssetRequestHeader.Status::Closed;
            AssetRequestHeader.Modify(true);
        end;
    end;
}