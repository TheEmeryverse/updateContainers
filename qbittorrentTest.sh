# qbittorrent testing

docker pull lscr.io/linuxserver/qbittorrent

docker run \
	--name=qbittorrentTest \
	-e TZ=America/Chicago \
	-e WEBUI_PASSWORD=password \
	-e WEBUI_PORT=8090 \
	-v /home/containerConfigs/qbittorrentTest/config:/config \
	-v /mnt/plexNAS/torrents:/downloads \
	-p 8090:8090 \
	-p 9050:9050/udp \
	-p 9050:9050 \
	--restart=unless-stopped \
	lscr.io/linuxserver/qbittorrent

docker run -it --rm --cap-add=NET_ADMIN \
	--name=gluetun \
	-e VPN_SERVICE_PROVIDER=custom -e VPN_TYPE=wireguard \
	-e WIREGUARD_ENDPOINT_IP= 185.159.157.23 \
	-e WIREGUARD_ENDPOINT_PORT=51820 \
	-e WIREGUARD_PUBLIC_KEY=VNNO5MYorFu1UerHvoXccW6TvotxbJ1GAGJKtzM9HTY= \
	-e WIREGUARD_PRIVATE_KEY=qKyMq+oLuW3B69+ncluL2QnSUdKYcBM+PkyFMOmjgVw= \
	-e WIREGUARD_ADDRESSES="10.2.0.2/32" \
qmcgaw/gluetun

# [Interface]
# Bouncing = 2
# NetShield = 0
# Moderate NAT = off
# NAT-PMP (Port Forwarding) = on
# VPN Accelerator = on
# PrivateKey = qKyMq+oLuW3B69+ncluL2QnSUdKYcBM+PkyFMOmjgVw=
# Address = 10.2.0.2/32
# DNS = 10.2.0.1

# [Peer]
# CH#352
# PublicKey = VNNO5MYorFu1UerHvoXccW6TvotxbJ1GAGJKtzM9HTY=
# AllowedIPs = 0.0.0.0/0
# Endpoint = 185.159.157.23:51820