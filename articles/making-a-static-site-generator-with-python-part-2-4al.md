---
title: "Making a Static Site Generator with Python - part 2"
url: "https://dev.to/nqcm/making-a-static-site-generator-with-python-part-2-4al"
author: "TheNiqabiCoderMum"
category: "templatized-software"
---
# Making a Static Site Generator with Python - part 2
**Author:** TheNiqabiCoderMum  **Published:** May 3, 2019

## Overview
This tutorial demonstrates building a functional static site generator (SSG) using Python, Markdown2, and Jinja2. Constructs a recipe blog with a home page listing all posts and individual post pages.

## Key Concepts
1. **File Organization**: Create `content/` for markdown files, `templates/` for HTML templates, `output/` for generated files
2. **Markdown Processing**: Parse multiple markdown files with metadata using the markdown2 library
3. **Template Inheritance**: Use Jinja2's `{% extends %}` and `{% block %}` tags to eliminate code repetition
4. **Dynamic Rendering**: Convert markdown content and metadata into HTML pages programmatically
5. **Post Sorting**: Organize posts chronologically by converting date strings to datetime objects

```python
POSTS = {}
for markdown_post in os.listdir('content'):
    file_path = os.path.join('content', markdown_post)
    with open(file_path, 'r') as file:
        POSTS[markdown_post] = markdown(file.read(), extras=['metadata'])
```

```python
POSTS = {post: POSTS[post] for post in sorted(POSTS,
  key=lambda post: datetime.strptime(POSTS[post].metadata['date'],
  '%Y-%m-%d'), reverse=True)}
```

```html
{% block content %} {% endblock %}
```

```html
{% extends "layout.html" %}
{% block content %}
  <!-- page-specific content -->
{% endblock %}
```

```python
home_html = home_template.render(posts=posts_metadata)
with open('output/home.html', 'w') as file:
    file.write(home_html)
```

```python
for post in POSTS:
    post_html = post_template.render(post=post_data)
    os.makedirs(os.path.dirname(post_file_path), exist_ok=True)
    with open(post_file_path, 'w') as file:
        file.write(post_html)
```

GitHub: https://github.com/nqcm/static-site-generator
