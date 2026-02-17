# 🐧 Guía de Instalación Arch Linux + Hyprland

📍 **[English Version](README.md)** | [Versión en Español]

---

## 1️⃣ Crear USB booteable

Descargar ISO desde:
👉 [Arch Linux](https://archlinux.org/download/)

Grabar en USB con:
👉 [Ventoy](https://www.ventoy.net/en/download.html)

## 2️⃣ Conectarse a internet (WiFi)

Antes de usar archinstall, conectar red:

```bash
iwctl
```

Dentro de iwctl:

```bash
device list
station wlan0 scan
station wlan0 get-networks
station wlan0 connect NOMBRE_DE_TU_RED
exit
```

Verificar conexión:

```bash
ping archlinux.org
```

## 3️⃣ Instalar Arch con archinstall

```bash
archinstall
```

### Configurar:

- **Language:** English
- **Disk:** SSD principal
- **Filesystem:** ext4
- **Bootloader:** systemd-boot
- **Profile:** Desktop
- **Desktop:** Hyprland
- **Audio:** pipewire
- **Network:** NetworkManager
- **User:** crear usuario normal (NO trabajar como root)

Instalar y reiniciar.

## 4️⃣ Instalar dotfiles de Hyprland

### Repositorio:
🔗 https://github.com/end-4/dots-hyprland

### Clonar:

```bash
git clone https://github.com/end-4/dots-hyprland
cd dots-hyprland
```

### Dar permisos:

```bash
chmod +x setup.sh
```

### Ejecutar:

```bash
./setup.sh
```

### Reiniciar:

```bash
reboot
```

## 5️⃣ Instalar yay (AUR helper)

Si no está instalado:

```bash
sudo pacman -S --needed base-devel git
git clone https://aur.archlinux.org/yay.git
cd yay
makepkg -si
```

## 6️⃣ Instalar aplicaciones principales

### 🔹 Visual Studio Code

```bash
yay -S visual-studio-code-bin
```

### 🔹 Discord

```bash
yay -S discord
```

---

## 🔐 Respaldo importante (ANTES de formatear)

### Exportar:

- Bookmarks del navegador
- Contraseñas exportadas
- Carpeta `~/.ssh`
- Claves GPG
- `.gitconfig`
- Proyectos importantes
- Wallpapers
- Configuración de Hyprland si la modificaste

---

## 📸 Mi Setup Actual

Aquí están algunos screenshots de mi configuración con Hyprland:

<div align="center">

![Setup Screenshot 1](image.png "Mi primera captura de pantalla")

![Setup Screenshot 2](image-1.png "Segunda vista del setup")

![Setup Screenshot 3](image-2.png "Tercera captura del ambiente de trabajo")

</div>
