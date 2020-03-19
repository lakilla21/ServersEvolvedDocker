#!/bin/bash
cd /home/container

# Make internal Docker IP address available to processes.
export INTERNAL_IP=`ip route get 1 | awk '{print $NF;exit}'`

# Load Config Files

rm serverconfigInput.xml
wget https://raw.githubusercontent.com/lakilla21/ServersEvolvedDocker/7DaysToDie-server/serverconfigInput.xml -P /home/container/

if [[ ${MANUAL_CONFIG} = 'false' ]]; then
  envsubst < serverconfigInput.xml > serverconfig.xml
fi

# Update Server
if [ ! -z ${SRCDS_APPID} ]; then
  ./steamcmd/steamcmd.sh +login anonymous +force_install_dir /home/container +app_update ${SRCDS_APPID} +quit
fi

# Replace Startup Variables
MODIFIED_STARTUP=`eval echo $(echo ${STARTUP} | sed -e 's/{{/${/g' -e 's/}}/}/g')`
echo ":/home/container$ ${MODIFIED_STARTUP}"

# Run the Server
${MODIFIED_STARTUP}