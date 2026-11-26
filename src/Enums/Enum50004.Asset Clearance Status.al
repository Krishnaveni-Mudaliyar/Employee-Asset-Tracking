enum 50004 "Asset Clearance Status"
{
    Extensible = true;

    value(0; Open)
    {
        Caption = 'Open';
    }
    value(1; Cleared)
    {
        Caption = 'Cleared';
    }
    value(2; Cancelled)
    {
        Caption = 'Cancelled';
    }
    value(3; "")
    {
        Caption = '';
    }
}