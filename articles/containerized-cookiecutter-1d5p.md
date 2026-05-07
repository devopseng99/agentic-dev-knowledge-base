---
title: "Containerized Cookiecutter"
url: "https://dev.to/ckaserer/containerized-cookiecutter-1d5p"
author: "Clemens Kaserer"
category: "templatized-software"
---
# Containerized Cookiecutter
**Author:** Clemens Kaserer  **Published:** February 15, 2020

## Overview
The article introduces running Cookiecutter — a project template generation tool — within Docker containers rather than installing it locally on a machine.

## Key Concepts
- **Cookiecutter**: "A command-line utility that creates projects from cookiecutters (project templates)"
- **Docker Implementation**: Uses a Python 3-based image available in "latest" (built daily) and version-specific tags (starting with 1.7.0)
- **Convenience Function**: Users can add a bash function to `.bashrc` to invoke the container as if Cookiecutter were installed locally

```bash
docker run --rm -it -v $(pwd):/cookiecutter ckaserer/cookiecutter TEMPLATE
```

```bash
function cookiecutter () {
  local command="docker run --rm -it -v $(pwd):/cookiecutter ckaserer/cookiecutter"
  echo "+ ${command} $@" && ${command} $@
}
```

GitHub: github.com/ckaserer/cookiecutter
Docker Hub: hub.docker.com/r/ckaserer/cookiecutter
