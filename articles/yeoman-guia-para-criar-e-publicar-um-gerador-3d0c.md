---
title: "Yeoman - Guia para criar e publicar um gerador"
url: "https://dev.to/jhonywalkeer/yeoman-guia-para-criar-e-publicar-um-gerador-3d0c"
author: "Jhony Walker"
category: "templatized-software"
---
# Yeoman - Guia para criar e publicar um gerador
**Author:** Jhony Walker  **Published:** December 16, 2021

## Overview
A Portuguese-language guide teaching developers how to create and publish custom Yeoman generators to automate repetitive project setup tasks, using a Node.js CRUD application with TypeScript as the example.

## Key Concepts
1. **Yeoman Framework** — "uma ferramenta de estrutura para aplicativos da web" (a web application scaffolding tool) that helps automate scaffolding tasks
2. **Generator Structure** — Requires `app/` folder containing `index.js` as the entry point
3. **Package Naming Convention** — Generator packages must prefix the name with "generator-"
4. **Sub-generators** — Methods executed sequentially after the constructor
5. **EJS Templating** — Used for dynamic file generation with variable substitution
6. **NPM Publishing** — Publishing generators publicly for team or community use

```javascript
'use strict';
const Generator = require('yeoman-generator');
module.exports = class extends Generator {
  constructor(args, opts) {
    super(args, opts);
    this.log('Initializing...');
  }
  start() {
    this.log('Do something...');
  }
};
```

```javascript
this.prompt([
  {
    type: 'input',
    name: 'name',
    message: 'Enter a name for the new component:'
  }
]).then((answers) => {
  this.destinationRoot(answers.name);
});
```

```javascript
this.fs.copyTpl(
  this.templatePath('index.html'),
  this.destinationPath(answers.name + '.html'),
  { message: 'Hello world!' }
);
```
