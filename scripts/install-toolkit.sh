#!/usr/bin/env bash
# Instala Kdenlive, herramientas modernas de terminal, y Tailscale + Syncthing
# para respaldo de fotos en viajes. No requiere reiniciar.
# Ejecutar con: sudo bash install-toolkit.sh
set -euo pipefail

if [[ $EUID -ne 0 ]]; then
  echo "Corre esto con sudo: sudo bash $0" >&2
  exit 1
fi

echo "== 1/3 Kdenlive (edicion de video) =="
pacman -S --needed kdenlive

echo "== 2/3 Terminal moderna: bat, fzf, zoxide, neovim =="
pacman -S --needed bat fzf zoxide neovim

echo "== 3/3 Tailscale + Syncthing =="
pacman -S --needed tailscale syncthing
systemctl enable --now tailscaled
systemctl enable --now syncthing@denji.service

echo ""
echo "Listo. Pasos que faltan (sin sudo, los hacemos juntos despues):"
echo "  - tailscale up                 (login por navegador, una sola vez)"
echo "  - abrir http://localhost:8384  (Syncthing, agregar tu telefono)"
