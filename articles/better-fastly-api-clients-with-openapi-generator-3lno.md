---
title: "Better Fastly API clients with OpenAPI Generator"
url: "https://dev.to/fastly/better-fastly-api-clients-with-openapi-generator-3lno"
author: "Integralist"
category: "templatized-software"
---
# Better Fastly API clients with OpenAPI Generator
**Author:** Integralist  **Published:** November 1, 2022

## Overview
Fastly documented their journey to auto-generate API clients across seven programming languages using OpenAPI Generator. With 700+ endpoints, manually maintaining separate clients was unsustainable. They adopted OpenAPI specifications and OAG tooling to programmatically generate consistent, up-to-date clients.

## Key Concepts
- **OpenAPI Specification**: A standardized, language-agnostic interface describing APIs that enables programmatic interaction to generate code, documentation, and tools
- **OpenAPI Generator (OAG)**: A Java-based, template-driven engine using Mustache that parses OpenAPI specs to generate clients, documentation, and server stubs
- **Supported Languages**: Ruby, Python, PHP, Perl, Go, JavaScript, and Rust

**Challenges Addressed**:
- Aggregating ~120 specification files into single documents using Redocly
- Dockerizing the CLI tool for CI/CD integration
- Handling inconsistent community language templates
- Debugging errors across three layers (spec documents, Mustache templates, Java parsers)
- Created custom OpenAPI extensions to exclude endpoints by language/scope

```yaml
paths:
  /service/{service_id}/version/{version_id}/backend:
    get:
      summary: List backends
      operationId: list-backends
      responses:
        "200":
          description: OK
          content:
            application/json:
              schema:
                type: array
                items:
                  $ref: "#/components/schemas/backend_response"
```

```makefile
OAPI_GENERATOR_CLI:=docker run --rm -v $(PWD):/local openapitools/openapi-generator-cli:v5.4.0
$(OAPI_GENERATOR_CLI) generate \
  -i /local/schema.yaml \
  -g ruby \
  -o /local/ruby-client
```

```yaml
x-fastly-preprocess-exclude:
  - fastly-rust
  - fastly-js
```
