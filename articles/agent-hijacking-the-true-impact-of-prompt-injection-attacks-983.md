---
title: "Agent hijacking: The true impact of prompt injection attacks"
url: "https://dev.to/snyk/agent-hijacking-the-true-impact-of-prompt-injection-attacks-983"
author: "SnykSec"
category: "agent-prompt-chaining"
---

# Agent hijacking: The true impact of prompt injection attacks

**Author:** SnykSec (Snyk)
**Published:** August 29, 2024

## Overview

Explores how LLM agents using tools can be compromised through prompt injection, including indirect attacks via data sources. Covers both novel LLM vulnerabilities and classic software vulnerabilities in agent frameworks.

## Key Concepts

### Agent Architecture Vulnerability
Agents use an LLM as a "reasoning engine" with access to tools for autonomous interaction. The workflow:
1. User provides initial task prompt
2. LLM determines action using available tools
3. Tool output feeds back into new prompt
4. Process repeats until task completion

### Prompt Injection is OWASP #1
"Prompt Injection is the number one vulnerability in the OWASP Top 10 for LLM Applications."

### Indirect Attack Vector
Attackers embed malicious instructions within data sources (emails, documents, web pages) that agents process, enabling remote compromise without direct user interaction.

### CVE-2024-21513 (LangChain)
Unsafe use of Python's `eval()` processing database results:

```python
def _try_eval(x: Any) -> Any:
    try:
        return eval(x)
    except Exception:
        return x
```

This allowed code injection through crafted SQL queries. An LLM could be prompted to create malicious queries exploiting this vulnerability.

### Gmail Attack Example
An agent connected to Gmail with the Gmail toolkit could be manipulated via email content to forward sensitive messages to attacker-controlled accounts.

### Mitigation Recommendations
1. Treat LLM output as untrusted data requiring validation and sanitization
2. Implement prompt defense solutions
3. Apply traditional security practices (input validation, escaping)
4. Use OWASP LLM Security Verification Standard for secure development
