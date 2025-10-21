# 🚀 GritHost FiveM Server - Quick Installation

## ⚡ One-Line Installation

Führen Sie einfach diesen Befehl aus, um den FiveM Server zu installieren:

```bash
bash <(curl -s https://raw.githubusercontent.com/GritHost/fivem-installer/main/fivem-installer.sh)
```

### Alternative mit wget:

```bash
bash <(wget -qO- https://raw.githubusercontent.com/GritHost/fivem-installer/main/fivem-installer.sh)
```

---

## 📋 Voraussetzungen

- **Root-Zugriff** (sudo)
- **Debian 12** (Bookworm)
- **Internetverbindung**
- **FiveM License Key** von [keymaster.fivem.net](https://keymaster.fivem.net/)

---

## 🎯 Was passiert bei der Installation?

Das Script wird Sie durch folgende Schritte führen:

### 1️⃣ Systemprüfung
- Überprüfung der Root-Rechte
- Validierung der Debian Version

### 2️⃣ Konfiguration (Interaktiv)
Sie werden nach folgenden Informationen gefragt:

| Parameter | Beschreibung | Standard |
|-----------|--------------|----------|
| **Server Name** | Name Ihres FiveM Servers | GritHost-FiveM |
| **Installationsverzeichnis** | Wo der Server installiert wird | /opt/fivem |
| **Server Port** | Port für den Server | 30120 |
| **Max. Spieler** | Maximale Spieleranzahl | 32 |
| **License Key** | FiveM License Key | - |
| **RCON Passwort** | Admin-Passwort (min. 8 Zeichen) | - |
| **Steam API Key** | Optional für Steam-Integration | Optional |
| **Systemd Service** | Autostart aktivieren | Ja |
| **Firewall** | UFW automatisch konfigurieren | Ja |

### 3️⃣ Automatische Installation
- System-Updates
- Installation aller Abhängigkeiten
- FiveM Server Download
- Konfigurationserstellung
- Systemd Service Setup
- Firewall-Konfiguration

---

## 🎮 Nach der Installation

### Server starten
```bash
sudo systemctl start fivem
```

### Server-Status prüfen
```bash
sudo systemctl status fivem
```

### Logs anzeigen
```bash
sudo journalctl -u fivem -f
```

### Konfiguration bearbeiten
```bash
sudo nano /opt/fivem/server-data/server.cfg
```

---

## 🌐 Verbindung zum Server

Im FiveM Client (F8 Konsole):
```
connect IHRE-SERVER-IP:30120
```

---

## 📦 Manuelle Installation (Alternative)

Falls Sie das Script lieber manuell herunterladen möchten:

```bash
# Script herunterladen
wget https://raw.githubusercontent.com/GritHost/fivem-installer/main/fivem-installer.sh

# Ausführbar machen
chmod +x fivem-installer.sh

# Installation starten
sudo ./fivem-installer.sh
```

---

## 🔧 Troubleshooting

### Fehler: "curl: command not found"

```bash
sudo apt-get update
sudo apt-get install curl -y
```

Dann erneut versuchen.

### Fehler: "Permission denied"

Stellen Sie sicher, dass Sie `sudo` verwenden:

```bash
sudo bash <(curl -s https://raw.githubusercontent.com/GritHost/fivem-installer/main/fivem-installer.sh)
```

### Server startet nicht

Logs überprüfen:
```bash
sudo journalctl -u fivem -n 50
```

---

## 🆘 Support

- **Website:** https://grithost.de
- **Discord:** https://discord.gg/grithost
- **E-Mail:** support@grithost.de

---

## 📝 Hinweise

- Das Script wurde für **Debian 12** entwickelt und getestet
- Eine aktive Internetverbindung ist erforderlich
- Der Download kann je nach Verbindung 2-5 Minuten dauern
- Alle Eingaben werden validiert, um Fehler zu vermeiden

---

**© 2024 GritHost - Professionelles Game Server Hosting**
