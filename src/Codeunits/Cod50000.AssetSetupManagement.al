codeunit 50000 "Asset Setup Management"
{
    procedure GetSetup(): Record "Asset Setup"
    var
        AssetSetup: Record "Asset Setup";
    begin
        if not AssetSetup.Get('') then begin
            AssetSetup.Init();
            AssetSetup."Primary Key" := '';
            AssetSetup.Insert();
        end;
        exit(AssetSetup);
    end;
}