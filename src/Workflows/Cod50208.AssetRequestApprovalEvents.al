codeunit 50208 "Asset Request Approval Events"
{
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
        AssetRequestHeader."Approved By" := CopyStr(
            UserId(),
            1,
MaxStrLen(
    AssetRequestHeader."Approved By"));
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
        AssetRequestHeader."Approved By" := CopyStr(
            UserId(),
            1,
            MaxStrLen(
                AssetRequestHeader."Approved By"));
        AssetRequestHeader."Approval Date-Time" := CurrentDateTime();
        AssetRequestHeader.Modify(true);

        AssetNotificationManagement.Notify(
           AssetRequestHeader."Requested By",
                StrSubstNo(
                 'Your asset request %1 has been rejected.',
                 AssetRequestHeader."No."),
                AssetRequestHeader."No.");
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Approvals Mgmt.", 'OnPopulateApprovalEntryArgument', '', false, false)]
    local procedure OnPopulateApprovalEntryArgument(var RecRef: RecordRef; var ApprovalEntryArgument: Record "Approval Entry"; WorkflowStepInstance: Record "Workflow Step Instance")
    var
        AssetRequestHeader: Record "Asset Request Header";
    begin
        if RecRef.Number <> Database::"Asset Request Header" then
            exit;

        RecRef.SetTable(AssetRequestHeader);
        ApprovalEntryArgument."Document No." := AssetRequestHeader."No.";
    end;

    [EventSubscriber(ObjectType::Table, Database::"Approval Entry", 'OnAfterInsertEvent', '', false, false)]
    local procedure NotifyApproverOnApprovalEntryInsert(var Rec: Record "Approval Entry"; RunTrigger: Boolean)
    var
        AssetRequestHeader: Record "Asset Request Header";
        AssetNotificationManagement: Codeunit "Asset Notification Management";
    begin
        if Rec."Table ID" <> Database::"Asset Request Header" then
            exit;
        if Rec.Status <> Rec.Status::Open then
            exit;
        if not AssetRequestHeader.Get(Rec."Record ID to Approve") then
            exit;

        AssetNotificationManagement.Notify(
            Rec."Approver ID",
            StrSubstNo('Asset request %1 is waiting for your approval.', AssetRequestHeader."No."),
            AssetRequestHeader."No.");
    end;
}