query 50001 "AST Assignment Analytics"
{
    QueryType = API;
    APIPublisher = 'krishnavenimudaliyar';
    APIGroup = 'assetTracking';
    APIVersion = 'v1.0';
    EntityName = 'assignmentAnalytics';
    EntitySetName = 'assignmentAnalytics';
    Caption = 'Assignment Analytics';

    elements
    {
        dataitem(ASTAssignment; "AST Assignment")
        {
            column(AssignmentNo; "Assignment No.") { }
            column(AssetNo; "Asset No.") { }
            column(EmployeeNo; "Employee No.") { }
            column(AssignmentDate; "Assignment Date") { }
            column(Status; Status) { }
        }
    }
}
