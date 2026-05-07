---
title: "agentwallet-sdk v3.0.0: Solana Wallets, Jupiter Swaps, and a 17-Chain CCTP V2 Bridge"
url: "https://dev.to/up2itnow0822/agentwallet-sdk-v300-solana-wallets-jupiter-swaps-and-a-17-chain-cctp-v2-bridge-46np"
author: "Bill Wilson"
category: "web3-blockchain-agents"
---

# agentwallet-sdk v3.0.0: Solana Wallets, Jupiter Swaps, and a 17-Chain CCTP V2 Bridge
**Author:** Bill Wilson
**Published:** March 3, 2026

## Overview
SDK providing non-custodial Solana wallets, Jupiter swap integration, x402 payment protocol on Solana, and a 17-chain CCTP V2 bridge -- arguing EVM is not fast or cheap enough for agents doing real work.

## Key Concepts

### Solana Wallet

```typescript
import { SolanaWallet } from 'agentwallet-sdk';

const wallet = await SolanaWallet.create({
  rpcUrl: 'https://api.mainnet-beta.solana.com',
  spendLimit: { amount: '10', token: 'SOL', windowSeconds: 86400 }
});
```

### Jupiter Swap

```typescript
import { SolanaWallet, JupiterSwap } from 'agentwallet-sdk';

const wallet = await SolanaWallet.fromKeypair(existingKeypair, {
  rpcUrl: 'https://api.mainnet-beta.solana.com'
});
const swap = new JupiterSwap(wallet);

const result = await swap.execute({
  inputMint: 'So11111111111111111111111111111111111111112',
  outputMint: 'EPjFWdd5AufqSSqeM2qN1xzybapC8G4wEGGkZwyTDt1v',
  amount: '1000000000',
  slippageBps: 50
});
```

### x402 on Solana

```typescript
import { SolanaX402Client } from 'agentwallet-sdk';
const client = new SolanaX402Client(wallet);
const response = await client.fetch('https://api.example.com/premium-data');
```

### 17-Chain CCTP V2 Bridge

```typescript
import { UnifiedBridge } from 'agentwallet-sdk';

const bridge = new UnifiedBridge({ sourceWallet: evmWallet, solanaWallet });
const transfer = await bridge.transfer({
  sourceChain: 'base',
  destinationChain: 'solana',
  token: 'USDC',
  amount: '100',
  destinationAddress: solanaWallet.publicKey
});
await transfer.waitForFinality();
```

### Stats
376 passing tests, 17 chains, ~400ms Solana confirmation, MIT license.

```bash
npm install agentwallet-sdk
```
