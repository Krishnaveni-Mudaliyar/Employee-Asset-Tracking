page 50229 "Asset Stocktake Card"
{
    ApplicationArea = All;
    Caption = 'Asset Stocktake';
    PageType = Document;
    SourceTable = "Asset Stocktake Header";

    layout
    {
        area(Content)
        {
            group(General)
            {
                Caption = 'General';

                field("No."; Rec."No.")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Specifies the stocktake number.';
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies a description of the stocktake.';
                }
                field("Location Code"; Rec."Location Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the location whose assets are counted.';
                }
                field("Employee No."; Rec."Employee No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the employee whose assigned assets are verified.';
                }
                field("Created Date"; Rec."Created Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies when the stocktake was created.';
                }
                field(Completed; Rec.Completed)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies whether the stocktake has been completed.';
                }
                field("Completed Date"; Rec."Completed Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies when the stocktake was completed.';
                }
            }
            part(Lines; "Asset Stocktake Subpage")
            {
                ApplicationArea = All;
                SubPageLink = "Document No." = field("No.");
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(LoadAssets)
            {
                ApplicationArea = All;
                Caption = 'Load Assets';
                Image = GetLines;
                ToolTip = 'Loads the assets to count, based on the location or employee.';

                trigger OnAction()
                var
                    AssetStocktakeManagement: Codeunit "Asset Stocktake Management";
                begin
                    Message('%1 asset(s) loaded.', AssetStocktakeManagement.LoadAssets(Rec));
                    CurrPage.Update(false);
                end;
            }
            action(CompleteStocktake)
            {
                ApplicationArea = All;
                Caption = 'Complete Stocktake';
                Image = Approve;
                ToolTip = 'Marks uncounted assets as missing and flags assets found in a different location.';

                trigger OnAction()
                var
                    AssetStocktakeManagement: Codeunit "Asset Stocktake Management";
                begin
                    AssetStocktakeManagement.CompleteStocktake(Rec);
                    CurrPage.Update(false);
                end;
            }
        }
    }
}