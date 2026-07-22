page 50003 "AST Asset Card"
{
    PageType = Card;
    ApplicationArea = All;
    SourceTable = "AST Asset";
    Caption = 'Asset Card';

    layout
    {
        area(content)
        {
            group(General)
            {
                Caption = 'General';
                field("No."; Rec."No.")
                {
                    ToolTip = 'Asset number';
                    Editable = false;
                }
                field(Description; Rec.Description)
                {
                    ToolTip = 'Description';
                }
                field(Category; Rec.Category)
                {
                    ToolTip = 'Category';
                }
                field("Serial Number"; Rec."Serial Number")
                {
                    ToolTip = 'Serial Number';
                }
                field(Cost; Rec.Cost)
                {
                    ToolTip = 'Cost';
                }
            }
            group(Statuss)
            {
                Caption = 'Status';
                field(Status; Rec.Status)
                {
                    ToolTip = 'Status';
                    Editable = false;
                }
                field("Current Employee"; Rec."Current Employee")
                {
                    ToolTip = 'Current Employee';
                    Editable = false;
                }
                field("Assignment Date"; Rec."Assignment Date")
                {
                    ToolTip = 'Assignment Date';
                    Editable = false;
                }
                field("Asset Condition"; Rec."Asset Condition")
                {
                    ToolTip = 'Asset Condition';
                }
                field(Active; Rec.Active)
                {
                    ToolTip = 'Active';
                }
            }
            group(Maintenance)
            {
                Caption = 'Maintenance';
                field("Maintenance Status"; Rec."Maintenance Status")
                {
                    ToolTip = 'Maintenance Status';
                    Editable = false;
                }
                field("Last Maintenance Date"; Rec."Last Maintenance Date")
                {
                    ToolTip = 'Last Maintenance Date';
                    Editable = false;
                }
                field("Maintenance Interval Days"; Rec."Maintenance Interval Days")
                {
                    ToolTip = 'Maintenance Interval (Days)';
                }
            }
            group(Warranty)
            {
                Caption = 'Warranty';
                field("Warranty Expiry Date"; Rec."Warranty Expiry Date")
                {
                    ToolTip = 'Warranty Expiry Date';
                }
            }
        }
        area(FactBoxes)
        {
            part(AssetStatisticsFactbox; "AST Asset Statistics FactBox")
            {
                ApplicationArea = All;
                Caption = 'Statistics';
                SubPageLink = "No." = field("No.");
            }
            part(DocAttachmentFactbox; "Document Attachment FactBox")
            {
                ApplicationArea = All;
                Caption = 'Attachments';
                SubPageLink = "Table ID" = const(Database::"AST Asset"), "No." = field("No.");
            }
        }
    }

    actions
    {
        area(processing)
        {
            action("Start Maintenance")
            {
                ApplicationArea = All;
                Caption = 'Start Maintenance';
                Image = Tools;
                trigger OnAction()
                begin
                    OpenMaintenanceDialog(true);
                end;
            }
            action("Complete Maintenance")
            {
                ApplicationArea = All;
                Caption = 'Complete Maintenance';
                Image = Completed;
                trigger OnAction()
                begin
                    OpenMaintenanceDialog(false);
                end;
            }
        }
    }

    local procedure OpenMaintenanceDialog(IsStart: Boolean)
    var
        MaintenanceMgt: Codeunit "AST Maintenance Management";
        MaintenanceDialog: Page "AST Maintenance Dialog";
    begin
        MaintenanceDialog.SetAsset(Rec, IsStart);
        if MaintenanceDialog.RunModal() = Action::OK then
            CurrPage.Update(false);
    end;
}