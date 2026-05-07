---
title: "How I Use 4 Terminal Setups with Claude Code Agent Teams"
url: "https://dev.to/coa00/how-i-use-4-terminal-setups-with-claude-code-agent-teams-52i9"
author: "Kohei Aoki"
category: "agent-team-coordination"
---
# How I Use 4 Terminal Setups with Claude Code Agent Teams
**Author:** Kohei Aoki  **Published:** March 31, 2026

## Overview
Evaluation of four terminal environments on macOS for Claude Code Agent Teams split-pane mode, which requires either tmux or iTerm2.

## Key Concepts

### Feature Matrix
| Feature | Ghostty | iTerm2 | Ghostty + tmux | Ghostty + zellij |
|---------|---------|--------|----------------|------------------|
| Rendering speed | ◎ | △ slow | ◎ | ◎ |
| URL/file clicking | ◎ | ◎ | ◎ | ◎ |
| Session persistence | × | × | ○ plugin | ◎ built-in |
| Agent Teams split pane | × | ○ it2 CLI | ◎ | × |
| Ease of use | ◎ | ◎ | △ | ◎ |

### Ghostty + tmux Configurations

#### Shift+Enter Fix
```
keybind = shift+enter=text:\x1b[13;2u
```

#### Session Persistence
```
set -g @plugin 'tmux-plugins/tmux-resurrect'
set -g @plugin 'tmux-plugins/tmux-continuum'
set -g @resurrect-capture-pane-contents 'on'
set -g @continuum-restore 'on'
set -g @continuum-save-interval '15'
```

#### Claude Code Status Line
```
set -g status-left "#[fg=#89b4fa,bold] #(cat ~/.claude/tmux-status-left.txt 2>/dev/null || echo '#S') "
set -g status-right "#[fg=#a6e3a1]#(cat ~/.claude/tmux-status-right.txt 2>/dev/null)#[default]"
```

### fzf Session Picker
```bash
curl -fsSL https://raw.githubusercontent.com/coa00/ghostty-session-picker/main/ghostty-session-picker \
  -o ~/.local/bin/ghostty-session-picker
chmod +x ~/.local/bin/ghostty-session-picker
```

### Use-Case Recommendations
- **Daily Claude Code usage:** Ghostty for speed and URL interaction
- **Agent Teams with split panes:** Ghostty + tmux
- **Session persistence with intuitive interface:** Ghostty + zellij
- **Minimal configuration, stability-focused:** iTerm2
