---
title: "Building a Proactive AI Travel Agent on AWS Bedrock AgentCore (Final Part)"
url: "https://dev.to/aws-builders/building-a-proactive-ai-travel-agent-on-aws-bedrock-agentcore-final-part--p5n"
author: "Harsha Mathan"
category: "bedrock-agent-aws"
---

# Building a Proactive AI Travel Agent on AWS Bedrock AgentCore (Final Part)

**Author:** Harsha Mathan
**Published:** September 23, 2025

## Overview

Final part of a four-part series exploring AWS Bedrock AgentCore through building a production travel agent with real APIs. Demonstrates deployment from local Python to production AWS infrastructure using the Strands Agent framework.

## Key Concepts

### AgentCore Deployment

```shell
agentcore configure -e app.py --region us-west-2
agentcore launch
```

Automated results:
- ARM64 container built via AWS CodeBuild
- ECR repository creation and population
- IAM role configuration
- Production endpoint deployment

### Testing

```shell
agentcore invoke '{"message": "Find flights from LHR to CDG"}'
```

### Project Structure

Production files include:
- `app.py` - AgentCore wrapper with CORS support
- `orchestrator.py` - Coordination logic
- `planning_agent.py` - Flight request parsing
- `travel_tool.py` - RealFlightAPI integration
- `flight_api.py` - Aviationstack API with fallback mechanisms
- `agentcore.yaml` - Deployment configuration

### Time Comparison

- **AgentCore:** 5 minutes total
- **Traditional AWS:** 2-3 days infrastructure setup

### What AgentCore Handled Automatically

- Container building (ARM64 via CodeBuild)
- ECR repository creation
- IAM role provisioning
- Auto-scaling configuration
- VPC, security groups, load balancing
- CloudWatch logging integration
- Complete CI/CD pipeline

## Lessons Learned

1. Start with AgentCore patterns from day one rather than building local infrastructure first
2. Plan authentication earlier; browser-to-cloud communication is more complex than anticipated
3. Implement memory services from the start for better user context
