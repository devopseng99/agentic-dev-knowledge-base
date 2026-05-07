---
title: "Create Architecture Diagrams in Seconds with the Amazon Q Developer CLI Agent!"
url: "https://dev.to/aws-heroes/create-architecture-diagrams-in-seconds-with-the-amazon-q-developer-cli-agent-1110"
author: "Faye Ellis"
category: "aws-agents"
---

# Create Architecture Diagrams in Seconds with the Amazon Q Developer CLI Agent!
**Author:** Faye Ellis
**Published:** May 23, 2025

## Overview
Using Amazon Q Developer CLI agent to generate architecture diagrams from CloudFormation templates. Demonstrates both Mermaid and draw.io diagram generation with official AWS icons.

## Key Concepts

### Setup

```bash
brew install amazon-q
q --version
q login
q chat
```

### Generating Mermaid Diagrams from IaC

```
Create a mermaid diagram that represents the contents
of the CloudFormation template named cf-template.yaml.
Here is a link to the template:
https://raw.githubusercontent.com/.../cf-template.yaml
The diagram should include all the AWS resources,
use consistent spacing, clear labels,
include CIDR blocks for networking components.
```

### Generating draw.io Diagrams with AWS Icons

```
Can you create the same diagram again but this time
create a draw.io diagram using the correct AWS icons
for the AWS resources.
```

Amazon Q generated professional draw.io diagrams suitable for practical use.
