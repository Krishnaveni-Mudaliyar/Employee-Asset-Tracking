codeunit 50204 "Asset Request Approval Mgmt."
{
    procedure HasPendingApproval(AssetRequestNo: Code[20]): Boolean
    var
        ApprovalEntry: Record "Approval Entry";
    begin
        ApprovalEntry.SetRange("Table ID", Database::"Asset Request Header");
        ApprovalEntry.SetRange("Document No.", AssetRequestNo);
        ApprovalEntry.SetRange(Status, ApprovalEntry.Status::Open);

        exit(not ApprovalEntry.IsEmpty());
    end;

    procedure CancelApprovalRequest(var AssetRequestHeader: Record "Asset Request Header")
    var
        ApprovalEntry: Record "Approval Entry";
        RecRef: RecordRef;
    begin
        if AssetRequestHeader.Status <> AssetRequestHeader.Status::"Pending Approval" then
            Error('Asset request %1 does not have an open approval request to cancel.', AssetRequestHeader."No.");

        if not HasPendingApproval(AssetRequestHeader."No.") then
            Error('Asset request %1 does not have an open approval request to cancel.', AssetRequestHeader."No.");

        RecRef.GetTable(AssetRequestHeader);

        ApprovalEntry.SetRange("Table ID", Database::"Asset Request Header");
        ApprovalEntry.SetRange("Document No.", AssetRequestHeader."No.");
        ApprovalEntry.SetRange(Status, ApprovalEntry.Status::Open);

        if ApprovalEntry.FindSet(true) then
            repeat
                ApprovalEntry.Status := ApprovalEntry.Status::Canceled;
                ApprovalEntry."Last Modified Date-Time" := CurrentDateTime();
                ApprovalEntry.Modify(true);
            until ApprovalEntry.Next() = 0;

        AssetRequestHeader.Status := AssetRequestHeader.Status::Open;
        AssetRequestHeader.Modify(true);

        // NOTE: this cancels the Approval Entry records directly rather than calling
        // Codeunit "Approvals Mgmt." internally, since its cancellation procedure name
        // varies across BC versions. If your environment exposes a public cancel
        // procedure on Approvals Mgmt. (e.g. for approver notifications), prefer
        // calling that instead of the manual loop above — verify against your BC 28
        // symbol package before shipping.
    end;
}