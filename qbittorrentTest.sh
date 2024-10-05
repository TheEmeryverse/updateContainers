# qbittorrent testing

docker pull lscr.io/linuxserver/qbittorrent

docker run \
	--name=qbittorrentTest \
	--TZ=America/Chicago \
	-e WEBUI_PORT=8090 \
	-v /home/containerConfigs/qbittorrentTest/config:/config \
	-v /mnt/plexNAS/torrents:/downloads \
	-p 8090:8090 \
	-p 9050:9050/udp \
	-p 9050:9050 \
	--restart=unless-stopped \
	lscr.io/linuxserver/qbittorrent