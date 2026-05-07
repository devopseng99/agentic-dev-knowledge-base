---
title: "Automating your boring code with yeoman - Part 1"
url: "https://dev.to/bouthouri/automating-your-boring-code-with-yeoman-part-1-231a"
author: "Oussama Bouthouri"
category: "templatized-software"
---
# Automating your boring code with yeoman - Part 1
**Author:** Oussama Bouthouri  **Published:** September 30, 2019

## Overview
This tutorial introduces Yeoman, a scaffolding tool for automating repetitive code generation tasks. The author demonstrates creating a custom code generator, drawing inspiration from the LoopBack CLI framework.

## Key Concepts
1. **Yeoman's Purpose**: Automates file and project structure generation through command-line interfaces
2. **Generator Structure**: One project can contain multiple generators, each housed in separate folders; primary generator lives in `generators/app` directory
3. **Core Methods**:
   - `this.fs.copy()` — Copies files from template to destination
   - `this.templatePath()` — Returns absolute path within template directory
   - `this.destinationPath()` — Returns current folder path concatenated with filename
4. **File System Behavior**: `this.fs.copy()` automatically creates missing directories and prompts users about overwriting existing files

```javascript
'use strict';
const Generator = require('yeoman-generator');

module.exports = class extends Generator {
  writing() {
    this.fs.copy(
      this.templatePath('dummyfile.txt'),
      this.destinationPath('dummyfile.txt')
    );
  }
};
```

```bash
npm install -g yo
npm install -g generator-generator
yo generator
npm link
yo generator-code
```
