permissionset 50202 "AST-USER"
{
    Assignable = true;
    Caption = 'Asset Tracking - Employee Self-Service';

    Permissions =
        // Master data — read only, employees don't manage categories/brands/setup
        tabledata "Asset Setup" = R,
        tabledata "Asset Category" = R,
        tabledata "Asset Sub Category" = R,
        tabledata "Asset Brand" = R,
        tabledata Asset = R,

        // Own requests — full rights to create/edit/send/cancel their own requests
        tabledata "Asset Request Header" = RIMD,
        tabledata "Asset Request Line" = RIMD,

        // Assignment/return/transfer/maintenance/disposal history — read only;
        // the actual state-changing actions (Assign/Return/Transfer/Send to
        // Maintenance/Dispose) are intended for AST-ADMIN, not self-service.
        tabledata "Asset Assignment" = R,
        tabledata "Asset Return" = R,
        tabledata "Asset Transfer" = R,
        tabledata "Asset Maintenance" = R,
        tabledata "Asset Disposal" = R,

        // Codeunits needed to send/cancel their own approval request
        codeunit "Asset Setup Management" = X,
        codeunit "Asset Request Management" = X,
        codeunit "Asset Request Workflow Respons" = X,
        codeunit "Asset Request Approval Mgmt." = X,
        codeunit "Asset Request Workflow Events" = X,
        codeunit "Asset Request Approval Events" = X,

        // Pages
        page "Asset Card" = X,
        page "Asset List" = X,
        page "Asset Request Card" = X,
        page "Asset Request Subpage" = X,
        page "Asset Request List" = X,
        page "Asset Assignment List" = X,
        page "Asset Assignment Hist. FactBox" = X,
        page "Emp. Active Asset Assgn." = X,

        // Page extension — so the Assigned Assets factbox renders on their Employee Card
        pageextension "Employee Card Ext." = X;
}