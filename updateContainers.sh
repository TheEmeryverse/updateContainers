#! /bin/bash
#shell script to update and redeploy all containers

#stop all containers
echo "Stopping all containers..."
docker stop prowlarr; docker stop overseerr; docker stop tautulli; docker stop qbittorrent; docker stop bazarr; docker stop readarr; docker stop plex; docker stop sonarr; docker stop radarr; docker stop flood; docker stop gluetun; docker stop cloudflare

#uodate all containers
echo "Updating all containers..."
docker pull lscr.io/linuxserver/overseerr:latest
docker pull tautulli/tautulli:latest
docker pull lscr.io/linuxserver/prowlarr:latest
docker pull lscr.io/linuxserver/qbittorrent:latest
docker pull lscr.io/linuxserver/bazarr:latest
docker pull lscr.io/linuxserver/readarr:develop
docker pull lscr.io/linuxserver/plex:latest
docker pull lscr.io/linuxserver/sonarr:latest
docker pull lscr.io/linuxserver/radarr:latest
docker pull qmcgaw/gluetun:latest
docker pull jesec/flood:master
docker pull cloudflare/cloudflared:latest

echo "Deleting all containers..."
docker rm prowlarr; docker rm overseerr; docker rm tautulli; docker rm qbittorrent; docker rm bazarr; docker rm readarr; docker rm plex; docker rm sonarr; docker rm radarr; docker rm flood; docker rm cloudflare

echo "All containers successfully deleted..."

echo "Starting containers with updated images..."

echo "Starting prowlarr..."
docker run -d \
	--name=prowlarr \
	--env=TZ=America/Chicago \
	--volume=/home/containerConfigs/prowlarr/data:/config \
	-p 9696:9696 \
	--restart=unless-stopped \
	--runtime=runc \
lscr.io/linuxserver/prowlarr:latest

echo "Starting overseerr..."
docker run -d \
	--name=overseerr \
	-e TZ=America/Chicago \
	-p 5055:5055 \
	-v /home/containerConfigs/overseerr/appdata/config:/config \
	--restart unless-stopped \
lscr.io/linuxserver/overseerr:latest

echo "Starting tautulli..."
docker run -d \
	--name=tautulli \
	--restart=unless-stopped \
	-v /home/containerConfigs/tautulli/config:/config \
	-e TZ=America/Chicago \
	-p 8181:8181 \
tautulli/tautulli:latest

echo "Starting bazarr..."
docker run -d \
	--name=bazarr \
	--volume=/mnt/plexNAS/media/tv:/tv \
	--volume=/mnt/plexNAS/media/movies:/movies \
	--volume=/home/containerConfigs/bazarr/config:/config \
	--network=bridge \
	-e TZ=America/Chicago \
	-p 6767:6767 \
	--restart=unless-stopped \
	--runtime=runc \
lscr.io/linuxserver/bazarr:latest

echo "Starting readarr..."
docker run -d \
	--name=readarr \
	--env=TZ=America/Chicago \
	--volume=/mnt/plexNAS/media/audiobooks:/audiobooks \
	--volume=/mnt/plexNAS/torrents/audiobooks:/downloads/audiobooks \
	--volume=/home/containerConfigs/readarr/config:/config \
	--network=bridge \
	-p 8787:8787 \
	--restart=unless-stopped \
	--runtime=runc \
lscr.io/linuxserver/readarr:develop

echo "Starting plex..."
docker run -d \
	--name=plex \
	--net=host \
	-e TZ=America/Chicago \
	-e VERSION=docker \
	-e NVIDIA_VISIBLE_DEVICES=all \
	-e NVIDIA_DRIVER_CAPABILITIES=all \
	-p 32400:32400 \
	-e PLEX_CLAIM=claim-W_Qx5smRRpWbGziPJu2d \
	-v /mnt/plexNAS/media/plex_database/config:/config \
	-v /mnt/plexNAS/media/tv:/tv \
	-v /mnt/plexNAS/media/movies:/movies \
	-v /mnt/plexNAS/media/audiobooks:/audiobooks \
	-v /mnt/plexNAS/media/music:/music \
	-v /tmp:/transcode \
	--restart unless-stopped \
	--runtime=nvidia \
	--gpus all \
lscr.io/linuxserver/plex:latest

echo "Starting sonarr..."
docker run -d \
	--name=sonarr \
	--volume=/home/containerConfigs/sonarr/config:/config \
	--volume=/mnt/plexNAS/torrents/:/downloads \
	--volume=/mnt/plexNAS/media/tv:/tv \
	--network=bridge \
	-e TZ=America/Chicago \
	-p 8989:8989 \
	--restart=unless-stopped \
	--runtime=runc \
lscr.io/linuxserver/sonarr:latest

echo "Starting radarr..."
docker run -d \
	--name=radarr \
	--volume=/home/containerConfigs/radarr/config:/config \
	--volume=/mnt/plexNAS/torrents:/downloads \
	--volume=/mnt/plexNAS/media/movies:/movies \
	--network=bridge \
	-p 7878:7878 \
	--restart=unless-stopped \
	--runtime=runc \
lscr.io/linuxserver/radarr:latest

echo "Starting gluetun..."
docker run -d --rm --cap-add=NET_ADMIN \
	--name=gluetun \
	-e VPN_SERVICE_PROVIDER=custom \
	-e VPN_TYPE=wireguard \
	-e WIREGUARD_ENDPOINT_IP=185.159.157.23 \
	-e WIREGUARD_ENDPOINT_PORT=51820 \
	-e WIREGUARD_PUBLIC_KEY=VNNO5MYorFu1UerHvoXccW6TvotxbJ1GAGJKtzM9HTY= \
	-e WIREGUARD_PRIVATE_KEY=qKyMq+oLuW3B69+ncluL2QnSUdKYcBM+PkyFMOmjgVw= \
	-e WIREGUARD_ADDRESSES="10.2.0.2/32" \
	-p 8080:8080 \
	-p 8999:8999 \
qmcgaw/gluetun:latest

echo "Starting qbittorrent..."
docker run -d \
	--name=qbittorrent \
	-e TZ=America/Chicago \
	--network=container:gluetun \
	-e WEBUI_PORT=8080 \
	-v /home/containerConfigs/qbittorrent/config:/config \
	-v /mnt/plexNAS/torrents:/downloads \
	--restart=unless-stopped \
lscr.io/linuxserver/qbittorrent:latest

docker run -d \
	--name=cloudflare \
	--restart=unless-stopped \
cloudflare/cloudflared:latest tunnel --no-autoupdate run --token eyJhIjoiNmVmMDM5ZTUxOWI5OGE3N2NhZTY4OTk2NDA2N2E2NGUiLCJ0IjoiM2Y5MzUwZTQtZjVmMC00ZTZmLWJjN2QtMjJmMjc5OWFmOTZmIiwicyI6Ik5tWTVZek0yTURRdE5ERTJZeTAwTXpFMUxXRTJaalV0TURGa1lqRTROVE15TjJRMCJ9

# flood is still broken!!

# docker run -d \
	# --name=flood \
	# -e HOME=/config \
	# -v /home/containerConfigs/flood/config:/config \
	# -v /mnt/plexNAS/torrents:/data \
	# -p 3000:3000 \
	# -e FLOOD_OPTION_port=3000 \
	# --restart=unless-stopped \
	# jesec/flood:master \
	# --allowedpath /data

# docker run -d --rm \
	# --name flood \
	# --hostname flood \
	# -e HOME=/config \
	# -v /home/containerConfigs/flood/config:/config \
	# -v /mnt/plexNAS/torrents:/data \
	# -p 0.0.0.0:3000:3000 \
	# jesec/flood \
	# --port 3000 \
	# --allowedpath /data

echo "All containers updated!!"