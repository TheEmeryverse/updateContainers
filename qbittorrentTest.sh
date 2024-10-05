# qbittorrent testing
docker stop qbittorrentTest; docker stop gluetun
docker rm qbittorrentTest; docker rm gluetun


docker pull qmcgaw/gluetun:latest

docker run -d --rm --cap-add=NET_ADMIN \
	--name=gluetun \
	-e VPN_SERVICE_PROVIDER=custom -e VPN_TYPE=wireguard \
	-e WIREGUARD_ENDPOINT_IP=185.159.157.23 \
	-e WIREGUARD_ENDPOINT_PORT=51820 \
	-e WIREGUARD_PUBLIC_KEY=VNNO5MYorFu1UerHvoXccW6TvotxbJ1GAGJKtzM9HTY= \
	-e WIREGUARD_PRIVATE_KEY=qKyMq+oLuW3B69+ncluL2QnSUdKYcBM+PkyFMOmjgVw= \
	-e WIREGUARD_ADDRESSES="10.2.0.2/32" \
	-p 8090:8090 \
	-p 9050:9050/udp \
	-p 9050:9050 \
	qmcgaw/gluetun:latest

docker pull lscr.io/linuxserver/qbittorrent

docker run \
	--name=qbittorrentTest \
	-e TZ=America/Chicago \
	--network=container:gluetun \
	-e WEBUI_PASSWORD=@elLazo4932@ \
	-e WEBUI_PORT=8090 \
	-v /home/containerConfigs/qbittorrentTest/config:/config \
	-v /mnt/plexNAS/torrents:/downloads \
	--restart=unless-stopped \
	lscr.io/linuxserver/qbittorrent



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

#qBittorrent
echo "Starting qbittorrent..."
docker run -d \
	--name qbittorrent \
	# --network=host \
	-e VPN_TYPE=wireguard \
	-e WEBUI_PASSWORD=@elLazo4932@ \
	-e TZ=America/Chicago \
	-e BIND_INTERFACE=yes \
	-e HEALTH_CHECK_INTERVAL=900 \
	-e HEALTH_CHECK_TIMEOUT=900 \
	-v /home/containerConfigs/qbittorrent/config:/config \
	-v /mnt/plexNAS/torrents/:/downloads \
	-p 8080:8080 \
	-p 8999:8999 \
	--restart unless-stopped \
	--cap-add NET_ADMIN \
	--sysctl net.ipv4.conf.all.src_valid_mark=1 \
trigus42/qbittorrentvpn:latest