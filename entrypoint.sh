#!/bin/bash
cd /home/container

# Make internal Docker IP address available to processes.
export INTERNAL_IP=`ip route get 1 | awk '{print $NF;exit}'`

# Load Config Files

[ ! -d /home/container/citadel/Saved/Config/LinuxServer ] && mkdir -p /home/container/citadel/Saved/Config/LinuxServer
[ ! -f /home/container/citadel/Saved/Config/LinuxServer/EngineInput.ini ] && wget https://raw.githubusercontent.com/lakilla21/ServersEvolvedDocker/Citadel-Server/EngineInput.ini -P /home/container/Citadel/Saved/Config/LinuxServer/
[ ! -f /home/container/citadel/Saved/Config/LinuxServer/GameInput.ini ] && wget http://raw.githubusercontent.com/lakilla21/ServersEvolvedDocker/Citadel-Server/GameInput.ini -P /home/container/Citadel/Saved/Config/LinuxServer/

envsubst < citadel/Saved/Config/LinuxServer/EngineInput.ini > citadel/Saved/Config/WindowsServer/Engine.ini
envsubst < citadel/Saved/Config/LinuxServer/GameInput.ini > citadel/Saved/Config/WindowsServer/Game.ini

# Update Server
if [ ! -z ${SRCDS_APPID} ]; then
  ./steam/steamcmd.sh +login anonymous +force_install_dir /home/container +app_update ${SRCDS_APPID} +quit
fi

# Replace Startup Variables
MODIFIED_STARTUP=`eval echo $(echo ${STARTUP} | sed -e 's/{{/${/g' -e 's/}}/}/g')`
echo ":/home/container$ ${MODIFIED_STARTUP}"

# Run the Server
${MODIFIED_STARTUP}