permissionset 50002 "AST User"
{
    Caption = 'Asset Tracking User';
    Permissions =
    // tables
        table "AST Asset" = X,
        table "AST Assignment" = X,
        table "AST Assignment Entry" = X,
        table "AST Return Entry" = X,
        table "AST Maintenance Entry" = X,
         table "AST Asset Category" = X,
        table "AST Audit Log" = X,

 //query
 query "AST Asset Analytics" = X,
        query "AST Assignment Analytics" = X,

        // codeunit
        codeunit "AST Employee Exit Validation" = X,
          codeunit "AST Asset Assignment" = X,
        codeunit "AST Maintenance Management" = X,

        //pages
        page "AST Asset List" = X,
        page "AST Asset Card" = X,
        page "AST Assignment List" = X,
        page "AST Assignment Card" = X,
        page "AST Asset Statistics FactBox" = X;
}