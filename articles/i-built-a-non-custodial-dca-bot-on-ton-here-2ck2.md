---
title: "I Built a Non-Custodial DCA Bot on TON -- Here"
url: "https://dev.to/gerus_team/i-built-a-non-custodial-dca-bot-on-ton-here-2ck2"
author: "Gerus Lab"
category: "web3-blockchain-agents"
---

# I Built a Non-Custodial DCA Bot on TON -- Here

**Author:** Gerus Lab
**Published:** February 28, 2026

## Overview

A fully non-custodial DCA protocol on the TON blockchain where the smart contract itself executes swaps automatically without custody risk. Uses TON's async message-passing model, cheap storage, and native Telegram integration.

## Architecture

### Layer 1: Smart Contracts (Tact)

MasterChef-inspired index model for O(1) complexity:

```
struct GlobalState {
    accRewardPerShare: Int;
    totalDeposited: Int;
    lastSwapTime: Int;
}

struct UserPosition {
    deposited: Int;
    rewardDebt: Int;
    interval: Int;
}
```

```
fun executeSwap(swapResult: Int) {
    let tokensReceived = swapResult;
    self.accRewardPerShare += tokensReceived * PRECISION / self.totalDeposited;
}

fun pendingReward(user: UserPosition): Int {
    return user.deposited * self.accRewardPerShare / PRECISION - user.rewardDebt;
}
```

### Layer 2: Proxy-TON Mechanism

Wraps native TON into jetton, routes to STON.fi v2.1 for swaps, unwraps results.

### Layer 3: NestJS Indexer

```typescript
@Injectable()
export class DCAScheduler {
  @Cron('*/30 * * * * *')
  async checkPendingSwaps() {
    const positions = await this.contractService.getActivePositions();
    const now = Math.floor(Date.now() / 1000);

    for (const pos of positions) {
      if (now - pos.lastSwapTime >= pos.interval) {
        await this.contractService.triggerSwap(pos.id);
      }
    }
  }
}
```

If the indexer goes down, no funds are at risk. Invalid swaps revert on-chain.

### Telegram Mini App

```typescript
import { TonConnectUI } from '@tonconnect/ui';

const tonConnect = new TonConnectUI({
  manifestUrl: 'https://dca.ton/tonconnect-manifest.json',
});

async function createDCAPosition(params: {
  amount: bigint;
  interval: number;
  targetToken: string;
}) {
  const tx = {
    validUntil: Math.floor(Date.now() / 1000) + 600,
    messages: [{
      address: DCA_CONTRACT_ADDRESS,
      amount: params.amount.toString(),
      payload: buildCreatePositionPayload(params),
    }],
  };
  await tonConnect.sendTransaction(tx);
}
```

## Lessons

- TON's async model requires different thinking (bounce messages vs reverts)
- MasterChef-style accumulator saves gas for thousands of concurrent positions
- Telegram Mini Apps showed 3x higher activation rates than traditional web dApps
