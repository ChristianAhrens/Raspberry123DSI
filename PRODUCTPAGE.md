---
title: Raspberry123DSI
description: A Raspberry Pi 5 kiosk system running three audio applications on a DSI touchscreen in a self-built laser-cut rack enclosure.
github_url: https://github.com/ChristianAhrens/Raspberry123DSI
icon: assets/RackEnclosure-UpmixProtoUI.jpeg
docs_path: docs/
no_hero: true
---

# Raspberry123DSI

A Raspberry Pi 5-based self-build rack enclosure system running three audio applications (Mema, Mema.Mo, Mema.Re) in a tiled kiosk mode on a 12.3" DSI touchscreen. This repository provides the reference documentation, configuration files, and laser-cut enclosure vector graphics needed to build and configure the system.

<img class="hero-img" src="assets/RackEnclosure-InStudioRack.jpeg" alt="Raspberry123DSI installed in studio rack">

::: {.cta}
[Build Guide](docs/)

[GitHub Repository](https://github.com/ChristianAhrens/Raspberry123DSI)

[Enclosure Files](assets/)
:::

---

## Gallery

<div class="gallery">

<div class="gallery-item" data-src="assets/RackEnclosure-UpmixProtoUI.jpeg" onclick="openLightbox(this)">
<img src="assets/RackEnclosure-UpmixProtoUI.jpeg" alt="Prototype UI on screen">
<span class="gallery-caption">Prototype UI on screen</span>
</div>

<div class="gallery-item" data-src="assets/RackEnclosure-InStudioRack.jpeg" onclick="openLightbox(this)">
<img src="assets/RackEnclosure-InStudioRack.jpeg" alt="Installed in studio rack">
<span class="gallery-caption">Installed in studio rack</span>
</div>

<div class="gallery-item" data-src="assets/RackEnclosure-PaintJob.jpeg" onclick="openLightbox(this)">
<img src="assets/RackEnclosure-PaintJob.jpeg" alt="Paint job — finished enclosure">
<span class="gallery-caption">Paint job</span>
</div>

<div class="gallery-item" data-src="assets/RackEnclosure-Backpanel.jpeg" onclick="openLightbox(this)">
<img src="assets/RackEnclosure-Backpanel.jpeg" alt="Back panel view">
<span class="gallery-caption">Back panel</span>
</div>

<div class="gallery-item video-thumb" data-src="assets/RackEnclosure-BootupUpmixProto.mp4" data-type="video" onclick="openLightbox(this)">
<img src="assets/RackEnclosure-UpmixProtoUI.jpeg" alt="Boot-up video">
<span class="gallery-play">&#x25B6;</span>
<span class="gallery-caption">Boot-up video</span>
</div>

</div>

## System Architecture

```
┌─────────────────────────────────────────────────────────────┐
│  d&b Soundscape DS100 (network)                              │
│         ↕ OCA/OCP.1 protocol                                 │
│  ┌───────────────────────────────────────────────────────┐  │
│  │  Raspberry Pi 5                                        │  │
│  │  ┌─────────────────────────────────────────────────┐  │  │
│  │  │  Raspberry Pi OS (64-bit, Debian Trixie)         │  │  │
│  │  │  ┌───────────────────────────────────────────┐  │  │  │
│  │  │  │  Sway (Wayland compositor)                 │  │  │  │
│  │  │  │  ┌──────────┬──────────┬───────────────┐  │  │  │  │
│  │  │  │  │ Mema.Mo  │  Umsci   │  Mema.Re      │  │  │  │  │
│  │  │  │  │  25%     │   55%    │    20%        │  │  │  │  │
│  │  │  │  └──────────┴──────────┴───────────────┘  │  │  │  │
│  │  │  │  ALSA → RME Dante (16×16, 48kHz/32-bit)   │  │  │  │
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

The rack enclosure is a multi-layer laser-cut plywood assembly for professional audio integration:

| Component | Details |
|:----------|:--------|
| **Controller** | Raspberry Pi 5 (64-bit Raspberry Pi OS, Debian Trixie) |
| **Display** | Waveshare 12.3" DSI touchscreen (720×1920, rotated 270°) |
| **Audio interface** | RME Digiface Dante (USB, 16×16, 48kHz/32-bit) via ALSA |
| **Enclosure** | Laser-cut plywood (3 mm / 6 mm / 10 mm), ~139 mm total depth |

Full SVG vector files for laser cutting are available in the [assets/](assets/) directory.

## Software

The system boots headlessly into a kiosk mode:

1. **Raspberry Pi OS** boots with DRM/KMS display driver and rotated framebuffer console
2. **Sway** starts via `bash_login`, launching three audio applications tiled side-by-side
3. **Mema.Mo** (25%) — Network-level audio monitoring
4. **Umsci** (55%) — Spatial audio control surface for d&b Soundscape DS100
5. **Mema.Re** (20%) — Remote control interface

All configuration files are in the [config/](https://github.com/ChristianAhrens/Raspberry123DSI/tree/main/config) directory.

## Getting Started

1. **Build the enclosure** — Download SVG files from `assets/`, send to a laser cutter
2. **Prepare the SD card** — Flash Raspberry Pi OS (64-bit) onto the SD card
3. **Deploy configs** — Copy files from `config/` to the appropriate locations on the Pi
4. **Boot** — The Pi automatically starts Sway and launches the three audio applications

See the [build guide](docs/) for detailed step-by-step instructions.

## Sibling Projects

| Project | Description |
|:--------|:------------|
| [**Umsci**](https://github.com/ChristianAhrens/Umsci) | Spatial audio control surface for d&b Soundscape DS100. macOS, Windows, iOS/iPadOS. |
| [**Mema**](https://github.com/ChristianAhrens/Mema) | Family of audio matrix routing applications (Mema, Mema.Mo, Mema.Re). macOS, Windows, Linux, iOS/iPadOS. |

---

*Open source — use what is provided here at your own risk.*
