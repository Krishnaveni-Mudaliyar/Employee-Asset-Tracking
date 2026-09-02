codeunit 50207 "Asset Tracking Mgt. Tests"
{
    Subtype = Test;

    var
        LibraryAssert: Codeunit "Library Assert";

    [Test]
    procedure TestNewAssetDefaultAndNumbering()
    var
        AssetSetup: Record "Asset Setup";
        Asset: Record Asset;

    begin
        // [GIVEN] Asset Setup Has an Asset Nos. series
        EnsureAssetSetup(AssetSetup);

        // [WHEN] a new Assert is inserted with a blank No.
        Asset.Init();
        Asset.Insert(true);

        // [THEN] the No. is assigned from the series
        LibraryAssert.AreNotEqual('', Asset."No.", 'Asset No. should be auto-numbered.');
    end;

    [TEST]
    procedure TestBlockedCategoryCannotBeUsedOnAsset()
    var
        AssetCategory: Record "Asset Category";
        Asset: Record Asset;

    begin
        // [GIVEN] A blocked asset category
        AssetCategory.Init();
        AssetCategory.Code := 'BLKCAT';
        AssetCategory.Blocked := true;
        AssetCategory.Insert(true);

        // [WHEN] assigning it to an Asset
        Asset.Init();
        Asset.Insert(true);

        // [THEN] validation fails
        asserterror Asset.Validate("Category Code", AssetCategory.Code);
    end;

    [TEST]
    procedure TestSerialNoMustBeUnique()
    var
        Asset1: Record Asset;
        Asset2: Record Asset;

    begin
        // [GIVEN] an asset with a Serial No.
        Asset1.Init();
        Asset1.Insert(true);
        Asset1.Validate("Serial No.", 'SN-0001');
        Asset1.Modify(true);

        // [WHEN] another asset tries to use the same Serial No.
        Asset2.Init();
        Asset2.Insert(true);

        // [THEN] validation fails
        asserterror Asset2.Validate("Serial No.", 'SN-0001');
    end;

    [Test]
    procedure TestAssetRequestLineQuantityValidation()
    var
        AssetRequestLine: Record "Asset Request Line";
    begin
        AssetRequestLine.Init();
        AssetRequestLine."Document No." := 'TESTDOC';

        // [THEN] Quantity must be greater than zero
        asserterror AssetRequestLine.Validate(Quantity, 0);

        // [WHEN] a valid quantity is set
        AssetRequestLine.Validate(Quantity, 5);

        // [THEN] Approved Quantity cannot exceed Quantity
        asserterror AssetRequestLine.Validate("Approved Quantity", 6);

        // [WHEN] a valid approved quantity is set
        AssetRequestLine.Validate("Approved Quantity", 3);

        // [THEN] Assigned Quantity cannot exceed Approved Quantity
        asserterror AssetRequestLine.Validate("Assigned Quantity", 4);
    end;

    [Test]
    procedure TestSendForApprovalRequiresOpenStatus()
    var
        AssetRequestHeader: Record "Asset Request Header";
        AssetRequestManagement: Codeunit "Asset Request Management";

    begin
        // [GIVEN] a request that is already Pending Approval
        AssetRequestHeader.Init();
        AssetRequestHeader.Insert(true);
        AssetRequestHeader."Employee No." := GetAnyEmployeeNo();
        AssetRequestHeader.Status := AssetRequestHeader.Status::"Pending Approval";
        AssetRequestHeader.Modify(true);

        // [WHEN] sending it for approval again
        // [THEN] it fails, because Status <> Open

        asserterror AssetRequestManagement.SendForApproval(AssetRequestHeader);
    end;

    [Test]
    procedure TestCancelApprovalRequestRequiresPendingStatus()
    var
        AssetRequestHeader: Record "Asset Request Header";
        AssetRequestApprovalMgmt: Codeunit "Asset Request Approval Mgmt.";

    begin
        // [GIVEN] a request that is still Open (never sent for approval)
        AssetRequestHeader.Init();
        AssetRequestHeader.Insert(true);
        AssetRequestHeader."Employee No." := GetAnyEmployeeNo();
        AssetRequestHeader.Modify(true);

        // [WHEN] trying to cancel an approval request that was never sent
        // [THEN] it fails
        asserterror AssetRequestApprovalMgmt.CancelApprovalRequest(AssetRequestHeader);
    end;

    procedure TestAssignAssetRequiresApprovedRequest()
    var
        AssetRequestHeader: Record "Asset Request Header";
        AssetRequestLine: Record "Asset Request Line";
        Asset: Record Asset;
        AssetAssignmentManagement: Codeunit "Asset Assignment Management";
    begin
        // [GIVEN] an Open (not yet Approved) request with one line
        AssetRequestHeader.Init();
        AssetRequestHeader.Insert(true);
        AssetRequestHeader."Employee No." := GetAnyEmployeeNo();
        AssetRequestHeader.Modify(true);

        AssetRequestLine.Init();
        AssetRequestLine."Document No." := AssetRequestHeader."No.";
        AssetRequestLine."Line No." := 10000;
        AssetRequestLine.Insert(true);
        AssetRequestLine.Validate(Quantity, 1);
        AssetRequestLine.Validate("Approved Quantity", 1);
        AssetRequestLine.Modify(true);

        Asset.Init();
        Asset.Insert(true);
        Asset.Modify(true);

        // [WHEN] trying to assign an asset before the request is Approved
        // [THEN] it fails
        asserterror AssetAssignmentManagement.AssignAsset(AssetRequestLine, Asset."No.");
    end;

    [Test]
    procedure TestAssignAssetSucceedsAndClosesFullyAssignedRequest()
    var
        AssetRequestHeader: Record "Asset Request Header";
        AssetRequestLine: Record "Asset Request Line";
        Asset: Record Asset;
        AssetAssignmentManagement: Codeunit "Asset Assignment Management";
    begin
        // [GIVEN] an Approved request with one line requesting/approving quantity 1
        AssetRequestHeader.Init();
        AssetRequestHeader.Insert(true);
        AssetRequestHeader."Employee No." := GetAnyEmployeeNo();
        AssetRequestHeader.Status := AssetRequestHeader.Status::Approved;
        AssetRequestHeader.Modify(true);

        AssetRequestLine.Init();
        AssetRequestLine."Document No." := AssetRequestHeader."No.";
        AssetRequestLine."Line No." := 10000;
        AssetRequestLine.Insert(true);
        AssetRequestLine.Validate(Quantity, 1);
        AssetRequestLine.Validate("Approved Quantity", 1);
        AssetRequestLine.Modify(true);

        Asset.Init();
        Asset.Insert(true);
        Asset.Modify(true);
        LibraryAssert.AreEqual(Asset.Status::Available, Asset.Status, 'New asset should default to Available.');

        // [WHEN] the asset is assigned
        AssetAssignmentManagement.AssignAsset(AssetRequestLine, Asset."No.");

        // [THEN] the asset becomes Assigned
        Asset.Get(Asset."No.");
        LibraryAssert.AreEqual(Asset.Status::Assigned, Asset.Status, 'Asset should be Assigned after assignment.');

        // [THEN] the line's Assigned Quantity reflects it
        AssetRequestLine.Get(AssetRequestLine."Document No.", AssetRequestLine."Line No.");
        LibraryAssert.AreEqual(1, AssetRequestLine."Assigned Quantity", 'Assigned Quantity should be 1.');

        // [THEN] the header auto-closes since every line is fully assigned
        AssetRequestHeader.Get(AssetRequestHeader."No.");
        LibraryAssert.AreEqual(AssetRequestHeader.Status::Closed, AssetRequestHeader.Status, 'Header should auto-close once fully assigned.');
    end;

    [Test]
    procedure TestReturnAssetRequiresAssignedStatus()
    var
        Asset: Record Asset;
        AssetReturnManagement: Codeunit "Asset Return Management";
    begin
        // [GIVEN] an Available (not Assigned) asset
        Asset.Init();
        Asset.Insert(true);
        Asset.Modify(true);

        // [WHEN] trying to return it
        // [THEN] it fails
        asserterror AssetReturnManagement.ReturnAsset(Asset."No.", Asset.Condition::Good, '');
    end;

    [Test]
    procedure TestDisposeAssetBlocksAssetAndSetsStatus()
    var
        Asset: Record Asset;
        AssetDisposalManagement: Codeunit "Asset Disposal Management";
    begin
        // [GIVEN] an Available asset
        Asset.Init();
        Asset.Insert(true);
        Asset.Modify(true);

        // [WHEN] disposing of it
        AssetDisposalManagement.DisposeAsset(Asset."No.", 'End of life.');

        // [THEN] it is Disposed and Blocked
        Asset.Get(Asset."No.");
        LibraryAssert.AreEqual(Asset.Status::Disposed, Asset.Status, 'Asset should be Disposed.');
        LibraryAssert.IsTrue(Asset.Blocked, 'Disposed asset should be Blocked.');
    end;

    [Test]
    procedure TestDisposeAssetFailsWhenAssigned()
    var
        Asset: Record Asset;
        AssetDisposalManagement: Codeunit "Asset Disposal Management";
    begin
        // [GIVEN] an Assigned asset
        Asset.Init();
        Asset.Insert(true);
        Asset.Status := Asset.Status::Assigned;
        Asset.Modify(true);

        // [WHEN] trying to dispose of it
        // [THEN] it fails
        asserterror AssetDisposalManagement.DisposeAsset(Asset."No.", 'Attempted while assigned.');
    end;

    local procedure EnsureAssetSetup(var AssetSetup: Record "Asset Setup")
    var
        AssetSetupManagement: Codeunit "Asset Setup Management";
    begin
        AssetSetup := AssetSetupManagement.GetSetup();
        // NOTE: this test relies on No. Series already being configured in the test
        // environment (e.g. via a demo-data or setup codeunit). If "Asset Nos." is
        // blank, TestNewAssetDefaultsAndNumbering will fail with a clear setup error
        // rather than a silent pass — set up a No. Series in your test company first.
    end;

    local procedure GetAnyEmployeeNo(): Code[20]
    var
        Employee: Record Employee;
    begin
        if Employee.FindFirst() then
            exit(Employee."No.");

        Employee.Init();
        Employee.Insert(true);
        exit(Employee."No.");
    end;
}