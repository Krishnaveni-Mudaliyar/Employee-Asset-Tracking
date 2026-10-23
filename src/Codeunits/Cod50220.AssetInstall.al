codeunit 50220 "Asset Install"
{
    Subtype = Install;

    trigger OnInstallAppPerCompany()
    var
        AssetSetup: Record "Asset Setup";
    begin
        if not AssetSetup.Get() then begin
            AssetSetup.Init();
            AssetSetup.Insert();
        end;
        InitNoSeries(AssetSetup);
        AssetSetup.Modify();
    end;

    procedure InitNoSeries(var AssetSetup: Record "Asset Setup")
    begin
        if AssetSetup."Asset Nos." = '' then
            AssetSetup."Asset Nos." := CreateSeries('AST', 'Assets', 'AST0001');
        if AssetSetup."Asset Request Nos." = '' then
            AssetSetup."Asset Request Nos." := CreateSeries('ASTREQ', 'Asset Requests', 'REQ0001');
        if AssetSetup."Assignment Nos." = '' then
            AssetSetup."Assignment Nos." := CreateSeries('ASTASG', 'Asset Assignments', 'ASG0001');
        if AssetSetup."Return Nos." = '' then
            AssetSetup."Return Nos." := CreateSeries('ASTRET', 'Asset Returns', 'RET0001');
        if AssetSetup."Transfer Nos." = '' then
            AssetSetup."Transfer Nos." := CreateSeries('ASTTRF', 'Asset Transfers', 'TRF0001');
        if AssetSetup."Maintenance Nos." = '' then
            AssetSetup."Maintenance Nos." := CreateSeries('ASTMNT', 'Asset Maintenance', 'MNT0001');
        if AssetSetup."Disposal Nos." = '' then
            AssetSetup."Disposal Nos." := CreateSeries('ASTDSP', 'Asset Disposals', 'DSP0001');
        if AssetSetup."Stocktake Nos." = '' then
            AssetSetup."Stocktake Nos." := CreateSeries('ASTSTK', 'Asset Stocktakes', 'STK0001');
    end;

    local procedure CreateSeries(SeriesCode: Code[20];
    SeriesDescription: Text[100]; StartingNo: Code[20]): Code[20]
    var
        NoSeries: Record "No. Series";
        NoSeriesLine: Record "No. Series Line";
    begin
        if not NoSeries.Get(SeriesCode) then begin
            NoSeries.Init();
            NoSeries.Code := SeriesCode;
            NoSeries.Description := SeriesDescription;
            NoSeries."Default Nos." := true;
            NoSeries.Insert();

            NoSeriesLine.Init();
            NoSeriesLine."Series Code" := SeriesCode;
            NoSeriesLine."Line No." := 10000;
            NoSeriesLine."Starting No." := StartingNo;
            NoSeriesLine."Increment-by No." := 1;
            NoSeriesLine.Insert(true);
        end;
        exit(SeriesCode);
    end;
}