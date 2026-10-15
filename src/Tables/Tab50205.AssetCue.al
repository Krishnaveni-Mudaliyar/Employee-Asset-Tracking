table 50205 "Asset Cue"
{
    Caption = 'Asset Cue';
    DataClassification = CustomerContent;

    fields
    {
        field(1; "Primary Key"; Code[10])
        {
            Caption = 'Primary Key';
            DataClassification = SystemMetadata;
        }
        field(10; "Available Assets"; Integer)
        {
            Caption = 'Available Assets';
            FieldClass = FlowField;
            CalcFormula = count("Fixed Asset"
                           where("IT Asset Status" = const(Assigned)));
            Editable = false;
        }
        field(11; "Assigned Assets"; Integer)
        {
            Caption = 'Assigned Assets';
            FieldClass = FlowField;
            CalcFormula = count("Fixed Asset" where("IT Asset Status" = const(Assigned)));
            Editable = false;
        }
        field(12; "Assets Under Maintenance"; Integer)
        {
            Caption = 'Assets Under Maintenance';
            FieldClass = FlowField;
            CalcFormula = count("Fixed Asset" where("IT Asset Status" = const("Under Maintenance")));
            Editable = false;
        }
        field(13; "Pending Requests"; Integer)
        {
            Caption = 'Pending Requests';
            FieldClass = FlowField;
            CalcFormula = count("Asset Request Header" where(Status = const("Pending Approval")));
            Editable = false;
        }
        field(14; "Approved Requests"; Integer)
        {
            Caption = 'Approved Requests To Assign';
            FieldClass = FlowField;
            CalcFormula = count("Asset Request Header" where(Status = const(Approved)));
            Editable = false;
        }
        field(15; "Overdue Returns"; Integer)
        {
            Caption = 'Overdue Returns';
            FieldClass = FlowField;
            CalcFormula = count("Asset Assignment" where(Active = const(true), "Expected Return Date" = field("Overdue Date Filter")));
            Editable = false;
        }
        field(16; "Unread Notifications"; Integer)
        {
            Caption = 'Unread Notifications';
            FieldClass = FlowField;
            CalcFormula = count("Asset Notification" where(Read = const(false), "Recipient User ID" = field("User ID Filter")));
            Editable = false;
        }
        field(30; "Overdue Date Filter"; Date)
        {
            Caption = 'Overdue Date Filter';
            FieldClass = FlowFilter;
        }
        field(31; "User ID Filter"; Code[50])
        {
            Caption = 'User ID Filter';
            FieldClass = FlowFilter;
        }
    }
    keys
    {
        key(PK; "Primary Key")
        {
            Clustered = true;
        }
    }
}