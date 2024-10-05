#! /bin/bash
#shell script to update and redeploy all non-root containers

#stop all containers
echo "Stopping all containers..."
docker stop prowlarr; docker stop overseerr; docker stop tautulli; docker stop qbittorrent; docker stop bazarr; docker stop readarr; docker stop plex; docker stop sonarr; docker stop radarr

#uodate all containers
echo "Updating all containers..."
docker pull lscr.io/linuxserver/overseerr:latest
docker pull tautulli/tautulli:latest
docker pull lscr.io/linuxserver/prowlarr:
docker pull trigus42/qbittorrentvpn:latest
docker pull hotio/bazarr:latest
docker pull hotio/readarr
docker pull lscr.io/linuxserver/plex:latest
docker pull hotio/sonarr:latest
docker pull lscr.io/linuxserver/radarr:latest

echo "Deleting all containers..."
docker rm prowlarr; docker rm overseerr; docker rm tautulli; docker rm qbittorrent; docker rm bazarr; docker rm readarr; docker rm plex; docker rm sonarr; docker rm radarr

echo "All containers successfully deleted..."

echo "Starting containers with updated images..."

echo "Starting prowlarr..."
docker run -d \
	--name=prowlarr \
	--hostname=a4403accf5d6 \
	--mac-address=02:42:ac:11:00:04 \
	--env=TZ=America/Chicago \
	--volume=/home/containerConfigs/prowlarr/data:/config \
	-p 9696:9696 \
	--restart=unless-stopped \
	--runtime=runc \
lscr.io/linuxserver/prowlarr:latest

echo "Starting overseerr..."
docker run -d \
	--name=overseerr \
	--mac-address=02:42:ac:11:00:05 \
	-e TZ=Etc/UTC \
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
tautulli/tautulli:

#qBittorrent
echo "Starting qbittorrent..."
docker run -d \
	--name qbittorrent \
	-e VPN_TYPE=wireguard \
	-e WEBUI_PASSWORD=@elLazo4932@ \
	-e TZ=America/Chicago \
	-e BIND_INTERFACE=yes \
	-e HEALTH_CHECK_INTERVAL=900 \
	-e HEALTH_CHECK_TIMEOUT=900 \
	-v /home/containerConfigs/qbittorrent/config:/config \
	-v /mnt/plexNAS/torrents/:/downloads \
	-p 8080:8080 \
	--restart unless-stopped \
	--cap-add NET_ADMIN \
	--sysctl net.ipv4.conf.all.src_valid_mark=1 \
trigus42/qbittorrentvpn:latest

echo "Starting bazarr..."
docker run -d \
	--name=bazarr \
	--hostname=6dc2eef9524a \
	--mac-address=02:42:ac:11:00:0a \
	--volume=/mnt/plexNAS/media/tv:/tv \
	--volume=/mnt/plexNAS/media/movies:/movies \
	--volume=/home/containerConfigs/bazarr/config:/config \
	--network=bridge \
	-p 6767:6767 \
	--restart=no \
	--runtime=runc \
hotio/bazarr:latest

echo "Starting readarr..."
docker run -d \
	--name=readarr \
	--env=TZ=Etc/UTC \
	--volume=/mnt/plexNAS/media/audiobooks:/audiobooks \
	--volume=/mnt/plexNAS/torrents/audiobooks:/downloads/audiobooks \
	--volume=/home/containerConfigs/readarr/config:/config \
	--network=bridge \
	--workdir=/ \
	-p 8787:8787 \
	--restart=unless-stopped \
	--runtime=runc \
hotio/readarr

echo "Starting plex..."
docker run -d \
	--name=plex \
	--net=host \
	-e TZ=America/Chicago \
	-e VERSION=docker \
	-p 32400:32400 \
	-e PLEX_CLAIM=claim-W_Qx5smRRpWbGziPJu2d \
	-v /mnt/plexNAS/media/plex_database/config:/config \
	-v /mnt/plexNAS/media/tv:/tv \
	-v /mnt/plexNAS/media/movies:/movies \
	-v /mnt/plexNAS/media/audiobooks:/audiobooks \
	-v /mnt/plexNAS/media/music:/music \
	-v /tmp:/transcode \
	--restart unless-stopped \
lscr.io/linuxserver/plex:latest

echo "Starting sonarr..."
docker run -d \
	--name=sonarr \
	--hostname=c8a71a008167 \
	--mac-address=02:42:ac:11:00:05 \
	--volume=/home/containerConfigs/sonarr/config:/config \
	--volume=/mnt/plexNAS/torrents/:/downloads \
	--volume=/mnt/plexNAS/media/tv:/tv \
	--network=bridge \
	-p 8989:8989 \
	--restart=unless-stopped \
	--runtime=runc \
hotio/sonarr:latest

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

echo "All containers updated!!"