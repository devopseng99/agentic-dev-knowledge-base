---
title: "Rust Async Patterns in Tauri — Keeping the UI Responsive While Rust Does Heavy Work"
url: "https://dev.to/hiyoyok/rust-async-patterns-in-tauri-keeping-the-ui-responsive-while-rust-does-heavy-work-e9d"
author: "hiyoyo"
category: "code-optimization"
---
# Rust Async Patterns in Tauri — Keeping the UI Responsive While Rust Does Heavy Work
**Author:** hiyoyo  **Published:** May 5, 2026

## Overview
Practical patterns for keeping Tauri desktop apps responsive during CPU-intensive and I/O-heavy Rust operations. The key insight: Tauri's JavaScript frontend runs on the main thread; blocking it causes UI freezes. The solution is async Tauri commands and spawn_blocking for CPU work.

## Key Concepts

### The Three Patterns

**Pattern 1: Async I/O commands**
For network requests, file operations, database queries. Use async fn + tokio I/O. Non-blocking, efficient.

**Pattern 2: spawn_blocking for CPU work**
For image processing, parsing, cryptography. CPU work in async context blocks the tokio thread pool. Move to dedicated thread pool via spawn_blocking.

**Pattern 3: Progress reporting via events**
For long operations, emit Tauri events from Rust to update a progress bar in the frontend without blocking.

### The Rule
- I/O bound -> async fn directly
- CPU bound -> tokio::task::spawn_blocking
- Long running -> spawn_blocking + emit events

## Key Code Examples

```rust
// Pattern 1: Async I/O - network request in Tauri command
use tauri::command;

#[command]
async fn fetch_data(url: String) -> Result<String, String> {
    // Non-blocking HTTP request - doesn't block UI thread
    let response = reqwest::get(&url)
        .await
        .map_err(|e| e.to_string())?;

    let body = response.text()
        .await
        .map_err(|e| e.to_string())?;

    Ok(body)
}
```

```rust
// Pattern 2: spawn_blocking for CPU-intensive work
use tauri::command;
use tokio::task;
use image::{ImageFormat, DynamicImage};

#[command]
async fn process_image(path: String) -> Result<String, String> {
    // DON'T do this - blocks tokio thread pool
    // let img = image::open(&path)?;
    // let resized = img.resize(800, 600, FilterType::Lanczos3);

    // DO this - moves CPU work to dedicated thread pool
    let result = task::spawn_blocking(move || -> Result<String, String> {
        let img = image::open(&path)
            .map_err(|e| e.to_string())?;

        // CPU-intensive resize on its own thread
        let resized = img.resize(800, 600, image::imageops::FilterType::Lanczos3);

        let output_path = path.replace(".jpg", "_resized.jpg");
        resized.save(&output_path)
            .map_err(|e| e.to_string())?;

        Ok(output_path)
    }).await.map_err(|e| e.to_string())??;

    Ok(result)
}
```

```rust
// Pattern 3: Progress reporting via events
use tauri::{command, Window};

#[command]
async fn process_large_file(window: Window, path: String) -> Result<(), String> {
    let total_lines = count_lines(&path).await?;

    // Spawn blocking CPU work with progress updates
    let window_clone = window.clone();
    task::spawn_blocking(move || -> Result<(), String> {
        let file = std::fs::File::open(&path)
            .map_err(|e| e.to_string())?;
        let reader = std::io::BufReader::new(file);

        for (i, line) in std::io::BufRead::lines(reader).enumerate() {
            let line = line.map_err(|e| e.to_string())?;
            process_line(&line);

            // Emit progress every 1000 lines
            if i % 1000 == 0 {
                let progress = (i as f64 / total_lines as f64 * 100.0) as u32;
                window_clone.emit("progress", progress).ok();
            }
        }
        Ok(())
    }).await.map_err(|e| e.to_string())??;

    window.emit("complete", ()).ok();
    Ok(())
}
```

```javascript
// Frontend: listen to progress events
import { listen } from '@tauri-apps/api/event';
import { invoke } from '@tauri-apps/api/tauri';

async function processFile(path) {
    // Subscribe to progress before starting
    const unlisten = await listen('progress', (event) => {
        updateProgressBar(event.payload);  // 0-100
    });

    const completionPromise = new Promise((resolve) => {
        listen('complete', () => resolve());
    });

    // Start processing - returns immediately, progress comes via events
    await invoke('process_large_file', { path });
    await completionPromise;

    unlisten();  // Clean up listener
    hideProgressBar();
}
```

## Performance Notes
- spawn_blocking uses a separate thread pool (default: 512 threads, expandable)
- emit() is async from Rust's perspective but synchronous in JS - no message ordering issues
- For parallel CPU work across multiple files: join all spawn_blocking tasks with futures::join_all
- Memory: each spawn_blocking task gets ~8MB stack by default; adjust with Builder::thread_stack_size
