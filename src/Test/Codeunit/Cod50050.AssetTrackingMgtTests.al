codeunit 50050 "Asset Tracking Mgt. Tests"
{
    Subtype = Test;

    var
        LibraryAssert: Codeunit "Library Assert";

    // ---------- Asset master ----------
    [TEST]
    procedure TestNewAssetDefaultAndNumbering()
    var
        AssetSetup: Record "Asset Setup";
        Asset: Record "Fixed Asset";
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
        Asset: Record "Fixed Asset";

    begin
        // [GIVEN] A blocked asset category
        AssetCategory.Init();
        AssetCategory.Code := 'BLKCAT';
        AssetCategory.Blocked := true;
        AssetCategory.Insert(true);

        // [WHEN] assigning it to an  Asset
        CreateAsset(Asset);

        // [THEN] validation fails
        asserterror Asset.Validate("Asset Category Code", AssetCategory.Code);
    end;

    [TEST]
    procedure TestSerialNoMustBeUnique()
    var
        Asset1: Record "Fixed Asset";
        Asset2: Record "Fixed Asset";

    begin
        // [GIVEN] a fixed asset with a Serial No.
        CreateAsset(Asset1);
        Asset1.Validate("Serial No.", 'SN-0001');
        Asset1.Modify(true);

        // [WHEN] another asset tries to use the same Serial No.
        CreateAsset(Asset2);

        // [THEN] validation fails
        asserterror Asset2.Validate("Serial No.", 'SN-0001');
    end;

    // ---------- Request and approval ----------

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

        // [THEN] sending it for approval again fails, because Status <> Open
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

        // [THEN] cancelling an approval request that was never sent fails
        asserterror AssetRequestApprovalMgmt.CancelApprovalRequest(AssetRequestHeader);
    end;

    // ---------- Assignment ----------

    [Test]
    procedure TestAssignAssetRequiresApprovedRequest()
    var
        AssetRequestHeader: Record "Asset Request Header";
        AssetRequestLine: Record "Asset Request Line";
        Asset: Record "Fixed Asset";
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

        CreateAsset(Asset);

        // [THEN] assigning before the request is Approved fails
        asserterror AssetAssignmentManagement.AssignAsset(AssetRequestLine, Asset."No.");
    end;

    [Test]
    procedure TestAssignAssetSucceedsAndClosesFullyAssignedRequest()
    var
        AssetRequestHeader: Record "Asset Request Header";
        AssetRequestLine: Record "Asset Request Line";
        Asset: Record "Fixed Asset";
        AssetAssignmentManagement: Codeunit "Asset Assignment Management";
    begin
        // [GIVEN] an Approved request for quantity 1 and an Available asset
        CreateApprovedRequest(AssetRequestHeader, AssetRequestLine, 1);
        CreateAsset(Asset);
        LibraryAssert.AreEqual(Asset."Asset Status"::Available, Asset."Asset Status", 'New asset should default to Available.');

        // [WHEN] the asset is assigned
        AssetAssignmentManagement.AssignAsset(AssetRequestLine, Asset."No.");

        // [THEN] the asset becomes Assigned
        Asset.Get(Asset."No.");
        LibraryAssert.AreEqual(Asset."Asset Status"::Assigned, Asset."Asset Status", 'Asset should be Assigned after assignment.');

        // [THEN] the line's Assigned Quantity reflects it
        AssetRequestLine.Get(AssetRequestLine."Document No.", AssetRequestLine."Line No.");
        LibraryAssert.AreEqual(1, AssetRequestLine."Assigned Quantity", 'Assigned Quantity should be 1.');

        // [THEN] the header auto-closes since every line is fully assigned
        AssetRequestHeader.Get(AssetRequestHeader."No.");
        LibraryAssert.AreEqual(AssetRequestHeader.Status::Closed, AssetRequestHeader.Status, 'Header should auto-close once fully assigned.');
    end;

    [Test]
    procedure TestAssignAssetCreatesNotificationForRequester()
    var
        AssetRequestHeader: Record "Asset Request Header";
        AssetRequestLine: Record "Asset Request Line";
        Asset: Record "Fixed Asset";
        AssetNotification: Record "Asset Notification";
        AssetAssignmentManagement: Codeunit "Asset Assignment Management";
    begin
        // [GIVEN] an Approved request and an Available asset
        CreateApprovedRequest(AssetRequestHeader, AssetRequestLine, 1);
        CreateAsset(Asset);

        // [WHEN] the asset is assigned
        AssetAssignmentManagement.AssignAsset(AssetRequestLine, Asset."No.");

        // [THEN] the requester gets a notification referencing the request
        AssetNotification.SetRange("Recipient User ID", AssetRequestHeader."Requested By");
        AssetNotification.SetRange("Related Document No.", AssetRequestHeader."No.");
        LibraryAssert.IsFalse(AssetNotification.IsEmpty(), 'Expected a notification for the requester after assignment.');
    end;

    [Test]
    procedure TestBulkAssignFromStockAssignsUpToRemainingQuantity()
    var
        AssetRequestHeader: Record "Asset Request Header";
        AssetRequestLine: Record "Asset Request Line";
        Asset1, Asset2, Asset3 : Record "Fixed Asset";
        AssetAssignmentManagement: Codeunit "Asset Assignment Management";
        AssignedCount: Integer;
    begin
        // [GIVEN] an Approved request needing 2 assets, and 3 Available assets in stock
        CreateApprovedRequest(AssetRequestHeader, AssetRequestLine, 2);
        CreateAsset(Asset1);
        CreateAsset(Asset2);
        CreateAsset(Asset3);

        // [WHEN] bulk-assigning from stock
        AssignedCount := AssetAssignmentManagement.BulkAssignFromStock(AssetRequestLine, WorkDate());

        // [THEN] exactly 2 were assigned, not all 3
        LibraryAssert.AreEqual(2, AssignedCount, 'Should assign only up to the remaining approved quantity.');

        AssetRequestLine.Get(AssetRequestLine."Document No.", AssetRequestLine."Line No.");
        LibraryAssert.AreEqual(2, AssetRequestLine."Assigned Quantity", 'Assigned Quantity should be 2.');
    end;

    [Test]
    procedure TestAssignAssetFailsWhenUnderMaintenance()
    var
        AssetRequestHeader: Record "Asset Request Header";
        AssetRequestLine: Record "Asset Request Line";
        Asset: Record "Fixed Asset";
        AssetAssignmentManagement: Codeunit "Asset Assignment Management";
    begin
        CreateApprovedRequest(AssetRequestHeader, AssetRequestLine, 1);
        CreateAsset(Asset);
        Asset."Asset Status" := Asset."Asset Status"::"Under Maintenance";
        Asset.Modify(true);

        asserterror AssetAssignmentManagement.AssignAsset(AssetRequestLine, Asset."No.");

        LibraryAssert.ExpectedError('under maintenance');
    end;

    [Test]
    procedure TestAssignAssetFailsWhenAlreadyAssigned()
    var
        AssetRequestHeader: Record "Asset Request Header";
        AssetRequestLine: Record "Asset Request Line";
        Asset: Record "Fixed Asset";
        AssetAssignmentManagement: Codeunit "Asset Assignment Management";
    begin
        CreateApprovedRequest(AssetRequestHeader, AssetRequestLine, 1);
        CreateAsset(Asset);
        Asset."Asset Status" := Asset."Asset Status"::Assigned;
        Asset.Modify(true);

        asserterror AssetAssignmentManagement.AssignAsset(AssetRequestLine, Asset."No.");

        LibraryAssert.ExpectedError('already assigned');
    end;

    [Test]
    procedure TestAssignAssetFailsWhenDisposed()
    var
        AssetRequestHeader: Record "Asset Request Header";
        AssetRequestLine: Record "Asset Request Line";
        Asset: Record "Fixed Asset";
        AssetAssignmentManagement: Codeunit "Asset Assignment Management";
    begin
        CreateApprovedRequest(AssetRequestHeader, AssetRequestLine, 1);
        CreateAsset(Asset);
        Asset."Asset Status" := Asset."Asset Status"::Disposed;
        Asset.Modify(true);

        asserterror AssetAssignmentManagement.AssignAsset(AssetRequestLine, Asset."No.");

        LibraryAssert.ExpectedError('disposed');
    end;

    // ---------- Return, transfer, disposal ----------

    [Test]
    procedure TestReturnAssetRequiresAssignedStatus()
    var
        Asset: Record "Fixed Asset";
        AssetReturnManagement: Codeunit "Asset Return Management";
    begin
        // [GIVEN] an Available (not Assigned) asset
        CreateAsset(Asset);

        // [THEN] returning it fails
        asserterror AssetReturnManagement.ReturnAsset(Asset."No.", Asset."Asset Condition"::Good, '');
    end;

    [Test]
    procedure TestReturnAssetNotifiesRequester()
    var
        AssetRequestHeader: Record "Asset Request Header";
        AssetRequestLine: Record "Asset Request Line";
        Asset: Record "Fixed Asset";
        AssetNotification: Record "Asset Notification";
        AssetAssignmentManagement: Codeunit "Asset Assignment Management";
        AssetReturnManagement: Codeunit "Asset Return Management";
    begin
        // [GIVEN] an asset assigned through an approved request
        CreateApprovedRequest(AssetRequestHeader, AssetRequestLine, 1);
        CreateAsset(Asset);
        AssetAssignmentManagement.AssignAsset(AssetRequestLine, Asset."No.");

        // [WHEN] the asset is returned
        AssetReturnManagement.ReturnAsset(Asset."No.", Asset."Asset Condition"::Good, '');

        // [THEN] the requester is notified about the return
        AssetNotification.SetRange("Recipient User ID", AssetRequestHeader."Requested By");
        AssetNotification.SetRange("Related Document No.", AssetRequestHeader."No.");
        AssetNotification.SetFilter(Message, '*returned*');
        LibraryAssert.IsFalse(AssetNotification.IsEmpty(), 'Expected a return notification for the requester.');
    end;

    [Test]
    procedure TestTransferAssetFailsWhenUnderMaintenance()
    var
        Asset: Record "Fixed Asset";
        AssetTransferManagement: Codeunit "Asset Transfer Management";
    begin
        CreateAsset(Asset);
        Asset."Asset Status" := Asset."Asset Status"::"Under Maintenance";
        Asset.Modify(true);

        asserterror AssetTransferManagement.TransferAsset(Asset."No.", GetAnyEmployeeNo(), '', '');

        LibraryAssert.ExpectedError('under maintenance');
    end;

    [Test]
    procedure TestTransferAssetFailsForInactiveEmployee()
    var
        Asset: Record "Fixed Asset";
        Employee: Record Employee;
        AssetTransferManagement: Codeunit "Asset Transfer Management";
    begin
        CreateAsset(Asset);
        Asset."Asset Status" := Asset."Asset Status"::Assigned;
        Asset.Modify(true);
        Employee.Get(GetAnyEmployeeNo());
        Employee.Status := Employee.Status::Inactive;
        Employee.Modify();

        asserterror AssetTransferManagement.TransferAsset(Asset."No.", Employee."No.", '', '');

        LibraryAssert.ExpectedError('is not active');
    end;

    [Test]
    procedure TestDisposeAssetBlocksAssetAndSetsStatus()
    var
        Asset: Record "Fixed Asset";
        AssetDisposalManagement: Codeunit "Asset Disposal Management";
    begin
        // [GIVEN] an Available asset
        CreateAsset(Asset);

        // [WHEN] disposing of it
        AssetDisposalManagement.DisposeAsset(Asset."No.", 'End of life.');

        // [THEN] it is Disposed and blocked
        Asset.Get(Asset."No.");
        LibraryAssert.AreEqual(Asset."Asset Status"::Disposed, Asset."Asset Status", 'Asset should be Disposed.');
        LibraryAssert.IsTrue(Asset.Blocked, 'Disposed asset should be blocked.');
    end;

    [Test]
    procedure TestDisposeAssetFailsWhenAssigned()
    var
        Asset: Record "Fixed Asset";
        AssetDisposalManagement: Codeunit "Asset Disposal Management";
    begin
        // [GIVEN] an Assigned asset
        CreateAsset(Asset);
        Asset."Asset Status" := Asset."Asset Status"::Assigned;
        Asset.Modify(true);

        // [THEN] disposing of it fails
        asserterror AssetDisposalManagement.DisposeAsset(Asset."No.", 'Attempted while assigned.');
    end;

    [Test]
    procedure TestDisposeAssetFailsWhenUnderMaintenance()
    var
        Asset: Record "Fixed Asset";
        AssetDisposalManagement: Codeunit "Asset Disposal Management";
    begin
        CreateAsset(Asset);
        Asset."Asset Status" := Asset."Asset Status"::"Under Maintenance";
        Asset.Modify(true);

        asserterror AssetDisposalManagement.DisposeAsset(Asset."No.", 'Attempted during maintenance.');

        LibraryAssert.ExpectedError('under maintenance');
    end;

    // ---------- Alerts and employee events ----------

    [Test]
    procedure TestAlertJobNotifiesOverdueReturnOnlyOnce()
    var
        AssetRequestHeader: Record "Asset Request Header";
        AssetRequestLine: Record "Asset Request Line";
        Asset: Record "Fixed Asset";
        AssetAssignment: Record "Asset Assignment";
        AssetNotification: Record "Asset Notification";
        AssetAssignmentManagement: Codeunit "Asset Assignment Management";
    begin
        // [GIVEN] an assigned asset whose expected return date was yesterday
        CreateApprovedRequest(AssetRequestHeader, AssetRequestLine, 1);
        CreateAsset(Asset);
        AssetAssignmentManagement.AssignAsset(AssetRequestLine, Asset."No.");
        AssetAssignment.SetRange("Asset No.", Asset."No.");
        AssetAssignment.FindFirst();
        AssetAssignment."Expected Return Date" := CalcDate('<-1D>', Today());
        AssetAssignment.Modify();

        // [WHEN] the alert job runs twice
        Codeunit.Run(Codeunit::"Asset Alert Job");
        Codeunit.Run(Codeunit::"Asset Alert Job");

        // [THEN] the requester has exactly one overdue notification for the asset
        AssetNotification.SetRange("Recipient User ID", AssetRequestHeader."Requested By");
        AssetNotification.SetRange("Related Document No.", Asset."No.");
        AssetNotification.SetFilter(Message, '*overdue*');
        LibraryAssert.AreEqual(1, AssetNotification.Count(), 'Expected exactly one overdue notification.');
    end;

    [Test]
    procedure TestAlertJobNotifiesExpiringWarranty()
    var
        Asset: Record "Fixed Asset";
        AssetSetup: Record "Asset Setup";
        AssetNotification: Record "Asset Notification";
    begin
        // [GIVEN] a warranty alert user and an asset whose warranty ends in 5 days
        if not AssetSetup.Get() then
            AssetSetup.Insert();
        AssetSetup."Warranty Alert Lead Days" := 30;
        AssetSetup."Alert Recipient User ID" := 'WARRUSER';
        AssetSetup.Modify();

        CreateAsset(Asset);
        Asset."Warranty End Date" := CalcDate('<+5D>', Today());
        Asset.Modify();

        // [WHEN] the alert job runs
        Codeunit.Run(Codeunit::"Asset Alert Job");

        // [THEN] the alert user is notified
        AssetNotification.SetRange("Recipient User ID", 'WARRUSER');
        AssetNotification.SetRange("Related Document No.", Asset."No.");
        LibraryAssert.IsFalse(AssetNotification.IsEmpty(), 'Expected a warranty expiry notification.');
    end;

    [Test]
    procedure TestCountActiveAssetsForEmployee()
    var
        AssetRequestHeader: Record "Asset Request Header";
        AssetRequestLine: Record "Asset Request Line";
        Asset: Record "Fixed Asset";
        AssetAssignmentManagement: Codeunit "Asset Assignment Management";
        AssetEmployeeEvents: Codeunit "Asset Employee Events";
        CountBefore: Integer;
    begin
        // [GIVEN] an employee and the number of assets they hold
        CreateApprovedRequest(AssetRequestHeader, AssetRequestLine, 1);
        CountBefore := AssetEmployeeEvents.CountActiveAssets(AssetRequestHeader."Employee No.");
        CreateAsset(Asset);

        // [WHEN] an asset is assigned to them
        AssetAssignmentManagement.AssignAsset(AssetRequestLine, Asset."No.");

        // [THEN] their active asset count goes up by one
        LibraryAssert.AreEqual(
            CountBefore + 1,
            AssetEmployeeEvents.CountActiveAssets(AssetRequestHeader."Employee No."),
            'Active asset count should increase after assignment.');
    end;

    // ---------- Helpers ----------

    local procedure CreateAsset(var Asset: Record "Fixed Asset")
    begin
        Asset.Init();
        Asset.Insert(true);
    end;

    local procedure CreateApprovedRequest(var AssetRequestHeader: Record "Asset Request Header"; var AssetRequestLine: Record "Asset Request Line"; Qty: Integer)
    begin
        AssetRequestHeader.Init();
        AssetRequestHeader.Insert(true);
        AssetRequestHeader."Employee No." := GetAnyEmployeeNo();
        AssetRequestHeader.Status := AssetRequestHeader.Status::Approved;
        AssetRequestHeader.Modify(true);

        AssetRequestLine.Init();
        AssetRequestLine."Document No." := AssetRequestHeader."No.";
        AssetRequestLine."Line No." := 10000;
        AssetRequestLine.Insert(true);
        AssetRequestLine.Validate(Quantity, Qty);
        AssetRequestLine.Validate("Approved Quantity", Qty);
        AssetRequestLine.Modify(true);
    end;

    local procedure EnsureAssetSetup(var AssetSetup: Record "Asset Setup")
    var
        AssetSetupManagement: Codeunit "Asset Setup Management";
    begin
        AssetSetup := AssetSetupManagement.GetSetup();
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