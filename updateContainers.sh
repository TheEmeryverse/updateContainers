#! /bin/bash
#shell script to update and redeploy all non-root containers

#stop all containers
echo "Stopping all containers..."
docker stop prowlarr; docker stop overseerr; docker stop tautulli

#uodate all containers
echo "Updating all containers..."
docker pull lscr.io/linuxserver/overseerr:latest
docker pull tautulli/tautulli:latest
docker pull lscr.io/linuxserver/prowlarr:latest

echo "Deleting all containers..."
docker rm prowlarr; docker rm overseerr; docker rm tautulli

echo "All containers successfully deleted..."

echo "Starting containers with updated images..."

echo "Starting prowlarr..."
docker run -d \
	--name=prowlarr \
	--hostname=a4403accf5d6 \
	--mac-address=02:42:ac:11:00:04 \
	--env=TZ=America/Chicago \
	--volume=/home/hudson/prowlarr/data:/config \
	--workdir=/ \
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
	-v /home/hudson/overseerr/appdata/config:/config \
	--restart unless-stopped \
lscr.io/linuxserver/overseerr:latest

echo "Starting tautulli..."
docker run -d \
	--name=tautulli \
	--restart=unless-stopped \
	-v /home/hudson/tautulli/config:/config \
	-e TZ=America/Chicago \
	-p 8181:8181 \
tautulli/tautulli:latest

echo "All containers updated!!"