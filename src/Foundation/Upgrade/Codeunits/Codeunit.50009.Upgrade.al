codeunit 50009 "AST Upgrade"
{
    Subtype = Upgrade;
    Access = Internal;

    trigger OnUpgradePerCompany()
    begin
        UpgradeSetupRecord();
    end;

    local procedure UpgradeSetupRecord()
    var
        UpgradeTag: Codeunit "Upgrade Tag";
        ASTModuleSetup: Codeunit "AST Module Setup";
    begin
        if UpgradeTag.HasUpgradeTag(GetSetupBackfillUpgradeTag()) then
            exit;

        ASTModuleSetup.InitializeSetup();

        UpgradeTag.SetUpgradeTag(GetSetupBackfillUpgradeTag());
    end;

    local procedure GetSetupBackfillUpgradeTag(): Code[250]
    begin
        exit('KRISHNAVENI-AST-SETUP-BACKFILL-20260721');
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Upgrade Tag Definitions", 'OnGetPerCompanyUpgradeTags', '', false, false)]
    local procedure RegisterPerCompanyTags(var PerCompanyUpgradeTags: List of [Code[250]])
    begin
        PerCompanyUpgradeTags.Add(GetSetupBackfillUpgradeTag());
    end;
}
