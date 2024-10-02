#! /bin/bash
cd /home/hudson/updateContainers
git checkout updateContainers.sh
git pull
chmod +x updateContainers.sh
./updateContainers.sh