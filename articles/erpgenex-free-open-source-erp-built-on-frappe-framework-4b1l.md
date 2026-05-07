---
title: "ERPGENEX Free Open-Source ERP Built on Frappe Framework"
url: "https://dev.to/erpgenex_micro_2e6197b425/erpgenex-free-open-source-erp-built-on-frappe-framework-4b1l"
author: "erpgenex micro"
category: "erp-business-law"
---
# ERPGENEX Free Open-Source ERP Built on Frappe Framework
**Author:** erpgenex micro  **Published:** April 26, 2026

## Overview
Comprehensive installation guide for ERPGENEX, an open-source ERP system built on Frappe Framework. Runs on Ubuntu Server with auto-fetching of required applications.

## Key Concepts

**Server Prerequisites**
- Ubuntu 24.04/22.04 LTS
- Specific port configurations

**Key Software Dependencies**
- Python (via Miniconda or system Python)
- MariaDB (UTF8MB4 character set + InnoDB storage engine)
- Redis (caching)
- Node.js + Yarn
- wkhtmltopdf

**MariaDB UTF8 Configuration**
```ini
[mysqld]
character-set-client-handshake = FALSE
character-set-server = utf8mb4
collation-server = utf8mb4_unicode_ci

[mysql]
default-character-set = utf8mb4
```

**Bench Initialization**
```bash
# Install frappe-bench
pip install frappe-bench

# Initialize bench with Frappe v15
bench init --frappe-branch version-15 myERPGENEX

# Create site
cd myERPGENEX
bench new-site --db-name erpgenexdb01 erpgenex.local

# Get and install ERPGENEX app
bench get-app omnexa_core
bench --site erpgenex.local install-app omnexa_core
```

**Production Deployment**
```bash
# Setup production (Nginx + Supervisor)
sudo bench setup production $USER

# Development mode
bench start
```

**Verification Commands**
```bash
bench --site erpgenex.local list-installed-apps
bench doctor
```

**Key Feature:** Auto-fetches required applications via environment variables during installation.
