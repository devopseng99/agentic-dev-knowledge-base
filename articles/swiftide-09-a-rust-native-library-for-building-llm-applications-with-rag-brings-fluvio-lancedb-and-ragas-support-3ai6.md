---
title: "Swiftide 0.9: Rust Native Library for Building LLM Applications with RAG"
url: "https://dev.to/timonv/swiftide-09-a-rust-native-library-for-building-llm-applications-with-rag-brings-fluvio-lancedb-and-ragas-support-3ai6"
author: "Timon Vonk"
category: "immutable-arch-rust-flink"
---
# Swiftide 0.9: Rust Native Library for Building LLM Applications with RAG
**Author:** Timon Vonk  **Published:** September 2, 2024

## Overview
Swiftide 0.9 adds Fluvio (Rust streaming), LanceDB (Apache Arrow vector store), and RAGAS evaluation to this Rust-native RAG pipeline library. Enables real-time indexing from Rust streaming systems directly into vector databases.

## Key Concepts

Fluvio streaming integration (Rust-native distributed streaming):
```rust
static TOPIC_NAME: &str = "hello-rust";
static PARTITION_NUM: u32 = 0;

let loader = Fluvio::builder()
    .consumer_config_ext(
        ConsumerConfigExt::builder()
            .topic(TOPIC_NAME)
            .partition(PARTITION_NUM)
            .offset_start(fluvio::Offset::from_end(1))
            .build()?,
    )
    .build()?;

indexing::Pipeline::from_loader(loader)
    .then_in_batch(10, Embed::new(FastEmbed::try_default().unwrap()))
    .then_store_with(
        Qdrant::builder()
            .batch_size(50)
            .vector_size(384)
            .collection_name("swiftide-examples")
            .build()?,
    )
    .run()
    .await?;
```

LanceDB (Apache Arrow + Tantivy, separates storage from compute):
```rust
let lancedb = LanceDB::builder()
  .uri(tempdir.child("lancedb").to_str()?)
  .vector_size(1536)
  .with_vector(EmbeddedField::Combined)
  .with_metadata(METADATA_QA_TEXT_NAME)
  .table_name("swiftide_test")
  .build()?;
```

RAGAS evaluation:
```rust
let ragas = evaluators::ragas::Ragas::from_prepared_questions(questions);
let pipeline = query::Pipeline::default()
    .evaluate_with(ragas.clone())
    .then_transform_query(GenerateSubquestions::from_client(context.openai.clone()))
    .then_transform_query(query_transformers::Embed::from_client(context.openai.clone()))
    .then_retrieve(context.qdrant.clone())
    .then_answer(Simple::from_client(context.openai.clone()));
pipeline.query_all(ragas.questions().await).await?;
let json = ragas.to_json().await;
```

```python
from ragas.metrics import answer_relevancy, faithfulness, context_recall, context_precision
from ragas import evaluate
from datasets import load_dataset

dataset = load_dataset("json", data_file='output.json')
result = evaluate(dataset, metrics=[answer_relevancy, faithfulness, context_recall, context_precision]).to_pandas()
```
