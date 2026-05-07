---
title: "Boilerplates in VSCode"
url: "https://dev.to/mattkenefick/boilerplates-in-vscode-5220"
author: "Matt Kenefick"
category: "templatized-software"
---
# Boilerplates in VSCode
**Author:** Matt Kenefick  **Published:** November 13, 2023

## Overview
This article introduces a Visual Studio Code plugin (PolymerMallard.new-from-template) that streamlines the creation and management of reusable templates for developers.

## Key Concepts
**Primary Use Cases:**
- Project boilerplates for complex initial setup
- Dynamic file templates with personalized variables
- Folder structure generation with dynamic content
- File distribution across multiple project directories

**Template Variables**: Supports environment variables (`${env.HOME}`), package metadata (`${package.name}`), user inputs (`${input.filename}`), and custom-defined variables

**Dynamic Code Execution**: Templates enable JavaScript evaluation using double-bracket syntax (`${{ Date.now() }}`), allowing conditional logic and complex variable manipulation

```
your-project/
├── manifest.json
└── src/
    ├── {filename}.ts
    ├── {filename}.scss
    └── index.html
```

```
{filename}.vue
{filename}-123.vue
```

```
My Home: ${env.HOME}
My User: ${env.USER}
```

```javascript
/**
 * @author ${package.author}
 * @package ${{ outputDirectoryRelative.split('src/')[1] }}
 * @project ${package.name}
 */
```

```javascript
${--
    variables.className = outputPathRelative.split('.').slice(0, -1).join('.').split('/').join('-').toLowerCase().split('src-')[1]
--}
```

```javascript
${{
    if (variables.package_author.indexOf('Kenefick') > -1) {
        `It's Matt.`
    }
    else {
        `It's someone else.`
    }
}}
```

VSCode Marketplace: https://marketplace.visualstudio.com/items?itemName=PolymerMallard.new-from-template
