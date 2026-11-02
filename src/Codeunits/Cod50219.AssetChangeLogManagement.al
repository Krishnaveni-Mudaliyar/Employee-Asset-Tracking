codeunit 50219 "Asset Change Log Management"
{
    procedure EnableChangeLog()
    var
        ChangeLogSetup: Record "Change Log Setup";
    begin
        if not ChangeLogSetup.Get() then begin
            ChangeLogSetup.Init();
            ChangeLogSetup.Insert();
        end;
        if not ChangeLogSetup."Change Log Activated" then begin
            ChangeLogSetup."Change Log Activated" := true;
            ChangeLogSetup.Modify();
        end;

        EnableTable(Database::"Asset Request Header");
        EnableTable(Database::"Asset Request Header");
        EnableTable(Database::"Asset Request Line");
        EnableTable(Database::"Asset Assignment");
        EnableTable(Database::"Asset Return");
        EnableTable(Database::"Asset Transfer");
        EnableTable(Database::"Asset Maintenance");
        EnableTable(Database::"Asset Disposal");
        EnableTable(Database::"Asset Stocktake Header");
        EnableTable(Database::"Asset Category");
        EnableTable(Database::"Asset Sub Category");
        EnableTable(Database::"Asset Brand");
        EnableTable(Database::"Asset Setup");
    end;

    local procedure EnableTable(TableNo: Integer)
    var
        ChangeLogSetupTable: Record "Change Log Setup (Table)";
    begin
        if not ChangeLogSetupTable.Get(TableNo) then begin
            ChangeLogSetupTable.Init();
            ChangeLogSetupTable."Table No." := TableNo;
            ChangeLogSetupTable.Insert();
        end;

        ChangeLogSetupTable."Log Insertion" := ChangeLogSetupTable."Log Insertion"::"All Fields";
        ChangeLogSetupTable."Log Modification" := ChangeLogSetupTable."Log Modification"::"All Fields";
        ChangeLogSetupTable."Log Deletion" := ChangeLogSetupTable."Log Deletion"::"All Fields";
        ChangeLogSetupTable.Modify();
    end;
}