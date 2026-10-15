page 50224 "Transfer Asset Dialog"
{
    PageType = StandardDialog;
    Caption = 'Transfer Asset';
    SourceTable = "Asset Transfer";
    SourceTableTemporary = true;

    layout
    {
        area(Content)
        {
            field("To Employee No."; Rec."To Employee No.")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the employee the asset is being transferred to.';
            }
            field("To Location Code"; Rec."To Location Code")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the new location of the asset, if it is changing.';
            }
            field(Remarks; Rec.Remarks)
            {
                ApplicationArea = All;
                ToolTip = 'Specifies any remarks about the transfer.';
            }
        }
    }

    procedure GetToEmployeeNo(): Code[20]
    begin
        exit(Rec."To Employee No.");
    end;

    procedure GetToLocationCode(): Code[20]
    begin
        exit(Rec."To Location Code");
    end;

    procedure GetRemarks(): Text[250]
    begin
        exit(Rec.Remarks);
    end;
}