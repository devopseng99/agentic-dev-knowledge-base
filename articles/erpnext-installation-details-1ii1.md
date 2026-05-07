---
title: "ERPNext Installation Details"
url: "https://dev.to/zimeracorp/erpnext-installation-details-1ii1"
author: "Bambang Purnomosidi D. P."
category: "erp-business-law"
---
# ERPNext Installation Details
**Author:** Bambang Purnomosidi D. P.  **Published:** August 11, 2021

## Overview
Comprehensive step-by-step guide for installing ERPNext on a personal server using the Bench framework. Covers the complete setup from Python and MariaDB through to initial ERPNext configuration.

## Key Concepts

**8 Essential Software Components**
- Python programming language
- MariaDB database management system
- Frappe framework (ERPNext's foundation)
- Bench CLI tool for managing deployments
- Node.js JavaScript runtime
- Yarn package manager
- Git version control
- Redis caching system

**Key Installation Commands**
```bash
# Install frappe-bench
pip install frappe-bench

# Initialize bench directory
bench init --frappe-branch version-14 myERPNext14

# Create new site
bench new-site --db-name myerpnextdb01 myerpnext01

# Get ERPNext application
bench get-app --branch version-14 erpnext

# Install payments dependency (required for v14)
bench get-app payments

# Install ERPNext into site
bench --site myerpnext01 install-app erpnext

# Production setup
sudo /path/to/bench setup production $USER
```

**MariaDB Configuration Requirements**
```ini
[mysqld]
character-set-client-handshake = FALSE
character-set-server = utf8mb4
collation-server = utf8mb4_unicode_ci

[mysql]
default-character-set = utf8mb4
```

**Initial Configuration Steps**
1. Language selection
2. Regional and timezone configuration
3. User account creation
4. Industry/domain selection
5. Company branding information

Development server runs on port 8001 via `bench start`.

**Key Takeaway:** While ERPNext documentation exists, practical installation details require hands-on experimentation. The Bench framework manages the multi-tenant Frappe ecosystem.
