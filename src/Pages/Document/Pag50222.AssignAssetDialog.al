page 50222 "Assign Asset Dialog"
{
    PageType = StandardDialog;
    Caption = 'Assign Asset';
    SourceTable = Asset;
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
                TableRelation = Asset."No." where(Status = const(Available), Blocked = const(false));

                trigger OnValidate()
                var
                    Asset: Record Asset;
                begin
                    if Rec."No." = '' then
                        exit;

                    if not Asset.Get(Rec."No.") then
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