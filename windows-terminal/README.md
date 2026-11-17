# windows-terminal

Windows Terminal settings of the WINOS host, tracked from
`%LOCALAPPDATA%\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState\settings.json`.

The package is deliberately not stowed: Windows owns that path and cannot
follow a WSL-side symlink. Restore by copying the file back into `LocalState`.
