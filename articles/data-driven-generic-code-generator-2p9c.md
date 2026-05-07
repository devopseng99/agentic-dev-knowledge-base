---
title: "Data Driven Generic Code Generator"
url: "https://dev.to/canonical/data-driven-generic-code-generator-2p9c"
author: "canonical"
category: "templatized-software"
---
# Data Driven Generic Code Generator
**Author:** canonical  **Published:** November 17, 2025

## Overview
This article explains the Nop platform's code generation capabilities, which integrate with Maven through the `exec-maven-plugin`. The system supports both pre-compilation and post-compilation code generation phases.

## Key Concepts
- **Maven Integration**: Configuration uses `exec-maven-plugin` to run `CodeGenTask` class; precompile phases execute before Java compilation; postcompile phases run afterward
- **XCodeGenerator**: The data-driven code generator that treats "template paths as a micro-format DSL, encoding conditionals and loop logic into the path format"
- **Template Path Encoding**: Files use `{variable}` expressions for loops and conditionals; files with `.xgen` suffix are templates; `.xrun` files execute without generating output
- **Delta-Based Generation**: "manual edits are customized Deltas over the auto-generated part," enabling repeated generation with preserved customizations
- **x:extends Operator**: Generic mechanism for XML/JSON customization implementing "Delta-based customization" through inheritance patterns

```xml
<plugin>
  <groupId>org.codehaus.mojo</groupId>
  <artifactId>exec-maven-plugin</artifactId>
</plugin>
```

```java
XCodeGenerator generator = new XCodeGenerator("/nop/templates/orm-entity", targetRootPath);
```

```bash
nop-cli gen model/app-mall.orm.xlsx -t=/nop/templates/orm
```

```xml
<gen:DefineLoop xpl:lib="/nop/codegen/xlib/gen.xlib">
  <c:script>
    builder.defineLoopVar("task","tasks",model=>model);
  </c:script>
</gen:DefineLoop>
```

```java
CustomClass extends _AutoGenClass extends BaseClass
```

```json
{
  "x:extends":"_page_crud.json5",
  "body":{"columns":[...]}
}
```
