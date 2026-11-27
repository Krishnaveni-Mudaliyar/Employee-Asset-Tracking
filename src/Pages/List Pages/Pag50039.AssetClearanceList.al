page 50039 "Asset Clearance List"
{
    Caption = 'Asset Clearances';
    PageType = List;
    SourceTable = "Asset Clearance Header";
    CardPageId = "Asset Category Card";
    UsageCategory = Lists;
    ApplicationArea = All;
    Editable = false;

    layout
    {
        area(Content)
        {
            repeater(Clearances)
            {
                field("No."; Rec."No.")
                {
                    ToolTip = 'Specifies the number of this clearance.', Comment = '%';
                }
                field("Employee No."; Rec."Employee No.")
                {
                    ToolTip = 'Specifies the employee who is leaving.', Comment = '%';
                }
                field("Employee Name"; Rec."Employee Name")
                {
                    ToolTip = 'Specifies the name of the employee.', Comment = '%';
                }
                field("Last Working Date"; Rec."Last Working Date")
                {
                    ToolTip = 'Specifies the employee''s last working day. All assets should be resolved by this date.', Comment = '%';
                }
                field(Status; Rec.Status)
                {
                    ToolTip = 'Specifies whether the clearance is open, cleared or cancelled.', Comment = '%';
                }
                field("Open Lines"; Rec."Open Lines")
                {
                    StyleExpr = OpenLinesStyle;
                    ToolTip = 'Specifies how many assets still have no action chosen. The clearance can only be cleared when this is zero.';
                }
                field("Created Date"; Rec."Created Date")
                {
                    ToolTip = 'Specifies the value of the Created Date field.', Comment = '%';
                }
            }
        }
    }
    trigger OnAfterGetRecord()
    begin
        Rec.CalcFields("Open Lines");
        OpenLinesStyle := 'Favorable';
        if (Rec.Status = Rec.Status::Open) and (Rec."Open Lines" > 0) then
            OpenLinesStyle := 'Unfavorable';
    end;

    var
        OpenLinesStyle: Text;
}
