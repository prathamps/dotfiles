#!/bin/bash
# Install Pop!_OS (COSMIC) dotfiles: copies configs into place and
# enables the user services. Idempotent — safe to re-run.
set -euo pipefail
cd "$(dirname "$0")"

echo ">> Packages (needs sudo): wl-clipboard flameshot btop cosmic-monitor"
sudo apt install -y wl-clipboard flameshot btop cosmic-monitor

echo ">> COSMIC configs"
mkdir -p ~/.config/cosmic
cp -r cosmic/* ~/.config/cosmic/

echo ">> Scripts -> ~/.local/bin"
mkdir -p ~/.local/bin
cp scripts/* ~/.local/bin/
chmod +x ~/.local/bin/flameshot-wayland ~/.local/bin/clipboard-persist-store ~/.local/bin/clipboard-persist-worker

echo ">> Flameshot config"
mkdir -p ~/.config/flameshot
cp flameshot/flameshot.ini ~/.config/flameshot/

echo ">> D-Bus service override (flameshot must launch with Wayland env)"
mkdir -p ~/.local/share/dbus-1/services
cp dbus-services/org.flameshot.Flameshot.service ~/.local/share/dbus-1/services/

echo ">> systemd user services"
mkdir -p ~/.config/systemd/user
cp systemd-user/*.service ~/.config/systemd/user/
systemctl --user daemon-reload
systemctl --user enable --now clipboard-persist.service flameshot.service

echo ">> Minimon panel applet (flatpak)"
if ! flatpak info io.github.cosmic_utils.minimon-applet >/dev/null 2>&1; then
  flatpak install --user -y cosmic io.github.cosmic_utils.minimon-applet || \
    echo "   (install manually from the COSMIC Store if the 'cosmic' remote is missing)"
fi

echo ">> Wallpaper (RDR2 press screenshot, not kept in repo)"
mkdir -p ~/Pictures/Wallpapers
[ -f ~/Pictures/Wallpapers/rdr2-sunset.jpg ] || curl -sSL -o ~/Pictures/Wallpapers/rdr2-sunset.jpg \
  "https://shared.akamai.steamstatic.com/store_item_assets/steam/apps/1174180/ss_d1a8f5a69155c3186c65d1da90491fcfd43663d9.1920x1080.jpg"

echo "Done. Log out/in (or restart cosmic-panel) to pick up panel/theme changes."
