table 50006 "Asset Request Line"
{
    Caption = 'Asset Request Line';
    DataClassification = CustomerContent;

    fields
    {
        field(1; "Document No."; Code[20])
        {
            Caption = 'Document No.';
            TableRelation = "Asset Request Header"."No.";
        }
        field(2; "Line No."; Integer)
        {
            Caption = 'Line No.';
            DataClassification = SystemMetadata;
        }
        field(3; "Asset Category Code"; Code[20])
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
                        'Asset Category %1 is blocked and cannot be requested.', "Asset Category Code");
            end;
        }
        field(4; "Asset Sub Category Code"; Code[20])
        {
            Caption = 'Asset Sub Category Code';
            TableRelation = "Asset Sub Category".Code;

            trigger OnValidate()
            var
                AssetSubCategory: Record "Asset Sub Category";
            begin
                if "Asset Sub Category Code" = '' then
                    exit;

                AssetSubCategory.Get("Asset Sub Category Code");

                if AssetSubCategory.Blocked then
                    Error(
                        'Asset sub category %1 is blocked and cannot be requested.', "Asset Sub Category Code");

                if ("Asset Category Code" <> '') and
                        (AssetSubCategory."Category Code" <> "Asset Category Code")
                        then
                    Error(
                        'Asset sub category %1 does not belong to asset category %2.',
                        "Asset Sub Category Code",
                        "Asset Category Code");
            end;
        }
        field(5; Description; Text[100])
        {
            Caption = 'Description';
        }
        field(6; Quantity; Decimal)
        {
            Caption = 'Quantity';
            DecimalPlaces = 0 : 0;

            trigger OnValidate()
            begin
                if Quantity <= 0 then
                    Error(
                        'Quantity must be greater than zero.');
            end;
        }
        field(7; "Approved Quanity"; Decimal)
        {
            Caption = 'Approved Quanity';
            DecimalPlaces = 0 : 0;

            trigger OnValidate()
            begin
                if "Approved Quanity" < 0 then
                    Error(
                        'Approved Quantity cannot be negative.');

                if "Approved Quanity" > Quantity then
                    Error(
                        'Approved Quantity cannot be greater than quantity.');
            end;
        }
        field(8; "Assigned Quanity"; Decimal)
        {
            Caption = 'Assigned Quanity';
            DecimalPlaces = 0 : 0;
            Editable = false;

            trigger OnValidate()
            begin
                if "Assigned Quanity" < 0 then
                    Error(
                        'Assigned Quantity cannot be negative.');

                if "Assigned Quanity" > "Approved Quanity" then
                    Error(
                        'Assigned Quantity cannot be greater than approved quanity.');
            end;
        }
        field(9; Status; Enum "Asset Request Status")
        {
            Caption = 'Status';
        }
    }
    keys
    {
        key(PK; "Document No.")
        {
            Clustered = true;
        }
        key(Category; "Asset Category Code", "Asset Sub Category Code") { }
    }
}