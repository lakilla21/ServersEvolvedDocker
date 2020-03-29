#!/bin/bash
cd /home/container

# Make internal Docker IP address available to processes.
export INTERNAL_IP=`ip route get 1 | awk '{print $NF;exit}'`

# Load Config Files
rm /home/container/Configs/UsersInput.eco
rm /home/container/Configs/DifficultyInput.eco
rm /home/container/Configs/SleepInput.eco
rm /home/container/Configs/NetworkInput.eco

[ ! -d /home/container/Configs ] && mkdir -p /home/container/Configs/
wget http://raw.githubusercontent.com/lakilla21/ServersEvolvedDocker/ECO-Server/UsersInput.eco -P /home/container/Configs/
wget http://raw.githubusercontent.com/lakilla21/ServersEvolvedDocker/ECO-Server/DifficultyInput.eco -P /home/container/Configs/
wget http://raw.githubusercontent.com/lakilla21/ServersEvolvedDocker/ECO-Server/SleepInput.eco -P /home/container/Configs/
wget http://raw.githubusercontent.com/lakilla21/ServersEvolvedDocker/ECO-Server/NetworkInput.eco -P /home/container/Configs/

if [[ ${MANUAL_CONFIG} = 'false' ]]; then
  envsubst '${WHITELIST},${BLACKLIST},${ADMINS}' < /home/container/Configs/UsersInput.eco > /home/container/Configs/Users.eco
  envsubst < /home/container/Configs/DifficultyInput.eco > /home/container/Configs/Difficulty.eco
  envsubst < /home/container/Configs/SleepInput.eco > /home/container/Configs/Sleep.eco
  envsubst < /home/container/Configs/NetworkInput.eco > /home/container/Configs/Network.eco
fi

# Replace Startup Variables
MODIFIED_STARTUP="eval $(echo ${STARTUP} | sed -e 's/{{/${/g' -e 's/}}/}/g')"
echo ":/home/container$ ${MODIFIED_STARTUP}"

# Run the Server
${MODIFIED_STARTUP}
