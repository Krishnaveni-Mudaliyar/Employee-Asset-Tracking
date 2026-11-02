enum 50204 "Asset Stocktake Result"
{
    Extensible = true;
    
    value(0; Pending)
    {
        Caption = 'Pending';
    }
    value(1; Found)
    {
        Caption = 'Found';
    }
    value(2; Missing)
    {
        Caption = 'Missing';
    }
    value(3; Mismatch)
    {
        Caption = 'Mismatch';
    }
}
