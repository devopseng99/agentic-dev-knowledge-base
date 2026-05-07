---
title: "Optimizing LLM Context Windows: Reducing Token Usage by 40% with TOON and Rust"
url: "https://dev.to/copyleftdev/optimizing-llm-context-windows-reducing-token-usage-by-40-with-toon-and-rust-1j10"
author: "Mr. 0x1"
category: "immutable-arch-rust-flink"
---
# Optimizing LLM Context Windows: Reducing Token Usage by 40% with TOON and Rust
**Author:** Mr. 0x1  **Published:** January 17, 2026

## Overview
TOON (Token-Oriented Object Notation): data serialization format designed for LLM token efficiency. MCP server in Rust achieves 18-40% reduction in token usage. Header-row schematization eliminates redundant key declarations.

## Key Concepts
JSON vs TOON comparison:
```json
[
  { "id": "u_001", "name": "Alice Corp", "access_level": "admin", "region": "us-east-1" },
  { "id": "u_002", "name": "Bob Ltd", "access_level": "write", "region": "eu-west-1" },
  { "id": "u_003", "name": "Charlie Inc", "access_level": "read", "region": "ap-northeast-1" }
]
```

```
users[3]{id,name,access_level,region}:
  u_001,Alice Corp,admin,us-east-1
  u_002,Bob Ltd,write,eu-west-1
  u_003,Charlie Inc,read,ap-northeast-1
```

```rust
#[tool(
    name = "toon_encode",
    description = "Optimizes JSON payloads into TOON format for token efficiency."
)]
pub fn encode(args: EncodeArgs) -> Result<EncodingResult, Error> {
    let options = args.options.unwrap_or_default();
    let toon_string = toon::to_string_with_options(&args.json, options)
        .map_err(|e| Error::custom(format!("Serialization failed: {}", e)))?;
    Ok(EncodingResult { content: toon_string })
}
```

Benchmark results:
| Dataset Type | Size (JSON) | Size (TOON) | Reduction |
|---|---|---|---|
| User Logs (1k rows) | 145 KB | 92 KB | 36% |
| E-commerce Config | 24 KB | 19 KB | 21% |
| Geo-spatial Points | 512 KB | 290 KB | 43% |

MCP integration:
```json
{
  "mcpServers": {
    "toon": {
      "command": "/path/to/toon-mcp"
    }
  }
}
```

**Source:** https://github.com/copyleftdev/toon-mcp (MIT)
