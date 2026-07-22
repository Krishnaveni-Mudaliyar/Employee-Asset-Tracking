# Employee Asset Tracking — File Architecture Blueprint

## Purpose and conventions

This is the master development plan for the Employee Asset Tracking extension. It is intentionally a file-level contract: every object has a stable ID, a target path, a single responsibility, and documented dependencies. `✓` means that an object currently exists in the repository; `○` means planned work. Planned files are not represented as empty AL objects, because empty placeholders can make the extension fail compilation and create a misleading release artifact.

## Product composition

The repository currently contains one deployable extension. That is a practical baseline for validating the core domain, but the recommended commercial-product target is a multi-app repository. Each app retains the feature-oriented organization described below; the split controls dependency direction and release ownership rather than changing the domain model.

```text
apps/
├── EmployeeAssetTracking.Foundation/    # setup, permissions, audit, shared contracts
├── EmployeeAssetTracking.Core/          # asset, assignment, return, transfer, maintenance
├── EmployeeAssetTracking.API/           # versioned API pages and webhooks
├── EmployeeAssetTracking.Integration/   # Graph, SharePoint, Blob, HRMS, Power Automate
├── EmployeeAssetTracking.Reporting/     # reports, layouts, queries, dashboards
├── EmployeeAssetTracking.PowerBI/       # Power BI datasets and refresh orchestration
├── EmployeeAssetTracking.AI/            # optional Copilot providers and prompt contracts
├── EmployeeAssetTracking.Tests/         # test app; depends on production apps only
└── EmployeeAssetTracking.DemoData/      # optional, non-production demonstration data
```

`Foundation` has no dependency on the other product apps. `Core` depends on `Foundation`; optional apps depend on `Core` and/or `Foundation`; `Tests` depends inward only. `DemoData` must never be a production dependency. An `EmployeeAssetTracking.DevOps` *folder* remains at repository level because it contains pipeline assets rather than a Business Central app.

| Prefix | Meaning |
|---|---|
| `AST` | Employee Asset Tracking application object |
| `50000–54999` | Application data, UI, and shared foundation |
| `55000–57999` | Tests and test support |
| `58000–58999` | Integration/API/XMLPorts |
| `59000–60000` | Upgrade, installation, and reserved growth |

## Current implementation inventory

The existing implementation is kept under `src/` while the extension is stabilized. New work follows the feature-oriented target paths below. During the multi-app consolidation milestone, current objects are moved without changing their IDs or captions, and each resulting app receives a separate manifest, source folder, test scope, and dependency declaration.

| Status | Current file | Object |
|---|---|---|
| ✓ | `src/Features/Asset/**` | Asset master, category, enum, UI, factbox, employee extension |
| ✓ | `src/Features/Assignment/**`, `Return/**`, `Transfer/**` | Assignment lifecycle and dialogs |
| ✓ | `src/Features/Maintenance/**`, `Warranty/**` | Maintenance data, monitoring job, and warranty analytics |
| ✓ | `src/Features/Approval/**`, `Workflow/**`, `Notifications/**` | Approval request, workflow policy, and notifications |
| ✓ | `src/Foundation/**` | Setup, permissions, audit, and upgrade objects |
| ✓ | `src/Features/API/**`, `Integration/**` | API pages and integration seam |
| ✓ | `src/Features/Statistics/**`, `Dashboard/**`, `Reporting/**` | Analytics queries, report, and layout |
| ✓ | `src/Tests/**` | Assignment, maintenance, and exit validation tests |

## Feature object catalog

### Foundation and security

| ID | File | Purpose | Depends on |
|---:|---|---|---|
| 50007 | `Foundation/Setup/AssetSetup.Table.al` | Global module settings | No. Series |
| 50010 | `Foundation/Setup/AssetSetup.Page.al` | Setup UI | 50007 |
| 50000–50003 | `Foundation/Permissions/*.PermissionSet.al` | Admin, manager, user, viewer roles | Application objects |
| 50090 | `Foundation/Install/Install.Codeunit.al` | Seed/setup on installation | 50007 |
| 50009 | `Foundation/Upgrade/Upgrade.Codeunit.al` | Data upgrades | Prior app version |
| 50008 | `Foundation/Audit/AuditLog.Table.al` | Immutable business audit trail | All service codeunits |
| 50008 | `Foundation/Audit/AuditManagement.Codeunit.al` | Audit writer | Audit Log |

### Asset feature

| ID | File | Purpose | Depends on |
|---:|---|---|---|
| 50000 | `Features/Asset/Tables/EmployeeAsset.Table.al` | Asset master | Setup, enums |
| 50001 | `Features/Asset/Tables/AssetCategory.Table.al` | Asset classification | — |
| 50014 | `Features/Asset/Tables/AssetModel.Table.al` | Manufacturer/model catalogue | Asset Category |
| 50015 | `Features/Asset/Tables/AssetLocation.Table.al` | Asset locations | — |
| 50016 | `Features/Asset/Tables/AssetDocument.Table.al` | Document metadata | Asset |
| 50000 | `Features/Asset/Pages/EmployeeAssetList.Page.al` | Asset workspace | Asset |
| 50003 | `Features/Asset/Pages/EmployeeAssetCard.Page.al` | Asset maintenance card | Asset |
| 50002 | `Features/Asset/Pages/AssetCategoryList.Page.al` | Category list | Category |
| 50023 | `Features/Asset/Pages/AssetLocationList.Page.al` | Location list | Location |
| 50024 | `Features/Asset/Pages/AssetModelList.Page.al` | Model list | Model |
| 50005 | `Features/Asset/FactBoxes/AssetStatistics.FactBox.Page.al` | KPIs on asset | Asset, Assignment |
| 50025 | `Features/Asset/FactBoxes/AssetHistory.FactBox.Page.al` | Recent activity | Audit Log |
| 50026 | `Features/Asset/FactBoxes/AssetDocuments.FactBox.Page.al` | Attached documents | Asset Document |
| 50030 | `Features/Asset/Codeunits/AssetManagement.Codeunit.al` | Asset lifecycle service | Asset, Audit |
| 50031 | `Features/Asset/Codeunits/AssetValidation.Codeunit.al` | Validation policy | Asset |
| 50032 | `Features/Asset/Codeunits/AssetEvents.Codeunit.al` | Integration events | Asset |
| 50033 | `Features/Asset/Codeunits/AssetSubscribers.Codeunit.al` | Domain subscribers | Asset Events |
| 50000 | `Features/Asset/Queries/AssetStatistics.Query.al` | Power BI metrics | Asset |
| 50005 | `Features/Asset/Queries/AssetKPI.Query.al` | KPI dataset | Asset |
| 50000 | `Features/Asset/Reports/AssetRegister.Report.al` | Register report | Asset |
| 50001 | `Features/Asset/Reports/AssetHistory.Report.al` | History report | Audit Log |
| 50002 | `Features/Asset/Reports/AssetInventory.Report.al` | Inventory report | Asset, Location |
| 50020 | `Features/Asset/API/EmployeeAsset.API.Page.al` | Public asset API | Asset |

### Assignment, transfer, return and exit

| ID | File | Purpose | Depends on |
|---:|---|---|---|
| 50002 | `Features/Assignment/Tables/AssetAssignment.Table.al` | Assignment header | Asset, Employee |
| 50003 | `Features/Assignment/Tables/AssignmentEntry.Table.al` | Posted activity | Assignment |
| 50004 | `Features/Return/Tables/ReturnEntry.Table.al` | Asset return record | Assignment |
| 50034 | `Features/Assignment/Codeunits/AssignmentManagement.Codeunit.al` | Assign/return/transfer service | Asset, Assignment |
| 50035 | `Features/Assignment/Codeunits/AssignmentValidation.Codeunit.al` | Eligibility rules | Employee, Asset |
| 50036 | `Features/Transfer/Codeunits/TransferManagement.Codeunit.al` | Transfer workflow | Assignment |
| 50005 | `Features/Exit/Codeunits/EmployeeExitValidation.Codeunit.al` | Exit clearance validation | Assignment |
| 50001 | `Features/Assignment/Pages/AssignmentList.Page.al` | Assignment list | Assignment |
| 50004 | `Features/Assignment/Pages/AssignmentCard.Page.al` | Assignment card | Assignment |
| 50006 | `Features/Assignment/Pages/AssignAsset.Dialog.Page.al` | Guided assignment | Assignment service |
| 50007 | `Features/Return/Pages/ReturnAsset.Dialog.Page.al` | Guided return | Assignment service |
| 50008 | `Features/Transfer/Pages/TransferAsset.Dialog.Page.al` | Guided transfer | Transfer service |
| 50022 | `Features/Assignment/API/Assignment.API.Page.al` | Assignment API | Assignment |
| 50006 | `Features/Assignment/Queries/AssignmentAnalytics.Query.al` | Analytics model | Assignment |

### Maintenance, compliance and approvals

| ID | File | Purpose | Depends on |
|---:|---|---|---|
| 50005 | `Features/Maintenance/Tables/MaintenanceEntry.Table.al` | Maintenance work record | Asset |
| 50037 | `Features/Maintenance/Tables/MaintenancePlan.Table.al` | Planned service schedule | Asset |
| 50004 | `Features/Maintenance/Codeunits/MaintenanceManagement.Codeunit.al` | Start/complete maintenance | Asset |
| 50013 | `Features/Maintenance/Codeunits/AssetMonitoring.Codeunit.al` | Warranty/service job queue | Asset |
| 50009 | `Features/Maintenance/Pages/Maintenance.Dialog.Page.al` | Service dialog | Maintenance |
| 50008 | `Features/Approval/Tables/ApprovalRequest.Table.al` | Internal approval request | Asset, Employee |
| 50010 | `Features/Approval/Codeunits/ApprovalManagement.Codeunit.al` | Submit/approve/reject | Approval Request |
| 50021 | `Features/Approval/Pages/ApprovalRequests.Page.al` | Approver worklist | Approval Request |
| 50012 | `Features/Workflow/Codeunits/WorkflowManagement.Codeunit.al` | Policy and workflow seam | Asset |
| 50038 | `Features/Workflow/Codeunits/WorkflowEvents.Codeunit.al` | Workflow integration events | Workflow Mgmt |

### Integration, intelligence, reporting and operations

| ID | File | Purpose | Depends on |
|---:|---|---|---|
| 50011 | `Features/Integration/Codeunits/IntegrationManagement.Codeunit.al` | External integration boundary | Asset |
| 50080 | `Features/Integration/XMLPorts/AssetImport.XmlPort.al` | Controlled asset import | Asset |
| 50081 | `Features/Integration/XMLPorts/AssetExport.XmlPort.al` | Asset export | Asset |
| 50039 | `Features/Notifications/Codeunits/NotificationManagement.Codeunit.al` | In-app/email notification facade | System Application |
| 50040 | `Features/Telemetry/Codeunits/TelemetryManagement.Codeunit.al` | Structured telemetry facade | System Application |
| 50041 | `Features/Copilot/Codeunits/CopilotAssetAssistant.Codeunit.al` | AI provider abstraction | Azure OpenAI extension |
| 50042 | `Features/Copilot/Interfaces/AssetAssistant.Interface.al` | Replaceable AI contract | — |
| 50043 | `Features/PowerBI/Codeunits/PowerBIRefresh.Codeunit.al` | Dataset refresh orchestration | Queries |
| 50003 | `Features/PowerBI/Queries/AssetStatusSummary.Query.al` | Power BI status dataset | Asset |
| 50004 | `Features/PowerBI/Queries/WarrantyExpiry.Query.al` | Power BI warranty dataset | Asset |
| 50012 | `Features/RoleCenter/Pages/AssetManager.RoleCenter.al` | Manager landing page | Cues, lists |
| 50027 | `Features/RoleCenter/Pages/AssetManagerActivities.CardPart.al` | Role center activities | Queries |

## Supporting-file architecture

| Path | Purpose |
|---|---|
| `.vscode/launch.json` | Local sandbox launch profile |
| `.vscode/settings.json` | AL formatting and analyzer settings |
| `.github/workflows/build.yml` | CI: restore symbols, compile, test, package |
| `app.json` | Extension manifest and ID range contract |
| `Translations/*.xlf` | Source and language translations |
| `docs/ARCHITECTURE.md` | Component architecture |
| `docs/API.md` | Endpoint and versioning contract |
| `docs/OPERATIONS.md` | Job queue, notifications, telemetry runbook |
| `docs/FILE_ARCHITECTURE.md` | This master file plan |
| `scripts/Build.ps1` | Local build wrapper |

## Delivery sequence

1. Create the `apps/` workspace and move shared setup, permission, audit, enum, and contract objects to `Foundation` with no ID changes.
2. Move asset, assignment, return, transfer, maintenance, warranty, reservation, insurance, disposal, lost/damaged, attachment, and QR/barcode objects to `Core`, preserving feature boundaries.
3. Complete asset master (model, location, documents) and all validation/events.
4. Add approval and workflow integration using the approval request contract already implemented.
5. Build the independently-versioned API, Integration, Reporting, Power BI, and optional AI apps with explicit dependency contracts.
6. Add operational integrations, telemetry, job queues, and Copilot behind interfaces.
7. Expand automated tests for every service codeunit and public API; run analyzers, upgrade testing, permission testing, and AppSource validation before release.
