---
name: debug
description: Systematic debugging workflow. Guides through hypothesis generation, isolation, and verification. Use when encountering errors, crashes, or unexpected behavior.
argument-hint: <error-message-or-symptom>
---

# Debug Workflow

Systematic approach to finding and fixing bugs.

## Initial Assessment

1. If `$ARGUMENTS` provided, treat it as the error message or symptom
2. Otherwise, ask user to describe the problem (error message, unexpected behavior, or crash)

## Step 1: Reproduce

- [ ] Can the issue be reproduced reliably?
- [ ] What are the exact steps to trigger it?
- [ ] Is there an error message? Capture it verbatim.

```bash
# Run the failing command or test
<reproduction-command>
```

## Step 2: Isolate

Use binary search and subtraction to find the root cause:

### If code changed recently
```bash
git bisect start
git bisect bad  # current broken state
git bisect good <last-known-working-commit>
```

### If it's in a specific file
- Comment out sections until the error disappears
- Check recent changes: `git log --oneline -10 -- <file>`

### If it's a test failure
- Run single test with verbose output
- Add debug prints or use debugger

## Step 3: Hypothesize

Based on symptoms, form 2-3 hypotheses ranked by likelihood:

| # | Hypothesis | Test | Result |
|---|------------|------|--------|
| 1 | ... | ... | ... |
| 2 | ... | ... | ... |
| 3 | ... | ... | ... |

## Step 4: Verify

For each hypothesis, design a minimal test:

1. Make a small change that would prove/disprove the hypothesis
2. Run and observe result
3. Update hypothesis table

Continue until root cause is confirmed.

## Step 5: Fix

Once root cause is known:

1. Make the minimal fix (don't refactor while debugging)
2. Add a test that would have caught this bug
3. Verify the fix doesn't break anything else
4. Run full test suite

## Common Debugging Commands

```bash
# Logs and errors
rtk log <file>              # Token-optimized log reading
rtk err <cmd>               # Run cmd, show only errors

# Process inspection
ps aux | grep <process>
lsof -i :<port>
strace -f <command>

# Network
curl -v <url>
netstat -tlnp

# Git investigation
git log --oneline -10
git diff HEAD~1
git blame <file>
```

## Output Format

```
## Problem
[One sentence description]

## Root Cause
[What's actually wrong]

## Fix
[What needs to change - be specific]

## Prevention
[Test or check to prevent regression]
```

## Rules

- Don't guess - form hypotheses and test them
- Change one thing at a time
- Keep notes of what you tried
- When stuck, explain the problem out loud (rubber duck)
