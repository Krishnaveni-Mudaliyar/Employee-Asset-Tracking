page 50000 "Asset Setup"
{
    ApplicationArea = All;
    Caption = 'Asset Setup';
    PageType = Card;
    SourceTable = "Asset Setup";
    UsageCategory = Administration;

    layout
    {
        area(Content)
        {
            group(Numbering)
            {
                Caption = 'Numbering';

                field("Asset Nos."; Rec."Asset Nos.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Asset Nos. field.', Comment = '%';
                }
                field("Asset Request Nos."; Rec."Asset Request Nos.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Asset Request Nos. field.', Comment = '%';
                }
                field("Assignment Nos."; Rec."Assignment Nos.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Assignment Nos. field.', Comment = '%';
                }
                field("Return Nos."; Rec."Return Nos.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Return Nos. field.', Comment = '%';
                }
                field("Transfer Nos."; Rec."Transfer Nos.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Transfer Nos. field.', Comment = '%';
                }
                field("Maintenance Nos."; Rec."Maintenance Nos.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Maintenance Nos. field.', Comment = '%';
                }
                field("Disposal Nos."; Rec."Disposal Nos.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Disposal Nos. field.', Comment = '%';
                }
            }
        }
    }
}