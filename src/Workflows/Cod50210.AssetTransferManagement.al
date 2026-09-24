codeunit 50210 "Asset Transfer Management"
{
    procedure TransferAsset(AssetNo: Code[20]; ToEmployeeNo: Code[20]; ToLocationCode: Code[20]; Remarks: Text[250])
    var
        FixedAsset: Record "Fixed Asset";
        OldAssignment: Record "Asset Assignment";
        NewAssignment: Record "Asset Assignment";
        AssetTransfer: Record "Asset Transfer";
        Employee: Record Employee;
    begin
        FixedAsset.Get(AssetNo);

        if FixedAsset."IT Asset Status" <> FixedAsset."IT Asset Status"::Assigned then
            Error('Asset %1 is not currently Assigned and cannot be transferred.', AssetNo);

        Employee.Get(ToEmployeeNo);

        OldAssignment.SetRange("Asset No.", AssetNo);
        OldAssignment.SetRange(Active, true);
        if not OldAssignment.FindLast() then
            Error('No active assignment was found for asset %1.', AssetNo);

        if OldAssignment."Employee No." = ToEmployeeNo then
            Error('Asset %1 is already assigned to employee %2.', AssetNo, ToEmployeeNo);

        AssetTransfer.Init();
        AssetTransfer."Asset No." := AssetNo;
        AssetTransfer."From Employee No." := OldAssignment."Employee No.";
        AssetTransfer."To Employee No." := ToEmployeeNo;
        AssetTransfer."From Location Code" := FixedAsset."IT Location Code";
        AssetTransfer."To Location Code" := ToLocationCode;
        AssetTransfer.Remarks := Remarks;
        AssetTransfer.Insert(true);

        OldAssignment.Active := false;
        OldAssignment.Modify(true);

        NewAssignment.Init();
        NewAssignment."Document No." := OldAssignment."Document No.";
        NewAssignment."Document Line No." := OldAssignment."Document Line No.";
        NewAssignment."Asset No." := AssetNo;
        NewAssignment."Employee No." := ToEmployeeNo;
        NewAssignment.Insert(true);

        if ToLocationCode <> '' then
            FixedAsset."IT Location Code" := ToLocationCode;
        FixedAsset.Modify(true);
    end;
}