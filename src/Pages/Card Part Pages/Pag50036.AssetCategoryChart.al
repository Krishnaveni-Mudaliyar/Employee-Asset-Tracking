page 50036 "Asset Category Chart"
{
    Caption = 'Assets by Category';
    PageType = CardPart;
    SourceTable = "Business Chart Buffer";
    SourceTableTemporary = true;

    layout
    {
        area(Content)
        {
            usercontrol(CategoryChart; BusinessChart)
            {
                ApplicationArea = All;

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
        AssetCategory: Record "Asset Category";
        FixedAsset: Record "Fixed Asset";
        i: Integer;
    begin
        Rec.Initialize();
        Rec.AddMeasure('Assets', 1, Rec."Data Type"::Integer, Rec."Chart Type"::Column);
        Rec.SetXAxis('Category', Rec."Data Type"::String);

        AssetCategory.SetRange(Blocked, false);
        if AssetCategory.FindSet() then
            repeat
                FixedAsset.SetRange("Asset Category Code", AssetCategory.Code);
                Rec.AddColumn(AssetCategory.Description);
                Rec.SetValueByIndex(0, i, FixedAsset.Count());
                i += 1;
            until AssetCategory.Next() = 0;

        Rec.UpdateChart(CurrPage.CategoryChart);
    end;
}