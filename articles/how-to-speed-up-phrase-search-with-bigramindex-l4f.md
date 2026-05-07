---
title: "How to Speed Up Phrase Search with bigram_index"
url: "https://dev.to/sanikolaev/how-to-speed-up-phrase-search-with-bigramindex-l4f"
author: "Sergey Nikolaev"
category: "code-optimization"
---
# How to Speed Up Phrase Search with bigram_index
**Author:** Sergey Nikolaev  **Published:** May 7, 2026

## Overview
bigram_index accelerates phrase search by pre-storing adjacent token pairs. Benchmark demonstrated approximately 2.9x improvement in queries per second and 3.2x reduction in latency on a 1M-document dataset. Important caveat: bigrams operate at tokenization level only and do not account for morphology, wordforms, or stopwords.

## Key Concepts

### What Bigram Indexing Does
Stores adjacent token pairs (e.g., "noise cancelling" and "cancelling headphones" from "noise cancelling headphones"). Enables faster candidate document narrowing during phrase matching.

### Four Performance Modes

**Mode 1: Default (no bigrams)** - Use when phrase search is rare, documents are short, or you want minimal indexing overhead.

**Mode 2: all** - Every adjacent token pair becomes a bigram. Use when exact phrase search is critical and phrases frequently include common words.

**Mode 3: first_freq** - Stores pairs only when first token is in frequent-word list. Lighter alternative to 'all' for phrases with common bridge words.

**Mode 4: both_freq** - Stores pairs only when both tokens are frequent. Conservative bigram footprint.

## Key Code Examples

```sql
-- Mode 1: Default behavior
CREATE TABLE bi_none_demo(title text);
SELECT id, title FROM bi_none_demo WHERE MATCH('"noise cancelling"');
```

```sql
-- Mode 2: All bigrams
CREATE TABLE bi_all_demo(title text)
  bigram_index='all';

INSERT INTO bi_all_demo VALUES
  (1,'lord of the rings trilogy'),
  (2,'house of the dragon season 2'),
  (3,'made for iphone charger');

SELECT id, title FROM bi_all_demo WHERE MATCH('"house of the dragon"');
SELECT id, title FROM bi_all_demo WHERE MATCH('"made for iphone"');
```

```sql
-- Mode 3: first_freq
CREATE TABLE bi_first_freq_demo(title text)
  bigram_index='first_freq'
  bigram_freq_words='for,of,the,with';

SELECT id, title FROM bi_first_freq_demo WHERE MATCH('"made for iphone"');
```

```sql
-- Mode 4: both_freq
CREATE TABLE bi_both_freq_demo(title text)
  bigram_index='both_freq'
  bigram_freq_words='for,of,the,with';

SELECT id, title FROM bi_both_freq_demo WHERE MATCH('"lord of the"');
```

## Benchmark Results

**Setup:** 1M-document tables, 5,000 random 2-word phrase queries, single-threaded.

| Configuration | QPS | Avg Latency |
|---|---|---|
| Without bigrams | 755 | 1.3 ms |
| With bigram_index='all' | 2,175 | 0.4 ms |

Indexing speed trade-off: without bigrams (~45k docs/sec) vs with 'all' (~17k docs/sec).

## Recommendations
Start with both_freq for general phrase-search workloads. Move to 'all' if stronger acceleration is needed and indexing cost is acceptable. Consider first_freq when phrases heavily involve common bridge words.
