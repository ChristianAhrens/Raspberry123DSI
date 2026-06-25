---
title: Raspberry123DSI — Build Guide
description: Step-by-step build and configuration guide for the Raspberry Pi 5 kiosk system with DSI touchscreen in a laser-cut rack enclosure.
github_url: https://github.com/ChristianAhrens/Raspberry123DSI
icon: ../assets/RackEnclosure-UpmixProtoUI.jpeg
docs_path: ./
no_hero: true
---

# Raspberry123DSI

A Raspberry Pi 5 kiosk system running three audio applications side-by-side on a 12.3" DSI touchscreen, housed in a self-built laser-cut plywood rack enclosure. This guide walks through the full build and configuration from enclosure assembly to audio routing.

<img class="hero-img" src="../assets/RackEnclosure-InStudioRack.jpeg" alt="Raspberry123DSI installed in studio rack">

## Gallery

<div class="gallery">

<div class="gallery-item" data-src="../assets/RackEnclosure-UpmixProtoUI.jpeg" onclick="openLightbox(this)">
<img src="../assets/RackEnclosure-UpmixProtoUI.jpeg" alt="Prototype UI on screen">
<span class="gallery-caption">Prototype UI on screen</span>
</div>

<div class="gallery-item" data-src="../assets/RackEnclosure-InStudioRack.jpeg" onclick="openLightbox(this)">
<img src="../assets/RackEnclosure-InStudioRack.jpeg" alt="Installed in studio rack">
<span class="gallery-caption">Installed in studio rack</span>
</div>

<div class="gallery-item" data-src="../assets/RackEnclosure-PaintJob.jpeg" onclick="openLightbox(this)">
<img src="../assets/RackEnclosure-PaintJob.jpeg" alt="Paint job — finished enclosure">
<span class="gallery-caption">Paint job</span>
</div>

<div class="gallery-item" data-src="../assets/RackEnclosure-Backpanel.jpeg" onclick="openLightbox(this)">
<img src="../assets/RackEnclosure-Backpanel.jpeg" alt="Back panel view">
<span class="gallery-caption">Back panel</span>
</div>

<div class="gallery-item video-thumb" data-src="../assets/RackEnclosure-BootupUpmixProto.mp4" data-type="video" onclick="openLightbox(this)">
<img src="../assets/RackEnclosure-UpmixProtoUI.jpeg" alt="Boot-up video">
<span class="gallery-play">&#x25B6;</span>
<span class="gallery-caption">Boot-up video</span>
</div>

</div>

## System Overview

| Component | Details |
|:----------|:--------|
| **Controller** | Raspberry Pi 5 (64-bit Raspberry Pi OS, Debian Trixie) |
| **Display** | Waveshare 12.3" DSI touchscreen (720×1920, rotated 270°) |
| **Display config** | kanshi (Wayland output profile daemon) |
| **Window Manager** | Sway (Wayland compositor, tile-based) |
| **Audio interface** | RME Digiface Dante (USB, 16×16, 48kHz/32-bit) via ALSA |
| **Network** | Ethernet with IPv4 link-local for Dante device discovery |
| **Applications** | Mema.Mo (audio monitor) · Umsci (DS100 control) · Mema.Re (remote) |

## Build Guide

Follow these steps to build and configure the system from scratch:

<div class="guide-cards">

<a class="guide-card" href="rack-assembly.html">
<div class="guide-card-step">Step 1</div>
<div class="guide-card-title">Enclosure Assembly</div>
<div class="guide-card-desc">Laser-cut part list, layer stack order, dimensions, and photos of the finished rack enclosure.</div>
</a>

<a class="guide-card" href="os-setup.html">
<div class="guide-card-step">Step 2</div>
<div class="guide-card-title">OS Setup</div>
<div class="guide-card-desc">Raspberry Pi OS configuration: bootloader, kernel parameters, Sway window manager, kanshi display profile, and session startup.</div>
</a>

<a class="guide-card" href="audio-config.html">
<div class="guide-card-step">Step 3</div>
<div class="guide-card-title">Audio Configuration</div>
<div class="guide-card-desc">ALSA/Dante routing, LV2 DSP plugin chain setup, and audio device configuration for the RME Digiface Dante.</div>
</a>

</div>

## Files

All raw configuration files are in the [config/](https://github.com/ChristianAhrens/Raspberry123DSI/tree/main/config) directory of the repository.

All laser-cut SVG files are in the [assets/](https://ChristianAhrens.github.io/Raspberry123DSI/assets/) directory of the deployed site.

## Related Projects

| Project | Description |
|:--------|:------------|
| [**Umsci**](https://github.com/ChristianAhrens/Umsci) | Spatial audio control surface for d&b Soundscape DS100 |
| [**Mema**](https://github.com/ChristianAhrens/Mema) | Audio matrix routing family (Mema, Mema.Mo, Mema.Re) |

---

*Use what is provided here at your own risk.*
