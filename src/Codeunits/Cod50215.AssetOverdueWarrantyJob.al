codeunit 50222 "Asset Overdue Warranty Job"
{
    // Run from a Job Queue Entry (daily). Raises notifications for overdue returns
    // and for warranties ending within the lead days set in Asset Setup.

    trigger OnRun()
    var
        AssetSetup: Record "Asset Setup";
    begin
        AssetSetup := GetSetup();

        ProcessOverdueReturns(AssetSetup);
        ProcessWarrantyExpiry(AssetSetup);
    end;

    local procedure GetSetup() AssetSetup: Record "Asset Setup"
    begin
        if not AssetSetup.Get() then
            AssetSetup."Warranty Alert Lead Days" := 30;
    end;

    local procedure ProcessOverdueReturns(AssetSetup: Record "Asset Setup")
    var
        AssetAssignment: Record "Asset Assignment";
        AssetRequestHeader: Record "Asset Request Header";
        RecipientUserId: Code[50];
        RelatedNo: Code[20];
    begin
        AssetAssignment.SetRange(Active, true);
        AssetAssignment.SetFilter("Expected Return Date", '<>%1&<%2', 0D, Today());

        if not AssetAssignment.FindSet() then
            exit;

        repeat
            RecipientUserId := AssetSetup."Alert Recipient User ID";
            RelatedNo := AssetAssignment."Asset No.";

            if AssetAssignment."Document No." <> '' then
                if AssetRequestHeader.Get(AssetAssignment."Document No.") then begin
                    RelatedNo := AssetRequestHeader."No.";
                    if AssetRequestHeader."Requested By" <> '' then
                        RecipientUserId := AssetRequestHeader."Requested By";
                end;

            NotifyOncePerDay(
                RecipientUserId,
                StrSubstNo(
                    'Asset %1 assigned to employee %2 is overdue for return (expected %3).',
                    AssetAssignment."Asset No.", AssetAssignment."Employee No.", AssetAssignment."Expected Return Date"),
                RelatedNo);
        until AssetAssignment.Next() = 0;
    end;

    local procedure ProcessWarrantyExpiry(AssetSetup: Record "Asset Setup")
    var
        FixedAsset: Record "Fixed Asset";
    begin
        if AssetSetup."Alert Recipient User ID" = '' then
            exit;

        FixedAsset.SetRange(Blocked, false);
        FixedAsset.SetRange("Warranty End Date", Today(), Today() + AssetSetup."Warranty Alert Lead Days");

        if not FixedAsset.FindSet() then
            exit;

        repeat
            NotifyOncePerDay(
                AssetSetup."Alert Recipient User ID",
                StrSubstNo('Warranty for asset %1 ends on %2.', FixedAsset."No.", FixedAsset."Warranty End Date"),
                FixedAsset."No.");
        until FixedAsset.Next() = 0;
    end;

    local procedure NotifyOncePerDay(RecipientUserId: Code[50]; NotificationMessage: Text; RelatedNo: Code[20])
    var
        AssetNotification: Record "Asset Notification";
        AssetNotificationManagement: Codeunit "Asset Notification Management";
    begin
        if RecipientUserId = '' then
            exit;

        AssetNotification.SetRange("Recipient User ID", RecipientUserId);
        AssetNotification.SetRange(Message, CopyStr(NotificationMessage, 1, MaxStrLen(AssetNotification.Message)));
        AssetNotification.SetFilter("Created Date-Time", '>=%1', CreateDateTime(Today(), 0T));

        if not AssetNotification.IsEmpty() then
            exit;

        AssetNotificationManagement.Notify(
            RecipientUserId, CopyStr(NotificationMessage, 1, 250), RelatedNo);
    end;
}