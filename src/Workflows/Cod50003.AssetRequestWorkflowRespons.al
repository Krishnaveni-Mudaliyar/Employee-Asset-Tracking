codeunit 50003 "Asset Request Workflow Respons"
{
    procedure SetAssetRequestPendingApprovalCode(): Code[128]
    begin
        exit('SETASSETREQUESTPENDINGAPPROVAL');
    end;


    [EventSubscriber(
        ObjectType::Codeunit,
        Codeunit::"Workflow Response Handling",
        OnAddWorkflowResponsesToLibrary,
        '',
        false,
        false)]
    local procedure AddAssetRequestWorkflowResponsesToLibrary()
    var
        WorkflowResponseHandling: Codeunit "Workflow Response Handling";
    begin
        WorkflowResponseHandling.AddResponseToLibrary(
            SetAssetRequestPendingApprovalCode(),
            Database::"Asset Request Header",
            'Set asset request status to pending approval.',
            'Group 0');
    end;

    [EventSubscriber(
        ObjectType::Codeunit,
        Codeunit::"Workflow Response Handling",
        OnAddWorkflowResponsePredecessorsToLibrary,
        '',
        false,
        false)]
    local procedure AddAssetRequestWorkflowResponsePredecessors(ResponseFunctionName: Code[128])
    var
        AssetRequestWorkflowEvents: Codeunit "Asset Request Workflow Events";
        WorkflowResponseHandling: Codeunit "Workflow Response Handling";
    begin
        case ResponseFunctionName of
            WorkflowResponseHandling.CreateApprovalRequestsCode():
                WorkflowResponseHandling.AddResponsePredecessor(
                    WorkflowResponseHandling.CreateApprovalRequestsCode(),
                    AssetRequestWorkflowEvents.RunWorkflowOnSendAssetRequestForApprovalCode());

            SetAssetRequestPendingApprovalCode():
                WorkflowResponseHandling.AddResponsePredecessor(
                        SetAssetRequestPendingApprovalCode(), AssetRequestWorkflowEvents.RunWorkflowOnSendAssetRequestForApprovalCode());
        end;
    end;

    [EventSubscriber(
        ObjectType::Codeunit,
        Codeunit::"Workflow Response Handling",
        OnExecuteWorkflowResponse,
        '',
        false,
        false)]
    local procedure ExecuteAssetRequestWorkflowResponse(
        var ResponseExecuted: Boolean;
        Variant: Variant;
        xVariant: Variant;
        ResponseWorkflowStepInstance: Record "Workflow Step Instance")
    var
        AssetRequestHeader: Record "Asset Request Header";
    begin
        if ResponseWorkflowStepInstance."Function Name" <> SetAssetRequestPendingApprovalCode() then
            exit;

        AssetRequestHeader := Variant;

        AssetRequestHeader.Status := AssetRequestHeader.Status::"Pending Approval";

        AssetRequestHeader.Modify(true);

        ResponseExecuted := true;
    end;


}