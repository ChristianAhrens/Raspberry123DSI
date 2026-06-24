# Raspberry123DSI

A Raspberry Pi 5-based kiosk system for a self-build rack enclosure, running three audio applications (Mema, Mema.Mo, Mema.Re) side by side on a DSI touchscreen via the Sway window manager.

This repository contains the reference documentation, configuration files, and laser-cut enclosure vector graphics needed to build and configure the system.

## System Overview

| Component | Details |
|:----------|:--------|
| **Controller** | Raspberry Pi 5 (64-bit Raspberry Pi OS) |
| **Display** | Waveshare 12.3" DSI touchscreen (720×1920, rotated 270°) |
| **Window Manager** | Sway (Wayland compositor, tile-based) |
| **Audio** | ALSA routed to RME Dante interface (16×16, 48kHz/32-bit) |
| **Applications** | Mema (audio matrix), Mema.Mo (network monitor), Mema.Re (remote control) |

## Hardware

The rack enclosure is designed for d&b Soundscape DS100 integration and consists of laser-cut plywood panels (3mm and 6mm) assembled into a multi-layer body:

- **Front panels** — Design front (3mm) + Front face (6mm) = 9mm total
- **Body** — Dual/single volume bodies, screen mounting, and backplate with fan cutout
- **Total depth** — ~139mm (front + body stack + backplate)

See the [enclosure drawings](https://ChristianAhrens.github.io/Raspberry123DSI/assets/) for full SVG vector files ready for laser cutting.

## Software

The system boots headlessly into a kiosk mode:

1. **Raspberry Pi OS** boots with DRM/KMS display driver and rotated framebuffer console
2. **Sway** starts automatically via `bash_login`, launching three audio applications tiled side-by-side
3. **Mema** (55% width) — Core audio matrix router, configurable with any LV2 upmix or DSP plugin
4. **Mema.Mo** (25% width) — Network-level audio monitoring
5. **Mema.Re** (20% width) — Remote control interface

Configuration files for the OS, audio routing (ALSA/Dante), and window layout are in the [config/](config/) directory.

## Repository Structure

```
README.md              — This file
CHANGELOG.md           — Version history
config/                — Raspberry Pi OS configuration files
│   ├── config.txt     — Firmware / bootloader config
│   ├── cmdline.txt    — Kernel boot parameters
│   ├── config         — Sway window manager config
│   ├── asound.conf    — ALSA Dante audio routing
│   ├── bash_login     — Session startup (Sway + apps)
│   └── launchAndLayout.sh — App launch and window sizing
rack_enclosure/        — Laser-cut enclosure SVGs, product photos, video, BOM
docs/                  — Documentation (assembly, OS setup, audio config)
```

## Deployed Site

A browsable documentation site is deployed to [GitHub Pages](https://ChristianAhrens.github.io/Raspberry123DSI/).

## Sibling Projects

| Project | Description |
|:--------|:------------|
| [**Umsci**](https://github.com/ChristianAhrens/Umsci) | Spatial audio control surface for d&b Soundscape DS100 |
| [**Mema**](https://github.com/ChristianAhrens/Mema) | Family of audio matrix routing applications (Mema, Mema.Mo, Mema.Re) |

## License

Configuration files and documentation are provided under the license specified in [COPYING](COPYING).

---

*Use what is provided here at your own risk.*
