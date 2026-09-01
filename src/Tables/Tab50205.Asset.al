table 50205 Asset
{
    Caption = 'Asset';
    DataClassification = CustomerContent;

    fields
    {
        field(1; "No."; Code[20])
        {
            Caption = 'No.';
        }
        field(2; Description; Text[100])
        {
            Caption = 'Description';
        }
        field(3; "Category Code"; Code[20])
        {
            Caption = 'Category Code';
            TableRelation = "Asset Category".Code;

            trigger OnValidate()
            var
                AssetCategory: Record "Asset Category";
            begin
                if "Category Code" = '' then
                    exit;

                AssetCategory.Get("Category Code");

                if AssetCategory.Blocked then
                    Error(
                        'Asset Category %1 is blocked and cannot be used.', "Category Code");
            end;
        }
        field(4; "Sub Category Code"; Code[20])
        {
            Caption = 'Sub Category Code';
            TableRelation = "Asset Sub Category".Code;

            trigger OnValidate()
            var
                AssetSubCategory: Record "Asset Sub Category";
                AssetCategory: Record "Asset Category";
            begin
                if "Sub Category Code" = '' then
                    exit;

                AssetSubCategory.Get("Sub Category Code");

                if AssetSubCategory."Blocked" then
                    Error(
                        'Asset sub category %1 us blocked and cannot be used.', "Sub Category Code");

                if ("Category Code" <> '') and (AssetSubCategory."Category Code" <> "Category Code")
                then
                    Error(
                        'Asset sub category %1 does not belong to asset category %2.',
                        "Sub Category Code",
                        "Category Code");

                if AssetSubCategory."Category Code" <> '' then begin
                    AssetCategory.Get(AssetSubCategory."Category Code");

                    if AssetCategory.Blocked then
                        Error(
                            'Asset Category %1 is blocked and cannot be used.', AssetSubCategory."Category Code");
                end;
            end;
        }
        field(5; "Brand Code"; Code[20])
        {
            Caption = 'Brand Code';
            TableRelation = "Asset Brand".Code;

            trigger OnValidate()
            var
                AssetBrand: Record "Asset Brand";
            begin
                if "Brand Code" = '' then
                    exit;

                AssetBrand.Get("Brand Code");

                if AssetBrand.Blocked then
                    Error(
                        'Asset brand %1 is blocked and cannot be used.', "Brand Code");
            end;
        }
        field(6; "Model No."; Code[50])
        {
            Caption = 'Model No.';
        }
        field(7; "Serial No."; Code[50])
        {
            Caption = 'Serial No.';
        }
        field(8; "Asset Tag No."; Code[50])
        {
            Caption = 'Asset Tag No.';
        }
        field(9; "Purchase Date"; Date)
        {
            Caption = 'Purchase Date';
        }
        field(10; "Purchase Cost"; Decimal)
        {
            Caption = 'Purchase Cost';
            DecimalPlaces = 0 : 2;
        }
        field(11; "Vendor No."; Code[20])
        {
            Caption = 'Vendor No.';
            TableRelation = Vendor."No.";
        }
        field(12; "Location Code"; Code[10])
        {
            Caption = 'Location Code';
        }
        field(13; Status; Enum "Asset Status")
        {
            Caption = 'Status';
        }
        field(14; Condition; Enum "Asset Condition")
        {
            Caption = 'Condition';
        }
        field(15; "Warranty Start Date"; Date)
        {
            Caption = 'Warranty Start Date';
        }
        field(16; "Warranty End Date"; Date)
        {
            Caption = 'Warranty End Date';
        }
        field(17; Blocked; Boolean)
        {
            Caption = 'Blocked';
        }
    }
    keys
    {
        key(PK; "No.")
        {
            Clustered = true;
        }
        key(Category; "Category Code", "Sub Category Code") { }
        key(SerialNo; "Serial No.") { }
        key(AssetTagNo; "Asset Tag No.") { }
        key(Status; Status) { }
    }

    trigger OnInsert()
    var
        AssetSetupManagement: Codeunit "Asset Setup Management";
    begin
        if "No." = '' then
            "No." := AssetSetupManagement.GetAssetNo();
    end;
}