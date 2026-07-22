query 50003 "AST Asset Status Summary"
{
    QueryType = API;
    APIPublisher = 'krishnavenimudaliyar';
    APIGroup = 'assetTracking';
    APIVersion = 'v1.0';
    EntityName = 'assetStatusSummary';
    EntitySetName = 'assetStatusSummary';
    Caption = 'Asset Status Summary';

    elements
    {
        dataitem(ASTAsset; "AST Asset")
        {
            column(Status; Status) { }
            column(MaintenanceStatus; "Maintenance Status") { }
            column(Category; Category) { }
            column(count; 1) 
            {
                Method = Count; 
            }
            column(TotalCost; Cost) 
            {
                 Method = Sum; 
            }
        }
    }
}