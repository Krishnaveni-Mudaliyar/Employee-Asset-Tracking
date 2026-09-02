page 50227 "Dispose Asset Dialog"
{
    PageType = StandardDialog;
    Caption = 'Dispose Asset';
    SourceTable = "Asset Disposal";
    SourceTableTemporary = true;

    layout
    {
        area(Content)
        {
            field(Reason; Rec.Reason)
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the reason for disposing of the asset.';
            }
        }
    }

    procedure GetReason(): Text[250]
    begin
        exit(Rec.Reason);
    end;
}