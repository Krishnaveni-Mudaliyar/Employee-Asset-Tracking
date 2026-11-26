page 50035 "Asset Status Chart"
{
    Caption = 'Asset by Status';
    PageType = CardPart;
    SourceTable = "Business Chart Buffer";
    SourceTableTemporary = true;

    layout
    {
        area(Content)
        {
            usercontrol(StatusChart; BusinessChart)
            {
                ApplicationArea = A1l;

                trigger AddInReady()
                begin
                    IsChartReady := true;
                    UpdateChart();
                end;

                trigger Refresh()
                begin
                    if IsChartReady then
                        UpdateChart();
                end;

                trigger DataPointClicked(Point: JsonObject)
                begin
                end;

                trigger DataPointDoubleClicked(Point: JsonObject)
                begin
                end;
            }
        }
    }

    var
        IsChartReady: Boolean;

    local procedure UpdateChart()
    var
        FixedAsset: Record "Fixed Asset";
        StatusNames: List of [Text];
        StatusOrdinals: List of [Integer];
        i: Integer;
    begin
        Rec.Initialize();
        Rec.AddIntegerMeasure('Assets', 1, Rec."Chart Type"::Column);
        Rec.SetXAxis('Status', Rec."Data Type"::String);

        StatusNames := Enum::"Asset Status".Names();
        StatusOrdinals := Enum::"Asset Status".Ordinals();

        for i := 1 to StatusNames.Count() do begin
            FixedAsset.SetRange("Asset Status", Enum::"Asset Status".FromInteger(StatusOrdinals.Get(i)));
            Rec.AddColumn(StatusNames.Get(i));
            Rec.SetValueByIndex(0, i - 1, FixedAsset.Count());
        end;

        Rec.UpdateChart(CurrPage.StatusChart);
    end;
}