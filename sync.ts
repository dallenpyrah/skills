#!/usr/bin/env bun
/**
 * devbox sync — installs tools and applies dotfiles.
 *
 * Scope:
 *  - systems: brew, gh, bun
 *  - tools:   claude, codex, shelf, parallel-cli, uvx, ast-grep
 *  - dotfiles: shell, git, claude (+skills, +commands, +MCP), codex (+skills), ghostty
 *
 * MCP servers are declarative:
 *  - claude/mcp-servers.json is merged into ~/.claude.json (top-level mcpServers)
 *  - codex/config.toml ships mcp_servers.* inline; sync copies the whole file
 *
 * Usage:
 *   devbox-sync                  # all steps
 *   devbox-sync --fast           # skip systems + tools (dotfiles only)
 *   devbox-sync --skip-systems   # skip any step by name
 */

import { Effect, Console, Cause } from "effect";
import * as fs from "node:fs";
import { homedir } from "node:os";
import { dirname, join } from "node:path";

const HOME = homedir();
const DOTFILES = import.meta.dir;

// ─── primitives ──────────────────────────────────────────────────────────

const has = (cmd: string): Effect.Effect<boolean> =>
  Effect.sync(() => Bun.which(cmd) !== null);

const exec = (
  cmd: string,
  args: ReadonlyArray<string> = [],
  opts: { inherit?: boolean } = {},
): Effect.Effect<void, Error> =>
  Effect.tryPromise({
    try: async () => {
      const proc = Bun.spawn([cmd, ...args], {
        stdout: opts.inherit ? "inherit" : "pipe",
        stderr: opts.inherit ? "inherit" : "pipe",
      });
      await proc.exited;
      if (proc.exitCode !== 0) {
        const err = opts.inherit ? "" : await new Response(proc.stderr).text();
        throw new Error(`${cmd} ${args.join(" ")} → exit ${proc.exitCode}${err ? `\n${err}` : ""}`);
      }
    },
    catch: (e) => (e instanceof Error ? e : new Error(String(e))),
  });

const tryExec = (cmd: string, args: ReadonlyArray<string> = []) =>
  exec(cmd, args).pipe(Effect.catchAll(() => Effect.void));

const sh = (script: string) => exec("/bin/bash", ["-c", script]);
const trySh = (script: string) => tryExec("/bin/bash", ["-c", script]);

const ensureDir = (path: string) =>
  Effect.sync(() => fs.mkdirSync(path, { recursive: true }));

const cp = (src: string, dst: string) =>
  Effect.sync(() => {
    fs.mkdirSync(dirname(dst), { recursive: true });
    fs.copyFileSync(src, dst);
  });

const cpTree = (src: string, dst: string) =>
  Effect.sync(() => {
    if (!fs.existsSync(src)) return;
    fs.mkdirSync(dst, { recursive: true });
    fs.cpSync(src, dst, { recursive: true });
  });

const appendOnce = (line: string, file: string) =>
  Effect.sync(() => {
    const current = fs.existsSync(file) ? fs.readFileSync(file, "utf8") : "";
    if (current.includes(line)) return;
    const sep = current.length === 0 || current.endsWith("\n") ? "" : "\n";
    fs.writeFileSync(file, `${current}${sep}${line}\n`);
  });

const mergeJson = (srcFile: string, dstFile: string, key: string) =>
  Effect.sync(() => {
    const src = JSON.parse(fs.readFileSync(srcFile, "utf8"));
    const dst = fs.existsSync(dstFile)
      ? JSON.parse(fs.readFileSync(dstFile, "utf8"))
      : {};
    dst[key] = src[key];
    fs.writeFileSync(dstFile, JSON.stringify(dst, null, 2) + "\n");
  });

// ─── steps ───────────────────────────────────────────────────────────────

const installSystems = Effect.gen(function* () {
  yield* Console.log("→ systems");

  if (!(yield* has("brew"))) {
    yield* sh(
      '/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"',
    );
  }

  if (!(yield* has("gh"))) yield* exec("brew", ["install", "gh"]);
  if (!(yield* has("bun"))) yield* exec("brew", ["install", "oven-sh/bun/bun"]);

  yield* exec("gh", ["auth", "status"]);
});

const installTools = Effect.gen(function* () {
  yield* Console.log("→ tools");

  if (!(yield* has("claude"))) {
    yield* sh("curl -fsSL https://claude.ai/install.sh | bash");
  } else {
    yield* tryExec("claude", ["update"]);
  }

  if (!(yield* has("codex"))) yield* tryExec("brew", ["install", "--cask", "codex"]);
  if (!(yield* has("shelf"))) yield* tryExec("bun", ["install", "-g", "@rikalabs/shelf"]);
  if (!(yield* has("parallel-cli"))) {
    yield* trySh("curl -fsSL https://parallel.ai/install.sh | bash");
  }
  if (!(yield* has("uvx"))) {
    yield* trySh("curl -LsSf https://astral.sh/uv/install.sh | sh");
  }
  if (!(yield* has("ast-grep"))) yield* tryExec("brew", ["install", "ast-grep"]);
});

const syncDotfiles = Effect.gen(function* () {
  yield* Console.log("→ dotfiles");

  // shell
  yield* appendOnce(`source "${DOTFILES}/shell/shared.zsh"`, join(HOME, ".zshrc"));

  // git
  yield* cp(join(DOTFILES, "git/gitconfig"), join(HOME, ".gitconfig"));

  // claude: settings + AGENTS → CLAUDE.md + skills + commands + MCP merge
  yield* ensureDir(join(HOME, ".claude"));
  yield* cp(join(DOTFILES, "claude/settings.json"), join(HOME, ".claude/settings.json"));
  yield* cp(join(DOTFILES, "AGENTS.md"), join(HOME, ".claude/CLAUDE.md"));
  yield* cpTree(join(DOTFILES, "skills"), join(HOME, ".claude/skills"));
  yield* cpTree(join(DOTFILES, "claude/commands"), join(HOME, ".claude/commands"));
  yield* mergeJson(
    join(DOTFILES, "claude/mcp-servers.json"),
    join(HOME, ".claude.json"),
    "mcpServers",
  );

  // codex: config (MCP servers already inline) + AGENTS + skills
  yield* ensureDir(join(HOME, ".codex"));
  yield* cp(join(DOTFILES, "codex/config.toml"), join(HOME, ".codex/config.toml"));
  yield* cp(join(DOTFILES, "AGENTS.md"), join(HOME, ".codex/AGENTS.md"));
  yield* cpTree(join(DOTFILES, "skills"), join(HOME, ".codex/skills"));

  // ghostty
  yield* cp(join(DOTFILES, "ghostty/config"), join(HOME, ".config/ghostty/config"));
});

// ─── cli ─────────────────────────────────────────────────────────────────

const STEPS = {
  systems: installSystems,
  tools: installTools,
  dotfiles: syncDotfiles,
} as const;

type Step = keyof typeof STEPS;
const ORDER: ReadonlyArray<Step> = ["systems", "tools", "dotfiles"];

const selectSteps = (argv: ReadonlyArray<string>): ReadonlyArray<Step> => {
  const skip = new Set<Step>();
  for (const arg of argv) {
    if (arg === "--fast") {
      skip.add("systems");
      skip.add("tools");
    } else if (arg.startsWith("--skip-")) {
      const name = arg.slice("--skip-".length) as Step;
      if (name in STEPS) skip.add(name);
    }
  }
  return ORDER.filter((s) => !skip.has(s));
};

const main = Effect.gen(function* () {
  const steps = selectSteps(process.argv.slice(2));
  for (const step of steps) yield* STEPS[step];
  yield* Console.log("✓ done");
});

Effect.runPromiseExit(main).then((exit) => {
  if (exit._tag === "Failure") {
    console.error("sync failed:\n" + Cause.pretty(exit.cause));
    process.exit(1);
  }
});
