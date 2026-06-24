---
title: OS Setup — Raspberry123DSI
description: "Complete Raspberry Pi OS configuration: bootloader, kernel, Sway window manager, splash screen."
github_url: https://github.com/ChristianAhrens/Raspberry123DSI
icon: rack_enclosure/RackEnclosure-UpmixProtoUI.jpeg
---

# OS Setup

Complete Raspberry Pi OS configuration for the kiosk system. All configuration files are in the [config/](https://github.com/ChristianAhrens/Raspberry123DSI/tree/main/config) directory of the repository.

## Boot Configuration

### config.txt — Firmware Configuration

Located at `/boot/firmware/config.txt` on the Pi:

```ini
# Enable audio (loads snd_bcm2835)
dtparam=audio=on

# Enable DRM VC4 V3D driver
dtoverlay=vc4-kms-v3d
max_framebuffers=2

# DSI display (12.3" Waveshare, 4-lane)
dtoverlay=vc4-kms-dsi-waveshare-panel-v2,12_3_inch_a_4lane

# Disable firmware video setup (use kernel's default)
disable_fw_kms_setup=1

# 64-bit mode
arm_64bit=1

# Disable overscan
disable_overscan=1

# Maximum firmware speed
arm_boost=1
```

Key settings:
- **`dtoverlay=vc4-kms-v3d`** — Enables the DRM/KMS graphics driver required for Wayland/Sway
- **`dtoverlay=vc4-kms-dsi-waveshare-panel-v2,12_3_inch_a_4lane`** — Configures the DSI display driver for the 12.3" Waveshare panel (4-lane DSI)
- **`max_framebuffers=2`** — Allows two framebuffers (one for console, one for Sway)
- **`disable_fw_kms_setup=1`** — Prevents the firmware from setting an initial video mode; the kernel handles it via cmdline.txt

### cmdline.txt — Kernel Boot Parameters

Located at `/boot/firmware/cmdline.txt` on the Pi (single line):

```
console=serial0,115200 console=tty1 root=PARTUUID=ff12f123-02 rootfstype=ext4 fsck.repair=yes rootwait quiet splash plymouth.ignore-serial-consoles cfg80211.ieee80211_regdom=D fbcon=rotate:3
```

Key parameters:
- **`console=serial0,115200 console=tty1`** — Serial console on GPIO + virtual terminal 1
- **`quiet splash`** — Quiet boot with splash screen (Plymouth)
- **`plymouth.ignore-serial-consoles`** — Prevents Plymouth from interfering with serial output
- **`cfg80211.ieee80211_regdom=D`** — Sets WiFi regulatory domain to Germany
- **`fbcon=rotate:3`** — Rotates the framebuffer console 270° (matches the 270° screen rotation)

## Window Manager: Sway

Configuration at `~/.config/sway/config`:

```
# No window tile frames, but a little gap
default_border none
default_floating_border none
gaps inner 3
gaps outer 3

# Output setup (DSI display rotated 270°)
output DSI-2 transform 270

# Launch apps side by side on startup
exec ~/.config/sway/launchAndLayout.sh

# Force all windows to tile horizontally
default_orientation horizontal

# Kiosk hardening
bindsym --inhibited Control+q exit
```

Key settings:
- **`output DSI-2 transform 270`** — Rotates the DSI display 270° (portrait mode)
- **`gaps inner 3` / `gaps outer 3`** — 3px gaps between windows and screen edges
- **`default_border none`** — No window borders (kiosk mode)

## Application Launcher

Script at `~/.config/sway/launchAndLayout.sh`:

```bash
#!/bin/sh

# Launch apps sequentially, waiting for each to register before starting the next
MemaMo --noconfigui --noupdates &
sleep 1
Umsci --noupdates &
sleep 1
MemaRe --noconfigui --noupdates &
sleep 2

# Window sizing (proportional widths)
swaymsg '[class="Mema.Mo"] resize set width 25ppt'
swaymsg '[class="Umsci"] resize set width 55ppt'
swaymsg '[class="Mema.Re"] resize set width 20ppt'
```

Applications launch in sequence with a 1–2 second delay between each (allowing registration with the window manager), then are sized proportionally: Mema.Mo 25%, Umsci 55%, Mema.Re 20%.

## Session Startup

Configuration at `~/.bash_login`:

```bash
# Start tmux on login
if command -v tmux &> /dev/null && [ -z "$TMUX" ]; then
  tmux new-session -d -s main \; \
    split-window -h \; \
    split-window -v -t main:0.0 \; \
    send-keys -t main:0.0 'sway' Enter \; \
    send-keys -t main:0.1 'while true; do Mema --headless --noupdates; echo "[mema] exited with $?, restarting in 3s..."; sleep 3; done' Enter \; \
    send-keys -t main:0.2 'btop' Enter \; \
    attach-session -t main
fi
. "$HOME/.cargo/env"
```

On login, tmux creates a 3-pane layout:
- **Pane 0** — Starts Sway (the graphical kiosk)
- **Pane 1** — Runs Mema in headless mode with auto-restart on crash
- **Pane 2** — Runs `btop` (system monitor)

This provides a debugging-friendly setup: if Sway crashes, the other two panes remain accessible for diagnostics.

## Boot splash screen

To set a custom boot splash screen:

```bash
sudo cp Downloads/dbaudio-soundscape-logo_rot.png /usr/share/plymouth/themes/pix/splash.png
sudo update-initramfs -u
```

## Optional: Time Protocol (PTP)

For precision time synchronization with the Dante network, a statime PTP daemon can be configured:

```ini
# /etc/systemd/system/statime.service
[Unit]
Description=statime PTP daemon
After=network.target

[Service]
Type=simple
User=root
ExecStart=/path/to/statime -c /path/to/inferno-ptv1.toml
Restart=on-failure
RestartSec=3

[Install]
WantedBy=multi-user.target
```

---

*Use what is provided here at your own risk.*
