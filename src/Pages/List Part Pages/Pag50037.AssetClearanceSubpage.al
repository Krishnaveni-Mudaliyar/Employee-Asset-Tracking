page 50037 "Asset Clearance Subpage"
{
    Caption = 'Lines';
    PageType = ListPart;
    SourceTable = "Asset Clearance Line";
    InsertAllowed = false;
    DeleteAllowed = false;

    layout
    {
        area(Content)
        {
            repeater(Lines)
            {
                field("Asset No."; Rec."Asset No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the asset the employee still holds.', Comment = '%';
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the description of the asset.', Comment = '%';
                }
                field("Assignment No."; Rec."Assignment No.")
                {
                    ApplicationArea = All;
                    Visible = false;
                    ToolTip = 'Specifies the assignment this line comes from.', Comment = '%';
                }
                field("Action"; Rec."Action")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies what happens to the asset: return it, transfer it to a colleague, or mark it not recovered.', Comment = '%';

                    trigger OnValidate()
                    begin
                        SetFieldEditability();
                    end;
                }
                field("Transfer to Employee No."; Rec."Transfer to Employee No.")
                {
                    ApplicationArea = All;
                    Editable = IsTransfer;
                    ToolTip = 'Specifies the colleague who takes over the asset. Only used when the action is Transfer.', Comment = '%';
                }
                field("Return Condition"; Rec."Return Condition")
                {
                    ApplicationArea = All;
                    Editable = IsReturn;
                    ToolTip = 'Specifies the condition of the asset when it is returned. Only used when the action is Return.', Comment = '%';
                }
                field(Remarks; Rec.Remarks)
                {
                    ApplicationArea = All;

                    ToolTip = 'Specifies a note about this asset, for example why it could not be recovered.', Comment = '%';
                }
                field("Resolved Date"; Rec."Resolved Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the date this line was resolved.', Comment = '%';
                }
            }
        }
    }
    trigger OnAfterGetRecord()
    begin
        SetFieldEditability();
    end;

    var
        IsTransfer: Boolean;
        IsReturn: Boolean;

    local procedure SetFieldEditability()
    begin
        IsTransfer := Rec.Action = Rec.Action::Transfer;
        IsReturn := Rec.Action = Rec.Action::Return;
    end;
}
