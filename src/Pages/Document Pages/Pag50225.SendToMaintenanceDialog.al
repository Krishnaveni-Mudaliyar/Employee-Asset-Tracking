page 50225 "Send To Maintenance Dialog"
{
    PageType = StandardDialog;
    Caption = 'Send to Maintenance';
    SourceTable = "Asset Maintenance";
    SourceTableTemporary = true;

    layout
    {
        area(Content)
        {
            field("Vendor No."; Rec."Vendor No.")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the vendor performing the maintenance.';
            }
            field(Description; Rec.Description)
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the reason for maintenance.';
            }
        }
    }

    procedure GetVendorNo(): Code[20]
    begin
        exit(Rec."Vendor No.");
    end;

    procedure GetDescription(): Text[250]
    begin
        exit(Rec.Description);
    end;
}