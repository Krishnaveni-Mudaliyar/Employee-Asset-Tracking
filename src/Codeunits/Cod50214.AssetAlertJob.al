codeunit 50214 "Asset Alert Job"
{
    trigger OnRun()
    begin
        NotifyOverdueReturns();
        NotifyExpiringWarranties();
    end;

    local procedure NotifyOverdueReturns()
    var
        AssetAssignment: Record "Asset Assignment";
        AssetRequestHeader: Record "Asset Request Header";

    begin
        AssetAssignment.SetRange(Active, true);
        AssetAssignment.SetFilter("Expected Return Date", '<>%1&<%2', 0D, Today());
        if AssetAssignment.FindSet() then
            repeat
                if AssetRequestHeader.Get(AssetAssignment."Document No.")
                then
                    SendOnce(
                        AssetRequestHeader."Requested By",
                        StrSubstNo(
                            'Asset %1 is overdue for return (expected %2).',
                            AssetAssignment."Asset No.",
                            AssetAssignment."Expected Return Date"),
                            AssetAssignment."Asset No.");
            until AssetAssignment.Next() = 0;
    end;

    local procedure NotifyExpiringWarranties()
    var
        AssetSetup: Record "Asset Setup";
        FixedAsset: Record "Fixed Asset";
        AlertDays: Integer;
    begin
        if not AssetSetup.Get() then
            exit;
        if AssetSetup."Warranty Alert User ID" = '' then
            exit;

        AlertDays := AssetSetup."Warranty Alert Days";
        if AlertDays = 0 then
            AlertDays := 30;

        FixedAsset.SetRange("Warranty End Date", Today(), CalcDate(StrSubstNo('<+%1D>', AlertDays), Today()));
        if FixedAsset.FindSet() then
            repeat
                SendOnce(
                    AssetSetup."Warranty Alert User ID",
                    StrSubstNo('Warranty for asset %1 expires on %2.', FixedAsset."No.", FixedAsset."Warranty End Date"),
                    FixedAsset."No.");
            until FixedAsset.Next() = 0;
    end;

    local procedure SendOnce(RecipientUserId: Code[50]; NotificationMessage: Text[250]; RelatedDocumentNo: Code[20])
    var
        AssetNotification: Record "Asset Notification";
        AssetNotificationManagement: Codeunit "Asset Notification Management";
    begin
        if RecipientUserId = '' then
            exit;

        AssetNotification.SetRange("Recipient User ID", RecipientUserId);
        AssetNotification.SetRange(Read, false);
        AssetNotification.SetRange(Message, NotificationMessage);
        AssetNotification.SetRange("Related Document No.", RelatedDocumentNo);
        if not AssetNotification.IsEmpty() then
            exit;

        AssetNotificationManagement.Notify(RecipientUserId, NotificationMessage, RelatedDocumentNo);
    end;
}