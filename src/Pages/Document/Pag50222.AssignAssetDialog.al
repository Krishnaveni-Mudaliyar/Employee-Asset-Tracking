page 50222 "Assign Asset Dialog"
{
    PageType = StandardDialog;
    Caption = 'Assign Asset';
    SourceTable = "Fixed Asset";
    SourceTableTemporary = true;

    layout
    {
        area(Content)
        {
            field("No."; Rec."No.")
            {
                ApplicationArea = All;
                Caption = 'Asset No.';
                ToolTip = 'Specifies the available asset to assign.';
                TableRelation = "Fixed Asset"."No." where("IT Asset Status" = const(Available), "IT Asset Blocked" = const(false));

                trigger OnValidate()
                var
                    FixedAsset: Record "Fixed Asset";
                begin
                    if Rec."No." = '' then
                        exit;

                    if not FixedAsset.Get(Rec."No.") then
                        Error('Asset %1 does not exist.', Rec."No.");
                end;
            }
        }
    }

    procedure GetAssetNo(): Code[20]
    begin
        exit(Rec."No.");
    end;
}