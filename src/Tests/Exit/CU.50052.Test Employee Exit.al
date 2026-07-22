codeunit 50052 "AST Test Employee Exit"
{
    Subtype = Test;

    [Test]
    procedure TestEmployeeWithPendingAssets()
    var
        ASTAsset: Record "AST Asset";
        Employee: Record Employee;
        ASTAssignment: Record "AST Assignment";
        ExitValidationMgt: Codeunit "AST Employee Exit Validation";
        AssignmentMgt: Codeunit "AST Asset Assignment";
    begin
        // Setup
        CreateTestAsset(ASTAsset);
        GetTestEmployee(Employee);
        AssignmentMgt.AssignAsset(ASTAsset, Employee."No.", '');

        // Execute & Verify
        Assert.IsFalse(ExitValidationMgt.ValidateEmployeeExit(Employee."No."), 'Employee exit should be blocked with pending assets');
    end;

    [Test]
    procedure TestEmployeeWithoutPendingAssets()
    var
        ExitValidationMgt: Codeunit "AST Employee Exit Validation";
        Employee: Record Employee;
    begin
        // Setup
        GetTestEmployee(Employee);

        // Execute & Verify
        Assert.IsTrue(ExitValidationMgt.ValidateEmployeeExit(Employee."No."), 'Employee exit should be allowed without pending assets');
    end;

    [Test]
    procedure TestEmployeeWithAssetsInMaintenance()
    var
        ASTAsset: Record "AST Asset";
        Employee: Record Employee;
        ExitValidationMgt: Codeunit "AST Employee Exit Validation";
        MaintenanceMgt: Codeunit "AST Maintenance Management";
    begin
        // Setup
        CreateTestAsset(ASTAsset);
        GetTestEmployee(Employee);

        // Assign asset to employee
        ASTAsset.Status := ASTAsset.Status::"Assigned";
        ASTAsset."Current Employee" := Employee."No.";
        ASTAsset.Modify();

        // Start maintenance
        MaintenanceMgt.StartMaintenance(ASTAsset."No.", 'Test Maintenance');

        // Execute & Verify (FIX #5: Now should check maintenance status)
        Assert.IsFalse(ExitValidationMgt.ValidateEmployeeExit(Employee."No."), 'Employee exit should be blocked with assets in maintenance');
    end;

    [TearDown]
    procedure CleanUp()
    var
        ASTAsset: Record "AST Asset";
        ASTAssignment: Record "AST Assignment";
        ASTAssignmentEntry: Record "AST Assignment Entry";
        ASTMaintenanceEntry: Record "AST Maintenance Entry";
    begin
        // FIX #12: Clean up test data
        ASTAsset.SetFilter("No.", 'EXIT%');
        ASTAsset.DeleteAll();

        ASTAssignment.DeleteAll();
        ASTAssignmentEntry.DeleteAll();
        ASTMaintenanceEntry.DeleteAll();
    end;

    local procedure CreateTestAsset(var ASTAsset: Record "AST Asset")
    begin
        ASTAsset.Init();
        ASTAsset."No." := 'EXIT-' + Format(Today(), 0, '<Year4><Month,2><Day,2>') + '-' + Format(System.Random(9999), '0000');
        ASTAsset.Description := 'Test Asset';
        ASTAsset.Status := ASTAsset.Status::Available;
        ASTAsset.Active := true;
        ASTAsset."Maintenance Status" := ASTAsset."Maintenance Status"::"Not In Maintenance";
        ASTAsset.Insert();
    end;

    local procedure GetTestEmployee(var Employee: Record Employee)
    begin
        if not Employee.FindFirst() then
            Error('No employee found in system. Create test employee data first.');
    end;

    var
        Assert: Codeunit Assert;
}
