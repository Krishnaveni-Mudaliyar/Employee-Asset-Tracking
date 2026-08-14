codeunit 50001 "Asset Request Workflow Events"
{
    procedure RunWorkflowOnSendAssetRequestForApprovalCode(): Code[128]
    begin
        exit('RUNWORKFLOWONSENDASSETREQUESTFORAPPROVAL');
    end;

    [EventSubscriber(
        ObjectType::Codeunit,
        Codeunit::"Workflow Event Handling",
        OnAddWorkflowEventsToLibrary,
        '',
        false,
        false)]
    local procedure AddAssetRequestWorkflowEventsToLibrary()
    var
        WorkFlowEventHandling: Codeunit "Workflow Event Handling";
    begin
        WorkFlowEventHandling.AddEventToLibrary(
            RunWorkflowOnSendAssetRequestForApprovalCode(),
            Database::"Asset Request Header",
            'An asset request is sent for approval.',
            0,
            false);
    end;

    [EventSubscriber(
        ObjectType::Table,
        Database::"Asset Request Header",
        OnSendAssetRequestForApproval,
        '',
        false,
        false)]
    local procedure RunWorkflowOnSendAssetRequestForApproval(
        var
         AssetRequestHeader: Record "Asset Request Header")
    var
        WorkflowManagement: Codeunit "Workflow Management";
    begin
        WorkflowManagement.HandleEvent(
            RunWorkflowOnSendAssetRequestForApprovalCode(),
            AssetRequestHeader);
    end;

    [EventSubscriber(
        ObjectType::Codeunit,
        Codeunit::"Workflow Event Handling",
        OnAddWorkflowEventPredecessorsToLibrary,
        '',
        false,
        false)]

    local procedure AddAssetRequestWorkflowEventPredecessors(EventFunctionName: Code[128])
    begin
    end;

    [EventSubscriber(
        ObjectType::Codeunit,
        Codeunit::"Workflow Event Handling",
        OnAddWorkflowTableRelationsToLibrary,
        '',
        false,
        false)]
    local procedure AddAssetRequestWorkflowTableRelationsToLibrary()
    var
        WorkflowSetup: Codeunit "Workflow Setup";
    begin
        WorkflowSetup.InsertTableRelation(
            Database::"Asset Request Header",
            1,
            Database::"Approval Entry",
            2);
    end;
}