---
title: "Automatically generate services and models for your API consumers"
url: "https://dev.to/iacons/automatically-generate-services-and-models-for-react-2dep"
author: "Iacovos Constantinou"
category: "templatized-software"
---
# Automatically generate services and models for your API consumers
**Author:** Iacovos Constantinou  **Published:** January 16, 2022

## Overview
Explores code generation from OpenAPI specifications to keep frontend and backend applications synchronized. The approach applies to React, Vue, Angular, and backend frameworks regardless of language.

## Key Concepts
**Code Generation Benefits**:
- "your backend and frontend will adhere to the same schema"
- Reduces manual errors in service and model creation
- Can be automated in build pipelines

**Generated Code Handling**: The author recommends not committing generated code, instead storing only the OpenAPI spec and regenerating during builds to "ensure that the generated code is intact and it has not modified manually."

**Tools & Solutions**:
- **OpenAPI Generator**: Supports TypeScript with Fetch, TypeScript with Axios, vanilla JavaScript; installable via npm or Docker
- **openapi-client-axios**: "JavaScript client library for consuming OpenAPI-enabled APIs with axios"
- **ng-openapi-gen**: "An OpenAPI 3.0 codegen for Angular"

```bash
docker run --rm \
  -v $PWD:/local openapitools/openapi-generator-cli generate \
  -i /api-specy.aml \
  -g typescript-axios \
  -o /output
```

GitHub Repos:
- https://github.com/OpenAPITools/openapi-generator
- https://github.com/openapistack/openapi-client-axios
- https://github.com/cyclosproject/ng-openapi-gen
