codeunit 50004 "Asset Request Approval Mgmt."
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
}