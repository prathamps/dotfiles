# Pop!_OS 24.04 — COSMIC (Wayland)

My daily driver: Pop!_OS with the COSMIC desktop, RDR2-themed.

## What's here

| Path | What it is |
|---|---|
| `cosmic/` | COSMIC config trees (drop into `~/.config/cosmic/`) — RDR2 dark theme (blood-red accent `#D02B28`, sepia-warmed greys), panel layout incl. Minimon applet, custom shortcuts, wallpaper config, compositor/terminal/toolkit settings |
| `scripts/` | Helper scripts for `~/.local/bin` (see below) |
| `systemd-user/` | User services: `flameshot.service`, `clipboard-persist.service` |
| `dbus-services/` | User D-Bus override so flameshot always launches with Wayland env |
| `flameshot/` | Flameshot settings |
| `shell/bashrc` | Bash config |

## Install

```bash
./install.sh
```

## The two gotchas this setup solves

**1. Flameshot on COSMIC/Wayland.** Flameshot needs `QT_QPA_PLATFORM=wayland` and
`XDG_CURRENT_DESKTOP=GNOME` (portal spoof) or it silently runs on Xwayland and
copies screenshots to the X11 clipboard, where Wayland apps can't see them.
Wrapper scripts alone are NOT enough: D-Bus activation spawns the daemon with a
clean environment, bypassing the wrapper. Hence `flameshot.service` (starts the
daemon correctly at login) + the D-Bus service override (catches manual launches).
`Print` is bound to `flameshot-wayland`, `Super+Print` to COSMIC's native tool.

**2. Wayland clears the clipboard when the source app exits** — screenshot something,
the tool closes, your paste is gone. `clipboard-persist.service` watches the
clipboard (`wl-paste --watch`) and re-offers content from a long-lived process.
Split into a launcher (`clipboard-persist-store`, returns instantly — watch
callbacks are sequential and must never block) and a worker
(`clipboard-persist-worker`, flock-serialized with timeouts on every read).
It deliberately skips file-manager copies (`text/uri-list`, `x-special/*`) and
password-manager secrets. Requires `wl-clipboard`.
