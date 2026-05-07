---
title: "Binja: Finally, a Fast Jinja2/Django Template Engine for Bun"
url: "https://dev.to/egeominotti/binja-finally-a-fast-jinja2django-template-engine-for-bun-1li4"
author: "Egeo Minotti"
category: "templatized-software"
---
# Binja: Finally, a Fast Jinja2/Django Template Engine for Bun
**Author:** Egeo Minotti  **Published:** January 22, 2026

## Overview
Introduces binja, a high-performance template engine designed for the Bun JavaScript runtime. Created to address performance and compatibility gaps when migrating Django applications to Bun/Elysia.

## Key Concepts
**Performance Advantages**:
- Runtime rendering operates 2-4x faster than Nunjucks
- Ahead-of-time (AOT) compilation achieves 14+ million operations per second — approximately 160x faster than Nunjucks
- Synchronous rendering eliminates async/await overhead

**Django/Jinja2 Compatibility**:
- 84 built-in filters and 28 built-in tests
- Supports Django-specific features: `csrf_token`, `cycle`, `regroup`, `lorem` tags
- Template inheritance via `extends` and `block` directives
- Autoescape enabled by default

**Multi-Engine Support**: Can parse Handlebars, Liquid, and Twig syntax alongside Jinja2

```javascript
import { compile } from 'binja'

const templates = {
  home: compile(await Bun.file('./views/home.html').text()),
  user: compile(await Bun.file('./views/user.html').text()),
}

app.get('/', () => templates.home({ title: 'Welcome' }))
```

```javascript
import * as handlebars from 'binja/engines/handlebars'
import * as liquid from 'binja/engines/liquid'

await handlebars.render('{{#each items}}{{this}}{{/each}}', { items: ['a', 'b'] })
await liquid.render('{% for item in items %}{{ item }}{% endfor %}', { items: ['a', 'b'] })
```

```javascript
import { Elysia } from 'elysia'
import { binja } from 'binja/elysia'

const app = new Elysia()
  .use(binja({ root: './views', cache: true }))
  .get('/', ({ render }) => render('index', { title: 'Home' }))
  .listen(3000)
```

```javascript
import { render } from 'binja'

const html = await render('Hello, {{ name|title }}!', { name: 'world' })
// Output: Hello, World!
```

```javascript
import { Environment } from 'binja'

const env = new Environment({
  templates: './templates',
  autoescape: true,
})

const html = await env.render('pages/home.html', { user })
```

GitHub: github.com/egeominotti/binja
npm: npmjs.com/package/binja
