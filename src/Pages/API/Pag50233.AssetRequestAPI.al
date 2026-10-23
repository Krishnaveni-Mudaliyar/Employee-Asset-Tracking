page 50233 "Asset Request API"
{
    PageType = API;
    APIPublisher = 'astTracking';
    APIGroup = 'assets';
    APIVersion = 'v1.0';
    EntityName = 'assetRequest';
    EntitySetName = 'assetRequests';
    SourceTable = "Asset Request Header";
    DelayedInsert = true;
    Editable = false;
    ODataKeyFields = SystemId;
    Caption = 'assetRequest';

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
                field(employeeNo; Rec."Employee No.")
                {
                    Caption = 'Employee No.';
                }
                field(requestDate; Rec."Request Date")
                {
                    Caption = 'Request Date';
                }
                field(requiredDate; Rec."Required Date")
                {
                    Caption = 'Required Date';
                }
                field(departmentCode; Rec."Department Code")
                {
                    Caption = 'Department Code';
                }
                field(locationCode; Rec."Location Code")
                {
                    Caption = 'Location Code';
                }
                field(reason; Rec."Reason")
                {
                    Caption = 'Reason';
                }
                field(status; Rec."Status")
                {
                    Caption = 'Status';
                }
                field(requestedBy; Rec."Requested By")
                {
                    Caption = 'Requested By';
                }
                field(approvedBy; Rec."Approved By")
                {
                    Caption = 'Approved By';
                }
            }
        }
    }
}
