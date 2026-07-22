query 50000 "AST Asset Analytics"
{
    QueryType = API;
    APIPublisher = 'krishnavenimudaliyar';
    APIGroup = 'assetTracking';
    APIVersion = 'v1.0';
    EntityName = 'assetAnalytics';
    EntitySetName = 'assetAnalytics';
    Caption = 'Asset Analytics';

    elements
    {
        dataitem(ASTAsset; "AST Asset")
        {
            column(No; "No.") { }
            column(Description; Description) { }
            column(Category; Category) { }
            column(Status; Status) { }
            column(CurrentEmployee; "Current Employee") { }
            column(Cost; Cost) { }
            column(WarrantyExpiryDate; "Warranty Expiry Date") { }
            column(LastMaintenanceDate; "Last Maintenance Date") { }
            column(MaintenanceStatus; "Maintenance Status") { }
            column(AssetCondition; "Asset Condition") { }
            column(Active; Active) { }
        }
    }
}
