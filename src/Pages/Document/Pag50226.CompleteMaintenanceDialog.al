page 50226 "Complete Maintenance Dialog"
{
    PageType = StandardDialog;
    Caption = 'Complete Maintenance';
    SourceTable = "Asset Maintenance";
    SourceTableTemporary = true;

    layout
    {
        area(Content)
        {
            field(Cost; Rec.Cost)
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the final maintenance cost.';
            }
        }
    }

    procedure GetCost(): Decimal
    begin
        exit(Rec.Cost);
    end;
}