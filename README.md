# Employee-Asset-Tracking

An AL extension for Microsoft Dynamics 365 Business Central that manages the full lifecycle of company assets issued to employees — asset master data, categorization, and an employee-initiated, approval-driven asset request process.

- **Publisher:** Krishnaveni Mudaliyar
- **App ID:** `26497bdb-0f00-4aae-8ac1-73b71d040ef8`
- **Object ID range:** 50201–50500
- **Target application:** Business Central 28.0
- **Runtime:** 17.0

## Prerequisites

1. Configure number series for Asset Nos. and Asset Request Nos. in **Asset Setup** before creating any assets or requests — both `GetAssetNo()` and `GetAssetRequestNo()` raise an error if their series isn't set.
2. Configure a Business Central workflow against the `Asset Request Header` table if you want approvals to go through the standard Approval Entry process (see Workflow Integration below).

## What's Included

### Setup
| Object | ID | Purpose |
|---|---|---|
| `Asset Setup` (Table/Page) | 50201 | Singleton setup record holding number series for Assets, Asset Requests, Assignments, Returns, Transfers, Maintenance, and Disposals |
| `Asset Setup Management` (Codeunit) | 50201 | Retrieves/initializes the setup singleton; generates the next Asset No. and Asset Request No. |

### Master Data
| Object | ID | Purpose |
|---|---|---|
| `Asset Category` (Table/Card/List) | 50202 / 50208 | Top-level asset categorization, with a Blocked flag |
| `Asset Sub Category` (Table/Card/List) | 50203 / 50209 | Sub-categorization linked to a parent Asset Category, with a Blocked flag |
| `Asset Brand` (Table/Card/List) | 50204 / 50210 | Brand master, with a Blocked flag |
| `Asset` (Table/Card/List) | 50205 / 50211 | The asset master record: category/sub-category/brand, model/serial/tag numbers, purchase details, location, status, condition, and warranty dates |

### Asset Requests (document)
| Object | ID | Purpose |
|---|---|---|
| `Asset Request Header` (Table) | 50206 | Header for an employee's asset request — employee, dates, department/location, reason, status, and approval audit fields |
| `Asset Request Line` (Table) | 50207 | Requested asset category/sub-category, description, quantity, approved quantity, assigned quantity, and line status |
| `Asset Request Card` (Page) | 50206 | Document page with a Lines subpage and Send for Approval / Cancel Approve Request actions |
| `Asset Request Subpage` (Page) | 50207 | Editable lines grid for the Asset Request Card |
| `Asset Request List` (Page) | 50212 | List view of all asset requests |

### Workflow / Approval
| Object | ID | Purpose |
|---|---|---|
| `Asset Request Management` (Codeunit) | 50202 | Validates a request (No., Employee No., must be Open status) and raises `OnSendAssetRequestForApproval` |
| `Asset Request Workflow Respons` (Codeunit) | 50203 | Registers a custom workflow response ("Set asset request status to pending approval") in the BC Workflow library and executes it |
| `Asset Request Approval Mgmt.` (Codeunit) | 50204 | Checks whether an asset request has an open Approval Entry |
| `Asset Request Workflow Events` (Codeunit) | 50205 | Registers the custom workflow event ("An asset request is sent for approval") and fires it, plus registers the table relation to Approval Entry |

## Functional Behavior

### Enums
- **Asset Status** (50201): Available, Requested, Assigned, Returned, Under Maintenance, Transferred, Disposed, Blocked
- **Asset Condition** (50202): New, Good, Fair, Damaged, Under Repair, Beyond Repair
- **Asset Request Status** (50203): Open, Pending Approval, Approved, Rejected, Cancelled, Closed

### Master data validation
- An `Asset`'s Category, Sub Category, and Brand fields all validate against their respective Blocked flags and refuse a blocked value.
- A Sub Category must belong to the Category selected on the same record (checked both on the Asset and on Asset Request Lines); the system also walks up to check whether the sub-category's parent category is blocked.
- Asset Request Line enforces `Quantity > 0`, `0 ≤ Approved Quantity ≤ Quantity`, and `0 ≤ Assigned Quantity ≤ Approved Quantity`.

### Numbering
- New Asset and Asset Request records get their No. from the series configured in Asset Setup (`GetAssetNo`/`GetAssetRequestNo`), assigned on insert if left blank.
- A new Asset Request also defaults Request Date to `WorkDate()`, stamps Requested By (current user) and Created Date-Time, and sets Status to Open.

### Send for Approval flow
1. **Asset Request Card → Send for Approval** calls `Asset Request Management.SendForApproval`, which requires No. and Employee No. to be filled and the request to currently be **Open**.
2. This raises the `OnSendAssetRequestForApproval` integration event on `Asset Request Header`.
3. `Asset Request Workflow Events` catches that event and hands it to BC's `Workflow Management`, driving the custom workflow event `RUNWORKFLOWONSENDASSETREQUESTFORAPPROVAL`.
4. The workflow response registered by `Asset Request Workflow Respons` (`SETASSETREQUESTPENDINGAPPROVAL`) sets the request's Status to **Pending Approval** once the workflow's approval-request step executes.
5. `Asset Request Approval Mgmt.` exposes `HasPendingApproval` to check for an open Approval Entry against a given request.

> Note: the **Cancel Approve Request** action on the Asset Request Card currently raises a placeholder error — it's not yet wired to the standard approval cancellation process.

## Setup

1. Publish the extension (`Krishnaveni Mudaliyar_Employee-Asset-Tracking_1.0.0.0.app`) to your Business Central environment.
2. Open **Asset Setup** and configure number series for at least Asset Nos. and Asset Request Nos.
3. Create Asset Categories, Sub Categories, and Brands as needed.
4. Set up a Business Central workflow on the Asset Request Header table using the "An asset request is sent for approval" event and the "Set asset request status to pending approval" response (plus the standard Create Approval Requests response) to drive the Pending Approval → Approved/Rejected flow.
5. Start creating Assets and Asset Requests.

## Project Structure

```
Employee-Asset-Tracking/
├── app.json
├── src/
│   ├── Codeunits/
│   │   └── Cod50201.AssetSetupManagement.al
│   ├── Enums/
│   │   ├── Enum50201.AssetStatus.al
│   │   ├── Enum50202.AssetCondition.al
│   │   └── Enum50203.AssetRequestStatus.al
│   ├── Pages/
│   │   ├── Card Pages/
│   │   │   ├── Pag50201.AssetSetup.al
│   │   │   ├── Pag50202.AssetCategoryCard.al
│   │   │   ├── Pag50203.AssetSubCategoryCard.al
│   │   │   ├── Pag50204.AssetBrandCard.al
│   │   │   └── Pag50205.AssetCard.al
│   │   ├── Document/
│   │   │   ├── Pag50206.AssetRequestCard.al
│   │   │   └── Pag50207.AssetRequestSubpage.al
│   │   └── List Pages/
│   │       ├── Pag50208.AssetCategoryList.al
│   │       ├── Pag50209.AssetSubCategoryList.al
│   │       ├── Pag50210.AssetBrandList.al
│   │       ├── Pag50211.AssetList.al
│   │       └── Pag50212.AssetRequestList.al
│   ├── Tables/
│   │   ├── Tab50201.AssetSetup.al
│   │   ├── Tab50202.AssetCategory.al
│   │   ├── Tab50203.AssetSubCategory.al
│   │   ├── Tab50204.AssetBrand.al
│   │   ├── Tab50205.Asset.al
│   │   ├── Tab50206.AssetRequestHeader.al
│   │   └── Tab50207.AssetRequestLine.al
│   └── Workflows/
│       ├── Cod50202.AssetRequestManagement.al
│       ├── Cod50203.AssetRequestWorkflowRespons.al
│       ├── Cod50204.AssetRequestApprovalMgmt.al
│       └── Cod50205.AssetRequestWorkflowEvents.al
```

## Known Gaps

- **Cancel Approve Request** action is a stub (raises an explanatory error rather than cancelling the approval).
- No page/action currently transitions a request from **Approved** to **Assigned/Closed**, or handles Returns, Transfers, Maintenance, or Disposals, even though number series for those are already defined in Asset Setup — these look like planned next phases of the module.
- Minor field-name typos carried from the source (`Approved Quantity`, `Assigned Quantity`) — kept as-is here to match the actual field names in code.
