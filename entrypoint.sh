#!/bin/bash
cd /home/container

# Make internal Docker IP address available to processes.
export INTERNAL_IP=`ip route get 1 | awk '{print $NF;exit}'`

# Load Config Files
rm /home/container/Astro/Saved/Config/WindowsServer/AstroServerSettingsInput.ini
rm /home/container/Astro/Saved/Config/WindowsServer/EngineInput.ini

wget https://raw.githubusercontent.com/lakilla21/ServersEvolvedDocker/Astroneer/AstroServerSettingsInput.ini -P /home/container/Astro/Saved/Config/WindowsServer
wget https://raw.githubusercontent.com/lakilla21/ServersEvolvedDocker/Astroneer/EngineInput.ini -P /home/container/Astro/Saved/Config/WindowsServer

cd /home/container/Astro/Saved/Config/WindowsServer

if [[ ${MANUAL_CONFIG} = 'false' ]]; then
  envsubst < AstroServerSettingsInput.ini > AstroServerSettings.ini
  envsubst < EngineInput.ini > Engine.ini
fi

cd /home/container
# Update Server
if [ ! -z ${SRCDS_APPID} ]; then
  ./steamcmd/steamcmd.sh +login anonymous +force_install_dir /home/container +app_update ${SRCDS_APPID} +quit
fi

# Replace Startup Variables
MODIFIED_STARTUP=`eval echo $(echo ${STARTUP} | sed -e 's/{{/${/g' -e 's/}}/}/g')`
echo ":/home/container$ ${MODIFIED_STARTUP}"

# Run the Server
${MODIFIED_STARTUP}