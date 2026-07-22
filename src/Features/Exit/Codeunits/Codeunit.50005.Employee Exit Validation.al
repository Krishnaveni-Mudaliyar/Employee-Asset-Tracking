codeunit 50005 "AST Employee Exit Validation"
{
    procedure ValidateEmployeeExit(EmployeeNo: Code[20]): Boolean
    begin
        exit(not HasPendingAssets(EmployeeNo) and not HasAssetsInMaintenance(EmployeeNo));
    end;

    procedure HasPendingAssets(EmployeeNo: Code[20]): Boolean
    var
        ASTAssignment: Record "AST Assignment";
    begin
        ASTAssignment.SetRange("Employee No.", EmployeeNo);
        ASTAssignment.SetRange(Status, ASTAssignment.Status::"Active");
        exit(not ASTAssignment.IsEmpty);
    end;

    procedure HasAssetsInMaintenance(EmployeeNo: Code[20]): Boolean
    var
        ASTAsset: Record "AST Asset";
    begin
        ASTAsset.SetRange("Current Employee", EmployeeNo);
        ASTAsset.SetRange("Maintenance Status", ASTAsset."Maintenance Status"::"In Maintenance");
        exit(not ASTAsset.IsEmpty);
    end;

    procedure GetPendingAssetCount(EmployeeNo: Code[20]): Integer
    var
        ASTAssignment: Record "AST Assignment";
    begin
        ASTAssignment.SetRange("Employee No.", EmployeeNo);
        ASTAssignment.SetRange(Status, ASTAssignment.Status::"Active");
        exit(ASTAssignment.Count);
    end;

    procedure BlockEmployeeExit(EmployeeNo: Code[20])
    var
        ErrorMsg: Text;
        PendingCount: Integer;
    begin
        if HasPendingAssets(EmployeeNo) then begin
            PendingCount := GetPendingAssetCount(EmployeeNo);
            ErrorMsg := 'Cannot exit employee %1. %2 asset(s) must be returned first.';
            Error(ErrorMsg, EmployeeNo, PendingCount);
        end;

        if HasAssetsInMaintenance(EmployeeNo) then begin
            ErrorMsg := 'Cannot exit employee %1. Employee has assets in maintenance. Complete maintenance first';
            Error(ErrorMsg, EmployeeNo);
        end;
    end;

    [EventSubscriber(ObjectType::Table, Database::Employee, 'OnBeforeModifyEvent', '', false, false)]
    local procedure OnBeforeModifyEmployee(var Rec: Record Employee; var xRec: Record Employee; RunTrigger: Boolean)
    begin
        if Rec.Status = Rec.Status::Inactive then
            if xRec.Status <> Rec.Status::Inactive then
                BlockEmployeeExit(Rec."No.");
    end;
}