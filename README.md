# 🐧 Arch Linux + Hyprland Setup Guide

📍 **[Versión en Español](README.es.md)** | [English Version]

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
