---
title: "Build your own Project Template Generator"
url: "https://dev.to/duwainevandriel/build-your-own-project-template-generator-59k4"
author: "Duwaine"
category: "templatized-software"
---
# Build your own Project Template Generator
**Author:** Duwaine  **Published:** May 11, 2020

## Overview
A practical guide for creating a custom CLI tool that generates new projects from templates. The author demonstrates building a template generator in TypeScript/Node.js that allows developers to reuse project configurations from anywhere on their machine.

## Key Concepts
- **Shebang (`#!/usr/bin/env node`)**: Directive enabling Node to execute TypeScript code
- **Template Rendering**: Using EJS to dynamically replace placeholder values (e.g., `<%= projectName %>`)
- **File System Operations**: Reading templates and recursively copying directory structures
- **CLI Registration**: Using `npm link` to create globally accessible commands
- **Inquirer.js**: Interactive command-line prompts for user input

```typescript
import * as fs from 'fs';
import * as inquirer from 'inquirer';
import chalk from 'chalk';

const CHOICES = fs.readdirSync(path.join(__dirname, 'templates'));
inquirer.prompt(QUESTIONS).then(answers => {
  // Process template selection and project creation
});
```

```javascript
import * as ejs from 'ejs';
export function render(content: string, data: TemplateData) {
  return ejs.render(content, data);
}
```

```json
{
  "name": "<%= projectName %>",
  "version": "1.0.0"
}
```

GitHub: https://github.com/DuwainevanDriel/project-template-generator.git
