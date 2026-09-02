permissionset 50201 "AST-ADMIN"
{
    Assignable = true;
    Caption = 'Asset Tracking - Admin';

    Permissions =
        // Tables — full data rights
        tabledata "Asset Setup" = RIMD,
        tabledata "Asset Category" = RIMD,
        tabledata "Asset Sub Category" = RIMD,
        tabledata "Asset Brand" = RIMD,
        tabledata Asset = RIMD,
        tabledata "Asset Request Header" = RIMD,
        tabledata "Asset Request Line" = RIMD,
        tabledata "Asset Assignment" = RIMD,
        tabledata "Asset Return" = RIMD,
        tabledata "Asset Transfer" = RIMD,
        tabledata "Asset Maintenance" = RIMD,
        tabledata "Asset Disposal" = RIMD,
        tabledata "Asset Notification" = RIMD,

        // Codeunits — execute
        codeunit "Asset Setup Management" = X,
        codeunit "Asset Request Management" = X,
        codeunit "Asset Request Workflow Respons" = X,
        codeunit "Asset Request Approval Mgmt." = X,
        codeunit "Asset Request Workflow Events" = X,
        codeunit "Asset Request Approval Events" = X,
        codeunit "Asset Assignment Management" = X,
        codeunit "Asset Return Management" = X,
        codeunit "Asset Transfer Management" = X,
        codeunit "Asset Maintenance Management" = X,
        codeunit "Asset Disposal Management" = X,
        codeunit "Asset Tracking Mgt. Tests" = X,
        codeunit "Asset Notification Management" = X,

        // Pages — execute
        page "Asset Setup" = X,
        page "Asset Category Card" = X,
        page "Asset Sub Category Card" = X,
        page "Asset Brand Card" = X,
        page "Asset Card" = X,
        page "Asset Request Card" = X,
        page "Asset Request Subpage" = X,
        page "Asset Category List" = X,
        page "Asset Sub Category List" = X,
        page "Asset Brand List" = X,
        page "Asset List" = X,
        page "Asset Request List" = X,
        page "Assign Asset Dialog" = X,
        page "Asset Assignment List" = X,
        page "Return Asset Dialog" = X,
        page "Asset Return List" = X,
        page "Transfer Asset Dialog" = X,
        page "Asset Transfer List" = X,
        page "Send To Maintenance Dialog" = X,
        page "Asset Maintenance List" = X,
        page "Complete Maintenance Dialog" = X,
        page "Dispose Asset Dialog" = X,
        page "Asset Disposal List" = X,
        page "Asset Assignment Hist. FactBox" = X,
        page "Asset Maintenance Hist. FctBox" = X,
        page "Emp. Active Asset Assgn." = X,
        page "Asset Notifications" = X,

        // Reports
        report "Asset Register" = X;
}