tableextension 50201 "Fixed Asset Ext" extends "Fixed Asset"
{
    fields
    {
        field(50201; "Asset Category Code"; Code[20])
        {
            Caption = 'Asset Category Code';
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
            Caption = 'Asset Brand Code';
            TableRelation = "Asset Brand".Code;

            trigger OnValidate()
            var
                AssetBrand: Record "Asset Brand";
            begin
                if "Asset Brand Code" = '' then
                    exit;

                AssetBrand.Get("Asset Brand Code");

                if AssetBrand.Blocked then
                    Error(
                        'Asset brand %1 is blocked and cannot be used.',
                        "Asset Brand Code");
            end;
        }
        field(50212; "IT Model No."; Code[50])
        {
            Caption = 'Model No.';
        }
        field(50204; "IT Serial No."; Code[50])
        {
            Caption = 'Serial No.';

            trigger OnValidate()
            var
                FixedAsset: Record "Fixed Asset";
            begin
                if "IT Serial No." = '' then
                    exit;

                FixedAsset.SetRange("IT Serial No.", "IT Serial No.");
                FixedAsset.SetFilter("No.", '<>%1', "No.");

                if not FixedAsset.IsEmpty() then begin
                    FixedAsset.FindFirst();
                    Error(
                        'Serial No. %1 is already used on asset %2.',
                        "IT Serial No.",
                        FixedAsset."No.");
                end;
            end;
        }
        field(50205; "IT Asset Tag No."; Code[50])
        {
            Caption = 'Asset Tag No.';

            trigger OnValidate()
            var
                FixedAsset: Record "Fixed Asset";
            begin
                if "IT Asset Tag No." = '' then
                    exit;

                FixedAsset.SetRange("IT Asset Tag No.", "IT Asset Tag No.");
                FixedAsset.SetFilter("No.", '<>%1', "No.");

                if not FixedAsset.IsEmpty() then begin
                    FixedAsset.FindFirst();
                    Error(
                        'Asset Tag No. %1 is already used on asset %2.',
                        "IT Asset Tag No.",
                        FixedAsset."No.");
                end;
            end;
        }
        field(50206; "IT Asset Condition"; Enum "Asset Condition")
        {
            Caption = 'Condition';
        }
        field(50207; "IT Asset Status"; Enum "Asset Status")
        {
            Caption = 'Status';
        }
        field(50208; "Warranty Start Date"; Date)
        {
            Caption = 'Warranty Start Date';
        }
        field(50209; "Warranty End Date"; Date)
        {
            Caption = 'Warranty End Date';
        }
        field(50210; "IT Location Code"; Code[10])
        {
            Caption = 'IT Location Code';
        }
        field(50211; "IT Asset Blocked"; Boolean)
        {
            Caption = 'IT Asset Blocked';
        }
    }

    keys
    {
        key(ITAssetCategory; "Asset Category Code", "Asset Sub Category Code") { }
        key(ITAssetSerialNo; "IT Serial No.") { }
        key(ITAssetTagNo; "IT Asset Tag No.") { }
        key(ITAssetStatus; "IT Asset Status") { }
    }
}