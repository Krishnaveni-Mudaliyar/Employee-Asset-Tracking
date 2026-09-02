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
                        'Asset Category %1 is blocked and cannot be used.',
                        "Category Code");
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
                        'Asset sub category %1 us blocked and cannot be used.',
                         "Sub Category Code");

                if
                ("Category Code" <> '') and (AssetSubCategory."Category Code" <> "Category Code")
                then
                    Error(
                        'Asset sub category %1 does not belong to asset category %2.',
                        "Sub Category Code",
                        "Category Code");

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
                            'Asset Category %1 is blocked and cannot be used.',
                            AssetSubCategory."Category Code");
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
                        'Asset brand %1 is blocked and cannot be used.',
                        "Brand Code");
            end;
        }
        field(6; "Model No."; Code[50])
        {
            Caption = 'Model No.';
        }
        field(7; "Serial No."; Code[50])
        {
            Caption = 'Serial No.';

            trigger OnValidate()
            var
                Asset: Record Asset;
            begin
                if "Serial No." = '' then
                    exit;

                Asset.SetRange("Serial No.", "Serial No.");
                Asset.SetFilter("No.", '<>%1', "No.");

                if not Asset.IsEmpty() then begin
                    Asset.FindFirst();
                    Error(
                        'Serial No. %1 is already used on asset %2.',
                        "Serial No.",
                        Asset."No.");
                end;
            end;
        }
        field(8; "Asset Tag No."; Code[50])
        {
            Caption = 'Asset Tag No.';

            trigger OnValidate()
            var
                Asset: Record Asset;
            begin
                if "Asset Tag No." = '' then
                    exit;

                Asset.SetRange("Asset Tag No.", "Asset Tag No.");
                Asset.SetFilter("No.", '<>%1', "No.");

                if not Asset.IsEmpty() then begin
                    Asset.FindFirst();
                    Error(
                        'Asset Tag No. %1 is already used on asset %2.',
                        "Asset Tag No.",
                        Asset."No.");
                end;
            end;
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
        field(18; "Shortcut Dimension 1 Code"; Code[20])
        {
            CaptionClass = '1,2,1';
            Caption = 'Shortcut Dimension 1 Code';
            TableRelation = "Dimension Value".Code where("Global Dimension No." = const(1));

            trigger OnValidate()
            begin
                DimMgt.ValidateShortcutDimValues(1, "Shortcut Dimension 1 Code", "Dimension Set ID");
            end;
        }
        field(19; "Shortcut Dimension 2 Code"; Code[20])
        {
            CaptionClass = '1,2,2';
            Caption = 'Shortcut Dimension 2 Code';
            TableRelation = "Dimension Value".Code where("Global Dimension No." = const(2));

            trigger OnValidate()
            begin
                DimMgt.ValidateShortcutDimValues(2, "Shortcut Dimension 2 Code", "Dimension Set ID");
            end;
        }
        field(20; "Dimension Set ID"; Integer)
        {
            Caption = 'Dimension Set ID';
            Editable = false;
            TableRelation = "Dimension Set Entry"."Dimension Set ID";

            trigger OnLookup()
            begin
                ShowDimensions();
            end;
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

    var
        DimMgt: Codeunit DimensionManagement;

    procedure ShowDimensions()
    begin
        // NOTE: EditDimensionSet's exact parameter order/signature on codeunit
        // "Dimension Management" can vary slightly between BC versions. Verify this
        // call against your BC 28 symbols before relying on it — if it doesn't
        // compile as-is, check the codeunit's actual procedure signature in the
        // AL Symbol browser and adjust the arguments to match.
        "Dimension Set ID" :=
            DimMgt.EditDimensionSet(Database::Asset, "Dimension Set ID", "No.", "Shortcut Dimension 1 Code", "Shortcut Dimension 2 Code");
        Modify(true);
    end;
}