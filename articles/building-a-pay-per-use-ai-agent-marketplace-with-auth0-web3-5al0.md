---
title: "Building a Pay-Per-Use AI Agent Marketplace with Auth0 + Web3"
url: "https://dev.to/prema_ananda/building-a-pay-per-use-ai-agent-marketplace-with-auth0-web3-5al0"
author: "Prema Ananda"
category: "web3-blockchain-agents"
---

# Building a Pay-Per-Use AI Agent Marketplace with Auth0 + Web3
**Author:** Prema Ananda
**Published:** October 25, 2025

## Overview
AgentBounty is a marketplace where AI agents authenticate through Auth0, execute tasks, and accept per-use USDC payments via gasless transactions using x402 Protocol and EIP-712.

## Key Concepts

### Auth Setup

```python
from authlib.integrations.starlette_client import OAuth

oauth = OAuth()
oauth.register(
    name='auth0',
    client_id=settings.AUTH0_CLIENT_ID,
    client_secret=settings.AUTH0_CLIENT_SECRET,
    server_metadata_url=f'https://{settings.AUTH0_DOMAIN}/.well-known/openid-configuration',
    client_kwargs={'scope': 'openid profile email offline_access'}
)
```

### Web3 Wallet Linking

```python
@router.post("/connect")
async def connect_wallet(
    request: Request,
    data: ConnectWalletRequest,
    user: dict = Depends(require_auth)
):
    auth0_user_id = user.get('sub')
    w3 = Web3()
    message = encode_defunct(text=data.message)
```

### Rate Limit Caching

```python
class Auth0Service:
    def __init__(self):
        self._token_cache = {}
        self._profile_cache = {}
    
    async def get_user_profile(self, user_id: str) -> dict:
        if user_id in self._profile_cache:
            profile, expires = self._profile_cache[user_id]
            if datetime.utcnow() < expires:
                return profile
        profile = await self._fetch_profile(user_id)
        self._profile_cache[user_id] = (
            profile, datetime.utcnow() + timedelta(minutes=5)
        )
        return profile
```

### Tech Stack
- Backend: FastAPI (Python), SQLite
- Frontend: Vanilla JS, Tailwind CSS
- AI: Google Gemini API, Bright Data MCP Server
- Payments: X402 Protocol, EIP-712, ERC-3009
- Blockchain: Base Sepolia, USDC

Live Demo: https://agentbounty.premananda.site
