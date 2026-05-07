---
title: "Template Your Own Clean, Precise Boilerplate Code: No AI, No Wallet Drain. Part 2 – Exploring Every Hidden Trail"
url: "https://dev.to/georgekobaidze/template-your-own-clean-precise-boilerplate-code-no-ai-no-wallet-drain-part-2-exploring-every-31ao"
author: "Giorgi Kobaidze"
category: "templatized-software"
---
# Template Your Own Clean, Precise Boilerplate Code: No AI, No Wallet Drain. Part 2 – Exploring Every Hidden Trail
**Author:** Giorgi Kobaidze  **Published:** September 9, 2025

## Overview
Second installment dissecting Microsoft's Web API template structure to explain how developers can create reusable, configurable boilerplate code without AI tools or paid services.

## Key Concepts
**template.json Configuration File** — core configuration file with properties:
- `$schema`: Points to JSON schema for validation and IDE support
- `identity`: Unique template identifier
- `shortName`: CLI keyword (e.g., "webapi")
- `sourceName`: Placeholder replaced with user-specified project name
- `symbols`: Defines configurable parameters
- `sources`: Controls file inclusion, exclusion, and renaming
- `postActions`: Scripts executed after generation

**Symbol Types**:
- Parameter: User-supplied values via CLI flags
- Computed: Boolean logic based on other symbols
- Generated: Auto-created values (GUIDs, ports, timestamps)
- Derived: Values transformed from other symbols
- Bind: Values from host environment

**Multiple Program.cs Files** — template engine conditionally includes only the relevant version based on user selections

**Localization Support** — Templates support 13+ languages through language-specific folders with `strings.json` translated descriptions

```powershell
$Env:DOTNET_CLI_UI_LANGUAGE = "de-DE"
```

```bash
export DOTNET_CLI_UI_LANGUAGE=de-DE
```

```bash
dotnet new webapi -o BlackBear
dotnet new webapi --use-program-main -o ProjectName
dotnet new list API
```

```json
{
  "generator": "port",
  "parameters": {
    "low": 5000,
    "high": 5300
  }
}
```

GitHub: https://github.com/dotnet/templating
