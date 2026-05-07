---
title: "On-Chain AI Agent Attestations with EAS"
url: "https://dev.to/dogcomplex/on-chain-ai-agent-attestations-with-eas-4j35"
author: "Warren Koch"
category: "web3-blockchain-agents"
---

# On-Chain AI Agent Attestations with EAS
**Author:** Warren Koch
**Published:** March 12, 2026

## Overview
Using Ethereum Attestation Service (EAS) to create immutable on-chain records when AI agents transition between platforms, providing publicly auditable records for regulatory and legal purposes.

## Key Concepts

### Installation

```bash
npm install @cellar-door/eas cellar-door-exit ethers
```

### Creating an Anchored Marker

```javascript
import { quickExit, toJSON } from 'cellar-door-exit';
import { anchorToEAS } from '@cellar-door/eas';

const { marker } = quickExit('did:web:platform.example');

const attestation = await anchorToEAS(toJSON(marker), {
  provider: ethersProvider,
  signer: ethersSigner,
});

console.log('Attestation UID:', attestation.uid);
```

### Verification

```javascript
import { verifyEASAttestation } from '@cellar-door/eas';

const result = await verifyEASAttestation(attestationUid, {
  provider: ethersProvider,
});

console.log(result.valid); // true
```

### When to Use On-Chain
Use for immutability and compliance needs. Default to off-chain methods for speed and cost. Alternatives include ERC-8004 and Sign Protocol.
