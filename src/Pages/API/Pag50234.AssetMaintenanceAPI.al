page 50234 "Asset Maintenance API"
{
    PageType = API;
    APIPublisher = 'astTracking';
    APIGroup = 'assets';
    APIVersion = 'v1.0';
    EntityName = 'assetMaintenance';
    EntitySetName = 'assetMaintenances';
    SourceTable = "Asset Maintenance";
    DelayedInsert = true;
    Editable = false;
    ODataKeyFields = SystemId;
    Caption = 'assetMaintenance';

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
                field(startDate; Rec."Start Date")
                {
                    Caption = 'Start Date';
                }
                field(endDate; Rec."End Date")
                {
                    Caption = 'End Date';
                }
                field(vendorNo; Rec."Vendor No.")
                {
                    Caption = 'Vendor No.';
                }
                field(cost; Rec."Cost")
                {
                    Caption = 'Cost';
                }
                field(description; Rec."Description")
                {
                    Caption = 'Description';
                }
                field(completed; Rec."Completed")
                {
                    Caption = 'Completed';
                }
            }
        }
    }
}