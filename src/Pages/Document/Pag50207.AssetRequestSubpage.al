page 50207 "Asset Request Subpage"
{
    ApplicationArea = All;
    Caption = 'Lines';
    PageType = ListPart;
    SourceTable = "Asset Request Line";
    AutoSplitKey = true;
    layout
    {
        area(Content)
        {
            repeater(Lines)
            {
                Caption = 'General';
                field("Asset Category Code"; Rec."Asset Category Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Asset Category Code field.', Comment = '%';
                }
                field("Asset Sub Category Code"; Rec."Asset Sub Category Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Asset Sub Category Code field.', Comment = '%';
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Description field.', Comment = '%';
                }
                field(Quantity; Rec.Quantity)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Quantity field.', Comment = '%';
                }
                field("Approved Quantity"; Rec."Approved Quantity")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Approved Quantity field.', Comment = '%';
                }
                field("Assigned Quantity"; Rec."Assigned Quantity")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Specifies the value of the Assigned Quantity field.', Comment = '%';
                }
                field(Status; Rec.Status)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Status field.', Comment = '%';
                }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(AssignAsset)
            {
                ApplicationArea = All;
                Caption = 'Assign Asset';
                Image = Approve;
                ToolTip = 'Assign a specific available asset to this request line.';

                trigger OnAction()
                var
                    AssetAssignmentManagement: Codeunit "Asset Assignment Management";
                    AssignAssetDialog: Page "Assign Asset Dialog";
                    AssetNo: Code[20];
                begin
                    CurrPage.SaveRecord();

                    if AssignAssetDialog.RunModal() <> Action::OK then
                        exit;

                    AssetNo := AssignAssetDialog.GetAssetNo();
                    if AssetNo = '' then
                        exit;

                    AssetAssignmentManagement.AssignAsset(Rec, AssetNo);
                    CurrPage.Update(false);
                end;
            }
        }
    }
}