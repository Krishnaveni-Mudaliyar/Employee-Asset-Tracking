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

        NotifyRequesterOfAssignment(AssetRequestHeader, AssetNo);
        CloseHeaderIfFullyAssigned(AssetRequestHeader);
    end;

    procedure BulkAssignFromStock(var AssetRequestLine: Record "Asset Request Line"): Integer
    var
        Asset: Record Asset;
        RemainingToAssign: Integer;
        AssignedCount: Integer;
    begin
        RemainingToAssign := AssetRequestLine."Approved Quantity" - AssetRequestLine."Assigned Quantity";

        if RemainingToAssign <= 0 then
            Error(
                'Asset request line for %1 is already fully assigned (%2 of %3).',
                AssetRequestLine."Asset Category Code",
                AssetRequestLine."Assigned Quantity",
                AssetRequestLine."Approved Quantity");

        Asset.SetRange(Status, Asset.Status::Available);
        Asset.SetRange(Blocked, false);

        if AssetRequestLine."Asset Category Code" <> '' then
            Asset.SetRange("Category Code", AssetRequestLine."Asset Category Code");

        if AssetRequestLine."Asset Sub Category Code" <> '' then
            Asset.SetRange("Sub Category Code", AssetRequestLine."Asset Sub Category Code");

        if not Asset.FindSet() then
            exit(0);

        AssignedCount := 0;

        repeat
            if AssignedCount < RemainingToAssign then begin
                AssignAsset(AssetRequestLine, Asset."No.");
                AssignedCount += 1;
            end;
        until (Asset.Next() = 0) or (AssignedCount >= RemainingToAssign);

        exit(AssignedCount);
    end;

    local procedure NotifyRequesterOfAssignment(AssetRequestHeader: Record "Asset Request Header"; AssetNo: Code[20])
    var
        AssetNotificationManagement: Codeunit "Asset Notification Management";
    begin
        AssetNotificationManagement.Notify(
            AssetRequestHeader."Requested By",
            StrSubstNo('Asset %1 has been assigned to you for request %2.', AssetNo, AssetRequestHeader."No."),
            AssetRequestHeader."No.");
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