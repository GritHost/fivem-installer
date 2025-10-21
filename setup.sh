#!/bin/bash

#############################################
# GritHost FiveM Server Installer - Setup
# Quick Installation Wrapper
# Version: 1.0.0
#############################################

# Farben
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
NC='\033[0m'
BOLD='\033[1m'

# Banner
echo -e "${CYAN}${BOLD}"
echo "╔═══════════════════════════════════════════════════════════╗"
echo "║                                                           ║"
echo "║         GritHost FiveM Server Quick Installer             ║"
echo "║                                                           ║"
echo "╚═══════════════════════════════════════════════════════════╝"
echo -e "${NC}\n"

# Prüfen ob curl installiert ist
if ! command -v curl &> /dev/null; then
    echo -e "${YELLOW}[INFO]${NC} curl wird benötigt. Installiere curl..."
    if [ "$EUID" -ne 0 ]; then
        echo -e "${RED}[ERROR]${NC} Bitte führen Sie das Script mit sudo aus!"
        exit 1
    fi
    apt-get update -qq
    apt-get install -y curl
fi

# Hauptinstaller herunterladen und ausführen
INSTALLER_URL="https://raw.githubusercontent.com/GritHost/fivem-installer/main/fivem-installer.sh"

echo -e "${CYAN}[INFO]${NC} Lade FiveM Installer herunter..."
echo -e "${CYAN}[INFO]${NC} URL: $INSTALLER_URL"
echo ""

# Installer herunterladen und direkt ausführen
curl -fsSL "$INSTALLER_URL" | bash

# Exit Code des Installers weitergeben
exit $?
