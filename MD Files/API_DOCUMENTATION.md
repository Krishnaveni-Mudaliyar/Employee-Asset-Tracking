# Employee Asset Tracking - API & Power BI Documentation

## Available APIs (Queries)

All queries are exposed as REST APIs for Power BI and third-party integrations.

---

## 1. Asset Analytics Query

**Entity:** assetAnalytics  
**API Path:** `/api/v1.0/companies([company-id])/assetAnalytics`

### Fields
| Field | Type | Description |
|-------|------|-------------|
| No | Code[20] | Asset number |
| Description | Text[100] | Asset description |
| Category | Code[20] | Asset category |
| Status | Enum | Asset status |
| CurrentEmployee | Code[20] | Assigned employee |
| Cost | Decimal | Asset cost |
| WarrantyExpiryDate | Date | Warranty expiry |
| LastMaintenanceDate | Date | Last maintenance |
| MaintenanceStatus | Enum | Maintenance status |
| AssetCondition | Enum | Asset condition |
| Active | Boolean | Active flag |

### Sample Filter
```
GET /api/v1.0/companies([company-id])/assetAnalytics?$filter=Status eq 'Assigned'
```

### Power BI Usage
```
Source = Json.Document(Web.Contents("https://[bc-env]/api/v1.0/companies([company-id])/assetAnalytics"))
```

---

## 2. Assignment Analytics Query

**Entity:** assignmentAnalytics  
**API Path:** `/api/v1.0/companies([company-id])/assignmentAnalytics`

### Fields
| Field | Type | Description |
|-------|------|-------------|
| AssignmentNo | Code[20] | Assignment number |
| AssetNo | Code[20] | Asset number |
| EmployeeNo | Code[20] | Employee number |
| AssignmentDate | Date | Assignment date |
| Status | Enum | Assignment status |
| DaysAssigned | Integer | Days since assignment |
| EmployeeFullName | Text[100] | Employee name |
| Department | Code[20] | Department code |

### Sample Filter
```
GET /api/v1.0/companies([company-id])/assignmentAnalytics?$filter=Status eq 'Active' and DaysAssigned gt 90
```

### Dashboard Idea
- Timeline: Days Assigned (X-axis) vs Count (Y-axis)
- Filter: By Department
- Card: Average Days Assigned

---

## 3. Maintenance Analytics Query

**Entity:** maintenanceAnalytics  
**API Path:** `/api/v1.0/companies([company-id])/maintenanceAnalytics`

### Fields
| Field | Type | Description |
|-------|------|-------------|
| MaintenanceNo | Code[20] | Maintenance number |
| AssetNo | Code[20] | Asset number |
| Description | Text[250] | Maintenance description |
| StartDate | Date | Start date |
| EndDate | Date | End date |
| Status | Enum | Status (In Progress/Completed) |
| MaintenanceDays | Integer | Duration in days |
| PostedBy | Code[20] | Who performed |

### Sample Filter
```
GET /api/v1.0/companies([company-id])/maintenanceAnalytics?$filter=Status eq 'Completed'
```

### Dashboard Idea
- Column: Average Maintenance Days by Month
- KPI: Total Maintenance Completed This Month
- Table: Pending Maintenance

---

## 4. Asset Status Summary Query

**Entity:** assetStatusSummary  
**API Path:** `/api/v1.0/companies([company-id])/assetStatusSummary`

### Fields
| Field | Type | Description |
|-------|------|-------------|
| Status | Enum | Asset status |
| MaintenanceStatus | Enum | Maintenance status |
| Category | Code[20] | Category |
| Count | Integer | Number of assets |
| TotalCost | Decimal | Total cost |

### Sample Response
```json
{
  "value": [
    {
      "Status": "Available",
      "MaintenanceStatus": "Not In Maintenance",
      "Category": "IT",
      "Count": 25,
      "TotalCost": 500000
    },
    {
      "Status": "Assigned",
      "MaintenanceStatus": "Not In Maintenance",
      "Category": "IT",
      "Count": 45,
      "TotalCost": 1200000
    }
  ]
}
```

### Dashboard Idea
- Donut: Asset Distribution by Status
- Stacked Bar: Cost by Category and Status
- KPI Cards: Total Assets, Total Cost, Available Count

---

## 5. Warranty Expiry Report Query

**Entity:** warrantyExpiryReport  
**API Path:** `/api/v1.0/companies([company-id])/warrantyExpiryReport`

### Fields
| Field | Type | Description |
|-------|------|-------------|
| No | Code[20] | Asset number |
| Description | Text[100] | Description |
| Category | Code[20] | Category |
| WarrantyExpiryDate | Date | Expiry date |
| DaysUntilExpiry | Integer | Days remaining |
| CurrentEmployee | Code[20] | Assigned employee |
| Cost | Decimal | Cost |

### Sample Filter
```
GET /api/v1.0/companies([company-id])/warrantyExpiryReport?$filter=DaysUntilExpiry gt 0 and DaysUntilExpiry lt 30
```

### Dashboard Idea
- Table: Assets expiring within 30 days
- Alert: Red if expiring within 7 days
- Action: Export for warranty renewal process

---

## Power BI Desktop Connection Example

### Step 1: Get Data
```
Power BI Desktop → Home → Get Data → Web
```

### Step 2: Enter URL
```
https://[tenant].dynamics.com/api/v1.0/companies([company-id])/assetAnalytics
```

Replace:
- `[tenant]` = Your BC environment
- `[company-id]` = Your company GUID

### Step 3: Authentication
```
Authentication: Organizational Account
Sign in with BC admin account
```

### Step 4: M Query (Advanced)
```m
let
    Source = Json.Document(
        Web.Contents(
            "https://[tenant].dynamics.com/api/v1.0/companies([company-id])/assetAnalytics"
        )
    ),
    value = Source[value],
    #"Converted to Table" = Table.FromList(value, Splitter.SplitByNothing(), null, null, ExtraValues.Error),
    #"Expanded Column1" = Table.ExpandRecordColumn(#"Converted to Table", "Column1", 
        {"No", "Description", "Category", "Status", "CurrentEmployee", "Cost"},
        {"No", "Description", "Category", "Status", "CurrentEmployee", "Cost"})
in
    #"Expanded Column1"
```

---

## Authentication

All APIs use BC standard authentication:
- **Cloud:** Azure AD (AAD)
- **On-Premise:** Basic Auth or Windows Auth

### Headers Required
```
Authorization: Bearer [access-token]
Content-Type: application/json
```

---

## Rate Limiting

- No explicit rate limits
- Recommended: Max 100 requests/minute per connection
- Batch queries recommended for large datasets

---

## Sample Power BI Report Structure

### Page 1: Asset Overview
- **Visual 1:** Donut - Asset Status Distribution
- **Visual 2:** Map - Assets by Location
- **Visual 3:** Card - Total Asset Cost
- **Visual 4:** Card - Available Count

### Page 2: Assignments
- **Visual 1:** Timeline - Assignment Duration
- **Visual 2:** Stacked Bar - Assignments by Department
- **Visual 3:** Table - Longest Active Assignments
- **Visual 4:** KPI - Overdue Returns (90+ days)

### Page 3: Maintenance
- **Visual 1:** Column - Maintenance by Month
- **Visual 2:** KPI - Average Maintenance Days
- **Visual 3:** Table - Pending Maintenance
- **Visual 4:** Alert - Assets Due for Maintenance

### Page 4: Warranty
- **Visual 1:** Table - Expiring Soon (< 30 days)
- **Visual 2:** Timeline - Warranty Expiry by Month
- **Visual 3:** Card - Total Warranty Value At Risk
- **Visual 4:** Alert Cards - Critical Expiries

---

## OData Query Examples

### Get All Available Assets
```
GET /api/v1.0/companies([company-id])/assetAnalytics?$filter=Status eq 'Available'
```

### Get Assignments Older Than 180 Days
```
GET /api/v1.0/companies([company-id])/assignmentAnalytics?$filter=DaysAssigned gt 180
```

### Get Maintenance in Progress
```
GET /api/v1.0/companies([company-id])/maintenanceAnalytics?$filter=Status eq 'In Progress'
```

### Order by Cost (Descending)
```
GET /api/v1.0/companies([company-id])/assetAnalytics?$orderby=Cost desc
```

### Select Specific Fields
```
GET /api/v1.0/companies([company-id])/assetAnalytics?$select=No,Description,Status,Cost
```

### Top 10 Most Expensive Assets
```
GET /api/v1.0/companies([company-id])/assetAnalytics?$orderby=Cost desc&$top=10
```

---

## Error Responses

### 401 Unauthorized
```json
{
  "error": {
    "code": "Unauthorized",
    "message": "Authentication failed"
  }
}
```

### 404 Not Found
```json
{
  "error": {
    "code": "ResourceNotFound",
    "message": "Company not found"
  }
}
```

### 500 Server Error
```json
{
  "error": {
    "code": "InternalServerError",
    "message": "An error occurred processing the request"
  }
}
```

---

## Integration Examples

### Excel Get & Transform
```m
let
    Source = Json.Document(Web.Contents("https://[tenant].dynamics.com/api/v1.0/companies([company-id])/assetAnalytics")),
    Data = Source[value],
    ToTable = Table.FromList(Data, Splitter.SplitByNothing())
in
    ToTable
```

### REST API Call (PowerShell)
```powershell
$headers = @{
    "Authorization" = "Bearer $accessToken"
    "Content-Type" = "application/json"
}

$response = Invoke-WebRequest -Uri "https://[tenant].dynamics.com/api/v1.0/companies([company-id])/assetAnalytics" -Headers $headers
$assets = $response.Content | ConvertFrom-Json
```

### JavaScript Fetch
```javascript
const response = await fetch(
    'https://[tenant].dynamics.com/api/v1.0/companies([company-id])/assetAnalytics',
    {
        headers: {
            'Authorization': `Bearer ${accessToken}`,
            'Content-Type': 'application/json'
        }
    }
);
const assets = await response.json();
```

---

## Best Practices

1. **Caching:** Cache query results for 1 hour
2. **Filtering:** Always filter at API level (not client-side)
3. **Pagination:** Use $skip/$top for large datasets
4. **Fields:** Select only needed fields with $select
5. **Batch:** Combine multiple queries into one request

---

## Troubleshooting

### Query Returns Empty
- Verify company ID is correct
- Check company exists in BC
- Verify user has proper permissions

### Slow Performance
- Add filters to reduce data
- Select specific fields only
- Consider caching results
- Check BC performance logs

### Authentication Fails
- Verify access token is valid
- Check AAD permissions
- Ensure service principal configured
- Verify company access granted

---

## Support

For API/Query issues:
1. Verify authentication
2. Check query syntax
3. Review filter conditions
4. Contact support with query details

