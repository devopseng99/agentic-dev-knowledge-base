---
title: "How to Build a CLI based Project Generator with Node"
url: "https://dev.to/ghostaram/build-a-cli-based-project-generator-with-node-56ld"
author: "Felix Owino"
category: "templatized-software"
---
# How to Build a CLI based Project Generator with Node
**Author:** Felix Owino  **Published:** November 8, 2023

## Overview
This guide teaches developers how to create a command-line tool that automatically generates new projects from templates, eliminating repetitive setup tasks. Covers building a Node.js application that prompts users for input, copies template files, and runs post-installation processes.

## Key Concepts
- **Project Templates**: Pre-configured directory structures serving as starting points for new projects
- **User Input Prompts**: Interactive CLI questions using the `prompts` npm package
- **File System Operations**: Reading template directories and recursively copying files using Node's `fs` and `path` modules
- **Post-Process Commands**: Automated setup tasks (like `npm install`) executed after project generation using `shelljs`
- **Global CLI Command**: Making generator executable from any system location via npm's `bin` configuration
- **Shebang Line**: The `#!/usr/bin/env node` directive

```bash
npm install prompts
npm i -D @types/prompts
npm i shelljs
npm i -D @types/shelljs
```

```typescript
import prompts, { PromptObject } from "prompts";

const questions: PromptObject[] = [
    {
        type: 'text',
        name: 'projectName',
        message: 'What is the name of your new project .',
        validate: name => name.trim().length < 1 || typeof name !== 'string'?
            'Project name is required': true
    },
    {
        type: 'select',
        name: 'templateName',
        message: 'Which template do you want to generate',
        choices: [
            { title: 'Simple Project One', value: 'simple-project-one' },
            { title: 'Simple Project Two', value: 'simple-project-two' }
        ]
    }
];
```

```typescript
const replicateTemplates = (
    templatePath: string,
    projectPath: string
) => {
    let templateContentNames = fs.readdirSync(templatePath);
    const filesToBeSkipped = ['node_modules', 'build', 'dist'];

    templateContentNames = templateContentNames.filter(
        name => !filesToBeSkipped.includes(name)
    );

    if(!fs.existsSync(projectPath)){
        fs.mkdirSync(projectPath);
    }

    templateContentNames.forEach(name => {
        const originPath = path.join(templatePath, name);
        const destinationPath = path.join(projectPath, name);
        const stats = fs.statSync(originPath);

        if(stats.isFile()){
            const content = fs.readFileSync(originPath, 'utf8');
            fs.writeFileSync(destinationPath, content);
        } else if (stats.isDirectory()){
            replicateTemplates(originPath, destinationPath);
        }
    });
};
```

```typescript
import shell from 'shelljs';

if(templateFilesNames.includes('package.json')){
    shell.cd(projectPath);
    console.log('Running npm install');
    shell.exec('npm install');
}
```

```json
"bin": {
    "generate-project": "./build/index.js"
}
```

```typescript
#! /usr/bin/env node
```

GitHub: https://github.com/GHOST-Aram/project-generator-with-cli
