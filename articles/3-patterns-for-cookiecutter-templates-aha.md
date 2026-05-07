---
title: "3 Patterns for Cookiecutter Templates"
url: "https://dev.to/conorsheehan1/3-patterns-for-cookiecutter-templates-aha"
author: "Conor Sheehan"
category: "templatized-software"
---
# 3 Patterns for Cookiecutter Templates
**Author:** Conor Sheehan  **Published:** July 27, 2021

## Overview
This article explores three essential patterns for creating robust Cookiecutter templates — Python-based project generators using Jinja templating. Covers hooks for post-generation customization, testing strategies, and continuous integration setup.

## Key Concepts
**Cookiecutter Basics**: A command-line utility creating projects from templates, built with Python and Jinja2 templating.

**Hooks**: Pre and post-generation scripts (Python or Shell) executed before/after project creation. Example use: replacing placeholder text with absolute paths in generated files.

**Testing Approaches**:
1. **Internal Tests**: Include test suites within generated projects so users receive pre-configured testing infrastructure
2. **External Tests**: Generate projects programmatically using `--no-input` flag and test outputs without including tests in deliverables

**CI/CD Integration**: Automate template validation through continuous integration by generating projects and running their test suites.

```python
# Post-generation hook — walks directory tree, replaces placeholder text with absolute path
abs_path = os.getcwd()
for root, dirs, files in os.walk(abs_path):
    for filename in files:
        with open(os.path.join(root, filename)) as f:
            content = f.read()
        content = content.replace('replace_me.base_dir', abs_path)
```

```python
# {{cookiecutter.repo_name}}/tests/test_{{cookiecutter.repo_name}}.py
def test_version(self):
    assert {{cookiecutter.repo_name}}(version=True) == "0.1.0"
```

```bash
cookiecutter . --no-input project_name="foo"
```

```yaml
- name: Generate package using cookiecutter
  run: poetry run cookiecutter . --overwrite-if-exists --no-input
```

GitHub Repos:
- https://github.com/ConorSheehan1/cookiecutter-jira-project
- https://github.com/ConorSheehan1/cookiecutter-fire-cli
- https://github.com/cookiecutter/cookiecutter
