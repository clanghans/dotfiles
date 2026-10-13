---
name: summarize
description: Generate a concise summary of recent commits, a branch, or a file's change history. Useful for standups, PR descriptions, or catching up on a project.
argument-hint: [<branch>|<file>|--last <n>]
---

# Change Summarizer

Generate concise summaries of git history.

## Mode Selection

1. If `$ARGUMENTS` contains `--last <n>`: summarize last n commits
2. If `$ARGUMENTS` is a branch name: summarize commits since divergence from main
3. If `$ARGUMENTS` is a file path: summarize that file's change history
4. If no arguments: summarize last 5 commits

## Execution

### Last N Commits

```bash
git log --oneline -n <N>
git log -p -n <N> --stat
```

### Branch Summary

```bash
# Find merge base with main
git merge-base main <branch>

# Commits on branch not in main
git log main..<branch> --oneline

# Full diff
git diff main...<branch> --stat
```

### File History

```bash
git log --oneline --follow -- <file>
git log -p --follow -- <file> | head -200
```

## Output Format

### Commits Summary

```
## Summary: <time-range-or-branch>

**<N> commits** by <authors>

### Key Changes
- **<topic>**: <brief description> (<commit-short-hash>)
- **<topic>**: <brief description> (<commit-short-hash>)

### Files Changed
- <file> (+<additions>/-<deletions>)
- <file> (+<additions>/-<deletions>)

### Notable Patterns
[Any themes, refactors, or areas of focus]
```

### Branch Summary (for PR description)

```
## <branch-name>

### Summary
[1-2 sentences on what this branch accomplishes]

### Changes
- <change 1>
- <change 2>
- <change 3>

### Testing
- [ ] Tests added/updated
- [ ] Manual testing done

### Breaking Changes
[Any API or behavior changes]
```

### File History

```
## <filename>

**Last modified**: <date>
**Lines**: +<total>/-<total>

### Recent Changes
| Date | Author | Description |
|------|--------|-------------|
| <date> | <author> | <commit message> |

### Change Patterns
[What kind of changes does this file typically receive?]
```

## Rules

- Keep summaries under 10 bullet points
- Group related commits by topic, not chronologically
- Highlight breaking changes prominently
- Skip trivial commits (typo fixes, formatting)
- Always cite commit hashes for traceability
