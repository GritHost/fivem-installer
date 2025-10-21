#!/bin/bash

#############################################
# GritHost FiveM Server Installer
# Debian 12 Installation Script
# Version: 1.0.0
#############################################

set -e

# Farben für die Ausgabe
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
MAGENTA='\033[0;35m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color
BOLD='\033[1m'

# Banner anzeigen
show_banner() {
    clear
    echo -e "${CYAN}${BOLD}"
    echo "╔═══════════════════════════════════════════════════════════╗"
    echo "║                                                           ║"
    echo "║              GritHost FiveM Server Installer              ║"
    echo "║                    Debian 12 Edition                      ║"
    echo "║                      Version 1.0.0                        ║"
    echo "║                                                           ║"
    echo "╚═══════════════════════════════════════════════════════════╝"
    echo -e "${NC}"
    echo ""
}

# Logging-Funktion
log_info() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

log_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

log_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

log_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Prüfen ob als Root ausgeführt
check_root() {
    if [ "$EUID" -ne 0 ]; then 
        log_error "Dieses Script muss als Root ausgeführt werden!"
        echo -e "${YELLOW}Bitte verwenden Sie: ${BOLD}sudo bash $0${NC}"
        exit 1
    fi
}

# Debian Version prüfen
check_debian_version() {
    log_info "Prüfe Debian Version..."
    if [ -f /etc/os-release ]; then
        . /etc/os-release
        if [ "$ID" != "debian" ]; then
            log_error "Dieses Script ist nur für Debian konzipiert!"
            exit 1
        fi
        if [ "$VERSION_ID" != "12" ]; then
            log_warning "Dieses Script wurde für Debian 12 entwickelt. Ihre Version: $VERSION_ID"
            read -p "Möchten Sie trotzdem fortfahren? (j/n): " continue_anyway
            if [ "$continue_anyway" != "j" ] && [ "$continue_anyway" != "J" ]; then
                exit 1
            fi
        fi
    else
        log_error "Konnte OS-Version nicht ermitteln!"
        exit 1
    fi
    log_success "Debian Version geprüft"
}

# Benutzereingaben sammeln
collect_user_input() {
    show_banner
    echo -e "${BOLD}${MAGENTA}═══ Installationskonfiguration ═══${NC}\n"
    
    # Server Name
    while true; do
        read -p "$(echo -e ${CYAN}Server Name${NC} [Standard: GritHost-FiveM]): " SERVER_NAME
        SERVER_NAME=${SERVER_NAME:-GritHost-FiveM}
        if [[ "$SERVER_NAME" =~ ^[a-zA-Z0-9_-]+$ ]]; then
            break
        else
            log_error "Ungültiger Server Name! Nur Buchstaben, Zahlen, - und _ erlaubt."
        fi
    done
    
    # Installationsverzeichnis
    read -p "$(echo -e ${CYAN}Installationsverzeichnis${NC} [Standard: /opt/fivem]): " INSTALL_DIR
    INSTALL_DIR=${INSTALL_DIR:-/opt/fivem}
    
    # Server Port
    while true; do
        read -p "$(echo -e ${CYAN}Server Port${NC} [Standard: 30120]): " SERVER_PORT
        SERVER_PORT=${SERVER_PORT:-30120}
        if [[ "$SERVER_PORT" =~ ^[0-9]+$ ]] && [ "$SERVER_PORT" -ge 1024 ] && [ "$SERVER_PORT" -le 65535 ]; then
            break
        else
            log_error "Ungültiger Port! Bitte einen Port zwischen 1024 und 65535 eingeben."
        fi
    done
    
    # Max Players
    while true; do
        read -p "$(echo -e ${CYAN}Maximale Spieleranzahl${NC} [Standard: 32]): " MAX_PLAYERS
        MAX_PLAYERS=${MAX_PLAYERS:-32}
        if [[ "$MAX_PLAYERS" =~ ^[0-9]+$ ]] && [ "$MAX_PLAYERS" -ge 1 ] && [ "$MAX_PLAYERS" -le 2048 ]; then
            break
        else
            log_error "Ungültige Spieleranzahl! Bitte eine Zahl zwischen 1 und 2048 eingeben."
        fi
    done
    
    # License Key
    while true; do
        echo -e "\n${YELLOW}Wichtig: Sie benötigen einen FiveM License Key von https://keymaster.fivem.net/${NC}"
        read -p "$(echo -e ${CYAN}FiveM License Key${NC}): " LICENSE_KEY
        if [ -n "$LICENSE_KEY" ]; then
            break
        else
            log_error "License Key darf nicht leer sein!"
        fi
    done
    
    # RCON Password
    while true; do
        read -sp "$(echo -e ${CYAN}RCON Passwort${NC} [für Server-Administration]): " RCON_PASSWORD
        echo ""
        if [ ${#RCON_PASSWORD} -ge 8 ]; then
            break
        else
            log_error "RCON Passwort muss mindestens 8 Zeichen lang sein!"
        fi
    done
    
    # Steam Web API Key (optional)
    echo -e "\n${YELLOW}Optional: Steam Web API Key von https://steamcommunity.com/dev/apikey${NC}"
    read -p "$(echo -e ${CYAN}Steam Web API Key${NC} [Optional, Enter zum Überspringen]): " STEAM_API_KEY
    
    # Systemd Service erstellen?
    read -p "$(echo -e ${CYAN}Systemd Service erstellen?${NC} [j/n, Standard: j]): " CREATE_SERVICE
    CREATE_SERVICE=${CREATE_SERVICE:-j}
    
    # Firewall konfigurieren?
    read -p "$(echo -e ${CYAN}Firewall automatisch konfigurieren?${NC} [j/n, Standard: j]): " CONFIGURE_FIREWALL
    CONFIGURE_FIREWALL=${CONFIGURE_FIREWALL:-j}
    
    # Zusammenfassung anzeigen
    echo -e "\n${BOLD}${MAGENTA}═══ Installationszusammenfassung ═══${NC}"
    echo -e "${CYAN}Server Name:${NC} $SERVER_NAME"
    echo -e "${CYAN}Installationsverzeichnis:${NC} $INSTALL_DIR"
    echo -e "${CYAN}Server Port:${NC} $SERVER_PORT"
    echo -e "${CYAN}Max. Spieler:${NC} $MAX_PLAYERS"
    echo -e "${CYAN}License Key:${NC} ${LICENSE_KEY:0:10}..."
    echo -e "${CYAN}RCON Passwort:${NC} ********"
    echo -e "${CYAN}Steam API Key:${NC} ${STEAM_API_KEY:-Nicht angegeben}"
    echo -e "${CYAN}Systemd Service:${NC} $CREATE_SERVICE"
    echo -e "${CYAN}Firewall konfigurieren:${NC} $CONFIGURE_FIREWALL"
    echo ""
    
    read -p "$(echo -e ${YELLOW}${BOLD}Installation mit diesen Einstellungen starten?${NC} [j/n]): " CONFIRM
    if [ "$CONFIRM" != "j" ] && [ "$CONFIRM" != "J" ]; then
        log_info "Installation abgebrochen."
        exit 0
    fi
}

# System aktualisieren
update_system() {
    log_info "Aktualisiere System-Pakete..."
    apt-get update -qq
    apt-get upgrade -y -qq
    log_success "System aktualisiert"
}

# Abhängigkeiten installieren
install_dependencies() {
    log_info "Installiere erforderliche Abhängigkeiten..."
    
    PACKAGES=(
        "curl"
        "wget"
        "tar"
        "xz-utils"
        "git"
        "ca-certificates"
        "gnupg"
        "lsb-release"
        "ufw"
        "screen"
        "nano"
    )
    
    for package in "${PACKAGES[@]}"; do
        if ! dpkg -l | grep -q "^ii  $package "; then
            log_info "Installiere $package..."
            apt-get install -y -qq "$package"
        fi
    done
    
    log_success "Alle Abhängigkeiten installiert"
}

# FiveM Benutzer erstellen
create_fivem_user() {
    log_info "Erstelle FiveM Systembenutzer..."
    
    if id "fivem" &>/dev/null; then
        log_warning "Benutzer 'fivem' existiert bereits"
    else
        useradd -r -m -d /home/fivem -s /bin/bash fivem
        log_success "Benutzer 'fivem' erstellt"
    fi
}

# FiveM Server herunterladen
download_fivem() {
    log_info "Erstelle Installationsverzeichnis: $INSTALL_DIR"
    mkdir -p "$INSTALL_DIR"
    cd "$INSTALL_DIR"
    
    log_info "Lade FiveM Server herunter..."
    
    # Neueste FXServer Version herunterladen
    FIVEM_URL="https://runtime.fivem.net/artifacts/fivem/build_proot_linux/master/$(curl -s https://runtime.fivem.net/artifacts/fivem/build_proot_linux/master/ | grep -oP '(?<=href=")[0-9]+-[a-f0-9]+(?=/fx\.tar\.xz")' | tail -1)/fx.tar.xz"
    
    wget -q --show-progress "$FIVEM_URL" -O fx.tar.xz
    
    log_info "Entpacke FiveM Server..."
    tar -xf fx.tar.xz
    rm fx.tar.xz
    
    log_success "FiveM Server heruntergeladen und entpackt"
}

# Server-Konfiguration erstellen
create_server_config() {
    log_info "Erstelle Server-Konfiguration..."
    
    mkdir -p "$INSTALL_DIR/server-data/resources"
    mkdir -p "$INSTALL_DIR/server-data/cache"
    
    cat > "$INSTALL_DIR/server-data/server.cfg" <<EOF
## GritHost FiveM Server Configuration
## Generiert am: $(date)

## Server Name
sv_hostname "$SERVER_NAME | Powered by GritHost"

## License Key
sv_licenseKey $LICENSE_KEY

## Server Port
endpoint_add_tcp "0.0.0.0:$SERVER_PORT"
endpoint_add_udp "0.0.0.0:$SERVER_PORT"

## Max Players
sv_maxclients $MAX_PLAYERS

## RCON Password
rcon_password "$RCON_PASSWORD"

## Steam Web API Key
${STEAM_API_KEY:+set steam_webApiKey "$STEAM_API_KEY"}

## Server Tags
sets tags "GritHost, Deutsch, Roleplay"

## Server Locale
sets locale "de-DE"

## Game Build (optional, für spezifische GTA V Versionen)
# sv_enforceGameBuild 2699

## OneSync
onesync on

## Script Hook
sv_scriptHookAllowed 0

## Server Info
sv_projectName "GritHost FiveM Server"
sv_projectDesc "Professioneller FiveM Server gehostet bei GritHost"

## Loading Screen
# load_server_icon myLogo.png
# sets banner_detail "https://your-website.com"
# sets banner_connecting "https://your-website.com/banner.png"

## Resources
ensure mapmanager
ensure chat
ensure spawnmanager
ensure sessionmanager
ensure basic-gamemode
ensure hardcap

## Admin Resources
#ensure admin
#ensure EasyAdmin

## Weitere Ressourcen hier hinzufügen
# ensure your-resource

## Server Commands
add_ace group.admin command allow
add_ace group.admin command.quit deny
add_principal identifier.fivem:1 group.admin

## Logging
set sv_logFile "$INSTALL_DIR/server-data/logs/server.log"

## Performance
set mysql_connection_string "mysql://user:password@localhost/database?charset=utf8mb4"

## Convars
set temp_convar "hey world!"

## Discord Rich Presence
#set discord_appId "your_app_id"
#set discord_largeImageKey "your_image_key"
#set discord_largeImageText "GritHost FiveM Server"

## Server Branding
sv_master1 ""
sv_endpointprivacy true

## Restart Message
sv_shutdownMessage "Server wird neu gestartet... Bitte warten Sie einen Moment."

## Heartbeat
set sv_heartbeatInterval 30000

## Weitere Einstellungen
set sv_enforceGameBuild 2699
set sv_allowDownload true
set sv_downloadUrl ""

EOF

    log_success "Server-Konfiguration erstellt: $INSTALL_DIR/server-data/server.cfg"
}

# Start-Script erstellen
create_start_script() {
    log_info "Erstelle Start-Script..."
    
    cat > "$INSTALL_DIR/start.sh" <<EOF
#!/bin/bash
cd "$INSTALL_DIR/server-data"
exec "$INSTALL_DIR/run.sh" +exec server.cfg
EOF

    chmod +x "$INSTALL_DIR/start.sh"
    log_success "Start-Script erstellt: $INSTALL_DIR/start.sh"
}

# Systemd Service erstellen
create_systemd_service() {
    if [ "$CREATE_SERVICE" == "j" ] || [ "$CREATE_SERVICE" == "J" ]; then
        log_info "Erstelle Systemd Service..."
        
        cat > /etc/systemd/system/fivem.service <<EOF
[Unit]
Description=GritHost FiveM Server
After=network.target

[Service]
Type=simple
User=fivem
WorkingDirectory=$INSTALL_DIR/server-data
ExecStart=$INSTALL_DIR/start.sh
Restart=on-failure
RestartSec=10
StandardOutput=append:$INSTALL_DIR/server-data/logs/console.log
StandardError=append:$INSTALL_DIR/server-data/logs/error.log

[Install]
WantedBy=multi-user.target
EOF

        systemctl daemon-reload
        systemctl enable fivem.service
        
        log_success "Systemd Service erstellt und aktiviert"
    fi
}

# Firewall konfigurieren
configure_firewall() {
    if [ "$CONFIGURE_FIREWALL" == "j" ] || [ "$CONFIGURE_FIREWALL" == "J" ]; then
        log_info "Konfiguriere Firewall (UFW)..."
        
        # UFW aktivieren falls nicht aktiv
        if ! ufw status | grep -q "Status: active"; then
            echo "y" | ufw enable
        fi
        
        # Ports öffnen
        ufw allow $SERVER_PORT/tcp
        ufw allow $SERVER_PORT/udp
        ufw allow 22/tcp  # SSH
        
        log_success "Firewall konfiguriert - Port $SERVER_PORT geöffnet"
    fi
}

# Berechtigungen setzen
set_permissions() {
    log_info "Setze Berechtigungen..."
    
    mkdir -p "$INSTALL_DIR/server-data/logs"
    chown -R fivem:fivem "$INSTALL_DIR"
    chmod -R 755 "$INSTALL_DIR"
    
    log_success "Berechtigungen gesetzt"
}

# README erstellen
create_readme() {
    log_info "Erstelle README..."
    
    cat > "$INSTALL_DIR/README.md" <<EOF
# GritHost FiveM Server

## Installation abgeschlossen!

Ihr FiveM Server wurde erfolgreich installiert.

### Server-Informationen

- **Server Name:** $SERVER_NAME
- **Installationsverzeichnis:** $INSTALL_DIR
- **Server Port:** $SERVER_PORT
- **Max. Spieler:** $MAX_PLAYERS

### Server-Verwaltung

#### Server starten
\`\`\`bash
sudo systemctl start fivem
\`\`\`

#### Server stoppen
\`\`\`bash
sudo systemctl stop fivem
\`\`\`

#### Server neustarten
\`\`\`bash
sudo systemctl restart fivem
\`\`\`

#### Server-Status prüfen
\`\`\`bash
sudo systemctl status fivem
\`\`\`

#### Server-Logs anzeigen
\`\`\`bash
sudo journalctl -u fivem -f
\`\`\`

oder

\`\`\`bash
tail -f $INSTALL_DIR/server-data/logs/console.log
\`\`\`

### Konfiguration

Die Server-Konfiguration befindet sich hier:
\`$INSTALL_DIR/server-data/server.cfg\`

Nach Änderungen an der Konfiguration muss der Server neu gestartet werden.

### Ressourcen hinzufügen

1. Ressourcen in das Verzeichnis kopieren: \`$INSTALL_DIR/server-data/resources/\`
2. In der \`server.cfg\` mit \`ensure ressourcen-name\` aktivieren
3. Server neu starten

### Verbindung zum Server

Spieler können sich über die FiveM-Client-Konsole verbinden:
\`\`\`
connect <server-ip>:$SERVER_PORT
\`\`\`

### Support

Bei Fragen oder Problemen wenden Sie sich an GritHost Support.

**Website:** https://grithost.de
**Discord:** https://discord.gg/grithost

---

Installiert mit dem GritHost FiveM Installer v1.0.0
EOF

    log_success "README erstellt: $INSTALL_DIR/README.md"
}

# Abschluss-Informationen anzeigen
show_completion_info() {
    show_banner
    echo -e "${GREEN}${BOLD}╔═══════════════════════════════════════════════════════════╗${NC}"
    echo -e "${GREEN}${BOLD}║                                                           ║${NC}"
    echo -e "${GREEN}${BOLD}║          Installation erfolgreich abgeschlossen!         ║${NC}"
    echo -e "${GREEN}${BOLD}║                                                           ║${NC}"
    echo -e "${GREEN}${BOLD}╚═══════════════════════════════════════════════════════════╝${NC}"
    echo ""
    echo -e "${CYAN}${BOLD}Server-Informationen:${NC}"
    echo -e "  ${CYAN}Server Name:${NC} $SERVER_NAME"
    echo -e "  ${CYAN}Installation:${NC} $INSTALL_DIR"
    echo -e "  ${CYAN}Port:${NC} $SERVER_PORT"
    echo -e "  ${CYAN}Max. Spieler:${NC} $MAX_PLAYERS"
    echo ""
    echo -e "${CYAN}${BOLD}Nächste Schritte:${NC}"
    echo ""
    echo -e "  ${YELLOW}1.${NC} Server starten:"
    echo -e "     ${GREEN}sudo systemctl start fivem${NC}"
    echo ""
    echo -e "  ${YELLOW}2.${NC} Server-Status prüfen:"
    echo -e "     ${GREEN}sudo systemctl status fivem${NC}"
    echo ""
    echo -e "  ${YELLOW}3.${NC} Server-Logs anzeigen:"
    echo -e "     ${GREEN}sudo journalctl -u fivem -f${NC}"
    echo ""
    echo -e "  ${YELLOW}4.${NC} Konfiguration bearbeiten:"
    echo -e "     ${GREEN}nano $INSTALL_DIR/server-data/server.cfg${NC}"
    echo ""
    echo -e "${CYAN}${BOLD}Verbindung zum Server:${NC}"
    echo -e "  In der FiveM-Konsole (F8): ${GREEN}connect $(hostname -I | awk '{print $1}'):$SERVER_PORT${NC}"
    echo ""
    echo -e "${CYAN}${BOLD}Wichtige Dateien:${NC}"
    echo -e "  ${CYAN}Konfiguration:${NC} $INSTALL_DIR/server-data/server.cfg"
    echo -e "  ${CYAN}Start-Script:${NC} $INSTALL_DIR/start.sh"
    echo -e "  ${CYAN}README:${NC} $INSTALL_DIR/README.md"
    echo -e "  ${CYAN}Logs:${NC} $INSTALL_DIR/server-data/logs/"
    echo ""
    echo -e "${MAGENTA}${BOLD}═══════════════════════════════════════════════════════════${NC}"
    echo -e "${MAGENTA}${BOLD}        Vielen Dank für die Nutzung von GritHost!         ${NC}"
    echo -e "${MAGENTA}${BOLD}═══════════════════════════════════════════════════════════${NC}"
    echo ""
}

# Hauptfunktion
main() {
    show_banner
    check_root
    check_debian_version
    collect_user_input
    
    echo ""
    log_info "Starte Installation..."
    echo ""
    
    update_system
    install_dependencies
    create_fivem_user
    download_fivem
    create_server_config
    create_start_script
    create_systemd_service
    configure_firewall
    set_permissions
    create_readme
    
    show_completion_info
}

# Script ausführen
main
