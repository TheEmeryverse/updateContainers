#! /bin/bash

#stop all containers
#echo "Stopping all containers..."
#docker stop prowlarr; docker stop overseerr; docker stop tautulli; sudo docker stop qbittorrent; sudo docker stop bazarr; sudo stop readarr; sudo docker stop plex; sudo docker stop sonarr; sudo docker stop radarr

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

