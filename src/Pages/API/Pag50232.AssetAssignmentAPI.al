page 50232 "Asset Assignment API"
{
    PageType = API;
    APIPublisher = 'astTracking';
    APIGroup = 'assets';
    APIVersion = 'v1.0';
    EntityName = 'assetAssignment';
    EntitySetName = 'assetAssignments';
    SourceTable = "Asset Assignment";
    DelayedInsert = true;
    Editable = false;
    ODataKeyFields = SystemId;
    Caption = 'assetAssignment';

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field(id; Rec.SystemId)
                {
                    Caption = 'Id';
                }
                field(number; Rec."No.")
                {
                    Caption = 'No.';
                }
                field(assetNo; Rec."Asset No.")
                {
                    Caption = 'Asset No.';
                }
                field(employeeNo; Rec."Employee No.")
                {
                    Caption = 'Employee No.';
                }
                field(assignmentDate; Rec."Assignment Date")
                {
                    Caption = 'Assignment Date';
                }
                field(expectedReturnDate; Rec."Expected Return Date")
                {
                    Caption = 'Expected Return Date';
                }
                field(active; Rec."Active")
                {
                    Caption = 'Active';
                }
                field(documentNo; Rec."Document No.")
                {
                    Caption = 'Document No.';
                }
            }
        }
    }
}