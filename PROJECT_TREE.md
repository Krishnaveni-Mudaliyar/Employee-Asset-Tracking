# Employee Asset Tracking — Project Tree

The current single-app baseline is arranged by business domain. `.alpackages/`, `.snapshots/`, and `output/` are generated/local folders and are not listed below.

```text
Employee Asset Tracking/
├── .github/workflows/build.yml
├── .vscode/{launch.json,rad.json,settings.json}
├── apps/README.md
├── demo-data/README.md
├── devops/README.md
├── docs/{API.md,FILE_ARCHITECTURE.md,OPERATIONS.md}
├── MD Files/{API_DOCUMENTATION.md,ARCHITECTURE.md,DEPLOYMENT_GUIDE.md,MIGRATION_GUIDE.md,README.md}
├── resources/README.md
├── samples/README.md
├── scripts/Build.ps1
├── tests/README.md
├── Translations/Employee Asset Tracking.g.xlf
├── src/
│   ├── Foundation/
│   │   ├── Audit/{Codeunits/Codeunit.50008.Audit Mgmt.al,Tables/Tab.50006.Audit Log.al}
│   │   ├── Permissions/{ps.50000.Admin.al,ps.50001.Manager.al,ps.50002.User.al,ps.50003.Viewer.al}
│   │   ├── Setup/{Codeunits/Codeunit.50007.Module Setup.al,Pages/Page.50010.AST Setup.al,Tables/Tab.50007.Setup.al}
│   │   └── Upgrade/Codeunits/Codeunit.50009.Upgrade.al
│   ├── Features/
│   │   ├── API/Pages/{API.50020.Asset.al,API.50022.Assignment.al}
│   │   ├── Approval/{Codeunits/CU.50010.Approval Management.al,Enums/Enum.50005.Approval Status.al,Pages/Pag.50021.Approval Requests.al,Tables/Tab.50008.Approval Request.al}
│   │   ├── Asset/{Enums/{Enum.50000.Asset Status.al,Enum.50002.Asset Condition.al},FactBoxes/Page.50005.Asset Statistics Factbox.al,Page Extensions/pagext.50000.Employee card Ext.al,Pages/{Page.50000.AssetList.al,Page.50002.AssetCategoryList.al,Page.50003.AssetCard.al},Tables/{Tab.50000.Asset.al,Tab.50001.AssetCategory.al}}
│   │   ├── Assignment/{Codeunits/Codeunit.50001.Asset Assignment.al,Enums/Enum.50003.Assignment Status.al,Pages/{Page.50001.AssignmentList.al,Page.50004.Assignment Card.al,Page.50006.Assign Asset Dialog.al},Tables/{Tab.50002.Assignment.al,Tab.50003.AssignmentEntry.al}}
│   │   ├── Dashboard/Queries/que.50003.Asset Status Summary.al
│   │   ├── Exit/Codeunits/Codeunit.50005.Employee Exit Validation.al
│   │   ├── Integration/Codeunits/CU.50011.Integration Management.al
│   │   ├── Maintenance/{Codeunits/Codeunit.50004.Maintenance Management.al,Enums/{Enum.50001.Maintenance Status.al,Enum.50004.Maintenance Entry Status.al},Job Queue/CU.50013.Asset Monitoring.al,Pages/Page.50009.Maintenance Dialog.al,Queries/que.50002.Maintenance Analytics.al,Tables/Tab.50005.MaintenanceEntry.al}
│   │   ├── Notifications/Codeunits/Codeunit.50006.Notification Management.al
│   │   ├── Reporting/{Report Layouts/Asset Register.rdlc,Reports/Rep.50000.Asset Register.al}
│   │   ├── Return/{Pages/Page.50007.Return Asset Dialog.al,Tables/Tab.50004.ReturnEntry.al}
│   │   ├── Role Center/Pages/Page.50012.Role Center.al
│   │   ├── Statistics/Queries/{que.50000.Asset Analytics.al,que.50001.Assignment Analytics.al}
│   │   ├── Transfer/Pages/Page.50008.Transfer Asset Dialog.al
│   │   ├── Warranty/Queries/que.50004.Warranty Expiry Report.al
│   │   └── Workflow/Codeunits/CU.50012.Workflow Management.al
│   └── Tests/{Assignment/CU.50050.Test Assignments.al,Exit/CU.50052.Test Employee Exit.al,Maintenance/CU.50051.Test Maintenance.al}
├── .gitignore
├── app.json
├── PROJECT_TREE.md
└── README.md
```

The planned multi-app commercial-product layout is documented in [docs/FILE_ARCHITECTURE.md](docs/FILE_ARCHITECTURE.md).
