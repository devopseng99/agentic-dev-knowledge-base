---
title: "Properly precompile Handlebars templates and partials with Gulp"
url: "https://dev.to/honatas/properly-precompile-handlebars-templates-and-partials-with-gulp-4g91"
author: "Jonatas de Moraes Junior"
category: "templatized-software"
---
# Properly precompile Handlebars templates and partials with Gulp
**Author:** Jonatas de Moraes Junior  **Published:** April 22, 2021

## Overview
Demonstrates a Gulp-based workflow for precompiling Handlebars templates and partials into a single JavaScript file for browser delivery, avoiding client-side compilation overhead.

## Key Concepts
1. **Template Precompilation** — Converting templates to JavaScript before deployment
2. **Partials** — Reusable template fragments (identified by underscore prefix in filename)
3. **Gulp Pipeline** — Automated build process using task runners
4. **Namespace Declaration** — Creating accessible template objects via `Hbs` namespace

```javascript
const { src, dest, series } = require('gulp');
const concat = require('gulp-concat');
const declare = require('gulp-declare');
const del = require('del');
const handlebars = require('gulp-handlebars');
const merge = require('merge2');
const path = require('path');
const rename = require('gulp-rename');
const wrap = require('gulp-wrap');

const target = 'dist/js';

function clean() {
  return del('dist');
}

function templates() {
  return src('src/**/*.hbs')
  .pipe(rename((path) => {
    if (path.basename.startsWith('_')) {
      path.basename = path.basename.substring(1);
    }
  }))
  .pipe(handlebars())
  .pipe(wrap('Handlebars.template(<%= contents %>)'))
  .pipe(declare({
    namespace: 'Hbs',
    noRedeclare: true,
  }));
}

function partials() {
  return src('src/**/_*.hbs')
  .pipe(handlebars())
  .pipe(wrap('Handlebars.registerPartial(<%= processPartialName(file.relative) %>, Hbs[<%= processPartialName(file.relative) %>]);', {}, {
    imports: {
      processPartialName: function(fileName) {
        return JSON.stringify(path.basename(fileName, '.js').substring(1));
      }
    }
  }));
}

function hbs() {
  return merge(templates(), partials())
    .pipe(concat('templates.js'))
    .pipe(dest(target));
}

exports.default = series(clean, hbs);
```

```javascript
const stringTemplate = Hbs['your_template_name_here'];
```
