---
title: "Cookiecutter for container images"
url: "https://dev.to/ckaserer/cookiecutter-for-container-images-g4i"
author: "Clemens Kaserer"
category: "templatized-software"
---
# Cookiecutter for container images
**Author:** Clemens Kaserer  **Published:** March 1, 2020

## Overview
Introduces using Cookiecutter to standardize and automate container image building processes, including folder structure, CI/CD, registry publishing, and Slack notifications.

## Key Concepts
- **Cookiecutter**: A utility that creates projects from pre-defined templates
- **docker-cookiecutter Template**: Generates standardized Docker project structures with testing, CI/CD integration, and documentation components
- **Automated Workflows**: Integration of Travis CI, container registry credentials, and Slack for notifications throughout the build pipeline
- **Project Structure**: Generated folders include `.ci/` for tests, `.github/` for issue templates, Dockerfile, and configuration files like `.dockerignore` and `.travis.yml`

GitHub Repos:
- https://github.com/cookiecutter/cookiecutter
- https://github.com/ckaserer/cookiecutter
- https://github.com/ckaserer/docker-cookiecutter
- https://github.com/ckaserer/docker-travis-cli
