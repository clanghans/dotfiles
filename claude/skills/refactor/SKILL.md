---
name: refactor
description: Plan and execute safe refactoring with tests as anchors. Identifies dependencies, suggests test coverage, and performs incremental changes. Use when restructuring code without changing behavior.
argument-hint: <target-function-or-module>
---

# Safe Refactoring

Plan and execute refactoring with test coverage as the safety net.

## Prerequisites

1. Identify target: `$ARGUMENTS` should specify the function, class, or module to refactor
2. Verify tests exist: `pytest --collect-only -q` or equivalent
3. If no tests: offer to create them first (refactoring without tests is risky)

## Step 1: Understand Current State

```bash
# Find all usages of the target
rg "<target-name>" --type py  # or --type js, etc.

# Show the target definition
rg -A 20 "def <target-name>|class <target-name>"

# Check test coverage
pytest --cov=<module> --cov-report=term-missing  # Python
# or: npm test -- --coverage  # JavaScript
```

Document:
- What the target does (one sentence)
- Where it's defined
- Where it's called from (callers)
- What it calls (dependencies)

## Step 2: Define Refactoring Goal

Ask user to clarify the goal:
- Extract to separate module?
- Simplify logic?
- Rename for clarity?
- Split into smaller functions?
- Change signature?

## Step 3: Create Test Safety Net

Before any changes:

```bash
# Run existing tests to establish baseline
pytest tests/ -v 2>&1 | tee .refactor-baseline.txt
```

If coverage is weak:
1. Suggest critical test cases to add
2. Wait for user confirmation before adding tests
3. Run tests again to confirm they pass

## Step 4: Plan the Refactor

Create a checklist of changes:

```markdown
## Refactor Plan: <target>

### Phase 1: Preparation
- [ ] Add missing tests
- [ ] Run full test suite (baseline)

### Phase 2: Extraction/Restructuring
- [ ] Create new structure
- [ ] Copy logic (don't delete original yet)
- [ ] Add imports/exports

### Phase 3: Migration
- [ ] Update one caller at a time
- [ ] Run tests after each change
- [ ] Remove old code

### Phase 4: Cleanup
- [ ] Remove dead code
- [ ] Update documentation
- [ ] Run full test suite
```

## Step 5: Execute Incrementally

For each change:
1. Make the smallest possible edit
2. Run tests immediately
3. If tests fail: revert and debug
4. If tests pass: commit with message `refactor: <description>`

```bash
# After each change
pytest tests/ -x -q && git add -A && git commit -m "refactor: step N - <description>"
```

## Step 6: Verify

After all changes:

```bash
# Run full test suite
pytest tests/ -v

# Check for regressions
pytest --cov=<module> --cov-report=term-missing

# Static analysis
mypy <module>  # or: tsc, ruff check
```

## Refactoring Patterns

### Extract Function
- Name the new function before creating it
- Pass all dependencies as parameters
- Return a value, don't mutate external state

### Rename
- Update all usages in one commit
- Use IDE refactoring or `sed` for batch rename
- Update tests and docs in same commit

### Move to Module
- Check import cycles
- Update all import statements
- Consider re-exporting from original location for backward compatibility

### Split Function
- Identify distinct responsibilities
- Keep one function as the orchestrator
- Each sub-function should be testable independently

## Output Format

```
## Refactor: <target>

### Changes Made
1. <change 1>
2. <change 2>

### Tests
- Baseline: X passing
- After refactor: X passing
- Coverage: Y% → Z%

### Commits
- <commit-hash> refactor: step 1
- <commit-hash> refactor: step 2
```

## Rules

- Never refactor without tests
- One logical change per commit
- Keep the diff readable
- Don't mix refactoring with feature changes
