---
title: "Express Templating Cheatsheet (Pug, EJS, Handlebars, Mustache, Liquid)"
url: "https://dev.to/alexmercedcoder/express-templating-cheatsheet-pug-ejs-handlebars-mustache-liquid-50f1"
author: "Alex Merced"
category: "templatized-software"
---
# Express Templating Cheatsheet (Pug, EJS, Handlebars, Mustache, Liquid)
**Author:** Alex Merced  **Published:** October 20, 2021

## Overview
Provides practical syntax comparisons across five popular templating engines for Express.js applications. All engines follow the same Express pattern: `res.render("template.extension", {data: values})`.

## Key Concepts
**Variable Injection**:
- Liquid, Mustache, Handlebars: `{{variable}}`
- EJS: `<%= variable %>`
- Pug: `#{variable}`

**Looping**:
- Liquid: `{% for item in array %} ... {% endfor %}`
- EJS: `<% for (item of array) { %> ... <% } %>`
- Mustache: `{{#array}} ... {{/array}}`
- Pug: `each item in array`
- Handlebars: `{{#each array}} ... {{/each}}`

**Conditionals**:
- Liquid: `{% if condition %} ... {% else %} ... {% endif %}`
- EJS: `<% if (condition) { %> ... <% } else { %> ... <% } %>`
- Mustache/Handlebars: `{{#condition}} ... {{/condition}}`
- Pug: `if condition ... else ...`

```javascript
const app = require('liquid-express-views')(express(), {
  root: [path.resolve(__dirname, 'views/')]
})
```

```javascript
// EJS works by default; no configuration needed
res.render("template.ejs", {name: "Alex Merced"})
```

```javascript
server.set('view engine', 'pug')
```

```javascript
server.engine('mustache', mustache())
server.set('view engine', 'mustache')
```

```javascript
server.engine('handlebars', handlebars())
server.set('view engine', 'handlebars')
```
