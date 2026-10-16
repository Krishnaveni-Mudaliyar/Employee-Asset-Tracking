codeunit 50217 "Asset Excel Import"
{
    // Expected columns (row 1 = headers, data from row 2):
    // A Description, B Category Code, C Sub Category Code, D Brand Code, E Model No.,
    // F Serial No., G Tag No., H Location Code, I Warranty Start, J Warranty End

    procedure ImportFromStream(var InStr: InStream): Integer
    var
        TempExcelBuffer: Record "Excel Buffer" temporary;
        FixedAsset: Record "Fixed Asset";
        SheetName: Text;
        LastRow: Integer;
        RowNo: Integer;
        Created: Integer;
        Description: Text;
    begin
        SheetName := TempExcelBuffer.SelectSheetsNameStream(InStr);
        if SheetName = '' then
            exit(0);

        TempExcelBuffer.OpenBookStream(InStr, SheetName);
        TempExcelBuffer.ReadSheet();

        TempExcelBuffer.Reset();
        if not TempExcelBuffer.FindLast() then
            exit(0);
        LastRow := TempExcelBuffer."Row No.";
        for RowNo := 2 to LastRow do begin
            Description := GetCell(TempExcelBuffer, RowNo, 1);
            if Description <> '' then begin
                FixedAsset.Init();
                FixedAsset."No." := '';
                FixedAsset.Insert(true);
                FixedAsset.Validate(Description, CopyStr(Description, 1, MaxStrLen(FixedAsset.Description)));
                FixedAsset.Validate("Asset Category Code", CopyStr(GetCell(TempExcelBuffer, RowNo, 2), 1, MaxStrLen(FixedAsset."Asset Category Code")));
                FixedAsset.Validate("Asset Sub Category Code", CopyStr(GetCell(TempExcelBuffer, RowNo, 3), 1, MaxStrLen(FixedAsset."Asset Sub Category Code")));
                FixedAsset.Validate("Asset Brand Code", CopyStr(GetCell(TempExcelBuffer, RowNo, 4), 1, MaxStrLen(FixedAsset."Asset Brand Code")));
                FixedAsset.Validate("IT Model No.", CopyStr(GetCell(TempExcelBuffer, RowNo, 5), 1, MaxStrLen(FixedAsset."IT Model No.")));
                FixedAsset.Validate("IT Serial No.", CopyStr(GetCell(TempExcelBuffer, RowNo, 6), 1, MaxStrLen(FixedAsset."IT Serial No.")));
                FixedAsset.Validate("IT Asset Tag No.", CopyStr(GetCell(TempExcelBuffer, RowNo, 7), 1, MaxStrLen(FixedAsset."IT Asset Tag No.")));
                FixedAsset.Validate("IT Location Code", CopyStr(GetCell(TempExcelBuffer, RowNo, 8), 1, MaxStrLen(FixedAsset."IT Location Code")));
                FixedAsset.Validate("Warranty Start Date", GetDateCell(TempExcelBuffer, RowNo, 9));
                FixedAsset.Validate("Warranty End Date", GetDateCell(TempExcelBuffer, RowNo, 10));
                FixedAsset.Modify(true);
                Created += 1;
            end;
        end;
        exit(Created);
    end;

    local procedure GetCell(var TempExcelBuffer: Record "Excel Buffer" temporary; RowNo: Integer; ColNo: Integer): Text
    begin
        if TempExcelBuffer.Get(RowNo, ColNo) then
            exit(DelChr(TempExcelBuffer."Cell Value as Text", '<>', ' '));
        exit('');
    end;

    local procedure GetDateCell(var TempExcelBuffer: Record "Excel Buffer" temporary; RowNo: Integer; ColNo: Integer): Date
    var
        CellText: Text;
        Result: Date;
    begin
        CellText := GetCell(TempExcelBuffer, RowNo, ColNo);
        if CellText = '' then
            exit(0D);
        if not Evaluate(Result, CellText) then
            Error('Row %1, column %2: "%3" is not a valid date.', RowNo, ColNo, CellText);
        exit(Result);
    end;
}