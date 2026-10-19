page 50230 "Asset Stocktake Subpage"
{
    ApplicationArea = All;
    Caption = 'Asset Stocktake Subpage';
    PageType = ListPart;
    SourceTable = "Asset Stocktake Header";

    layout
    {
        area(Content)
        {
            repeater(Lines)
            {
                field("Asset No."; Rec."Asset No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the asset to count.';
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the asset description.';
                }
                field("Expected Employee No."; Rec."Expected Employee No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the employee the asset is assigned to.';
                }
                field("Expected Location Code"; Rec."Expected Location Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the location the asset is expected to be in.';
                }
                field(Counted; Rec.Counted)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies that the asset was physically found.';
                }
                field("Counted Location Code"; Rec."Counted Location Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the location where the asset was found.';
                }
                field(Result; Rec.Result)
                {
                    ApplicationArea = All;
                    StyleExpr = ResultStyle;
                    ToolTip = 'Specifies the stocktake result for this asset.';
                }
                field(Remarks; Rec.Remarks)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies remarks about this asset.';
                }
            }
        }
    }

    var
        ResultStyle: Text;

    trigger OnAfterGetRecord()
    begin
        case Rec.Result of
            Rec.Result::Missing:
                ResultStyle := 'Unfavorable';
            Rec.Result::Mismatch:
                ResultStyle := 'Ambiguous';
            Rec.Result::Found:
                ResultStyle := 'Favorable';
            else
                ResultStyle := 'Standard';
        end;
    end;
}