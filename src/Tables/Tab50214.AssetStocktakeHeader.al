table 50214 "Asset Stocktake Header"
{
    Caption = 'Asset Stocktake Header';
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
        field(3; "Location Code"; Code[10])
        {
            Caption = 'Location Code';
            TableRelation = Location.Code;
        }
        field(4; "Employee No."; Code[20])
        {
            Caption = 'Employee No.';
            TableRelation = Employee."No.";
        }
        field(5; "Created Date"; Date)
        {
            Caption = 'Created Date';
            Editable = false;
        }
        field(6; "Created By"; Code[50])
        {
            Caption = 'Created By';
            Editable = false;
        }
        field(7; Completed; Boolean)
        {
            Caption = 'Completed';
            Editable = false;
        }
        field(8; "Completed Date"; Date)
        {
            Caption = 'Completed Date';
            Editable = false;
        }
    }
    keys
    {
        key(PK; "No.")
        {
            Clustered = true;
        }
    }

    trigger OnInsert()
    var
        AssetSetupManagement: Codeunit "Asset Setup Management";
    begin
        if "No." = '' then
            "No." := AssetSetupManagement.GetStocktakeNo();
        "Created Date" := WorkDate();
        "Created By" := CopyStr(UserId(), 1, MaxStrLen("Created By"));
    end;

    trigger OnDelete()
    var
        AssetStocktakeLine: Record "Asset Stocktake Line";
    begin
        AssetStocktakeLine.SetRange("Document No.", "No.");
        AssetStocktakeLine.DeleteAll();
    end;
}