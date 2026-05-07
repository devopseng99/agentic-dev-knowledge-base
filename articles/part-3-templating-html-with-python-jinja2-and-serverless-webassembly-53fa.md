---
title: "Part 3: Templating HTML with Python, Jinja2 and serverless WebAssembly"
url: "https://dev.to/fermyon/part-3-templating-html-with-python-jinja2-and-serverless-webassembly-53fa"
author: "Matt Butcher"
category: "templatized-software"
---
# Part 3: Templating HTML with Python, Jinja2 and serverless WebAssembly
**Author:** Matt Butcher  **Published:** January 4, 2024

## Overview
This article demonstrates building the frontend of a serverless bookmarking application using Python and WebAssembly. Focuses on serving HTML files, implementing Jinja2 templating, and dynamically displaying stored bookmarks from a Key-Value store in the Spin WebAssembly framework.

## Key Concepts
1. **Static File Serving**: Loading and serving HTML files from within a Python application
2. **Spin Security Model**: Applications operate within a pseudo-filesystem where only explicitly granted files (via `spin.toml`) are accessible
3. **Jinja2 Template Engine**: A Python templating library for dynamic HTML generation through variable substitution and control structures
4. **Template Variables**: Passing Python objects to templates for rendering
5. **Template Loops**: Using Jinja2's `for...in` syntax to iterate through collections

```python
from jinja2 import Environment, FileSystemLoader, select_autoescape

env = Environment(loader=FileSystemLoader("/"), autoescape=select_autoescape())
template = env.get_template("index.html")
buf = template.render(title="Bookmarker", bookmarks=bookmarks)
```

```html
<h1 class="title is-1">{{title}}</h1>
```

```html
{% for bookmark in bookmarks %}
<li><a href="{{bookmark.url}}">{{bookmark.title}}</a></li>
{% endfor %}
```

```toml
files = ["index.html"]
```

Spin Framework: https://developer.fermyon.com/spin/v2/index
Jinja2 Docs: https://jinja.palletsprojects.com/en/3.1.x/
