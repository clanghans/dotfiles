# Claude Code Agents & Skills Reference

Quick reference for all installed skills, hooks, and extensions.

## Skills (Triggers)

| Skill | Trigger | Purpose |
|-------|---------|---------|
| **graphify** | `/graphify` | Turn codebases into queryable knowledge graphs with community detection, AST extraction, and semantic analysis |
| **grill-me** | User mentions "grill me" or wants to stress-test a design | Relentless interview about a plan until shared understanding |
| **worktree** | `/worktree <branch-name>` | Create git worktree from uncommitted changes, spawn Claude in new tmux window |

## Installed Extensions

| Extension | Purpose |
|-----------|---------|
| `rust-analyzer-lsp` | Rust language server integration |
| `pyright-lsp` | Python type checking and IDE features |
| `clangd-lsp` | C/C++ language server integration |
| `github` | GitHub PR/issue operations from Claude |
| `commit-commands` | Streamlined commit workflows |
| `ponytail` | Status line integration and hooks |

## Hooks

### PreToolUse: RTK Rewrite (`hooks/rtk-rewrite.sh`)

Automatically rewrites Bash commands to use `rtk` for token savings (60-90% reduction). Requires `rtk >= 0.23.0` and `jq`.

Key rewrites:
- `git status/diff/log` → `rtk git status/diff/log`
- `pytest`/`cargo test` → shows failures only
- `tsc`/`lint`/`mypy` → shows errors only

### Status Line (`statusline.sh`)

Shows current model and ponytail mode in the TUI status bar.

## Configuration Highlights

- **Default model**: `claude-glm-5`
- **Model picker**: 30+ models (GPT-5/6, Gemini 3.x, DeepSeek v4, O-series)
- **Theme**: Dark, fullscreen TUI
- **Language**: All output in English

## RTK Quick Reference

```bash
# Git (59-80% savings)
rtk git status          rtk git diff            rtk git log

# Files & Search (60-75% savings)
rtk ls <path>           rtk read <file>         rtk grep <pattern>

# Test (90-99% savings) — failures only
rtk pytest tests/       rtk cargo test

# Build & Lint (80-90% savings) — errors only
rtk tsc                 rtk ruff check          rtk mypy

# Analysis (70-90% savings)
rtk err <cmd>           rtk log <file>          rtk json <file>
```

See `RTK.md` for full command reference.

## Sandbox (`claude-bwrapped`)

Bubblewrap sandbox for Claude Code with:
- Read-only: `/usr`, `/etc`, `/nix`, `~/.config/gh`, `~/.pi`
- Read-write: `~/.claude`, `~/.cache/claude`, current project
- Secrets from `~/.secrets` injected as environment variables
- Resource limits: 10min CPU, 20GB memory, 1000 processes

## Suggested Additional Skills

### 1. `/review` - Code Review Skill

```markdown
---
name: review
description: Perform a thorough code review of staged changes or a PR. Checks for bugs, security issues, performance, and style consistency.
argument-hint: [--staged|--pr <number>]
---
```

Useful for pre-commit review workflow.

### 2. `/summarize` - Change Summarizer

```markdown
---
name: summarize
description: Generate a concise summary of recent commits, a branch, or a file's change history.
argument-hint: [<branch>|<file>|--last <n>]
---
```

Quick context for standups or PR descriptions.

### 3. `/debug` - Debug Assistant

```markdown
---
name: debug
description: Systematic debugging workflow - reproduce, isolate, fix. Guides through hypothesis generation and verification.
argument-hint: <error-message-or-symptom>
---
```

Structured approach to debugging rather than ad-hoc.

### 4. `/refactor` - Safe Refactoring

```markdown
---
name: refactor
description: Plan and execute safe refactoring with tests as anchors. Identifies dependencies, suggests test coverage, performs incremental changes.
argument-hint: <target-function-or-module>
---
```

Guides large-scale changes with safety rails.

## Suggested Extensions

| Extension | Why |
|-----------|-----|
| `docker` | Container management from Claude (already using rtk docker) |
| `terraform-lsp` | IaC support if using Terraform |
| `markdownlint-lsp` | Better documentation editing |

## File Locations

```
~/.claude/
├── settings.json          # Main config (installed from dotfiles)
├── CLAUDE.md              # This file (global instructions)
├── RTK.md                 # RTK command reference
├── skills/
│   ├── graphify/SKILL.md
│   ├── grill-me/SKILL.md
│   └── worktree/SKILL.md
├── hooks/
│   └── rtk-rewrite.sh
└── statusline.sh
```
