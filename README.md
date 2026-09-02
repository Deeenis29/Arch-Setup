# 🐧 Arch Linux + Hyprland Setup Guide

📍 **[Versión en Español](README.es.md)**

---

## 1️⃣ Create Bootable USB

Download ISO from:
👉 [Arch Linux](https://archlinux.org/download/)

Write to USB with:
👉 [Ventoy](https://www.ventoy.net/en/download.html)

## 2️⃣ Connect to Internet (WiFi)

Before using archinstall, connect to network:

```bash
iwctl
```

Inside iwctl:

```bash
device list
station wlan0 scan
station wlan0 get-networks
station wlan0 connect YOUR_NETWORK_NAME
exit
```

Verify connection:

```bash
ping archlinux.org
```

## 3️⃣ Install Arch with archinstall

```bash
archinstall
```

### Configure:

- **Language:** English
- **Disk:** Main SSD
- **Filesystem:** ext4
- **Bootloader:** systemd-boot
- **Profile:** Desktop
- **Desktop:** Hyprland
- **Audio:** pipewire
- **Network:** NetworkManager
- **User:** Create normal user (DO NOT work as root)

Install and reboot.

## 4️⃣ Install Hyprland Dotfiles

### Repository:
🔗 https://github.com/end-4/dots-hyprland

### Clone:

```bash
git clone https://github.com/end-4/dots-hyprland
cd dots-hyprland
```

### Grant permissions:

```bash
chmod +x setup.sh
```

### Execute:

```bash
./setup.sh
```

### Reboot:

```bash
reboot
```

## 5️⃣ Install yay (AUR helper)

If not installed:

```bash
sudo pacman -S --needed base-devel git
git clone https://aur.archlinux.org/yay.git
cd yay
makepkg -si
```

## 6️⃣ Install Main Applications

### 🔹 Visual Studio Code

```bash
yay -S visual-studio-code-bin
```

### 🔹 Discord

```bash
yay -S discord
```

### 🔹 Zen Browser

```bash
yay -S zen-browser-bin
```

### 🔹 Gwenview (image viewer)

```bash
sudo pacman -S gwenview
```

### 🔹 Mousepad (lightweight text editor)

```bash
sudo pacman -S mousepad
```

### 🔹 mpv (video/media player)

```bash
sudo pacman -S mpv
```

### 🔹 OnlyOffice (Word/Excel/PowerPoint alternative)

```bash
yay -S onlyoffice-bin
```

## 7️⃣ NVIDIA Driver (Intel + NVIDIA hybrid laptop)

Only needed if the machine has a discrete NVIDIA GPU alongside Intel integrated graphics. The open kernel driver fixes Hyprland stutter on nouveau and is required for GPU-accelerated video editing (DaVinci Resolve).

```bash
sudo pacman -S --needed nvidia-open nvidia-utils nvidia-settings
```

> `nvidia-open` works for Turing GPUs and newer (GTX 16xx / RTX). For older cards use `nvidia` instead.

### Early KMS

Edit `/etc/mkinitcpio.conf` and change `MODULES=()` to:

```
MODULES=(nvidia nvidia_modeset nvidia_uvm nvidia_drm)
```

Then regenerate the initramfs:

```bash
sudo mkinitcpio -P
```

### Boot parameter

Find your systemd-boot entry:

```bash
ls /boot/loader/entries/
sudo nano /boot/loader/entries/<your-entry>.conf
```

Append `nvidia-drm.modeset=1` to the end of the `options` line, e.g.:

```
options root=PARTUUID=... rw rootfstype=ext4 nvidia-drm.modeset=1
```

### Suspend/resume services

```bash
sudo systemctl enable nvidia-suspend.service nvidia-hibernate.service nvidia-resume.service
```

### PRIME offload (use the dGPU only on demand)

Add to `~/.bashrc`, so the Intel GPU stays default (battery) and NVIDIA only kicks in when called explicitly:

```bash
nvidia-offload() {
    __NV_PRIME_RENDER_OFFLOAD=1 __NV_PRIME_RENDER_OFFLOAD_PROVIDER=NVIDIA-G0 \
    __GLX_VENDOR_LIBRARY_NAME=nvidia __VK_LAYER_NV_optimus=NVIDIA_only \
    "$@"
}
```

Usage: `nvidia-offload kdenlive`, `nvidia-offload davinci-resolve`

### Reboot and verify

```bash
reboot
nvidia-smi   # should list the GPU after reboot
```

## 8️⃣ Mapping dots-hyprland (what's safe to edit)

dots-hyprland ("illogical-impulse") uses **Quickshell** (QML), not Waybar, for the bar/dock/sidebars. Key distinction after install:

| Path | Status |
|---|---|
| `~/.config/hypr/custom/*.lua` | ✅ Safe — your layer, never touched by updates. Put keybinds/execs/rules/env here. |
| `~/.config/hypr/hyprland/*.lua` | ⚠️ Managed — overwritten by `./setup exp-update`. |
| `~/.config/quickshell/ii/modules/**/*.qml` | ⚠️ Managed, **no custom/ layer exists here** — editing the bar (`modules/ii/bar/`) means editing managed files directly. |
| In-app settings panel (`settings.qml`) | 🔧 Check here first for common toggles before hand-editing QML. |

**Right after installing dotfiles**, turn your live config into its own git repo so you can always diff/revert experiments:

```bash
cd ~/.config/quickshell && git init && git add -A && git commit -m "initial state"
cd ~/.config/hypr && git init && git add -A && git commit -m "initial state"
```

Full reference with file tree and task table: https://claude.ai/code/artifact/4cbc1c38-d102-46a0-91c4-65c46b216fe2 (private artifact, only visible logged into your account)

## 9️⃣ Tailscale + Syncthing (remote access & phone photo backup)

Purpose: SSH into this machine from anywhere via Tailscale, and auto-sync phone photos in original quality (no more WhatsApp "send as document" workaround).

```bash
sudo pacman -S --needed tailscale syncthing
sudo systemctl enable --now tailscaled
sudo systemctl enable --now syncthing@<your-username>.service
sudo tailscale up   # opens a login URL, authenticate in the browser
```

Syncthing's web UI is at `http://localhost:8384` (localhost-only by default — that's fine, folder pairing only needs to happen once from the machine itself). Install the Syncthing app on the phone, add this PC by Device ID (found in the web UI), accept the folder share from the phone side, then accept it on the PC side and pick a real destination path.

### Gotchas that actually happened here

- **Turn OFF "Introducer" on at least one side.** With it on both ends, the phone auto-shared *every* other folder it had configured (WhatsApp Documents, WhatsApp Images) on top of the one folder we wanted — not obvious until it happens. In the web UI: Remote Devices → your phone → Edit → uncheck Introducer.
- **"Auto Accept Folders" picks the destination path from the folder's label**, which can literally be something like `Camera` — Syncthing then tries `mkdir /Camera` at the filesystem root and fails with `permission denied`. Turn Auto Accept off, or always double-check/fix the path after an auto-accept.
- **Never point two folder definitions at the same or a nested directory.** Doing so (even briefly) risks index corruption. If you catch it, pause the extra folder immediately from the web UI before doing anything else.
- **Moving a folder to a new path triggers `folder marker missing`** (a safety check against writing to the wrong place). Fix: `touch <new-path>/.stfolder`, then trigger a rescan (web UI folder → Rescan, or `POST /rest/db/scan?folder=<id>` with the API key from `~/.local/state/syncthing/config.xml`).
- **If two devices show `Disconnected`/`Never seen` despite being on the same WiFi**, it's almost always Android battery optimization killing the app in the background, not a firewall (Arch ships with no firewall active by default — verified via `systemctl is-active ufw firewalld nftables`, all inactive). Open the app in the foreground once, and disable battery optimization for it.

---

## 🔐 Important Backup (BEFORE formatting)

### Export:

- Browser bookmarks
- Exported passwords
- `~/.ssh` folder
- GPG keys
- `.gitconfig`
- Important projects
- Wallpapers
- Hyprland configuration if you modified it

---

## 📸 My Current Setup

Here are some screenshots of my Hyprland configuration:

<div align="center">

![Setup Screenshot 1](image.png "First screenshot")

![Setup Screenshot 2](image-1.png "Second view of setup")

![Setup Screenshot 3](image-2.png "Third screenshot of work environment")

</div>
