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
- Tmux/Workmux: основной workspace и prefix — `Ctrl+A`; Workmux настроен в
  [`workmux/config.yaml`](../workmux/config.yaml).
- Herdr: дополнительный workspace и тот же prefix — `Ctrl+A`; его bindings
  повторяют Tmux и описаны в [`herdr/README.md`](../herdr/README.md) и
  [`herdr/config.toml`](../herdr/config.toml).

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
| Lazygit popup в Herdr/Tmux | `Prefix`, затем `g` |
| Workmux dashboard | `Prefix`, затем `W` |
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
| Multi-cursor на слове под cursor | `Ctrl+N` | Действует |
| История yank | `<Space>p` | Действует |
| Следующий / предыдущий yank | `[y` / `]y` | Действует |

### Интерфейс: header, breadcrumbs, статусбар

Над explorer в строке вкладок выводится ` <проект>    <ветка>`, а заголовок
окна терминала — `проект — ⎇ ветка — файл`. Имя проекта берётся из Git root.
В статусбаре к нему добавляется вложенный корень, если language server
разрешил под-проект: в монорепозитории это читается как `repo/package`.

Breadcrumbs (`dropbar.nvim`) занимают `winbar` над буфером и показывают
`каталог › файл › символ` из пути и LSP document symbols, с откатом на
Tree-sitter. Компоненты кликабельны и раскрываются в меню. Дублирующий
Trouble-компонент в статусбаре отключён, чтобы путь не печатался дважды.

Единый статусбар слева направо: режим, ветка и diff, шесть кликабельных
кнопок панелей, метка проекта, диагностика, путь, задачи Overseer, форматтеры
Conform, подключённые LSP, отступы, кодировка и перевод строки (только если
не UTF-8/LF), filetype, прогресс, позиция курсора и часы.

Кнопки панелей — explorer, Git, problems, tests, tasks, terminal. Клик мышью
открывает панель, у каждой есть и сочетание.

Символ `󰌵` в конце строки означает, что language server предлагает code action
(refactor или quick fix) — это аналог лампочки в IDE. Запрос идёт только по
`CursorHold`.

| Сценарий | Клавиши |
| --- | --- |
| Breadcrumbs: режим выбора | `<Space>cb` |
| Structure/outline справа | `<Space>cs` |
| Панель problems | `<Space>qq` |
| Problems текущего buffer | `<Space>qb` |
| Список задач | `<Space>ow` |
| Применить code action | `<Space>ca` |
| Выключить/включить индикатор code action | `<Space>uB` |

### AI-агенты в редакторе

`sidekick.nvim` запускает официальные CLI в терминале редактора: каждый агент
логинится своей подпиской, ключи и содержимое буферов в репозитории не
хранятся. Herdr остаётся агентами уровня рабочего пространства, sidekick — это
мост уровня буфера: отдать агенту символ под курсором, файл или выделение.

На этой машине найдены `claude`, `codex` и `opencode`; `<Space>as` показывает
только установленные. Copilot Next Edit Suggestions выключены — на хосте нет
`copilot-language-server`; спецификация смотрит на бинарник, так что фича
включится сама, если его поставить.

| Сценарий | Клавиши |
| --- | --- |
| Открыть/закрыть терминал агента | `<Space>aa` |
| Claude Code / Codex | `<Space>ac` / `<Space>ax` |
| Выбрать установленного агента | `<Space>as` |
| Библиотека промптов | `<Space>ap` |
| Отдать символ под курсором | `<Space>at` |
| Отдать весь файл | `<Space>af` |
| Отдать выделение | `<Space>av` |

### Внешний вид и курсор

Терминал и редактор теперь на одной палитре Catppuccin Mocha — при прозрачном
фоне Neovim иначе они спорили друг с другом в каждой непокрытой ячейке.
Строка курсора — не серая полоса, а pink, подогретый rose-акцентом и
подмешанный в базу на 22%: розовая, но достаточно тёмная, чтобы поверх
читался текст. Выделение — lavender с базой на 22%, оно остаётся синим и
не путается со строкой курсора; подсказки пробелов приглушены.
Межстрочный интервал задаёт Ghostty: `adjust-cell-height = 28%` (действует на
все терминальные программы, не только на Neovim). Плавающие окна без своей
рамки получают скруглённую (`winborder`).

Панели показывают фон терминала так же, как редактор: explorer, закреплённые
панели edgy и docked terminal больше не затемняются. Плавающие пикеры при этом
остаются читаемыми над кодом — под ними лежит собственный непрозрачный бокс.

Курсор: `guicursor` даёт блок в Normal, тонкую полосу в Insert и мигание с
каденцией как в VS Code — мигает сам терминал. Движение между позициями
анимирует smear-cursor, теперь с субклеточным разрешением через символы
Unicode 16 legacy computing (Ghostty рисует их сам, покрытие шрифта не нужно) —
за счёт этого курсор растягивается и сжимается по оси Y при переходе между
строками, а не прыгает по клеткам. Полностью повторить «расширяющееся» мигание
VS Code сетка терминала не может; это максимум для клеточного рендера.
`:SmearCursorToggle` выключает анимацию движения.

### Закреплённые панели (edgy)

`edgy.nvim` держит tool windows на фиксированных краях: панель всегда
открывается в одном и том же месте и одного размера, а не там, где случился
последний `:split`.

| Край | Что там | Размер |
| --- | --- | --- |
| Слева | Explorer (project view), Neotest summary | 40 колонок |
| Справа | Neogit-панель, Dadbod, правый Trouble, Grug Far | 46 колонок |
| Снизу | Trouble, quickfix, Overseer, Neotest, terminal, help | 14 строк |

Докается только панель `<Space>gs`. `<Space>gg` открывает Neogit отдельной
вкладкой на всю ширину — она остаётся нетронутой.

| Сценарий | Клавиши |
| --- | --- |
| Свернуть/развернуть все края | `<Space>ue` |
| Перейти к панели | `<Space>uE` |
| Закрыть / скрыть панель под фокусом | `q` / `Ctrl+Q` |
| Закрыть весь край | `Q` |
| Следующая / предыдущая панель на краю | `]w` / `[w` |
| Изменить размер панели | `Ctrl+Left/Right/Up/Down` |
| Сбросить размеры | `Ctrl+W =` |

`q`, `Q`, `]w`, `[w` и `Ctrl+W`-ресайз действуют только внутри панелей и
никогда не перекрывают обычные клавиши редактирования.

### Сообщения и уведомления

Noice владеет UI сообщений, Snacks notifier рисует всплывающие карточки.
Hover и signature help — в такой же скруглённой рамке, `<Space>cr` показывает
переименование прямо в cmdline, прогресс LSP — один маленький индикатор в углу,
а не стопка тостов. Рутина (запись файла, счётчики undo/yank, переход поиска
через край) уходит в неприметный угловой вид; счётчик поиска, «No information
available» и прогресс диагностики отбрасываются совсем. Всё остальное
по-прежнему показывается полноценным тостом.

| Сценарий | Клавиши |
| --- | --- |
| История уведомлений | `<Space>n` |
| Скрыть все уведомления | `<Space>un` |
| Последнее сообщение / вся история | `<Space>snl` / `<Space>snh` |
| Все сообщения / сбросить | `<Space>sna` / `<Space>snd` |

### Мультикурсор

Владелец один — `multicursor.nvim`. Каждый дополнительный курсор является
настоящим курсором Vim со своими регистрами: операторы, text objects, счётчики,
макросы, `.`, Insert и undo работают ровно так же, как с одним курсором.
Отдельного «режима мультикурсора» с урезанным набором команд нет — этим он
отличается от блочного выделения `Ctrl+V`.

Типовой цикл: встать на слово, нажать `Ctrl+N` столько раз, сколько нужно
вхождений (или `<Space>ma` — сразу все), отредактировать как обычно, затем
`Esc` — курсоры схлопываются в один.

| Сценарий | Клавиши (Normal и Visual) |
| --- | --- |
| Курсор на следующем вхождении | `Ctrl+N` или `<Space>mn` |
| Курсор на предыдущем вхождении | `<Space>mN` |
| Пропустить вхождение вперёд / назад | `<Space>mx` / `<Space>mX` |
| Курсор на всех вхождениях в буфере | `<Space>ma` |
| Курсор строкой ниже / выше | `<Space>mj` / `<Space>mk` |
| Пропустить строку ниже / выше | `<Space>mJ` / `<Space>mK` |
| Переключить курсор в текущей позиции | `<Space>mt` |
| Убрать все курсоры | `<Space>mc` |
| Вернуть только что убранные курсоры | `<Space>mr` |
| Выровнять курсоры по колонкам | `<Space>mg` |
| Курсор под указателем | `Ctrl` + левый клик |

Из Visual selection:

| Сценарий | Клавиши |
| --- | --- |
| Разбить selection по шаблону | `<Space>mp` |
| Курсор на каждом совпадении внутри selection | `<Space>mm` |
| Insert / append в каждом selection | `<Space>mI` / `<Space>mA` |
| Прокрутить содержимое selection | `<Space>mT` |

Пока курсоры существуют, дополнительно действуют buffer-local клавиши, которые
исчезают вместе с последним курсором: `Ctrl+N` — следующее вхождение, `Ctrl+P` —
пропустить, `Ctrl+Left` / `Ctrl+Right` — переключить главный курсор, `Esc` —
убрать все.

### Файлы, buffers и поиск

Snacks Explorer открывается слева: `<Space>fe` (и привычный remap
`<Space>e`) всегда использует Git root репозитория. Для намеренной навигации
от текущего каталога используйте `<Space>fE` или `<Space>E`; это единственный
вариант, который следует за текущим working directory или вложенным проектом.
Bufferline остаётся видимым даже при одном обычном buffer и скрывается только
на стартовом `snacks_dashboard`.

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

Вместе с сессией восстанавливается состояние панелей: раскрытые каталоги
explorer и сам факт того, что панель была открыта. Snapshot лежит в
`$XDG_STATE_HOME/nvim/workspace/` и ключуется так же, как файл сессии — по cwd
и ветке, поэтому у каждой ветки своя раскладка окон и своё раскрытое дерево.
Панель открывается и сразу отдаёт фокус обратно в редактор, курсор остаётся в
файле. Переход в панель попадает на дерево файлов в Normal mode, а не в строку
поиска; чтобы намеренно попасть в поиск, нажмите `i` в списке. Trouble,
Overseer, Neogit и terminal не восстанавливаются — их открывают их же
сочетания.

| Сценарий | Клавиши |
| --- | --- |
| Восстановить текущую сессию вручную | `<Space>qs` |
| Выбрать snapshot | `<Space>qS` |
| Восстановить последнюю сессию | `<Space>ql` |
| Сохранить сессию и панели, не выходя | `<Space>qw` |
| Не сохранять временную раскладку | `<Space>qd` |
| Недавние проекты | `<Space>qp` или `<Space>fp` |

`<Space>qp` показывает проекты из `~/projects`, `~/dev` и корней недавних
файлов; выбор проекта загружает его сессию.

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
| Сохранить session сейчас | `<Space>qw` |
| Не сохранять текущую session | `<Space>qd` |
| Недавние проекты | `<Space>qp` |
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

### Helm и Kubernetes в Neovim

Открытие Helm-шаблона или `values*.yaml` лениво подключает единственный
`helm_ls`: completion, hover (`K`), definition (`gd`) и references (`gr`).
`helm-ls.nvim` подсвечивает управляющие блоки и показывает line-local hints
для `indent`/`nindent`; при найденном `Chart.yaml` экспериментально отображает
текущие значения выражений через virtual text/conceal. Это не полноценный
`helm template`: secrets, cluster lookups и произвольные функции не вычисляются.
Для точного результата запускайте `helm template` явной задачей Overseer.

`conceallevel=2` включён только для Helm buffers. Jinja YAML определяется по
содержимому и намеренно не классифицируется как Helm. Hex-цвета и Tailwind
utility colors подсвечиваются через ленивый `mini-hipatterns`.

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
| Интерактивная шпаргалка Navi | `Ctrl+G`, `nav` |

Мультиплексор выбирается через `ZSH_MULTIPLEXER` в untracked
`~/.zshrc.local`: `tmux` (по умолчанию), `herdr` или `none`.
Для разового выбора в новом outer/plain shell используйте
`ZSH_MULTIPLEXER=herdr zsh` или `ZSH_MULTIPLEXER=none zsh`; guards вложенных
мультиплексоров имеют приоритет.

### Navi: команды по описанию

`Ctrl+G` открывает поиск по шпаргалкам из
[`navi/cheats/`](../navi/cheats). Выбранный сниппет вставляется в командную
строку: подстановки запрашиваются по очереди, и команду ещё можно прочитать и
поправить перед Enter. `nav` запускает то же самое отдельным процессом, но
тогда сниппет выполняется в неинтерактивном shell и не видит функций вроде
`heavy` или `dev` — для них нужен именно виджет.

Поиск идёт и по колонке тега, поэтому имя инструмента в запросе сразу сужает
выдачу.

| Сценарий | Как искать |
| --- | --- |
| Shell в контейнере Docker | `Ctrl+G`, `docker shell into a container` |
| Shell в поде Kubernetes | `Ctrl+G`, `kubernetes shell into a pod` |
| Логи контейнера, follow | `Ctrl+G`, `docker follow container logs` |
| Логи пода, follow | `Ctrl+G`, `kubernetes follow pod logs` |
| Логи всех подов деплоя | `Ctrl+G`, `logs of every pod` |
| Снести все локальные контейнеры | `Ctrl+G`, `docker DESTRUCTIVE remove all` |
| Всё, что удаляет или ломает | `Ctrl+G`, `DESTRUCTIVE` |
| Всё, что меняет состояние хоста | `Ctrl+G`, `APPLIES` |
| Поиск сразу по теме | `navq docker`, `navq kubernetes`, `navq git` |
| Команда не из шпаргалок | `navi --tldr <команда>` |

Списки контейнеров, подов, namespace, релизов, веток и профилей строятся из
живого состояния: сначала выбирается namespace, затем поды уже отфильтрованы по
нему. Описания короткие намеренно — finder ищет только по видимой части колонки
комментария, и слово за обрезкой найти нельзя.

Машинно-специфичное (обёртки прокси, `KUBECONFIG` стендов, jump-хосты, строки
подключения) кладётся в `~/.config/navi/cheats.local/` и в репозиторий не
попадает. Подробности и правила добавления — в
[`navi/README.md`](../navi/README.md).

### Приоритет процессов

Процесс, запущенный из shell, наследует его класс планировщика, поэтому сборка
конкурирует с редактором на равных. GUI-приложение эту гонку не проигрывает —
его главный поток зарегистрирован как user-interactive; у TUI такого пути нет.
Отсюда и разница: Zed под нагрузкой не лагает, а Neovim в терминале лагает.

Поднять приоритет нельзя: отрицательный `renice` требует root, а интерактивный
shell и так в максимальном доступном классе. Поэтому foreground защищается
только тем, что нагрузка уводится вниз, на энергоэффективные ядра.

| Сценарий | Команда |
| --- | --- |
| Запустить сборку/тесты на E-ядрах | `heavy <команда>` |
| То же плюс троттлинг дискового IO | `idle <команда>` |
| Посмотреть, кто реально держит ядра | `hogs [%]` |
| Увести вниз всех незащищённых пожирателей | `calm [%]` |
| Придавить конкретный процесс или дерево | `demote <pid\|имя>` |
| Вернуть процесс обратно в foreground | `boost [pid\|имя]` |
| Узнать текущую полосу процесса | `prio [pid\|имя]` |

Типовые сборочные команды подхватываются автоматически: `pnpm build`,
`cargo test`, `go build`, `make`, `tsc`, `vitest`, `brew install` и подобные
уходят на E-ядра без обёртки. Совпадение идёт по всей командной строке, а не по
имени бинарника: `pnpm build` клампится, `pnpm dev` — нет. Обойти обёртку
разово: `command pnpm build`.

`boost` без аргументов поднимает обратно все запущенные интерактивные
инструменты из `PRIORITY_INTERACTIVE` (Ghostty, tmux, Neovim, lazygit, yazi,
k9s и остальные) — это путь восстановления, если `calm` задел лишнее.

Осознанно не входят в автоматику: Docker и Minikube (работа идёт внутри
Linux-VM, кламп клиента ничего не меняет — ограничивайте CPU в Docker Desktop,
либо ловите VM через `calm`), `hyperfine` (кламп бенчмарка искажает замеры) и
`git` (короткий и интерактивный).

Выключить автоматику, сохранив команды: `PRIORITY_AUTO=0` в `~/.zshrc.local`.

Замер на 4P/6E: три одинаковые CPU-петли одновременно получили 76%, 16% и 13%
ядра — обычная, под `heavy` и под `idle` соответственно.

## Herdr

Prefix — это последовательность, а не chord:

1. нажать `Ctrl+A`;
2. отпустить;
3. нажать следующую клавишу.

Bindings повторяют `tmux/tmux.binds.conf`, поэтому одна мышечная память
работает в обоих мультиплексорах. Соответствие терминов: Tmux session -> Herdr
workspace (space), Tmux window -> Herdr tab, Tmux pane -> Herdr pane. Полная
таблица и осознанные расхождения — в [`herdr/README.md`](../herdr/README.md).

| Сценарий | Сочетание | Tmux |
| --- | --- | --- |
| Split справа / вниз | `Prefix \|` / `Prefix -` | `\|` / `-` |
| Фокус pane | `Prefix h/j/k/l` | то же |
| Resize pane на 5 % | `Prefix Shift+H/J/K/L` | то же |
| Swap pane с соседним | `Prefix {` / `Prefix }` | то же |
| Вынести pane в новый tab | `Prefix !` | `!` |
| Zoom / закрыть pane | `Prefix z` / `Prefix x` | то же |
| Новый tab / переименовать / закрыть | `Prefix c` / `Prefix ,` / `Prefix &` | то же |
| Предыдущий / следующий tab | `Prefix Ctrl+H` / `Prefix Ctrl+L` | то же |
| Новый space / переименовать / закрыть | `Prefix Shift+C` / `Prefix $` / `Prefix Shift+X` | `C` / `$` / `X` |
| Space navigator / picker | `Prefix s` / `Prefix Shift+S` | `s` |
| Предыдущий / следующий space | `Prefix (` / `Prefix )` | то же |
| Worktree: открыть / создать / удалить | `Prefix w` / `Prefix Shift+W` / `Prefix Shift+D` | Workmux `w` / `W` |
| Scrollback в `$EDITOR` | `Prefix [` | `[` (copy-mode) |
| Detach, процессы продолжаются | `Prefix d` | `d` |
| Reload config | `Prefix r` | `r` |
| Toggle sidebar | `Prefix t` | `t` (status bar) |
| Popup: Lazygit / Btop / Yazi / fzf / notes | `Prefix g` / `b` / `y` / `f` / `n` | то же |
| Toggle Reviewr overlay | `Prefix Shift+R` | — |
| Перейти к источнику уведомления | `Prefix Alt+O` | — |
| Передать приложению literal `Ctrl+A` | `Prefix Ctrl+A` | `Prefix Ctrl+A` |

Последний пункт важен для Zsh/FZF: внутри Herdr обычный `Ctrl+A` начинает
prefix, поэтому начало command line или FZF select-all получают literal только
после второго `Ctrl+A`.

Уведомления о фоновых агентах уходят в macOS Notification Center
(`[ui.toast] delivery = "system"` плюс `terminal-notifier`), а не остаются
внутри терминала. Проверка: `herdr notification show "Herdr" --body test`.

Команды:

| Сценарий | Команда/alias |
| --- | --- |
| Status | `herdrs` |
| Sessions | `herdrl` |
| Reload config | `herdrr` |
| Открыть Reviewr вручную | `reviewr` |

## Tmux и Workmux

Обычный локальный интерактивный Zsh автоматически подключается к постоянной
Tmux-сессии `main`. Для Herdr установите `ZSH_MULTIPLEXER=herdr`, а для обычного
shell — `none`. Вложенные мультиплексоры, SSH, IDE и non-TTY shells остаются
обычным shell.

`Prefix` — это `Ctrl+A`: нажать, отпустить, затем нажать следующую клавишу.

### Сохранение и восстановление состояния

Сервер живёт независимо от терминалов: `exit-empty off` не даёт ему завершиться
даже без сессий, а `destroy-unattached off` сохраняет сессии при отключении
клиента. Закрытие Ghostty отсоединяет клиента, но не трогает shells внутри.

Снапшот пишется автоматически: раз в 5 минут (continuum), при каждом отсоединении
клиента и при закрытии сессии, если остались другие. Восстановление происходит
при старте нового сервера — то есть после перезагрузки, а не при каждом
подключении к уже работающему серверу.

Сервер поднимается сам при входе в систему: LaunchAgent
`com.dotfiles.tmux-server` запускает
[`tmux/tmux-server-boot.sh`](../tmux/tmux-server-boot.sh) — без открытия
терминала. Сначала шанс даётся continuum, и только если сессии не появились,
скрипт восстанавливает снапшот явно, чтобы результат не зависел от гонки.
Штатный `@continuum-boot` для этого не годится: под macOS он открывает
Terminal.app, iTerm, kitty или Alacritty и про Ghostty не знает. Выключается
через `macos_tmux_server_autostart: false`.

На холодном старте `tmux-auto.zsh` сначала поднимает пустой сервер, ждёт
появления сессии `main` и только потом подключается. Порядок важен: если создать
`main` заранее и восстанавливать поверх неё, в окнах, которые resurrect
пересоздаёт последними, появляются лишние панели.

Continuum намеренно отключает авто-восстановление, если запущен ещё один
tmux-сервер (другой сокет через `tmux -L`), чтобы снапшоты двух окружений не
затирали друг друга. В такой ситуации восстанавливайте вручную — `Prefix Ctrl+R`.

| Сценарий | Команда/сочетание |
| --- | --- |
| Сохранить состояние вручную | `Prefix Ctrl+S` |
| Восстановить состояние вручную | `Prefix Ctrl+R` |
| Отсоединиться (сессии продолжают жить) | `Prefix d` |
| Подключиться заново из shell | `tmux attach` или новый Ghostty |
| Список сессий на сервере | `tmux ls` |

Восстанавливаются: сессии, окна, их имена и порядок, разбиение на панели,
layout, рабочие каталоги, содержимое scrollback каждой панели и процессы из
списка `@resurrect-processes` (`nvim`, `lazygit`, `yazi`, `k9s`, `btop`,
`lazydocker`, `broot`, `jless`, `lnav`, `glow`, `ssh`, клиенты БД).

Агентские CLI намеренно **не** перезапускаются: панель возвращается в нужном
каталоге и со своим текстом, но десяток агентов автоматически не поднимается.
Включить это можно, дописав в `@resurrect-processes` в
[`tmux.plugins.conf`](../tmux/tmux.plugins.conf):
`"~claude->claude --continue" "~codex->codex resume --last"`.

### Сессии

| Сценарий | Сочетание |
| --- | --- |
| Дерево сессий и окон | `Prefix s` |
| Менеджер сессий SessionX | `Prefix o` |
| Новая сессия | `Prefix C` |
| Переименовать сессию | `Prefix $` |
| Убить сессию (с подтверждением) | `Prefix X` |
| Предыдущий/следующий клиент | `Prefix (` / `Prefix )` |
| Приостановить клиента | `Prefix Ctrl+Z` |

### Окна (вкладки)

| Сценарий | Сочетание |
| --- | --- |
| Создать окно в текущем каталоге | `Prefix c` |
| **Переименовать окно** | `Prefix ,` |
| Закрыть окно (с подтверждением) | `Prefix &` |
| Окно по номеру | `Prefix 1`…`Prefix 9`, `Prefix 0` — десятое |
| Выбрать окно по индексу через промпт | `Prefix '` |
| Предыдущее/следующее окно | `Prefix Ctrl+H` / `Prefix Ctrl+L` |
| Предыдущее окно (стандартное) | `Prefix p` |
| Последнее активное окно | `Prefix Tab` |
| Окно с уведомлением: следующее/предыдущее | `Prefix M-n` / `Prefix M-p` |
| Сдвинуть окно влево/вправо по порядку | `Prefix <` / `Prefix >` |
| **Переместить окно на конкретный индекс** | `Prefix .` |
| Информация об окне | `Prefix i` |

Окна перенумеровываются автоматически (`renumber-windows on`), нумерация
начинается с единицы. Имя окна ставится автоматически по текущей команде, пока
его не переименовали вручную.

### Панели: создание и фокус

| Сценарий | Сочетание |
| --- | --- |
| Split вправо | `Prefix \|` или `Prefix \\` |
| Split вниз | `Prefix -` или `Prefix _` |
| **Плавающая панель** | `Prefix *` |
| Фокус влево/вниз/вверх/вправо | `Prefix h` / `j` / `k` / `l` |
| То же стрелками | `Prefix ←` / `↓` / `↑` / `→` |
| Последняя активная панель | `Prefix ;` |
| Показать номера панелей | `Prefix q` |
| Закрыть панель (с подтверждением) | `Prefix x` |
| Развернуть/свернуть панель на весь экран | `Prefix z` |
| **Вынести панель в отдельное окно** | `Prefix !` |
| Ввод одновременно во все панели | `Prefix S` |

### Панели: размер

| Сценарий | Сочетание |
| --- | --- |
| **Растянуть/сузить на 5** | `Prefix H` / `J` / `K` / `L` (повторяемые) |
| То же стрелками | `Prefix M-←` / `M-↓` / `M-↑` / `M-→` |
| **Точная подгонка на 1** | `Prefix M-h` / `M-j` / `M-k` / `M-l` |
| Стандартный resize на 1 | `Prefix Ctrl+←` / `Ctrl+↓` / `Ctrl+↑` / `Ctrl+→` |
| Выровнять панели поровну | `Prefix E` |

Повторяемые сочетания (`-r`) можно жать подряд без повторного `Prefix` в течение
600 мс. Мышью панели тоже тянутся: `mouse on` включён.

### Панели: перемещение и раскладки

| Сценарий | Сочетание |
| --- | --- |
| **Поменять панель местами с соседней** | `Prefix {` / `Prefix }` |
| Прокрутить панели по кругу | `Prefix Ctrl+O` / `Prefix M-o` (в обратную) |
| Отметить панель / снять отметку | `Prefix M` / `Prefix m` |
| Следующая раскладка по кругу | `Prefix Space` |
| main-horizontal / main-vertical | `Prefix M-1` / `Prefix M-2` |
| tiled | `Prefix M-3` |
| even-horizontal / even-vertical | `Prefix M-4` / `Prefix M-5` |
| Зеркальные main-* | `Prefix M-6` / `Prefix M-7` |
| Dev layout 70/30 | `Prefix D` |
| IDE layout: main + две панели справа | `Prefix I` |

### Copy mode

Раскладка emacs (`mode-keys emacs`), выделение мышью не сбрасывается по
отпусканию кнопки.

| Сценарий | Сочетание |
| --- | --- |
| Войти в copy mode | `Prefix [` |
| Войти и сразу пролистать вверх | `Prefix PgUp` |
| Начать выделение | `Space` |
| Прямоугольное выделение | `Ctrl+Space` |
| Скопировать и выйти | `Enter` |
| Выйти без копирования | `Escape`, `q` или `Ctrl+G` |
| Поиск назад/вперёд | `Ctrl+R` / `Ctrl+S` |
| В начало/конец истории | `M-<` / `M->` |
| Перейти к строке | `g` |
| Вставить буфер | `Prefix ]` |
| Список буферов / выбрать буфер | `Prefix #` / `Prefix =` |
| Скопировать текущую строку | `Prefix y` |
| Скопировать путь текущей панели | `Prefix Y` |
| Подсказки-хинты для копирования | `Prefix T` |
| Fuzzy-поиск по содержимому панели | `Prefix e` |
| Открыть URL из панели через FZF | `Prefix u` |

### Popups, плагины и служебное

| Сценарий | Сочетание |
| --- | --- |
| Lazygit | `Prefix g` |
| Btop | `Prefix b` |
| Yazi | `Prefix y` |
| Поиск файла и открытие в редакторе | `Prefix f` |
| Заметки `~/notes.md` | `Prefix n` |
| Меню tmux-fzf | `Prefix F` |
| Перезагрузить конфиг | `Prefix r` |
| Перерисовать экран | `Prefix Ctrl+L` |
| Очистить scrollback | `Prefix Ctrl+K` |
| Показать/скрыть статус-бар | `Prefix t` |
| Командная строка tmux | `Prefix :` |
| Список всех сочетаний | `Prefix ?` |
| Описать одно сочетание | `Prefix /` |
| Показать сообщения сервера | `Prefix ~` |
| Установить/обновить/почистить плагины | `Prefix I` / `Prefix U` / `Prefix M-u` |
| Отправить сам `Ctrl+A` в приложение | `Prefix Ctrl+B` |

### Agent sidebar

Панель отслеживает панели Claude Code, Codex и OpenCode во всех сессиях и окнах
сразу: статус, промпты, вызовы инструментов, состояние Git, активность и
worktrees.

| Сценарий | Сочетание |
| --- | --- |
| **Показать/скрыть в текущем окне** | `Prefix a` |
| **Показать/скрыть во всех окнах** | `Prefix A` |

Апстрим по умолчанию вешает это на `e`/`E`; здесь `e` уже занят extrakto, а `E` —
стандартным `select-layout -E`, поэтому переключатели переехали на `a` — agent.
Ширина и сторона настраиваются через `@sidebar_width` и `@sidebar_position` в
[`tmux.plugins.conf`](../tmux/tmux.plugins.conf).

Sidebar видит только тех агентов, которые сами о себе сообщают через hooks.
Апстрим предлагает подключать это руками — в Claude Code через
`/plugin marketplace add` и `/plugin install`, в Codex через жёлтый значок `ⓘ` и
вставку сниппета в панель. Здесь и то и другое делает Ansible при установке
конфига, чтобы после переустановки не остаться с пустой панелью без объяснений:

- Claude Code — `claude plugin marketplace add` и `claude plugin install`,
  обе задачи пропускаются, если плагин уже стоит;
- Codex — `codex_hooks = true` в `~/.codex/config.toml` и слияние hooks в
  `~/.codex/hooks.json`. `tmux-agent-sidebar setup codex` только печатает JSON,
  поэтому слияние делает
  [`configure-codex-sidebar.py`](../roles/dotfiles/files/configure-codex-sidebar.py):
  существующие hooks сохраняются, записи сопоставляются по команде, перед
  изменением пишется `.bak`.

Прогнать вручную: `ansible-playbook -i inventory/hosts.ini all.yml --tags agent-sidebar`.
Codex нужно перезапустить после первого изменения `config.toml`.

### Чего нет

- Нет сочетания для переноса панели в другое окно (`join-pane`). Только через
  командную строку: `Prefix :` и `join-pane -t :N`.
- Нет сочетания для переименования отдельной панели (`select-pane -T`).
- Нет сочетания для перемещения окна между сессиями (`move-window -t sess:`).
- `@continuum-boot` выключен намеренно: автозапуск при логине делает
  собственный LaunchAgent, headless и без привязки к конкретному терминалу.
- LaunchAgent не поднимает сервер заново, если тот был убит вручную
  (`KeepAlive` не выставлен): `tmux start-server` сразу отсоединяется, и launchd
  принял бы это за падение. Следующий терминал поднимет сервер сам.
- `Prefix Ctrl+J` не занят: `Ctrl+H`/`Ctrl+L` листают окна, но вертикальной пары
  к ним нет.

### Workmux

| Сценарий | Команда/сочетание |
| --- | --- |
| Workmux menu | `Prefix`, затем `w`, затем command key |
| Список/открытие worktrees | `Prefix W` или `Prefix w w` |
| Создать worktree + Tmux session | `wm add BRANCH` |
| Список worktrees | `wm list` |
| Открыть существующий | `wm open BRANCH` |
| Завершить слиянием | `wm merge` |

Workmux не копирует `.env`, не линкует `node_modules`, не устанавливает
зависимости и не удаляет worktree после merge автоматически. Agents tab и
отслеживание Codex требуют явного `workmux setup`; он не выполняется
автоматически, поскольку изменяет конфигурацию Codex.

`Prefix+w` открывает меню Workmux. Внутри меню доступны `w` (worktrees
dashboard — создание и открытие worktrees из TUI), `a` (agents dashboard),
`d` (diff dashboard), `s` (session sidebar), `r` (resurrect), `b` (rebase),
`m` (merge), `c` (close) и `?` (документация). Rebase, merge и close требуют
подтверждения и запускаются в popup из текущей директории. `Prefix+W` сохранён
как прямое открытие worktrees dashboard.

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

### Starship prompt

В prompt постоянно отображаются локальные данные: время, длительность
последней команды, ветка и состояние Git. Git появляется только внутри
репозитория. В каталогах с Docker-файлом или compose-маркером показывается
только непустой/переопределённый Docker context; Kubernetes показывает context,
а Helm — установленную версию Helm (не context). Также отображаются версии
обнаруженных инструментов (Node, Python, Go, Rust, .NET, Swift, Java, Lua,
PHP, Ruby, Terraform, Buf и package manager). Сетевые запросы не выполняются.
`command_timeout = 250ms` ограничивает отдельную внешнюю проверку модуля, а не
весь prompt; если инструмент перегружен, соответствующий модуль исчезает до
следующего prompt, а shell остаётся отзывчивым.

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
