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
                field(brandCode; Rec."Brand Code")
                {
                    Caption = 'Asset Brand Code';
                }
                field(modelNo; Rec."Model No.")
                {
                    Caption = 'IT Model No.';
                }
                field(serialNo; Rec."Serial No.")
                {
                    Caption = 'IT Serial No.';
                }
                field(assetTagNo; Rec."Asset Tag No.")
                {
                    Caption = 'IT Asset Tag No.';
                }
                field(condition; Rec."Asset Condition")
                {
                    Caption = 'IT Asset Condition';
                }
                field(status; Rec."Asset Status")
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
                field(blocked; Rec."Blocked")
                {
                    Caption = 'IT Asset Blocked';
                }
            }
        }
    }
}