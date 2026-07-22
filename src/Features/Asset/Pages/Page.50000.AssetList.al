page 50000 "AST Asset List"
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = "AST Asset";
    Caption = 'Assets';
    CardPageId = "AST Asset Card";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("No."; Rec."No.")
                {
                    ToolTip = 'Asset number';
                }
                field(Description; Rec.Description)
                {
                    ToolTip = 'Description';
                }
                field(Category; Rec.Category)
                {
                    ToolTip = 'Category';
                }
                field(Status; Rec.Status)
                {
                    ToolTip = 'Status';
                }
                field("Current Employee"; Rec."Current Employee")
                {
                    ToolTip = 'Current Employee';
                }
                field(Cost; Rec.Cost)
                {
                    ToolTip = 'Cost';
                }
                field("Warranty Expiry Date"; Rec."Warranty Expiry Date")
                {
                    ToolTip = 'Warranty Expiry Date';
                }
            }
        }
        area(factboxes)
        {
            part(AssetStatistics; "AST Asset Statistics FactBox")
            {
                SubPageLink = "No." = FIELD("No.");
            }
        }
    }

    actions
    {
        area(processing)
        {
            action(AssignAsset)
            {
                ApplicationArea = All;
                Caption = 'Assign Asset';
                Image = AssemblyBOM;
                trigger OnAction()
                begin
                    OpenAssignDialog();
                end;
            }
        }
    }

    local procedure OpenAssignDialog()
    var
        AssetAssignmentMgt: Codeunit "AST Asset Assignment";
        AssignmentDialog: Page "AST Assign Asset Dialog";
    begin
        AssignmentDialog.SetAsset(Rec);
        if AssignmentDialog.RunModal() = Action::OK then
            CurrPage.Update(false);
    end;
}