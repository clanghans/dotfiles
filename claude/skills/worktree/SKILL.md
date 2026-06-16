---
name: worktree
description: Create a git worktree from uncommitted and committed changes on the current branch. Moves all local changes (staged, unstaged, untracked) into a new worktree on a named branch, leaving the original branch clean.
disable-model-invocation: true
allowed-tools: Bash(git *)
argument-hint: [branch-name]
---

## Current state

!`git status`

!`git log --oneline -5`

## Instructions

Create a git worktree that isolates uncommitted and unpushed changes from the current branch.

### Steps

1. Determine the branch name:
   - If `$ARGUMENTS` is provided, use it as the branch name
   - Otherwise, infer a descriptive branch name from the recent commits and staged changes (e.g. `fix/short-description`)
2. Create the worktree as a sibling directory of the current repo root:
   - `git worktree add ../<branch-name> -b <branch-name>`
3. If there are uncommitted changes (staged, unstaged, or untracked):
   - `git stash --include-untracked` in the current directory
   - `git stash pop` in the new worktree
   - Re-stage all changes in the worktree with `git reset HEAD && git add -A` so git detects renames properly
4. Report the worktree path, branch name, and a summary of what was moved
