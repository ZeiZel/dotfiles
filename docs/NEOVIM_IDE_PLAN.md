# План терминальной IDE на базе Neovim

<!-- markdownlint-disable MD013 -->

## Назначение

Цель проекта — получить быстрый terminal-first аналог полного цикла
GoLand/RustRover/PyCharm/WebStorm/Rider:

```text
поиск → навигация → изменение → refactor → format/lint
      → build/test/debug/coverage → review → commit/CI/deploy
```

Neovim остаётся редактором и оркестратором, Herdr — рабочим пространством,
а CLI, LSP, DAP, Neotest, Overseer и Git-инструменты — исполняющим слоем.
Внешние GUI остаются допустимыми там, где терминальный интерфейс объективно
слабее: визуальные дизайнеры, сложные memory profilers, UML/schema designers,
интерактивные таблицы и графики notebooks.

Этот документ описывает целевую архитектуру и порядок интеграции. Фактическими
источниками истины остаются [операционная спецификация](../AGENTS.md),
[Neovim-конфигурация](../nvim/README.md), [Zsh](../zsh/README.md) и
[Herdr](../herdr/README.md).

Исследовательская база сверена с первичными источниками:

- [обзор IntelliJ IDEA](https://www.jetbrains.com/help/idea/discover-intellij-idea.html)
  и [VCS tool window](https://www.jetbrains.com/help/idea/version-control-tool-window.html)
  задают сравниваемый IDE lifecycle;
- [LazyVim extras](https://www.lazyvim.org/extras) и
  [DAP core](https://www.lazyvim.org/extras/dap/core) определяют поддерживаемые
  точки расширения и владельцев language/debug stack;
- [Neogit](https://github.com/NeogitOrg/neogit),
  [Diffview](https://github.com/sindrets/diffview.nvim) и
  [Gitsigns](https://github.com/lewis6991/gitsigns.nvim) подтверждают
  разделение status/operations, history/conflicts и buffer hunks;
- [Overseer](https://github.com/stevearc/overseer.nvim),
  [Neotest](https://github.com/nvim-neotest/neotest) и
  [nvim-dap](https://github.com/mfussenegger/nvim-dap) покрывают
  task–test–debug lifecycle;
- [Kulala](https://neovim.getkulala.net/) и
  [nvim-coverage](https://github.com/andythigpen/nvim-coverage) документируют
  ограничения REST и coverage слоёв.

## Исходное состояние

Базовый срез перед реализацией плана:

- LazyVim уже предоставляет completion, snippets, Treesitter, Snacks picker,
  explorer и terminal, Trouble, persistent sessions, DAP UI и Neotest core.
- TypeScript/JavaScript, Go, Rust и C# подключены официальными LazyVim extras.
- Svelte, Vue, Tailwind, Prisma, Ansible, Docker, Helm, YAML, Terraform, SQL,
  CMake, Markdown, JSON и TOML также выбраны через
  [`lazyvim.json`](../nvim/lazyvim.json).
- Git внутри Neovim разделён между Neogit, Diffview и Gitsigns в
  [`git.lua`](../nvim/lua/plugins/git.lua).
- Python parser установлен, но исходный baseline не содержит полного Python
  extra, Python LSP/test/debug/venv workflow.
- GitHub Actions получает `actionlint`, но отдельный filetype
  `yaml.ghaction` в baseline требует явного подключения YAML LSP и formatter.
- Нет единого владельца project tasks/run configurations, общего coverage UI,
  JS test adapters, сохранённых project debug profiles и IDE-like security
  task layer.
- `persistence.nvim` — единственный владелец sessions. Persistent undo включён,
  но это не полноценная Local History и не защита несохранённого буфера после
  аварии.
- Lazydocker и remote editing имеют command/key triggers; внешний Posting
  остаётся отдельным CLI и не является Neovim launcher. Интеграции зависят от
  внешних бинарников и не должны считаться рабочими только по наличию mapping.

Первый implementation slice поверх baseline уже задаёт архитектурный каркас:

- Python extra и project virtual environment selection;
- GitHub Actions YAML LSP/formatting вместе с actionlint;
- Neoconf и incremental rename;
- command/key-lazy Overseer;
- project-selected Jest/Vitest adapters поверх общего Neotest;
- persistent DAP breakpoints в Neovim state;
- key-lazy refactoring.nvim без глобального `BufReadPre`;
- Kulala для `.http`/`.rest`;
- command/key-lazy coverage viewer;
- разведённые Trouble, persistence и LSP mappings.

Этот срез не означает, что готовы все project task templates, coverage
producers, Playwright/Cypress, remote debug, security scans и advanced .NET
profile. Их критерии остаются в следующих этапах.

## Архитектурные принципы

### Один владелец каждой функции

Каждая операция должна иметь один основной механизм:

- LazyVim extras выбирают языковую экосистему.
- LSP отвечает за semantic navigation, diagnostics и language-aware actions.
- Conform форматирует; LSP formatting используется только как fallback.
- nvim-lint запускает только CLI linters, не дублирующие LSP.
- Neotest отвечает за test tree, nearest/file/suite и test output.
- Overseer отвечает за build/run/task graph и длительные процессы.
- nvim-dap отвечает за debug sessions.
- Coverage viewer только отображает уже сгенерированные отчёты.
- Neogit выполняет Git-операции, Diffview показывает history/diffs/conflicts,
  Gitsigns работает с hunks текущего буфера.
- Snacks остаётся основным picker/explorer/terminal слоем.
- Herdr отвечает за terminal workspace, Lazygit popup и Reviewr.

Нельзя добавлять второй TypeScript, Go, Rust или C# client «для ещё одной
фичи». Новый provider сначала должен заменить старый в изолированном пилоте.

### Lazy loading вместо «асинхронной загрузки Lua»

Загрузка Lua-плагина в момент срабатывания trigger синхронна. Поэтому цель
формулируется точнее:

- не загружать тяжёлый плагин до первого реального использования;
- запускать внешние команды через asynchronous job API;
- не выполнять сеть, package checks, root shell probes и генераторы на
  критическом пути старта;
- не запускать language tooling до открытия подходящего filetype/project;
- не использовать таймер как замену корректному `cmd`, `keys`, `ft` или
  `event` trigger.

Глобальный `defaults.lazy = true` не должен быть единственной гарантией.
Каждый тяжёлый custom spec получает явный trigger. Глобальный режим меняется
только отдельным измеряемым экспериментом после аудита всех specs.

### Project-local инструменты имеют приоритет

Для Node, Python, Go, Rust и .NET сначала используется бинарник или runtime из
проекта, затем editor-managed fallback. Это предотвращает расхождение версий
CI и редактора. Исключения должны быть видны в project settings, а не спрятаны
в глобальном shell startup.

### Никаких скрытых мутаций

Открытие Neovim не должно:

- устанавливать или обновлять плагины и toolchains;
- выполнять Git fetch, Docker/Kubernetes запрос или сетевой CI lint;
- менять project files;
- восстанавливать session без явной команды;
- автоматически применять code action ко всему проекту;
- отправлять source, diagnostics или credentials во внешний сервис.

## Performance contract

### Что измеряется

Для каждого крупного этапа сохраняются before/after:

1. warm no-file startup;
2. подробный `--startuptime`;
3. число загруженных plugins до пользовательского trigger;
4. открытие representative файла по каждому затронутому ecosystem;
5. время до LSP attach и первой диагностики;
6. latency первого вызова тяжёлой поверхности: test, DAP, task, Git, REST,
   database или remote.

Рекомендуемый воспроизводимый baseline:

```bash
hyperfine --warmup 5 --runs 20 \
  'nvim -i NONE --headless +qa'

nvim -i NONE \
  --startuptime /private/tmp/nvim-startuptime.log \
  --headless +qa

nvim -i NONE --headless \
  '+lua print(vim.inspect(require("lazy").stats()))' \
  +qa
```

Representative-file замер выполняется на локальном fixture без package
install и сети. Первый холодный запуск записывается отдельно, но gate
сравнивает медианы в одинаковых условиях.

### Бюджет

Изменение не проходит performance gate, если медиана no-file startup
ухудшилась одновременно:

- более чем на 10 мс;
- более чем на 15% от baseline.

Дополнительные условия:

- ни один новый тяжёлый plugin не загружен до своего trigger;
- no-file startup не запускает внешние процессы и сеть;
- package installation не происходит внутри Neovim startup;
- длительные lint/test/build/security/CI операции не блокируют UI;
- после закрытия task/debug/test surface не остаётся бесконтрольного polling;
- lazy checker не должен выводить startup noise.

Если функциональность не укладывается в бюджет, она переносится в opt-in
profile или остаётся внешним инструментом Herdr.

## Карта возможностей JetBrains

Цель — закрыть рабочий сценарий, а не копировать расположение tool windows.

| Возможность JetBrains | Terminal IDE replacement | Ожидаемый уровень |
| --- | --- | --- |
| Search Everywhere/files/actions | Snacks pickers, command/keymap search | высокий |
| Project symbols/usages/hierarchy | LSP workspace symbols, references, call hierarchy | высокий в пределах качества LSP |
| Inspections/intentions/quick fixes | LSP diagnostics/actions + nvim-lint + explicit repository tasks | высокий для известных toolchains |
| Safe rename/file move | LSP rename и workspace file operations | высокий для одного language, частичный cross-language |
| Extract/inline/change signature | refactoring.nvim + language LSP actions | частичный, зависит от parser/LSP |
| Structural search/replace | ast-grep/project CLI + GrugFar | высокий для поддержанных syntax patterns |
| Run configurations | Overseer templates + project task files | высокий |
| Services/processes | Overseer task list + Herdr panes | высокий без GUI service graph |
| Unit test runner | Neotest + language adapters | высокий |
| Debugger | nvim-dap + DAP UI + project launch profiles | высокий, кроме IDE-specific runtime views |
| Coverage | language report producer + один viewer | высокий после fixture validation |
| Profiler | CLI profiler task + browser/report handoff | частичный |
| Git log/branches/rebase/partial commit | Neogit + Diffview + Gitsigns + Lazygit | высокий |
| Three-way merge conflicts | Diffview и Lazygit conflict views | высокий |
| Shelf/changelists | Git stash, worktrees и explicit WIP flow | частичный |
| Local History/crash recovery | persistent undo, evaluated swap, explicit Git history | частичный |
| GitHub PR/GitLab MR review | Reviewr + `gh`/`glab`; opt-in Octo | высокий для terminal review, частичный inline collaboration |
| HTTP Client | Kulala `.http` collections; optional Posting | высокий |
| Database console/data browser | Dadbod + optional Harlequin | высокий для queries, частичный для schema/data GUI |
| Docker/Kubernetes/Helm | LSP + Overseer tasks + Lazydocker/k9s | высокий |
| CI status/log/lint | local validation + explicit `gh`/`glab` tasks | высокий без постоянного polling |
| Remote/Dev Containers | Herdr/SSH + remote-nvim + opt-in DevPod | частичный относительно Gateway |
| Notebooks/data science | opt-in Quarto/Otter/Molten/Jupyter | частичный |
| AI actions | Herdr Codex/Claude/Hermes; optional editor context bridge | высокий как agent workflow, без native IDE debugger control |
| Rider designers/game editor integration | внешний Rider/Visual Studio/engine editor | внешняя поверхность |

## Матрица владения

| Область | Владелец | Source of truth | Что запрещено дублировать |
| --- | --- | --- | --- |
| Language ecosystems | LazyVim extras | [`lazyvim.json`](../nvim/lazyvim.json) | повторный import extras из `lua/plugins/` |
| Shared LSP policy | nvim-lspconfig override | [`lspconfig.lua`](../nvim/lua/plugins/lspconfig.lua) | language clients, уже созданные extra |
| Editor-owned binaries | Mason | [`mason.lua`](../nvim/lua/plugins/mason.lua) | те же бинарники без причины в Brewfile |
| Formatting | Conform | [`conform.lua`](../nvim/lua/plugins/conform.lua) | параллельный formatter-on-save |
| Extra CLI lint | nvim-lint | [`code.lua`](../nvim/lua/plugins/code.lua) | LSP diagnostics и линтеры extra |
| Syntax | Treesitter | [`syntax.lua`](../nvim/lua/plugins/syntax.lua) | parser install в нескольких files |
| Tasks/run configs | Overseer, целевой | отдельный lazy spec | второй task runner |
| Tests | Neotest | LazyVim test extra + adapters | test execution через несколько UI |
| Debug | nvim-dap | LazyVim DAP extra + language adapters | второй DAP owner |
| Coverage | один viewer, целевой | отдельный command-lazy spec | самостоятельный повторный test runner |
| Git status/actions | Neogit | [`git.lua`](../nvim/lua/plugins/git.lua) | Fugitive как второй status UI |
| Diffs/conflicts/history | Diffview | [`git.lua`](../nvim/lua/plugins/git.lua) | второй merge UI внутри Neovim |
| Buffer hunks | Gitsigns | [`git.lua`](../nvim/lua/plugins/git.lua) | второй gutter/hunk owner |
| Picker/explorer/terminal | Snacks | LazyVim + local overrides | новый основной Telescope/Toggleterm слой |
| Sessions | persistence.nvim | LazyVim util spec | auto-session и другие restorers |
| REST collections | Kulala, целевой | `.http` filetype spec | второй in-editor collection runner |
| Exploratory API TUI | Posting, опционально | external command | хранение `.http` collections |
| SQL editor | Dadbod | LazyVim SQL extra | параллельный in-editor DB client |
| DB exploration | Harlequin, опционально | external command | credentials в dotfiles |
| Host CLI | Homebrew/Ansible | [`Brewfile`](../Brewfile), `roles/` | Mason package без editor use |
| Workspace/review | Herdr/Reviewr | [`herdr/`](../herdr/README.md) | второй terminal multiplexer |
| Lock versions | lazy.nvim | [`lazy-lock.json`](../nvim/lazy-lock.json) | ручные несогласованные SHAs |

## Матрица lazy triggers

| Компонент | Trigger | До trigger |
| --- | --- | --- |
| Colorscheme/core options/keymaps | startup, только лёгкий код | допускается loaded |
| Statusline, notifications, cosmetic UI | `VeryLazy` | не должен задерживать first screen |
| LSP client | matching filetype и root | не стартует process |
| Treesitter parser | matching buffer | не загружает чужие parsers |
| Formatter/linter | format/save/lint event подходящего filetype | не запускает binary |
| Neotest core | test key/command | adapters не сканируют проект |
| Language test adapter | matching filetype после Neotest trigger | не загружен в чужом проекте |
| DAP core/UI | debug key/command | adapters не стартуют |
| Language DAP adapter | первая debug operation подходящего language | process отсутствует |
| Overseer | `:Overseer*` или task mappings | не читает project tasks на startup |
| Refactoring UI | refactor mapping | не использовать глобальный `BufReadPre` |
| Coverage UI | coverage command/mapping | не ищет reports на startup |
| Kulala | `http` filetype или `:Kulala*` | HTTP parser не загружен |
| Dadbod UI | DB command/SQL workflow | не устанавливает connection |
| Octo/PR surface | `:Octo*` | не вызывает `gh` и сеть |
| Remote Nvim | `:Remote*` | не запускает SSH probe |
| Lazydocker | его mapping/command | Toggleterm не загружен |
| Notebook/science | отдельный opt-in profile | полностью отсутствует в base |
| AI/editor context | явная команда | Herdr agents не влияют на startup |

## Языковая матрица

Статус «baseline» относится к исходному состоянию плана; итог каждого этапа
проверяется по фактическому merged Lazy spec, а не по наличию пакета в Mason.

| Экосистема | Baseline | Целевой IDE-цикл | Проверка |
| --- | --- | --- | --- |
| JavaScript/TypeScript | VTSLS, ESLint, Prettier, js-debug; Vue/Svelte/Tailwind/Prisma | Vitest/Jest по root markers, Playwright как task, browser/Node launch profiles, coverage, npm/pnpm/Nx tasks | attach одного TS client; nearest/file/suite test; Node и browser breakpoint |
| Go | gopls, goimports/gofumpt, golangci-lint, Delve, Neotest | build, race, benchmark, fuzz, coverprofile, pprof/trace tasks; module actions | один gopls; test/debug nearest; race/coverage task не блокирует UI |
| Rust | rustaceanvim/rust-analyzer, codelldb, crates, Neotest | cargo check/clippy/test/nextest, llvm-cov, bench, flamegraph/samply tasks | один rust-analyzer; feature-aware project; test/debug/coverage fixture |
| Python | parser без полного lifecycle | Python extra, basedpyright или Pyright как единственный type server, Ruff, venv selector, debugpy, pytest adapter, coverage.py | `.venv` selection; один type LSP + Ruff; nearest test/debug/coverage |
| C#/.NET | OmniSharp, F# LSP, netcoredbg, VSTest | build/run/test profiles, solution-aware assembly resolution, coverage; отдельный пилот Roslyn/easy-dotnet только как замена текущего owner | один C# client; `.sln` fixture; test/debug without repeated DLL prompt |
| Lua | lua_ls, Stylua, Treesitter | project-local diagnostics, Busted/Plenary tasks при необходимости | attach lua_ls; format; repo Lua smoke test |
| HTML/CSS | html/cssls, Emmet, Prettier | Stylelint, accessibility task, browser preview/debug profile | no duplicate formatting; CSS/HTML diagnostics; browser breakpoint |
| Helm/Kubernetes | Helm/YAML tooling и shell CLI | `helm lint/template`, kubeconform, kube-linter, diff/apply preview tasks; schema completion | chart fixture; rendered manifest validation; никаких cluster calls на startup |
| Ansible | Ansible extra и lint tooling | syntax-check, inventory/playbook tasks, Molecule profile, explicit Vault workflow | role/playbook fixture; no secret output; lint and syntax diagnostics |
| Docker/Compose | Docker/Compose LSP, hadolint, Lazydocker entry point | compose config/build/log tasks, BuildKit profile, opt-in devcontainer debugging | Dockerfile/Compose diagnostics; task works without loading at startup |
| GitHub Actions | `actionlint`; baseline filetype gap | YAML schema/LSP/format retained for `yaml.ghaction`, explicit actionlint task | workflow fixture gets schema, completion, format and actionlint |
| GitLab CI | YAML schema baseline | local syntax/schema plus explicit authenticated pipeline/lint/log tasks | no network until command; error becomes task/quickfix item |
| Databases | SQL extra, Dadbod, Prisma; external Harlequin intent | query/EXPLAIN/migration tasks, safe connection profiles, optional external data grid | no credentials in repo/session logs; command-lazy UI; test connection explicit |

Terraform и CMake сохраняются как уже выбранные ecosystems и используют тот же
task contract: language diagnostics на filetype, build/plan только по команде.

## Функциональные профили

### Core editing

Всегда доступно:

- files/buffers/grep/symbols через Snacks;
- Treesitter text objects и syntax;
- completion/snippets;
- persistent undo и ручное session restore;
- diagnostics, quickfix и Trouble;
- formatting и language code actions.

Core не знает о Docker daemon, cluster, database, remote host или CI network.

### Project tasks

Overseer становится единым каталогом:

- project-native scripts из `package.json`, Make, Cargo, Go, dotnet и
  project task files;
- build/run/lint/test/coverage/security/deploy templates;
- dependencies между задачами;
- problem matchers с выводом в quickfix/diagnostics;
- long-running watch/dev/server tasks с явным stop/restart;
- `preLaunchTask` для DAP.

Project-specific tasks хранятся в проекте, если полезны команде. Personal paths
и secrets остаются в local overrides.

### Tests

Neotest предоставляет общий UX nearest/file/suite/watch/output/debug.
Adapters выбираются по root markers:

- Vitest и Jest не должны одновременно claim один JS project;
- pytest выбирается из активного Python environment;
- Go, Rust и VSTest сохраняют владельцев из language extras;
- Playwright/Cypress end-to-end запускаются Overseer tasks, пока adapter не
  доказал стабильность на реальном monorepo.

### Debug

DAP contract:

- общие команды одинаковы для всех языков;
- project profiles читаются из `.vscode/launch.json` или локального
  эквивалента;
- persisted breakpoints хранят только paths/lines/conditions, не secrets;
- adapter process стартует только при debug;
- Node/browser, Delve, codelldb, debugpy и netcoredbg не запускаются вместе;
- remote/container attach требует явного host/port выбора;
- task owner строит artefact до launch.

### Coverage и profiling

Coverage состоит из двух частей:

1. Overseer/Neotest task генерирует нативный report.
2. Один viewer показывает signs, summary и uncovered lines.

Producer определяется языком: lcov для web, coverprofile для Go,
coverage.py для Python, llvm-cov-compatible output для Rust и dotnet coverage
format для .NET. Поддержка конкретного формата подтверждается fixture до
добавления mapping.

Profiling остаётся task-driven:

- Go: pprof и trace;
- Rust: cargo-flamegraph или samply;
- Python: py-spy/Scalene;
- Node: inspector/Chrome DevTools;
- .NET: dotnet-trace, counters и dump.

Neovim открывает отчёт или browser URL, но не имитирует тяжёлый GUI profiler.

### Git, history и conflicts

Сохраняется текущая композиция:

- Gitsigns — stage/reset/preview/blame текущего hunk или Visual selection;
- Neogit — status, commit, branch, tag, log и rebase;
- Diffview — file/repository history, diffs и three-way conflict resolution;
- Lazygit — полноэкранный Herdr popup для широкого graph/rebase/stash flow;
- Reviewr — branch/PR/MR review поверх текущего Herdr tab.

System `git mergetool` обязан указывать на реально provisioned tool без
hard-coded отсутствующего GUI. Внешнее открытие файла из Lazygit должно
переиспользовать текущий Neovim process, только если IPC с Herdr проверен;
иначе безопаснее отдельный `nvim` process.

Persistent undo не называется Local History. Минимальный recovery layer:

- undo files в XDG state;
- оценка swap recovery в закрытом XDG state каталоге;
- Git WIP commit/stash только по явной команде;
- никаких скрытых auto-commits.

### REST и databases

Kulala — целевой owner воспроизводимых `.http` collections, environments,
assertions и team-reviewable requests. Posting остаётся отдельным exploratory
TUI, если его binary provisioned. Они не должны хранить одну и ту же
collection в несовместимых форматах.

Dadbod остаётся SQL surface внутри редактора. Harlequin может быть внешним data
browser. Connection strings, tokens, cookies, query history с персональными
данными и database dumps не коммитятся и не попадают в Herdr pane history.

### DevOps, CI и security

Быстрые file linters остаются diagnostics layer. Репозиторные проверки идут
как explicit tasks:

- Helm/Kubernetes render и validation;
- Ansible syntax/Molecule;
- Docker/Compose validation;
- Terraform fmt/validate/plan;
- actionlint и GitLab CI validation;
- secret scan, dependency audit, SAST и image scan.

Кандидаты вроде gitleaks, osv-scanner, Trivy или Semgrep сначала проверяются на
дублирование с project CI. Полный scan никогда не запускается на каждом save.
Network CI/API actions запускаются только вручную и используют уже настроенный
`gh`/`glab`, не credentials из Neovim config.

### Remote, containers и AI

`remote-nvim` остаётся command-lazy. Remote instance сам владеет своим LSP и
toolchain; локальный Neovim не стартует второй client для удалённого buffer.
DevPod/devcontainer — opt-in profile после проверки root mapping и file
watchers.

Codex, Claude и Hermes остаются Herdr integrations. Editor-side AI допускается
только как command-lazy context/diff bridge без второго multiplexer backend,
автозагрузки и скрытой отправки buffer.

## Этапы интеграции

### Этап 0. Baseline и инварианты

Результат:

- зафиксированы startup measurements и loaded-plugin set;
- сохранён merged Lazy spec;
- проверено, что repository `nvim/` действительно связан с активным
  `~/.config/nvim`;
- составлена карта конфликтующих mappings и дублирующих providers;
- определены representative fixtures для всех ecosystems.

Критерий выхода: baseline воспроизводим, current config проходит JSON/Lua и
headless checks, pre-existing dirty changes сохранены.

### Этап 1. Исправление P0 gaps

Результат:

- полный Python ecosystem через один официальный extra;
- `yaml.ghaction` получает YAML LSP/schema/format вместе с actionlint;
- broken external Git mergetool заменён на provisioned flow;
- Posting/Harlequin/HTTP entry points либо provisioned, либо явно убраны;
- устранены реальные mapping collisions, документация сверена с runtime maps.

Load model: Python по `ft=python`; REST/DB и external TUI только по
command/key; никакой новый startup plugin.

Критерий выхода: clean-machine декларации совпадают с фактическими entry
points, Python и GitHub Actions fixtures работают.

### Этап 2. Tasks и tests

Результат:

- Overseer — единственный task owner;
- templates для Node, Go, Cargo, Python, dotnet и DevOps;
- Neotest adapters для Python и project-selected Jest/Vitest;
- task output связан с quickfix/diagnostics;
- dev/watch tasks имеют stop/restart и не переживают workspace случайно.

Load model: Overseer и Neotest только по mappings/commands, adapter — по
matching ecosystem.

Критерий выхода: build, nearest test, file test и suite test проходят на
fixtures; JS adapter выбирается однозначно.

### Этап 3. Navigation и refactoring

Результат:

- incremental rename и project settings;
- refactoring plugin загружается только mapping-ом;
- structural search/replace использует project CLI;
- outline/hierarchy добавляется только если Trouble/Snacks symbols не закрывают
  реальный сценарий;
- file/module rename проходит через LSP workspace operations.

Не обещаются несуществующие cross-language refactors. Extract/inline/change
signature считаются доступными только для языков и LSP, где fixture доказал
корректность.

Критерий выхода: rename symbol/file, references, call hierarchy, structural
search и минимум один extract refactor проверены без eager load.

### Этап 4. Debug, coverage и profiling

Результат:

- project launch profiles и `preLaunchTask`;
- persisted breakpoints;
- Node/browser, Go, Rust, Python и .NET debug fixtures;
- единый coverage viewer с language producers;
- explicit profiler tasks и browser/report handoff.

Критерий выхода: break/step/eval/restart/terminate, test debug и coverage
работают в representative projects; adapters отсутствуют до trigger.

### Этап 5. Git и review lifecycle

Результат:

- Neogit/Diffview/Gitsigns mappings без пересечений;
- three-way merge и rebase conflict fixtures;
- Lazygit `e` открывает правильный editor flow;
- Reviewr, `gh` и `glab` покрывают branch/PR/MR review;
- GitHub-only Octo добавляется command-lazy только при доказанном UX gap;
- GitLab plugin не добавляется поверх Reviewr без отдельного решения.

Критерий выхода: partial line commit, amend/fixup/rebase, cherry-pick,
branch/tag, file history, repo history и ours/theirs/both conflict resolution
воспроизводимы.

### Этап 6. REST, DB, DevOps, CI, security и remote

Результат:

- `.http` collections через Kulala;
- Dadbod + optional external Harlequin с безопасными connection profiles;
- explicit validation/deploy/security task catalog;
- remote/devcontainer profile;
- network и privileged operations имеют явное действие пользователя.

Критерий выхода: никакой secret или network call не появляется на startup,
save или session restore; ошибки tool output переходят в навигабельную форму.

### Этап 7. Opt-in heavy profiles

Отдельно оцениваются:

- Roslyn/easy-dotnet как замена, а не дополнение OmniSharp stack;
- Quarto/Otter/Molten/Jupyter;
- richer browser/Playwright integration;
- AI context bridge;
- advanced profiler viewers.

Каждый profile имеет отдельный performance baseline и может быть полностью
выключен без изменения core.

### Этап 8. Hardening и handoff

Результат:

- lockfile согласован;
- docs содержат только реальные mappings;
- startup before/after опубликован в отчёте задачи;
- clean headless start не выдаёт ошибок;
- host application остаётся отдельным явным шагом;
- оставшиеся gaps оформлены как Beads issues, а не скрыты в комментариях.

## Проверка готовности

### Статические gates

```bash
jq empty nvim/lazyvim.json nvim/lazy-lock.json
stylua --check nvim/lua/config nvim/lua/plugins
nvim -i NONE --headless '+qa'
git diff --check
git status --short
```

Проверки Ansible/Brewfile выполняются только если этап меняет provisioning.
`brew bundle install` не является validation command.

### Runtime gates

Для каждого language fixture:

1. открыть файл;
2. убедиться, что attach произошёл ровно у ожидаемых clients;
3. выполнить definition, references, rename, code action и format;
4. запустить lint/test/debug;
5. для поддерживаемого языка сгенерировать и открыть coverage;
6. закрыть buffer и убедиться в отсутствии runaway processes;
7. сравнить startup и first-trigger latency с baseline.

Для Git fixture:

1. stage целый файл, hunk и Visual lines;
2. commit/amend/fixup/rebase;
3. file и repository history;
4. synthetic diff3 conflict;
5. продолжение/отмена merge и rebase;
6. открытие файла из Lazygit в editor.

Для security/remote/CI:

- без команды нет сети;
- cancellation действительно завершает job;
- credentials не выводятся в notifications, quickfix, pane history и reports;
- remote disconnect не оставляет зависший local client.

## Правила для AI-агентов

При реализации этого плана агент обязан:

1. читать [`AGENTS.md`](../AGENTS.md) и component README до изменений;
2. сохранять pre-existing dirty worktree;
3. проверять фактический merged spec и runtime mapping, а не угадывать;
4. явно различать «plugin declared», «binary provisioned», «host installed» и
   «workflow verified»;
5. добавлять language extra только через `lazyvim.json`;
6. не добавлять второй provider ради одного mapping;
7. задавать тяжёлому plugin явный trigger;
8. обновлять lockfile только вместе с изменением plugin resolution;
9. не применять host provisioning без отдельного запроса;
10. фиксировать новые долгоживущие архитектурные факты в Beads memory, а
    незавершённую работу — в Beads issues.

## Осознанные ограничения

Neovim не воспроизводит один-в-один:

- закрытый ReSharper solution-wide engine и весь набор Rider refactorings;
- WinForms/XAML drag-and-drop designers и глубокие Unity/Unreal GUI flows;
- DataGrip schema designer, UML и безопасный rich data grid;
- dotTrace/dotMemory timelines и dominator analysis;
- PyCharm DataFrame/Jupyter GUI;
- единый JetBrains cross-language project index;
- Gateway thin-client UX;
- полный browser DOM/framework locator debugger.

Definition of done поэтому не означает «установлены все плагины». Он означает,
что ежедневный code–test–debug–Git цикл быстрый, воспроизводимый и согласованный,
а специализированные внешние поверхности открываются из того же Herdr
workspace без дублирования core editor stack.
