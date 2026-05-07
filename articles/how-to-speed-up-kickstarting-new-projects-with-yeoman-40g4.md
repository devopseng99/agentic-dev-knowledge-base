---
title: "How to speed up kickstarting new projects with Yeoman"
url: "https://dev.to/vincenius/how-to-speed-up-kickstarting-new-projects-with-yeoman-40g4"
author: "Vincent Will"
category: "templatized-software"
---
# How to speed up kickstarting new projects with Yeoman
**Author:** Vincent Will  **Published:** March 13, 2020

## Overview
Vincent Will created a Yeoman generator to automate setup of Next.js projects with styled-components, then explains how others can build custom generators. Addresses the common pain of repetitive code copying when starting new projects.

## Key Concepts
**Three Core Functions**:
- `prompting()` — Collects user input via interactive questions
- `writing()` — Copies templates and generates project files based on responses
- `install()` — Runs dependency installation (npm, bower, yarn)

**Template System** — Uses EJS templating engine with variable interpolation: `<%= variableName %>`

**Private Helper Functions** — The underscore prefix convention marks internal methods like `_generateFiles()`

```bash
npm install -g yo generator-generator
```

```bash
npm link
```

```javascript
prompting() {
    const prompts = [{
        type: 'input',
        name: 'projectName',
        message: 'Your project name',
        default: this.appname
    }];
    return this.prompt(prompts).then(props => {
        this.props = props;
    });
}
```

```javascript
writing() {
    this._generateFiles('base')
    if (this.props.someAnswer)
        this._generateFiles('option')
}
```

```bash
npm login
npm publish
```

GitHub: https://github.com/Vincenius/generator-next-styled-components
