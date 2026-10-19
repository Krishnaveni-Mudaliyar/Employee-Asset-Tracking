codeunit 50218 "Asset Stocktake Management"
{
    procedure LoadAssets(var AssetStocktakeHeader: Record "Asset Stocktake Header"): Integer
    var
        AssetStocktakeLine: Record "Asset Stocktake Line";
        FixedAsset: Record "Fixed Asset";
        AssetAssignment: Record "Asset Assignment";
        LineNo: Integer;
        Added: Integer;
    begin
        AssetStocktakeHeader.TestField(Completed, false);
        if (AssetStocktakeHeader."Location Code" = '') and (AssetStocktakeHeader."Employee No." = '') then
            Error('Specify a location or an employee for the stocktake.');

        AssetStocktakeLine.SetRange("Document No.", AssetStocktakeHeader."No.");
        if not AssetStocktakeLine.IsEmpty() then
            Error('Assets are already loaded. Delete the lines first to load again.');
        if AssetStocktakeHeader."Employee No." <> '' then begin
            AssetAssignment.SetRange("Employee No.",
            AssetStocktakeHeader."Employee No.");
            AssetAssignment.SetRange(Active, true);
            if AssetAssignment.FindSet() then
                repeat
                    if FixedAsset.Get(AssetAssignment."Asset No.")
                    then
                        if (AssetStocktakeHeader."Location Code" = '') or (FixedAsset."IT Location Code" = AssetStocktakeHeader."Location Code") then begin
                            LineNo += 10000;
                            InsertLine(AssetStocktakeHeader."No.", LineNo, FixedAsset, AssetStocktakeHeader."Employee No.");
                            Added += 1;
                        end;
                until AssetAssignment.Next() = 0;
        end else begin
            FixedAsset.SetRange("IT Location Code",
            AssetStocktakeHeader."Location Code");
            FixedAsset.SetFilter("IT Asset Status"::Disposed);
            if FixedAsset.FindSet() then
                repeat
                    LineNo += 10000;
                    InsertLine(AssetStocktakeHeader."No.",
                    LineNo, FixedAsset, GetActiveEmployee(FixedAsset."No."));
                    Added += 1;
                until FixedAsset.Next() = 0;
        end;
        exit(Added);
    end;

    procedure CompleteStocktake(var AssetStocktakeHeader: Record "Asset Stocktake Header")
    var
        AssetStocktakeLine: Record "Asset Stocktake Line";
        AssetNotificationManagement: Codeunit "Asset Notification Management";
        MissingCount: Integer;
        MismatchCount: Integer;
    begin
        AssetStocktakeHeader.TestField(Completed, false);

        AssetStocktakeLine.SetRange("Document No.", AssetStocktakeHeader."No.");
        if AssetStocktakeLine.IsEmpty() then
            Error('There are no lines to complete. Load assets first.');
        if AssetStocktakeLine.FindSet(true) then
            repeat
                if not AssetStocktakeLine.Counted then begin
                    AssetStocktakeLine.Result := AssetStocktakeLine.Result::Missing;
                    MissingCount += 1;
                end else
                    if (AssetStocktakeLine."Counted Location Code" <> '') and
                       (AssetStocktakeLine."Expected Location Code" <> '') and
                       (AssetStocktakeLine."Counted Location Code" <> AssetStocktakeLine."Expected Location Code")
                    then begin
                        AssetStocktakeLine.Result := AssetStocktakeLine.Result::Mismatch;
                        MismatchCount += 1;
                    end else
                        AssetStocktakeLine.Result := AssetStocktakeLine.Result::Found;
                AssetStocktakeLine.Modify();
            until AssetStocktakeLine.Next() = 0;

        AssetStocktakeHeader.Completed := true;
        AssetStocktakeHeader."Completed Date" := WorkDate();
        AssetStocktakeHeader.Modify();
        if (MissingCount > 0) or (MismatchCount > 0) then
            AssetNotificationManagement.Notify(
                AssetStocktakeHeader."Created By",
                StrSubstNo('Stocktake %1 completed: %2 missing, %3 in a different location.', AssetStocktakeHeader."No.", MissingCount, MismatchCount),
                AssetStocktakeHeader."No.");
    end;

    local procedure InsertLine(DocumentNo: Code[20]; LineNo: Integer; FixedAsset: Record "Fixed Asset"; ExpectedEmployeeNo: Code[20])
    var
        AssetStocktakeLine: Record "Asset Stocktake Line";
    begin
        AssetStocktakeLine.Init();
        AssetStocktakeLine."Document No." := DocumentNo;
        AssetStocktakeLine."Line No." := LineNo;
        AssetStocktakeLine."Asset No." := FixedAsset."No.";
        AssetStocktakeLine.Description := CopyStr(FixedAsset.Description, 1, MaxStrLen(AssetStocktakeLine.Description));
        AssetStocktakeLine."Expected Employee No." := ExpectedEmployeeNo;
        AssetStocktakeLine."Expected Location Code" := FixedAsset."IT Location Code";
        AssetStocktakeLine.Insert(true);
    end;

    local procedure GetActiveEmployee(AssetNo: Code[20]): Code[20]
    var
        AssetAssignment: Record "Asset Assignment";
    begin
        AssetAssignment.SetRange("Asset No.", AssetNo);
        AssetAssignment.SetRange(Active, true);
        if AssetAssignment.FindFirst() then
            exit(AssetAssignment."Employee No.");
        exit('');
    end;
}