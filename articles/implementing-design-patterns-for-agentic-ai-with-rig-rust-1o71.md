---
title: "Implementing Design Patterns for Agentic AI with Rig and Rust"
url: "https://dev.to/joshmo_dev/implementing-design-patterns-for-agentic-ai-with-rig-rust-1o71"
author: "Josh Mo"
category: "AI agent Rust"
---

# Implementing Design Patterns for Agentic AI with Rig and Rust

**Author:** Josh Mo
**Published:** February 26, 2025

## Overview
This tutorial explores six agentic AI design patterns using the Rig framework in Rust, based on Anthropic's agent-building research. Patterns include prompt chaining, routing, parallelization, orchestrator-worker, evaluator-optimizer, and autonomous agents.

## Key Concepts

### Pattern 1: Prompt Chaining

Decomposes a task into smaller steps where LLM calls are piped sequentially.

```rust
use std::env;
use rig::providers::openai::Client;

#[tokio::main]
async fn main() -> Result<(), anyhow::Error> {
    let openai_api_key = env::var("OPENAI_API_KEY").expect("OPENAI_API_KEY not set");
    let openai_client = Client::new(&openai_api_key);

    let rng_agent = openai_client.agent("gpt-4")
        .preamble("You are a random number generator designed to only either output a single whole integer that is 0 or 1. Only return the number.")
        .build();

    let adder_agent = openai_client.agent("gpt-4")
        .preamble("You are a mathematician who adds 1000 to every number passed into the context, except if the number is 0 - in which case don't add anything. Only return the number.")
        .build();

    let chain = rig::pipeline::new()
        .prompt(rng_agent)
        .map(|x| x.unwrap())
        .prompt(adder_agent);

    let response = chain
        .call("Please generate a single whole integer that is 0 or 1".to_string())
        .await;

    println!("Pipeline result: {response:?}");
    Ok(())
}
```

### Pattern 2: Prompt Routing

Categorizes user statements into topics and adjusts responses accordingly.

```rust
use std::env;
use rig::providers::openai::Client;

#[tokio::main]
async fn main() -> Result<(), anyhow::Error> {
    let openai_api_key = env::var("OPENAI_API_KEY").expect("OPENAI_API_KEY not set");
    let openai_client = Client::new(&openai_api_key);

    let animal_agent = openai_client.agent("gpt-4")
        .preamble("Your role is to categorise the user's statement using the following values: [sheep, cow, dog]\n\nReturn only the value.")
        .build();

    let default_agent = openai_client.agent("gpt-4").build();

    let chain = rig::pipeline::new()
        .prompt(animal_agent)
        .map_ok(|x: String| match x.trim() {
            "cow" => Ok("Tell me a fact about the United States of America.".to_string()),
            "sheep" => Ok("Calculate 5+5 for me. Return only the number.".to_string()),
            "dog" => Ok("Write me a poem about cashews".to_string()),
            message => Err(format!("Could not process - received category: {message}")),
        })
        .map(|x| x.unwrap().unwrap())
        .prompt(default_agent);

    let response = chain.try_call("Sheep can self-medicate").await?;
    println!("Pipeline result: {response:?}");
    Ok(())
}
```

### Pattern 3: Parallelization

Sends multiple API calls simultaneously and combines results.

```rust
use schemars::JsonSchema;

#[derive(serde::Deserialize, JsonSchema, serde::Serialize)]
struct DocumentScore {
    score: f32,
}
```

```rust
use std::env;
use rig::providers::openai::Client;

#[tokio::main]
async fn main() -> Result<(), anyhow::Error> {
    let openai_api_key = env::var("OPENAI_API_KEY").expect("OPENAI_API_KEY not set");
    let openai_client = Client::new(&openai_api_key);

    let manipulation_agent = openai_client
        .extractor::<DocumentScore>("gpt-4")
        .preamble("Your role is to score a user's statement on how manipulative it sounds between 0 and 1.")
        .build();

    let depression_agent = openai_client
        .extractor::<DocumentScore>("gpt-4")
        .preamble("Your role is to score a user's statement on how depressive it sounds between 0 and 1.")
        .build();

    let intelligent_agent = openai_client
        .extractor::<DocumentScore>("gpt-4")
        .preamble("Your role is to score a user's statement on how intelligent it sounds between 0 and 1.")
        .build();

    use rig::pipeline::agent_ops::extract;
    use rig::{parallel, pipeline::{self, passthrough, Op}};

    let chain = pipeline::new()
        .chain(parallel!(
            passthrough(),
            extract(manipulation_agent),
            extract(depression_agent),
            extract(intelligent_agent)
        ))
        .map(|(statement, manip_score, dep_score, int_score)| {
            format!(
                "Original statement: {statement}\nManipulation sentiment score: {}\nDepression sentiment score: {}\nIntelligence sentiment score: {}",
                manip_score.unwrap().score,
                dep_score.unwrap().score,
                int_score.unwrap().score
            )
        });

    let response = chain
        .call("I hate swimming. The water always gets in my eyes.")
        .await;

    println!("Pipeline run: {response:?}");
    Ok(())
}
```

### Pattern 4: Orchestrator-Worker

Central orchestrator manages multiple agents across a pipeline.

```rust
use schemars::JsonSchema;

#[derive(serde::Deserialize, JsonSchema, serde::Serialize, Debug)]
struct Specification {
    tasks: Vec<Task>,
}

#[derive(serde::Deserialize, JsonSchema, serde::Serialize, Debug)]
struct Task {
    original_task: String,
    style: String,
    guidelines: String,
}

#[derive(serde::Deserialize, JsonSchema, serde::Serialize, Debug)]
struct TaskResults {
    style: String,
    response: String,
}
```

```rust
use std::env;
use rig::providers::openai::Client;

const CLASSIFY_PREAMBLE: &str = "Analyze the given task and break it down into 2-3 distinct approaches.\n\nProvide an Analysis and 2-3 approaches to tackle the task.";

#[tokio::main]
async fn main() -> Result<(), anyhow::Error> {
    let openai_api_key = env::var("OPENAI_API_KEY").expect("OPENAI_API_KEY not set");
    let openai_client = Client::new(&openai_api_key);

    let classify_agent = openai_client.extractor::<Specification>("gpt-4")
        .preamble(CLASSIFY_PREAMBLE)
        .build();

    let specification = classify_agent.extract("Write a product description for a new eco-friendly water bottle.").await.unwrap();

    let content_agent = openai_client
        .extractor::<TaskResults>("gpt-4")
        .preamble("Generate content based on the original task, style, and guidelines.\n\nReturn only your response and the style you used as a JSON object.")
        .build();

    let mut vec: Vec<TaskResults> = Vec::new();

    for task in specification.tasks {
        let results = content_agent
            .extract(&format!("Task: {},\nStyle: {},\nGuidelines: {}", task.original_task, task.style, task.guidelines))
            .await
            .unwrap();
        vec.push(results);
    }

    let judge_agent = openai_client
        .extractor::<Specification>("gpt-4")
        .preamble("Analyze the given written materials and decide the best one.")
        .build();

    let task_results_raw_json = serde_json::to_string_pretty(&vec).unwrap();
    let results = judge_agent.extract(&task_results_raw_json).await.unwrap();

    println!("Results: {results:?}");
    Ok(())
}
```

### Pattern 5: Evaluator-Optimizer

LLM completes tasks and improves based on feedback in a loop.

```rust
use schemars::JsonSchema;

#[derive(serde::Deserialize, JsonSchema, serde::Serialize, Debug)]
struct Evaluation {
    evaluation_status: EvalStatus,
    feedback: String,
}

#[derive(serde::Deserialize, JsonSchema, serde::Serialize, Debug, PartialEq)]
enum EvalStatus {
    Pass,
    NeedsImprovement,
    Fail,
}
```

```rust
use std::env;
use rig::{completion::Prompt, providers::openai::Client};

const TASK: &str = "Implement a Stack with push(x), pop(), getMin(). All O(1).";

#[tokio::main]
async fn main() -> Result<(), anyhow::Error> {
    let openai_api_key = env::var("OPENAI_API_KEY").expect("OPENAI_API_KEY not set");
    let openai_client = Client::new(&openai_api_key);

    let generator_agent = openai_client
        .agent("gpt-4")
        .preamble("Complete the task. Reflect on feedback to improve your solution.")
        .build();

    let evaluator_agent = openai_client.extractor::<Evaluation>("gpt-4")
        .preamble("Evaluate code for correctness, time complexity, style. Only PASS if all criteria met.")
        .build();

    let mut memories: Vec<String> = Vec::new();
    let mut response = generator_agent.prompt(TASK).await.unwrap();
    memories.push(response.clone());

    loop {
        let eval_result = evaluator_agent
            .extract(&format!("{TASK}\n\n{response}"))
            .await
            .unwrap();

        if eval_result.evaluation_status == EvalStatus::Pass {
            break;
        } else {
            let context = format!("{TASK}\n\n{}", eval_result.feedback);
            response = generator_agent.prompt(context).await.unwrap();
            memories.push(response.clone());
        }
    }

    println!("Response: {response}");
    Ok(())
}
```

### Pattern 6: Autonomous Agent

Executes tasks autonomously until achieving a goal with no human intervention.

```rust
use rig::providers::openai::Client;
use std::env;

#[tokio::main]
async fn main() -> Result<(), anyhow::Error> {
    let openai_api_key = env::var("OPENAI_API_KEY").expect("OPENAI_API_KEY not set");
    let openai_client = Client::new(&openai_api_key);

    let agent = openai_client.extractor::<Counter>("gpt-4")
        .preamble("Your role is to add a random number between 1 and 64 to the previous number.")
        .build();

    let mut number: u32 = 0;
    let mut interval = tokio::time::interval(std::time::Duration::from_secs(1));

    loop {
        let response = agent.extract(&number.to_string()).await.unwrap();
        if response.number >= 2000 {
            break;
        } else {
            number += response.number
        }
        interval.tick().await;
    }

    println!("Finished with number: {number:?}");
    Ok(())
}
```
