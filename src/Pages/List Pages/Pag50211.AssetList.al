page 50211 "Asset List"
{
    ApplicationArea = All;
    Caption = 'Assets';
    PageType = List;
    SourceTable = Asset;
    UsageCategory = Lists;
    CardPageId = "Asset Card";

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("No."; Rec."No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the No. field.', Comment = '%';
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Description field.', Comment = '%';
                }
                field("Category Code"; Rec."Category Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Category Code field.', Comment = '%';
                }
                field("Sub Category Code"; Rec."Sub Category Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Sub Category Code field.', Comment = '%';
                }
                field("Brand Code"; Rec."Brand Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Brand Code field.', Comment = '%';
                }
                field("Model No."; Rec."Model No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Model No. field.', Comment = '%';
                }
                field("Serial No."; Rec."Serial No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Serial No. field.', Comment = '%';
                }
                field("Asset Tag No."; Rec."Asset Tag No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Asset Tag No. field.', Comment = '%';
                }
                field(Status; Rec.Status)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Status field.', Comment = '%';
                }
                field(Condition; Rec.Condition)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Condition field.', Comment = '%';
                }
                field("Location Code"; Rec."Location Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Location Code field.', Comment = '%';
                }
                field(Blocked; Rec.Blocked)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Blocked field.', Comment = '%';
                }
            }
        }
    }
}