tableextension 50201 "Fixed Asset Ext" extends "Fixed Asset"
{
    fields
    {
        field(50201; "Asset Category Code"; Code[20])
        {
            Caption = 'Asset Category Code';
            DataClassification = CustomerContent;
            TableRelation = "Asset Category".Code;

            trigger OnValidate()
            var
                AssetCategory: Record "Asset Category";
            begin
                if "Asset Category Code" = '' then
                    exit;

                AssetCategory.Get("Asset Category Code");

                if AssetCategory.Blocked then
                    Error(
                        'Asset Category %1 is blocked and cannot be used.',
                        "Asset Category Code");
            end;
        }
        field(50202; "Asset Sub Category Code"; Code[20])
        {
            Caption = 'Asset Sub Category Code';
            DataClassification = CustomerContent;
            TableRelation = "Asset Sub Category".Code;

            trigger OnValidate()
            var
                AssetSubCategory: Record "Asset Sub Category";
                AssetCategory: Record "Asset Category";
            begin
                if "Asset Sub Category Code" = '' then
                    exit;

                AssetSubCategory.Get("Asset Sub Category Code");

                if AssetSubCategory.Blocked then
                    Error(
                        'Asset Sub Category %1 is blocked and cannot be used.',
                        "Asset Sub Category Code");

                if ("Asset Category Code" <> '') and (AssetSubCategory."Category Code" <> "Asset Category Code")
                then
                    Error(
                         'Asset sub category %1 does not belong to asset category %2.',
                        "Asset Sub Category Code",
                        "Asset Category Code");

                if AssetSubCategory."Category Code" <> '' then begin
                    AssetCategory.Get(AssetSubCategory."Category Code");

                    if AssetCategory.Blocked then
                        Error(
                            'Asset Category %1 is blocked and cannot be used.',
                            AssetSubCategory."Category Code");
                end;
            end;
        }
        field(50203; "Brand Code"; Code[20])
        {
            Caption = 'Brand Code';
            DataClassification = CustomerContent;
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
        field(50204; "Model No."; Code[50])
        {
            Caption = 'Model No.';
            DataClassification = CustomerContent;
        }
        field(50205; "Asset Tag No."; Code[50])
        {
            Caption = 'Asset Tag No.';

            trigger OnValidate()
            var
                FixedAsset: Record "Fixed Asset";
            begin
                if "Asset Tag No." = '' then
                    exit;

                FixedAsset.SetRange("Asset Tag No.", "Asset Tag No.");
                FixedAsset.SetFilter("No.", '<>%1', "No.");

                if FixedAsset.FindFirst() then
                    Error(
                        'Asset Tag No. %1 is already used on asset %2.',
                        "Asset Tag No.",
                        FixedAsset."No.");
            end;
        }
        field(50206; "Purchase Date"; Date)
        {
            Caption = 'Purchase Date';
            DataClassification = CustomerContent;
        }
        field(50207; "Purchase Cost"; Decimal)
        {
            Caption = 'Purchase Cost';
            DataClassification = CustomerContent;
            DecimalPlaces = 0 : 2;
        }
        field(50208; "Asset Status"; Enum "Asset Status")
        {
            Caption = 'Asset Status';
            DataClassification = CustomerContent;
        }
        field(50209; "Asset Condition"; Enum "Asset Condition")
        {
            Caption = 'Asset Condition';
            DataClassification = CustomerContent;
        }
        field(50210; "Warranty Start Date"; Date)
        {
            Caption = 'Warranty Start Date';
            DataClassification = CustomerContent;
        }
        field(50211; "Warranty End Date"; Date)
        {
            Caption = 'Warranty End Date';
            DataClassification = CustomerContent;
        }

        modify("Serial No.")
        {
            trigger OnAfterValidate()
            var
                FixedAsset: Record "Fixed Asset";
            begin
                if "Serial No." = '' then
                    exit;

                FixedAsset.SetRange("Serial No.", "Serial No.");
                FixedAsset.SetFilter("No.", '<>%1', "No.");

                if FixedAsset.FindFirst() then
                    Error('Serial No. %1 is already used on asset %2.', "Serial No.", FixedAsset."No.");
            end;
        }
    }
    keys
    {
        key(AssetCategory; "Asset Category Code", "Asset Sub Category Code") { }
        key(AssetStatus; "Asset Status") { }
        key(AssetTagNo; "Asset Tag No.") { }
    }
}