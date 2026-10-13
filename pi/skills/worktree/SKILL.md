---
name: worktree
description: Create a git worktree from uncommitted and committed changes on the current branch. Moves all local changes (staged, unstaged, untracked) into a new worktree on a named branch, leaving the original branch clean. Spawns a new Claude Code session in a tmux window.
allowed-tools: Bash(git *), Bash(tmux *), Bash(echo *)
argument-hint: [branch-name]
---

## Current state

!`git status`

!`git log --oneline -5`

## Instructions

Create a git worktree that isolates uncommitted and unpushed changes from the current branch, then spawn a new Claude Code session in a tmux window pointing at the worktree.

Minimize the number of tool calls by chaining shell commands with `&&`.

### Steps

1. Determine the branch name:
   - If `$ARGUMENTS` is provided, use it as the branch name
   - Otherwise, infer a descriptive branch name from the recent commits and staged changes (e.g. `fix/short-description`)
2. Create the worktree and move changes in a single command:
   ```
   git worktree add ../<branch-name> -b <branch-name> && \
   git stash --include-untracked && \
   git -C ../<branch-name> stash pop && \
   git -C ../<branch-name> reset HEAD && \
   git -C ../<branch-name> add -A
   ```
   Skip the stash commands if there are no uncommitted changes (staged, unstaged, or untracked).
3. Report the worktree path, branch name, and a summary of what was moved
4. Spawn a new Claude Code session in a tmux window:
   - Skip this step if not running inside tmux (check `$TMUX`)
   - Compose a short context prompt (one paragraph, no special quotes) summarizing: the branch name, the parent branch it was forked from, the worktree path, and what changes were moved
   - Open a new tmux window and send the claude command in a single call:
     ```
     tmux new-window -c <worktree-path> -n <branch-name> && \
     tmux send-keys -t <branch-name> 'claude "<context-prompt>"' Enter
     ```
   - Use the full branch name as the tmux window name (e.g. `fix/login-bug`)
