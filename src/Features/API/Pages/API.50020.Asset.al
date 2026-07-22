page 50020 "AST Asset API"
{
    APIPublisher = 'krishnavenimudaliyar';
    APIGroup = 'employeeAssetTracking';
    APIVersion = 'v1.0';
    Caption = 'asset';
    DelayedInsert = true;
    EntityName = 'asset';
    EntitySetName = 'assets';
    ODataKeyFields = SystemId;
    PageType = API;
    SourceTable = "AST Asset";

    layout
    {
        area(content)
        {
            field(id; Rec.SystemId)
            {
                Caption = 'Id';
                Editable = false;
            }
            field(number; Rec."No.")
            {
                Caption = 'Number';
            }
            field(description; Rec.Description) { }
            field(category; Rec.Category) { }
            field(status; Rec.Status)
            {
                Editable = false;
            }
            field(currentEmployeeNo; Rec."Current Employee")
            {
                Editable = false;
            }
            field(serialNumber; Rec."Serial Number") { }
            field(warrantyExpiryDate; Rec."Warranty Expiry Date") { }
            field(assetCondition; Rec."Asset Condition") { }
            field(Cost; Rec.Cost) { }
            field(lastModifiedDateTime; Rec.SystemModifiedAt)
            {
                Editable = false;
            }
        }
    }

    [ServiceEnabled]
    procedure assignAsset(employeeNo: Code[20]; notes: Text[250]; var ActionContext: WebServiceActionContext)
    var
        AssignmentMgt: Codeunit "AST Asset Assignment";
    begin
        AssignmentMgt.AssignAsset(Rec, employeeNo, notes);
        SetActionResponse(ActionContext, Rec.SystemId);
    end;

    local procedure SetActionResponse(var ActionContext: WebServiceActionContext; DocumentId: Guid)
    begin
        ActionContext.SetObjectType(ObjectType::Page);

        ActionContext.SetObjectId(Page::"AST Asset API");

        ActionContext.AddEntityKey(Rec.FieldNo(SystemId), DocumentId);

        ActionContext.SetResultCode(WebServiceActionResultCode::Updated);
    end;
}