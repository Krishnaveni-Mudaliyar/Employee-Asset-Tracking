table 50011 "Asset Cue"
{
    Caption = 'Asset Cue';
    DataClassification = SystemMetadata;

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
            CalcFormula = count("Fixed Asset" where("Asset Status" = const(Available), Blocked = const(false)));
            Editable = false;
        }
        field(11; "Assigned Assets"; Integer)
        {
            Caption = 'Assigned Assets';
            FieldClass = FlowField;
            CalcFormula = count("Fixed Asset" where("Asset Status" = const(Assigned)));
            Editable = false;
        }
        field(12; "Assets Under Maintenance"; Integer)
        {
            Caption = 'Assets Under Maintenance';
            FieldClass = FlowField;
            CalcFormula = count("Fixed Asset" where("Asset Status" = const("Under Maintenance")));
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
        field(17; "Open Requests"; Integer)
        {
            Caption = 'Open Requests';
            FieldClass = FlowField;
            CalcFormula = count("Asset Request Header" where(Status = const(Open)));
            Editable = false;
        }
        field(18; "Disposed Assets"; Integer)
        {
            Caption = 'Disposed Assets';
            FieldClass = FlowField;
            CalcFormula = count("Fixed Asset" where("Asset Status" = const(Disposed)));
            Editable = false;
        }
        field(19; "Due This Week"; Integer)
        {
            Caption = 'Due This Week';
            FieldClass = FlowField;
            CalcFormula = count("Asset Assignment" where(Active = const(true), "Expected Return Date" = field("Due Date Filter")));
            Editable = false;
        }
        field(20; "Pending Approvals"; Integer)
        {
            Caption = 'Pending Approvals';
            FieldClass = FlowField;
            CalcFormula = count("Asset Request Header" where(Status = const("Pending Approval")));
            Editable = false;
        }
        field(21; "Expiring Warranties"; Integer)
        {
            Caption = 'Expiring Warranties';
            FieldClass = FlowField;
            CalcFormula = count("Fixed Asset" where(Blocked = const(false), "Warranty End Date" = field("Warranty Date Filter")));
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
        field(32; "Due Date Filter"; Date)
        {
            Caption = 'Due Date Filter';
            FieldClass = FlowFilter;
        }
        field(33; "Warranty Date Filter"; Date)
        {
            Caption = 'Warranty Date Filter';
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