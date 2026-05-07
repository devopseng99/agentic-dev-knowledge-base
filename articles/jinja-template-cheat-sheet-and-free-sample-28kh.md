---
title: "Jinja Template - Cheat Sheet and FREE Samples"
url: "https://dev.to/sm0ke/jinja-template-cheat-sheet-and-free-sample-28kh"
author: "Sm0ke"
category: "templatized-software"
---
# Jinja Template - Cheat Sheet and FREE Samples
**Author:** Sm0ke  **Published:** September 15, 2020

## Overview
Guide introducing Jinja, a Python templating engine used by Flask, FastAPI, and Django frameworks. Explains how Jinja enables secure, efficient HTML/XML generation with practical applications through code samples and open-source project templates.

## Key Concepts
- **Template Engines**: "Jinja is a library for Python used by popular web frameworks like Flask and Django to serve HTML pages in a secure and efficient way."
- **Component Reusability**: Create separate HTML files and include them across multiple pages using include directives
- **Template Inheritance**: Define a base template that establishes the structure for all child templates
- **Control Structures**: Conditional statements and loops for manipulating lists and dictionaries
- **HTML Escaping**: Variables piped through `|e` filter to escape unsafe characters
- **Filters**: Apply transformations to template sections (e.g., converting text to uppercase)

```python
>>> from jinja2 import Template
>>> t = Template("Jinja {{ token }}!")
>>> t.render(token="works")
u'Jinja works!'
```

```html
{% include 'footer.html' %}
```

```html
<html>
  <head>
    <title>My Jinja {% block title %}{% endblock %}</title>
  </head>
  <body>
    <div class="container">
      <h2>This is from the base template</h2>
      {% block content %}{% endblock %}
    </div>
  </body>
</html>
```

```html
{% extends "base.html" %}
{% block title %}MySample{% endblock %}
{% block content %}Cool content here{% endblock %}
```

```html
<ul>
{% for user in users %}
  <li>{{ user }}</li>
{% endfor %}
</ul>
```

```html
<ul>
{% for user in users %}
  <li>{{ user.username|e }}</li>
{% else %}
  <li><em>no users found</em></li>
{% endfor %}
</ul>
```

```html
{% filter upper %}
  uppercase me
{% endfilter %}
```

```bash
git clone https://github.com/app-generator/jinja-volt-dashboard.git
cd jinja-volt-dashboard
virtualenv env
source env/bin/activate
pip3 install -r requirements.txt
export FLASK_APP=run.py
flask run
```

GitHub Repos:
- https://github.com/app-generator/jinja-volt-dashboard
- https://github.com/app-generator/jinja-datta-able
