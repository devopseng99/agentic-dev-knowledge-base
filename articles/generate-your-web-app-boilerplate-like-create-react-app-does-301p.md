---
title: "Generate your web-app boilerplate like create-react-app does."
url: "https://dev.to/leopold/generate-your-web-app-boilerplate-like-create-react-app-does-301p"
author: "Leopold"
category: "templatized-software"
---
# Generate your web-app boilerplate like create-react-app does.
**Author:** Leopold  **Published:** April 8, 2021

## Overview
This tutorial guides developers through creating a custom NPM package that generates project boilerplate with a single command, similar to `create-react-app`. Reduces repetitive setup tasks by automating preferred development configurations.

## Key Concepts
1. **The `bin` field in package.json**: Maps command names to executable scripts, enabling NPX package runners to execute Node.js files directly
2. **NPX Command Execution**: Allows running packages without global installation
3. **Git Cloning for Template Distribution**: Script clones a boilerplate repository, installs dependencies, removes unnecessary files
4. **Process Argument Handling**: Validates user input through `process.argv`

```javascript
#!/usr/bin/env node

const { execSync } = require('child_process');
const path = require('path');
const fs = require('fs');
```

```javascript
if (process.argv.length < 3) {
    console.log('You have to provide a name to your app.');
    process.exit(1);
}
```

```javascript
async function main() {
    try {
        execSync(`git clone --depth 1 ${git_repo} ${projectPath}`);
        process.chdir(projectPath);
        execSync('npm install');
        execSync('npx rimraf ./.git');
        console.log('Installation complete!');
    } catch (error) {
        console.log(error);
    }
}
main();
```

```json
"bin": {
    "create-boilerplate": "./bin/generate-app.js"
}
```

```bash
npm init
npm install -D parcel-bundler
npm install rimraf
npm link
npx create-my-boilerplate app-name
npm publish
```

NPM Package: https://www.npmjs.com/package/react-parcel-app
