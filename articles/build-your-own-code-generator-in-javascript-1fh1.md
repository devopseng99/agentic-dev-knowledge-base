---
title: "Build your own code generator in JavaScript"
url: "https://dev.to/okeeffed/build-your-own-code-generator-in-javascript-1fh1"
author: "Dennis O'Keeffe"
category: "templatized-software"
---
# Build your own code generator in JavaScript
**Author:** Dennis O'Keeffe  **Published:** June 30, 2020

## Overview
This tutorial demonstrates creating a minimal CLI tool that scaffolds JavaScript files using the EJS template engine. The author emphasizes how templates enforce coding patterns and assist with developer onboarding in large codebases.

## Key Concepts
1. **EJS Template Engine** - Enables dynamic code generation with embedded JavaScript logic
2. **CLI Argument Parsing** - Uses yargs-parser to handle command-line flags and positional arguments
3. **File System Operations** - Leverages fs-extra for safe file creation and path management
4. **Template Rendering** - Converts template files into executable code based on provided data

```javascript
yarn init -y
yarn add ejs fs-extra yargs-parser
```

```javascript
const fs = require("fs-extra")
const ejs = require("ejs")
const argv = require("yargs-parser")(process.argv.slice(2))
const path = require("path")

ejs.renderFile(filename, data, options, function(err, str) {
  const outputFile = path.join(process.cwd(), out)
  fs.ensureFileSync(outputFile)
  fs.outputFileSync(outputFile, str)
})
```

```ejs
const <%= fn %> = () => {
  <% for (const arg of leftovers) { %>
  console.log('<%= arg %>')
  <% } %>
}

<%= fn %>()
```

GitHub: https://github.com/okeeffed/hello-ejs
