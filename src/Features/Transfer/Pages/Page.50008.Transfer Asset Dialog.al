page 50008 "AST Transfer Asset Dialog"
{
    PageType = StandardDialog;
    Caption = 'Transfer Asset';

    layout
    {
        area(content)
        {
            group(CurrentAssignment)
            {
                Caption = 'Current Assignment';
                field(AssignmentNo; AssignmentNo_Var)
                {
                    ApplicationArea = All;
                    Caption = 'Assignment No.';
                    Editable = false;
                }
                field(FromEmployee; FromEmployee_Var)
                {
                    ApplicationArea = All;
                    Caption = 'From Employee';
                    Editable = false;
                }
            }
            group(NewAssignment)
            {
                Caption = 'Transfer To';
                field(ToEmployee; ToEmployee_Var)
                {
                    ApplicationArea = All;
                    Caption = 'New Employee No.';
                    TableRelation = Employee;
                    trigger OnValidate()
                    begin
                        ValidateNewEmployee(ToEmployee_Var);
                    end;
                }
                field(ToEmployeeName; ToEmployeeName_Var)
                {
                    ApplicationArea = All;
                    Caption = 'Employee Name';
                    Editable = false;
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            action(Transfer)
            {
                ApplicationArea = All;
                Caption = 'Transfer';
                InFooterBar = true;
                trigger OnAction()
                begin
                    ProcessTransfer();
                end;
            }
        }
    }

    procedure SetAssignment(ASTAssignment: Record "AST Assignment")
    begin
        AssignmentNo_Var := ASTAssignment."Assignment No.";
        FromEmployee_Var := ASTAssignment."Employee No.";
    end;

    local procedure ProcessTransfer()
    var
        ASTAssignment: Record "AST Assignment";
        AssetAssignmentMgt: Codeunit "AST Asset Assignment";
    begin
        if ToEmployee_Var = '' then
            Error('New employee must be selected.');

        if ToEmployee_Var = FromEmployee_Var
        then
            Error('Cannot transfer to same employee.');

        if not Confirm('Transfer asset to employee %1?\', true, ToEmployee_Var) then
            exit;

        ASTAssignment.Get(AssignmentNo_Var);
        AssetAssignmentMgt.TransferAsset(ASTAssignment, ToEmployee_Var);
        Message('Asset transferred successfully to employee %1', ToEmployee_Var);
    end;

    local procedure ValidateNewEmployee(EmployeeNo: Code[20])
    var
        Employee: Record Employee;
    begin
        if Employee.Get(EmployeeNo) then
            ToEmployeeName_Var := Employee.FullName();
    end;

    var
        AssignmentNo_Var: Code[20];
        FromEmployee_Var: Code[20];
        ToEmployee_Var: Code[20];
        ToEmployeeName_Var: Text[100];
}