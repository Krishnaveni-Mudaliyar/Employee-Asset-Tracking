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

            end;
        }
        field(50202; "Brand Code"; Code[20])
        {
            Caption = 'Brand Code';
            DataClassification = ToBeClassified;
        }
        field(50203; "Serial No"; Text[50])
        {
            Caption = 'Serial No.';
            DataClassification = ToBeClassified;
        }
        field(50204; "Asset Tag No."; Code[20])
        {
            Caption = 'Asset Tag No.';
            DataClassification = ToBeClassified;
        }
        field(50205; "IT Asset Condition"; Enum "Asset Condition")
        {
            Caption = 'IT Asset Condition';
            DataClassification = ToBeClassified;
        }
        field(50206; "Warranty Start Date"; Date)
        {
            Caption = 'Warranty Start Date';
            DataClassification = ToBeClassified;
        }
        field(50207; "Warranty End Date"; Date)
        {
            Caption = 'Warranty End Date';
            DataClassification = ToBeClassified;
        }
        field(50208; "IT Asset Status"; Enum "Asset Status")
        {
            Caption = 'IT Asset Status';
            DataClassification = ToBeClassified;
        }
    }
}
