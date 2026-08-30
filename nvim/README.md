# Neovim

This is a LazyVim-based configuration. Language ecosystems are enabled in
`lazyvim.json`; shared overrides live in `lua/plugins/`.

## Supported ecosystems

The selected LazyVim extras cover JavaScript/TypeScript, Vue, Svelte, Tailwind,
Python, Go, Rust, C#/.NET, Lua, SQL/Prisma, HTML/CSS, Markdown, JSON, YAML
(including GitHub Actions), TOML, CMake, Docker, Helm, Terraform and Ansible.
Each extra owns its language server, debugger and test adapter; Mason installs
editor-managed binaries and Conform owns formatting. Check `:LspInfo`,
`:Mason` and `:ConformInfo` before diagnosing a project-specific failure.

### Helm and Kubernetes

The Helm extra and `qvalentin/helm-ls.nvim` are loaded only when a Helm buffer
is opened. `helm_ls` is the single Helm-specific language server for templates
and `values*.yaml` files; a `yaml.helm-values` buffer may additionally attach
`yamlls` for ordinary YAML structure. `helm_ls` supplies completion, hover,
go-to-definition and references. `K`, `gd` and `gr` therefore work on Helm expressions and chart
values as they do in code. Helm template actions are highlighted, and the
current `indent`/`nindent` effect is shown as a line-local hint.

When helm-ls can resolve a chart and its values, template expressions may show
their current value as virtual text/concealed rendering. This is an
experimental preview, not a full Helm render: it depends on a discoverable
`Chart.yaml`, valid chart values and an installed `helm_ls` binary, and it does
not evaluate runtime secrets, cluster lookups or arbitrary functions. Use an
explicit project task (`helm template`, usually through Overseer) for the
authoritative manifest. `conceallevel=2` is enabled for Helm template buffers;
Jinja YAML remains excluded from Helm detection. These LSP features depend on a
discoverable `Chart.yaml` root, the installed `helm_ls` binary and the Helm
Tree-sitter parser.

The `mini-hipatterns` extra restores inline previews for hex colors and
Tailwind utility colors in supported source files. It is event-loaded and
does not add work to an empty Neovim startup.

## Core keymaps

`<leader>` is `<Space>`. The complete cross-tool reference lives in
[`docs/CHEATSHEET.md`](../docs/CHEATSHEET.md); these are the mappings used most
often while coding:

| Action | Mapping |
| --- | --- |
| Find files / grep project | `<leader><leader>` / `<leader>/` |
| Current-buffer lines | `<leader>sb` |
| Definition / references / implementation | `gd` / `gr` / `gI` |
| Hover / signature help | `K` / `gK` |
| Quick fix / rename / format | `<leader>ca` / `<leader>cr` / `<leader>cf` |
| Next/previous diagnostic | `]d` / `[d` |
| Explorer (Git/project root) | `<leader>fe` / `<leader>e` |
| Explorer (current working directory) | `<leader>E` / `<leader>fE` |
| Next/previous buffer | `Tab` / `Shift+Tab` |
| Save / quit all | `<leader>w` / `<leader>qq` |
| Window navigation | `Ctrl+h/j/k/l` |
| Terminal | `Ctrl+/` |
| Git status / compact status | `<leader>gg` / `<leader>gs` |
| Run task / nearest test | `<leader>oo` / `<leader>tr` |

Terminal motion animations (`neoscroll.nvim` and `smear-cursor.nvim`) activate
automatically after the first normal local TUI file buffer. Neoscroll is the
only smooth-scroll owner; Snacks' scroll animation is disabled to avoid
competing viewport updates. Neoscroll smooths
the standard viewport mappings (`<C-u>`, `<C-d>`, `<C-b>`, `<C-f>`, `<C-y>`,
`<C-e>`, `zt`, `zz`, `zb`) without replacing arrow or `j`/`k` navigation.
Smear Cursor is disabled for Neovide, SSH, special buffers and files larger
than 1 MiB; it is also suspended in Visual/Select mode to keep rapid `V` +
`j`/`k` movement responsive, then re-enabled when returning to Normal/Insert
mode or an eligible file. Use `:SmearCursorToggle` for a manual temporary
toggle.

## Git workflow

| Mapping | Action |
| --- | --- |
| `<leader>gg` | Open Neogit status |
| `<leader>gs` | Open compact Neogit status in a right split (width 42) |
| `<leader>gc` | Commit staged changes |
| `<leader>gl` | Open commit log and graph |
| `<leader>gb` | Branch actions |
| `<leader>gt` | Tag actions |
| `<leader>gr` | Rebase actions |
| `<leader>gd` | Review working-tree changes in Diffview |
| `<leader>gD` | Compare with the previous commit |
| `<leader>gh` | Current file history |
| `<leader>gH` | Repository history |
| `<leader>gm` | Open the merge/conflict view |
| `<leader>ghs` | Stage hunk, or selected lines in Visual mode |
| `<leader>ghr` | Reset hunk, or selected lines in Visual mode |
| `<leader>ghu` | Toggle hunk stage |
| `<leader>ghp` | Preview hunk inline |
| `<leader>ghb` | Blame current line |
| `<leader>gB` | Toggle inline blame |

In Neogit, press `?` to see actions for the current view. The rebase editor
uses `p/r/e/s/f/d` for pick, reword, edit, squash, fixup and drop.

The Snacks Explorer remains on the left. `<leader>fe` (and its `<leader>e`
remap) always opens it at the repository Git root, even when the active file is
inside a monorepo application such as `apps/sublease`; `<leader>fE` and
`<leader>E` deliberately retain current-working-directory behavior. Reopening
the root mapping therefore does not follow an LSP or test subproject root.
The SQL extra's DBUI opens on the
right; from an editor buffer, use `Ctrl+L` to enter it and `Ctrl+H` to leave it.
DBUI's `Ctrl+J`/`Ctrl+K` are restored to window navigation, while its sibling
navigation remains available through the view's own mappings.

`<leader>gg` opens the full-tab Git status; `<leader>gs` opens the compact
right-side status. In the status view, `c` opens Neogit's commit popup, but the
commit message editor is a separate window, so the workflow cannot be completed
entirely in the status pane.

During a merge or rebase, `<leader>gm` opens Diffview's three-column merge
tool. Use `]x`/`[x` to move between conflicts and `2do`/`3do` to obtain the
current hunk from ours/theirs. Press `g?` for the complete local mapping list.

## Tool ownership

- LazyVim language extras: LSP servers, debuggers and test adapters.
- Mason: installation of editor-owned external binaries.
- Conform: formatting, with LSP used only as fallback.
- nvim-lint: CLI linters that are not already provided by an LSP.
- Treesitter: syntax parsers.

This separation is intentional: do not configure a second TypeScript, Go,
Rust or C# client in a custom plugin file.

## IDE workflow

The expensive IDE features below are command-, mapping- or filetype-loaded.
They do not run external processes during an empty Neovim startup.

The intended development loop is:

```text
plan/spec (Markdown, issue or task)
  -> code and refactor
  -> infrastructure and services
  -> tests and coverage
  -> debug/profile
  -> deploy/CI
  -> Git review, MR, blame, history and conflict resolution
```

Neovim owns the editor lifecycle and local task UI; project files remain the
source of truth for build, test, deployment and CI commands.

### Tasks and project metadata

Overseer is the task runner. It discovers its built-in templates and project
tasks, including `.vscode/tasks.json`.

| Mapping | Action |
| --- | --- |
| `<leader>oo` | Select and run a task |
| `<leader>or` | Restart the most recent task |
| `<leader>ot` | Select an action for an existing task |
| `<leader>ow` | Toggle the task list |

`nvim-dap` reads `.vscode/launch.json` on demand when a debug configuration is
requested. Overseer's DAP integration resolves `preLaunchTask` and
`postDebugTask`; no project-local Lua file is executed. Declarative per-project
LSP overrides belong in `.neoconf.json`.

For Docker Compose, Helm, Kubernetes, Ansible, Terraform and monitoring, keep
commands in project task definitions (`.vscode/tasks.json`, Make targets or a
project task runner). Inspect the command and environment in the task form
before running it; long-running services stay in an Overseer terminal and can
be restarted with `<leader>or`.

### Tests and coverage

Neotest remains the single test UI. Python, Go and .NET adapters come from
their LazyVim language extras. JavaScript and TypeScript projects use exactly
one adapter: the nearest `jest.config.*`, `vitest.config.*` or `package.json`
marker selects Jest or Vitest. An explicit config wins over a package marker;
Vitest is the deterministic fallback when both runners are declared at the
same level. Create React App's `react-scripts` and a top-level `jest` object
are also recognized as Jest markers.

| Mapping | Action |
| --- | --- |
| `<leader>tr` | Run the nearest test |
| `<leader>tt` | Run the current test file |
| `<leader>tT` | Run all tests |
| `<leader>tl` | Repeat the last test |
| `<leader>td` | Debug the nearest test |
| `<leader>ts` | Toggle the test tree |
| `<leader>to` | Open output for the nearest test |
| `<leader>tw` | Toggle watch mode for the current file |
| `<leader>tc` | Load and display the project's coverage report |
| `<leader>tC` | Show the coverage summary |

Coverage display is deliberately separate from test execution. Generate a
supported report with the project task or test runner, then use the coverage
mappings to inspect it.

### Debugging and refactoring

Breakpoints are stored under Neovim's state directory and restored when their
buffer is opened. The normal LazyVim DAP controls remain available.

| Mapping | Action |
| --- | --- |
| `<leader>db` | Toggle a persistent breakpoint |
| `<leader>dB` | Set a persistent conditional breakpoint |
| `<leader>dL` | Set a persistent log point |
| `<leader>dX` | Clear all persistent breakpoints |
| `<leader>dc` | Start or continue debugging |
| `<leader>di` / `<leader>dO` / `<leader>do` | Step into / over / out |
| `<leader>du` | Toggle the debugger UI |
| `<leader>de` | Evaluate under the cursor or selection |
| `<leader>dt` | Terminate the debug session |
| `<leader>rs` | Select a supported refactoring |
| `<leader>ri` / `<leader>rI` | Inline a variable / function |
| `<leader>rf` / `<leader>rF` | Extract a function locally / to a file |
| `<leader>rx` | Extract a variable |

### HTTP and REST

Kulala owns `.http` and `.rest` files. Its backend and parser are prepared only
on first use; the `tree-sitter` CLI is Mason-managed.

| Mapping | Action |
| --- | --- |
| `<leader>Rb` | Open a REST scratchpad from any buffer |
| `<leader>Rs` | Send the request under the cursor or selection |
| `<leader>Ra` | Send all requests in the file |
| `<leader>Rc` | Copy the request as cURL |
| `<leader>Re` | Select an environment |
| `<leader>Ri` | Inspect the resolved request |
| `<leader>Rn` / `<leader>Rp` | Move to the next / previous request |
| `<leader>Rr` | Replay the previous request |
| `<leader>Rt` | Toggle response body and headers |

### Deploy, CI and infrastructure

There is intentionally no implicit deploy command. Add reviewable project
tasks for container builds, Helm/Kubernetes changes, Ansible, migrations and
GitHub/GitLab CI checks, then run them through `<leader>oo`. Keep production
contexts and credentials outside the repository and require explicit
confirmation before a task mutates a cluster, database or remote environment.

### Diagnostics and formatting

YAML files containing Jinja control blocks (`{% if %}`, `{% for %}`, `{% endif %}`
and related tags) are detected from their contents, not their filename, and use
the `yaml.jinja` filetype. This prevents `helm_ls` and `yamlls` from reporting
false YAML errors against the unrendered template. The filetype uses the normal
YAML syntax base plus a small Jinja overlay for `{% ... %}`, `{{ ... }}` and
`{# ... #}` blocks; it deliberately does not register the standalone Jinja
Tree-sitter parser, because that parser would replace (rather than combine with)
YAML parsing. Render the template with the project's normal Jinja2/`envsubst`
task before running YAML or Helm validation. Ordinary YAML and Helm files keep
their existing language servers and formatters.

- SQL completion remains owned by the SQL omnifunc and LazyVim Dadbod/Blink;
  Neovim's packaged SQL omni mappings are disabled so insert-mode arrow keys
  retain native cursor movement.

- GitHub Actions workflows use the `yaml.ghaction` filetype, the existing
  `yamlls` client and SchemaStore, `actionlint`, Treesitter YAML and the same
  Conform formatting chain as YAML.
- Shell scripts use `bashls` plus ShellCheck for `bash` and `sh`; Zsh is not
  sent to tools that do not understand its syntax.
- Python uses the LazyVim Python extra: Pyright, Ruff, neotest-python,
  nvim-dap-python and virtual-environment selection.
- Prettierd is preferred only when the project has a Prettier config (including
  a `prettier` key in `package.json`). Prettier is the next formatter and LSP
  formatting is the final fallback, so competing formatters never both edit a
  buffer.

Trouble uses `<leader>qb` for current-buffer diagnostics and `<leader>cL` for
the LSP definitions/references view. This leaves `<leader>qd` to session
persistence and the standard `<leader>cl` to LSP information.

`Lazydocker` is a lightweight command backed by a Snacks terminal window. It
checks that the executable exists and starts it only when invoked (`<leader>ld`).
Posting remains available as a standalone external CLI when installed.

## Startup contract

New IDE integrations must stay lazy by command, mapping or narrow filetype.
Avoid broad `BufReadPre` hooks for task, REST, coverage and refactoring tools.
Use `:Lazy profile` to audit regressions; an empty startup should leave
Telescope, Overseer, Neotest, DAP, Kulala, refactoring and coverage unloaded.
Bufferline remains visible for every normal file/tool buffer, including a
single-buffer project; only the Snacks dashboard hides the tabline.

## Sessions

LazyVim's `persistence.nvim` is the only session owner. A plain interactive
`nvim` started without file arguments from a project (including a Git
subdirectory) now normalizes to the containing Git root and restores that
root's session and branch automatically. Non-Git projects use direct project
markers only (package/workspace manifests, language/build files, Docker/Helm/
Kubernetes/Terraform/Ansible files and .NET solution/project files). Sessions
are saved from `VimLeavePre`,
so both `:qa` and `:wqa` persist the active layout before exit.

Automatic restore is skipped for explicit file arguments, stdin, `--headless`,
`-c`/`-S` startup commands, `--clean`, Git commit/rebase editor processes,
directories without a recognizable project marker. This keeps editor launches
from Git, scripts and CI deterministic.

The session contains named file buffers, tab pages, window layout, working
directory, cursor/view state and folds. Transient terminal, DBUI, Neogit,
Overseer and running DAP processes are not portable session state and may need
to be recreated manually.

| Mapping | Action |
| --- | --- |
| `<leader>qs` | Restore the current directory's session |
| `<leader>qS` | Select a saved session |
| `<leader>ql` | Restore the last session |
| `<leader>qd` | Do not save the current session |

Recommended daily flow:

1. `cd` to the project root and run `nvim` with no file arguments.
2. Continue in the restored tabs and buffers.
3. Use `:wqa` (or `<leader>qq`) to save files and leave; the layout is saved
   automatically.
4. Use `<leader>qd` before leaving a temporary layout that must not replace the
   previous project session.

If a project does not restore, verify the same project root/branch was used and
that at least one named file buffer was open when the session was saved.
Starting in a Git monorepo subdirectory automatically changes to the containing
Git root before restore, so the same root snapshot is used. `<leader>qS` can
still select another snapshot. Non-Git projects must be started from the
directory containing their direct marker.

## Performance contract and non-obvious behavior

- Heavy task, test, DAP, REST, coverage, refactor and external-TUI plugins load
  only from their command, mapping or narrow filetype.
- Empty startup must keep Telescope, Overseer, Neotest, DAP, Kulala,
  refactoring, coverage and persistent breakpoints unloaded. Use `:Lazy profile`
  after plugin changes.
- Conform owns formatting; LSP formatting is a fallback. Prettier runs only
  when a project config is present.
- SQL omnifunc arrow mappings are disabled so cursor keys never invoke SQL
  calculator completion.
- JavaScript tests use one Jest/Vitest adapter selected from the nearest project
  markers; both adapters must not claim one file.
- Coverage only displays an existing report. Generation belongs to an explicit
  project task and never runs from a buffer event.

## Troubleshooting and honest gaps

- `:LspInfo` and `:Mason` show whether a server or binary is actually present.
- For monorepos, put correct project roots in `.neoconf.json` or language tool
  configuration; the editor does not guess conflicting TypeScript roots.
- If formatting does nothing, check project config and `:ConformInfo`.
- If tests are misdetected, inspect the nearest Jest/Vitest marker and
  `lua/util/js_test_runner.lua`.
- DAP requires a launch profile or language-extra adapter; use project tasks for
  build/pre-launch steps.
- Browser E2E adapters, profiler integrations, remote/devcontainer debugging,
  safe database connection profiles and deployment task catalogs remain
  project-level roadmap items rather than hidden global behavior.
