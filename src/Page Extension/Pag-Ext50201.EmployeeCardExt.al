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
            action(EmployeeAssetReport)
            {
                ApplicationArea = All;
                Caption = 'Employee Asset Report';
                Image = Report;
                ToolTip = 'Runs the employee asset report for this employee';

                trigger OnAction()
                var
                    Employee: Record Employee;

                begin
                    Employee.SetRange("No.", Rec."No.");
                    Report.Run(Report::"Employee Asset Report", true, false, Employee);
                end;
            }
            action(EmployeeAssignments)
            {
                ApplicationArea = All;
                Caption = 'Asset Assignments';
                Image = History;
                RunObject = page "Asset Assignment List";
                RunPageLink = "Employee No." = field("No.");
                ToolTip = 'Opens all asset assignments for this employee.';
            }
        }
    }
}