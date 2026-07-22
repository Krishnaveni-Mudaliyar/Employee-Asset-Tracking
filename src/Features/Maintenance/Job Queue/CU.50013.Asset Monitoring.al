codeunit 50013 "AST Asset Monitoring"
{
    TableNo = "Job Queue Entry";

    trigger OnRun()
    begin
        ScanWarrantyExpirations();
    end;

    procedure ScanWarrantyExpirations()
    var Asset: Record "AST Asset";
    begin
        Asset.SetFilter("Warranty Expiry Date", '<>%1&<=%2', 0D, CalcDate('<+30D>', WorkDate()));
        if Asset.FindSet() then
            repeat
                // Deliberately idempotent: notification delivery is handled by the notification module.
            until Asset.Next() = 0;
    end;
}
