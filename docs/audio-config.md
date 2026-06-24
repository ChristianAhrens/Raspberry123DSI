---
title: Audio Configuration — Raspberry123DSI
description: ALSA/Dante routing, LV2 DSP plugin configuration, and audio device setup.
github_url: https://github.com/ChristianAhrens/Raspberry123DSI
icon: rack_enclosure/RackEnclosure-UpmixProtoUI.jpeg
---

# Audio Configuration

Configuration for routing audio between the Raspberry Pi and the RME Dante audio interface, plus the Mema plugin chain setup.

## ALSA Configuration

The ALSA configuration at `/etc/asound.conf` defines a custom plug device for the RME Dante interface:

```
pcm.dante16 {
    type plug
    slave {
        pcm "hw:Dante24290649,0"
        channels 32
        rate 48000
        format S32_LE
    }
    ttable {
        # input channel (slave side) -> output channel (app side)
        # format: ttable.SLAVE_CH.APP_CH = gain
        0.0   1
        1.1   1
        2.2   1
        3.3   1
        4.4   1
        5.5   1
        6.6   1
        7.7   1
        8.8   1
        9.9   1
        10.10 1
        11.11 1
        12.12 1
        13.13 1
        14.14 1
        15.15 1
    }
}

ctl.dante16 {
    type hw
    card Dante24290649
}
```

Key settings:
- **`type plug`** — Automatically converts between different PCM formats (allows applications to use any format)
- **`channels 32`** — 16 input + 16 output channels (full RME interface capacity)
- **`rate 48000`** — 48kHz sample rate (standard for professional audio)
- **`format S32_LE`** — 32-bit little-endian integer (maximum precision)
- **`ttable`** — 1:1 channel mapping (input 0→output 0, input 1→output 1, etc.)

The card name `Dante24290649` is the RME serial number embedded in the hardware. Replace this with your actual card name if different (check with `aplay -l`).

## DSP Plugin Configuration

Mema loads LV2 plugins at runtime, and the plugin chain is fully configurable through its XML config file (`Mema.config`). The system is plugin-agnostic: any LV2 plugin available for aarch64 can be loaded, including upmixers, equalizers, reverb, and custom DSP processors.

### Example LV2 upmix plugins for aarch64

The following LV2 upmix plugins are available for the Raspberry Pi 5 (aarch64) and can be configured in Mema:

| Plugin | Description | Upmix Formats |
|:-------|:------------|:--------------|
| **Qupmix** (LSP) | Stereo → 5.1 / 7.1 upmixer (Linux Sound Plugins) | 5.1, 7.1 |
| **mbeq** (LSP) | Multi-band EQ — not an upmixer, but commonly paired | — |
| **GVerb** (LV2) | Convolution reverb — spatial enhancement, not upmix | — |
| **calf** (LV2) | Suite with spatial processing modules (chorus, flanger, reverb) | — |

For immersive formats (surround, object-based), proprietary or commercial LV2 upmixers may also be loaded. The system does not impose restrictions on which plugin is used — the config file simply specifies the plugin URI, I/O channel counts, and parameter values.

### Configuring a plugin in Mema

The Mema config XML specifies:
- **`deviceType`** — ALSA (or other backend)
- **`audioDeviceInChans` / `audioDeviceOutChans`** — Which channels are active (`1` = enabled, `0` = muted)
- **`<PLUGIN>`** — Plugin name, format (LV2), file URL, unique ID, I/O channel counts
- **`<PLUGINPARAM>`** — Per-parameter values (gain, mute, format selection, etc.)

A complete example config is available at [config/Mema.config](https://github.com/ChristianAhrens/Raspberry123DSI/blob/main/config/Mema.config) (local reference only — not deployed to the public site).

## Audio Device Setup

The Mema application config (`config/Mema.config`) specifies:

- **Device type:** ALSA
- **Audio output device:** `dante16` (the custom plug device defined above)
- **Audio input device:** `dante16`
- **Sample rate:** 48000 Hz
- **Buffer size:** 512 samples
- **Input channels:** 16 (all enabled)
- **Output channels:** 16 (all enabled)

## Getting the Card Name

To find your RME card name:

```bash
aplay -l
```

Look for a line containing "Dante" — the alphanumeric string after it is the card name to use in `asound.conf`.

---

*Use what is provided here at your own risk.*
