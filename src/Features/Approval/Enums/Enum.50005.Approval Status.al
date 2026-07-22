enum 50005 "AST Approval Status"
{
    Extensible = false;
    Caption = 'Approval Status';

    value(0; Open)
    {
        Caption = 'Open';
    }
    value(1; Pending)
    {
        Caption = 'Pending Approval';
    }
    value(2; Approved)
    {
        Caption = 'Approved';
    }
    value(3; Rejected)
    {
        Caption = 'Rejected';
    }
    value(4; Cancelled)
    {
        Caption = 'Cancelled';
    }
}
