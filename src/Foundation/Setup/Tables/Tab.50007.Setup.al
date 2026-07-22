table 50007 "AST Setup"
{
    DataClassification = SystemMetadata;
    Caption = 'Asset Tracking Setup';

    fields
    {
        field(1; "Primary Key"; Code[10])
        {
            DataClassification = SystemMetadata;
        }
        field(2; "Asset Nos."; Code[20])
        {
            Caption = 'Asset Nos.';
            TableRelation = "No. Series";
        }
        field(3; "Assignment Nos."; Code[20])
        {
            Caption = 'Assignment Nos.';
            TableRelation = "No. Series";
        }
        field(4; "Return Nos"; Code[20])
        {
            Caption = 'Return Nos.';
            TableRelation = "No. Series";
        }
        field(5; "Maintenance Nos."; Code[20])
        {
            Caption = 'Maintenance Nos.';
            TableRelation = "No. Series";
        }
        field(6; "Warranty Alert Lead Days"; Integer)
        {
            caption = 'Warranty Alert Lead Days';
            InitValue = 30;
            MinValue = 0;
        }
        field(7; "Maintenance Alert Lead Days"; Integer)
        {
            caption = 'Maintenance Alert Lead Days';
            InitValue = 7;
            MinValue = 0;
        }
    }
    keys
    {
        key(PK; "Primary Key") { }
    }
    trigger OnInsert()
    begin
        if not Rec.IsEmpty() then
            Error('Only one %1 record can exist.', Rec.TableCaption());
    end;

    procedure GetSetup(): Record "AST Setup"
    var
        ASTSetup: Record "AST Setup";
    begin
        if not ASTSetup.Get() then begin
            ASTSetup.Init();
            ASTSetup.Insert(true);
        end;
        exit(ASTSetup);
    end;
}
