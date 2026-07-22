permissionset 50003 "AST Viewer"
{
    Caption = 'Asset Tracking Viewer';
    Permissions =
        table "AST Asset" = X,
        table "AST Assignment" = X,
        table "AST Assignment Entry" = X,
        table "AST Return Entry" = X,
        table "AST Maintenance Entry" = X,
        query "AST Asset Analytics" = X,
        query "AST Assignment Analytics" = X,
        query "AST Warranty Expiry Report" = X,
        page "AST Asset List" = X,
        page "AST Asset Statistics FactBox" = X,
        report "AST Asset Register" = X;
}
