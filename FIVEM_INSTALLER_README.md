# GritHost FiveM Server Installer

Ein professioneller, benutzerfreundlicher Installer für FiveM Server auf Debian 12.

## 🚀 Features

- ✅ Vollautomatische Installation
- ✅ Interaktive Konfiguration im Terminal
- ✅ Systemd Service für automatischen Start
- ✅ Firewall-Konfiguration (UFW)
- ✅ Benutzerfreundliche Oberfläche mit Farben
- ✅ Umfassende Fehlerprüfung
- ✅ Automatische Abhängigkeitsinstallation
- ✅ GritHost Branding
- ✅ Deutsche Sprache

## 📋 Systemanforderungen

- **Betriebssystem:** Debian 12 (Bookworm)
- **RAM:** Mindestens 4 GB (8 GB empfohlen)
- **CPU:** Mindestens 2 Cores (4 Cores empfohlen)
- **Festplatte:** Mindestens 10 GB freier Speicher
- **Root-Zugriff:** Erforderlich
- **Internetverbindung:** Erforderlich

## 📥 Installation

### Schritt 1: Script herunterladen

```bash
wget https://your-domain.com/fivem-installer.sh
```

Oder mit curl:

```bash
curl -O https://your-domain.com/fivem-installer.sh
```

### Schritt 2: Ausführbar machen

```bash
chmod +x fivem-installer.sh
```

### Schritt 3: Installation starten

```bash
sudo ./fivem-installer.sh
```

## 🎯 Installationsprozess

Das Script führt Sie durch folgende Schritte:

### 1. Systemprüfung
- Root-Rechte werden überprüft
- Debian Version wird validiert

### 2. Konfiguration
Sie werden nach folgenden Informationen gefragt:

- **Server Name** - Name Ihres FiveM Servers (Standard: GritHost-FiveM)
- **Installationsverzeichnis** - Wo der Server installiert wird (Standard: /opt/fivem)
- **Server Port** - Port für den Server (Standard: 30120)
- **Maximale Spieleranzahl** - Anzahl der Spieler (Standard: 32)
- **FiveM License Key** - Ihr License Key von https://keymaster.fivem.net/
- **RCON Passwort** - Admin-Passwort (mindestens 8 Zeichen)
- **Steam Web API Key** - Optional von https://steamcommunity.com/dev/apikey
- **Systemd Service** - Automatischer Start beim Booten (j/n)
- **Firewall** - Automatische Firewall-Konfiguration (j/n)

### 3. Installation
Das Script führt automatisch aus:

- System-Updates
- Installation aller Abhängigkeiten
- Erstellung eines FiveM Systembenutzers
- Download der neuesten FiveM Server-Version
- Erstellung der Server-Konfiguration
- Einrichtung des Systemd Service
- Firewall-Konfiguration
- Berechtigungen setzen

## 🎮 Server-Verwaltung

### Server starten
```bash
sudo systemctl start fivem
```

### Server stoppen
```bash
sudo systemctl stop fivem
```

### Server neustarten
```bash
sudo systemctl restart fivem
```

### Server-Status prüfen
```bash
sudo systemctl status fivem
```

### Server-Logs anzeigen
```bash
sudo journalctl -u fivem -f
```

Oder direkt die Log-Datei:
```bash
tail -f /opt/fivem/server-data/logs/console.log
```

### Autostart aktivieren/deaktivieren
```bash
# Aktivieren
sudo systemctl enable fivem

# Deaktivieren
sudo systemctl disable fivem
```

## ⚙️ Konfiguration

### Server-Konfiguration bearbeiten
```bash
sudo nano /opt/fivem/server-data/server.cfg
```

Nach Änderungen Server neu starten:
```bash
sudo systemctl restart fivem
```

### Wichtige Konfigurationsoptionen

```cfg
# Server Name
sv_hostname "Ihr Server Name"

# Maximale Spieler
sv_maxclients 32

# Server Tags
sets tags "GritHost, Deutsch, Roleplay"

# OneSync (für mehr als 32 Spieler)
onesync on

# Game Build festlegen
sv_enforceGameBuild 2699
```

## 📦 Ressourcen hinzufügen

### 1. Ressource hochladen
```bash
# In das Ressourcen-Verzeichnis wechseln
cd /opt/fivem/server-data/resources/

# Ressource hochladen (z.B. mit SCP oder FTP)
# Oder mit Git klonen
sudo -u fivem git clone https://github.com/user/resource.git
```

### 2. Ressource aktivieren
Bearbeiten Sie die `server.cfg`:
```bash
sudo nano /opt/fivem/server-data/server.cfg
```

Fügen Sie hinzu:
```cfg
ensure resource-name
```

### 3. Server neu starten
```bash
sudo systemctl restart fivem
```

## 🌐 Verbindung zum Server

### Im FiveM Client

1. FiveM öffnen
2. F8 drücken (Konsole öffnen)
3. Eingeben:
```
connect SERVER-IP:PORT
```

Beispiel:
```
connect 192.168.1.100:30120
```

### Server zur Serverliste hinzufügen

Der Server erscheint automatisch in der FiveM Serverliste, wenn:
- Der Server läuft
- Der Port korrekt weitergeleitet ist
- Die Firewall korrekt konfiguriert ist

## 🔒 Sicherheit

### Firewall-Regeln

Das Script konfiguriert automatisch UFW:
```bash
# Manuell Ports öffnen
sudo ufw allow 30120/tcp
sudo ufw allow 30120/udp

# SSH nicht vergessen!
sudo ufw allow 22/tcp

# Firewall aktivieren
sudo ufw enable
```

### RCON-Zugriff sichern

Ändern Sie regelmäßig Ihr RCON-Passwort in der `server.cfg`:
```cfg
rcon_password "IhrSicheresPasswort123!"
```

### Berechtigungen prüfen
```bash
# Überprüfen Sie die Dateiberechtigungen
ls -la /opt/fivem/

# Alle Dateien sollten dem Benutzer 'fivem' gehören
sudo chown -R fivem:fivem /opt/fivem/
```

## 🔧 Troubleshooting

### Server startet nicht

1. **Logs überprüfen:**
```bash
sudo journalctl -u fivem -n 50
```

2. **License Key prüfen:**
```bash
sudo nano /opt/fivem/server-data/server.cfg
# Überprüfen Sie sv_licenseKey
```

3. **Berechtigungen prüfen:**
```bash
sudo chown -R fivem:fivem /opt/fivem/
```

### Port bereits in Verwendung

```bash
# Prüfen welcher Prozess den Port verwendet
sudo netstat -tulpn | grep 30120

# Prozess beenden oder anderen Port wählen
```

### Verbindungsprobleme

1. **Firewall prüfen:**
```bash
sudo ufw status
```

2. **Port-Weiterleitung prüfen** (bei Router/NAT)

3. **Server-Status prüfen:**
```bash
sudo systemctl status fivem
```

### Hohe CPU/RAM-Nutzung

1. **Ressourcen optimieren** - Entfernen Sie nicht benötigte Ressourcen
2. **OneSync konfigurieren** - Passen Sie die Einstellungen an
3. **Server-Hardware upgraden**

## 📁 Verzeichnisstruktur

```
/opt/fivem/
├── alpine/              # FiveM Server-Dateien
├── run.sh              # FiveM Start-Script
├── start.sh            # Wrapper-Script
├── server-data/
│   ├── server.cfg      # Server-Konfiguration
│   ├── resources/      # Server-Ressourcen
│   ├── cache/          # Cache-Dateien
│   └── logs/           # Log-Dateien
│       ├── console.log
│       ├── error.log
│       └── server.log
└── README.md           # Server-Dokumentation
```

## 🔄 Updates

### FiveM Server aktualisieren

```bash
# Server stoppen
sudo systemctl stop fivem

# Backup erstellen
sudo cp -r /opt/fivem /opt/fivem.backup

# Neue Version herunterladen
cd /opt/fivem
sudo -u fivem wget https://runtime.fivem.net/artifacts/fivem/build_proot_linux/master/LATEST/fx.tar.xz

# Entpacken
sudo -u fivem tar -xf fx.tar.xz
sudo rm fx.tar.xz

# Server starten
sudo systemctl start fivem
```

### Script aktualisieren

```bash
# Neues Script herunterladen
wget https://your-domain.com/fivem-installer.sh -O fivem-installer-new.sh
chmod +x fivem-installer-new.sh
```

## 📊 Performance-Optimierung

### Systemd Service optimieren

Bearbeiten Sie `/etc/systemd/system/fivem.service`:

```ini
[Service]
# Mehr Ressourcen zuweisen
LimitNOFILE=65536
LimitNPROC=4096

# Nice-Level anpassen (niedriger = höhere Priorität)
Nice=-10

# CPU-Affinität setzen (optional)
CPUAffinity=0-3
```

Nach Änderungen:
```bash
sudo systemctl daemon-reload
sudo systemctl restart fivem
```

### MySQL-Optimierung

Wenn Sie MySQL verwenden, optimieren Sie die Verbindung in `server.cfg`:

```cfg
set mysql_connection_string "mysql://user:password@localhost/database?charset=utf8mb4&connectionLimit=10"
```

## 🆘 Support

### GritHost Support

- **Website:** https://grithost.de
- **Discord:** https://discord.gg/grithost
- **E-Mail:** support@grithost.de
- **Ticket-System:** https://grithost.de/support

### FiveM Community

- **Forum:** https://forum.cfx.re/
- **Discord:** https://discord.gg/fivem
- **Dokumentation:** https://docs.fivem.net/

## 📝 Lizenz

Dieses Installations-Script ist für GritHost-Kunden kostenlos verfügbar.

## 🙏 Credits

- **Entwickelt von:** GritHost Team
- **FiveM:** Cfx.re Team
- **Version:** 1.0.0

## 📋 Changelog

### Version 1.0.0 (2024)
- ✅ Initiale Version
- ✅ Vollautomatische Installation
- ✅ Interaktive Konfiguration
- ✅ Systemd Service Integration
- ✅ Firewall-Konfiguration
- ✅ Deutsche Lokalisierung
- ✅ GritHost Branding

---

**Hinweis:** Dieses Script wurde speziell für Debian 12 entwickelt und getestet. Die Verwendung auf anderen Systemen erfolgt auf eigene Gefahr.

**© 2024 GritHost - Professionelles Game Server Hosting**
