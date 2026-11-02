codeunit 50202 "Asset Request Management"
{
    procedure SendForApproval(var AssetRequestHeader: Record "Asset Request Header")
    var
        AssetNotificationManagement: Codeunit "Asset Notification Management";
    begin
        AssetRequestHeader.TestField("No.");
        AssetRequestHeader.TestField("Employee No.");

        if AssetRequestHeader.Status <> AssetRequestHeader.Status::Open then
            Error(
                'Asset request %1 must have open status before it can be sent for approval.',
                AssetRequestHeader."No.");

        AssetRequestHeader.OnSendAssetRequestForApproval(AssetRequestHeader);

        AssetNotificationManagement.Notify(
            AssetRequestHeader."Requested By",
            StrSubstNo('Your asset request %1 has been sent for approval.', AssetRequestHeader."No."), AssetRequestHeader."No.");
    end;
}