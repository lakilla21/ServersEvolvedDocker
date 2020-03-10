#!/bin/bash
cd /home/container

# Make internal Docker IP address available to processes.
export INTERNAL_IP=`ip route get 1 | awk '{print $NF;exit}'`

# Load Config Files
[ ! -d /home/container/Configs ] && mkdir -p /home/container/Configs/
[ ! -f /home/container/Configs/Users.eco ] && wget http://raw.githubusercontent.com/lakilla21/ServersEvolvedDocker/ECO-Server/Users.eco -P /home/container/Configs/
[ ! -f /home/container/Configs/Difficulty.eco ] && wget http://raw.githubusercontent.com/lakilla21/ServersEvolvedDocker/ECO-Server/Difficulty.eco -P /home/container/Configs/
[ ! -f /home/container/Configs/Sleep.eco ] && wget http://raw.githubusercontent.com/lakilla21/ServersEvolvedDocker/ECO-Server/Sleep.eco -P /home/container/Configs/

# Adding Blacklist, Whitelist, and Admins
sed -i "10s/[]/[${WHITELIST}]/" /home/container/Configs/Users.eco
sed -i "16s/[]/[${BLACKLIST}]/" /home/container/Configs/Users.eco
sed -i "22s/[]/[${ADMINS}]/" /home/container/Configs/Users.eco

# Replace Startup Variables
MODIFIED_STARTUP="eval $(echo ${STARTUP} | sed -e 's/{{/${/g' -e 's/}}/}/g')"
echo ":/home/container$ ${MODIFIED_STARTUP}"

# Run the Server
${MODIFIED_STARTUP}
