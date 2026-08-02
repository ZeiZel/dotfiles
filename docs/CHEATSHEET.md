# Dotfiles: рабочая шпаргалка

<!-- markdownlint-disable MD013 -->

Это не полный каталог команд, а короткий набор для ежедневной работы.

Обозначения:

- `<Space>` — `leader` в Neovim.
- `Prefix` — нажать `Ctrl+A`, отпустить, затем нажать следующую клавишу.
- **Действует** — mapping/alias есть в текущей конфигурации или активном
  LazyVim extra.
- **Зависимость** — entry point настроен, но требует доступного внешнего
  бинарника.
- **План** — workflow описан в
  [плане IDE](NEOVIM_IDE_PLAN.md), но сочетание ещё не назначено.

Самый точный help в момент работы:

- Neovim: нажать `<Space>` и подождать WhichKey либо вызвать `<Space>sk`.
- Lazygit: `?` в текущей панели.
- Herdr: текущие bindings описаны в [`herdr/config.toml`](../herdr/config.toml).

## Ядро на каждый день

| Сценарий | Действующее сочетание |
| --- | --- |
| Найти файл проекта | `<Space><Space>` |
| Найти текст во всём проекте | `<Space>/` |
| Найти строку в текущем buffer | `<Space>sb` |
| Обычный поиск в текущем buffer | `/текст<Enter>`, затем `n`/`N` |
| Перейти к definition / references | `gd` / `gr` |
| Показать quick fix/code action | `<Space>ca` |
| Переименовать symbol | `<Space>cr` |
| Форматировать buffer/selection | `<Space>cf` |
| Следующая ошибка | `]e`; подробность — `<Space>cd` |
| Запустить project task | `<Space>oo` |
| Запустить ближайший test | `<Space>tr` |
| Debug ближайшего test | `<Space>td` |
| Поставить breakpoint / запустить | `<Space>db` / `<Space>dc` |
| Git status в Neovim | `<Space>gg` |
| Компактный Git status справа | `<Space>gs` |
| Git history файла | `<Space>gh` |
| Git diff/conflicts | `<Space>gd` / `<Space>gm` |
| Lazygit поверх Herdr | `Prefix`, затем `g` |
| Terminal внутри Neovim | `Ctrl+/` |
| История shell | `Ctrl+R` через Atuin |

## Neovim

### Режимы и базовое редактирование

| Сценарий | Клавиши | Статус |
| --- | --- | --- |
| Выйти из Insert | `jj` или `Esc` | Действует |
| Сохранить | `<Space>w` или `Ctrl+S` | Действует |
| Сохранить и выйти | `:wq` | Стандарт Vim |
| Выйти из всех окон | `:qa` | Стандарт Vim |
| Сохранить всё и выйти | `:wqa` | Стандарт Vim |
| Отменить / вернуть | `u` / `Ctrl+R` | Стандарт Vim |
| Повторить последнее изменение | `.` | Стандарт Vim |
| Изменить слово | `ciw` | Стандарт Vim |
| Удалить / скопировать слово | `diw` / `yiw` | Стандарт Vim |
| Комментировать selection | выделить, затем `gc` | Действует через LazyVim |
| Добавить surrounding | `gsa`, затем следовать prompt | Действует |
| Удалить / заменить surrounding | `gsd` / `gsr` | Действует |
| Multi-cursor на слове/selection | `<Space>ms` | Действует |
| История yank | `<Space>p` | Действует |
| Следующий / предыдущий yank | `[y` / `]y` | Действует |

### Файлы, buffers и поиск

| Сценарий | Клавиши |
| --- | --- |
| Файлы от project root | `<Space><Space>` или `<Space>ff` |
| Файлы от текущего каталога | `<Space>fF` |
| Только Git files | `<Space>fg` |
| Недавние файлы | `<Space>fr` |
| Explorer от project root | `<Space>e` |
| Список buffers | `<Space>,` |
| Следующий / предыдущий buffer | `Tab` / `Shift+Tab` |
| Закрыть buffer | `<Space>bd` |
| Закрыть остальные buffers | `<Space>bo` |
| Grep от project root | `<Space>/` или `<Space>sg` |
| Grep от текущего каталога | `<Space>sG` |
| Строки текущего buffer | `<Space>sb` |
| Слово/Visual selection по проекту | `<Space>sw` |
| История поисков | `<Space>s/` |
| Возобновить последний picker | `<Space>sR` |
| Поиск mappings | `<Space>sk` |
| Текст в текущем buffer | `/текст<Enter>` |
| Следующее / предыдущее совпадение | `n` / `N` |
| Слово под cursor вперёд / назад | `*` / `#` |
| Перейти на строку 42 | `42G` или `:42` |
| Начало / конец файла | `gg` / `G` |
| Назад / вперёд по jump list | `Ctrl+O` / `Ctrl+I` |
| Парная скобка/tag | `%` |

Explorer остаётся слева. SQL DBUI открывается справа; из редактора `Ctrl+L`
переходит в DBUI, а `Ctrl+H` возвращает фокус в редактор.

### Сессии проекта

При обычном запуске `nvim` без аргументов из каталога проекта сессия текущей
ветки восстанавливается автоматически. `:qa`, `:wqa` и `<Space>qq` сохраняют
раскладку перед выходом. Автовосстановление отключено для запуска с файлами,
stdin, Git commit/rebase editor, `--headless`, `-c`, `-S` и `--clean`.

| Сценарий | Клавиши |
| --- | --- |
| Восстановить текущую сессию вручную | `<Space>qs` |
| Выбрать snapshot | `<Space>qS` |
| Восстановить последнюю сессию | `<Space>ql` |
| Не сохранять временную раскладку | `<Space>qd` |

Snacks picker показывает hidden и ignored files для files/explorer, а project
grep включает hidden files. Поэтому результаты могут содержать файлы, которые
обычный `git status` не показывает.

### LSP, refactoring и autofix

Эти mappings появляются в buffer только когда подходящий LSP attached и
поддерживает операцию.

| Сценарий | Клавиши |
| --- | --- |
| Definition | `gd` |
| References | `gr` |
| Implementation | `gI` |
| Type definition | `gy` |
| Declaration | `gD` |
| Hover documentation | `K` |
| Signature help | `gK`; в Insert — `Ctrl+K` |
| Code action / quick fix | `<Space>ca` |
| Source-level action | `<Space>cA` |
| Rename symbol | `<Space>cr` |
| Rename file через LSP | `<Space>cR` |
| Organize imports | `<Space>co` |
| Format buffer/Visual selection | `<Space>cf` |
| Document symbols | `<Space>ss` |
| Workspace symbols | `<Space>sS` |
| Incoming / outgoing calls | `gai` / `gao` |
| Следующая / предыдущая reference | `]]` / `[[` |
| LSP information | `<Space>cl` |

`<Space>ca` показывает доступные fixes, но не означает «безусловно исправить
весь проект». Full-project lint/fix должен быть отдельной явной task.

### Refactoring

Тяжёлый refactoring plugin загружается только после первого mapping:

| Сценарий | Клавиши |
| --- | --- |
| Incremental LSP rename | `<Space>cr` |
| Выбрать доступный refactor | `<Space>rs` |
| Inline variable / function | `<Space>ri` / `<Space>rI` |
| Extract selected function | Visual selection, затем `<Space>rf` |
| Extract selected function в файл | Visual selection, затем `<Space>rF` |
| Extract selected variable | Visual selection, затем `<Space>rx` |
| Project search/replace | `<Space>sr` |

Набор безопасных операций зависит от filetype, Treesitter parser и LSP.
Cross-language refactor уровня JetBrains не предполагается.

### Diagnostics и problems

| Сценарий | Клавиши |
| --- | --- |
| Diagnostic текущей строки | `<Space>cd` |
| Следующая / предыдущая diagnostic | `]d` / `[d` |
| Следующая / предыдущая error | `]e` / `[e` |
| Следующая / предыдущая warning | `]w` / `[w` |
| Все diagnostics в Trouble | `<Space>qq` |
| Diagnostics текущего buffer | `<Space>qb` |
| Symbols в Trouble | `<Space>cs` |
| LSP definitions/references view | `<Space>cL` |
| Location list | `<Space>qL` |
| Quickfix list | `<Space>qQ` |
| Diagnostics picker / buffer picker | `<Space>sd` / `<Space>sD` |

Trouble bindings специально разведены со стандартными LazyVim mappings:
`<Space>qd` остаётся persistence action, а `<Space>cl` — LSP Info.

### Project tasks

Overseer — единый task/run surface:

| Сценарий | Клавиши |
| --- | --- |
| Найти и запустить task | `<Space>oo` |
| Restart последней task | `<Space>or` |
| Action над task | `<Space>ot` |
| Toggle task list | `<Space>ow` |

Плагин загружается только этим mapping или `:Overseer*` command. Project task
может быть build, run, lint, test или long-running dev server; проверяйте
выбранную команду в form до запуска.

### Tests

Generic Neotest mappings действуют для подключённых language adapters:

| Сценарий | Клавиши |
| --- | --- |
| Ближайший test | `<Space>tr` |
| Текущий test file | `<Space>tt` |
| Все test files | `<Space>tT` |
| Последний test | `<Space>tl` |
| Debug ближайшего test | `<Space>td` |
| Attach к test process | `<Space>ta` |
| Summary | `<Space>ts` |
| Output текущего test | `<Space>to` |
| Output panel | `<Space>tO` |
| Watch текущего файла | `<Space>tw` |
| Stop | `<Space>tS` |
| Загрузить и показать готовый coverage report | `<Space>tc` |
| Coverage summary | `<Space>tC` |

Наличие generic mapping не гарантирует runtime конкретного проекта. Текущая
конфигурация объявляет adapters для Go, Rust, VSTest, Python, Vitest и Jest.
Для JavaScript/TypeScript ближайший config или `package.json` выбирает ровно
один из Jest/Vitest; end-to-end browser tests пока запускаются project task.

Coverage mappings показывают существующий report, но не генерируют его. Сначала
нужно выполнить language-specific coverage task.

Python-specific:

| Сценарий | Клавиши |
| --- | --- |
| Выбрать virtual environment | `<Space>cv` |
| Debug текущего Python method | `<Space>dPt` |
| Debug текущего Python class | `<Space>dPc` |

### Debug

| Сценарий | Клавиши |
| --- | --- |
| Toggle persistent breakpoint | `<Space>db` |
| Persistent conditional breakpoint | `<Space>dB` |
| Persistent log point | `<Space>dL` |
| Очистить все persistent breakpoints | `<Space>dX` |
| Run/continue | `<Space>dc` |
| Run with arguments | `<Space>da` |
| Run to cursor | `<Space>dC` |
| Step into / over / out | `<Space>di` / `<Space>dO` / `<Space>do` |
| Pause / terminate | `<Space>dP` / `<Space>dt` |
| Repeat last debug | `<Space>dl` |
| Toggle DAP UI | `<Space>du` |
| Evaluate expression/selection | `<Space>de` |
| REPL | `<Space>dr` |
| Stack frame down / up | `<Space>dj` / `<Space>dk` |

Breakpoints сохраняются в Neovim state directory, а не в repository. Language
adapter и executable должны существовать: DAP core сам по себе не делает любой
файл отлаживаемым.

### Git внутри Neovim

#### Neogit

| Сценарий | Клавиши |
| --- | --- |
| Status | `<Space>gg` |
| Compact status в правом split | `<Space>gs` |
| Commit staged changes | `<Space>gc` |
| Log/graph | `<Space>gl` |
| Branches | `<Space>gb` |
| Tags | `<Space>gt` |
| Rebase | `<Space>gr` |
| Help текущего Neogit view | `?` |

В rebase editor: `p` pick, `r` reword, `e` edit, `s` squash, `f` fixup,
`d` drop.

В status view `c` открывает commit popup, но редактор сообщения — отдельное
окно; завершить commit только внутри status pane нельзя. Используйте полный
`<Space>gg` для обычного workflow или компактный `<Space>gs`, когда нужен
параллельный редактор.

#### Diffview

| Сценарий | Клавиши |
| --- | --- |
| Working-tree diff | `<Space>gd` |
| Diff с предыдущим commit | `<Space>gD` |
| History текущего файла | `<Space>gh` |
| History repository | `<Space>gH` |
| Three-way conflict view | `<Space>gm` |
| Следующий / предыдущий conflict | `]x` / `[x` |
| Взять ours / theirs для hunk | `2do` / `3do` |
| Локальный help | `g?` |
| Закрыть view | `:DiffviewClose` |

#### Gitsigns

| Сценарий | Клавиши |
| --- | --- |
| Следующий / предыдущий hunk | `]h` / `[h` |
| Stage hunk | `<Space>ghs` |
| Stage только Visual lines | выделить строки, затем `<Space>ghs` |
| Reset hunk / Visual lines | `<Space>ghr` |
| Undo staged hunk | `<Space>ghu` |
| Preview hunk inline | `<Space>ghp` |
| Blame строки | `<Space>ghb` |
| Toggle inline blame | `<Space>gB` |

Практический partial commit:

1. выделить нужные строки;
2. `<Space>ghs`;
3. проверить `<Space>gd`;
4. `<Space>gc`.

### Окна, terminal и sessions

| Сценарий | Клавиши |
| --- | --- |
| Фокус окна | `Ctrl+H/J/K/L` |
| Vertical / horizontal split | `\|` / `\` |
| Split ниже / справа через leader | `<Space>-` / `<Space>\|` |
| Закрыть окно | `<Space>wd` |
| Zoom текущего окна | `<Space>wm` |
| Terminal от project root | `<Space>ft` или `Ctrl+/` |
| Terminal от текущего каталога | `<Space>fT` |
| Restore session текущего каталога | `<Space>qs` |
| Выбрать session | `<Space>qS` |
| Последняя session | `<Space>ql` |
| Не сохранять текущую session | `<Space>qd` |
| Toggle rendered Markdown | `<Space>um` |

При обычном запуске `nvim` без аргументов из project root `persistence.nvim`
автоматически восстанавливает session Git root и ветки. Запуск из monorepo
subdirectory нормализует cwd к Git root. Для non-Git проекта требуется запуск
из директории с прямым project marker (workspace/package, language/build,
Docker/Helm/Kubernetes/Terraform/Ansible или .NET solution/project); snapshots
индексируются по cwd.

Configured integrations:

- `<Space>ld` — Lazydocker popup, если команда `lazydocker` доступна;
- `:RemoteStart`, `:RemoteStop`, `:RemoteInfo` — remote-nvim по команде.

### Posting

Posting читает [`posting/config.yaml`](../posting/config.yaml) при запуске как
самостоятельный внешний CLI. Сочетания сохраняют штатные клавиши и добавляют
безопасные альтернативы:

| Действие | Клавиши |
| --- | --- |
| Отправить request | `Ctrl+J`, `Alt+Enter`, `Ctrl+Enter` |
| Сохранить / новый request | `Ctrl+S` / `Ctrl+N` |
| Выйти | `Ctrl+C` |
| Jump mode / поиск / команды | `Ctrl+O` / `/` / `:` |
| Помощь | `?`, `F1` |

Posting уже даёт Vim-навигацию в виджетах: collection/tree поддерживает `j/k`,
`J/K`, `g/G`, `h/l`, `Enter`, `r` и `Space`; таблицы — `h/j/k/l` и `g/G`.
`Ctrl+O` открывает cross-widget jump overlay с буквами/цифрами для перехода к
видимым панелям. `Esc` закрывает overlay и стандартные диалоги. URL и body
Input/TextArea сохраняют обычный текстовый ввод.

### Resterm

Resterm загружает native overrides из [`resterm/bindings.toml`](../resterm/bindings.toml).
На macOS роль dotfiles создаёт ссылку в нативный каталог
`~/Library/Application Support/resterm/bindings.toml`; на Linux Stow использует
`~/.config/resterm/bindings.toml`. Поэтому одинаково работают прямой `resterm`
и `dev rest`, а нативная macOS history DB остаётся на месте.

| Действие | Клавиши |
| --- | --- |
| Предыдущий focus в горизонтальном порядке | `Shift+Tab`, `Ctrl+H`, `Ctrl+K` |
| Следующий focus в горизонтальном порядке | `Tab`, `Ctrl+J`, `Ctrl+L` |
| Отправить request | `Ctrl+Enter`, `Cmd+Enter`, `Alt+Enter`, `Ctrl+M` |

`Ctrl+J` намеренно убран из отправки request, чтобы не конфликтовать с
переключением focus. Это previous/next approximation для текущего порядка
горизонтальных pane, а не настоящая directional-навигация. В editor insert
mode эти сочетания специально поглощаются: сначала нажмите `Esc`, затем
используйте binding в normal mode.

### REST `.http`/`.rest`

Kulala загружается через scratchpad либо при первом REST mapping в
`.http`/`.rest` buffer:

| Сценарий | Клавиши |
| --- | --- |
| Открыть REST scratchpad | `<Space>Rb` |
| Отправить текущий request | `<Space>Rs` |
| Выполнить все requests | `<Space>Ra` |
| Replay последнего request | `<Space>Rr` |
| Следующий / предыдущий request | `<Space>Rn` / `<Space>Rp` |
| Inspect request | `<Space>Ri` |
| Toggle body / headers | `<Space>Rt` |
| Copy как cURL | `<Space>Rc` |
| Выбрать environment | `<Space>Re` |

REST session не восстанавливается автоматически. Tokens и cookies должны
оставаться в local environment, а не в tracked request collection.

## Zsh, Atuin и FZF

ZLE принудительно использует только Emacs keymap. `EDITOR=nvim` не должен
переключать shell в Vim mode.

### Редактирование command line

| Сценарий | Клавиши |
| --- | --- |
| История назад / вперёд | `Up` / `Down` |
| То же без стрелок | `Ctrl+P` / `Ctrl+N` |
| Fuzzy history через Atuin | `Ctrl+R` |
| Начало / конец строки | `Ctrl+A` / `Ctrl+E` |
| Удалить до конца / начала строки | `Ctrl+K` / `Ctrl+U` |
| Удалить предыдущее слово | `Ctrl+W` |
| Слово назад / вперёд | `Ctrl+Left/Right` или `Alt+B/F` |
| Очистить экран через ZLE | `Ctrl+L` |
| Отменить текущую команду | `Ctrl+C` |
| Completion | `Tab` |
| Группа completion назад / вперёд | `,` / `.` внутри fzf-tab |

Atuin настроен на fuzzy/global compact search и Emacs keymap. `Ctrl+R`
открывает его, а `Up`/`Down` остаются нативной историей Zsh. После выбора
Atuin возвращает команду в prompt; перед запуском её можно отредактировать.

Если в текущем shell всё же появился Vim mode:

```zsh
bindkey -e
```

Это восстанавливает текущую session; следующий tracked shell и так выполняет
`bindkey -e`.

### FZF

| Сценарий | Клавиши/команда |
| --- | --- |
| Выбрать файл и вставить path | `Ctrl+T` |
| Выбрать каталог и перейти | `Alt+C` |
| Toggle preview внутри FZF | `?` |
| Preview на полстраницы | `Ctrl+U` / `Ctrl+D` |
| Скопировать selection | `Ctrl+Y` |
| Выделить всё | `Ctrl+A`; внутри Herdr отправить literal через `Prefix Ctrl+A` |
| Открыть файл в editor | `fe` или `fv` |
| Перейти в каталог | `fcd` |
| Нативная history через FZF | `fh` |
| Git branches / log browser | `fgb` / `fgl` |
| Найти и завершить process | `fkill` |

`Ctrl+R` принадлежит Atuin, а не FZF history widget.

### Частые shell entry points

| Сценарий | Команда |
| --- | --- |
| Перейти через Yazi с сохранением cwd | `yy` |
| Neovim config switcher | `nvims` |
| Herdr named session с FZF | `hsm` |
| Создать каталог и войти | `mkcd DIR` |
| Распаковать archive | `extract FILE` |
| Открыть dotfiles в Neovim | `dotfiles` |
| Править Nvim / Herdr config | `nvimrc` / `herdrc` |
| Интерактивная шпаргалка Navi | `nav` |

Для plain shell без автоматического входа в Herdr установите
`ZSH_HERDR_AUTOSTART=0` в untracked `~/.zshrc.local`.

## Herdr

Prefix — это последовательность, а не chord:

1. нажать `Ctrl+A`;
2. отпустить;
3. нажать следующую клавишу.

| Сценарий | Сочетание |
| --- | --- |
| Lazygit на весь terminal | `Prefix g` |
| Toggle Reviewr overlay | `Prefix Shift+R` |
| Session navigator | `Prefix f` |
| Workspace picker | `Prefix w` |
| Предыдущий / следующий workspace | `Prefix Left` / `Prefix Right` |
| Split справа / вниз | `Prefix v` / `Prefix -` |
| Фокус pane | `Prefix h/j/k/l` |
| Detach, процессы продолжаются | `Prefix q` |
| Reload config | `Prefix Alt+R` |
| Передать приложению literal `Ctrl+A` | `Prefix Ctrl+A` |

Последний пункт важен для Zsh/FZF: внутри Herdr обычный `Ctrl+A` начинает
prefix, поэтому начало command line или FZF select-all получают literal только
после второго `Ctrl+A`.

Команды:

| Сценарий | Команда/alias |
| --- | --- |
| Status | `herdrs` |
| Sessions | `herdrl` |
| Reload config | `herdrr` |
| Открыть Reviewr вручную | `reviewr` |

Tmux-конфигурация хранится как legacy fallback, но не является активным
workspace manager.

## Lazygit

Tracked override включает Signed-off-by в commit и выход по возврату с верхнего
уровня. Остальные клавиши — defaults установленного Lazygit; после обновления
проверяйте `?` и
[официальную таблицу](https://github.com/jesseduffield/lazygit/blob/master/docs/keybindings/Keybindings_en.md).

### Навигация

| Сценарий | Клавиши |
| --- | --- |
| Панели Status/Files/Branches/Commits/Stash | `1` / `2` / `3` / `4` / `5` |
| Main view | `0` |
| Элемент вверх / вниз | `k` / `j` или стрелки |
| Панель влево / вправо | `h` / `l` |
| Войти / назад | `Enter` / `Esc` |
| Help текущей панели | `?` |
| Поиск в view | `/`, затем `n` / `N` |
| Push / pull | `P` / `p` |
| Refresh | `R` |
| Undo / redo Git operation | `z` / `Z` |
| Merge/rebase continue/abort menu | `m` |
| Quit | `q` |

### Files, lines и commit

В панели Files (`2`):

| Сценарий | Клавиши |
| --- | --- |
| Stage/unstage файла | `Space` |
| Stage/unstage всех файлов | `a` |
| Открыть line/hunk staging | `Enter` |
| Commit / commit через editor | `c` / `C` |
| Amend последнего commit | `A` |
| Stash / stash options | `s` / `S` |
| Edit в `$EDITOR` / открыть системно | `e` / `o` |
| Discard options | `d` |
| Merge conflict options | `M` |
| External difftool | `Ctrl+T` |

В staging view после `Enter`:

| Сценарий | Клавиши |
| --- | --- |
| Предыдущий / следующий hunk | `h` / `l` |
| Переключить line-by-line / целый hunk | `a` |
| Stage/unstage строки или selection | `Space` |
| Начать range selection | `v` |
| Переключить staged/unstaged side | `Tab` |
| Edit текущего hunk | `E` |
| Вернуться к Files | `Esc` |

### Branches и history

В Branches (`3`):

| Сценарий | Клавиши |
| --- | --- |
| Checkout selected | `Space` |
| Новая branch | `n` |
| Предыдущая branch | `-` |
| Rebase текущей branch на выбранную | `r` |
| Merge выбранной в текущую | `M` |
| Rename / delete | `R` / `d` |
| Новый tag | `T` |
| Worktree menu | `w` |

В Commits (`4`):

| Сценарий | Клавиши |
| --- | --- |
| Interactive rebase | `i` |
| Pick / reword / edit / squash / fixup / drop | `p` / `r` / `e` / `s` / `f` / `d` |
| Move commit вниз / вверх | `Ctrl+J` / `Ctrl+K` |
| Создать fixup / применить fixups | `F` / `S` |
| Copy commit(s) / cherry-pick paste | `C` / `V` |
| Amend выбранного commit | `A` |
| Revert / tag | `t` / `T` |
| Checkout detached commit | `Space` |
| Reset options | `g` |
| Bisect options | `b` |
| Файлы commit | `Enter` |

### Conflicts

1. В Files выбрать conflict file и нажать `Enter`.
2. `h`/`l` — предыдущий/следующий conflict.
3. `k`/`j` — предыдущий/следующий hunk.
4. `Space` — взять текущий hunk; `b` — взять оба.
5. `z` — отменить последнее resolution.
6. `e` — открыть файл в editor, `M` — conflict options.
7. После resolution открыть global menu `m` и продолжить merge/rebase.

## Git в shell

Ниже перечислены только aliases из активного
[`zsh/aliases.zsh`](../zsh/aliases.zsh). Файл `git/funcs.sh` не входит в
явный Zsh source manifest и поэтому не считается активной шпаргалкой.

| Сценарий | Alias | Разворачивается в |
| --- | --- | --- |
| Status | `gst` | `git status` |
| Красивый graph | `glog` | `git log --graph ...` |
| Diff | `gdiff` | `git diff` |
| Branches | `gb` / `gba` | local / all |
| Checkout | `gco NAME` | `git checkout NAME` |
| Интерактивно добавить hunks | `gap` | `git add -p` |
| Добавить path | `gadd PATH` | `git add PATH` |
| Убрать из stage | `grs PATH` | `git restore --staged PATH` |
| Commit message | `gc "message"` | `git commit -m "message"` |
| Push текущего HEAD | `gp` | `git push origin HEAD` |
| Pull origin | `gpu BRANCH` | `git pull origin BRANCH` |
| Interactive rebase | `grbi BASE` | `git rebase -i BASE` |
| Cherry-pick | `gcp SHA` | `git cherry-pick SHA` |
| Stash / list / pop | `gsh` / `gshl` / `gshp` | соответствующие Git команды |

Полезное восстановление без alias:

```bash
git diff --staged
git restore -p path/to/file
git reflog
git rebase --continue
git rebase --abort
git merge --abort
```

Для conflicts внутри текущей конфигурации предпочтителен `<Space>gm` в Neovim.
`git mergetool` следует использовать только после проверки фактического
system mergetool.

## Частые dotfiles aliases

| Область | Ежедневный минимум |
| --- | --- |
| Node/npm | `nr`, `nrd`, `nrt`, `nrl`, `nrb` |
| pnpm | `pr`, `prd`, `prt`, `prb`, `px` |
| Docker Compose | `dco`, `dcup`, `dcdown`, `dclogs` |
| Docker TUI | `ld` |
| Unified dev environment | `dev ide`, `dev rest`, `dev db`, `dev docker`, `dev git`, `dev agent codex|claude` |
| Kubernetes | `k`, `kgp`, `kl`, `ke`, `k9` |
| Helm | `h`, `hla`, `hui` |
| Terraform safe checks | `tfp`, `tfv`, `tff` |
| Ansible | `ap`, `al`, `av` |
| Files | `l`, `ll`, `lt`, `ff`, `fdir`, `yy` |
| Processes/logs | `bt`, `psa`, `pst`, `logs` |
| HTTP | `xget`, `xpost`, `xput`, `xdel` |

`rm`, `cp` и `mv` aliased с interactive confirmation. Destructive aliases
вроде Docker prune или Terraform auto-approve намеренно не входят в ежедневный
минимум.

`post`, `hq` и `htt` существуют как shell entry points, но успешная работа
зависит от provisioned `posting`, `harlequin` и `httpyac`.

Единая точка входа для интерактивного окружения — функция `dev`:

```zsh
dev ide                 # nvim
dev rest                # resterm
dev db                  # harlequin
dev docker              # lazydocker
dev git                 # lazygit
dev agent codex         # Codex CLI
dev agent claude        # Claude CLI
```

Дополнительные аргументы передаются выбранной программе без изменений.

## Планируется, но ещё не является сочетанием

Не запоминайте будущие bindings до их появления в runtime:

| Workflow | Текущее состояние / fallback |
| --- | --- |
| Language-specific task catalog | Overseer surface действует; templates ещё расширяются |
| Python IDE lifecycle | Python extra действует; project runtime всё равно должен быть установлен |
| Browser E2E tests | Jest/Vitest действуют; Playwright/Cypress пока через task |
| Coverage generation | Viewer действует; report создаёт language-specific task/CLI |
| Persisted project launch profiles | Breakpoints сохраняются; profiles ещё стандартизируются |
| Security/dependency scans | План explicit tasks; не on-save |
| GitHub PR UI внутри Neovim | План opt-in; сейчас Reviewr/`gh`/Lazygit |
| Remote/devcontainer profile | План; сейчас `:Remote*` commands и Herdr/SSH |

## Как проверить, что шпаргалка не врёт

```vim
:verbose nmap <Space>qd
:verbose nmap gd
:Lazy
:Mason
```

```zsh
bindkey '^R'
bindkey -M emacs '^[[A'
type gp
command -v posting harlequin httpyac
```

В Lazygit нажмите `?` именно в нужной панели. В Herdr используйте
`herdr config check`. Наличие plugin spec, shell alias или Mason directory
ещё не доказывает, что весь workflow установлен и проверен.
