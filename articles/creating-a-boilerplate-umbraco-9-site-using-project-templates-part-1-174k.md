---
title: "Creating a boilerplate Umbraco 9 site using project templates - part 1"
url: "https://dev.to/jemayn/creating-a-boilerplate-umbraco-9-site-using-project-templates-part-1-174k"
author: "Jesper Mayntzhusen"
category: "templatized-software"
---
# Creating a boilerplate Umbraco 9 site using project templates - part 1
**Author:** Jesper Mayntzhusen  **Published:** September 30, 2021

## Overview
This tutorial demonstrates how to create reusable .NET project templates for Umbraco 9 sites. The guide walks through setting up a template repository, configuring template metadata, testing the template locally, and adding customizable parameters for dynamic project generation.

## Key Concepts
1. **Template Structure**: Projects require a `.template.config/template.json` file in the root directory
2. **Template Metadata**: Essential properties include `identity`, `name`, `shortName`, `author`, `classifications`, and `sourceName`
3. **Parameter System**: Templates support custom parameters beyond the standard `sourceName`
4. **Symbol Configuration**: Parameters defined in `symbols` object, supporting different data types (choice, text) with default values
5. **Local Testing**: PowerShell helper function manages template installation and cleanup for development iterations

```json
{
  "$schema": "http://json.schemastore.org/template",
  "author": "Jesper Mayntzhusen",
  "classifications": ["Umbraco", "WebApp"],
  "identity": "Testing.Boilerplate",
  "name": "Testing boilerplate solution",
  "shortName": "test-bp",
  "tags": {
    "type": "project",
    "language": "C#"
  },
  "sourceName": "UmbracoNineDemoSite"
}
```

```powershell
function Reset-Templates{
  [cmdletbinding()]
  param(
    [string]$templateEngineUserDir = (join-path -Path $env:USERPROFILE -ChildPath .templateengine)
  )
  process{
    'resetting dotnet new templates. folder: "{0}"' -f $templateEngineUserDir | Write-host
    get-childitem -path $templateEngineUserDir -directory | Select-Object -ExpandProperty FullName | remove-item -recurse
    &dotnet new --debug:reinit
  }
}
```

```bash
dotnet new --install ..\BoilerPlate\
dotnet new test-bp -o MyTestSite
dotnet new test-bp -o MyTestSiteTwo --ProductName Sofa
dotnet new test-bp --help
```

GitHub: https://github.com/Adolfi/UmbracoNineDemoSite.git
