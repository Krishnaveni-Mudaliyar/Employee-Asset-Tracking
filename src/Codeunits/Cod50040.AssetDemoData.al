codeunit 50040 "Asset Demo Data"
{
    procedure CreateDemoData()
    var
        AssetCategory: Record "Asset Category";
    begin
        if AssetCategory.Get('DEMO-LAPTOP') then
            Error('Demo data already exists. Delete the DEMO- categories first to create it again.');

        CreateMasterData();
        CreateAssets();
        CreateRequestsAndAssignments();

        Message('Demo data created.');
    end;

    local procedure CreateMasterData()
    begin
        InsertCategory('DEMO-LAPTOP', 'Laptops');
        InsertCategory('DEMO-MOBILE', 'Mobile Phones');
        InsertCategory('DEMO-TOOLS', 'Tools');

        InsertSubCategory('DEMO-LAP-STD', 'Standard Laptop', 'DEMO-LAPTOP');
        InsertSubCategory('DEMO-LAP-PWR', 'Power Laptop', 'DEMO-LAPTOP');
        InsertSubCategory('DEMO-MOB-STD', 'Standard Phone', 'DEMO-MOBILE');
        InsertSubCategory('DEMO-TOOL-HND', 'Hand Tools', 'DEMO-TOOLS');

        InsertBrand('DEMO-DELL', 'Dell');
        InsertBrand('DEMO-HP', 'HP');
        InsertBrand('DEMO-APPLE', 'Apple');
        InsertBrand('DEMO-BOSCH', 'Bosch');
    end;

    local procedure CreateAssets()
    var
        InYear: Date;
    begin
        InYear := CalcDate('<+1Y>', Today());

        InsertAsset('Dell Latitude 5440 (A)', 'DEMO-LAPTOP', 'DEMO-LAP-STD', 'DEMO-DELL', 'LAT5440', 'DEMO-SN-001', 'TAG-001', 72000, InYear, "Asset Status"::Available);
        InsertAsset('Dell Latitude 5440 (B)', 'DEMO-LAPTOP', 'DEMO-LAP-STD', 'DEMO-DELL', 'LAT5440', 'DEMO-SN-002', 'TAG-002', 72000, InYear, "Asset Status"::Available);
        InsertAsset('HP ProBook 450', 'DEMO-LAPTOP', 'DEMO-LAP-STD', 'DEMO-HP', 'PB450', 'DEMO-SN-003', 'TAG-003', 65000, InYear, "Asset Status"::Available);
        InsertAsset('HP ZBook Studio', 'DEMO-LAPTOP', 'DEMO-LAP-PWR', 'DEMO-HP', 'ZBOOK', 'DEMO-SN-004', 'TAG-004', 150000, Today() + 10, "Asset Status"::Available);
        InsertAsset('MacBook Pro 14', 'DEMO-LAPTOP', 'DEMO-LAP-PWR', 'DEMO-APPLE', 'MBP14', 'DEMO-SN-005', 'TAG-005', 190000, InYear, "Asset Status"::"Under Maintenance");
        InsertAsset('iPhone 15 (A)', 'DEMO-MOBILE', 'DEMO-MOB-STD', 'DEMO-APPLE', 'IP15', 'DEMO-SN-006', 'TAG-006', 80000, InYear, "Asset Status"::Available);
        InsertAsset('iPhone 15 (B)', 'DEMO-MOBILE', 'DEMO-MOB-STD', 'DEMO-APPLE', 'IP15', 'DEMO-SN-007', 'TAG-007', 80000, CalcDate('<-1M>', Today()), "Asset Status"::Disposed);
        InsertAsset('Cordless Drill', 'DEMO-TOOLS', 'DEMO-TOOL-HND', 'DEMO-BOSCH', 'GSR18', 'DEMO-SN-008', 'TAG-008', 9000, InYear, "Asset Status"::Available);
        InsertAsset('Torque Wrench', 'DEMO-TOOLS', 'DEMO-TOOL-HND', 'DEMO-BOSCH', 'TW200', 'DEMO-SN-009', 'TAG-009', 6000, InYear, "Asset Status"::Available);
    end;

    local procedure CreateRequestsAndAssignments()
    var
        Header: Record "Asset Request Header";
        Line: Record "Asset Request Line";
        AssetAssignmentManagement: Codeunit "Asset Assignment Management";
        Employee1: Code[20];
        Employee2: Code[20];
    begin
        Employee1 := GetEmployeeNo(1);
        Employee2 := GetEmployeeNo(2);

        // Open request
        CreateRequest(Header, Line, Employee1, "Asset Request Status"::Open, 'DEMO-LAPTOP', 'DEMO-LAP-STD', 'Standard laptop', 1, 0);

        // Waiting for approval
        CreateRequest(Header, Line, Employee2, "Asset Request Status"::"Pending Approval", 'DEMO-MOBILE', 'DEMO-MOB-STD', 'Mobile phone', 1, 0);

        // Approved, nothing assigned yet
        CreateRequest(Header, Line, Employee2, "Asset Request Status"::Approved, 'DEMO-TOOLS', 'DEMO-TOOL-HND', 'Cordless drill', 1, 1);

        // Approved, two laptops assigned: one overdue, one due this week
        CreateRequest(Header, Line, Employee1, "Asset Request Status"::Approved, 'DEMO-LAPTOP', 'DEMO-LAP-STD', 'Two standard laptops', 2, 2);
        AssetAssignmentManagement.AssignAsset(Line, FindAssetNo('DEMO-SN-001'));
        SetExpectedReturn(FindAssetNo('DEMO-SN-001'), Today() - 5);
        AssetAssignmentManagement.AssignAsset(Line, FindAssetNo('DEMO-SN-002'));
        SetExpectedReturn(FindAssetNo('DEMO-SN-002'), Today() + 3);
    end;

    local procedure InsertCategory(CategoryCode: Code[20]; CategoryDescription: Text[100])
    var
        AssetCategory: Record "Asset Category";
    begin
        AssetCategory.Init();
        AssetCategory.Code := CategoryCode;
        AssetCategory.Description := CategoryDescription;
        AssetCategory.Insert(true);
    end;

    local procedure InsertSubCategory(SubCategoryCode: Code[20]; SubCategoryDescription: Text[100]; CategoryCode: Code[20])
    var
        AssetSubCategory: Record "Asset Sub Category";
    begin
        AssetSubCategory.Init();
        AssetSubCategory.Code := SubCategoryCode;
        AssetSubCategory.Description := SubCategoryDescription;
        AssetSubCategory."Category Code" := CategoryCode;
        AssetSubCategory.Insert(true);
    end;

    local procedure InsertBrand(BrandCode: Code[20]; BrandDescription: Text[100])
    var
        AssetBrand: Record "Asset Brand";
    begin
        AssetBrand.Init();
        AssetBrand.Code := BrandCode;
        AssetBrand.Description := BrandDescription;
        AssetBrand.Insert(true);
    end;

    local procedure InsertAsset(AssetDescription: Text[100]; CategoryCode: Code[20]; SubCategoryCode: Code[20]; BrandCode: Code[20]; ModelNo: Code[50]; SerialNo: Text[50]; TagNo: Code[50]; PurchaseCost: Decimal; WarrantyEndDate: Date; AssetStatus: Enum "Asset Status")
    var
        FixedAsset: Record "Fixed Asset";
    begin
        FixedAsset.Init();
        FixedAsset.Insert(true);
        FixedAsset.Validate(Description, AssetDescription);
        FixedAsset.Validate("Asset Category Code", CategoryCode);
        FixedAsset.Validate("Asset Sub Category Code", SubCategoryCode);
        FixedAsset.Validate("Brand Code", BrandCode);
        FixedAsset.Validate("Model No.", ModelNo);
        FixedAsset.Validate("Serial No.", SerialNo);
        FixedAsset.Validate("Asset Tag No.", TagNo);
        FixedAsset."Purchase Date" := CalcDate('<-1Y>', Today());
        FixedAsset."Purchase Cost" := PurchaseCost;
        FixedAsset."Warranty Start Date" := FixedAsset."Purchase Date";
        FixedAsset."Warranty End Date" := WarrantyEndDate;
        FixedAsset."Asset Status" := AssetStatus;
        if AssetStatus = AssetStatus::Disposed then
            FixedAsset.Blocked := true;
        FixedAsset.Modify(true);
    end;

    local procedure CreateRequest(var Header: Record "Asset Request Header"; var Line: Record "Asset Request Line"; EmployeeNo: Code[20]; RequestStatus: Enum "Asset Request Status"; CategoryCode: Code[20]; SubCategoryCode: Code[20]; LineDescription: Text[100]; Qty: Decimal; ApprovedQty: Decimal)
    begin
        Header.Init();
        Header.Insert(true);
        Header."Employee No." := EmployeeNo;
        Header."Required Date" := Today() + 7;
        Header.Reason := 'Demo request';
        Header.Status := RequestStatus;
        Header.Modify(true);

        Line.Init();
        Line."Document No." := Header."No.";
        Line."Line No." := 10000;
        Line.Insert(true);
        Line.Validate("Asset Category Code", CategoryCode);
        Line.Validate("Asset Sub Category Code", SubCategoryCode);
        Line.Description := LineDescription;
        Line.Validate(Quantity, Qty);
        if ApprovedQty > 0 then
            Line.Validate("Approved Quantity", ApprovedQty);
        Line.Modify(true);
    end;

    local procedure FindAssetNo(SerialNo: Text[50]): Code[20]
    var
        FixedAsset: Record "Fixed Asset";
    begin
        FixedAsset.SetRange("Serial No.", SerialNo);
        FixedAsset.FindFirst();
        exit(FixedAsset."No.");
    end;

    local procedure SetExpectedReturn(AssetNo: Code[20]; ReturnDate: Date)
    var
        AssetAssignment: Record "Asset Assignment";
    begin
        AssetAssignment.SetRange("Asset No.", AssetNo);
        AssetAssignment.SetRange(Active, true);
        AssetAssignment.FindFirst();
        AssetAssignment."Expected Return Date" := ReturnDate;
        AssetAssignment.Modify();
    end;

    local procedure GetEmployeeNo(Index: Integer): Code[20]
    var
        Employee: Record Employee;
        Counter: Integer;
    begin
        if Employee.FindSet() then
            repeat
                Counter += 1;
                if Counter = Index then
                    exit(Employee."No.");
            until Employee.Next() = 0;

        Employee.Init();
        Employee.Validate("First Name", 'Demo');
        Employee.Validate("Last Name", 'Employee ' + Format(Index));
        Employee.Insert(true);
        exit(Employee."No.");
    end;
}