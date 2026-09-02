codeunit 50201 "Asset Setup Management"
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

    procedure GetAssetNo(): Code[20]
    var
        AssetSetup: Record "Asset Setup";
        NoSeries: Codeunit "No. Series";

    begin
        AssetSetup := GetSetup();

        if AssetSetup."Asset Nos." = '' then
            Error(
                'Asset No. Series must be specified in Asset Setup.');

        exit(NoSeries.GetNextNo(AssetSetup."Asset Nos.", WorkDate(), true));
    end;

    procedure GetAssetRequestNo(): Code[20]
    var
        AssetSetup: Record "Asset Setup";
        NoSeries: Codeunit "No. Series";

    begin
        AssetSetup := GetSetup();

        if AssetSetup."Asset Request Nos." = '' then
            Error(
                'Asset Request No. Series must be specified in Asset Setup.');

        exit(
            NoSeries.GetNextNo(
                AssetSetup."Asset Request Nos.",
                WorkDate(),
                true));
    end;

    procedure GetAssignmentNo(): Code[20]
    var
        AssetSetup: Record "Asset Setup";
        NoSeries: Codeunit "No. Series";

    begin
        AssetSetup := GetSetup();

        if AssetSetup."Assignment Nos." = '' then
            Error(
                'Assignment No. Series must be specified in Asset Setup.');

        exit(
            NoSeries.GetNextNo(
                AssetSetup."Assignment Nos.",
                WorkDate(),
                true));
    end;

    procedure GetAssignmentNo(): Code[20]
    var
        AssetSetup: Record "Asset Setup";
        NoSeries: Codeunit "No. Series";

    begin
        AssetSetup := GetSetup();

        if AssetSetup."Assignment Nos." = '' then
            Error(
                'Assignment No. Series must be specified in Asset Setup.');

        exit(
            NoSeries.GetNextNo(
                AssetSetup."Assignment Nos.",
                WorkDate(),
                true));
    end;
}