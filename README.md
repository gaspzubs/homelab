# Homelab stack

This repository provides a small self-hosted Docker Compose stack for common home services such as monitoring, media management, networking, and remote access.

## Included services

- Portainer
- Homer dashboard
- Glances monitoring
- AdGuard Home
- Jellyfin
- Navidrome
- Lidarr
- Radarr
- Sonarr
- Prowlarr
- qBittorrent
- slskd
- Soularr
- Feishin
- Immich
- Nextcloud AIO
- Watchtower

## Repository layout

- `docker-compose.yml` — main stack definition
- `network/docker-compose.yml` — network services for tunnels and private access
- `homer/assets/config.yml` — dashboard configuration
- `backup_script.sh` — backup helper for archives on external storage
- `MAKEFILE.md` — setup notes for Docker, networking, and system configuration

## Requirements

- Linux host with Docker Engine and Compose v2
- A persistent data directory
- A configured `.env` file with the required variables

## Environment variables

Create a `.env` file in the repository root with values similar to the following:

```env
ROOT_DIR=/srv/homelab
PUID=1000
PGID=1000
TZ=UTC
MEDIA_DIR=/mnt/data/homelab
```

Add any required service-specific values in `.env` for your deployment, and keep the file out of version control.

## Quick start

From the repository root:

```bash
docker compose -f network/docker-compose.yml up -d
docker compose up -d
```

Check the running services:

```bash
docker compose ps
docker compose logs -f
```

Stop the stack when needed:

```bash
docker compose down
docker compose -f network/docker-compose.yml down
```

## Media setup

The stack expects a shared media directory mounted into the containers. A typical layout looks like this:

```text
/mnt/data/homelab/
├── torrents/
│   ├── movies/
│   ├── tv/
│   └── music/
├── Music/
└── media/
    ├── Movies/
    └── TV/
```

Keep the directory structure consistent and make sure the host path is writable by the configured `PUID` and `PGID` values. When you configure the Arr apps, point them at the mounted `/data/...` paths instead of host-specific directories.

## Access and ports

The compose stack exposes these web ports on the host:

- Portainer: `9000`
- Homer: `80`
- Glances: `61208`
- AdGuard Home: `3000` and `3001`
- Jellyfin: `8096`
- Navidrome: `4533`
- Lidarr: `8686`
- Radarr: `7878`
- Sonarr: `8989`
- Prowlarr: `9696`
- qBittorrent: `8080`
- slskd: `5030`, `5031`, `50300`
- Feishin: `9180`
- Immich: `2283`
- Nextcloud AIO: `8082`

## Backup strategy

The project includes a backup helper that creates an archive of the homelab directory and stores it on external storage.

Run it manually:

```bash
bash backup_script.sh
```

A cron job can be configured to run it on a schedule if needed.

## Security notes

- Keep secrets in `.env` and do not commit them to Git.
- Use strong credentials for web interfaces and remote access.
- Restrict the host firewall to the ports that should be public.
- Use TLS and reverse proxying if exposing services outside your trusted network.
- Review DNS, firewall, and access controls before exposing the stack publicly.

## Notes

This is a simple home-lab stack meant to run on one Linux machine. It is designed for practical self-hosting rather than production-grade multi-node infrastructure.