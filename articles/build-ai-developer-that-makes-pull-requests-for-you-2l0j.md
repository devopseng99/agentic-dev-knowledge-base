---
title: "Build AI developer that makes pull requests for you"
url: "https://dev.to/tereza_tizkova/build-ai-developer-that-makes-pull-requests-for-you-2l0j"
author: "Tereza Tizkova"
category: "openai-assistants-api"
---

# Build AI developer that makes pull requests for you

**Author:** Tereza Tizkova
**Published:** December 21, 2023

## Overview
A guide to building an AI developer agent using Python that can clone GitHub repositories, make code modifications, commit changes, and create pull requests automatically. Uses OpenAI Assistants API with function calling and E2B Sandboxes for remote code execution.

## Key Concepts
- OpenAI Assistants API with function calling for agent intelligence
- E2B Sandboxes for isolated cloud execution environments
- GitHub CLI integration for PR creation
- Thread-based conversation management

## Code Examples

### Actions Module - Directory and Console Setup
```python
import os
import random
import string
from typing import Any, Dict
from e2b import Sandbox
from rich.console import Console
from rich.theme import Theme

REPO_DIRECTORY = "/home/user/repo"

custom_theme = Theme({"sandbox_action": "bold #E57B00"})
console = Console(theme=custom_theme)

def print_sandbox_action(action_type: str, action_message: str):
    console.print(
        f"[sandbox_action] [Sandbox Action][/sandbox_action] {action_type}: {action_message}"
    )
```

### Create Directory Action
```python
def create_directory(sandbox: Sandbox, args: Dict[str, Any]) -> str:
    directory = args["path"]
    print_sandbox_action("Creating directory", directory)
    try:
        sandbox.filesystem.make_dir(directory)
        return "success"
    except Exception as e:
        return f"Error: {e}"
```

### Save Content to File Action
```python
def save_content_to_file(sandbox: Sandbox, args: Dict[str, Any]) -> str:
    path = args["path"]
    content = args["content"]
    print_sandbox_action("Saving content to", path)
    try:
        dir = os.path.dirname(path)
        sandbox.filesystem.make_dir(dir)
        sandbox.filesystem.write(path, content)
        return "success"
    except Exception as e:
        return f"Error: {e}"
```

### Commit Action
```python
def commit(sandbox: Sandbox, args: Dict[str, Any]) -> str:
    repo_directory = "/home/user/repo"
    commit_message = args["message"]
    print_sandbox_action("Committing with the message", commit_message)

    git_add_proc = sandbox.process.start_and_wait(f"git -C {repo_directory} add .")
    if git_add_proc.exit_code != 0:
        error = f"Error adding files to staging: {git_add_proc.stdout}\n\t{git_add_proc.stderr}"
        console.print("\t[bold red]Error:[/bold red]", error)
        return error

    git_commit_proc = sandbox.process.start_and_wait(
        f"git -C {repo_directory} commit -m '{commit_message}'"
    )
    if git_commit_proc.exit_code != 0:
        error = f"Error committing changes: {git_commit_proc.stdout}\n\t{git_commit_proc.stderr}"
        console.print("\t[bold red]Error:[/bold red]", error)
        return error

    return "success"
```

### Make Pull Request Action
```python
def make_pull_request(sandbox: Sandbox, args: Dict[str, Any]) -> str:
    base_branch = "main"
    random_letters = "".join(random.choice(string.ascii_letters) for _ in range(5))
    new_branch_name = f"ai-developer-{random_letters}"
    title = args["title"]
    body = ""

    print_sandbox_action("Making a pull request", f"from '{new_branch_name}' to '{base_branch}'")

    git_checkout_proc = sandbox.process.start_and_wait(
        f"git -C {REPO_DIRECTORY} checkout -b {new_branch_name}"
    )
    if git_checkout_proc.exit_code != 0:
        error = f"Error creating a new git branch: {git_checkout_proc.stderr}"
        return error

    git_push_proc = sandbox.process.start_and_wait(
        f"git -C {REPO_DIRECTORY} push -u origin {new_branch_name}"
    )
    if git_push_proc.exit_code != 0:
        error = f"Error pushing changes: {git_push_proc.stderr}"
        return error

    gh_pull_request_proc = sandbox.process.start_and_wait(
        cmd=f'gh pr create --base "{base_branch}" --head "{new_branch_name}" --title "{title}" --body "{body}"',
        cwd=REPO_DIRECTORY,
    )
    if gh_pull_request_proc.exit_code != 0:
        error = f"Error creating pull request: {gh_pull_request_proc.stderr}"
        return error

    return "success"
```

### Create Assistant with Function Definitions
```python
from typing import List
from dotenv import load_dotenv
import openai
from openai.types.beta.assistant_create_params import Tool

load_dotenv()

def create_assistant():
    client = openai.Client()

    functions: List[Tool] = [
        {
            "type": "function",
            "function": {
                "name": "create_directory",
                "description": "Create a directory",
                "parameters": {
                    "type": "object",
                    "properties": {
                        "path": {"type": "string", "description": "The path to the directory"},
                    },
                    "required": ["path"],
                },
            },
        },
        {
            "type": "function",
            "function": {
                "name": "save_content_to_file",
                "description": "Save content (code or text) to file",
                "parameters": {
                    "type": "object",
                    "properties": {
                        "content": {"type": "string", "description": "The content to save"},
                        "path": {"type": "string", "description": "The path to the file"},
                    },
                    "required": ["content", "path"],
                },
            },
        },
        {
            "type": "function",
            "function": {
                "name": "commit",
                "description": "Commit changes to the repo",
                "parameters": {
                    "type": "object",
                    "properties": {
                        "message": {"type": "string", "description": "The commit message"},
                    },
                    "required": ["message"],
                },
            },
        },
        {
            "type": "function",
            "function": {
                "name": "make_pull_request",
                "description": "Creates a new branch and makes a pull request",
                "parameters": {
                    "type": "object",
                    "properties": {
                        "title": {"type": "string", "description": "The title of the pull request"},
                    },
                    "required": ["title"],
                },
            },
        },
    ]

    ai_developer = client.beta.assistants.create(
        instructions="""You are an AI developer. You help user work on their tasks related to coding in their codebase. The provided codebase is in the /home/user/repo.
    When given a coding task, work on it until completion, commit it, and make pull request.
    By default, always either commit your changes or make a pull request after performing any action on the repo.""",
        name="AI Developer",
        tools=functions,
        model="gpt-4-1106-preview",
    )
    print("AI Developer Assistant created:", ai_developer.id)
```

### Main Loop with E2B Sandbox
```python
import os
from dotenv import load_dotenv
from e2b import Sandbox
import openai
import time

load_dotenv()
client = openai.Client()
AI_ASSISTANT_ID = os.getenv("AI_ASSISTANT_ID")
USER_GITHUB_TOKEN = os.getenv("GITHUB_TOKEN")
assistant = client.beta.assistants.retrieve(AI_ASSISTANT_ID)

def setup_git(sandbox):
    sandbox.process.start_and_wait("git config --global user.email 'ai-developer@email.com'")
    sandbox.process.start_and_wait("git config --global user.name 'AI Developer'")
    proc = sandbox.process.start_and_wait(f"echo {USER_GITHUB_TOKEN} | gh auth login --with-token")
    sandbox.process.start_and_wait("gh auth setup-git")

def main():
    sandbox = Sandbox()
    setup_git(sandbox)
    repo_url = prompt_user_for_github_repo()
    sandbox.process.start_and_wait(f"git clone {repo_url} {REPO_DIRECTORY}")

    while True:
        user_task = prompt_user_for_task(repo_url)
        thread = client.beta.threads.create(
            messages=[{"role": "user", "content": f"Carefully plan this task: {user_task}"}],
        )
        run = client.beta.threads.runs.create(thread_id=thread.id, assistant_id=assistant.id)

        while True:
            if run.status == "requires_action":
                outputs = sandbox.openai.actions.run(run)
                if len(outputs) > 0:
                    client.beta.threads.runs.submit_tool_outputs(
                        thread_id=thread.id, run_id=run.id, tool_outputs=outputs
                    )
            elif run.status == "completed":
                messages = client.beta.threads.messages.list(thread_id=thread.id).data[0].content
                text_messages = [m for m in messages if m.type == "text"]
                print("Result:", text_messages[0].text.value)
                break
            elif run.status in ["cancelled", "cancelling", "expired", "failed"]:
                break

            run = client.beta.threads.runs.retrieve(thread_id=thread.id, run_id=run.id)
            time.sleep(0.5)

if __name__ == "__main__":
    main()
```

## Prerequisites
- OpenAI API key with Assistants API access
- E2B Sandbox free API key
- GitHub personal access token with repo, read:org, and read:project permissions
