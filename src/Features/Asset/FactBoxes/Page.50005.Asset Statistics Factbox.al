page 50005 "AST Asset Statistics FactBox"
{
    PageType = CardPart;
    SourceTable = "AST Asset";

    layout
    {
        area(content)
        {
            group(Statistics)
            {
                field("Current Status"; Rec.Status)
                {
                    ApplicationArea = all;
                    Caption = 'Status';
                }
                field("Employee"; Rec."Current Employee")
                {
                    ApplicationArea = all;
                    Caption = 'Assigned To';
                }
                field("Maintenance Status"; Rec."Maintenance Status")
                {
                    ApplicationArea = all;
                    Caption = 'Maintenance';
                }
                field("Days Since Maintenance"; GetDaysSinceMaintenance())
                {
                    ApplicationArea = all;
                    Caption = 'Days Since Maintenance';
                }
            }
        }
    }

    local procedure GetDaysSinceMaintenance(): Integer
    var
        DaysSince: Integer;
    begin
        if Rec."Last Maintenance Date" = 0D then
            exit(0);
        DaysSince := Today() - Rec."Last Maintenance Date";
        exit(DaysSince);
    end;
}