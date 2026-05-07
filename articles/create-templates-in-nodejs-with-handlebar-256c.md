---
title: "Create Templates in Node.js with Handlebar"
url: "https://dev.to/shayy/create-templates-in-nodejs-with-handlebar-256c"
author: "Shayan"
category: "templatized-software"
---
# Create Templates in Node.js with Handlebar
**Author:** Shayan  **Published:** February 24, 2025

## Overview
Demonstrates how to use Handlebars templating engine to manage dynamic content in Node.js applications. Covers setup, basic template creation, conditional logic, custom helpers, and Express.js integration, emphasizing separation of presentation from business logic.

## Key Concepts
1. **Templating Engine Basics** — Handlebars allows defining reusable templates with `{{variable}}` placeholders populated with dynamic data
2. **Template Compilation** — The `compile()` function converts template strings into executable functions
3. **Built-in Helpers** — Conditional (`if`/`else`) and iteration (`each`) helpers for adding logic within templates
4. **Custom Helpers** — Developers can register custom helper functions using `registerHelper()`
5. **Express Integration** — The `express-handlebars` package enables seamless template rendering via `res.render()`

```bash
npm install handlebars
npm install express express-handlebars
```

```handlebars
<h1>Welcome, {{name}}!</h1>
<p>Thanks for joining us on {{date}}.</p>
```

```javascript
import fs from 'fs';
import handlebars from 'handlebars';

const templateString = fs.readFileSync('./templates/welcome.hbs', 'utf8');
const template = handlebars.compile(templateString);

const data = { name: 'Alex', date: 'February 24, 2025' };
const output = template(data);
console.log(output);
```

```handlebars
{{#if interests}}
  <ul>
    {{#each interests}}
      <li>{{this}}</li>
    {{/each}}
  </ul>
{{else}}
  <p>No interests listed yet.</p>
{{/if}}
```

```javascript
handlebars.registerHelper('capitalize', (str) => {
  return str.charAt(0).toUpperCase() + str.slice(1);
});
```

```javascript
import express from 'express';
import { engine } from 'express-handlebars';

const app = express();
app.engine('hbs', engine({ extname: '.hbs' }));
app.set('view engine', 'hbs');
app.set('views', './templates');

app.get('/', (req, res) => {
  res.render('welcome', { name: 'Alex' });
});

app.listen(3000, () => console.log('Server running on port 3000'));
```
