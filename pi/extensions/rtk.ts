/**
 * RTK (Rust Token Killer) - Token-optimized command rewriter
 *
 * Rewrites Bash commands to use rtk for 60-90% token savings.
 * Requires: rtk >= 0.23.0
 */

import type { ExtensionAPI } from "@earendil-works/pi-coding-agent";

const RTK_COMMANDS = [
	// Git (59-80% savings)
	"git status",
	"git diff",
	"git log",
	"git show",
	// Files & Search (60-75% savings)
	"ls",
	"cat",
	"head",
	"tail",
	"grep",
	"find",
	// Test (90-99% savings) - shows failures only
	"pytest",
	"cargo test",
	"npm test",
	// Build & Lint (80-90% savings) - shows errors only
	"tsc",
	"lint",
	"mypy",
	"ruff",
	"prettier",
	// Analysis (70-90% savings)
	"docker ps",
	"docker logs",
	"kubectl get",
];

function shouldRewrite(command: string): boolean {
	// Skip if already using rtk
	if (command.startsWith("rtk ")) return false;

	// Check if command matches rtk-able patterns
	for (const rtkCmd of RTK_COMMANDS) {
		if (command.startsWith(rtkCmd + " ") || command === rtkCmd) {
			return true;
		}
	}

	return false;
}

function rewriteCommand(command: string): string {
	return `rtk ${command}`;
}

export default function (pi: ExtensionAPI) {
	// Check rtk availability on load
	let rtkAvailable = false;

	pi.on("session_start", async () => {
		// Check if rtk is installed
		try {
			const { spawnSync } = await import("child_process");
			const result = spawnSync("rtk", ["--version"], {
				encoding: "utf-8",
				timeout: 5000,
			});
			rtkAvailable = result.status === 0;

			if (!rtkAvailable) {
				pi.notify("rtk not found - install from https://github.com/rtk-ai/rtk", "warning");
			}
		} catch {
			rtkAvailable = false;
		}
	});

	pi.on("tool_call", async (event, _ctx) => {
		if (event.toolName !== "bash" || !rtkAvailable) return;

		const input = event.input as { command?: string };
		if (!input?.command) return;

		if (shouldRewrite(input.command)) {
			const rewritten = rewriteCommand(input.command);
			pi.notify(`rtk: ${input.command} → ${rewritten}`, "info");
			return {
				input: { ...input, command: rewritten },
			};
		}

		return undefined;
	});
}
