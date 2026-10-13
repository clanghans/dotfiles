# Pi Coding Agent Configuration

Quick reference for installed skills, extensions, and configuration.

## Skills

| Skill | Trigger | Purpose |
|-------|---------|---------|
| **graphify** | `/skill:graphify` | Turn codebases into queryable knowledge graphs with community detection, AST extraction, and semantic analysis |
| **grill-me** | `/skill:grill-me` or user mentions "grill me" | Relentless interview about a plan until shared understanding |
| **worktree** | `/skill:worktree <branch-name>` | Create git worktree from uncommitted changes, spawn Pi in new tmux window |
| **review** | `/skill:review [--staged\|--pr <n>]` | Systematic code review with checklist |
| **debug** | `/skill:debug <error>` | Hypothesis-driven debugging workflow |
| **refactor** | `/skill:refactor <target>` | Safe refactoring with test safety nets |
| **summarize** | `/skill:summarize [branch\|file]` | Git history summaries for standups and PRs |

## Extensions

| Extension | Purpose |
|-----------|---------|
| `rtk.ts` | Token-optimized command rewriter (60-90% savings on git, tests, lint, docker) |
| `ponytail.ts` | Think like the laziest senior dev - question if code is even needed |

### Ponytail Modes

Toggle with `/ponytail` command:
- `off` - Normal behavior
- `full` - Full lazy senior dev mode
- `questions` - Ask challenging questions before implementing
- `review` - Review-focused mode for code critiques

## Model Providers

Configured in `models.json`:

| Provider | Base URL | Models |
|----------|----------|--------|
| **BBM** | `litellm.orchestration.bbm.ai.bosch.com` | Claude Opus/Sonnet/Haiku 5.x, GPT-5/6, Gemini 3.x, DeepSeek v4 |
| **ESY** | `litellm.etas-llm-farm.dev` | Claude Opus/Sonnet/Haiku, Claude GLM 5, Coding Autorouter |

### Recommended Models

| Use Case | Model | Why |
|----------|-------|-----|
| **General coding** | `claude-sonnet-5-5` (ESY) | Best balance of speed and quality |
| **Complex reasoning** | `claude-opus-5-5` (BBM) | Highest capability |
| **Fast iteration** | `claude-haiku-5-5` (BBM) | Cheapest, fastest |
| **Large context** | `gpt-6-luna` (BBM) | 922K context window |
| **Cost-effective** | `deepseek-v4-flash` (BBM) | Cheapest per token |

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

## Sandbox (`pi-bwrapped`)

Bubblewrap sandbox with:
- Read-only: `/usr`, `/etc`, `/nix`, `~/.config/gh`
- Read-write: `~/.pi`, `~/.cache/pi`, current project
- Secrets from `~/.secrets` injected as environment variables
- Resource limits: 10min CPU, 20GB memory, 1000 processes

## Configuration Files

```
pi/
├── models.json       # Provider and model definitions
├── pi-bwrapped       # Bubblewrap sandbox script
├── extensions/
│   └── rtk.ts        # RTK token optimizer
├── skills/
│   ├── debug/
│   ├── graphify/
│   ├── grill-me/
│   ├── refactor/
│   ├── review/
│   ├── summarize/
│   └── worktree/
├── RTK.md            # RTK command reference
└── AGENTS.md         # This file
```

## Installation

The `install.sh --pi` flag creates:
- `~/.pi/agent/models.json` → symlink to `pi/models.json`
- `~/.local/bin/pi-bwrapped` → symlink to `pi/pi-bwrapped`

Extensions and skills are loaded from:
- `~/.pi/agent/extensions/` (user)
- `~/.pi/agent/skills/` (user)
- `.pi/extensions/` (project)
- `.pi/skills/` (project)

To enable the RTK extension, add to `~/.pi/agent/settings.json`:
```json
{
  "extensions": ["~/ws/github/dotfiles/pi/extensions/rtk.ts"]
}
```

To enable all skills, add to `~/.pi/agent/settings.json`:
```json
{
  "skills": ["~/ws/github/dotfiles/pi/skills/*"]
}
```

## Environment Variables

Required in `~/.secrets`:
- `BBM_LITELLM_API_KEY` - BBM provider authentication
- `ESY_LITELLM_API_KEY` - ESY provider authentication
