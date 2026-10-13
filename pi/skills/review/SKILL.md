---
name: review
description: Perform a thorough code review of staged changes, a PR, or recent commits. Checks for bugs, security issues, performance problems, and style consistency. Use when asked to review code or before committing.
argument-hint: [--staged|--pr <number>|--last <n>]
---

# Code Review

Perform a systematic review of code changes.

## Scope Selection

1. If `$ARGUMENTS` contains `--staged`: review `git diff --cached`
2. If `$ARGUMENTS` contains `--pr <number>`: review the PR diff using `gh pr diff <number>`
3. If `$ARGUMENTS` contains `--last <n>`: review the last n commits using `git log -p -n <n>`
4. If no arguments: review unstaged changes with `git diff`

## Review Checklist

Go through each category and flag issues found:

### Correctness
- [ ] Logic errors or edge cases not handled
- [ ] Race conditions or concurrency bugs
- [ ] Null/undefined handling
- [ ] Error handling completeness

### Security
- [ ] Input validation
- [ ] SQL injection, XSS, or other injection risks
- [ ] Sensitive data exposure (logs, error messages)
- [ ] Authentication/authorization checks

### Performance
- [ ] Unnecessary loops or O(n²) where O(n) possible
- [ ] Memory leaks or excessive allocations
- [ ] Missing caching opportunities
- [ ] N+1 query problems

### Maintainability
- [ ] Naming clarity
- [ ] Function length (should fit on one screen)
- [ ] Code duplication
- [ ] Missing or misleading comments

### Testing
- [ ] New code has tests
- [ ] Edge cases covered
- [ ] Tests are meaningful (not just happy path)

## Output Format

```
## Summary
[One sentence: approve / request changes / needs discussion]

## Issues Found

### 🔴 Critical (must fix)
- [file:line] Description

### 🟡 Suggestions (should fix)
- [file:line] Description

### 🟢 Nitpicks (optional)
- [file:line] Description

## Positive Notes
[What's done well - keep it brief]
```

## Rules

- Be specific: cite file paths and line numbers
- Be actionable: explain *why* and suggest *how* to fix
- Skip categories with no issues
- No sycophantic praise - keep positive notes minimal
