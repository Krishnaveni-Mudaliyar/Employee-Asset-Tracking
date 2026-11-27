codeunit 50020 "Asset Clearance Management"
{
    procedure StartClearance(EmployeeNo: Code[20]; LastWorkingDate: Date): Code[20]
    var
        ClearanceHeader: Record "Asset Clearance Header";
    begin
        ClearanceHeader.Init();
        ClearanceHeader.Insert(true);
        ClearanceHeader.Validate("Employee No.", EmployeeNo);
        ClearanceHeader."Last Working Date" := LastWorkingDate;
        ClearanceHeader.Modify(true);

        LoadAssets(ClearanceHeader);

        exit(ClearanceHeader."No.");
    end;

    procedure LoadAssets(var ClearanceHeader: Record "Asset Clearance Header")
    var
        ClearanceLine: Record "Asset Clearance Line";
        AssetAssignment: Record "Asset Assignment";
        FixedAsset: Record "Fixed Asset";
        LineNo: Integer;

    begin
        ClearanceHeader.TestField(Status, ClearanceHeader.Status::Open);
        ClearanceHeader.TestField("Employee No.");

        ClearanceLine.SetRange("Clearance No.", ClearanceHeader."No.");
        ClearanceLine.DeleteAll(true);

        AssetAssignment.SetRange("Employee No.", ClearanceHeader."Employee No.");
        AssetAssignment.SetRange(Active, true);
        if not AssetAssignment.FindSet() then
            exit;

        repeat
            LineNo += 10000;
            ClearanceLine.Init();
            ClearanceLine."Clearance No." := ClearanceHeader."No.";
            ClearanceLine."Line No." := LineNo;
            ClearanceLine."Asset No." := AssetAssignment."Asset No.";
            ClearanceLine."Assignment No." := AssetAssignment."No.";
            if FixedAsset.Get(AssetAssignment."Asset No.") then
                ClearanceLine.Description := FixedAsset.Description;
            ClearanceLine.Action := ClearanceLine.Action::Pending;
            ClearanceLine.Insert(true);
        until AssetAssignment.Next() = 0;
    end;

    procedure CompleteClearance(var ClearanceHeader: Record "Asset Clearance Header")
    var
        ClearanceLine: Record "Asset Clearance Line";
    begin
        ClearanceHeader.TestField(Status, ClearanceHeader.Status::Open);

        ClearanceHeader.CalcFields("Open Lines");
        if ClearanceHeader."Open Lines" > 0 then
            Error('%1 asset(s) still need an action. Choose Return, Transfer or Not Recovered on every line.', ClearanceHeader."Open Lines");

        ClearanceLine.SetRange("Clearance No.", ClearanceHeader."No.");
        if ClearanceLine.FindSet(true) then
            repeat
                ProcessLine(ClearanceLine);
            until ClearanceLine.Next() = 0;

        ClearanceHeader.Status := ClearanceHeader.Status::Cleared;
        ClearanceHeader."Cleared Date" := Today();
        ClearanceHeader.Modify(true);
    end;

    procedure CancelClearance(var ClearanceHeader: Record "Asset Clearance Header")
    begin
        ClearanceHeader.TestField(Status, ClearanceHeader.Status::Open);

        ClearanceHeader.Status := ClearanceHeader.Status::Cancelled;
        ClearanceHeader.Modify(true);
    end;

    local procedure ProcessLine(var ClearanceLine: Record "Asset Clearance Line")
    var
        AssetReturnManagement: Codeunit "Asset Return Management";
        AssetTransferManagement: Codeunit "Asset Transfer Management";
    begin
        case ClearanceLine.Action of
            ClearanceLine.Action::Return:
                AssetReturnManagement.ReturnAsset(
                    ClearanceLine."Asset No.",
                    ClearanceLine."Return Condition",
                    CopyStr(ClearanceLine.Remarks, 1, 250));
            ClearanceLine.Action::Transfer:
                begin
                    ClearanceLine.TestField("Transfer To Employee No.");
                    AssetTransferManagement.TransferAsset(
                        ClearanceLine."Asset No.",
                        ClearanceLine."Transfer To Employee No.",
                        '',
                        CopyStr(ClearanceLine.Remarks, 1, 250));
                end;
            ClearanceLine.Action::"Not Recovered":
                begin
                    ClearanceLine.TestField(Remarks);
                    WriteOffAsset(ClearanceLine."Asset No.");
                end;
        end;

        ClearanceLine."Resolved Date" := Today();
        ClearanceLine.Modify(true);
    end;

    local procedure WriteOffAsset(AssetNo: Code[20])
    var
        AssetAssignment: Record "Asset Assignment";
        FixedAsset: Record "Fixed Asset";
    begin
        AssetAssignment.SetRange("Asset No.", AssetNo);
        AssetAssignment.SetRange(Active, true);
        if AssetAssignment.FindFirst() then begin
            AssetAssignment.Active := false;
            AssetAssignment.Modify(true);
        end;

        FixedAsset.Get(AssetNo);
        FixedAsset."Asset Status" := FixedAsset."Asset Status"::Disposed;
        FixedAsset.Blocked := true;
        FixedAsset.Modify(true);
    end;
}