---
title: "Go Tools: Code Generation from OpenAPI Specs in Go with oapi-codegen"
url: "https://dev.to/nikita_rykhlov/go-tools-code-generation-from-openapi-specs-in-go-with-oapi-codegen-3jc1"
author: "Nikita Rykhlov"
category: "templatized-software"
---
# Go Tools: Code Generation from OpenAPI Specs in Go with oapi-codegen
**Author:** Nikita Rykhlov  **Published:** May 22, 2025

## Overview
Explores oapi-codegen, a code generation tool that automates the creation of Go code from OpenAPI specifications. Addresses the challenge of maintaining consistency between API documentation and implementation by generating server interfaces, client libraries, data models, and validation logic automatically.

## Key Concepts
- **oapi-codegen**: An open-source code generator for Go projects that accepts OpenAPI 3.0 specifications (YAML/JSON) and produces ready-to-use Go code
- **Design-first API development**: Define OpenAPI spec first, then generate server interface and client code
- **Framework Integration**: Supports Chi, Echo, Gin, Fiber, Gorilla Mux, Iris, net/http
- **Custom template extensibility**: Override default templates for project-specific code generation

```bash
go install github.com/oapi-codegen/oapi-codegen/v2/cmd/oapi-codegen@latest
```

```yaml
openapi: 3.0.3
info:
  title: User API
  version: 1.0.0
paths:
  /users/{id}:
    get:
      operationId: getV1GetUserByID
      parameters:
        - name: id
          in: path
          required: true
          schema:
            type: string
      responses:
        '200':
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/User'
components:
  schemas:
    User:
      type: object
      required:
        - id
        - name
      properties:
        id:
          type: integer
        name:
          type: string
```

```yaml
package: api
generate:
  chi-server: true
  models: true
output: server_interface.gen.go
```

```bash
oapi-codegen --config config.yaml openapi.yaml
```

GitHub: https://github.com/oapi-codegen/oapi-codegen
