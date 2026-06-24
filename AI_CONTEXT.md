# AI_CONTEXT.md — Raspberry123DSI

**Purpose:** Complete handoff context for any AI assistant picking up work on this repository. Read this before touching any files.

---

## What This Project Is

A self-build rack enclosure housing a **Raspberry Pi 5** running **Raspberry Pi OS (Debian Trixie / 64-bit aarch64)** in a headless kiosk configuration. The system is designed to sit in a professional audio studio rack alongside a **d&b Soundscape DS100** spatial audio processor. It runs three custom audio applications side-by-side on a rotated 12.3" DSI touchscreen:

- **Mema.Mo** (25–30% screen width) — network-level audio monitoring
- **Umsci** (45–55% screen width) — spatial audio control surface for d&b DS100 via OCA/OCP.1
- **Mema.Re** (20–25% screen width) — remote control interface

In the background, **Mema** runs headless as the audio matrix engine, routing 16×16 channels via ALSA to an **RME Digiface Dante** USB audio interface. The actual DSP is done by an **Illusonic ILupmixLive** LV2 plugin loaded into Mema, performing immersive upmixing (configured in `config/Mema.config`).

The owner is **Christian Ahrens** (GitHub: ChristianAhrens). All the sibling applications (Mema, Mema.Mo, Mema.Re, Umsci) are also his own software.

---

## Repository Role

This repo is **documentation + configuration only** — no application source code. It contains:

1. Reference configuration files for the OS/software stack
2. Laser-cut vector SVG files for the wooden rack enclosure
3. A GitHub Pages documentation site (deployed from `docs/` and root `index.html`)
4. Photos and video of the finished hardware

---

## Hardware Stack

| Component | Detail |
|:----------|:-------|
| SBC | Raspberry Pi 5 (64-bit, aarch64) |
| OS | Raspberry Pi OS (Debian Trixie-based), kernel `6.12.62+rpt-rpi-2712` |
| Display | Waveshare 12.3" DSI touchscreen, 720×1920 native, rotated 270° for landscape use |
| DSI port | DSI-2 (the secondary DSI connector on the Pi 5) |
| Audio interface | RME Digiface Dante (USB), appears as `hw:Dante24290649,0` |
| Enclosure | Custom laser-cut plywood, 8 layers, ~139mm total depth, 3U rack height |

---

## Software Stack

| Layer | Component | Config location |
|:------|:----------|:----------------|
| Session startup | `~/.bash_login` | `config/bash_login` |
| Terminal multiplexer | tmux (3-pane layout on login) | `config/bash_login` |
| Wayland compositor | Sway | `config/config` → `~/.config/sway/config` |
| Display output config | kanshi | `~/.config/kanshi/config` (NOT in repo yet — see Delta section) |
| App launcher | `launchAndLayout.sh` | `config/launchAndLayout.sh` → `~/.config/sway/launchAndLayout.sh` |
| Audio matrix engine | Mema `--headless` | runs in tmux pane 1 |
| DSP plugin | Illusonic ILupmixLive (LV2, proprietary) | `config/Mema.config` |
| ALSA routing | `/etc/asound.conf` | `config/asound.conf` |
| PTP time sync | statime daemon (optional) | `/etc/systemd/system/statime.service` |
| Network link-local | NetworkManager / nmcli | manual (see Delta section) |
| Boot splash | Plymouth `pix` theme | manual override |

### tmux layout on login
- **Pane 0:** `sway` — starts the graphical kiosk
- **Pane 1:** `while true; do Mema --headless --noupdates; ...; sleep 3; done` — headless audio engine with auto-restart
- **Pane 2:** `btop` — system monitor / debug view

---

## Repository File Map

```
README.md                          — High-level project overview
CHANGELOG.md                       — Empty / unreleased
AI_CONTEXT.md                      — This file
COPYING / LICENSE                  — License

config/
  config.txt                       — /boot/firmware/config.txt (Pi firmware)
  cmdline.txt                      — /boot/firmware/cmdline.txt (kernel params)
  config                           — ~/.config/sway/config
  bash_login                       — ~/.bash_login
  launchAndLayout.sh               — ~/.config/sway/launchAndLayout.sh (current)
  launchAndLayout_2026-04-12.sh    — Earlier version kept for reference
  asound.conf                      — /etc/asound.conf
  Mema.config                      — Mema headless XML config (ILupmixLive plugin)
  DOCU.txt                         — Owner's manual scratchpad (source of truth for
                                     config details not yet integrated into docs)
  logo_dbsoundscape.png/.svg       — d&b dbaudio logo assets
  logo_upmixproto.png/.svg         — Upmix prototype logo

rack_enclosure/
  00_All_Layers_Inkscape.svg       — Master SVG with all layers
  00_All_Layers_orderDef.txt       — Layer stack order + dimensions (German notes)
  00_All_Layers_orderDef_2026-04-12-Status.txt — Status snapshot
  01–08 *_Inkscape.svg             — Individual laser-cut layers
  DS100dims.png                    — d&b DS100 dimensional reference image
  RackEnclosure-*.jpeg / *.mp4     — Photos and boot video

docs/
  index.md / index.html            — Documentation landing page
  os-setup.md / os-setup.html      — OS configuration guide
  audio-config.md / audio-config.html — Audio routing guide
  rack-assembly.md / rack-assembly.html — Enclosure assembly guide

PRODUCTPAGE.md                     — Source markdown for the GitHub Pages root index
Resources/Documentation/
  page_template.html               — HTML template used for docs pages
```

---

## GitHub Pages Deployment

The site is deployed at `https://ChristianAhrens.github.io/Raspberry123DSI/`.

**Structure:**
- Root `index.html` — product landing page (generated from `Resources/Documentation/PRODUCTPAGE.md`)
- `docs/` — four HTML doc pages (generated from `docs/*.md` via pandoc or equivalent)
- Navigation in HTML pages links `docs/` sub-pages relative to each other

**Important:** The HTML files in `docs/` use **broken image paths**. The `<img src="rack_enclosure/...">` references in the nav bar and hero icons of `docs/*.html` are relative to the `docs/` directory but the images live at the repo root `rack_enclosure/`. These should be `../rack_enclosure/...` to work correctly. This was an issue before the kernel panic interrupted work — verify before treating pages as correct.

**CSS / Styling:** Dark theme inline CSS in every HTML page (GitHub-dark palette: `#0d1117` bg, `#58a6ff` accent). Each page has a sticky nav, hero icon, and footer. The CSS is duplicated across all four HTML files — there is no shared stylesheet.

---

## Delta: What DOCU.txt Contains vs. What's in the Docs

`config/DOCU.txt` is the owner's raw working notes. Several items in it are NOT yet fully integrated into the documentation or are inconsistent with the deployed docs:

### 1. kanshi display config — MISSING FROM DOCS
DOCU.txt specifies a `~/.config/kanshi/config`:
```
profile {
    output DSI-2 enable scale 1.000000 mode 720x1920@62.976 position 0,0 transform 90
}
```
Note: kanshi uses `transform 90` while the Sway config uses `transform 270`. This is intentional — kanshi and Sway apply rotation in opposite directions in this context. This config is NOT in the repo and NOT documented. It needs to be added to `config/` and to the OS setup docs.

### 2. Link-local Ethernet — MISSING FROM DOCS
DOCU.txt has:
```bash
sudo nmcli con mod "Wired connection 1" ipv4.link-local enabled
```
This enables link-local (RFC 3927, `169.254.x.x`) addressing on the Ethernet interface, which is how Dante devices discover each other without a DHCP server. This is critical for the RME Dante interface to work. Not documented anywhere currently.

### 3. `No .xsession` note
DOCU.txt explicitly notes "No .xsession" — Sway is started purely from `bash_login` via tmux, not via a display manager. This is already implicit in the docs but should be made explicit in the OS setup page.

### 4. `alsa_pcm_inferno` — TODO
DOCU.txt has `###########################\nalsa_pcm_inferno\n###########################\n...todo`. This refers to an ALSA PCM configuration for PTP-synchronized audio rendering (the "inferno" component). Currently incomplete/pending.

### 5. statime PTP daemon — partially documented, paths abstracted
DOCU.txt has the full TOML config and actual binary path. The docs use `/path/to/statime` as placeholder. The TOML config (`inferno-ptpv1.toml`) is present in DOCU.txt and should be added to `config/` and referenced in the docs.

### 6. `(sudo Mema --headless)` note
DOCU.txt has a parenthetical `(sudo Mema --headless)` — this suggests Mema may need root privileges for certain operations (likely real-time audio scheduling / ALSA priorities). Not documented.

### 7. Window size discrepancy
- DOCU.txt: 25% / 55% / 20% (Mema.Mo / Umsci / Mema.Re)
- Deployed `config/launchAndLayout.sh`: 30% / 45% / 25%
- `docs/os-setup.md`: 25% / 55% / 20%
The actual config file is the ground truth; the docs and DOCU.txt may be stale.

---

## Key Technical Facts

- **OS kernel:** `Linux RaspberryPi123DSI 6.12.62+rpt-rpi-2712 #1 SMP PREEMPT Debian 1:6.12.62-1+rpt1 (2025-12-18) aarch64`
- **Display driver:** `dtoverlay=vc4-kms-dsi-waveshare-panel-v2,12_3_inch_a_4lane` — requires KMS/DRM, NOT the legacy fbdev driver
- **No X11 / no display manager:** Wayland only (Sway). Apps must support Wayland natively.
- **Cargo env:** `~/.bash_login` sources `~/.cargo/env` — Rust toolchain is installed (likely for building statime)
- **ALSA card name:** `Dante24290649` — this is the RME hardware serial. Will differ on a different unit; check with `aplay -l`
- **ALSA device:** Configured as `pcm.dante16` plug device in `/etc/asound.conf`, 32ch/48kHz/S32_LE, 1:1 channel map for first 16 channels
- **Mema plugin:** ILupmixLive by Illusonic — commercial/proprietary LV2. The `Mema.config` contains a base64-encoded plugin state blob.
- **WiFi regulatory domain:** Germany (`cfg80211.ieee80211_regdom=D` in cmdline.txt)
- **PTP version:** PTPv1 (not v2), `domain=0`, `priority1=251` (lower priority than Dante hardware at 249)

---

## Completed Work (2026-06-24)

All DOCU.txt integration work was completed in this session:

- Added `config/kanshi` (kanshi display output profile)
- Added kanshi section + link-local networking section to `docs/os-setup.md` and `docs/os-setup.html`
- Removed the abandoned statime/PTP section from `docs/os-setup.md` and `docs/os-setup.html`
- Fixed broken image paths in all four `docs/*.html` files (`src="rack_enclosure/..."` → `src="../rack_enclosure/..."`)
- Fixed broken "Docs" nav link in `docs/*.html` (`href="docs/"` → `href="./"`)
- Updated `README.md` system overview table (added kanshi, link-local, Umsci, corrected RME description)
- Updated `README.md` repo structure listing (added kanshi config file)

**statime/PTP was deliberately omitted** — the owner attempted Dante audio via the RPi5 onboard NIC using the inferno/statime open-source PTP project, but aborted when the use case was not covered. All references to statime, inferno, and PTP have been removed from the docs.

---

## Conventions

- **No Pandoc/build step** tracked in the repo — the `.md` and `.html` files in `docs/` appear to be maintained in sync manually (or via a local pandoc command). When updating docs, both the `.md` and `.html` counterparts need to be updated.
- **Inline CSS** — all CSS is duplicated inside each HTML file. The `Resources/Documentation/page_template.html` may have been the source template.
- **Commit style:** Imperative short summary, no body. See recent commits for style reference.
- All config files in `config/` are the **canonical reference copies** — deploy to Pi by copying to target paths listed in the file map above.

---

*Last updated: 2026-06-24. Session interrupted by macOS kernel panic (OOM at 36GB system RAM).*
