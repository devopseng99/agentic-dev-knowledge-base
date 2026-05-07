---
title: "Generate JAVA code from OpenAPI specification"
url: "https://dev.to/kubenetic/generate-java-code-from-openapi-specification-4dn6"
author: "Miklos Halasz"
category: "templatized-software"
---
# Generate JAVA code from OpenAPI specification
**Author:** Miklos Halasz  **Published:** April 15, 2025

## Overview
This tutorial demonstrates how to integrate the OpenAPI Generator plugin into a Gradle-based Java project to automatically generate Java code from OpenAPI specifications, specifically targeting Spring Boot 3 applications.

## Key Concepts
1. **OpenAPI Generator Plugin** — A Gradle plugin that converts OpenAPI specifications into compilable Java code
2. **Generator Types** — The `generatorName` setting controls output structure; "spring" generates Spring Framework-compatible code
3. **Input/Output Configuration** — `inputSpec` locates the OpenAPI YAML file; `outputDir` specifies where generated code is placed
4. **Validation** — Setting `validateSpec` to true ensures the OpenAPI specification meets standards before code generation
5. **Model Package** — `modelPackage` designates where generated data transfer objects (DTOs) are placed
6. **Source Sets** — Gradle's mechanism for telling the compiler where to find generated source files
7. **Task Dependencies** — Configuring `compileJava` to depend on `openApiGenerate` ensures code regenerates during builds

```gradle
plugins {
    id("org.openapi.generator") version "7.12.0"
}
```

```gradle
openApiGenerate {
    generatorName.set("spring")
    inputSpec.set("$projectDir/src/main/resources/openapi/center-api-v1.yaml")
    outputDir.set("${layout.buildDirectory.get()}/generated")
    validateSpec.set(true)
}
```

```gradle
sourceSets {
    main {
        java {
            srcDir("${layout.buildDirectory.get()}/generated/src/main/java")
        }
    }
}
```

```gradle
tasks.named<JavaCompile>("compileJava") {
    dependsOn(tasks.named("openApiGenerate"))
}
```
