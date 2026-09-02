page 50228 "Asset Notifications"
{
    ApplicationArea = All;
    Caption = 'Asset Notifications';
    PageType = List;
    SourceTable = "Asset Notification";
    UsageCategory = Lists;
    Editable = false;

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field(Message; Rec.Message)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Message field.', Comment = '%';
                }
                field("Related Document No."; Rec."Related Document No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Related Document No. field.', Comment = '%';
                }
                field("Created Date-Time"; Rec."Created Date-Time")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Created Date-Time field.', Comment = '%';
                }
                field(Read; Rec.Read)
                {
                    ApplicationArea = All;
                    Editable = true;
                    ToolTip = 'Specifies whether this notification has been read.', Comment = '%';
                }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(MarkAllAsRead)
            {
                ApplicationArea = All;
                Caption = 'Mark All as Read';
                Image = Approve;
                ToolTip = 'Marks every notification in the current view as read.';

                trigger OnAction()
                begin
                    if Rec.FindSet(true) then
                        repeat
                            Rec.Read := true;
                            Rec.Modify(true);
                        until Rec.Next() = 0;

                    CurrPage.Update(false);
                end;
            }
        }
    }

    trigger OnOpenPage()
    begin
        Rec.SetRange("Recipient User ID", UserId());
        Rec.SetCurrentKey("Recipient User ID", Read);
        Rec.SetAscending(Read, true);
    end;
}