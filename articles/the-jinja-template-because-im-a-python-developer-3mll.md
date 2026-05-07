---
title: "The Jinja2 Template: Web Templates for Python"
url: "https://dev.to/kaelscion/the-jinja-template-because-im-a-python-developer-3mll"
author: "Jake Cahill"
category: "templatized-software"
---
# The Jinja2 Template: Web Templates for Python
**Author:** Jake Cahill  **Published:** October 31, 2018

## Overview
Explains how Jinja2 template engines enable modular web development in Python frameworks like Flask. Rather than building monolithic HTML pages, developers use template inheritance and includes to create reusable, maintainable components.

## Key Concepts
1. **Template Modularity** — Breaking web pages into independent components (header, content, footer) that fail gracefully if one section doesn't render
2. **Conditional Logic** — Using `{% if %}` statements to dynamically render content based on variables
3. **Template Inclusion** — Importing separate HTML files via `{% include "filename.html" %}`
4. **Variable Interpolation** — Displaying dynamic data using `{{ variable_name }}` syntax
5. **Syntax Rules** — Jinja uses `{% %}` for actions (conditionals, loops, includes) and `{{ }}` for displaying values

```jinja2
{% if user %}
  <title>Hey there {{ user }}</title>
{% else %}
  <title>I don't know you!</title>
{% endif %}
{% include "header.html" %}
{% include "content.html" %}
{% include "footer.html" %}
```

```jinja2
<img src="{{ url_for('static', filename='sarah-and-duck.jpeg') }}">
```
