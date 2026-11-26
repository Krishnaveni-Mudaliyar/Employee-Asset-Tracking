enum 50005 "Asset Clearance Action"
{
    Extensible = true;
    
    value(0; Pending)
    {
        Caption = 'Pending';
    }
    value(1; Return)
    {
        Caption = 'Return';
    }
    value(2; Transfer)
    {
        Caption = 'Transfer';
    }
    value(3; "Not Recovered")
    {
        Caption = 'Not Recovered';
    }
}
