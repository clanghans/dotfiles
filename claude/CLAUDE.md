# Claude Code Global Configuration

## Azure DevOps Integration

To access Azure DevOps work items and APIs, you need the following environment variables configured:

```bash
export AZURE_DEVOPS_EXT_USER=<your_username>
export AZURE_DEVOPS_EXT_PAT=<your_personal_access_token>
```

### Example: Fetching a Work Item

Fetch work item details using Azure CLI:

```bash
az boards work-item show --id <WORK_ITEM_ID> --org https://dev.azure.com/bosch-denso-common
```

Replace `<WORK_ITEM_ID>` with the actual work item ID (e.g., `98554`).

### Organization & Project Details

- **Organization:** `bosch-denso-common`
- **Project:** `VRTE-Adaptive`
- **Base API URL:** `https://dev.azure.com/bosch-denso-common/VRTE-Adaptive/_apis/`

### Useful References

- [Azure CLI - Boards Work Item Commands](https://learn.microsoft.com/en-us/cli/azure/boards/work-item)
- [Azure DevOps REST API Documentation](https://learn.microsoft.com/en-us/rest/api/azure/devops/)
- [Work Items API](https://learn.microsoft.com/en-us/rest/api/azure/devops/wit/work-items)

## Language Standards

- **All English**: Code, comments, documentation, commits, configs, errors, tests

## Git Commit Authorship

- **Never mention Claude** in any git commit: no `Co-Authored-By: Claude`, no `Generated with Claude Code`, no AI attribution of any kind
- Commits must appear as authored solely by the human developer

## Git Commit Convention

- **Format**: `<type>(<scope>): <subject>`
- **Types**: feat, fix, docs, style, refactor, test, chore, perf
- **Subject Rules**:
  - Max 50 characters
  - Imperative mood ("add" not "added")
  - No period at the end
- **Commit Structure**:
  - Simple changes: One-line commit only
  - Complex changes: Add body (72-char lines) explaining what/why
  - Reference issues in footer
- **Best Practices**:
  - Keep commits atomic (one logical change)
  - Make them self-explanatory
  - Split different concerns into separate commits

## Tool Preferences

- Search: `rg` instead of `grep`
- Find: `fd` instead of `find`
- Visualization: `tree`

## Tone & Behavior

- **Welcome critical feedback**: Point out mistakes, better approaches, or relevant standards I may have missed
- **Be skeptical**: Question assumptions when reasonable
- **No flattery**: Skip compliments unless specifically asked for judgment
- **Ask questions**: If intent is unclear, ask rather than guess
- Your changes will be reviewed by Codex and Github Copilot, so do your best.

## Python

- **Mocking**: Use `pytest-mock` (`mocker` fixture) over `unittest.mock`. Cleaner syntax, automatic teardown, no context manager nesting.

## Code Style

- **Names**: Complete words, concise while maintaining specificity. Understandable to someone unfamiliar with the codebase
- **Comments**: Add only when necessary:
  - Logic is non-obvious or complex
  - Deviating from standard/obvious approach
  - Important caveats or gotchas (first try eliminating them via code structure or types)
  - Never restate a function or variable name
- **Avoid over-engineering**: Prefer self-documenting code over comments
- **Type system**: Use enums instead of boolean flags with invalid combinations

## Writing Style

These rules apply to **all written output**: chat responses, code comments, documentation, presentations, how-to guides, READMEs, slide decks, and any other prose.

### Punctuation & Structure
- No em dashes. Rewrite with a comma, colon, or parentheses instead.
- No semicolons in prose. Split the sentence.
- No ellipses for dramatic effect or trailing off.
- No clause-stacked mega-sentences. Break them up.

### Banned Words & Phrases
- delve, dive into, explore
- crucial, vital, essential, paramount
- leverage (verb), utilize (use "use")
- groundbreaking, game-changing, revolutionary
- in the realm of, in the world of, in today's X landscape
- it's worth noting that, it's important to note that
- certainly, absolutely, of course
- comprehensive, robust, seamless
- unleash, unlock, harness
- testament to, a true X

### Tone & Voice
- No sycophantic openers ("Great question!", "Certainly!", etc.)
- No unsolicited ethics disclaimers or moralizing.
- Don't summarize what you're about to do. Just do it.
- Don't restate the question before answering.
- Active voice over passive.

### Structure & Formatting
- No filler transitions: "Moving on...", "Now, let's turn to...", "With that in mind..."
- Don't end sections with a summary that repeats the section.
- Headers only for genuinely multi-section content.
- Bullet lists only for genuinely enumerable items, not to avoid writing prose.

### Length
- Match length to complexity. Short answers for simple questions.
- No conclusion paragraph that re-summarizes what was just said.

