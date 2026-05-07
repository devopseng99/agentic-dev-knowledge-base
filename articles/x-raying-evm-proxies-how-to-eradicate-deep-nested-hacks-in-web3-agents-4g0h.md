---
title: "X-Raying EVM Proxies: How to Eradicate Deep-Nested Hacks in Web3 Agents"
url: "https://dev.to/lokii_ding/x-raying-evm-proxies-how-to-eradicate-deep-nested-hacks-in-web3-agents-4g0h"
author: "lokii"
category: "web3-blockchain-agents"
---

# X-Raying EVM Proxies: How to Eradicate Deep-Nested Hacks in Web3 Agents

**Author:** lokii
**Published:** May 6, 2026

## Overview

Layer 3 of the Lirix architecture -- a security framework designed to protect AI Web3 agents from sophisticated contract obfuscation attacks.

## Russian Doll: DFS Payload Disassembly

Malicious actors hide harmful instructions within nested Multicall transactions. Lirix implements a Depth-First Search algorithm that recursively unpacks all payload layers, exposing hidden execution paths and collecting every target address for security validation.

## Economic Guillotine: Zero-Tolerance Slippage

LLMs frequently fail at calculating proper slippage tolerances on DEX swaps. Lirix automatically decodes swap parameters and kills any transaction with `amountOutMin == 0`, preventing MEV extraction attacks before they reach the blockchain.

## Storage Slot X-Ray

The most critical defense: instead of trusting contract ABIs (which can be spoofed), Lirix queries raw EVM storage slots mandated by EIP-1967 standards. This reveals the actual implementation contract hidden behind proxy patterns, preventing attackers from secretly upgrading proxies to malicious logic.

## Code Example

```python
# EVM proxy storage slot constants (EIP-1967)
EIP1967_IMPLEMENTATION_SLOT = "0x360894a13ba1a3210667c828492db98dca3e2076cc3735a920a3ca505d382bbc"
EIP1967_BEACON_SLOT = "0xa3f0ad74e5423aebfd80d3ef4346578335a9a72aeaee59ff6cb3582b35133d50"

@staticmethod
def _read_slot_address(web3: Web3, address: str, slot: int) -> Optional[str]:
    """Read raw physical memory from EVM state trie"""
    raw = web3.eth.get_storage_at(cast(ChecksumAddress, address), slot)

    if not raw or raw == b"\x00" * 32:
        return None

    tail = raw[-20:]
    if tail == b"\x00" * 20:
        return None

    return Web3.to_checksum_address("0x" + tail.hex())
```

## Conclusion

Layer 4 (Truth Consensus) addresses RPC node Byzantine faults as the next evolution of the security stack.
