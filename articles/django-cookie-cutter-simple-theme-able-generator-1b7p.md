---
title: "Django Cookie-Cutter - Simple Theme-able Generator"
url: "https://dev.to/sm0ke/django-cookie-cutter-simple-theme-able-generator-1b7p"
author: "Sm0ke"
category: "templatized-software"
---
# Django Cookie-Cutter - Simple Theme-able Generator
**Author:** Sm0ke  **Published:** September 4, 2021

## Overview
Introduces Django Cookie-Cutter as a command-line tool enabling developers to rapidly generate Django projects with customizable UI themes and database backends.

## Key Concepts
- **CookieCutter**: A command-line utility that creates projects from pre-built templates, automating repetitive setup tasks
- **Django**: A batteries-included Python web framework
- **Theme-able Architecture**: Supports multiple UI designs (Volt, Soft UI, Datta Able) injected into generated projects
- **Database Flexibility**: Users can select SQLite, MySQL, or PostgreSQL during project generation

```bash
pip install cookiecutter
pip install GitPython
```

```bash
cookiecutter https://github.com/app-generator/cookiecutter-django.git
```

```bash
python manage.py makemigrations
python manage.py migrate
```

```bash
python manage.py runserver
# Access at http://127.0.0.1:8000/
```

**Available UI Themes**:
1. **Django Volt** — Bootstrap 5 design
2. **Django Soft UI** — Modern dashboard with 70+ frontend components
3. **Django Datta Able** — Colorful Bootstrap 4 admin template

GitHub: https://github.com/app-generator/cookiecutter-django.git
