#! /bin/bash

#stop all containers
echo "Stopping all containers..."
#docker stop prowlarr; docker stop overseerr; docker stop tautulli; sudo docker stop qbittorrent; sudo docker stop bazarr; sudo stop readarr; sudo docker stop plex; sudo docker stop sonarr; sudo docker stop radarr
sudo docker stop sonarr; sudo docker stop radarr

#uodate all containers
echo "Updating all containers..."
docker pull lscr.io/linuxserver/overseerr:latest
docker pull tautulli/tautulli:latest
docker pull hotio/prowlarr:latest
sudo docker pull trigus42/qbittorrentvpn:latest
sudo docker pull hotio/bazarr:latest
sudo docker pull hotio/readarr
sudo docker pull lscr.io/linuxserver/plex:latest
sudo docker pull hotio/sonarr:latest
sudo docker pull hotio/radarr:latest

echo "Deleting all containers"
#docker rm prowlarr; docker rm overseerr; docker rm tautulli; sudo docker rm qbittorrent; sudo docker rm bazarr; sudo docker rm readarr; sudo docker plex; sudo docker rm sonarr; sudo docker rm radarr
sudo docker rm radarr; sudo docker rm sonarr


echo "All containers successfully deleted..."

echo "Starting containers with updated images..."

echo "Starting radarr..."
sudo docker run -d \
	--name=radarr \
	--hostname=2d9eea69def0 \
	--mac-address=02:42:ac:11:00:06 \
	--volume=/home/hudson/radarr/config:/config \
	--volume=/home/hudson/data/torrents:/downloads \
	--volume=/home/hudson/data/media/movies:/movies \
	--network=bridge \
	-p 7878:7878 \
	--restart=unless-stopped \
	--runtime=runc \
hotio/radarr:latest

echo "Starting sonarr..."
sudo docker run -d \
	--name=sonarr \
	--hostname=c8a71a008167 \
	--mac-address=02:42:ac:11:00:05 \
	--volume=/home/hudson/sonarr/config:/config \
	--volume=/home/hudson/data/torrents/:/downloads \
	--volume=/home/hudson/data/media/tv:/tv \
	--network=bridge \
	-p 8989:8989 \
	--restart=unless-stopped \
	--runtime=runc \
hotio/sonarr:latest
