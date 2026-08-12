enum 50000 "Asset Status"
{
    Extensible = true;
    
    value(0; Available)
    {
        Caption = 'Available';
    }
    value(1; Requested)
    {
        Caption = 'Requested';
    }
    value(2; Assigned)
    {
        Caption = 'Assigned';
    }
    value(3; Returned)
    {
        Caption = 'Returned';
    }
    value(4; "Under Maintenance")
    {
        Caption = 'Under Maintenance';
    }
    value(5; Transferred)
    {
        Caption = 'Transferred';
    }
    value(6; Disposed)
    {
        Caption = 'Disposed';
    }
    value(7; Blocked)
    {
        Caption = 'Blocked';
    }
}
