# dotfiles

Configs for every machine I touch, organized by OS → distro → environment.

```
dotfiles/
├── windows/            # Windows 11 tiling setup
│   ├── komorebi/       #   tiling window manager (+ bar)
│   ├── whkd/           #   hotkey daemon
│   └── yasb/           #   status bar
├── linux/
│   └── pop-os/         # Pop!_OS 24.04 · COSMIC (Wayland) — see its README
│       ├── cosmic/     #   theme, panel, shortcuts, wallpaper config
│       ├── scripts/    #   flameshot wrapper, clipboard persistence
│       ├── systemd-user/, dbus-services/, flameshot/, shell/
│       └── install.sh
└── shared/             # cross-platform
    ├── cava/           #   audio visualizer (themes + shaders)
    └── wallpapers/
```

Each Linux environment gets its own folder under `linux/<distro>/` (e.g. a
future `linux/debian/i3/`), with an `install.sh` that puts everything in place.
