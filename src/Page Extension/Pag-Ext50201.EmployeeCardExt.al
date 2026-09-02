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
}