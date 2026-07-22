codeunit 50010 "AST Approval Management"
{
    procedure SubmitAssignmentRequest(AssetNo: Code[20]; EmployeeNo: Code[20]; Comments: Text[250]): Code[20]
    var
        Request: Record "AST Approval Request";
    begin
        Request.Init();
        Request."No." := CopyStr(Format(CreateGuid()), 1, MaxStrLen(Request."No."));
        Request."Asset No." := AssetNo;
        Request."Requested Employee No." := EmployeeNo;
        Request."Request Type" := Request."Request Type"::Assignment;
        Request.Status := Request.Status::Pending;
        Request."Requested By" := CopyStr(UserId, 1, MaxStrLen(Request."Requested By"));
        Request."Requested At" := CurrentDateTime;
        Request.Comments := Comments;
        Request.Insert(true);
        exit(Request."No.");
    end;

    procedure Approve(var Request: Record "AST Approval Request")

    var
        ASTAsset: Record "AST Asset";
        AssignmentMgt: Codeunit "AST Asset Assignment";
        AssignmentNo: Code[20];

    begin
        Request.TestField(Status, Request.Status::Pending);

        case Request."Request Type" of
            Request."Request Type"::Assignment:
                begin
                    ASTAsset.Get(Request."Asset No.");
                    AssignmentNo := AssignmentMgt.AssignAsset(ASTAsset, Request."Requested Employee No.", Request.Comments);
                    Request."Assignment No." := AssignmentNo;
                end;
        end;
        Request.Status := Request.Status::Approved;
        Request."Decision By" := CopyStr(UserId, 1, MaxStrLen(Request."Decision By"));
        Request."Decision At" := CurrentDateTime;
        Request.Modify(true);
    end;

    procedure Reject(var Request: Record "AST Approval Request")
    begin
        Request.TestField(Status, Request.Status::Pending);
        Request.Status := Request.Status::Rejected;
        Request."Decision By" := CopyStr(UserId, 1, MaxStrLen(Request."Decision By"));
        Request."Decision At" := CurrentDateTime;
        Request.Modify(true);
    end;
}