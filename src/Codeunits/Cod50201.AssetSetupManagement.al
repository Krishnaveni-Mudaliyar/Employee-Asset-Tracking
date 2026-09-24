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

    procedure GetAssetRequestNo(): Code[20]
    var
        AssetSetup: Record "Asset Setup";
        NoSeries: Codeunit "No. Series";

    begin
        AssetSetup := GetSetup();

        if AssetSetup."Asset Request Nos." = '' then
            Error(
                'Asset No. Series must be specified in Asset Setup.');

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

    procedure GetReturnNo(): Code[20]
    var
        AssetSetup: Record "Asset Setup";
        NoSeries: Codeunit "No. Series";
    begin
        AssetSetup := GetSetup();

        if AssetSetup."Return Nos." = '' then
            Error(
                'Return No. Series must be specified in Asset Setup.');
        exit(
            NoSeries.GetNextNo(
                AssetSetup."Return Nos.",
                WorkDate(),
                true));
    end;

    procedure GetTransferNo(): Code[20]
    var
        AssetSetup: Record "Asset Setup";
        NoSeries: Codeunit "No. Series";
    begin
        AssetSetup := GetSetup();

        if AssetSetup."Transfer Nos." = '' then
            Error(
                'Transfer No. Series must be specified in Asset Setup.');
        exit(
            NoSeries.GetNextNo(
                AssetSetup."Transfer Nos.",
                WorkDate(),
                true));
    end;

    procedure GetMaintenanceNo(): Code[20]
    var
        AssetSetup: Record "Asset Setup";
        NoSeries: Codeunit "No. Series";
    begin
        AssetSetup := GetSetup();

        if AssetSetup."Maintenance Nos." = '' then
            Error(
                'Maintenance No. Series must be specified in Asset Setup.');

        exit(
            NoSeries.GetNextNo(
                AssetSetup."Maintenance Nos.",
                WorkDate(),
                true));
    end;

    procedure GetDisposalNo(): Code[20]
    var
        AssetSetup: Record "Asset Setup";
        NoSeries: Codeunit "No. Series";
    begin
        AssetSetup := GetSetup();

        if AssetSetup."Disposal Nos." = '' then
            Error(
                'Disposal No. Series must be specified in Asset Setup.');

        exit(
            NoSeries.GetNextNo(
                AssetSetup."Disposal Nos.",
                WorkDate(),
                true));
    end;
}