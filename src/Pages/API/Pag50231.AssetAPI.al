page 50231 "Asset API"
{
    PageType = API;
    APIPublisher = 'astTracking';
    APIGroup = 'assets';
    APIVersion = 'v1.0';
    EntityName = 'asset';
    EntitySetName = 'assets';
    SourceTable = "Fixed Asset";
    DelayedInsert = true;
    Editable = false;
    ODataKeyFields = SystemId;
    Caption = 'asset';

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field(Id; Rec.SystemId)
                {
                    Caption = 'Id';
                }
                field(number; Rec."No.")
                {
                    Caption = 'No.';
                }
                field(description; Rec."Description")
                {
                    Caption = 'Description';
                }
                field(categoryCode; Rec."Asset Category Code")
                {
                    Caption = 'Asset Category Code';
                }
                field(subCategoryCode; Rec."Asset Sub Category Code")
                {
                    Caption = 'Asset Sub Category Code';
                }
                field(brandCode; Rec."Asset Brand Code")
                {
                    Caption = 'Asset Brand Code';
                }
                field(modelNo; Rec."IT Model No.")
                {
                    Caption = 'IT Model No.';
                }
                field(serialNo; Rec."IT Serial No.")
                {
                    Caption = 'IT Serial No.';
                }
                field(assetTagNo; Rec."IT Asset Tag No.")
                {
                    Caption = 'IT Asset Tag No.';
                }
                field(condition; Rec."IT Asset Condition")
                {
                    Caption = 'IT Asset Condition';
                }
                field(status; Rec."IT Asset Status")
                {
                    Caption = 'IT Asset Status';
                }
                field(warrantyStartDate; Rec."Warranty Start Date")
                {
                    Caption = 'Warranty Start Date';
                }
                field(warrantyEndDate; Rec."Warranty End Date")
                {
                    Caption = 'Warranty End Date';
                }
                field(locationCode; Rec."IT Location Code")
                {
                    Caption = 'IT Location Code';
                }
                field(blocked; Rec."IT Asset Blocked")
                {
                    Caption = 'IT Asset Blocked';
                }
            }
        }
    }
}