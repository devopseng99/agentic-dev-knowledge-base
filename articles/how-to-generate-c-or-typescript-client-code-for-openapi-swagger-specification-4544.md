---
title: "How to generate C# or TypeScript client code for OpenAPI (Swagger) specification"
url: "https://dev.to/unchase/how-to-generate-c-or-typescript-client-code-for-openapi-swagger-specification-4544"
author: "Chebotov Nickolay"
category: "templatized-software"
---
# How to generate C# or TypeScript client code for OpenAPI (Swagger) specification
**Author:** Chebotov Nickolay  **Published:** October 14, 2019

## Overview
This tutorial demonstrates how to use the Unchase OpenAPI Connected Service extension for Visual Studio 2017/2019 to automatically generate client code from OpenAPI specifications.

## Key Concepts
1. **Connected Service Extension** — A Visual Studio plugin enabling code generation from API specifications
2. **OpenAPI/Swagger Specification** — JSON or YAML format API documentation that can be converted to client code
3. **Code Generation Options** — Support for C# HTTP clients, TypeScript clients, and C# controllers
4. **NSwag Integration** — Underlying tool providing customization similar to NSwagStudio

**Process Steps**:
- Install the extension via Visual Studio marketplace
- Right-click "Connected Services" in Solution Explorer
- Configure the specification endpoint and service name
- (Optional) Customize code generation settings
- Complete generation to create client files

The extension can generate code from both remote URLs (API endpoints) and local OpenAPI specification files, making it useful for both consuming external APIs and developing against local API definitions.
