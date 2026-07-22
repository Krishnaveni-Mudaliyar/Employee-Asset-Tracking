query 50002 "AST Maintenance Analytics"
{
    QueryType = API;
    APIPublisher = 'leapingfrog';
    APIGroup = 'assetTracking';
    APIVersion = 'v1.0';
    EntityName = 'maintenanceAnalytics';
    EntitySetName = 'maintenanceAnalytics';
    Caption = 'Maintenance Analytics';

    elements
    {
        dataitem(ASTMaintenanceEntry; "AST Maintenance Entry")
        {
            column(MaintenanceNo; "Maintenance No.") { }
            column(AssetNo; "Asset No.") { }
            column(Description; Description) { }
            column(StartDate; "Start Date") { }
            column(EndDate; "End Date") { }
            column(Status; Status) { }
            column(MaintenanceDays; GetMaintenanceDays()) { }
            column(PostedBy; "Posted By") { }
        }
    }

    procedure GetMaintenanceDays(): Integer
    var
        Days: Integer;
    begin
        if ASTMaintenanceEntry."End Date" = 0D then
            Days := Today() - ASTMaintenanceEntry."Start Date"
        else
            Days := ASTMaintenanceEntry."End Date" - ASTMaintenanceEntry."Start Date";
        exit(Days);
    end;
}