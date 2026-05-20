#!/usr/bin/env bun

import { cpSync, existsSync, mkdirSync, readdirSync, rmSync } from "node:fs";
import { homedir } from "node:os";
import { dirname, join, relative } from "node:path";

const ROOT = import.meta.dir;
const HOME = homedir();
const SOURCE = join(ROOT, "skills");
const TARGETS: ReadonlyArray<{ path: string; preserve?: ReadonlySet<string> }> = [
  { path: join(HOME, ".agents", "skills") },
  { path: join(HOME, ".claude", "skills") },
  { path: join(HOME, ".codex", "skills"), preserve: new Set([".system"]) },
];

const shouldCopy = (path: string) => {
  const name = path.split(/[\\/]/).at(-1);
  return name !== ".DS_Store";
};

if (!existsSync(SOURCE)) {
  throw new Error(`Missing canonical skills directory: ${SOURCE}`);
}

const resetTarget = (target: string, preserve = new Set<string>()) => {
  mkdirSync(target, { recursive: true });
  for (const entry of readdirSync(target)) {
    if (preserve.has(entry)) continue;
    rmSync(join(target, entry), { recursive: true, force: true });
  }
};

for (const target of TARGETS) {
  mkdirSync(dirname(target.path), { recursive: true });
  resetTarget(target.path, target.preserve);
  cpSync(SOURCE, target.path, {
    recursive: true,
    filter: shouldCopy,
  });
  const displayTarget = target.path.startsWith(HOME)
    ? `~/${relative(HOME, target.path)}`
    : relative(ROOT, target.path);
  console.log(`copied ${relative(ROOT, SOURCE)} -> ${displayTarget}`);
}
