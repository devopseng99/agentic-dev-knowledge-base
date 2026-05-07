---
title: "Making a Static Site Generator with Python - part 1"
url: "https://dev.to/nqcm/making-a-static-site-generator-with-python-part-1-3kn3"
author: "TheNiqabiCoderMum"
category: "templatized-software"
---
# Making a Static Site Generator with Python - part 1
**Author:** TheNiqabiCoderMum  **Published:** May 2, 2019

## Overview
This tutorial demonstrates how to build a static site generator (SSG) from scratch using Python, covering converting markdown files to HTML and rendering them with Jinja2 templates.

## Key Concepts
1. **Static Site Generators**: Secure, fast alternatives to CMSs that convert markdown content into pre-built HTML templates
2. **Markdown Parsing**: Using the `markdown2` library to convert markdown syntax into HTML while extracting metadata
3. **Template Rendering**: Employing Jinja2 to inject parsed data into HTML templates with variable placeholders
4. **Project Structure**: Organizing content in dedicated folders with separate directories for markdown files and templates

```python
from markdown2 import markdown
markdown("**This is a very important message**")
# outputs '<p><strong>This is a very important message</strong></p>\n'
```

```python
from markdown2 import markdown
with open('content/turkish-pide.md', 'r') as file:
    parsed_md = markdown(file.read(), extras=['metadata'])
print('Metadata: ', parsed_md.metadata)
```

```python
from jinja2 import Environment, PackageLoader
env = Environment(loader=PackageLoader('main', 'templates'))
test_template = env.get_template('test.html')
data = {
    'content': parsed_md,
    'title': parsed_md.metadata['title'],
    'date': parsed_md.metadata['date']
}
print(test_template.render(post=data))
```

```html
<title>{{ post.title }}</title>
<h1>{{ post.title }}</h1>
<small>{{ post.date }}</small>
<p>{{ post.content }}</p>
```

GitHub: https://github.com/nqcm/static-site-generator
