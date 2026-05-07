---
title: "LLM Adversarial Attacks: How Are Attackers Maliciously Prompting LLMs and Steps To Safeguard Your Applications"
url: "https://dev.to/gssakash/llm-adversarial-attacks-how-are-attackers-maliciously-prompting-llms-and-steps-to-safeguard-your-applications-4gfj"
author: "Akash"
category: "llm-eval-alignment"
---
# LLM Adversarial Attacks: How Are Attackers Maliciously Prompting LLMs
**Author:** Akash  **Published:** September 14, 2024

## Overview
Security vulnerabilities in Large Language Models are exploited through malicious prompting techniques. This article covers the OWASP Top 10 for LLM Applications and comprehensive safeguarding strategies.

## Key Concepts

### Attack Methodologies

**Jailbreaking/Red-Teaming:** Utilizing prompt engineering to circumvent security guardrails through roleplay attacks (e.g., DAN for ChatGPT).

**Adversarial Attacks:** Inserting unintended text sequences like "ddeeff" to degrade model performance without semantic meaning changes.

### Methods to Prompt LLMs for Malicious Information

**Token Manipulation** — Alters small fractions of input tokens while preserving semantic meaning; suffix attacks append tokens to deceive models.

**Gradient-Based Attacks** — Exploits gradient signals in white-box settings with full model access; uses gradient descent to learn effective attack vectors.

**Jailbreak Prompting** — Uses algorithmic methods like PAIR (Prompt Automatic Iterative Refinement); often transferable between models.

**Model Red-Teaming** — Automated approach using other LLMs to generate adversarial prompts; creates "watering holes" — targeted prompts exploiting specific weaknesses.

### OWASP Top 10 for LLM Applications

**LLM01: Prompt Injection** — Attackers manipulate models through clever prompting. Mitigations: RBAC privilege limitations, human oversight for critical actions, ChatML filtering, trust boundaries, robust monitoring.

**LLM02: Insecure Output Handling** — Insufficient validation creates code injection (exec, eval) and XSS vulnerabilities. Mitigations: zero-trust approach, output encoding.

**LLM03: Training Data Poisoning** — Contaminated pre-training data creates vulnerabilities. Mitigations: data supply verification, network sandboxing, federated learning with outlier elimination.

**LLM04: Model Denial of Service** — Attackers consume excessive resources through complex recursive queries. Mitigations: resource usage caps, API rate limiting, token input restrictions.

**LLM06: Sensitive Information Disclosure** — Models leak classified details through outputs. Mitigations: comprehensive input sanitization, prevent sensitive data in training.

**LLM08: Excessive Agency** — LLMs interfacing with external systems gain unintended capabilities. Mitigations: minimize plugin functionality, restrict permissions, implement human-in-the-loop approval.

**LLM09: Overreliance** — Models generate confident but incorrect outputs. Mitigations: cross-reference trusted sources, chain-of-thought prompting (COT), automatic validation mechanisms.

**LLM10: Model Theft** — Unauthorized access through infrastructure exploitation or model extraction via querying. Mitigations: strong access controls, API rate limiting, adversarial robustness training, watermarking.

### Prevention Tools
1. **Rebuff** (ProtectAI) — Four-layer defense: heuristics, LLM detection, VectorDB pattern recognition, canary tokens
2. **LLM Guard** (Laiyer) — Detects harmful language, prevents data leakage, sanitizes outputs
3. **Vigil** (Deadbits) — Python library detecting jailbreaks, prompt injections, threats
4. **Fiddler Auditor** — Open-source LLM red-teaming library
5. **WhyLabs** — LLM security management platform

LLM security remains experimental and nascent. As models grow more sophisticated, adopting defensive methodologies becomes increasingly critical.
