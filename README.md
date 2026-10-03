# Homelab
This repository contains a personal self-hosted home lab stack managed with Docker Compose. It centralizes common services for administration, monitoring, media, networking, and secure remote access on a small Linux server.
## Overview
The compose stack provisions the following services:
- Portainer: Docker administration UI
- Homer: dashboard/home page for services
- Glances: system and container monitoring
- AdGuard Home: DNS filtering and ad blocking
- Jellyfin: media server for video
- Navidrome: music streaming server
- Lidarr: music library management
- slskd: Soulseek client daemon
- Soularr: automation bridge between slskd and Lidarr
- Feishin: lightweight music client for Navidrome
- Cloudflare Tunnel: secure remote access via Cloudflare
- Watchtower: automatic container updates
- Nextcloud AIO: self-hosted cloud storage stack
## Repository layout
- `docker-compose.yml` — main stack definition
- `backup_script.sh` — archive the homelab directory to a NAS backup target and prune old backups
- `MAKEFILE.md` — setup notes for Ubuntu/Docker, SSH, NAS mounts, backups, and Cockpit
## Requirements
- Ubuntu or Debian-based Linux host
- Docker Engine
- Docker Compose v2 (`docker compose`)
- A persistent directory for data, often mounted on a NAS or local disk
- A configured `.env` file with the variables referenced by `docker-compose.yml`
## Environment variables
Create a `.env` file in the repository root with values similar to the following:
```env
ROOT_DIR=/home/<user>/Documents/homelab
PUID=1000
PGID=1000
TZ=Europe/Paris
MEDIA_DIR=/mnt/nas/<shared-storage>
TUNNEL_TOKEN=your_cloudflare_tunnel_token
SOULSEEK_USER=your_soulseek_username
SOULSEEK_PASS=your_soulseek_password
```
`ROOT_DIR` is used for persistent data directories, `MEDIA_DIR` points to the shared media mount, and the Soulseek and tunnel credentials are required by the related services.
## Quick start
From the repository root:
```bash
docker compose up -d
```
To inspect running services:
```bash
docker compose ps
docker compose logs -f
```
To stop and remove the stack:
```bash
docker compose down
```
## Services and access
The compose file exposes these web ports on the host:
- Portainer: `9000`
- Homer: `80`
- Glances: `61208`
- AdGuard Home web UI: `3000` (with the install UI exposed on `3000`, and internal admin port on `3001`)
- Jellyfin: `8096`
- Navidrome: `4533`
- Lidarr: `8686`
- slskd: `5030`, `5031`, `50300`
- Feishin: `9180`
- Nextcloud AIO: `8082`
## Backup strategy
The project includes a backup script that creates a compressed tarball of the homelab directory and stores it on the NAS at `/mnt/nas/<shared-storage>/backups`.
Run it manually:
```bash
bash backup_script.sh
```
A cron job can be configured to run it on a schedule:
```bash
crontab -e
```
Example:
```cron
0 1 * * * sh ~/Documents/homelab/backup_script.sh
```
The script also deletes archives older than 14 days.
## Hosting notes
The setup notes in `MAKEFILE.md` include useful operating-system configuration for:
- installing Docker and Docker Compose
- enabling SSH
- disabling suspend on lid close
- mounting the NAS in `/etc/fstab`
- disabling `systemd-resolved` DNS stub to allow AdGuard Home to manage DNS
- installing Cockpit for system monitoring
## Security considerations
This stack is intended for a trusted home network and personal usage. Some services expose ports directly to the host, and remote access is handled via Cloudflare Tunnel. Review and secure the following before exposing the stack publicly:
- strong credentials and secrets in `.env`
- firewall rules for host ports
- reverse proxy and TLS termination if applicable
- rate limiting and access control for web interfaces
- DNS and network configuration for AdGuard Home
## Notes
This is a practical personal homelab configuration rather than a production-grade distributed platform. It is designed to run on a single Linux box and keep common self-hosted services easy to manage from one Docker Compose file.