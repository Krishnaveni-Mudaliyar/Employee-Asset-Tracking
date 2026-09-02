pageextension 50201 "Employee Card Ext." extends "Employee Card"
{
    layout
    {
        addlast(FactBoxes)
        {
            part(AssignedAssets; "Emp. Active Asset Assgn.")
            {
                ApplicationArea = All;
                Caption = 'Assigned Assets';
                SubPageLink = "Employee No." = field("No.");
            }
        }
    }
    actions
    {
        addlast(Processing)
        {
            action(RequestAsset)
            {
                ApplicationArea = All;
                Caption = 'Request Asset';
                Image = NewDocument;
                ToolTip = 'Create a new asset request for this employee.';

                trigger OnAction()
                var
                    AssetRequestHeader: Record "Asset Request Header";
                begin
                    AssetRequestHeader.Init();
                    AssetRequestHeader.Validate("Employee No.", Rec."No.");
                    AssetRequestHeader.Insert(true);

                    PAGE.Run(PAGE::"Asset Request Card", AssetRequestHeader);
                end;
            }

        }
    }
}