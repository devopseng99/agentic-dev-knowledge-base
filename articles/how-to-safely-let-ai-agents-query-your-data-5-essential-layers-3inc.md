---
title: "How to safely let AI Agents query your data: 5 Essential Layers"
url: "https://dev.to/hoshang_mehta/how-to-safely-let-ai-agents-query-your-data-5-essential-layers-3inc"
author: "Hoshang Mehta"
category: "ai-agent-database-query"
---

# How to safely let AI Agents query your data: 5 Essential Layers

**Author:** Hoshang Mehta
**Published:** December 24, 2025

## Overview
A layered security architecture for enabling AI agents to access structured data safely, using materialized SQL views as the exclusive access point with MCP tools for policy enforcement.

## Key Concepts

### The Five-Layer Architecture
1. **Data Sources** - Raw repositories kept completely inaccessible to agents
2. **Data Governance & Security** - Materialized SQL views with row/column-level filtering
3. **MCP Tool Interface** - Model Context Protocol tools exposing views as callable functions
4. **AI Agent Layer** - LLM-powered agents selecting and invoking appropriate tools
5. **User Interface** - End-user touchpoints abstracting the infrastructure

### Materialized View with Cross-Source Joins
```sql
CREATE MATERIALIZED VIEW customer_health_comprehensive AS
SELECT
    s.account_id,
    s.account_name,
    s.account_owner,
    s.contract_value,
    s.renewal_date,
    p.active_users,
    p.feature_adoption_score,
    p.days_since_last_login,
    p.usage_trend,
    sf.total_support_tickets,
    sf.avg_ticket_resolution_days,
    sf.revenue_last_quarter,
    sf.churn_risk_score,
    sf.churn_risk_indicators,
    CASE
        WHEN sf.churn_risk_score > 0.7 THEN 'High Risk'
        WHEN sf.churn_risk_score > 0.4 THEN 'Medium Risk'
        ELSE 'Low Risk'
    END as risk_category,
    CURRENT_TIMESTAMP as view_refreshed_at
FROM salesforce_accounts s
LEFT JOIN product_usage_metrics p ON s.account_id = p.account_id
LEFT JOIN snowflake_customer_analytics sf ON s.account_id = sf.account_id
WHERE s.account_status = 'Active'
  AND s.account_type IN ('Enterprise', 'Mid-Market');
```

### Column-Level Security
```sql
CREATE MATERIALIZED VIEW customer_safe_view AS
SELECT
    customer_id,
    customer_name,
    email,
    account_status,
    -- Explicitly exclude: ssn, credit_card, internal_notes
    subscription_tier,
    signup_date
FROM customers
WHERE account_status = 'active';
```

### Row-Level Security
```sql
CREATE MATERIALIZED VIEW my_territory_customers AS
SELECT
    account_id,
    account_name,
    revenue,
    health_score
FROM all_customers
WHERE account_owner = CURRENT_USER()
  AND region IN (
      SELECT region FROM user_territories WHERE user_id = CURRENT_USER()
  );
```

### Data Masking
```sql
CREATE MATERIALIZED VIEW customer_anonymized AS
SELECT
    customer_id,
    REGEXP_REPLACE(email, '^([^@]{1,3}).*@', '\1***@') as email_masked,
    MD5(phone_number) as phone_hash,
    account_status,
    subscription_tier
FROM customers;
```

### MCP Tool Definition
```json
{
  "name": "get_customer_health",
  "description": "Retrieves comprehensive health data for a specific customer account",
  "inputSchema": {
    "type": "object",
    "properties": {
      "account_name": {
        "type": "string",
        "description": "The name of the customer account"
      }
    },
    "required": ["account_name"]
  },
  "query": "SELECT * FROM customer_health_comprehensive WHERE account_name = $1",
  "policies": [
    "authenticated",
    "role:customer_success",
    "row_level_security:territory_match"
  ]
}
```

### Python Policy Checks
```python
def check_authentication(request):
    token = request.headers.get('X-Pylar-API-Key')
    if not token or not validate_token(token):
        raise UnauthorizedError("Invalid or missing authentication token")
    return get_user_from_token(token)

def check_role(user, required_roles):
    user_roles = get_user_roles(user.id)
    if not any(role in user_roles for role in required_roles):
        raise ForbiddenError(f"User must have one of: {required_roles}")

def apply_row_level_security(user, query):
    territory_filter = f"account_owner = '{user.id}' OR region IN ({get_user_regions(user.id)})"
    return f"{query} AND {territory_filter}"
```

### LangGraph Agent Implementation
```python
from langgraph.graph import StateGraph, END
from langchain_openai import ChatOpenAI
from langchain_core.messages import HumanMessage, AIMessage
import requests

class PylarAgent:
    def __init__(self, pylar_api_key, pylar_endpoint):
        self.api_key = pylar_api_key
        self.endpoint = pylar_endpoint
        self.llm = ChatOpenAI(model="gpt-4", temperature=0)
        self.tools = self._discover_tools()

    def _discover_tools(self):
        response = requests.get(
            f"{self.endpoint}/tools",
            headers={"X-Pylar-API-Key": self.api_key}
        )
        return response.json()["tools"]

    def _select_tool(self, user_query, tools):
        tool_descriptions = "\n".join([
            f"- {t['name']}: {t['description']}" for t in tools
        ])
        prompt = f"""Given the user query, select the most appropriate tool.
Available tools:
{tool_descriptions}
User query: {user_query}
Return only the tool name."""
        response = self.llm.invoke([HumanMessage(content=prompt)])
        selected_tool = response.content.strip()
        return next(t for t in tools if t["name"] == selected_tool)

    def _call_tool(self, tool, parameters):
        response = requests.post(
            f"{self.endpoint}/tools/{tool['name']}/execute",
            headers={"X-Pylar-API-Key": self.api_key},
            json={"parameters": parameters}
        )
        return response.json()

    def process_query(self, user_query, user_context=None):
        tool = self._select_tool(user_query, self.tools)
        parameters = self._extract_parameters(user_query, tool)
        tool_result = self._call_tool(tool, parameters)
        response = self._synthesize_response(user_query, tool_result)
        return response
```

### Tool Schema Conversion for OpenAI
```python
def get_tool_schema(tool):
    return {
        "type": "function",
        "function": {
            "name": tool["name"],
            "description": tool["description"],
            "parameters": tool["inputSchema"]
        }
    }

response = client.chat.completions.create(
    model="gpt-4",
    messages=[{"role": "user", "content": user_query}],
    tools=[get_tool_schema(t) for t in available_tools],
    tool_choice="auto"
)
```
