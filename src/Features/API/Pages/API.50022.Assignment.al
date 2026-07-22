page 50022 "AST Assignment API"
{
    APIPublisher = 'krishnavenimudaliyar';
    APIGroup = 'employeeAssetTracking';
    APIVersion = 'v1.0';
    Caption = 'assignment';
    DelayedInsert = true;
    EntityName = 'assignment';
    EntitySetName = 'assignments';
    ODataKeyFields = SystemId;
    PageType = API;
    SourceTable = "AST Assignment";
    InsertAllowed = false;
    ModifyAllowed = false;

    layout
    {
        area(content)
        {
            field(id; Rec.SystemId)
            {
                Caption = 'Id';
                Editable = false;
            }
            field(number; Rec."Assignment No.")
            {
                Caption = 'Number';
            }
            field(assetNo; Rec."Asset No.") { }
            field(employeeNo; Rec."Employee No.") { }
            field(EmployeeName; Rec."Employee Name") { }
            field(assignmentDate; Rec."Assignment Date") { }
            field(returnDate; Rec."Return Date") { }
            field(status; Rec.Status) { }
            field(notes; Rec."Assignment Notes") { }
            field(ReturnCondition; Rec."Return Condition") { }
            field(lastModifiedDateTime; Rec.SystemModifiedAt)
            {
                Editable = false;
            }
        }
    }

    [ServiceEnabled]
    procedure returnAsset(Condition: Enum "AST Asset Condition"; notes: Text[250]; var ActionContext: WebServiceActionContext)
    var
        AssignmentMgt: Codeunit "AST Asset Assignment";
    begin
        AssignmentMgt.ReturnAsset(Rec, Condition, notes);
        SetActionResponse(ActionContext, Rec.SystemId);
    end;

    [ServiceEnabled]
    procedure transferAsset(newEmployeeNo: Code[20]; var ActionContext: WebServiceActionContext)
    var
        AssignmentMgt: Codeunit "AST Asset Assignment";
    begin
        AssignmentMgt.TransferAsset(Rec, newEmployeeNo);
        SetActionResponse(ActionContext, rec.SystemId);
    end;

    local procedure SetActionResponse(var ActionContext: WebServiceActionContext; DocumentId: Guid)
    begin
        ActionContext.SetObjectType(ObjectType::Page);

        ActionContext.SetObjectId(Page::"AST Assignment API");

        ActionContext.AddEntityKey(Rec.FieldNo(SystemId), DocumentId);

        ActionContext.SetResultCode(WebServiceActionResultCode::Updated);
    end;
}