permissionset 50000 "AST Admin"
{
    Caption = 'Asset Tracking Admin';
    Permissions =

    // Tables
        table "AST Asset" = X,
        table "AST Asset Category" = X,
        table "AST Assignment" = X,
        table "AST Assignment Entry" = X,
        table "AST Return Entry" = X,
        table "AST Maintenance Entry" = X,
        table "AST Setup" = X,
        table "AST Audit Log" = X,
        table "AST Approval Request" = X,

        // Query
        query "AST Asset Analytics" = X,
        query "AST Assignment Analytics" = X,
        query "AST Maintenance Analytics" = X,
        query "AST Asset Status Summary" = X,
        query "AST Warranty Expiry Report" = X,

        // Codeunits
        codeunit "AST Asset Assignment" = X,
        codeunit "AST Maintenance Management" = X,
        codeunit "AST Employee Exit Validation" = X,
        codeunit "AST Notification Management" = X,
        codeunit "AST Module Setup" = X,
         codeunit "AST Approval Management" = X,

    // Pages
        page "AST Asset List" = X,
        page "AST Asset Card" = X,
        page "AST Assignment List" = X,
        page "AST Assignment Card" = X,
        page "AST Asset Category List" = X,
        page "AST Assign Asset Dialog" = X,
        page "AST Return Asset Dialog" = X,
        page "AST Transfer Asset Dialog" = X,
        page "AST Maintenance Dialog" = X,
        page "AST Asset Statistics FactBox" = X,
        Page "AST Setup" = X,
        page "AST Approval Requests" = X,
        page "Role Center" = X,
        page "AST Asset API" = X,
        page "AST Assignment API" = X,
        page "AST Maintenance API" = X,

        //Report
        report "AST Asset Register" = X;
}