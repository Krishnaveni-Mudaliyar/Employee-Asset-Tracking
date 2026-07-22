page 50023 "AST Maintenance API"
{
    APIPublisher = 'krishnavenimudaliyar';
    APIGroup = 'employeeAssetTracking';
    APIVersion = 'v1.0';
    Caption = 'assetMaintenance';
    DelayedInsert = true;
    EntityName = 'assetMaintenance';
    EntitySetName = 'assetMaintenance';
    ODataKeyFields = SystemId;
    PageType = API;
    SourceTable = "AST Maintenance Entry";
    InsertAllowed = false;
    ModifyAllowed = false;

    layout
    {
        area(Content)
        {
            field(id; Rec.SystemId)
            {
                Caption = 'Id';
                Editable = false;
            }
            field(MaintenanceNo; Rec."Maintenance No.") { }
            field(EntryNo; Rec."Entry No.") { }
            field(AssetNo; Rec."Asset No.") { }
            field(Description; Rec.Description) { }
            field(StartDate; Rec."Start Date") { }
            field(EndDate; Rec."End Date") { }
            field(Status; Rec.Status) { }
            field(CompletionNotes; Rec."Completion Notes") { }
            field(lastModifiedDateTime; Rec.SystemModifiedAt)
            {
                Editable = false;
            }
        }
    }

    [ServiceEnabled]
    procedure startMaintenance(assetNo: Code[20]; description: Text[250]; var ActionContext: WebServiceActionContext)
    var
        MaintenanceMgt: Codeunit "AST Maintenance Management";
        NewMaintenanceEntry: Record "AST Maintenance Entry";
        MaintenanceNo: Code[20];
    begin
        MaintenanceNo := MaintenanceMgt.StartMaintenance(assetNo, description);

        NewMaintenanceEntry.SetRange("Maintenance No.", MaintenanceNo);

        if NewMaintenanceEntry.FindFirst() then
            SetActionResponse(ActionContext, NewMaintenanceEntry.SystemId)
        else
            ActionContext.SetResultCode(WebServiceActionResultCode::Updated);
    end;

    [ServiceEnabled]
    procedure completeMaintenance(CompletionNotes: Text[500]; var ActionContext: WebServiceActionContext)
    var
        MaintenanceMgt: Codeunit "AST Maintenance Management";

    begin
        MaintenanceMgt.CompleteMaintenance(Rec."Maintenance No.", CompletionNotes);
        SetActionResponse(ActionContext, rec.SystemId);
    end;

    local procedure SetActionResponse(var ActionContext: WebServiceActionContext; DocumentId: Guid)
    begin
        ActionContext.SetObjectType(ObjectType::Page);

        ActionContext.SetObjectId(Page::"AST Maintenance API");

        ActionContext.AddEntityKey(Rec.FieldNo(SystemId), DocumentId);

        ActionContext.SetResultCode(WebServiceActionResultCode::Updated);
    end;
}