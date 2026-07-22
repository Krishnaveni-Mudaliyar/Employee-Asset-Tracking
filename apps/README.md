# Multi-app product workspace

This directory is the target workspace for the commercial Employee Asset Tracking product. The current `src/` extension is retained as the functional baseline until the multi-app consolidation milestone is scheduled.

| App | Ownership | Allowed dependencies |
|---|---|---|
| Foundation | Shared platform contracts and setup | Microsoft apps only |
| Core | Primary asset-management domain | Foundation |
| API | Versioned external contract | Foundation, Core |
| Integration | Optional external connectors | Foundation, Core |
| Reporting | Reports, layouts, analytics | Foundation, Core |
| PowerBI | Dataset and refresh features | Foundation, Core, Reporting |
| AI | Optional AI providers | Foundation, Core |
| Tests | Automated tests | All production apps |
| DemoData | Non-production sample data | Foundation, Core |

Do not make a production app depend on `Tests` or `DemoData`. See [`../docs/FILE_ARCHITECTURE.md`](../docs/FILE_ARCHITECTURE.md) for the migration sequence and object-level catalog.
