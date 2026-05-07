---
title: "Creating Scaffolds and Generators using Yeoman"
url: "https://dev.to/ricardoham/creating-scaffolds-and-generators-using-yeoman-1g1m"
author: "Ricardo Manoel"
category: "templatized-software"
---
# Creating Scaffolds and Generators using Yeoman
**Author:** Ricardo Manoel  **Published:** February 3, 2021

## Overview
This tutorial demonstrates building a Yeoman generator that scaffolds new projects with three template options: React frontend, Node.js API, or full-stack application via CLI prompts. Yeoman is technology-agnostic with over 5,000 available generators.

## Key Concepts
**Generator Structure**:
- Folder naming convention: `generator-<name>`
- Core directory: `/generators/app/` containing `index.js`
- Templates stored in `/generators/app/templates/`

**Priority Methods (Lifecycle)**: `initializing` → `prompting` → `configuring` → `default` → `writing` → `conflicts` → `install` → `end`

**File System Operations**:
- `this.fs.copy()` — copies directories
- `this.fs.copyTpl()` — copies with EJS template processing
- `this.templatePath()` and `this.destinationPath()` — manage source/destination paths

```bash
npm install -g yo
npm install --save yeoman-generator
```

```javascript
var Generator = require('yeoman-generator');

module.exports = class extends Generator {
  constructor(args, opts) {
    super(args, opts);
    this.argument('appname', { type: String, required: false });
  }
};
```

```javascript
async prompting() {
  this.answers = await this.prompt([{
    type: 'input',
    name: 'name',
    message: 'Your project name',
    default: this.appname,
    store: true,
  }, {
    type: 'list',
    name: 'templateType',
    message: 'Select the template wanted:',
    choices: ['Front-End React', 'Node API builder', 'FullStack Application']
  }]);
}
```

```javascript
_writingReactTemplate() {
  this.fs.copyTpl(
    this.templatePath('frontend/public/index.html'),
    this.destinationPath('frontend/public/index.html'),
    { title: this.answers.name }
  );
}
```

```html
<title><%= title %></title>
```

```javascript
writing() {
  if (this.answers.templateType === 'Front-End React') {
    this._writingReactTemplate();
  } else if (this.answers.templateType === 'Node API builder') {
    this._writingApiTemplate();
  } else {
    this._writingReactTemplate();
    this._writingApiTemplate();
  }
}
```

GitHub: https://github.com/ricardoham/generator-scaffold
