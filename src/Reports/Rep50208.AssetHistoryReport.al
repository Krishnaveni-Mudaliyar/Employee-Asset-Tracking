report 50208 "Asset History Report"
{
    ApplicationArea = All;
    Caption = 'Asset History Report';
    UsageCategory = ReportsAndAnalysis;
    DefaultLayout = Excel;
    ExcelLayout = 'src\Report Layouts\AssetHistoryReport.xlsx';

    dataset
    {
        dataitem(FixedAsset; "Fixed Asset")
        {
            RequestFilterFields = "No.", "Asset Category Code", "IT Asset Status";

            column(AssetNo; "No.") { }
            column(AssetDescription; Description) { }

            dataitem(Events; Integer)
            {
                DataItemTableView = sorting(Number);
                column(EventDate; EventDateText) { }
                column(EventType; EventTypeText) { }
                column(DocumentNo; EventDocText) { }
                column(Details; EventDetailText) { }
                column(PerformedBy; EventByText) { }

                trigger OnPreDataItem()
                begin
                    SetRange(Number, 1, EventDates.Count());
                end;

                trigger OnAfterGetRecord()
                begin
                    EventDateText := EventDates.Get(Number);
                    EventTypeText := EventTypes.Get(Number);
                    EventDocText := EventDocs.Get(Number);
                    EventDetailText := EventDetails.Get(Number);
                    EventByText := EventBys.Get(Number);
                end;
            }
            trigger OnAfterGetRecord()
            begin
                Clear(EventDates);
                Clear(EventTypes);
                Clear(EventDocs);
                Clear(EventDetails);
                Clear(EventBys);
                LoadAssignments();
                LoadReturns();
                LoadTransfers();
                LoadMaintenance();
                LoadDisposals();
            end;
        }
    }
    local procedure AddEvent(EventDate: Date; EventType: Text; DocNo: Text; Details: Text; PerformedBy: Text)
    begin
        EventDates.Add(Format(EventDate, 0, '<Year4>-<Month,2>-<Day,2>'));
        EventTypes.Add(EventType);
        EventDocs.Add(DocNo);
        EventDetails.Add(Details);
        EventBys.Add(PerformedBy);
    end;

    local procedure EmpName(EmployeeNo: Code[20]): Text
    var
        Employee: Record Employee;
    begin
        if EmployeeNo = '' then
            exit('');
        if Employee.Get(EmployeeNo) then
            exit(DelChr(Employee."First Name" + ' ' + Employee."Last Name", '<>', ' '));
        exit(EmployeeNo);
    end;

    local procedure LoadAssignments()
    var
        Rec: Record "Asset Assignment";
    begin
        Rec.SetRange("Asset No.", FixedAsset."No.");
        if Rec.FindSet() then
            repeat
                AddEvent(Rec."Assignment Date", 'Assigned', Rec."No.", 'To ' + EmpName(Rec."Employee No."), Rec."Assigned By");
            until Rec.Next() = 0;
    end;

    local procedure LoadReturns()
    var
        Rec: Record "Asset Return";
    begin
        Rec.SetRange("Asset No.", FixedAsset."No.");
        if Rec.FindSet() then
            repeat
                AddEvent(Rec."Return Date", 'Returned', Rec."No.",
                    'From ' + EmpName(Rec."Employee No.") + ', condition ' + Format(Rec.Condition), Rec."Returned By");
            until Rec.Next() = 0;
    end;

    local procedure LoadTransfers()
    var
        Rec: Record "Asset Transfer";
    begin
        Rec.SetRange("Asset No.", FixedAsset."No.");
        if Rec.FindSet() then
            repeat
                AddEvent(Rec."Transfer Date", 'Transferred', Rec."No.",
                    EmpName(Rec."From Employee No.") + ' -> ' + EmpName(Rec."To Employee No.") +
                    ' (' + Rec."From Location Code" + ' -> ' + Rec."To Location Code" + ')', Rec."Transferred By");
            until Rec.Next() = 0;
    end;

    local procedure LoadMaintenance()
    var
        Rec: Record "Asset Maintenance";
    begin
        Rec.SetRange("Asset No.", FixedAsset."No.");
        if Rec.FindSet() then
            repeat
                AddEvent(Rec."Start Date", 'Maintenance', Rec."No.", Rec.Description, Rec."Logged By");
            until Rec.Next() = 0;
    end;

    local procedure LoadDisposals()
    var
        Rec: Record "Asset Disposal";
    begin
        Rec.SetRange("Asset No.", FixedAsset."No.");
        if Rec.FindSet() then
            repeat
                AddEvent(Rec."Disposal Date", 'Disposed', Rec."No.", Rec.Reason, Rec."Disposed By");
            until Rec.Next() = 0;
    end;

    var
        EventDates: List of [Text];
        EventTypes: List of [Text];
        EventDocs: List of [Text];
        EventDetails: List of [Text];
        EventBys: List of [Text];
        EventDateText: Text[20];
        EventTypeText: Text[30];
        EventDocText: Text[20];
        EventDetailText: Text[250];
        EventByText: Text[50];
}