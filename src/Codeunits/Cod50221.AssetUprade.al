codeunit 50221 "Asset Uprade"
{
    Subtype = Upgrade;
    trigger OnUpgradePerCompany()
    var
        UpgradeTag: Codeunit "Upgrade Tag";
    begin
        if not UpgradeTag.HasUpgradeTag(StocktakeSeriesTagTok) then begin
            FillMissingNoSeries();
            UpgradeTag.SetUpgradeTag(StocktakeSeriesTagTok);
        end;
    end;

    local procedure FillMissingNoSeries()
    var
        AssetSetup: Record "Asset Setup";
        AssetInstall: Codeunit "Asset Install";
    begin
        if not AssetSetup.Get() then begin
            AssetSetup.Init();
            AssetSetup.Insert();
        end;
        AssetInstall.InitNoSeries(AssetSetup);
        AssetSetup.Modify();
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Upgrade Tag", 'OnGetPerCompanyUpgradeTags', '', false, false)]
    local procedure RegisterUpgradeTags(var PerCompanyUpgradeTags: List of [Code[250]])
    begin
        PerCompanyUpgradeTags.Add(StocktakeSeriesTagTok);
    end;

    var
        StocktakeSeriesTagTok: Label 'AST-20261023-FillMissingNoSeries', Locked = true;
}