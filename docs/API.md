# API contract

The extension publishes API pages under `krishnavenimudaliyar/employeeAssetTracking/v1.0`.

| Entity set | Page | Use |
|---|---:|---|
| `assets` | 50020 | Read and maintain asset master data |
| `assignments` | 50022 | Read assignment history and status |

API consumers must use `id` (the Business Central `SystemId`) as the stable entity key. Do not build integrations around the user-editable asset number or assignment number. Breaking field or behavior changes require a new API version.
