# Employee Asset Tracking

> A production-oriented Microsoft Dynamics 365 Business Central extension for managing the complete lifecycle of company assets, including acquisition, assignment, approvals, transfers, returns, maintenance, warranty monitoring, reporting, and auditing.

![Business Central](https://img.shields.io/badge/Microsoft-Dynamics%20365%20Business%20Central-blue)
![AL Language](https://img.shields.io/badge/Language-AL-green)
![Platform](https://img.shields.io/badge/Platform-Business%20Central-orange)
![License](https://img.shields.io/badge/License-MIT-lightgrey)

---

# Overview

Employee Asset Tracking is a Business Central extension designed to help organizations efficiently manage company-owned assets throughout their lifecycle.

The solution enables organizations to:

- Register company assets
- Assign assets to employees
- Transfer assets between employees
- Process asset returns
- Track maintenance history
- Monitor warranties
- Manage approval workflows
- Maintain complete audit history
- Generate reports and analytics
- Expose data through APIs for external integrations

The project follows a feature-oriented architecture suitable for long-term maintenance and commercial deployment.

---

# Features

## Asset Management

- Asset Master
- Asset Categories
- Asset Status Tracking
- Asset Condition Tracking
- Asset Statistics FactBox
- Asset Card
- Asset List

---

## Employee Asset Assignment

- Assign assets to employees
- Assignment history
- Assignment status tracking
- Assignment dialog
- Assignment approval support

---

## Asset Transfer

- Transfer assets between employees
- Transfer history
- Ownership tracking

---

## Asset Return

- Asset return process
- Return validation
- Asset condition updates
- Return history

---

## Approval Management

- Approval Request table
- Approval Management codeunit
- Approval Status enum
- Approval Request page

Supports configurable approval workflow for asset-related transactions.

---

## Maintenance Management

- Maintenance records
- Scheduled maintenance
- Maintenance history

---

## Warranty Monitoring

- Warranty expiry tracking
- Scheduled Job Queue processing
- Automatic warranty monitoring

---

## Audit Trail

Every important transaction can be audited, including:

- Asset creation
- Assignment
- Transfer
- Return
- Approval
- Maintenance

---

## Reports

Project includes reporting objects such as:

- RDLC Reports
- Reporting Queries
- Dataset support

---

## APIs

REST API pages are available for:

- Assets
- Asset Assignments

Designed for integration with:

- Power Apps
- Power Automate
- External ERP systems
- Mobile applications
- Third-party integrations

---

## Security

Includes:

- Permission Sets
- Role Center
- Feature isolation
- Object-level permissions

---

# Project Structure

```
Employee Asset Tracking
│
├── src/
│   ├── Features/
│   │   ├── API/
│   │   ├── Approval/
│   │   ├── Asset/
│   │   ├── Assignment/
│   │   ├── Maintenance/
│   │   ├── Reports/
│   │   ├── RoleCenter/
│   │   ├── Workflow/
│   │   └── Warranty/
│
├── docs/
│   ├── API.md
│   ├── FILE_ARCHITECTURE.md
│   └── OPERATIONS.md
│
├── devops/
├── demo-data/
├── samples/
├── scripts/
├── tests/
├── resources/
├── output/
├── apps/
├── PROJECT_TREE.md
└── README.md
```

---

# Technology Stack

- Microsoft Dynamics 365 Business Central
- AL Language
- Visual Studio Code
- RDLC Reports
- REST APIs
- Job Queue
- Permission Sets
- GitHub Actions

---

# Prerequisites

Before building the project, install:

- Visual Studio Code
- AL Language Extension
- Business Central Sandbox
- Docker (optional)
- PowerShell

---

# Build

Download symbols

```powershell
AL: Download Symbols
```

Package the extension

```powershell
Ctrl + Shift + B
```

Or

```powershell
Publish-BCContainerApp
```

---

# Deployment

Publish directly from Visual Studio Code

or

Use the provided PowerShell scripts:

```
scripts/
```

or

Use GitHub Actions

```
.github/workflows/build.yml
```

---

# Documentation

Additional documentation is available in:

| File | Description |
|------|-------------|
| PROJECT_TREE.md | Current project structure |
| docs/API.md | API documentation |
| docs/FILE_ARCHITECTURE.md | Target architecture |
| docs/OPERATIONS.md | Operational runbook |
| devops/README.md | DevOps guide |
| apps/README.md | Multi-app architecture |
| MD Files/README.md | Module documentation |

---

# Architecture

The project follows a feature-oriented architecture.

```
Feature
 ├── Tables
 ├── Pages
 ├── Page Extensions
 ├── Codeunits
 ├── Enums
 ├── Reports
 ├── Queries
 ├── APIs
 └── Permissions
```

This keeps every business feature isolated and easier to maintain.

---

# Current Baseline

Implemented functionality includes:

- Asset Master
- Asset Categories
- Employee Assignment
- Asset Return
- Maintenance
- Approval Requests
- Approval Management
- APIs
- Permission Sets
- Role Center
- Reporting Queries
- RDLC Reports
- Warranty Monitoring Job Queue
- Audit Logging Foundation
- Workflow Extension Points

Future enhancements are documented in:

```
docs/FILE_ARCHITECTURE.md
```

---

# DevOps

The repository contains:

- GitHub Actions
- PowerShell Build Scripts
- Deployment Scripts
- Output Folder
- Environment Configuration

---

# API

Current API endpoints expose:

- Assets
- Asset Assignments

Additional APIs can be added without affecting existing modules due to the feature-oriented architecture.

---

# Testing

The project structure supports dedicated test applications.

```
tests/
```

Recommended test coverage:

- Unit Tests
- Integration Tests
- Workflow Tests
- API Tests
- Performance Tests

---

# Future Roadmap

Planned enterprise features include:

- Power BI Dashboard
- Embedded Copilot
- AI-based Asset Recommendations
- Barcode & QR Code Support
- Mobile Asset Scanning
- Email Notifications
- Teams Integration
- Azure Blob Storage
- Document Attachments
- Asset Depreciation Dashboard
- Scheduled Maintenance Calendar
- Purchase Integration
- Fixed Asset Synchronization
- Multi-Company Support
- Multi-App AppSource Architecture

---

# Contributing

1. Fork the repository
2. Create a feature branch
3. Commit your changes
4. Push the branch
5. Open a Pull Request

---

# License

This project is licensed under the MIT License.

---

# Author

**Krishnaveni Mudaliyar**

Associate Technical Consultant  
Microsoft Dynamics 365 Business Central Developer

---

# Acknowledgements

Built using:

- Microsoft Dynamics 365 Business Central
- AL Language
- Visual Studio Code
- GitHub
````

### A few observations from your ZIP

Your project already has a **well-organized architecture** with:

* ✅ Feature-based `src/Features` structure
* ✅ GitHub Actions (`.github/workflows/build.yml`)
* ✅ DevOps documentation
* ✅ API documentation
* ✅ Operations runbook
* ✅ Project tree documentation
* ✅ PowerShell build scripts
* ✅ Demo data, samples, and resources folders

For an enterprise-grade GitHub repository, I'd additionally recommend adding:

* `CHANGELOG.md`
* `LICENSE`
* `CONTRIBUTING.md`
* `CODE_OF_CONDUCT.md`
* `SECURITY.md`
* `SUPPORT.md`
* `.editorconfig`
* `.gitattributes`
* GitHub Issue Templates
* Pull Request Template
* Release Notes template

These additions make the repository align closely with Microsoft and AppSource-quality open-source projects.
