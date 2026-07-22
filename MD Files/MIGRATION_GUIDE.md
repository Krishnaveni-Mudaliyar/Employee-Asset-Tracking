# Employee Asset Tracking - Migration & Upgrade Guide

## Data Migration from Legacy System

This guide helps migrate existing asset data to the new AST module.

---

## PRE-MIGRATION CHECKLIST

- [ ] Backup current database
- [ ] Export current asset data to Excel
- [ ] Export current assignment data to Excel
- [ ] Identify asset categories
- [ ] Identify employee mapping
- [ ] Document custom fields (if any)
- [ ] Test migration in sandbox
- [ ] Plan maintenance window
- [ ] Notify users of downtime
- [ ] Prepare rollback plan

---

## STEP 1: PREPARE DATA

### Export Legacy Assets

If migrating from:

#### Manual Spreadsheet
```
Required columns:
- Asset No. (Code[20])
- Description (Text[100])
- Category (Code[20])
- Status (Available/Assigned/Retired)
- Current Employee (Code[20]) - Leave blank if unassigned
- Warranty Expiry Date (YYYY-MM-DD)
- Cost (Decimal)
- Serial Number (Code[50])
```

#### Legacy System (SQL Query)
```sql
SELECT 
    AssetID as 'Asset No.',
    AssetName as 'Description',
    CategoryCode as 'Category',
    CASE AssetStatus 
        WHEN 1 THEN 'Available'
        WHEN 2 THEN 'Assigned'
        WHEN 3 THEN 'Retired'
    END as 'Status',
    EmployeeID as 'Current Employee',
    WarrantyDate as 'Warranty Expiry Date',
    AssetCost as 'Cost',
    SerialNo as 'Serial Number'
FROM LegacyAssets
WHERE Active = 1
```

### Export Legacy Assignments

```
Required columns:
- Assignment No. (Code[20]) - Can be auto-generated
- Asset No. (Code[20])
- Employee No. (Code[20])
- Assignment Date (YYYY-MM-DD)
- Status (Active/Returned/Transferred)
- Assignment Notes (Text[250]) - Optional
```

### Data Validation

Check Excel file:
```
✓ No duplicate Asset Nos.
✓ All Employees exist in HR
✓ All Categories exist in setup
✓ Dates in correct format
✓ No empty required fields
✓ Asset Nos. valid (max 20 chars)
✓ No special characters in codes
```

---

## STEP 2: SETUP BASELINE DATA

### Create Categories First
**Path:** Asset Tracking → Asset Categories

| Code | Description | Maintenance Interval |
|------|-------------|----------------------|
| IT | IT Equipment | 365 |
| FURN | Furniture | 730 |
| OFFICE | Office Equipment | 365 |
| VEHICLE | Vehicles | 180 |

**Ensure:** All categories from legacy data are created

### Create No. Series
**Path:** General Ledger → Setup → Number Series

| Series | Code | Description |
|--------|------|-------------|
| AST-ASSET | A-001001 | Asset Numbers |
| AST-ASSIGN | AS-001001 | Assignment Numbers |
| AST-RETURN | RT-001001 | Return Numbers |
| AST-MAINT | MN-001001 | Maintenance Numbers |

---

## STEP 3: MIGRATE ASSETS

### Method 1: Guided Import (Recommended)

Create migration codeunit:

```al
codeunit 50200 "AST Migration"
{
    procedure ImportAssets(FilePath: Text)
    var
        TempBlob: Codeunit "Temp Blob";
        AssetImportLine: Record "AST Asset Import Buffer";
    begin
        // Read Excel file
        // Validate each row
        // Create AST Asset records
        // Create assignment entries if assigned
    end;
}
```

### Method 2: Manual Import via Page

**Path:** Asset Tracking → Assets → Import Assets

**Steps:**
1. Upload Excel file
2. Map columns
3. Validate data
4. Preview
5. Import

### Method 3: Direct SQL Insert (Advanced)

```sql
INSERT INTO [dbo].[Leaping Frog$AST Asset] 
(
    [No_],
    [Description],
    [Category_Code],
    [Status],
    [Current Employee_No_],
    [Warranty Expiry Date],
    [Cost],
    [Serial Number],
    [Active],
    [Maintenance Status]
)
SELECT
    AssetID,
    AssetName,
    CategoryCode,
    CASE AssetStatus WHEN 1 THEN 0 WHEN 2 THEN 1 WHEN 3 THEN 4 END,
    EmployeeID,
    WarrantyDate,
    AssetCost,
    SerialNo,
    1,
    0
FROM LegacyAssets
WHERE Active = 1
```

---

## STEP 4: MIGRATE ASSIGNMENTS

### Only migrate if asset is currently assigned

```
Migration rules:
- Assignment Date = Last known assignment date
- Status = "Active" (if currently assigned)
- Status = "Returned" (if previously returned)
- Employee No. = Current or last employee
```

### Create assignments manually per asset

**For each assigned asset:**
1. Open Asset Card
2. Note: Current Employee field
3. Create assignment manually via dialog
4. Set Assignment Date to legacy date

OR use SQL for bulk:

```sql
INSERT INTO [dbo].[Leaping Frog$AST Assignment]
(
    [Assignment No_],
    [Asset No_],
    [Employee No_],
    [Assignment Date],
    [Status]
)
SELECT
    'MIGR-' + FORMAT(ROW_NUMBER() OVER (ORDER BY AssetID), '0000000'),
    AssetID,
    EmployeeID,
    AssignmentDate,
    1  -- Status: Active
FROM LegacyAssignments
WHERE Status IN (1, 2)  -- Active or Transferred
```

---

## STEP 5: MIGRATE MAINTENANCE HISTORY

### Create maintenance entries for audit trail

```
Data needed:
- Maintenance No.
- Asset No.
- Start Date
- End Date (if completed)
- Status (In Progress or Completed)
- Description
```

**Codeunit for batch import:**

```al
procedure ImportMaintenanceHistory(FilePath: Text)
var
    TempMaintenanceBuffer: Record "AST Maintenance Buffer" temporary;
    MaintenanceEntry: Record "AST Maintenance Entry";
begin
    // Read file
    // Create entries for historical data
    // Update Last Maintenance Date on asset
end;
```

---

## STEP 6: VALIDATION

### Post-Migration Verification

Run validation queries:

**1. Check all assets migrated**
```
Expected: Count matches legacy system
Current: SELECT COUNT(*) FROM "AST Asset" WHERE Active = 1
```

**2. Check assignments linked correctly**
```
Expected: All assignments have valid employee
Current: SELECT COUNT(*) FROM "AST Assignment" WHERE "Employee No_" NOT IN (SELECT "No_" FROM Employee)
```

**3. Check categories assigned**
```
Expected: All assets have category
Current: SELECT COUNT(*) FROM "AST Asset" WHERE Category = ''
```

**4. Check serial numbers unique**
```
Expected: No duplicates
Current: SELECT COUNT(*) FROM "AST Asset" GROUP BY "Serial Number" HAVING COUNT(*) > 1
```

**5. Check warranty dates valid**
```
Expected: All dates in future or past (not year 2099)
Current: SELECT * FROM "AST Asset" WHERE "Warranty Expiry Date" > 2099-01-01
```

---

## STEP 7: USER ACCEPTANCE TESTING

### Test Scenarios

**Test 1: View Asset**
- [ ] Open Asset List
- [ ] View asset details
- [ ] Verify all fields populated correctly

**Test 2: Check Assignment**
- [ ] Open Assignments
- [ ] Verify active assignments show
- [ ] Verify assignment dates correct

**Test 3: Return Migrated Asset**
- [ ] Select active assignment
- [ ] Return asset
- [ ] Verify status changed
- [ ] Check return entry created

**Test 4: Employee Exit Check**
- [ ] Search employee with assets
- [ ] Attempt to terminate
- [ ] System should block
- [ ] Return assets
- [ ] Try again - should allow

**Test 5: Reports**
- [ ] Run Asset Register
- [ ] Verify all migrated assets show
- [ ] Export to Excel
- [ ] Verify formatting

---

## STEP 8: CUTOVER

### Pre-Cutover Validation
- [ ] All tests passed
- [ ] Users trained
- [ ] Backup taken
- [ ] Rollback plan reviewed

### Cutover Steps

**1. Schedule maintenance window**
- Notify users 24 hours before
- Plan 2-3 hour downtime

**2. Final backup**
```
Backup [DatabaseName]
Backup location: [Path]
```

**3. Stop all processes**
```
- Stop Job Queues
- Stop background jobs
- Notify all users
- Lock application (optional)
```

**4. Run final migrations**
```
Execute all import codeunits
Validate all data
Run verification queries
```

**5. Test workflows**
```
- Create new asset
- Assign to employee
- Return asset
- Start maintenance
- Complete maintenance
```

**6. Go-live**
```
- Re-enable Job Queues
- Unlock application
- Notify users
- Monitor first hour
```

---

## STEP 9: ROLLBACK PLAN

If issues occur:

**Immediate (0-30 minutes):**
1. Stop users from using new system
2. Restore from backup
3. Restart old system
4. Notify users

**Investigation (30+ minutes):**
1. Analyze what failed
2. Fix data/code
3. Re-test in sandbox
4. Schedule retry

**Never:**
- Delete old system immediately
- Ignore validation errors
- Proceed with invalid data

---

## MIGRATION CHECKLIST

### Pre-Migration (Day Before)
- [ ] Backup current system
- [ ] Export all legacy data
- [ ] Validate data integrity
- [ ] Test in sandbox
- [ ] Train users
- [ ] Prepare rollback

### Migration Day
- [ ] Schedule maintenance window
- [ ] Notify users
- [ ] Take final backup
- [ ] Stop processes
- [ ] Run import codeunits
- [ ] Validate migrated data
- [ ] Test workflows
- [ ] Enable notifications
- [ ] Announce go-live

### Post-Migration (Days 1-7)
- [ ] Monitor system daily
- [ ] Fix any data issues
- [ ] Collect user feedback
- [ ] Optimize as needed
- [ ] Archive old system (after 1 week)

---

## PERFORMANCE DURING MIGRATION

### Expected Times
- Asset import: ~1 minute per 1000 assets
- Assignment creation: ~30 seconds per 100
- Maintenance history: ~1 minute per 1000
- Validation: ~5-10 minutes

### If Slow
1. Check database load
2. Increase batch size
3. Disable triggers temporarily
4. Run during off-peak hours

---

## COMMON ISSUES & SOLUTIONS

| Issue | Cause | Solution |
|-------|-------|----------|
| Employee not found | Legacy employee ID ≠ BC employee | Map IDs correctly |
| Category missing | Legacy category not created | Create missing categories |
| Duplicate assets | Legacy data has duplicates | Deduplicate in Excel first |
| Date format error | Excel stores as text | Format as date before import |
| Serial number conflict | Two assets same serial | Audit and correct data |

---

## CLEANUP AFTER MIGRATION

### Archive Old System
- [ ] Disable old asset tracking module
- [ ] Archive legacy data to historical DB
- [ ] Document cutover date
- [ ] Keep read-only access for 90 days

### Remove Old Data (After 30 Days)
```
IF all systems running smoothly THEN
  BEGIN
    BACKUP legacy_database
    DISABLE old_application
    DELETE old_application_data
  END
```

---

## SUPPORT DURING MIGRATION

### Escalation Path
1. **Tier 1:** Help desk (basic issues)
2. **Tier 2:** IT support (configuration)
3. **Tier 3:** Leaping Frog (technical issues)
4. **Tier 4:** Microsoft (BC issues)

### Hotline During Cutover
- Phone: [Support Number]
- Email: support@leapingfrog.com
- Status: Available 24/7 for first week

---

## POST-MIGRATION SUCCESS CRITERIA

✅ All assets migrated  
✅ All assignments validated  
✅ Users can view assets  
✅ Users can assign/return/transfer  
✅ Maintenance workflows functional  
✅ Employee exit validation works  
✅ Reports generate correctly  
✅ No critical data loss  
✅ System performance acceptable  
✅ Users trained and productive

