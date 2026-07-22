page 50001 "AST Assignment List"
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = "AST Assignment";
    Caption = 'Assignments';
    CardPageId = "AST Assignment Card";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Assignment No."; Rec."Assignment No.")
                {
                    ToolTip = 'Assignment No.';
                }
                field("Asset No."; Rec."Asset No.")
                {
                    ToolTip = 'Asset No.';
                }
                field("Asset Description"; Rec."Asset Description")
                {
                    ToolTip = 'Asset Description';
                }
                field("Employee No."; Rec."Employee No.")
                {
                    ToolTip = 'Employee No.';
                }
                field("Employee Name"; Rec."Employee Name")
                {
                    ToolTip = 'Employee Name';
                }
                field("Assignment Date"; Rec."Assignment Date")
                {
                    ToolTip = 'Assignment Date';
                }
                field(Status; Rec.Status)
                {
                    ToolTip = 'Status';
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            action("Return Asset")
            {
                ApplicationArea = All;
                Caption = 'Return Asset';
                Image = Return;
                trigger OnAction()
                begin
                    OpenReturnDialog();
                end;
            }
            action("Transfer Asset")
            {
                ApplicationArea = All;
                Caption = 'Transfer Asset';
                Image = Transfer;
                trigger OnAction()
                begin
                    OpenTransferDialog();
                end;
            }
        }
    }

    local procedure OpenReturnDialog()
    var
        ReturnDialog: Page "AST Return Asset Dialog";
    begin
        ReturnDialog.SetAssignment(Rec);
        if ReturnDialog.RunModal() = Action::OK then
            CurrPage.Update(false);
    end;

    local procedure OpenTransferDialog()
    var
        TransferDialog: Page "AST Transfer Asset Dialog";
    begin
        TransferDialog.SetAssignment(Rec);
        if TransferDialog.RunModal() = Action::OK then
            CurrPage.Update(false);
    end;
}