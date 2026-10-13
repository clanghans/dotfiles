/**
 * Ponytail - Think like the laziest senior dev
 *
 * "The best code is the code you never wrote."
 *
 * This extension modifies Pi's behavior to:
 * - Question if code is even needed
 * - Prefer deletion over addition
 * - Suggest simpler alternatives
 * - Avoid over-engineering
 */

import type { ExtensionAPI } from "@earendil-works/pi-coding-agent";

// State file path
const PONYTAIL_FLAG = process.env.HOME + "/.pi/agent/.ponytail-active";

type PonytailMode = "off" | "full" | "questions" | "review";

let currentMode: PonytailMode = "off";

const PONYTAIL_GUIDELINES = {
	full: `
You are in Ponytail mode - think like the laziest senior developer.

## Core Principles

1. **The best code is no code** - Can this be solved without writing anything?
2. **Delete first** - Is there existing code we can remove instead?
3. **YAGNI** - You Ain't Gonna Need It. Don't build for imaginary futures.
4. **Boring is good** - Prefer standard solutions over clever ones.
5. **Questions over assumptions** - When in doubt, ask.

## Before Writing Code

- Is there already a library that does this?
- Can we configure existing code instead?
- Is this solving a real problem or a hypothetical one?
- What's the minimum viable solution?
- Can we delete something instead?

## During Code Review

- Does this need to exist?
- Is it too abstract? Too generic?
- Are there fewer lines after than before?
- Would a junior understand it in 6 months?

When suggesting changes, always ask: "Is this the simplest thing that could possibly work?"
`,
	questions: `
You are in Ponytail Questions mode.

Before implementing anything, ask:
1. Is this actually needed?
2. What's the simplest solution?
3. Can existing code be reused/removed instead?
4. What happens if we don't do this?

Challenge assumptions. Make the human justify the complexity.
`,
	review: `
You are in Ponytail Review mode.

Review all code with these questions:
- Does this need to exist?
- Is there more code after this change? (Bad)
- Is it solving a real problem?
- Is it the simplest possible solution?

Suggest deletions over additions. Challenge abstractions.
`,
};

export default function (pi: ExtensionAPI) {
	// Register ponytail command
	pi.registerCommand("ponytail", {
		description: "Toggle ponytail mode (lazy senior dev thinking)",
		handler: async (arg, ctx) => {
			const mode = arg as PonytailMode | undefined;

			if (mode && ["off", "full", "questions", "review"].includes(mode)) {
				currentMode = mode;
			} else {
				// Cycle through modes
				const modes: PonytailMode[] = ["off", "full", "questions", "review"];
				const idx = modes.indexOf(currentMode);
				currentMode = modes[(idx + 1) % modes.length];
			}

			// Persist state
			const fs = await import("fs");
			if (currentMode !== "off") {
				fs.writeFileSync(PONYTAIL_FLAG, currentMode);
			} else {
				fs.unlinkSync(PONYTAIL_FLAG);
			}

			ctx.ui.notify(`Ponytail: ${currentMode.toUpperCase()}`, "info");
		},
	});

	// Load persisted state on session start
	pi.on("session_start", async () => {
		try {
			const fs = await import("fs");
			if (fs.existsSync(PONYTAIL_FLAG)) {
				currentMode = fs.readFileSync(PONYTAIL_FLAG, "utf-8").trim() as PonytailMode;
			}
		} catch {
			// Ignore
		}
	});

	// Inject ponytail guidelines into system prompt
	pi.on("before_agent_start", async (event, _ctx) => {
		if (currentMode === "off" || !PONYTAIL_GUIDELINES[currentMode]) return;

		const guidelines = PONYTAIL_GUIDELINES[currentMode];

		// Append to guidelines section
		if (!event.systemPromptOptions) {
			event.systemPromptOptions = {};
		}
		if (!event.systemPromptOptions.guidelines) {
			event.systemPromptOptions.guidelines = [];
		}

		event.systemPromptOptions.guidelines.push({
			text: guidelines,
			priority: 100, // High priority
		});
	});
}
