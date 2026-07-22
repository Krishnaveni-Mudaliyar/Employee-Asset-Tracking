page 50006 "AST Assign Asset Dialog"
{
    PageType = StandardDialog;
    Caption = 'Assign Asset';

    layout
    {
        area(content)
        {
            group(AssetInfo)
            {
                Caption = 'Asset Information';
                field(AssetNo; AssetNo_Var)
                {
                    ApplicationArea = All;
                    Caption = 'Asset No.';
                    Editable = false;
                }
                field(AssetDesc; AssetDesc_Var)
                {
                    ApplicationArea = All;
                    Caption = 'Description';
                    Editable = false;
                }
            }
            group(Assignment)
            {
                Caption = 'Assign To';
                field(EmployeeNo; EmployeeNo_Var)
                {
                    ApplicationArea = All;
                    Caption = 'Employee No.';
                    ToolTip = 'Employee No. must be filled';
                    TableRelation = Employee;
                    trigger OnValidate()
                    begin
                        ValidateEmployee(EmployeeNo_Var);
                    end;
                }
                field(EmployeeName; EmployeeName_Var)
                {
                    ApplicationArea = All;
                    Caption = 'Employee Name';
                    Editable = false;
                }
                field(AssignmentNotes; AssignmentNotes_Var)
                {
                    ApplicationArea = All;
                    Caption = 'Notes';
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            action(Assign)
            {
                ApplicationArea = All;
                Caption = 'Assign';
                InFooterBar = true;
                trigger OnAction()
                begin
                    ProcessAssignment();
                end;
            }
        }
    }

    procedure SetAsset(ASTAsset: Record "AST Asset")
    begin
        AssetNo_Var := ASTAsset."No.";
        AssetDesc_Var := ASTAsset.Description;
    end;

    local procedure ProcessAssignment()
    var
        ASTAsset: Record "AST Asset";
        ASTAssignment: Record "AST Assignment";
        AssetAssignmentMgt: Codeunit "AST Asset Assignment";
    begin
        if EmployeeNo_Var = '' then
            Error('Employee must be selected.');

        ASTAsset.Get(AssetNo_Var);

        if ASTAsset.Status <> ASTAsset.Status::Available then
            Error('Asset %1 is not available. Current status: %2', AssetNo_Var, ASTAsset.Status);

        if ASTAsset."Maintenance Status" = ASTAsset."Maintenance Status"::"In Maintenance" then Error('Asset %1 is in maintenance and cannot be assigned.', AssetNo_Var);

        if not Confirm('Assign asset %1 to employee %2?\', true, AssetNo_Var, EmployeeName_Var)
        then
            exit;

        AssetAssignmentMgt.AssignAsset(ASTAsset, EmployeeNo_Var, AssignmentNotes_Var);
        Message('Asset %1 assigned successfully to employee %2', AssetNo_Var, EmployeeNo_Var);
    end;

    local procedure ValidateEmployee(EmployeeNo: Code[20])
    var
        Employee: Record Employee;
    begin
        if Employee.Get(EmployeeNo) then
            EmployeeName_Var := Employee.FullName();
    end;

    var
        AssetNo_Var, EmployeeNo_Var : Code[20];
        AssetDesc_Var, EmployeeName_Var : Text[100];
        AssignmentNotes_Var: Text[250];
}