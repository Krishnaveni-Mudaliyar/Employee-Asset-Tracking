table 50000 "AST Asset"
{
    DataClassification = ToBeClassified;
    Caption = 'Asset';
    LookupPageId = "AST Asset List";

    fields
    {
        field(1; "No."; Code[20])
        {
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(2; Description; Text[100])
        {
            DataClassification = CustomerContent;
        }
        field(3; Category; Code[20])
        {
            DataClassification = CustomerContent;
            TableRelation = "AST Asset Category";
        }
        field(4; Status; Enum "AST Asset Status")
        {
            DataClassification = CustomerContent;
        }
        field(5; "Current Employee"; Code[20])
        {
            DataClassification = CustomerContent;
            TableRelation = Employee;
        }
        field(6; "Assignment Date"; Date)
        {
            DataClassification = CustomerContent;
        }
        field(7; "Warranty Expiry Date"; Date)
        {
            DataClassification = CustomerContent;
        }
        field(8; "Last Maintenance Date"; Date)
        {
            DataClassification = CustomerContent;
        }
        field(9; "Maintenance Status"; Enum "AST Maintenance Status")
        {
            DataClassification = CustomerContent;
        }
        field(10; "Maintenance Interval Days"; Integer)
        {
            DataClassification = CustomerContent;
        }
        field(11; Cost; Decimal)
        {
            DataClassification = CustomerContent;
        }
        field(12; "Serial Number"; Code[50])
        {
            DataClassification = CustomerContent;
        }
        field(13; Active; Boolean)
        {
            DataClassification = CustomerContent;
        }
        field(14; "Asset Condition"; Enum "AST Asset Condition")
        {
            DataClassification = CustomerContent;
        }
    }

    keys
    {
        key(PK; "No.") { }
        key(Employee; "Current Employee") { }
        key(Status; Status) { }
    }

    trigger OnInsert()
    var
        ASTSetup: Record "AST Setup";
        NoSeries: Codeunit "No. Series";
    begin
        // No series
        if "No." = '' then begin
            ASTSetup := ASTSetup.GetSetup();
            "No." := NoSeries.GetNextNo(ASTSetup."Asset Nos.", WorkDate());
        end;

        // Maintenance Status
        Active := true;
        Status := Status::Available;
        "Maintenance Status" := "Maintenance Status"::"Not In Maintenance";
    end;
}