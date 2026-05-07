---
title: "JavaScript Templating Engines: Pug, Handlebars (HBS), and EJS"
url: "https://dev.to/m__mdy__m/javascript-templating-engines-pug-handlebars-hbs-and-ejs-jcd"
author: "Genix (mahdi)"
category: "templatized-software"
---
# JavaScript Templating Engines: Pug, Handlebars (HBS), and EJS
**Author:** Genix (mahdi)  **Published:** December 8, 2023

## Overview
Explores three popular JavaScript templating engines used for dynamically generating HTML. Compares their syntax, advantages, disadvantages, and use cases.

## Key Concepts
**Pug**: High-performance template engine influenced by Haml; uses whitespace and indentation instead of closing tags; supports mixins and template inheritance
- Advantages: Simplified Syntax, code reusability, powerful features
- Disadvantages: Steep learning curve, unclear error stack traces
- Installation: `npm install pug`

**Handlebars (HBS)**: Logic-less templating engine for dynamic HTML generation; HTML-like syntax with custom helpers and partials
- Advantages: Ease of use, flexibility, compatibility
- Disadvantages: Limited logic support, maintenance challenges in large applications
- Installation: `npm install handlebars`

**EJS (Embedded JavaScript)**: Simple templating using plain JavaScript embedded directly into HTML markup
- Advantages: Minimal Syntax, fast compilation, easy integration
- Disadvantages: Can create "less readable templates", limited built-in features
- Installation: `npm install ejs`

```pug
doctype html
html(lang="en")
  head
    title= pageTitle
  body
    h1 Pug - node template engine
    #container.col
      if youAreUsingPug
        p You are amazing!
```

```html
<!DOCTYPE html>
<html>
<head>
  <title>{{title}}</title>
</head>
<body>
  <h1>{{header}}</h1>
  <div>{{body}}</div>
</body>
</html>
```

```ejs
<!DOCTYPE html>
<html>
<head>
  <title><%= title %></title>
</head>
<body>
  <h1><%= header %></h1>
  <% if (showBody) { %>
    <div><%= body %></div>
  <% } %>
</body>
</html>
```
