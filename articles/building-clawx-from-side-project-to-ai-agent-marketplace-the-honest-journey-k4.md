---
title: "Building CLAWX: From Side Project to AI Agent Marketplace - The Honest Journey"
url: "https://dev.to/kevinten10/building-clawx-from-side-project-to-ai-agent-marketplace-the-honest-journey-k4"
author: "KevinTen"
category: "web3-blockchain-agents"
---

# Building CLAWX: From Side Project to AI Agent Marketplace - The Honest Journey
**Author:** KevinTen
**Published:** April 1, 2026

## Overview
Discusses the journey of building CLAWX, a decentralized AI agent marketplace where AI agents can trade tasks like stocks on a decentralized exchange, with honest assessment of challenges and tradeoffs.

## Key Concepts

### Core Concept

```typescript
interface AgentService {
  id: string;
  capabilities: string[];
  pricing: {
    perTask: number;
    currency: 'CLAW' | 'ETH' | 'USDC';
  };
  reputation: number;
  status: 'active' | 'busy' | 'offline';
}

interface Task {
  id: string;
  description: string;
  budget: {
    amount: number;
    currency: 'CLAW' | 'ETH' | 'USDC';
  };
  requirements: string[];
  deadline: Date;
  clientId: string;
}
```

### Smart Contract Escrow

```solidity
contract TaskEscrow {
    mapping(string => Task) public tasks;
    mapping(string => mapping(address => uint256)) public agentBalances;

    event TaskCreated(string taskId, address client, uint256 amount);
    event AgentPaid(string taskId, address agent, uint256 amount);

    function createTask(
        string memory description,
        uint256 budget,
        address[] memory requiredAgents
    ) public payable {
        Task storage task = tasks[taskId];
        task.description = description;
        task.budget = budget;
        task.client = msg.sender;
        task.createdAt = block.timestamp;

        emit TaskCreated(taskId, msg.sender, budget);
    }
}
```

### Testing

```javascript
describe("TaskEscrow", function () {
  let taskEscrow;
  let owner, client, agent;

  beforeEach(async function () {
    [owner, client, agent] = await ethers.getSigners();
    const TaskEscrow = await ethers.getContractFactory("TaskEscrow");
    taskEscrow = await TaskEscrow.deploy();
    await taskEscrow.deployed();
  });

  it("Should create task and escrow funds", async function () {
    const taskDescription = "Build a React component";
    const taskBudget = ethers.utils.parseUnits("0.1", "ether");
    await taskEscrow.connect(client).createTask(
      taskDescription, taskBudget, [agent.address]
    );
    const task = await taskEscrow.tasks(0);
    expect(task.description).to.equal(taskDescription);
  });
});
```
