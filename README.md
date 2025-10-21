# 🎮 GritHost FiveM Server Installer

[![Debian](https://img.shields.io/badge/Debian-12-red.svg)](https://www.debian.org/)
[![License](https://img.shields.io/badge/License-MIT-blue.svg)](LICENSE)
[![Version](https://img.shields.io/badge/Version-1.0.0-green.svg)](https://github.com/GritHost/fivem-installer)

Ein professioneller, vollautomatischer Installer für FiveM Server auf Debian 12 mit interaktiver Konfiguration und GritHost-Branding.

---

## 🚀 Quick Start

### One-Line Installation

```bash
bash <(curl -s https://raw.githubusercontent.com/GritHost/fivem-installer/main/fivem-installer.sh)
```

**Alternative:**
```bash
bash <(wget -qO- https://raw.githubusercontent.com/GritHost/fivem-installer/main/fivem-installer.sh)
```

**Oder mit Setup-Wrapper:**
```bash
bash <(curl -s https://raw.githubusercontent.com/GritHost/fivem-installer/main/setup.sh)
```

Das war's! Der Installer führt Sie durch den Rest. 🎉

---

## ✨ Features

- ✅ **One-Line Installation** - Keine manuelle Downloads nötig
- ✅ **Vollautomatisch** - Alle Abhängigkeiten werden installiert
- ✅ **Interaktiv** - Benutzerfreundliche Terminal-Oberfläche
- ✅ **Validierung** - Alle Eingaben werden geprüft
- ✅ **Systemd Service** - Automatischer Start beim Booten
- ✅ **Firewall-Setup** - UFW wird automatisch konfiguriert
- ✅ **Sicherheit** - Eigener Systembenutzer für FiveM
- ✅ **Deutsche Sprache** - Vollständig auf Deutsch
- ✅ **GritHost Branding** - Professionelles Hosting-Branding

---

## 📋 Systemanforderungen

| Komponente | Minimum | Empfohlen |
|------------|---------|-----------|
| **OS** | Debian 12 | Debian 12 |
| **RAM** | 4 GB | 8 GB |
| **CPU** | 2 Cores | 4 Cores |
| **Festplatte** | 10 GB | 20 GB |
| **Netzwerk** | 100 Mbit/s | 1 Gbit/s |

**Zusätzlich benötigt:**
- Root-Zugriff (sudo)
- Internetverbindung
- FiveM License Key ([keymaster.fivem.net](https://keymaster.fivem.net/))

---

## 🎯 Installation

### Schritt 1: Command ausführen

```bash
bash <(curl -s https://raw.githubusercontent.com/GritHost/fivem-installer/main/fivem-installer.sh)
```

### Schritt 2: Konfiguration eingeben

Der Installer fragt Sie nach:

1. **Server Name** (z.B. "GritHost-Roleplay")
2. **Installationsverzeichnis** (Standard: `/opt/fivem`)
3. **Server Port** (Standard: `30120`)
4. **Maximale Spieleranzahl** (Standard: `32`)
5. **FiveM License Key** (von keymaster.fivem.net)
6. **RCON Passwort** (mindestens 8 Zeichen)
7. **Steam Web API Key** (optional)
8. **Systemd Service erstellen?** (j/n)
9. **Firewall konfigurieren?** (j/n)

### Schritt 3: Installation bestätigen

Der Installer zeigt eine Zusammenfassung. Bestätigen Sie mit `j` (Ja).

### Schritt 4: Fertig! 🎉

Nach 2-5 Minuten ist Ihr FiveM Server einsatzbereit!

---

## 🎮 Server-Verwaltung

### Grundlegende Befehle

```bash
# Server starten
sudo systemctl start fivem

# Server stoppen
sudo systemctl stop fivem

# Server neustarten
sudo systemctl restart fivem

# Server-Status anzeigen
sudo systemctl status fivem

# Autostart aktivieren
sudo systemctl enable fivem

# Autostart deaktivieren
sudo systemctl disable fivem
```

### Logs anzeigen

```bash
# Live-Logs (mit systemd)
sudo journalctl -u fivem -f

# Log-Datei direkt
tail -f /opt/fivem/server-data/logs/console.log

# Letzte 100 Zeilen
sudo journalctl -u fivem -n 100
```

### Konfiguration bearbeiten

```bash
# Server-Konfiguration
sudo nano /opt/fivem/server-data/server.cfg

# Nach Änderungen neu starten
sudo systemctl restart fivem
```

---

## 📦 Ressourcen hinzufügen

### Methode 1: Manuell hochladen

```bash
# In Ressourcen-Verzeichnis wechseln
cd /opt/fivem/server-data/resources/

# Ressource hochladen (z.B. mit SCP)
scp -r /pfad/zur/ressource user@server:/opt/fivem/server-data/resources/

# Berechtigungen setzen
sudo chown -R fivem:fivem /opt/fivem/server-data/resources/
```

### Methode 2: Git Clone

```bash
cd /opt/fivem/server-data/resources/
sudo -u fivem git clone https://github.com/user/resource-name.git
```

### Ressource aktivieren

```bash
# server.cfg bearbeiten
sudo nano /opt/fivem/server-data/server.cfg

# Zeile hinzufügen:
# ensure resource-name

# Server neu starten
sudo systemctl restart fivem
```

---

## 🌐 Verbindung zum Server

### Im FiveM Client

1. FiveM öffnen
2. `F8` drücken (Konsole)
3. Eingeben:
   ```
   connect SERVER-IP:30120
   ```

### Direktlink

```
fivem://connect/SERVER-IP:30120
```

---

## ⚙️ Erweiterte Konfiguration

### OneSync aktivieren (für mehr als 32 Spieler)

In `/opt/fivem/server-data/server.cfg`:

```cfg
# OneSync aktivieren
onesync on

# Oder für Legacy-Modus
onesync legacy
```

### MySQL-Datenbank einrichten

```cfg
set mysql_connection_string "mysql://user:password@localhost/database?charset=utf8mb4"
```

### Discord Rich Presence

```cfg
set discord_appId "your_app_id"
set discord_largeImageKey "your_image_key"
set discord_largeImageText "GritHost FiveM Server"
```

### Game Build festlegen

```cfg
# Für spezifische GTA V Version
sv_enforceGameBuild 2699
```

---

## 🔒 Sicherheit

### Firewall-Regeln

```bash
# Status prüfen
sudo ufw status

# Port manuell öffnen
sudo ufw allow 30120/tcp
sudo ufw allow 30120/udp

# SSH nicht vergessen!
sudo ufw allow 22/tcp

# Firewall aktivieren
sudo ufw enable
```

### RCON-Passwort ändern

```bash
sudo nano /opt/fivem/server-data/server.cfg
# Zeile ändern: rcon_password "NeuesPasswort123!"
sudo systemctl restart fivem
```

### Berechtigungen prüfen

```bash
# Alle Dateien sollten fivem gehören
sudo chown -R fivem:fivem /opt/fivem/
sudo chmod -R 755 /opt/fivem/
```

---

## 🔧 Troubleshooting

### Problem: Server startet nicht

**Lösung 1:** Logs überprüfen
```bash
sudo journalctl -u fivem -n 50
```

**Lösung 2:** License Key prüfen
```bash
sudo nano /opt/fivem/server-data/server.cfg
# sv_licenseKey überprüfen
```

**Lösung 3:** Berechtigungen setzen
```bash
sudo chown -R fivem:fivem /opt/fivem/
```

### Problem: Port bereits in Verwendung

```bash
# Prüfen welcher Prozess den Port verwendet
sudo netstat -tulpn | grep 30120

# Oder mit ss
sudo ss -tulpn | grep 30120
```

### Problem: Verbindung nicht möglich

**Checkliste:**
- [ ] Server läuft: `sudo systemctl status fivem`
- [ ] Firewall konfiguriert: `sudo ufw status`
- [ ] Port-Weiterleitung im Router (falls hinter NAT)
- [ ] Richtige IP-Adresse verwendet
- [ ] License Key gültig

### Problem: Hohe CPU/RAM-Nutzung

**Lösungen:**
1. Nicht benötigte Ressourcen deaktivieren
2. OneSync-Einstellungen optimieren
3. MySQL-Verbindungspool begrenzen
4. Server-Hardware upgraden

---

## 🔄 Updates

### FiveM Server aktualisieren

```bash
# Server stoppen
sudo systemctl stop fivem

# Backup erstellen
sudo cp -r /opt/fivem /opt/fivem.backup.$(date +%Y%m%d)

# Neue Version herunterladen
cd /opt/fivem
LATEST=$(curl -s https://runtime.fivem.net/artifacts/fivem/build_proot_linux/master/ | grep -oP '(?<=href=")[0-9]+-[a-f0-9]+(?=/fx\.tar\.xz")' | tail -1)
sudo -u fivem wget "https://runtime.fivem.net/artifacts/fivem/build_proot_linux/master/$LATEST/fx.tar.xz"

# Entpacken
sudo -u fivem tar -xf fx.tar.xz
sudo rm fx.tar.xz

# Server starten
sudo systemctl start fivem
```

### Installer aktualisieren

```bash
# Einfach erneut ausführen
bash <(curl -s https://raw.githubusercontent.com/GritHost/fivem-installer/main/fivem-installer.sh)
```

---

## 📊 Performance-Optimierung

### Systemd Service optimieren

```bash
sudo nano /etc/systemd/system/fivem.service
```

Hinzufügen:
```ini
[Service]
LimitNOFILE=65536
LimitNPROC=4096
Nice=-10
CPUAffinity=0-3
```

Dann:
```bash
sudo systemctl daemon-reload
sudo systemctl restart fivem
```

### Linux Kernel-Parameter

```bash
sudo nano /etc/sysctl.conf
```

Hinzufügen:
```
net.core.rmem_max=16777216
net.core.wmem_max=16777216
net.ipv4.tcp_rmem=4096 87380 16777216
net.ipv4.tcp_wmem=4096 65536 16777216
```

Anwenden:
```bash
sudo sysctl -p
```

---

## 📁 Verzeichnisstruktur

```
/opt/fivem/
├── alpine/                 # FiveM Server-Binaries
├── run.sh                  # FiveM Start-Script
├── start.sh                # Wrapper-Script
├── server-data/
│   ├── server.cfg          # Haupt-Konfiguration
│   ├── resources/          # Server-Ressourcen
│   │   ├── [local]/        # Lokale Ressourcen
│   │   ├── [system]/       # System-Ressourcen
│   │   └── [custom]/       # Eigene Ressourcen
│   ├── cache/              # Cache-Dateien
│   └── logs/               # Log-Dateien
│       ├── console.log
│       ├── error.log
│       └── server.log
└── README.md               # Server-Dokumentation
```

---

## 🆘 Support & Community

### GritHost Support

- 🌐 **Website:** [grithost.de](https://grithost.de)
- 💬 **Discord:** [discord.gg/grithost](https://discord.gg/grithost)
- 📧 **E-Mail:** support@grithost.de
- 🎫 **Ticket-System:** [grithost.de/support](https://grithost.de/support)

### FiveM Community

- 📚 **Dokumentation:** [docs.fivem.net](https://docs.fivem.net/)
- 💬 **Forum:** [forum.cfx.re](https://forum.cfx.re/)
- 🎮 **Discord:** [discord.gg/fivem](https://discord.gg/fivem)
- 🔑 **License Keys:** [keymaster.fivem.net](https://keymaster.fivem.net/)

---

## 📝 Changelog

### Version 1.0.0 (2024)

- ✅ Initiale Version
- ✅ One-Line Installation
- ✅ Interaktive Konfiguration
- ✅ Systemd Service Integration
- ✅ Automatische Firewall-Konfiguration
- ✅ Deutsche Lokalisierung
- ✅ GritHost Branding
- ✅ Umfassende Fehlerbehandlung
- ✅ Eingabevalidierung
- ✅ Automatische Updates

---

## 🤝 Beitragen

Contributions sind willkommen! Bitte erstellen Sie einen Pull Request oder öffnen Sie ein Issue.

### Development Setup

```bash
git clone https://github.com/GritHost/fivem-installer.git
cd fivem-installer
chmod +x fivem-installer.sh
```

### Testing

```bash
# Lokaler Test (Vorsicht: Installiert tatsächlich!)
sudo ./fivem-installer.sh
```

---

## 📜 Lizenz

Dieses Projekt ist unter der MIT-Lizenz lizenziert - siehe [LICENSE](LICENSE) für Details.

---

## 🙏 Credits

- **Entwickelt von:** GritHost Team
- **FiveM:** [Cfx.re Team](https://cfx.re/)
- **Inspiriert von:** Community-Feedback und Best Practices

---

## ⚠️ Disclaimer

Dieses Script wurde für **Debian 12** entwickelt und getestet. Die Verwendung auf anderen Systemen erfolgt auf eigene Gefahr. Erstellen Sie immer Backups vor größeren Änderungen.

---

## 🌟 Star History

Wenn Ihnen dieses Projekt gefällt, geben Sie ihm einen ⭐ auf GitHub!

---

**© 2024 GritHost - Professionelles Game Server Hosting**

[![GritHost](https://img.shields.io/badge/Powered%20by-GritHost-blue)](https://grithost.de)
