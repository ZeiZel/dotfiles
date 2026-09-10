#!/usr/bin/env python3
"""Wire tmux-agent-sidebar into Codex without the manual copy-paste flow.

The sidebar's documented Codex setup is interactive: open a Codex pane, toggle
the sidebar, click a badge, copy a snippet and paste it. `setup codex` only
prints the hook definitions on stdout -- it never writes them -- so the merge
into ~/.codex/hooks.json is done here instead.

Both files belong to the user and are edited in place, so existing hooks are
preserved, entries are matched by their command strings to keep the merge
idempotent, and a .bak copy is written before any change. Prints CHANGED or
UNCHANGED for the caller to interpret.
"""

from __future__ import annotations

import json
import os
import re
import shutil
import subprocess
import sys
from pathlib import Path

FEATURE_FLAG = "codex_hooks"
CODEX_DIR = Path(os.environ.get("CODEX_HOME", Path.home() / ".codex"))
CONFIG_PATH = CODEX_DIR / "config.toml"
HOOKS_PATH = CODEX_DIR / "hooks.json"


def backup(path: Path) -> None:
    if path.exists():
        shutil.copy2(path, path.with_suffix(path.suffix + ".bak"))


def ensure_feature_flag() -> bool:
    """Add `codex_hooks = true` under [features]; leave other keys alone."""
    text = CONFIG_PATH.read_text() if CONFIG_PATH.exists() else ""
    if re.search(rf"^\s*{FEATURE_FLAG}\s*=\s*true\s*$", text, re.MULTILINE):
        return False

    if re.search(r"^\[features\]\s*$", text, re.MULTILINE):
        updated = re.sub(
            r"^(\[features\]\s*)$",
            rf"\1\n{FEATURE_FLAG} = true",
            text,
            count=1,
            flags=re.MULTILINE,
        )
    else:
        separator = "" if text.endswith("\n") or not text else "\n"
        updated = f"{text}{separator}\n[features]\n{FEATURE_FLAG} = true\n"

    backup(CONFIG_PATH)
    CODEX_DIR.mkdir(parents=True, exist_ok=True)
    CONFIG_PATH.write_text(updated)
    return True


def commands(entry: dict) -> frozenset:
    return frozenset(
        hook.get("command", "") for hook in entry.get("hooks", []) if isinstance(hook, dict)
    )


def ensure_hooks(binary: str) -> bool:
    """Merge the sidebar's hook definitions into the user's hooks.json."""
    result = subprocess.run(
        [binary, "setup", "codex"], capture_output=True, text=True, check=True
    )
    incoming = json.loads(result.stdout).get("hooks", {})

    if HOOKS_PATH.exists():
        existing_doc = json.loads(HOOKS_PATH.read_text() or "{}")
    else:
        existing_doc = {}
    existing = existing_doc.setdefault("hooks", {})

    changed = False
    for event, entries in incoming.items():
        current = existing.setdefault(event, [])
        present = {commands(entry) for entry in current}
        for entry in entries:
            if commands(entry) not in present:
                current.append(entry)
                changed = True

    if changed:
        backup(HOOKS_PATH)
        CODEX_DIR.mkdir(parents=True, exist_ok=True)
        HOOKS_PATH.write_text(json.dumps(existing_doc, indent=2) + "\n")
    return changed


def main() -> int:
    if len(sys.argv) != 2:
        print("usage: configure-codex-sidebar.py <path-to-tmux-agent-sidebar>", file=sys.stderr)
        return 2
    binary = sys.argv[1]
    if not os.access(binary, os.X_OK):
        print(f"sidebar binary is not executable: {binary}", file=sys.stderr)
        return 1

    changed = ensure_feature_flag()
    changed = ensure_hooks(binary) or changed
    print("CHANGED" if changed else "UNCHANGED")
    return 0


if __name__ == "__main__":
    sys.exit(main())
