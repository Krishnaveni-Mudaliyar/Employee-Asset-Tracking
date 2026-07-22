codeunit 50051 "AST Test Maintenance"
{
    Subtype = Test;

    [Test]
    procedure TestStartMaintenance()
    var
        ASTAsset: Record "AST Asset";
        MaintenanceMgt: Codeunit "AST Maintenance Management";
        MaintenanceNo: Code[20];
    begin
        // Setup
        CreateTestAsset(ASTAsset);

        // Execute
        MaintenanceNo := MaintenanceMgt.StartMaintenance(ASTAsset."No.", 'Test Maintenance');

        // Verify
        Assert.IsTrue(MaintenanceNo <> '', 'Maintenance number should not be empty');
        ASTAsset.Get(ASTAsset."No.");
        Assert.AreEqual(ASTAsset."Maintenance Status", ASTAsset."Maintenance Status"::"In Maintenance", 'Asset should be in maintenance');
    end;

    [Test]
    procedure TestCompleteMaintenance()
    var
        ASTAsset: Record "AST Asset";
        MaintenanceMgt: Codeunit "AST Maintenance Management";
        MaintenanceNo: Code[20];
    begin
        // Setup
        CreateTestAsset(ASTAsset);
        MaintenanceNo := MaintenanceMgt.StartMaintenance(ASTAsset."No.", 'Test');

        // Execute
        MaintenanceMgt.CompleteMaintenance(MaintenanceNo, 'Completed');

        // Verify
        ASTAsset.Get(ASTAsset."No.");
        Assert.AreEqual(ASTAsset."Maintenance Status", ASTAsset."Maintenance Status"::"Not In Maintenance", 'Asset should not be in maintenance');
    end;

    [Test]
    procedure TestCheckMaintenanceDue()
    var
        ASTAsset: Record "AST Asset";
        MaintenanceMgt: Codeunit "AST Maintenance Management";
    begin
        //setup
        CreateTestAsset(ASTAsset);
        ASTAsset."Last Maintenance Date" := Today() - 100;
        ASTAsset."Maintenance Interval Days" := 90;
        ASTAsset.Modify();

        //Execute & Verify
        Assert.IsTrue(MaintenanceMgt.CheckMaintenanceDue(ASTAsset."No."), 'Maintenance should be due');
    end;

    [TearDown]
    procedure CleanUp()
    var
        ASTAsset: Record "AST Asset";
        ASTMaintenanceEntry: Record "AST Maintenance Entry";
    begin
        ASTAsset.SetFilter("No.", 'MAINT%');
        ASTAsset.DeleteAll();

        ASTMaintenanceEntry.DeleteAll();
    end;

    local procedure CreateTestAsset(var ASTAsset: Record "AST Asset")
    begin
        ASTAsset.Init();
        ASTAsset."No." := 'MAINT-' + Format(Today(), 0, '<Year4><Month,2><Day,2>') + '-' + Format(System.Random(9999), '0000');
        ASTAsset.Description := 'Test Asset';
        ASTAsset.Status := ASTAsset.Status::Available;
        ASTAsset.Active := true;
        ASTAsset.Insert();
    end;

    var
        Assert: Codeunit Assert;
}