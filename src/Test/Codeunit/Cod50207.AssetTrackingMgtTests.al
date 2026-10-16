codeunit 50207 "Asset Tracking Mgt. Tests"
{
    Subtype = Test;

    var
        LibraryAssert: Codeunit "Library Assert";
        LibraryFixedAsset: Codeunit "Library - Fixed Asset";

    [TEST]
    procedure TestBlockedCategoryCannotBeUsedOnAsset()
    var
        AssetCategory: Record "Asset Category";
        FixedAsset: Record "Fixed Asset";

    begin
        // [GIVEN] A blocked asset category
        AssetCategory.Init();
        AssetCategory.Code := 'BLKCAT';
        AssetCategory.Blocked := true;
        AssetCategory.Insert(true);

        // [WHEN] assigning it to an Fixed Asset
        LibraryFixedAsset.CreateFixedAsset(FixedAsset);

        // [THEN] validation fails
        asserterror FixedAsset.Validate("Asset Category Code", AssetCategory.Code);
    end;

    [TEST]
    procedure TestSerialNoMustBeUnique()
    var
        FixedAsset1: Record "Fixed Asset";
        FixedAsset2: Record "Fixed Asset";

    begin
        // [GIVEN] a fixed asset with a Serial No.
        LibraryFixedAsset.CreateFixedAsset(FixedAsset1);
        FixedAsset1.Validate("IT Serial No.", 'SN-0001');
        FixedAsset1.Modify(true);

        // [WHEN] another asset tries to use the same Serial No.
        LibraryFixedAsset.CreateFixedAsset(FixedAsset2);

        // [THEN] validation fails
        asserterror FixedAsset2.Validate("IT Serial No.", 'SN-0001');
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

    [Test]
    procedure TestAssignAssetRequiresApprovedRequest()
    var
        AssetRequestHeader: Record "Asset Request Header";
        AssetRequestLine: Record "Asset Request Line";
        FixedAsset: Record "Fixed Asset";
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

        LibraryFixedAsset.CreateFixedAsset(FixedAsset);

        // [WHEN] trying to assign an asset before the request is Approved
        // [THEN] it fails
        asserterror AssetAssignmentManagement.AssignAsset(
            AssetRequestLine,
            FixedAsset."No.",
            WorkDate());
    end;

    [Test]
    procedure TestAssignAssetSucceedsAndClosesFullyAssignedRequest()
    var
        AssetRequestHeader: Record "Asset Request Header";
        AssetRequestLine: Record "Asset Request Line";
        FixedAsset: Record "Fixed Asset";
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

        LibraryFixedAsset.CreateFixedAsset(FixedAsset);
        LibraryAssert.AreEqual(
            FixedAsset."IT Asset Status"::Available, FixedAsset."IT Asset Status",
            'New fixed asset should default to Available.');

        // [WHEN] the asset is assigned
        AssetAssignmentManagement.AssignAsset(
            AssetRequestLine,
            FixedAsset."No.",
            WorkDate());

        // [THEN] the asset becomes Assigned
        FixedAsset.Get(FixedAsset."No.");
        LibraryAssert.AreEqual(
            FixedAsset."IT Asset Status"::Assigned,
            FixedAsset."IT Asset Status",
            'Asset should be Assigned after assignment.');

        // [THEN] the line's Assigned Quantity reflects it
        AssetRequestLine.Get(
            AssetRequestLine."Document No.",
            AssetRequestLine."Line No.");
        LibraryAssert.AreEqual(
            1,
             AssetRequestLine."Assigned Quantity",
             'Assigned Quantity should be 1.');

        // [THEN] the header auto-closes since every line is fully assigned
        AssetRequestHeader.Get(AssetRequestHeader."No.");

        LibraryAssert.AreEqual(
            AssetRequestHeader.Status::Closed,
            AssetRequestHeader.Status,
            'Header should auto-close once fully assigned.');
    end;

    [Test]
    procedure TestAssignAssetCreatesNotificationForRequester()
    var
        AssetRequestHeader: Record "Asset Request Header";
        AssetRequestLine: Record "Asset Request Line";
        FixedAsset: Record "Fixed Asset";
        AssetNotification: Record "Asset Notification";
        AssetAssignmentManagement: Codeunit "Asset Assignment Management";
    begin
        // [GIVEN] an Approved request with one line
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

        LibraryFixedAsset.CreateFixedAsset(FixedAsset);

        // [WHEN] the asset is assigned
        AssetAssignmentManagement.AssignAsset(
            AssetRequestLine,
            FixedAsset."No.",
            WorkDate());

        // [THEN] a notification was created for the requester referencing the request
        AssetNotification.SetRange(
            "Recipient User ID",
            AssetRequestHeader."Requested By");

        AssetNotification.SetRange(
            "Related Document No.",
            AssetRequestHeader."No.");

        LibraryAssert.IsFalse(
            AssetNotification.IsEmpty(),
            'Expected a notification for the requester after assignment.');
    end;

    [Test]
    procedure TestReturnAssetRequiresAssignedStatus()
    var
        FixedAsset: Record "Fixed Asset";
        AssetReturnManagement: Codeunit "Asset Return Management";
    begin
        // [GIVEN] an Available (not Assigned) fixed asset
        LibraryFixedAsset.CreateFixedAsset(FixedAsset);

        // [WHEN] trying to return it
        // [THEN] it fails
        asserterror AssetReturnManagement.ReturnAsset(
            FixedAsset."No.",
            FixedAsset."IT Asset Condition"::Good,
            '');
    end;

    [Test]
    procedure TestDisposeAssetBlocksAssetAndSetsStatus()
    var
        FixedAsset: Record "Fixed Asset";
        AssetDisposalManagement: Codeunit "Asset Disposal Management";
    begin
        // [GIVEN] an Available fixed asset
        LibraryFixedAsset.CreateFixedAsset(FixedAsset);

        // [WHEN] disposing of it
        AssetDisposalManagement.DisposeAsset(
            FixedAsset."No.",
            'End of life.');

        // [THEN] it is Disposed and IT Asset Blocked
        FixedAsset.Get(FixedAsset."No.");
        LibraryAssert.AreEqual(
            FixedAsset."IT Asset Status"::Disposed,
            FixedAsset."IT Asset Status",
            'Asset should be Disposed.');

        LibraryAssert.IsTrue(
            FixedAsset."IT Asset Blocked",
            'Disposed asset should be IT Asset Blocked.');
    end;

    [Test]
    procedure TestDisposeAssetFailsWhenAssigned()
    var
        FixedAsset: Record "Fixed Asset";
        AssetDisposalManagement: Codeunit "Asset Disposal Management";
    begin
        // [GIVEN] an Assigned fixed asset
        LibraryFixedAsset.CreateFixedAsset(FixedAsset);
        FixedAsset."IT Asset Status" := FixedAsset."IT Asset Status"::Assigned;
        FixedAsset.Modify(true);

        // [WHEN] trying to dispose of it
        // [THEN] it fails
        asserterror AssetDisposalManagement.DisposeAsset(
            FixedAsset."No.",
            'Attempted while assigned.');
    end;

    [Test]
    procedure TestBulkAssignFromStockAssignsUpToRemainingQuantity()
    var
        AssetRequestHeader: Record "Asset Request Header";
        AssetRequestLine: Record "Asset Request Line";
        FixedAsset1: Record "Fixed Asset";
        FixedAsset2: Record "Fixed Asset";
        FixedAsset3: Record "Fixed Asset";
        AssetAssignmentManagement: Codeunit "Asset Assignment Management";
        AssignedCount: Integer;
    begin
        // [GIVEN] an Approved request needing 2 assets, and 3 Available fixed assets in stock
        AssetRequestHeader.Init();
        AssetRequestHeader.Insert(true);
        AssetRequestHeader."Employee No." := GetAnyEmployeeNo();
        AssetRequestHeader.Status := AssetRequestHeader.Status::Approved;
        AssetRequestHeader.Modify(true);

        AssetRequestLine.Init();
        AssetRequestLine."Document No." := AssetRequestHeader."No.";
        AssetRequestLine."Line No." := 10000;
        AssetRequestLine.Insert(true);
        AssetRequestLine.Validate(Quantity, 2);
        AssetRequestLine.Validate("Approved Quantity", 2);
        AssetRequestLine.Modify(true);

        LibraryFixedAsset.CreateFixedAsset(FixedAsset1);
        LibraryFixedAsset.CreateFixedAsset(FixedAsset2);
        LibraryFixedAsset.CreateFixedAsset(FixedAsset3);

        // [WHEN] bulk-assigning from stock
        AssignedCount := AssetAssignmentManagement.BulkAssignFromStock(AssetRequestLine, WorkDate());

        // [THEN] exactly 2 were assigned, not all 3
        LibraryAssert.AreEqual(2, AssignedCount, 'Should assign only up to the remaining approved quantity.');

        AssetRequestLine.Get(AssetRequestLine."Document No.", AssetRequestLine."Line No.");
        LibraryAssert.AreEqual(2, AssetRequestLine."Assigned Quantity", 'Assigned Quantity should be 2.');
    end;

    [Test]
    procedure TestAssignAssetFailsForInactiveEmployee()
    var
        AssetRequestHeader: Record "Asset Request Header";
        AssetRequestLine: Record "Asset Request Line";
        FixedAsset: Record "Fixed Asset";
        Employee: Record Employee;
        AssetAssignmentManagement: Codeunit "Asset Assignment Management";
    begin
        CreateApprovedRequest(AssetRequestHeader, AssetRequestLine, 1);
        Employee.Get(AssetRequestHeader."Employee No.");
        Employee.Status := Employee.Status::Inactive;
        Employee.Modify();
        LibraryFixedAsset.CreateFixedAsset(FixedAsset);

        asserterror AssetAssignmentManagement.AssignAsset(AssetRequestLine, FixedAsset."No.", WorkDate());

        LibraryAssert.ExpectedError('is not active');
    end;

    [Test]
    procedure TestAssignFailsForPastReturnDate()
    var
        AssetRequestHeader: Record "Asset Request Header";
        AssetRequestLine: Record "Asset Request Line";
        FixedAsset: Record "Fixed Asset";
        AssetAssignmentManagement: Codeunit "Asset Assignment Management";
    begin
        CreateApprovedRequest(AssetRequestHeader, AssetRequestLine, 1);
        LibraryFixedAsset.CreateFixedAsset(FixedAsset);

        asserterror AssetAssignmentManagement.AssignAsset(AssetRequestLine, FixedAsset."No.", CalcDate('<-1D>', WorkDate()));
        LibraryAssert.ExpectedError('cannot be in the past');
    end;

    [Test]
    procedure TestDisposeAssetFailsWhenUnderMaintenance()
    var
        FixedAsset: Record "Fixed Asset";
        AssetDisposalManagement: Codeunit "Asset Disposal Management";
    begin
        LibraryFixedAsset.CreateFixedAsset(FixedAsset);
        FixedAsset."IT Asset Status" := FixedAsset."IT Asset Status"::"Under Maintenance";
        FixedAsset.Modify(true);

        asserterror AssetDisposalManagement.DisposeAsset(FixedAsset."No.", 'Attempted during maintenace.');

        LibraryAssert.ExpectedError('under maintenance');
    end;

    [Test]
    procedure TestTransferAssetFailsForInactiveEmployee()
    var
        FixedAsset: Record "Fixed Asset";
        Employee: Record Employee;
        AssetTransferManagement: Codeunit "Asset Transfer Management";
    begin
        LibraryFixedAsset.CreateFixedAsset(FixedAsset);
        FixedAsset."IT Asset Status" := FixedAsset."IT Asset Status"::Assigned;
        FixedAsset.Modify(true);
        Employee.Init();
        Employee.Insert(true);
        Employee.Status := Employee.Status::Inactive;
        Employee.Modify();

        asserterror AssetTransferManagement.TransferAsset(FixedAsset."No.", Employee."No.", '', '');
        LibraryAssert.ExpectedError('is not active');
    end;

    [Test]
    procedure TestReturnAssetNotifiesRequester()
    var
        AssetRequestHeader: Record "Asset Request Header";
        AssetRequestLine: Record "Asset Request Line";
        FixedAsset: Record "Fixed Asset";
        AssetNotification: Record "Asset Notification";
        AssetAssignmentManagement: Codeunit "Asset Assignment Management";
        AssetReturnManagement: Codeunit "Asset Return Management";
    begin
        CreateApprovedRequest(AssetRequestHeader, AssetRequestLine, 1);
        LibraryFixedAsset.CreateFixedAsset(FixedAsset);
        AssetAssignmentManagement.AssignAsset(AssetRequestLine, FixedAsset."No.", WorkDate());

        // [WHEN] the asset is returned
        AssetReturnManagement.ReturnAsset(FixedAsset."No.", FixedAsset."IT Asset Condition"::Good, '');

        // [THEN] the requester is notified about the return
        AssetNotification.SetRange("Recipient User ID", AssetRequestHeader."Requested By");
        AssetNotification.SetRange("Related Document No.", AssetRequestHeader."No.");
        AssetNotification.SetFilter(Message, '*returned*');
        LibraryAssert.IsFalse(AssetNotification.IsEmpty(), 'Expected a return notification for the requester.');
    end;

    [Test]
    procedure TestApprovalEntryNotfiesApprover()
    var
        AssetRequestHeader: Record "Asset Request Header";
        ApprovalEntry: Record "Approval Entry";
        AssetNotification: Record "Asset Notification";
    begin
        AssetRequestHeader.Init();
        AssetRequestHeader.Insert(true);

        // [WHEN] an open approval entry is created for it
        ApprovalEntry.Init();
        ApprovalEntry."Table ID" := Database::"Asset Request Header";
        ApprovalEntry."Record ID to Approve" := AssetRequestHeader.RecordId;
        ApprovalEntry."Approver ID" := 'TESTAPPR';
        ApprovalEntry.Status := ApprovalEntry.Status::Open;
        ApprovalEntry.Insert();

        // [THEN] the approver is notified
        AssetNotification.SetRange("Recipient User ID", 'TESTAPPR');
        AssetNotification.SetRange("Related Document No.", AssetRequestHeader."No.");
        LibraryAssert.IsFalse(AssetNotification.IsEmpty(), 'Expected a notification for the approver.');
    end;

    [Test]
    procedure TestAlertJobNotifiesOverdueReturnOnlyOnce()
    var
        AssetRequestHeader: Record "Asset Request Header";
        AssetRequestLine: Record "Asset Request Line";
        FixedAsset: Record "Fixed Asset";
        AssetAssignment: Record "Asset Assignment";
        AssetNotification: Record "Asset Notification";
        AssetAssignmentManagement: Codeunit "Asset Assignment Management";

    begin
        CreateApprovedRequest(AssetRequestHeader, AssetRequestLine, 1);
        LibraryFixedAsset.CreateFixedAsset(FixedAsset);
        AssetAssignmentManagement.AssignAsset(AssetRequestline, FixedAsset."No.", WorkDate());
        AssetAssignment.SetRange("Asset No.", FixedAsset."No.");
        AssetAssignment.FindFirst();
        AssetAssignment."Expected Return Date" := CalcDate('<-1D>', Today());
        AssetAssignment.Modify();

        // [WHEN] the alert job runs twice
        Codeunit.Run(Codeunit::"Asset Alert Job");
        Codeunit.Run(Codeunit::"Asset Alert Job");

        // [THEN] the requester has exactly one overdue notification for the asset
        AssetNotification.SetRange("Recipient User ID", AssetRequestHeader."Requested By");
        AssetNotification.SetRange("Related Document No.", FixedAsset."No.");
        AssetNotification.SetFilter(Message, '*overdue*');
        LibraryAssert.AreEqual(1, AssetNotification.Count(), 'Expected exactly one overdue notification.');
    end;

    [Test]
    procedure TestAlertJobNotifiesExpiringWarranty()
    var
        FixedAsset: Record "Fixed Asset";
        AssetSetup: Record "Asset Setup";
        AssetNotification: Record "Asset Notification";
    begin
        if not AssetSetup.Get() then
            AssetSetup.Insert();
        AssetSetup."Warranty Alert Days" := 30;
        AssetSetup."Warranty Alert User ID" := 'WARRUSER';
        AssetSetup.Modify();

        LibraryFixedAsset.CreateFixedAsset(FixedAsset);
        FixedAsset."Warranty End Date" := CalcDate('<+5D>', Today());
        FixedAsset.Modify();

        Codeunit.Run(Codeunit::"Asset Alert Job");

        AssetNotification.SetRange("Recipient User ID", 'WARRUSER');
        AssetNotification.SetRange("Related Document No.", FixedAsset."No.");
        LibraryAssert.IsFalse(AssetNotification.IsEmpty(), 'Expected a warranty expiry notification');
    end;

    local procedure CreateApprovedRequest(
        var
        AssetRequestHeader: Record "Asset Request Header";
        var
        AssetRequestLine: Record "Asset Request Line";
        Qty: Integer)
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

    local procedure GetAnyEmployeeNo(): Code[20]
    var
        Employee: Record Employee;
    begin
        Employee.SetRange(Status, Employee.Status::Active);
        if Employee.FindFirst() then
            exit(Employee."No.");

        Employee.SetRange(Status);

        Employee.Init();
        Employee.Insert(true);
        exit(Employee."No.");
    end;
}