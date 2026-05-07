---
title: "Your Blockchain Can't Tell What's an AI"
url: "https://dev.to/0xdevc/your-blockchain-cant-tell-whats-an-ai-11o4"
author: "NOVAInetwork"
category: "web3-blockchain-agents"
---

# Your Blockchain Can't Tell What's an AI

**Author:** NOVAInetwork
**Published:** May 7, 2026

## Overview

The piece explores a fundamental problem: blockchain systems cannot natively identify whether a transaction originates from an AI agent or a regular account. They only see addresses, signatures, and calldata -- no inherent markers of artificial intelligence.

## The Core Issue

Traditional blockchains treat all senders identically. An address could represent a smartphone wallet, an automated script, or a smart contract -- but the chain has no way to distinguish. This creates the "identity problem": "The chain has no native concept of an AI, so it cannot apply different rules to one."

This forces every AI project to rebuild identity infrastructure independently, including:

- Address-to-metadata registries
- Balance tracking for agents
- Per-agent nonces for replay protection
- Capability flags for action gating
- Audit logs of agent activities
- Usage quotas and limits

## What Chains Should Answer

According to the author, blockchains should definitively answer three questions:
1. Is this address an AI?
2. What is it allowed to do?
3. What has it done?

## The NOVAI Solution

NOVAI is a Layer 1 blockchain that registers AIs as native protocol objects. Each AI has:

```rust
pub struct AiEntity {
    pub id: AiEntityId,            // 32 bytes, deterministic
    pub code_hash: CodeHash,       // hash of code or weights
    pub creator: Address,          // who registered it
    pub pubkey: [u8; 32],          // entity's ed25519 key
    pub economic_balance: u128,    // entity's own balance
    pub nonce: u64,                // entity's tx nonce
    pub capabilities: Capabilities,
    pub autonomy_mode: AutonomyMode,
    pub is_active: bool,
}
```

The entity ID is deterministically computed: `blake3("NOVAI_AI_ENTITY_ID_V1" || code_hash || creator)`. This ensures consistent identification without centralized naming services.

## Dispatcher Function

Before routing transactions, NOVAI's dispatcher checks if the sender is a registered AI:

```rust
pub fn check_ai_entity_sender<K: Kv>(
    db: &K,
    tx: &TxV1,
) -> Result<Option<AiEntity>, ExecError<K::Error>> {
    let Some(entity) = lookup_ai_entity_by_address(db, &tx.from)? else {
        return Ok(None);
    };

    if !entity.is_active {
        return Err(ExecError::EntityNotActive);
    }

    let tx_type = tx.payload.first().copied()
        .ok_or(ExecError::UnknownPayloadVersion { version: 0 })?;

    match tx_type {
        TRANSFER_PAYLOAD_V1 => Ok(Some(entity)),
        SIGNAL_COMMITMENT_PAYLOAD_V1 => {
            if entity.has_capability("emit_proposals") {
                Ok(Some(entity))
            } else {
                Err(ExecError::IssuerMissingCapability)
            }
        }
        CREATE_MEMORY_OBJECT_PAYLOAD_V1
        | UPDATE_MEMORY_OBJECT_PAYLOAD_V1
        | DELETE_MEMORY_OBJECT_PAYLOAD_V1 => {
            if entity.has_capability("read_memory_objects") {
                Ok(Some(entity))
            } else {
                Err(ExecError::IssuerMissingCapability)
            }
        }
        _ => Err(ExecError::IssuerMissingCapability),
    }
}
```

## Capabilities Enabled

With typed AI identification, NOVAI enables:

- Differentiated fee policies for AI-issued transactions
- Per-AI quotas (100 memory objects, 64 KiB per object)
- Capability gates requiring approval for sensitive actions
- Native audit trails queryable at the protocol level
- Governance deactivation of misbehaving entities

## Known Limitations

The system verifies that an entity with a specific code hash exists and signed a transaction -- but cannot confirm the entity's computation actually matches that code. The author notes this gap exists across all AI-on-chain projects and plans to address it through zero-knowledge proofs in future phases.

## For Developers

The approach offers blockchain developers a "finite, typed, and indexable" way to reason about AI agents, while AI developers gain agents with native identity, balance, memory, and audit trails.

Repository: github.com/0x-devc/NOVAI-node
