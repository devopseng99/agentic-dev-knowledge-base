---
title: "Building a Local and Private LLM Server in Rust"
url: "https://dev.to/alexandrughinea/building-a-local-and-private-llm-server-in-rust-32kp"
author: "Alex"
category: "immutable-arch-rust-flink"
---
# Building a Local and Private LLM Server in Rust
**Author:** Alex  **Published:** August 2, 2024

## Overview
High-performance LLM inference server using Rust, Tokio, and Actix-web. Configurable, lite, local, and private. Uses `web::Data<T>` which wraps state in `Arc<T>` for safe concurrent access across threads without data duplication.

## Key Concepts

```rust
#[derive(Debug, Clone)]
pub struct Config {
    pub server_address: String,
    pub server_port: u16,
    pub llm_model: String,
    pub llm_model_architecture: String,
    pub llm_inference_max_token_count: usize,
    // ...
}
```

```rust
#[actix_web::main]
async fn main() -> std::io::Result<()> {
    let model = llm::load_dynamic(
        model_architecture,
        &model_path,
        Default::default(),
        llm::load_progress_callback_stdout,
    ).unwrap_or_else(|err| panic!("Failed to load model: {}", err));

    let app_state = web::Data::new(AppState { model, config: config.clone() });

    HttpServer::new(move || {
        App::new()
            .app_data(app_state.clone())
            .wrap(Cors::default()
                .allowed_origin(&config.allowed_origin)
                .allowed_methods(vec!["GET", "POST"]))
            .route("/", web::get().to(server_info_handler))
            .service(
                web::scope("/api")
                    .route("/generate", web::post().to(generate_handler))
                    .route("/health", web::get().to(health_handler)),
            )
    })
    .bind_openssl(complete_address, ssl_builder)?
    .run()
    .await
}
```

```rust
fn run_inference_session(config: &Config, model: &Box<dyn Model>, prompt: String) -> Result<String, InferenceError> {
    let mut inference_session = model.start_session(Default::default());
    let inference_session_result = inference_session.infer::<Infallible>(
        model.as_ref(),
        &mut rand::thread_rng(),
        &mut llm::InferenceRequest {
            prompt: (&*prompt).into(),
            parameters: Option::from(&llm::InferenceParameters::default()),
            play_back_previous_tokens: false,
            maximum_token_count: Some(config.llm_inference_max_token_count),
        },
        &mut Default::default(),
        |response| { print!("{response}"); std::io::stdout().flush().unwrap(); Ok(()) },
    );
    match inference_session_result {
        Ok(_) => Ok(String::new()),
        Err(err) => Err(err),
    }
}
```

Streaming response:
```rust
pub async fn generate_stream(data: web::Data<AppState>, body: Json<GenerateRequest>) -> impl Responder {
    let (tx, rx) = mpsc::channel(100);
    actix_web::rt::spawn(async move {
        run_inference_session_streaming(&data.config, &data.model, &body.prompt, tx).await;
    });
    HttpResponse::Ok()
        .content_type("text/event-stream")
        .streaming(rx.map(|token| Ok(Bytes::from(token)) as Result<Bytes, actix_web::Error>))
}
```

Supported architectures: BLOOM, GPT-2, GPT-J, LLaMA, GPT-NeoX.
