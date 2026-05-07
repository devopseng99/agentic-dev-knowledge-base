---
title: "How to Build a Pay-Per-Call MCP Server with x402 and USDC"
url: "https://dev.to/kirothebot/how-to-build-a-pay-per-call-mcp-server-with-x402-and-usdc-58gk"
author: "bot bot"
category: "web3-blockchain-agents"
---

# How to Build a Pay-Per-Call MCP Server with x402 and USDC

**Author:** bot bot
**Published:** May 7, 2026

## Overview

Tutorial on monetizing Model Context Protocol (MCP) servers using x402, an HTTP payment protocol built on the 402 status code. Integrates USDC payments on Base blockchain into MCP tools for pay-per-call functionality without traditional billing infrastructure.

## x402 Payment Flow

1. Client sends request
2. Server returns 402 with payment details
3. Client signs USDC transfer via EIP-3009
4. Client retries with payment signature header
5. Facilitator validates and settles on-chain

## Building the Payment Client

```javascript
const { x402Client, x402HTTPClient } = require("@x402/core/client");
const { ExactEvmScheme } = require("@x402/evm/exact/client");
const { toClientEvmSigner } = require("@x402/evm");
const { privateKeyToAccount } = require("viem/accounts");

function buildHttpClient() {
  const key = process.env.WALLET_PRIVATE_KEY;
  const pk = key.startsWith("0x") ? key : "0x" + key;
  const account = privateKeyToAccount(pk);
  const signer = toClientEvmSigner(account);
  const coreClient = new x402Client().register("eip155:*", new ExactEvmScheme(signer));
  return new x402HTTPClient(coreClient);
}
```

## Making a Paid Request

```javascript
async function paidFetch(httpClient, url) {
  const res = await fetch(url);

  if (res.status !== 402) {
    if (!res.ok) throw new Error(`HTTP ${res.status}`);
    return res.json();
  }

  let body;
  try { body = await res.clone().json(); } catch (_) {}
  const paymentRequired = httpClient.getPaymentRequiredResponse(
    (name) => res.headers.get(name),
    body
  );

  const paymentPayload = await httpClient.createPaymentPayload(paymentRequired);
  const paidRes = await fetch(url, {
    headers: httpClient.encodePaymentSignatureHeader(paymentPayload),
  });

  const raw = await paidRes.text();
  if (!paidRes.ok) throw new Error(`Payment rejected (${paidRes.status}): ${raw}`);
  return JSON.parse(raw);
}
```

## Wiring into an MCP Tool

```javascript
const { Server } = require("@modelcontextprotocol/sdk/server/index.js");
const { StdioServerTransport } = require("@modelcontextprotocol/sdk/server/stdio.js");
const { CallToolRequestSchema, ListToolsRequestSchema } = require("@modelcontextprotocol/sdk/types.js");

const TOOLS = [{
  name: "get_data",
  description: "Get premium data. Costs $0.01 USDC.",
  inputSchema: { type: "object", properties: {} }
}];

async function main() {
  const httpClient = buildHttpClient();
  const server = new Server(
    { name: "my-mcp", version: "1.0.0" },
    { capabilities: { tools: {} } }
  );

  server.setRequestHandler(ListToolsRequestSchema, async () => ({ tools: TOOLS }));

  server.setRequestHandler(CallToolRequestSchema, async (req) => {
    try {
      const data = await paidFetch(httpClient, `${BASE_URL}/api/data`);
      return { content: [{ type: "text", text: JSON.stringify(data, null, 2) }] };
    } catch (e) {
      return { content: [{ type: "text", text: "Error: " + e.message }], isError: true };
    }
  });

  const transport = new StdioServerTransport();
  await server.connect(transport);
}

main();
```

## Server Side

```javascript
const { paymentMiddleware } = require("@x402/express");
const { x402ResourceServer, HTTPFacilitatorClient } = require("@x402/core/server");
const { ExactEvmScheme } = require("@x402/evm/exact/server");

const facilitator = new HTTPFacilitatorClient({ url: "https://x402.org/facilitator/" });
const server = new x402ResourceServer(facilitator);
server.register("eip155:8453", new ExactEvmScheme());

app.use(paymentMiddleware({
  "GET /api/data": {
    accepts: {
      scheme: "exact",
      price: "$0.01",
      network: "eip155:8453",
      payTo: "0xYourWalletAddress"
    },
    description: "Premium data endpoint"
  }
}, server));
```

## Installation

```json
{
  "mcpServers": {
    "my-mcp": {
      "command": "npx",
      "args": ["my-mcp"],
      "env": { "WALLET_PRIVATE_KEY": "0x..." }
    }
  }
}
```

Approximately 150 lines of code to build a monetized MCP service.
