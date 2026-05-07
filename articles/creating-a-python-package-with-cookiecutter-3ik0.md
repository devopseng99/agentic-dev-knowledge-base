---
title: "Creating a python package with cookiecutter"
url: "https://dev.to/chaps/creating-a-python-package-with-cookiecutter-3ik0"
author: "Chaps"
category: "templatized-software"
---
# Creating a python package with cookiecutter
**Author:** Chaps  **Published:** January 20, 2020

## Overview
A practical guide for packaging Python code using cookiecutter, a tool that generates project boilerplates dynamically. Demonstrates how to create a reusable Python package using an existing template from the community.

## Key Concepts
1. **Python Packages**: Distributable code modules importable via `import` statements
2. **Cookiecutter**: A Python tool enabling dynamic boilerplate generation with user prompts to set template variables
3. **Virtual Environments**: Isolated Python environments for dependency management
4. **Package Installation**: Using pip to install locally developed packages

```python
import my_python_package
```

```bash
python3 -m venv virtcookiecutter
source virtcookiecutter/bin/activate
pip install wheel
pip install cookiecutter
cookiecutter https://github.com/audreyr/cookiecutter-pypackage.git
cd python_cookiecutter_example/
pip install .
pip freeze
```

GitHub: https://github.com/audreyr/cookiecutter-pypackage.git
Docs: https://cookiecutter.readthedocs.io/
