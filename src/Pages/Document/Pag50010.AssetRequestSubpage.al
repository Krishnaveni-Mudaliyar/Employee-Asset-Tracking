page 50010 "Asset Request Subpage"
{
    ApplicationArea = All;
    Caption = 'Lines';
    PageType = ListPart;
    SourceTable = "Asset Request Line";
    AutoSplitKey = true;
    layout
    {
        area(Content)
        {
            repeater(Lines)
            {
                Caption = 'General';
                field("Asset Category Code"; Rec."Asset Category Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Asset Category Code field.', Comment = '%';
                }
                field("Asset Sub Category Code"; Rec."Asset Sub Category Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Asset Sub Category Code field.', Comment = '%';
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Description field.', Comment = '%';
                }
                field(Quantity; Rec.Quantity)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Quantity field.', Comment = '%';
                }
                field("Approved Quanity"; Rec."Approved Quanity")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Approved Quanity field.', Comment = '%';
                }
                field("Assigned Quanity"; Rec."Assigned Quanity")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Specifies the value of the Assigned Quanity field.', Comment = '%';
                }
                field(Status; Rec.Status)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Status field.', Comment = '%';
                }
            }
        }
    }
}