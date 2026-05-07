---
title: "Packaging for Fedora: General purpose cookiecutter template"
url: "https://dev.to/r0x0d/packaging-for-fedora-general-purpose-cookiecutter-template-4kgi"
author: "Rodolfo Olivieri"
category: "templatized-software"
---
# Packaging for Fedora: General purpose cookiecutter template
**Author:** Rodolfo Olivieri  **Published:** December 12, 2025

## Overview
Introduces a custom cookiecutter template designed to streamline packaging applications for Fedora Linux. Provides pre-configured setups for Rust and Python applications with integrated tooling to automate common packaging workflows.

## Key Concepts
1. **Cookiecutter Template** — A scaffolding tool that generates project structures based on templates and user input
2. **jinja2_time** — A Jinja2 extension for automated date/time handling in generated files
3. **rust2rpm & pyp2spec** — Tools for automatically generating RPM spec files from Rust and Python projects
4. **COPR (Community Projects)** — Fedora's build system for community-maintained packages
5. **Spec Files** — Recipe files defining how to build and package software

```bash
pip install cookiecutter jinja2_time
```

```bash
cookiecutter git@github.com:r0x0d/cookiecutter-fp
```

```bash
make sources
make build
make logs
```

```bash
toolbox create --image quay.io/toolbox-dev/environment/fedora-packaging fedora-packaging
```

GitHub: https://github.com/r0x0d/cookiecutter-fp
