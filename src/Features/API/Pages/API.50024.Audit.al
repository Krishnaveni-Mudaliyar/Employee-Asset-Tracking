page 50024 "AST Audit API"
{
    APIPublisher = 'krishnavenimudaliyar';
    APIGroup = 'employeeAssetTracking';
    APIVersion = 'v1.0';
    Caption = 'assetAuditLog';
    EntityName = 'assetAuditLog';
    EntitySetName = 'assetAuditLog';
    ODataKeyFields = "Entry No.";
    PageType = API;
    SourceTable = "AST Audit Log";
    Editable = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    DeleteAllowed = false;

    layout
    {
        area(Content)
        {
            field(EntryNo; Rec."Entry No.") { }
            field(eventType; Rec."Event Type") { }
            field(primaryNo; Rec."Primary No.") { }
            field(assetNo; Rec."Asset No.") { }
            field(employeeNo; Rec."Employee No.") { }
            field(notes; Rec.Notes) { }
            field(userId; Rec."User Id") { }
            field(createdAt; Rec."Created At") { }
        }
    }
}