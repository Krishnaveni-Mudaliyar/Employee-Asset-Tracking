codeunit 50213 "Asset Notification Management"
{
    procedure Notify(RecipientUserId: Code[50]; NotificationMessage: Text[250]; RelatedDocumentNo: Code[20])
    var
        AssetNotification: Record "Asset Notification";
    begin
        if RecipientUserId = '' then
            exit;

        AssetNotification.Init();
        AssetNotification."Recipient User ID" := RecipientUserId;
        AssetNotification.Message := NotificationMessage;
        AssetNotification."Related Document No." := RelatedDocumentNo;
        AssetNotification.Insert(true);
    end;

    procedure GetUnreadCount(UserId: Code[50]): Integer
    var
        AssetNotification: Record "Asset Notification";
    begin
        AssetNotification.SetRange("Recipient User ID", UserId);
        AssetNotification.SetRange(Read, false);
        exit(AssetNotification.Count());
    end;
}