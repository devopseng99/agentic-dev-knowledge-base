---
title: "Utilizing Coverage AI Agents for Better Unit Tests"
url: "https://dev.to/charlesuneze/utilizing-coverage-ai-agents-for-better-unit-tests-436c"
author: "Charles Uneze"
category: "ai-agent-unit-testing"
---

# Utilizing Coverage AI Agents for Better Unit Tests

**Author:** Charles Uneze
**Published:** May 21, 2024

## Overview
Using CodiumAI's Cover-Agent implementing Meta's TestGen-LLM to automatically iterate test generation until coverage increases.

## Key Concepts

### Source Code (aws.py)

```python
import time
import boto3

dynamodb = boto3.resource('dynamodb')
ec2 = boto3.resource('ec2')

def create_ec2_instance():
    instance_params = {
        'ImageId': '12345',
        'InstanceType': 't2.micro',
        'KeyName': 'key',
        'MinCount': 1,
        'MaxCount': 1
    }
    instances = ec2.create_instances(**instance_params)
    instance = instances[0]
    while instance.state['Name'] != 'running':
        time.sleep(5)
        instance.reload()
    return instance
```

### Initial Test

```python
from moto import mock_aws
from aws import create_ec2_instance

@mock_aws
def test_create_ec2_instance():
    instance = create_ec2_instance()
    assert instance.state['Name'] == 'running'
```

Initial coverage: 76%. After Cover-Agent run: 100%.

### AI-Generated Test

```python
@mock_aws
def test_create_dynamodb_table_wait_until_exists():
    create_dynamodb_table_and_put_item()
    dynamodb = boto3.resource('dynamodb', region_name='eu-west-2')
    table = dynamodb.Table('AMI_Table')
    table.wait_until_exists()
    assert table.table_status == 'ACTIVE'
```

### Running Cover-Agent

```bash
cover-agent \
  --source-file-path "aws.py" \
  --test-file-path "test_aws.py" \
  --code-coverage-report-path "./coverage.xml" \
  --test-command "pytest --cov=. --cov-report=xml --cov-report=term" \
  --coverage-type "cobertura" \
  --desired-coverage 77 \
  --max-iterations 5
```
