---
title: "Accessing HuggingFace ML datasets in Databricks"
url: "https://dev.to/encorepartners/accessing-huggingface-datasets-in-databricks-4k10"
author: "Jordan Smith"
category: "huggingface-llm-agents"
---
# Accessing HuggingFace ML datasets in Databricks
**Author:** Jordan Smith  **Published:** February 14, 2025

## Overview
This article explains how to integrate HuggingFace datasets into Databricks using Python. The author describes HuggingFace as a prominent platform in the AI and machine learning community, known for its extensive library of pre-trained models and datasets. The piece provides step-by-step guidance for importing, caching, and persisting datasets from HuggingFace into Unity Catalog for subsequent machine learning analysis.

## Key Concepts
- HuggingFace as an ML resource platform supporting NLP, computer vision, audio, and multimodal tasks
- Importance of caching for improving data warehouse performance
- Integration of HuggingFace with Databricks for streamlined data ingestion
- Use of Apache Spark for dataset manipulation
- Persistent storage in Unity Catalog

## Code Examples

### Python - Imports
```python
from datasets import load_dataset
from pyspark.sql import functions as F
```

### Python - Cache Directory Setup
```python
cache_dir = "dbfs/cache/"
```

### Python - Dataset Loading
```python
dataset = load_dataset("wykonos/movies", cache_dir=cache_dir, split="train[:25%]")
```

### Python - DataFrame Creation and Table Storage
```python
df = spark.createDataFrame(dataset)
df.write.mode("overwrite").saveAsTable(f"{path_table}" + "." + f"{table_name}")
```
