codeunit 50001 "Asset Request Workflow Events"
{
    procedure RunWorkflowOnSendAssetRequestForApprovalCode(): Code[128]
    begin
        exit('RUNWORKFLOWONSENDASSETREQUESTFOR APPROVAL');
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
        ObjectType::Codeunit,
        Codeunit::"Workflow Event Handling",
        OnAddWorkflowEventPredecessorsToLibrary,
        '',
        false,
        false)]

    local procedure AddAssetRequestWorkflowEventPredecessors(EventFunctionName: Code[128])
    begin
    end;
}