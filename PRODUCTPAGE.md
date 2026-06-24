---
title: Raspberry123DSI
description: A Raspberry Pi 5-based kiosk system running three audio applications on a DSI touchscreen. Reference docs, config files, and laser-cut enclosure drawings.
github_url: https://github.com/ChristianAhrens/Raspberry123DSI
icon: rack_enclosure/RackEnclosure-UpmixProtoUI.jpeg
---

# Raspberry123DSI

A Raspberry Pi 5-based self-build rack enclosure system running three audio applications (Mema, Mema.Mo, Mema.Re) in a tiled kiosk mode on a 12.3" DSI touchscreen. This repository provides the reference documentation, configuration files, and laser-cut enclosure vector graphics needed to build and configure the system.

::: {.cta}
[GitHub Repository](https://github.com/ChristianAhrens/Raspberry123DSI)

[Config Reference](config/)

[Enclosure Drawings](assets/)
:::

---

## System Architecture

```
┌─────────────────────────────────────────────────────────────┐
│  d&b Soundscape DS100 (network)                              │
│         ↕ OCA/OCP.1 protocol                                 │
│  ┌───────────────────────────────────────────────────────┐  │
│  │  Raspberry Pi 5                                        │  │
│  │  ┌─────────────────────────────────────────────────┐  │  │
│  │  │  Raspberry Pi OS (64-bit)                        │  │  │
│  │  │  ┌───────────────────────────────────────────┐  │  │  │
│  │  │  │  Sway (Wayland compositor)                 │  │  │  │
│  │  │  │  ┌──────────┬──────────┬───────────────┐  │  │  │  │
│  │  │  │  │ Mema.Mo  │  Umsci   │  Mema.Re      │  │  │  │  │
│  │  │  │  │  25%     │   55%    │    20%        │  │  │  │  │
│  │  │  │  └──────────┴──────────┴───────────────┘  │  │  │  │
│  │  │  │  ALSA → RME Dante (16×16, 48kHz)          │  │  │  │
│  │  │  └───────────────────────────────────────────┘  │  │  │
│  │  └─────────────────────────────────────────────────┘  │  │
│  └───────────────────────────────────────────────────────┘  │
│         ↕ DSI (720×1920, rotated 270°)                       │
│  ┌───────────────────────────────────────────────────────┐  │
│  │  12.3" DSI Touchscreen (Waveshare)                     │  │
│  └───────────────────────────────────────────────────────┘  │
└─────────────────────────────────────────────────────────────┘
```

## Hardware

The rack enclosure is a multi-layer laser-cut assembly designed for professional audio integration:

| Layer | Material | Thickness | Qty |
|:------|:---------|:----------|:----|
| 01_Designfront | Plywood | 3mm | 1× |
| 02_Front | Plywood | 6mm | 1× |
| 03_DSIScreenBodycutout | Plywood | 3mm | 1× |
| 04_DSIScreenMounting | Plywood | 6mm | 1× |
| 05_DualVolumeBody | Plywood | 6mm | 3× |
| 06_SingleVolumeBody | Plywood | 10mm | 10× |
| 07_DualVolumeBody_BackplateMount | Plywood | 6mm | 1× |
| 08_BackplateWFan | Plywood | 6mm | 1× |

**Total depth:** ~139mm (front panels 9mm + body stack 130mm)

Full SVG vector files for laser cutting are available in the [rack_enclosure/](https://github.com/ChristianAhrens/Raspberry123DSI/tree/main/rack_enclosure) directory.

## Software Configuration

All Raspberry Pi OS configuration files are provided in the [config/](config/) directory:

- **config.txt** — Firmware configuration (DRM/KMS, DSI panel overlay, audio enablement)
- **cmdline.txt** — Kernel boot parameters (console rotation, splash screen, WiFi regulatory domain)
- **config** — Sway window manager configuration (output setup, app launching, window sizing)
- **asound.conf** — ALSA plugin configuration for RME Dante interface (16-channel stereo routing at 48kHz/32-bit)
- **bash_login** — Automatic session startup (tmux → Sway + headless Mema + system monitor)
- **launchAndLayout.sh** — Application launch sequence with proportional window sizing

## Getting Started

1. **Build the enclosure** — Download the SVG files from `rack_enclosure/`, send to a laser cutter
2. **Prepare the SD card** — Flash Raspberry Pi OS (64-bit) onto the SD card
3. **Deploy configs** — Copy files from `config/` to the appropriate locations on the Pi:
   - `config.txt` + `cmdline.txt` → `/boot/firmware/`
   - `config` → `~/.config/sway/`
   - `asound.conf` → `/etc/`
   - `bash_login` → `~/.bash_login`
   - `launchAndLayout.sh` → `~/.config/sway/`
4. **Boot** — The Pi will automatically start Sway and launch the three audio applications

See the [documentation site](https://ChristianAhrens.github.io/Raspberry123DSI/docs/) for detailed assembly and setup guides.

## Sibling Projects

| Project | Description |
|:--------|:------------|
| [**Umsci**](https://github.com/ChristianAhrens/Umsci) | Spatial audio control surface for d&b Soundscape DS100. macOS, Windows, iOS/iPadOS. |
| [**Mema**](https://github.com/ChristianAhrens/Mema) | Family of audio matrix routing applications (Mema, Mema.Mo, Mema.Re). macOS, Windows, Linux, iOS/iPadOS. |

---

*Open source — use what is provided here at your own risk.*
