codeunit 50001 "AST Asset Assignment"
{
    procedure AssignAsset(var ASTAsset: Record "AST Asset"; EmployeeNo: Code[20]; AssignmentNotes: Text[250]): Code[20]

    var
        ASTAssignment: Record "AST Assignment";
        ASTSetup: Record "AST Setup";
        NoSeries: Codeunit "No. Series";
        ASTAuditMgt: Codeunit "AST Audit Management";
        AssignmentNo: Code[20];

    begin
        ASTAsset.LockTable();
        ASTAsset.Get(ASTAsset."No.");
        ValidateAvailability(ASTAsset);
        ValidateEmployee(EmployeeNo);

        ASTAssignment.LockTable();
        ASTAssignment.SetRange("Asset No.", ASTAsset."No.");
        ASTAssignment.SetRange(Status, ASTAssignment.Status::Active);

        if not ASTAssignment.IsEmpty then
            Error('Asset %1 already has an active assignment. Cannot assign twice.', ASTAsset."No.");

        ASTAssignment.Init();

        ASTSetup := ASTSetup.GetSetup();
        AssignmentNo := NoSeries.GetNextNo(ASTSetup."Assignment Nos.", WorkDate());

        ASTAssignment."Assignment No." := AssignmentNo;
        ASTAssignment."Asset No." := ASTAsset."No.";
        ASTAssignment."Employee No." := EmployeeNo;
        ASTAssignment."Assignment Date" := WorkDate();

        ASTAssignment."Assignment Notes" := AssignmentNotes;
        ASTAssignment.Status := ASTAssignment.Status::"Active";
        ASTAssignment."Assigned By" := UserId;
        ASTAssignment.Insert(true);

        CreateAssignmentEntry(ASTAssignment);

        ASTAsset.Status := ASTAsset.Status::"Assigned";
        ASTAsset."Current Employee" := EmployeeNo;
        ASTAsset."Assignment Date" := WorkDate();
        ASTAsset.Modify(true);
        ASTAuditMgt.LogAssetAssignment(AssignmentNo, ASTAsset."No.", EmployeeNo, AssignmentNotes);
        exit(AssignmentNo);
    end;

    procedure ReturnAsset(var ASTAssignment: Record "AST Assignment"; AssetCondition: Enum "AST Asset Condition"; ReturnNotes: Text[250]): Code[20]
    var
        ASTAsset: Record "AST Asset";
        ASTReturnEntry: Record "AST Return Entry";
        ASTSetup: Record "AST Setup";
        NoSeries: Codeunit "No. Series";
        ASTAuditMgt: Codeunit "AST Audit Management";
        ReturnNo: Code[20];

    begin
        ASTAssignment.LockTable();
        ASTAssignment.Get(ASTAssignment."Assignment No.");
        if ASTAssignment.Status <> ASTAssignment.Status::Active
        then
            Error('Only active assignments can be returned.');
        ValidateReturn(ASTAssignment);

        ASTReturnEntry.Init();

        ASTSetup := ASTSetup.GetSetup();
        ReturnNo := NoSeries.GetNextNo(ASTSetup."Return Nos", WorkDate());

        ASTReturnEntry.Init();

        ASTReturnEntry."Return No." := ReturnNo;
        ASTReturnEntry."Assignment No." := ASTAssignment."Assignment No.";
        ASTReturnEntry."Asset No." := ASTAssignment."Asset No.";
        ASTReturnEntry."Return Date" := WorkDate();
        ASTReturnEntry.Condition := AssetCondition;
        ASTReturnEntry.Notes := ReturnNotes;
        ASTReturnEntry."Posting Date" := WorkDate();
        ASTReturnEntry."Posted By" := UserId;
        ASTReturnEntry.Insert(true);

        ASTAsset.Get(ASTAssignment."Asset No.");
        ASTAsset.Status := ASTAsset.Status::"Available";
        ASTAsset."Current Employee" := '';
        ASTAsset."Asset Condition" := AssetCondition;
        ASTAsset.Modify(true);

        ASTAssignment.Status := ASTAssignment.Status::"Returned";
        ASTAssignment."Return Date" := WorkDate();
        ASTAssignment."Return Condition" := AssetCondition;
        ASTAssignment.Modify(true);

        ASTAuditMgt.LogAssetReturn(ReturnNo, ASTAssignment."Asset No.", ASTAssignment."Employee No.", AssetCondition);
        exit(ReturnNo);
    end;

    procedure TransferAsset(var ASTAssignment: Record "AST Assignment"; NewEmployeeNo: Code[20]): Code[20]
    var
        ASTAsset: Record "AST Asset";
        ASTAuditMgt: Codeunit "AST Audit Management";
        NewAssignmentNo: Code[20];

    begin
        ASTAssignment.LockTable();
        ASTAssignment.Get(ASTAssignment."Assignment No.");

        if ASTAssignment.Status <> ASTAssignment.Status::"Active" then
            Error('Only active assignments can be transferred.');
        ValidateEmployee(NewEmployeeNo);

        // Free the asset from its current assignment first, so AssignAsset's
        // ValidateAvailability check (which requires Status = Available) doesn't fail.
        ASTAsset.LockTable();
        ASTAsset.Get(ASTAssignment."Asset No.");
        ASTAsset.Status := ASTAsset.Status::Available;
        ASTAsset."Current Employee" := '';
        ASTAsset.Modify(true);

        ASTAssignment.Status := ASTAssignment.Status::"Transferred";
        ASTAssignment.Modify(true);

        NewAssignmentNo := AssignAsset(ASTAsset, NewEmployeeNo, '');

        ASTAuditMgt.LogAssetTransfer(ASTAssignment."Assignment No.", NewAssignmentNo, ASTAsset."No.", NewEmployeeNo);
        exit(NewAssignmentNo);
    end;

    local procedure ValidateAvailability(ASTAsset: Record "AST Asset")
    begin
        if ASTAsset.Status <> ASTAsset.Status::Available then
            Error('Asset %1 is not available. Current status: %2', ASTAsset."No.", ASTAsset.Status);
        if ASTAsset."Maintenance Status" = ASTAsset."Maintenance Status"::"In Maintenance" then
            Error('Asset %1 is in maintenance and cannot be assigned.', ASTAsset."No.");
    end;

    local procedure ValidateReturn(ASTAssignment: Record "AST Assignment")
    begin
        if ASTAssignment.Status <> ASTAssignment.Status::"Active" then
            Error('Only active assignments can be returned.');
    end;

    local procedure ValidateEmployee(EmployeeNo: Code[20])
    var
        Employee: Record Employee;
    begin
        if not Employee.Get(EmployeeNo) then
            Error('Employee %1 does not exist.', EmployeeNo);
        if Employee.Status = Employee.Status::Inactive then
            Error('Cannot assign to inactive employee %1.', EmployeeNo);
    end;

    local procedure CreateAssignmentEntry(ASTAssignment: Record "AST Assignment")
    var
        ASTAssignmentEntry: Record "AST Assignment Entry";
    begin
        ASTAssignmentEntry.Init();
        ASTAssignmentEntry."Assignment No." := ASTAssignment."Assignment No.";
        ASTAssignmentEntry."Asset No." := ASTAssignment."Asset No.";
        ASTAssignmentEntry."Employee No." := ASTAssignment."Employee No.";
        ASTAssignmentEntry."Assignment Date" := ASTAssignment."Assignment Date";
        ASTAssignmentEntry."Posting Date" := WorkDate();
        ASTAssignmentEntry."Posted By" := UserId;
        ASTAssignmentEntry.Insert(true);
    end;
}