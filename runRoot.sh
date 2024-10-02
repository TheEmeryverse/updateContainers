#! /bin/bash
cd /home/hudson/updateContainers
git checkout rootupdateContainers.sh
git pull
chmod +x rootupdateContainers.sh
./rootupdateContainers.sh