page 50223 "Return Asset Dialog"
{
    PageType = StandardDialog;
    Caption = 'Return Asset';
    SourceTable = "Asset Return";
    SourceTableTemporary = true;

    layout
    {
        area(Content)
        {
            field(Condition; Rec.Condition)
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the condition of the asset at the time it is returned.';
            }
            field(Remarks; Rec.Remarks)
            {
                ApplicationArea = All;
                ToolTip = 'Specifies any remarks about the return.';
            }
        }
    }

    procedure GetCondition(): Enum "Asset Condition"
    begin
        exit(Rec.Condition);
    end;

    procedure GetRemarks(): Text[250]
    begin
        exit(Rec.Remarks);
    end;
}