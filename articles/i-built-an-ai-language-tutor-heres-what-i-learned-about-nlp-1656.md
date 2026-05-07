---
title: "I Built an AI Language Tutor - Here's What I Learned About NLP"
url: "https://dev.to/pocket_linguist/i-built-an-ai-language-tutor-heres-what-i-learned-about-nlp-1656"
author: "Ahmed Mahmoud"
category: "conversational-ai-agent-nlp"
---

# I Built an AI Language Tutor - Here's What I Learned About NLP

**Author:** Ahmed Mahmoud
**Published:** February 25, 2026

## Overview

Details the technical architecture behind a conversational language learning application, covering vocabulary grading, intent classification via session state machines, pedagogically-informed error correction, and multi-language tokenization supporting 20+ languages.

## Key Concepts

### Vocabulary Grading System (Python)

Two-pass approach: generate response, then check/rewrite vocabulary above CEFR target level.

```python
def grade_vocabulary(text: str, target_level: str, lang: str) -> dict:
    doc = nlp_models[lang](text)
    lemmas = [token.lemma_.lower() for token in doc if token.is_alpha]
    above_level = [
        w for w in lemmas
        if cefr_level(w, lang) > target_level
    ]
    return {
        "flagged": above_level,
        "needs_rewrite": len(above_level) > 0,
    }
```

### Session State Machine (Python)

```python
from enum import Enum

class SessionMode(Enum):
    FREE_CONVERSATION = "free"
    CORRECTION = "correction"
    VOCAB_DRILL = "vocab_drill"
    TRANSLATION = "translation"
    PRONUNCIATION = "pronunciation"
```

### Error Correction Strategy (Python)

Uses fine-tuned DistilBERT trained on NUCLE corpus. Limits corrections to 2-3 per turn to preserve learner motivation.

```python
def select_corrections(errors: list[dict], level: str) -> list[dict]:
    if level in ("A1", "A2"):
        return [e for e in errors if e["severity"] == "blocking"][:2]
    return [e for e in errors if e["severity"] in ("blocking", "morphological")][:3]
```

### Multi-Language Tokenization (Python)

```python
TOKENISERS = {
    "en": lambda text: en_nlp(text),
    "de": lambda text: de_nlp(text),
    "ja": lambda text: mecab_tokenise(text),
    "zh": lambda text: jieba_tokenise(text),
    "ar": lambda text: cameltools_tokenise(text),
}

def tokenise(text: str, lang: str) -> list[str]:
    tokeniser = TOKENISERS.get(lang, default_tokeniser)
    return tokeniser(text)
```

### Performance Optimization

Initial latency of 2.4 seconds reduced to 680ms (p50) through:
- Server-sent events for response streaming
- Vocabulary check caching
- Asynchronous CEFR grading
- Smaller local error detection models (8ms vs 400ms)

### Lessons Learned

1. Implement state machines from project inception
2. Build evaluation datasets early (NUCLE, BEA-2019, Lang-8)
3. Separate LLM calls from validation logic
4. Budget 3x longer for Japanese vs Spanish language support
