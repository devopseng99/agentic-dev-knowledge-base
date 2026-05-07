---
title: "Scaffold your GitHub actions with Yeoman generator"
url: "https://dev.to/rocktimsaikia/scaffold-your-github-actions-with-yeoman-generator-39ic"
author: "Rocktim Saikia"
category: "templatized-software"
---
# Scaffold your GitHub actions with Yeoman generator
**Author:** Rocktim Saikia  **Published:** August 23, 2020

## Overview
The author created a Yeoman generator tool to streamline the scaffolding process for JavaScript-based GitHub Actions, eliminating the need to repeatedly fork boilerplate templates during the GitHub Actions Hackathon.

## Key Concepts
- **Yeoman Generator**: A scaffolding tool that automates project setup with minimal configuration
- **GitHub Actions**: GitHub's automation framework for CI/CD workflows
- **JavaScript-based Actions**: Custom actions written in JavaScript following GitHub's official template

```bash
npm install -g yo
npm install -g generator-github-action
```

```bash
yo github-action
```

This command launches an interactive prompt requesting project details (name, description, etc.) and auto-generates a minimal setup with pre-installed dependencies.

GitHub: https://github.com/RocktimSaikia/generator-github-action
