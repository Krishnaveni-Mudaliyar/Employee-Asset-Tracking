codeunit 50215 "Asset Employee Events"
{
    [EventSubscriber(ObjectType::Table, Database::Employee, 'OnAfterValidateEvent', 'Status', true, true)]
    local procedure CheckActiveAssetsOnStatusChange(var Rec: Record Employee; var xRec: Record Employee; CurrFieldNo: Integer)
    var
        ActiveAssetCount: Integer;
    begin
        if (xRec.Status <> xRec.Status::Active) or (Rec.Status = rec.Status::Active) then
            exit;

        ActiveAssetCount := CountActiveAssets(Rec."No.");
        if ActiveAssetCount = 0 then
            exit;
        if GuiAllowed() then
            if not confirm(
                'Employee %1 still holds %2 active asset(s).
                Return or transfer them before deactivating.
                \\Deactivate the employee anyway?',
                false, Rec."No.", ActiveAssetCount)
                then
                Error('');
    end;

    procedure CountActiveAssets(EmployeeNo: Code[20]): Integer
    var
        AssetAssignment: Record "Asset Assignment";
    begin
        if not AssetAssignment.ReadPermission() then
            exit(0);

        AssetAssignment.SetRange("Employee No.", EmployeeNo);
        AssetAssignment.setRange(Active, true);
        exit(AssetAssignment.Count());
    end;

}