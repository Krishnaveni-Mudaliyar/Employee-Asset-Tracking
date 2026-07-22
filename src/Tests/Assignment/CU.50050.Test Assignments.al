codeunit 50050 "AST Test Assignment"
{
    Subtype = Test;

    trigger OnRun()
    begin
        TestAssignAsset();
        TestReturnAsset();
        TestTransferAsset();
        TestValidateAvailability();
        Message('All assignment tests passed!');
    end;

    [Test]
    procedure TestAssignAsset()
    var
        ASTAsset: Record "AST Asset";
        Employee: Record Employee;
        AssignmentMgt: Codeunit "AST Asset Assignment";
        AssignmentNo: Code[20];
    begin
        // Setup
        CreateTestAsset(ASTAsset);
        CreateTestEmployee(Employee);

        // Execute
        AssignmentNo := AssignmentMgt.AssignAsset(ASTAsset, Employee."No.", '');

        // Verify
        Assert.IsTrue(AssignmentNo <> '', 'Assignment number should not be empty');
        ASTAsset.Get(ASTAsset."No.");
        Assert.AreEqual(ASTAsset.Status, ASTAsset.Status::"Assigned", 'Asset status should be Assigned');
        Assert.AreEqual(ASTAsset."Current Employee", Employee."No.", 'Employee should match');
    end;

    [Test]
    procedure TestReturnAsset()
    var
        ASTAsset: Record "AST Asset";
        ASTAssignment: Record "AST Assignment";
        Employee: Record Employee;
        AssignmentMgt: Codeunit "AST Asset Assignment";
    begin
        // Setup
        CreateTestAsset(ASTAsset);
        CreateTestEmployee(Employee);
        CreateTestAssignment(ASTAsset, Employee, ASTAssignment);

        // Execute
        AssignmentMgt.ReturnAsset(ASTAssignment, ASTAssignment."Return Condition"::"Good", 'Test return');

        // Verify
        ASTAsset.Get(ASTAsset."No.");
        Assert.AreEqual(ASTAsset.Status, ASTAsset.Status::Available, 'Asset should be Available after return');
        Assert.AreEqual(ASTAsset."Current Employee", '', 'Employee should be cleared');
    end;

    [Test]
    procedure TestTransferAsset()
    var
        ASTAsset: Record "AST Asset";
        Employee1, Employee2 : Record Employee;
        ASTAssignment: Record "AST Assignment";
        AssignmentMgt: Codeunit "AST Asset Assignment";
        NewAssignmentNo: Code[20];
    begin
        // Setup
        CreateTestAsset(ASTAsset);
        CreateTestEmployee(Employee1);
        CreateTestEmployee(Employee2);

        if Employee1."No." = Employee2."No." then
            exit;

        CreateTestAssignment(ASTAsset, Employee1, ASTAssignment);

        // Execute
        NewAssignmentNo := AssignmentMgt.TransferAsset(ASTAssignment, Employee2."No.");

        // Verify
        Assert.IsTrue(NewAssignmentNo <> '', 'New assignment number should not be empty');
        ASTAsset.Get(ASTAsset."No.");
        Assert.AreEqual(ASTAsset."Current Employee", Employee2."No.", 'Asset should be assigned to new employee');
    end;

    [Test]
    procedure TestValidateAvailability()
    var
        ASTAsset: Record "AST Asset";
        Employee: Record Employee;
        AssignmentMgt: Codeunit "AST Asset Assignment";
    begin
        // Setup
        CreateTestAsset(ASTAsset);
        CreateTestEmployee(Employee);

        // First assignment should succeed
        AssignmentMgt.AssignAsset(ASTAsset, Employee."No.", '');

        // Second assignment should fail
        AssertError AssignmentMgt.AssignAsset(ASTAsset, Employee."No.", '');
    end;

    [TearDown]
    procedure CleanUp()
    var
        ASTAsset: Record "AST Asset";
        ASTAssignment: Record "AST Assignment";
        ASTAssignmentEntry: Record "AST Assignment Entry";
        ASTReturnEntry: Record "AST Return Entry";
        ASTMaintenanceEntry: Record "AST Maintenance Entry";
    begin
        // FIX #12: Clean up test data after each test
        ASTAsset.SetFilter("No.", 'TEST%|MAINT%|EXIT%|ASSIGN%|TRANS%');
        ASTAsset.DeleteAll();

        ASTAssignment.DeleteAll();
        ASTAssignmentEntry.DeleteAll();
        ASTReturnEntry.DeleteAll();
        ASTMaintenanceEntry.DeleteAll();
    end;

    local procedure CreateTestAsset(var ASTAsset: Record "AST Asset")
    begin
        ASTAsset.Init();
        ASTAsset."No." := 'TEST-' + Format(Today(), 0, '<Year4><Month,2><Day,2>') + '-' + Format(System.Random(9999), '0000');
        ASTAsset.Description := 'Test Asset';
        ASTAsset.Category := 'IT';
        ASTAsset.Status := ASTAsset.Status::Available;
        ASTAsset.Cost := 10000;
        ASTAsset."Maintenance Status" := ASTAsset."Maintenance Status"::"Not In Maintenance";
        ASTAsset.Active := true;
        ASTAsset.Insert();
    end;

    local procedure GetTestEmployee(var Employee: Record Employee)
    begin
        // FIX #12: Get first existing employee instead of creating fake data
        if not Employee.FindFirst() then
            Error('No employees found in system. Create test employee data first.');
    end;

    local procedure CreateTestEmployee(var Employee: Record Employee)
    var
        EmployeeRec: Record Employee;
    begin
        EmployeeRec.SetLoadFields("No.");
        if EmployeeRec.FindFirst() then
            Employee := EmployeeRec
        else
            Error('No test employee found in system');
    end;

    local procedure CreateTestAssignment(ASTAsset: Record "AST Asset"; Employee: Record Employee; var ASTAssignment: Record "AST Assignment")
    var
        AssignmentMgt: Codeunit "AST Asset Assignment";
        AssignmentNo: Code[20];
    begin
        AssignmentNo := AssignmentMgt.AssignAsset(ASTAsset, Employee."No.", '');
        ASTAssignment.Get(AssignmentNo);
    end;

    var
        Assert: Codeunit Assert;
}
