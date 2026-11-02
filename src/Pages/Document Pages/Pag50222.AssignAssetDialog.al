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
                TableRelation = "Fixed Asset"."No." where("Asset Status" = const(Available), "Blocked" = const(false));

                trigger OnValidate()
                var
                    Asset: Record "Fixed Asset";
                begin
                    if Rec."No." = '' then
                        exit;

                    if not Asset.Get(Rec."No.") then
                        Error('Asset %1 does not exist.', Rec."No.");
                end;
            }
            // field(ExpectedReturnDate; ExpectedReturnDate)
            // {
            //     ApplicationArea = All;
            //     Caption = 'Expected Return Date';
            //     ToolTip = 'Specifies when the asset is expected to be returned. Leave blank for an open-ended assignment.';
            // }
        }
    }

    // var
    //     ExpectedReturnDate: Date;

    procedure GetAssetNo(): Code[20]
    begin
        exit(Rec."No.");
    end;

    // procedure GetExpectedReturnDate(): Date
    // begin
    //     exit(ExpectedReturnDate);
    // end;
}