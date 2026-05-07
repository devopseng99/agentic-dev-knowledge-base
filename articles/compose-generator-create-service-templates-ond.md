---
title: "Compose Generator - Create Service Templates"
url: "https://dev.to/marcauberer/compose-generator-create-service-templates-ond"
author: "Marc Auberer"
category: "templatized-software"
---
# Compose Generator - Create Service Templates
**Author:** Marc Auberer  **Published:** November 4, 2021

## Overview
This article describes how to create predefined service templates for Compose Generator, a tool that simplifies Docker deployment. Compose Generator offers over 60 pre-built templates across categories: frontend, backend, database, and db-admin.

## Key Concepts
- **Service Templates**: Reusable configurations enabling rapid deployment of software services via Docker
- **Template Structure**: Each template comprises four essential components — a configuration file, a service YAML file with Docker specs, an environment file for sensitive credentials, and a README
- **Placeholder System**: Templates use syntax like `${{PLACEHOLDER_EXAMPLE}}` for dynamic value injection
- **Contribution Model**: Community-driven extensibility via GitHub pull requests

**Key Steps for Creating Templates:**
1. Select target software and locate Docker images
2. Research required volumes, environment variables, and companion services
3. Fork the Compose Generator repository and create feature branch
4. Classify template type (frontend/backend/database/db-admin)
5. Establish directory structure with required files
6. Test locally using `./compose-generator -irf`
7. Submit via GitHub pull request

GitHub: github.com/compose-generator/compose-generator
Official Docs: www.compose-generator.com
