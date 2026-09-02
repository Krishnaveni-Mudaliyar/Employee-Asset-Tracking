codeunit 50208 "Asset Request Approval Events"
{
    // Mirrors the pattern used in Customer Master Approval (CMA): subscribe to the
    // standard Approvals Mgmt. events and react only when the entry belongs to
    // Asset Request Header, then update the document's own Status field.

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Approvals Mgmt.",
    'OnApproveApprovalRequest',
    '',
    false,
    false)]
    local procedure OnApproveApprovalRequest(var ApprovalEntry: Record "Approval Entry")
    begin
        if ApprovalEntry."Table ID" <> Database::"Asset Request Header" then
            exit;

        SetAssetRequestApproved(ApprovalEntry."Record ID to Approve");
    end;

    [EventSubscriber(ObjectType::Codeunit,
    Codeunit::"Approvals Mgmt.",
    'OnRejectApprovalRequest',
    '',
    false,
    false)]
    local procedure OnRejectApprovalRequest(var ApprovalEntry: Record "Approval Entry")
    begin
        if ApprovalEntry."Table ID" <> Database::"Asset Request Header" then
            exit;

        SetAssetRequestRejected(ApprovalEntry."Record ID to Approve");
    end;

    local procedure SetAssetRequestApproved(RecordIdToApprove: RecordId)
    var
        AssetRequestHeader: Record "Asset Request Header";
        AssetNotificationManagement: Codeunit "Asset Notification Management";
    begin
        if not AssetRequestHeader.Get(RecordIdToApprove) then
            exit;

        AssetRequestHeader.Status := AssetRequestHeader.Status::Approved;
        AssetRequestHeader."Approved By" := CopyStr(UserId(), 1, MaxStrLen(AssetRequestHeader."Approved By"));
        AssetRequestHeader."Approval Date-Time" := CurrentDateTime();
        AssetRequestHeader.Modify(true);

        AssetNotificationManagement.Notify(
           AssetRequestHeader."Requested By",
           StrSubstNo('Your asset request %1 has been approved.', AssetRequestHeader."No."),
           AssetRequestHeader."No.");
    end;

    local procedure SetAssetRequestRejected(RecordIdToApprove: RecordId)
    var
        AssetRequestHeader: Record "Asset Request Header";
        AssetNotificationManagement: Codeunit "Asset Notification Management";
    begin
        if not AssetRequestHeader.Get(RecordIdToApprove) then
            exit;

        AssetRequestHeader.Status := AssetRequestHeader.Status::Rejected;
        AssetRequestHeader."Approved By" := CopyStr(UserId(), 1, MaxStrLen(AssetRequestHeader."Approved By"));
        AssetRequestHeader."Approval Date-Time" := CurrentDateTime();
        AssetRequestHeader.Modify(true);

        AssetNotificationManagement.Notify(
           AssetRequestHeader."Requested By",
           StrSubstNo('Your asset request %1 has been rejected.', AssetRequestHeader."No."),
           AssetRequestHeader."No.");
    end;
}