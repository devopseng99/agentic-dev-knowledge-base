---
title: "Creating Yeoman based SpringBoot Generator"
url: "https://dev.to/sivalabs/creating-yeoman-based-springboot-generator-1o74"
author: "K. Siva Prasad Reddy"
category: "templatized-software"
---
# Creating Yeoman based SpringBoot Generator
**Author:** K. Siva Prasad Reddy  **Published:** January 29, 2020

## Overview
Documents how to build a Yeoman generator for automating SpringBoot application creation, scaffolding projects with pre-configured dependencies, properties, and best practices.

## Key Concepts
**Yeoman Generator Three-Step Process**:
1. Create template files with placeholders
2. Prompt users for inputs
3. Generate files by replacing placeholders with user-provided values

**Execution Priorities**: initializing → prompting → configuring → default → writing → conflicts → install → end

**Template Placeholders**: Uses `<%= variableName %>` syntax and `<%_ if condition _%>` for conditional logic

**Conditional Prompting**: The `when` property enables asking follow-up questions based on previous answers

```json
{
  "name": "generator-springboot",
  "version": "0.0.1",
  "description": "A Yeoman generator for generating SpringBoot microservices",
  "files": ["generators"],
  "main": "index.js",
  "keywords": ["yeoman-generator", "java", "spring", "spring-boot", "microservice"],
  "dependencies": {
    "yeoman-generator": "^4.0.1"
  }
}
```

```javascript
"use strict";
const Generator = require("yeoman-generator");

module.exports = class extends Generator {
  prompting() {
    const prompts = [
      {
        type: "string",
        name: "appName",
        message: "What is the application name?",
        default: "myservice"
      },
      {
        type: "list",
        name: "appType",
        message: "Do you want to use WebMVC or WebFlux?",
        choices: [
          { value: "webmvc", name: "WebMVC" },
          { value: "webflux", name: "WebFlux" }
        ],
        default: "webmvc"
      }
    ];

    return this.prompt(prompts).then(answers => {
      Object.assign(this.configOptions, answers);
    });
  }

  writing() {
    this.fs.copyTpl(
      this.templatePath("pom.xml.tpl"),
      this.destinationPath(this.configOptions.appName + "/pom.xml"),
      this.configOptions
    );
  }
};
```

```xml
<?xml version="1.0" encoding="UTF-8"?>
<project>
  <artifactId><%= appName %></artifactId>
  <dependencies>
    <%_ if (appType === 'webmvc') { _%>
    <dependency>
      <groupId>org.springframework.boot</groupId>
      <artifactId>spring-boot-starter-web</artifactId>
    </dependency>
    <%_ } _%>
  </dependencies>
</project>
```

```bash
npm link
yo springboot
```

GitHub: https://github.com/sivaprasadreddy/generator-springboot
