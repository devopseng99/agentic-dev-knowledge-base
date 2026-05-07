---
title: "Code Generation Is Easy - With Picocog"
url: "https://dev.to/ainslec/metaprogramming-with-picocog-44od"
author: "Chris Ainsley"
category: "templatized-software"
---
# Code Generation Is Easy - With Picocog
**Author:** Chris Ainsley  **Published:** January 8, 2018

## Overview
This article introduces Picocog, a lightweight open-source Java library designed to simplify programmatic code generation. The tool eliminates the need for templates or reflection, focusing on clean indentation and sequential code emission.

## Key Concepts
**Code Generation Process**: Three primary steps: define/use a model, interrogate it to emit source code, optionally regenerate upon model changes.

**POJO Models**: "A code generator designed to leverage Picocog typically utilizes a POJO model as a source of model data." Models can originate from JSON, XML, YAML, CSV, databases, or domain-specific languages.

**Core Goals**: Generate cleanly indented code easily, support out-of-sequence line injection, remain debuggable.

**Primary Class**: The PicoWriter class handles line writing with automatic indentation tracking via `writeln_r()`, `writeln_l()`, and `writeln_lr()` methods.

**Deferred Writing**: The `createDeferredWriter()` method enables simultaneous writing to multiple document locations with independent indentation stacks.

**Language Agnostic**: "Picocog is written in Java, but it can emit code in any language" — including C#, JavaScript, and others from a single model.

GitHub: https://github.com/ainslec/picocog
