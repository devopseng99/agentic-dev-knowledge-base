---
title: "Is devstral really agent friendly?"
url: "https://dev.to/techgirl1908/is-devstral-really-agent-friendly-5e5k"
author: "Angie Jones"
category: "mistral-ai-agent"
---

# Is devstral really agent friendly?

**Author:** Angie Jones
**Published:** May 22, 2025

## Overview
A critical evaluation of Mistral's devstral model, marketed as "designed to excel at agentic coding tasks." Testing with the Goose agent revealed significant failures in tool calling consistency, context memory, and environmental awareness -- all essential for agentic workflows.

## Key Concepts

### Test 1: Tool Calling

Prompt used:
```plaintext
Create a file at ~/workspace/loose-goose/tool-test.txt with the contents "Hello World".
Use the write tool. Do not ask for confirmation. Just do it.
```

First attempt - tool called but with hallucinated file paths:
```
text_editor | developer
path: /Users/pauljoshua/workspace/loose-goose/tool-test.txt
command: write
file_text: Hello World.
```

Second attempt - refused to use tools entirely:
```
I'm here to help, but I'm unable to directly create files or execute commands on your system.
```

Third attempt - tool called but missing required parameters:
```
text_editor | developer
content: Hello World
file_path: ...

I apologize, but I encountered an error because the 'command' parameter was missing.
```

### Test 2: Memory Awareness

Follow-up question in the same session:
```plaintext
did you create the file?
```

Response showed no recollection:
```
I'm not sure which file you're referring to. Could you please provide more details?
```

### Test 3: File System Reasoning

```plaintext
what directory are you in
```

Response showed no environmental awareness:
```
I don't have direct access to a file system or current working directory.
I operate within the parameters set by my programming...
```

### Conclusion

Devstral's marketing claims significantly overstated capabilities. The model failed:
- Basic tool-calling consistency (parameters hallucinated or missing)
- Context memory between turns (no recollection of previous actions)
- Environmental awareness (no knowledge of working directory)

All three are essential for agentic workflows.
