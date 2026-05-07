---
title: "My first successful LLM fine tuning"
url: "https://dev.to/maxfrecka/my-first-successful-llm-fine-tuning-ila"
author: "Max Frecka"
category: "llm-fine-tuning-agent"
---

# My first successful LLM fine tuning

**Author:** Max Frecka
**Published:** May 23, 2025

## Overview

A first-hand account of fine-tuning Mistral to create a personalized lyric generation system, covering hardware challenges, dataset construction, training on AWS SageMaker, and LoRA adapter conversion.

## Key Concepts

### Hardware Journey

- Initial: RTX 2060 Super (insufficient)
- Upgraded to AWS SageMaker g5.2xlarge, then g5.12xlarge
- Training: 3 epochs on 1,000 entries, ~40 minutes
- Used 250-step checkpoint (first epoch) to avoid overfitting

### Dataset Construction

Combined ~400 lines of original lyrics (YAML) with randomly generated word sequences from expanded vocabulary.

```python
def generate_dataset2(iterations=30):
    training_data = []
    for i in range(iterations):
        prompt = generate_dataset_prompt()
        generated_response = generate_abstract_response()
        training_data.append({
            "instruction": prompt,
            "response": generated_response
        })
    with open("trainingdataset.json", "w", encoding="utf-8") as f:
        json.dump(training_data, f, ensure_ascii=False, indent=2)
```

```python
def generate_abstract_response(iterations=10):
    output = ""
    with open("wordlist.txt", "r", encoding="utf-8") as f:
        wordlist = [line.strip() for line in f if line.strip()]
    for i in range(iterations):
        line = ""
        if random.random() < 0.7:
            line=get_random_yaml_sequence("lyriclines.yaml","dogalyrics")+"\n"
        else:
            line=generate_random_sequence(wordlist) + '\n'
        output+=line
    return output
```

### Word List Expansion via Datamuse API

```python
import csv, os, datetime, time, random, requests

words = ["bop", "roo", "cash", "spot", "big", "noise", "sound",
         "box", "future", "now", "meow", "alien", "moon",
         "high", "max", "global", "ear", "cat", "monkey",
         "road", "play", "station", "poly", "glitch", "picture",
         "pop", "center", "media", "dolphin", "frequency",
         "information", "dataset", "data", "number", "hear"]

def get_synonyms_antonyms(word):
    try:
        syn_resp = requests.get(f"https://api.datamuse.com/words?rel_syn={word}").json()
        ant_resp = requests.get(f"https://api.datamuse.com/words?rel_ant={word}").json()
        synonyms = [entry["word"] for entry in syn_resp]
        antonyms = [entry["word"] for entry in ant_resp]
        return synonyms + antonyms
    except Exception as e:
        print(f"Error fetching for word {word}: {e}")
        return []

extended_words = set(words)
for word in words:
    related_words = get_synonyms_antonyms(word)
    extended_words.update(related_words)
    time.sleep(0.2)

with open("wordlist.txt", "w", encoding="utf-8") as f:
    for word in sorted(extended_words):
        f.write(word + "\n")
```

### Key Learning

"Clearly the dataset is the key point when fine-tuning. Improving the dataset is the main thing."
