---
title: "Building Multi-Agent AWS Operations Intelligence with Amazon Bedrock AgentCore"
url: "https://dev.to/aws-builders/building-multi-agent-aws-operations-intelligence-with-amazon-bedrock-agentcore-1enm"
author: "Lewis Sawe"
category: "aws-agents"
---

# Building Multi-Agent AWS Operations Intelligence with Amazon Bedrock AgentCore
**Author:** Lewis Sawe
**Published:** September 29, 2025

## Overview
AWS Operations Command Center -- multi-agent AI system on Bedrock AgentCore for automatic AWS environment discovery and analysis across organizations. Three specialized agents: Cost Intelligence, Operations Intelligence, Infrastructure Intelligence. Self-discovers org structure, handles cross-account access via IAM roles, and shares context through AgentCore Memory service. Key finding: cost agent revealed $255.22 in consumption obscured by $255.21 in credits.

## Key Concepts

### Multi-Agent Architecture
- Three agents operate independently but share context through orchestration layer
- BedrockAgentCoreApp runtime provides foundation
- Runtime service (execution), Memory service (cross-agent context), Gateway service (distributed communication)

### Self-Discovery Mechanism
- Attempts Organizations API calls to detect management account
- Success enables cross-account analysis; failure triggers single-account fallback

### Cross-Account Access
- IAM roles deployed via CloudFormation to member accounts
- OrganizationAccountAccessRole with external ID verification

### Error Handling Categories
- Throttling errors: exponential backoff retry
- Access denial: permission issue logging
- Credential errors: graceful degradation

### Memory Service Integration
- Session-based context storage with TTL expiration
- Cost agent findings become available to operations agent

## Code Examples

### BedrockAgentCoreApp Implementation
```python
from bedrock_agentcore.runtime import BedrockAgentCoreApp

app = BedrockAgentCoreApp()

@app.entrypoint
def invoke(payload):
    session_id = payload.get('session_id', str(uuid.uuid4()))

    memory_service.store_context(session_id, {
        'agent': 'cost_intelligence',
        'timestamp': datetime.now().isoformat(),
        'payload': payload
    })

    result = agent.get_multi_account_costs()

    result.update({
        'services_used': ['runtime', 'memory', 'gateway'],
        'session_id': session_id
    })

    return result
```

### Environment Discovery
```python
def _discover_environment(self):
    try:
        sts = boto3.client('sts')
        self.current_account_id = sts.get_caller_identity()['Account']

        try:
            self.organizations = boto3.client('organizations')
            org_info = self.organizations.describe_organization()
            self.is_org_account = True

            accounts = self.organizations.list_accounts()
            self.org_accounts = [
                {'id': acc['Id'], 'name': acc['Name'], 'status': acc['Status']}
                for acc in accounts['Accounts'] if acc['Status'] == 'ACTIVE'
            ]
        except:
            self.is_org_account = False
            self.org_accounts = [{'id': self.current_account_id, 'name': 'current', 'status': 'ACTIVE'}]
    except Exception as e:
        pass
```

### CloudFormation Deployment
```python
def deploy_role_to_profile(profile_name, account_name):
    session = boto3.Session(profile_name=profile_name, region_name='us-east-1')
    cf = session.client('cloudformation')

    response = cf.create_stack(
        StackName='aws-operations-command-center-role',
        TemplateBody=template_body,
        Capabilities=['CAPABILITY_NAMED_IAM']
    )

    waiter = cf.get_waiter('stack_create_complete')
    waiter.wait(StackName='aws-operations-command-center-role')
```

### Resilient AWS API Wrapper
```python
def safe_aws_call(func, *args, max_retries=3, **kwargs):
    for attempt in range(max_retries):
        try:
            result = func(*args, **kwargs)
            return {'success': True, 'data': result}
        except ClientError as e:
            error_code = e.response['Error']['Code']
            if error_code in ['Throttling', 'RequestLimitExceeded']:
                time.sleep(2**attempt)
                continue
            elif error_code == 'AccessDenied':
                return {'success': False, 'error': 'access_denied'}
            else:
                return {'success': False, 'error': str(e)}
        except NoCredentialsError:
            return {'success': False, 'error': 'no_credentials'}

    return {'success': False, 'error': 'max_retries_exceeded'}
```
