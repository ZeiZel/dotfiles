---
name: changelog
description: Generate or update CHANGELOG from git history following Keep a Changelog format
allowed-tools: Read, Write, Edit, Bash
---

# Changelog Skill

Generates or updates CHANGELOG.md by analyzing git history, categorizing changes, and following the Keep a Changelog format.

## Usage

```bash
/changelog                           # Generate for unreleased changes
/changelog --since=v1.0.0            # Since specific tag
/changelog --since="2024-01-01"      # Since date
/changelog --version=1.2.0           # Set version number
/changelog --release                 # Prepare for release (set version + date)
```

## Examples

```bash
/changelog
/changelog --since=v1.5.0
/changelog --release --version=2.0.0
/changelog --since="last month"
```

## What It Does

1. **Analyzes Git History**
   - Identifies commits since last tag/date
   - Extracts PR/issue references
   - Detects conventional commit prefixes

2. **Categorizes Changes**
   - Added (new features)
   - Changed (modifications)
   - Deprecated (soon to be removed)
   - Removed (deleted features)
   - Fixed (bug fixes)
   - Security (vulnerability patches)

3. **Generates CHANGELOG**
   - Keep a Changelog format
   - Links to PRs/issues
   - Version comparison links

## Output Format

```markdown
# Changelog

## [Unreleased]

### Added
- New user authentication system (#123)
- API rate limiting (#124)

### Changed
- Improved error messages (#125)

### Fixed
- Memory leak in connection pool (#126)

## [1.1.0] - 2024-01-15

### Added
- Initial feature set

[Unreleased]: https://github.com/org/repo/compare/v1.1.0...HEAD
[1.1.0]: https://github.com/org/repo/releases/tag/v1.1.0
```

## Commit Categorization

| Prefix | Category |
|--------|----------|
| feat: | Added |
| fix: | Fixed |
| docs: | Changed |
| refactor: | Changed |
| perf: | Changed |
| security: | Security |
| deprecate: | Deprecated |
| remove: | Removed |

## Flags

| Flag | Description |
|------|-------------|
| `--since=[tag/date]` | Start point for changes |
| `--version=[X.Y.Z]` | Version number to use |
| `--release` | Prepare for release (date + version) |
| `--dry-run` | Preview without writing |

## Execute

Spawn the changelog-keeper agent:

```
subagent_type: changelog-keeper
prompt: Generate changelog entries [since X / for unreleased]. Analyze git history, categorize changes (Added/Changed/Fixed/etc), and output in Keep a Changelog format. [Set version X.Y.Z if releasing].
```
