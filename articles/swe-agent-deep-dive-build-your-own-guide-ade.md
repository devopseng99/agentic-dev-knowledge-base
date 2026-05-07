---
title: "SWE-agent -- Deep Dive & Build-Your-Own Guide"
url: "https://dev.to/truongpx396/swe-agent-deep-dive-build-your-own-guide-ade"
author: "Truong Phung"
category: "swe-bench"
---

# SWE-agent -- Deep Dive & Build-Your-Own Guide

**Author:** Truong Phung
**Published:** April 28, 2026
**Tags:** #ai #llm #tutorial #webdev

---

## Summary

This comprehensive guide examines SWE-agent, an autonomous software engineering AI system developed by Princeton NLP and Stanford that achieved breakthrough results on SWE-Bench through a novel Agent-Computer Interface (ACI) design. The article provides architectural deep-dives, code walkthroughs, and practical implementation guidance.

---

## Key Architectural Components

### The Five Moving Parts

```
DefaultAgent (loop, history, trajectory)
    |
SWEEnv (problem, repo, bundle install)
    |
Tool bundles (YAML + bash/Python)
    |
SWE-ReX runtime (Local/Docker/Modal/Fargate)
    |
Persistent shell session + git repo
```

The system separates concerns cleanly: the agent owns the decision loop, the environment manages sandbox setup, tools are portable bash scripts declared in YAML, and the runtime abstracts execution across deployment targets.

---

## The Agent Loop (30 lines)

```python
def run(self) -> Trajectory:
    self.setup()
    step_output = StepOutput(done=False)
    while not step_output.done:
        step_output = self.step()
        self.save_trajectory()
    return self._trajectory

def forward_with_handling(self, messages):
    for attempt in range(self.max_requeries):
        try:
            return self.forward(messages)
        except FormatError:
            messages = inject(self.templates.format_error_template)
        except BashIncorrectSyntaxError:
            messages = inject(self.templates.shell_check_error_template)
        except CommandTimeoutError:
            self._n_consecutive_timeouts += 1
            if self._n_consecutive_timeouts >= self.tools.config.max_consecutive_execution_timeouts:
                raise
    raise FormatError("Exceeded max_requeries")

def forward(self, messages) -> StepOutput:
    response = self.model.query(messages)
    thought, action = self.tools.parse_actions(response)
    self._check_bash_syntax(action)
    observation = self._env.communicate(action, timeout=...)
    state = self._env.communicate(self.tools.config.state_command)
    if self.tools.check_for_submission_cmd(observation):
        return self.handle_submission(observation, state)
    return StepOutput(thought=thought, action=action, observation=observation, state=state)
```

The core pattern: **render -> call -> parse -> validate -> execute -> check for completion**.

---

## The Agent-Computer Interface (ACI) -- Central Innovation

The paper's central thesis: "language models are a new kind of end user, and they need software interfaces designed for them, not for humans."

### Four ACI Design Rules

1. **Concise, bounded output** -- no unbounded `cat` or `grep -rn`; every command has maximum size and structured shape
2. **Persistent state across turns** -- runtime owns cursor position (`CURRENT_FILE`, `FIRST_LINE`); agent always knows where it is
3. **Guard rails on destructive actions** -- edits run through linters with auto-revert; bash is syntax-checked before execution
4. **Predictable, minimal argument grammar** -- each command has 1-2 positional arguments maximum; multi-line bodies use sentinels

### The Four Flagship ACI Tools

#### 1. Windowed File Viewer (`tools/windowed/`)

```bash
# Viewing a file with 100-line window, 2-line overlap
[File: /repo/src/foo.py (250 lines total)]
(95 more lines above)
96:def example():
97:    return 1
...
195:    pass
(55 more lines below)
```

- **Window size:** 100 lines (configurable)
- **Overlap:** 2 lines between scrolls
- **`goto N`:** Places N at ~1/6 down the window, providing context
- **Status lines:** Tell agent total file length and relative position
- **`_state` command:** Returns JSON with cursor position for next prompt

#### 2. Bounded Search (`tools/search/`)

```bash
# search_dir refusal when results exceed 100 files
More than 150 files matched ... Please narrow your search.

# Success case: filename + match counts only
Found 47 matches for "parse_args" in /repo:
./src/cli.py (12 matches)
./src/parser.py (28 matches)
./tests/test_cli.py (7 matches)
End of matches for "parse_args" in /repo
```

Why not raw `grep -rn`: bounded output, filename-only results (saves tokens), hard cap forcing strategy over brute-force.

#### 3. Edit with Lint-Checking and Rollback (`tools/windowed_edit_linting/`)

```bash
edit 10:15
def new_function():
    return foo()
end_of_edit
```

**Implementation logic:**
1. Run flake8 before edit
2. Apply replacement text
3. Run flake8 after edit
4. Diff errors, filtering pre-existing issues
5. If new errors introduced, auto-revert and show agent both states side-by-side

**Syntax rules:** F821/F822 (undefined names), E111/E112/E113 (indentation), E999/E902 (fatal errors only).

On failure output:
```
Your proposed edit has introduced new syntax error(s).

ERRORS:
- undefined name 'foo'

[side-by-side before/after views with line numbers]

Your changes have NOT been applied.
DO NOT re-run the same failed edit command.
```

#### 4. Submission Signal (`tools/submit/`)

```bash
#!/usr/bin/env bash
cd $ROOT
git add -A
git diff --cached > /root/model.patch
echo "<<SWE_AGENT_SUBMISSION>>"
cat /root/model.patch
echo "<<SWE_AGENT_SUBMISSION>>"
```

Unique sentinel pattern (`<<SWE_AGENT_SUBMISSION>>`) means any tool can declare completion. Loop greps for it; when found, `done = True`.

---

## Tool Bundles -- YAML + Bash Abstraction

### Bundle Structure
```
tools/<bundle>/
  config.yaml          # tool signatures, docstrings, args
  install.sh           # runs once at sandbox startup
  bin/
    <tool_name>        # bash or python+shebang executable
  lib/                 # shared helpers
  pyproject.toml       # optional Python deps
```

### Minimal Tool Specification

```yaml
# config.yaml
tools:
  my_command:
    signature: "my_command <arg1> [<arg2>]"
    docstring: "Description for the LM."
    arguments:
      - { name: arg1, type: string, required: true }
      - { name: arg2, type: integer, required: false }
state_command: "_my_state"
env_variables:
  MY_VAR: "default"
```

**Why YAML + bash instead of Python plugins:**
- Universal portability across Linux containers
- Trivial install: `cp -r tools/<bundle> $SANDBOX && bash install.sh`
- Tool docs render directly into system prompt

---

## Prompts -- What the Agent Sees

### Modern Default (Function-Calling)

```
SYSTEM:
You are a helpful assistant that can interact with a computer to solve tasks.

INSTANCE:
I've uploaded a python code repository. Consider this PR:
<pr_description>
{{problem_statement}}
</pr_description>

Follow these steps:
1. Find and read code relevant to the PR
2. Create a script to reproduce the error
3. Edit source code to resolve the issue
4. Re-run reproduce script and confirm fix
5. Consider edge cases

NEXT_STEP:
OBSERVATION:
{{observation}}
```

**Three important notes:**
- System prompt is one line; task context in instance template
- Five-step recipe encodes human SWE workflow
- No few-shot demonstrations in v1.0+ default

### Classic ReAct Prompt

```
SETTING: You are an autonomous programmer working in a command line with a special interface.

COMMANDS:
{{command_docs}}

RESPONSE FORMAT:
Your shell prompt is: (Open file: <path>) <cwd> $

Format output with DISCUSSION then COMMAND sections:

DISCUSSION
First I'll use ls to see what files are in the directory...

ls -a
```

Includes empirically-derived tips:
- "Use `goto 583` instead of multiple `scroll_down` for distant lines"
- "If a command didn't work once, it won't work the second time without modification"
- "Always check code after issuing an edit"

---

## SWE-ReX Runtime

Uniform API across deployment targets:

```python
class Runtime:
    async def communicate(self, command: str, timeout: int = 30) -> tuple[str, int]:
        # send to persistent shell, wait for sentinel, return (stdout, exit_code)
        ...
    async def write_file(self, path: str, content: str) -> None: ...
    async def read_file(self, path: str) -> str: ...
```

**Backends:** Local (subprocess), Docker, Modal (serverless), AWS Fargate, Daytona.

**Sentinel-based completion detection:**
```bash
my_command; echo "###SWE-REX-COMPLETE-<unique-id>###"
```

Appends unique sentinel; waits for stdout appearance. Enables interactive tools (gdb, ipython, netcat) across multiple turns.

---

## Autonomy -- Termination Paths

The loop runs unattended until one of four terminal states:

| Path | Signal | Exit Status |
|------|--------|-------------|
| **Submit** | `<<SWE_AGENT_SUBMISSION>>` in stdout | `submitted` |
| **Exit command** | `exit` or `exit_forfeit` | `exit_command` / `exit_forfeit` |
| **Autosubmit on error** | Cost/context/timeout/format limits | `exit_cost` / `exit_context` / etc. |
| **Format-error budget** | 3+ consecutive parse/syntax failures | `exit_format` |

**Critical design:** Every error path triggers autosubmit (run `git diff`, ship partial patch) rather than crash. SWE-Bench awards partial credit.

### Budget System

```python
per_instance_cost_limit: float = 3.0      # USD -- primary budget knob
total_execution_timeout: int              # cumulative bash time
execution_timeout: int = 30               # per-command timeout
max_consecutive_execution_timeouts: int = 5
max_observation_length: int = 100_000     # chars; truncated above this
```

Cost is the primary stop signal, not step count (step counts vary 5x across model families).

### Error Recovery -- Requery Ladder

```python
def forward_with_handling(self, messages):
    for attempt in range(self.max_requeries):  # default 3
        try:
            return self.forward(messages)
        except FormatError:
            messages = inject(format_error_template)
        except _BlockedActionError:
            messages = inject(action_blocked_template)
        except BashIncorrectSyntaxError:
            messages = inject(shell_check_error_template)
        except CommandTimeoutError:
            # increment counter; raise if >= max
            messages = inject(timeout_template)
```

**Three-layer guard rails:**
1. `bash -n` syntax check before execution
2. flake8 + auto-revert on edits
3. Format-error requery (up to 3 times)

---

## Configuration System (YAML-First)

### Single-Task Invocation

```bash
sweagent run \
  --agent.model.name=claude-sonnet-4-20250514 \
  --agent.model.per_instance_cost_limit=2.00 \
  --env.repo.github_url=https://github.com/user/repo \
  --problem_statement.github_url=https://github.com/user/repo/issues/1
```

### Batch / SWE-Bench

```bash
sweagent run-batch \
  --config config/default.yaml \
  --agent.model.name gpt-4o \
  --instances.type swe_bench \
  --instances.subset lite \
  --num_workers 8
```

### Top-Level YAML Structure

```yaml
agent:
  type: default  # or 'retry'
  templates: {...}
  tools: {...}
  model: {...}

env:
  repo: {...}
  deployment: {type: local/docker/modal/fargate}

problem_statement:
  type: github_issue
  github_url: "..."
```

---

## Build-Your-Own -- 200-Line MVP

### Minimal Agent Loop

```python
import subprocess, litellm

class Agent:
    def __init__(self, model, workdir, problem_statement, cost_limit=3.0):
        self.model = model
        self.history = [
            {"role": "system", "content": "You are an autonomous programmer..."},
            {"role": "user", "content": f"Fix this: {problem_statement}"},
        ]
        self.cost = 0.0
        self.cost_limit = cost_limit
        self.done = False
        self.submission = None

    def run(self):
        while not self.done:
            try:
                self.step()
            except CostLimitExceeded:
                self.autosubmit("exit_cost")
                break
            except Exception as e:
                self.autosubmit(f"exit_error: {e}")
                break
        return self.submission

    def step(self):
        if self.cost > self.cost_limit:
            raise CostLimitExceeded()
        resp = litellm.completion(model=self.model, messages=self.history)
        self.cost += resp._hidden_params["response_cost"]
        text = resp.choices[0].message.content

        thought, action = parse_thought_action(text)

        # Syntax check
        if subprocess.run(["bash", "-n", "-c", action],
                         capture_output=True).returncode != 0:
            self.history.append({"role": "user",
                               "content": "Bash syntax error. Try again."})
            return

        # Execute
        result = subprocess.run(["bash", "-c", action],
                               capture_output=True, text=True,
                               cwd=self.workdir, timeout=60)
        observation = result.stdout + result.stderr

        if "<<SWE_AGENT_SUBMISSION>>" in observation:
            self.done = True
            self.submission = self.run_git_diff()
            return

        # Append to history
        self.history.append({"role": "assistant", "content": text})
        self.history.append({"role": "user",
                           "content": f"OBSERVATION:\n{observation}"})

    def autosubmit(self, exit_status):
        self.submission = self.run_git_diff()
        self.done = True
```

### Four ACI Tools as Bash Scripts

```bash
# bin/open
file="$1"; line="${2:-1}"
echo "{\"open_file\": \"$file\", \"first_line\": $line}" > /tmp/agent_state.json
WINDOW=100; total=$(wc -l < "$file")
end=$((line + WINDOW)); above=$((line - 1)); below=$((total - end))
echo "[File: $file ($total lines total)]"
[ $above -gt 0 ] && echo "($above more lines above)"
sed -n "${line},${end}p" "$file" | nl -ba -s: -w1
[ $below -gt 0 ] && echo "($below more lines below)"
```

```bash
# bin/edit (paraphrased)
file=$(jq -r .open_file /tmp/agent_state.json)
range="$1"; start="${range%%:*}"; end="${range##*:}"
shift; replacement=$(cat)
cp "$file" "$file.bak"
{ head -n $((start-1)) "$file.bak"; echo "$replacement";
  tail -n +$((end+1)) "$file.bak"; } > "$file"

# Lint check
new_errors=$(flake8 --select=F821,F822,E999 "$file")
old_errors=$(flake8 --select=F821,F822,E999 "$file.bak")
diff_errors=$(diff <(echo "$old_errors") <(echo "$new_errors") | grep '^>')

if [ -n "$diff_errors" ]; then
    cp "$file.bak" "$file"
    echo "Edit rejected -- flake8 errors:"; echo "$diff_errors"
    exit 1
fi
echo "Edit applied to $file."
```

```bash
# bin/submit
git -C "$1" add -A
git -C "$1" diff --cached
echo "<<SWE_AGENT_SUBMISSION>>"
```

**High-leverage upgrades (priority order):**
1. Persistent shell session (survive cd, source activation)
2. `last_n_observations` history processor (context bounding)
3. Function-calling parser (Anthropic/OpenAI native)
4. Trajectory recording (JSON dumps per step)
5. Docker backend (parallel instances)
6. Reviewer LLM on submit

---

## Performance Metrics

| Benchmark | Score | Model |
|-----------|-------|-------|
| SWE-Bench (Full) v0.7 | 12.29% | GPT-4 |
| SWE-Bench Lite | 18.0% | GPT-4 |
| HumanEvalFix | 87.7% | GPT-4 |
| SWE-Bench Verified v1.0+ | SoTA (~62-66%) | Claude 3.7 Sonnet |
| Mini-SWE-Agent (100 LOC) | 65% | Claude 3.7 Sonnet |
| NYU CTF (EnIGMA) | 13.5% | GPT-4 |
| Mean cost/instance | ~$2 (under $4) | GPT-4 |

**Critical ablation:** ACI tools vs. raw bash shows "roughly 2x score improvement." Without the interface, GPT-4 + raw bash is no better than original RAG baseline.

---

## EnIGMA Extension -- Multi-Domain Generalization

SWE-agent principles extended to offensive cybersecurity (CTF tasks). Key innovations:

- **Interactive Agent Tools (IAT):** Stateful subprocesses (gdb, nc, ipython) where state spans turns
- **New tool families:** Debugger interface (breakpoints, register inspection), decompiler (ghidra/radare2), server interaction (netcat-like)
- **Soliloquizing mitigation:** Models hallucinate fake output instead of waiting for real tools. Solution: enforce real round-trips through runtime (no way to "see" output without executing).

Result: **13.5% on NYU CTF** (390 total challenges across 3 domains; ~3x prior SoTA).

---

## Design Rules to Copy (13-Point Checklist)

1. **Agent-shaped tools, not human-shaped** -- bounded output, persistent runtime state, fixed grammars, side-by-side error messaging
2. **Validate destructive actions before they land** -- `bash -n`, flake8 + diff-filtering, auto-rollback
3. **Make every termination path produce degraded success** -- cost/context/timeout -> autosubmit, not crash
4. **Use cost as budget, not steps** -- step counts vary 5x across model families
5. **Tools as YAML + bash, not Python plugins** -- universal portability, trivial install, automatic prompt inclusion
6. **Sentinel pattern for completion** -- unique string (`<<SWE_AGENT_SUBMISSION>>`) in observation; no separate done-channel
7. **Run history through processors before every model call** -- cache control + last-N-observations for prompt caching and context bounding
8. **Separate runtime from agent** -- SWE-ReX abstraction enables Local/Docker/Modal/Fargate swapping and massive parallelism
9. **No semantic guardrails unless 100% precision** -- prompt hints beat detectors when false-positive cost is high
10. **Optimize prompt + tools, not framework** -- 100-line MVP gets 65% SWE-Bench; framework should be invisible

---

## Lessons & Limitations (Team-Stated)

- **Long files break naive `cat`** -- windowed viewer was single biggest delta
- **`sed`-based edits fail** -- line-range edit + flake8 + auto-revert fixed compounding errors
- **Verbose tool output destroys reasoning** -- capping results, suppressing progress bars were necessary
- **Demonstrations don't generalize** -- GPT-4-tuned demos hurt Claude; v1.0 default dropped them entirely
- **Soliloquizing** -- models hallucinate fake stdout when tools are slow/interactive; mitigation is structural
- **Step-budget vs. cost-budget** -- v1.0 chose cost because step counts vary too much
- **Reviewer-on-submit was mixed** -- sometimes rejects correct patches; opt-in, not default
- **Multi-agent flows didn't pay off** -- delegation abandoned for SWE tasks (better for CTF)

---

## Sources

- [SWE-agent GitHub](https://github.com/SWE-agent/SWE-agent)
- [SWE-agent docs](https://swe-agent.com/latest/)
- [Paper: arXiv 2405.15793](https://arxiv.org/abs/2405.15793) (NeurIPS 2024)
- [EnIGMA paper: arXiv 2409.16165](https://arxiv.org/abs/2409.16165) (ICML 2025)
- [SWE-ReX runtime](https://github.com/SWE-agent/SWE-ReX)
- [Mini-SWE-Agent](https://github.com/SWE-agent/mini-swe-agent) (100-line reference implementation)
