---
title: "Server-side rendering in Rust - a Dall.E use-case"
url: "https://dev.to/nfrankel/server-side-rendering-in-rust-a-dalle-use-case-33jp"
author: "Nicolas Fränkel"
category: "ai-image-video-generation"
---
# Server-side rendering in Rust - a Dall.E use-case
**Author:** Nicolas Fränkel  **Published:** 2023-05-04

## Overview
Builds a web application with server-side rendering in Rust using Axum + Tokio, integrating OpenAI's DALL-E image generation API. Explores Rust's templating ecosystem through this practical use case.

## Key Concepts

### Rust Web Stack
- **Axum:** Web framework
- **Tokio:** Async runtime
- **axum-template:** Abstraction over handlebars, askama, and minijinja (allows switching implementation without API changes)
- **MiniJinja:** Template engine used in this implementation

### HTML Templating in Rust
Unlike JSON REST APIs, HTML generation requires explicit templating. "If you create it manually, maintenance is going to be a nightmare."

### Setup

```rust
type AppEngine = Engine<Environment<'static>>;

#[derive(Clone, FromRef)]
struct AppState {
    engine: AppEngine,
}

#[tokio::main]
async fn main() {
    let mut jinja = Environment::new();
    jinja.set_source(Source::from_path("templates"));
    let app = Router::new()
        .route("/", get(home))
        .with_state(AppState {
            engine: Engine::from(jinja),
        });
}
```

### Single Return Type Handler

```rust
async fn call(engine: AppEngine, Form(state): Form<InitialPageState>) -> impl IntoResponse {
    RenderHtml(Key("home.html".to_owned()), engine, state)
}
```

### Multiple Return Types Handler

```rust
async fn call(engine: AppEngine, Form(state): Form<InitialPageState>) -> Response {
    let page_state = PageState::from(state);
    if page_state.either.is_left() {
        RenderHtml(Key("home.html".to_owned()), engine,
            page_state.either.left().unwrap()).into_response()
    } else {
        RenderHtml(Key("home.html".to_owned()), engine,
            page_state.either.right().unwrap()).into_response()
    }
}
```

### Key Rust Insight
When handlers return multiple types, use explicit `Response` type instead of `impl IntoResponse`, then call `.into_response()`. Per Rust by Example: "If your function returns a type that implements `MyTrait`, you can write its return type as `-> impl MyTrait`" — but this only works for single concrete types.

### DALL-E Integration
- Endpoint: `https://api.openai.com/v1/images/generations`
- Docker image: `nfrankel/rust-dalle:0.1.0`
- Run: `docker run -it --rm -p 3000:3000 -e OPENAI_TOKEN=... nfrankel/rust-dalle:0.1.0`

## GitHub Repository
[nfrankel/rust-dalle](https://github.com/nfrankel/rust-dalle) — Rust facade for OpenAI DALL-E API calls with Axum SSR frontend
