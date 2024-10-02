#! /bin/bash
cd /home/hudson/updateContainers
git checkout updateContainers.sh
git checkout rootupdateContainers.sh
git pull
bash ./updateContainers.sh