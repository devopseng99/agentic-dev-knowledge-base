---
title: "Template Your Own Precise Boilerplate Code: No AI, No Wallet Drain. Part 1 – Microsoft's Implementation"
url: "https://dev.to/georgekobaidze/template-your-own-precise-boilerplate-code-no-ai-no-wallet-drain-part-1-microsofts-lkh"
author: "Giorgi Kobaidze"
category: "templatized-software"
---
# Template Your Own Precise Boilerplate Code: No AI, No Wallet Drain. Part 1 – Microsoft's Implementation
**Author:** Giorgi Kobaidze  **Published:** September 1, 2025

## Overview
First installment in a three-part series exploring how to create custom .NET project templates by reverse-engineering Microsoft's built-in template system. Advocates for manual template creation over AI-generated solutions, emphasizing precision, cost savings, and quality assurance.

## Key Concepts
**The Problem**: Starting projects from scratch requires repetitive setup work — folder structures, dependencies, file organization, documentation — before developers can enter a productive flow state.

**Why Manual Over AI**:
1. *Precision* — manual automation produces consistent, reliable output
2. *Cost* — avoiding per-token charges
3. *Quality Control* — reviewing foundation code is critical since fundamental changes become difficult later

**Template Storage Location**: Microsoft stores templates as NuGet packages:
- Windows: `C:/Program Files/dotnet/templates/<version>`
- macOS: `/usr/local/share/dotnet/templates/<version>`
- Linux: `/usr/lib/dotnet/templates/<version>`

**Template Categories**:
- **Common Project Templates**: Console and class library projects (C#, F#, VB)
- **Web Templates**: Blazor, MVC, Web API, gRPC applications
- **Test Templates**: MSTest, NUnit, xUnit frameworks
- **UI Templates**: WinForms and WPF applications
- **Item Templates**: Individual code files, configuration, components

```powershell
dotnet --version
dotnet --list-sdks
dotnet --list-runtimes
```

```powershell
dotnet new webapi -o BlackBear
```

```powershell
Expand-Archive -Path "projecttemplates.zip" -DestinationPath "."
```

```powershell
dotnet new gitignore
dotnet new razorcomponent
```
