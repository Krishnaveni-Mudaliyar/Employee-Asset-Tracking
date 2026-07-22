codeunit 50007 "AST Module Setup"
{
    Access = Public;
    Subtype = Install;

    trigger OnInstallAppPerCompany()
    begin
        CreateNoSeriesIfNotExists();
        CreateDefaultCategories();
        CreateJobQueueEntry();
        InitializeSetup();
    end;

    /* <summary>
     Creates default No. Series for asset assignment, returns, and maintenance.
     FIX #2: Ensures No. Series exist before they are referenced in codeunits.
     </summary> */

    procedure CreateNoSeriesIfNotExists()
    var
        NoSeries: Record "No. Series";
        NoSeriesLine: Record "No. Series Line";
    begin
        // Create AST-ASSIGN No. Series
        if not NoSeries.Get('AST-ASSIGN') then begin
            NoSeries.Init();
            NoSeries."Code" := 'AST-ASSIGN';
            NoSeries."Description" := 'Asset Assignments';
            NoSeries."Default Nos." := true;
            NoSeries.Insert(true);

            NoSeriesLine.Init();
            NoSeriesLine."Series Code" := 'AST-ASSIGN';
            NoSeriesLine."Line No." := 10000;
            NoSeriesLine."Starting No." := 'AST-ASSIGN-001';
            NoSeriesLine."Ending No." := 'AST-ASSIGN-99999';
            NoSeriesLine."Last No. Used" := '';
            NoSeriesLine."Implementation" := NoSeriesLine.Implementation::Normal;
            NoSeriesLine.Insert(true);
        end;

        // Create AST-RETURN No. Series
        if not NoSeries.Get('AST-RETURN') then begin
            NoSeries.Init();
            NoSeries."Code" := 'AST-RETURN';
            NoSeries."Description" := 'Asset Returns';
            NoSeries."Default Nos." := true;
            NoSeries.Insert(true);

            NoSeriesLine.Init();
            NoSeriesLine."Series Code" := 'AST-RETURN';
            NoSeriesLine."Line No." := 10000;
            NoSeriesLine."Starting No." := 'AST-RETURN-001';
            NoSeriesLine."Ending No." := 'AST-RETURN-99999';
            NoSeriesLine."Last No. Used" := '';
            NoSeriesLine."Implementation" := NoSeriesLine.Implementation::Normal;
            NoSeriesLine.Insert(true);
        end;

        // Create AST-MAINT No. Series
        if not NoSeries.Get('AST-MAINT') then begin
            NoSeries.Init();
            NoSeries."Code" := 'AST-MAINT';
            NoSeries."Description" := 'Maintenance';
            NoSeries."Default Nos." := true;
            NoSeries.Insert(true);

            NoSeriesLine.Init();
            NoSeriesLine."Series Code" := 'AST-MAINT';
            NoSeriesLine."Line No." := 10000;
            NoSeriesLine."Starting No." := 'AST-MAINT-001';
            NoSeriesLine."Ending No." := 'AST-MAINT-99999';
            NoSeriesLine."Last No. Used" := '';
            NoSeriesLine."Implementation" := NoSeriesLine.Implementation::Normal;
            NoSeriesLine.Insert(true);
        end;

        // Create AST Asset No. series
        if not NoSeries.Get('AST-ASSET') then begin
            NoSeries.Init();
            NoSeries.Code := 'AST-ASSET';
            NoSeries.Description := 'Assets';
            NoSeries."Default Nos." := true;
            NoSeries.Insert(true);

            NoSeriesLine.Init();
            NoSeriesLine."Series Code" := 'AST-ASSET';
            NoSeriesLine."Line No." := 10000;
            NoSeriesLine."Starting No." := 'AST-ASSET-001';
            NoSeriesLine."Ending No." := 'AST-ASSET-99999';
            NoSeriesLine."Last No. Used" := '';
            NoSeriesLine.Implementation := NoSeriesLine.Implementation::Normal;
            NoSeriesLine.Insert(true);
        end;
    end;

    /* <summary>
    Creates default asset categories if not already present.
    </summary> */
    procedure CreateDefaultCategories()
    var
        ASTAssetCategory: Record "AST Asset Category";
    begin
        if not ASTAssetCategory.Get('COMP') then begin
            ASTAssetCategory.Init();
            ASTAssetCategory."Code" := 'COMP';
            ASTAssetCategory."Description" := 'Computer';
            ASTAssetCategory."Default Maintenance Interval" := 90;
            ASTAssetCategory.Insert(true);
        end;

        if not ASTAssetCategory.Get('PHONE') then begin
            ASTAssetCategory.Init();
            ASTAssetCategory."Code" := 'PHONE';
            ASTAssetCategory."Description" := 'Mobile Device';
            ASTAssetCategory."Default Maintenance Interval" := 120;
            ASTAssetCategory.Insert(true);
        end;

        if not ASTAssetCategory.Get('EQUIP') then begin
            ASTAssetCategory.Init();
            ASTAssetCategory."Code" := 'EQUIP';
            ASTAssetCategory."Description" := 'Office Equipment';
            ASTAssetCategory."Default Maintenance Interval" := 180;
            ASTAssetCategory.Insert(true);
        end;

        if not ASTAssetCategory.Get('OTHER') then begin
            ASTAssetCategory.Init();
            ASTAssetCategory."Code" := 'OTHER';
            ASTAssetCategory."Description" := 'Other';
            ASTAssetCategory."Default Maintenance Interval" := 365;
            ASTAssetCategory.Insert(true);
        end;
    end;

    procedure CreateJobQueueEntry()
    var
        JobQueueEntry: Record "Job Queue Entry";
    begin
        JobQueueEntry.SetRange("Object Type to Run", JobQueueEntry."Object Type to Run"::Codeunit);
        JobQueueEntry.SetRange("Object ID to Run", Codeunit::"AST Notification Management");

        If JobQueueEntry.IsEmpty() then begin
            JobQueueEntry.Init();
            JobQueueEntry."Object Type to Run" := JobQueueEntry."Object Type to Run"::Codeunit;
            JobQueueEntry."Object ID to Run" := Codeunit::"AST Notification Management";
            JobQueueEntry.Description := 'Asset Tracking - Warranty & Maintenance Alerts';
            JobQueueEntry."Recurring Job" := true;
            JobQueueEntry."No. of Minutes between Runs" := 1440; //Once a day
            JobQueueEntry.Status := JobQueueEntry.Status::Ready;
            JobQueueEntry.Insert(true);
        end;
    end;

    procedure InitializeSetup()
    var
        ASTSetup: Record "AST Setup";
    begin
        ASTSetup := ASTSetup.GetSetup();
        if ASTSetup."Asset Nos." = '' then
            ASTSetup."Asset Nos." := 'AST-ASSET';
        if ASTSetup."Assignment Nos." = '' then
            ASTSetup."Assignment Nos." := 'AST-ASSIGN';
        if ASTSetup."Return Nos" = '' then
            ASTSetup."Return Nos" := 'AST-RETURN';
        if ASTSetup."Maintenance Nos." = '' then
            ASTSetup."Maintenance Nos." := 'AST-MAINT';
        ASTSetup.Modify(true);
    end;
}
