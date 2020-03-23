#!/bin/bash
cd /home/container
sleep 1
# Make internal Docker IP address available to processes.
export INTERNAL_IP=`ip route get 1 | awk '{print $NF;exit}'`

# Update Source Server
if [ ! -z ${SRCDS_APPID} ]; then
    if [ ! -z ${SRCDS_BETAID} ]; then
        if [ ! -z ${SRCDS_BETAPASS} ]; then
            ./steamcmd/steamcmd.sh +login anonymous +force_install_dir /home/container +app_update ${SRCDS_APPID} -beta ${SRCDS_BETAID} -betapassword ${SRCDS_BETAPASS} +quit
        else
            ./steamcmd/steamcmd.sh +login anonymous +force_install_dir /home/container +app_update ${SRCDS_APPID} -beta ${SRCDS_BETAID} +quit
        fi
    else
        ./steamcmd/steamcmd.sh +login anonymous +force_install_dir /home/container +app_update ${SRCDS_APPID} +quit
    fi
fi

#Custom Config Setup - Servers Evolved
#[ ! -d /home/container/csgo/cfg ] && mkdir -p /home/container/csgo/cfg
#rm csgo/cfg/ServerInput.cfg
#wget http://raw.githubusercontent.com/lakilla21/ServersEvolvedDocker/CSGO/ServerInput.cfg -P /home/container/csgo/cfg/
#envsubst < /home/container/csgo/cfg/ServerInput.cfg > /home/container/csgo/cfg/Server.cfg

[ ! -d /home/container/garrysmod/cfg ] && mkdir -p /home/container/garrysmod/cfg
rm garrysmod/cfg/ServerInput.cfg
wget https://raw.githubusercontent.com/lakilla21/ServersEvolvedDocker/Gmod/ServerInput.cfg -P /home/container/garrysmod/cfg/

if [[ ${MANUAL_CONFIG} = 'false' ]]; then
  envsubst < garrysmod/cfg/ServerInput.cfg > garrysmod/cfg/server.cfg
fi

# Replace Startup Variables
MODIFIED_STARTUP=`eval echo $(echo ${STARTUP} | sed -e 's/{{/${/g' -e 's/}}/}/g')`
echo ":/home/container$ ${MODIFIED_STARTUP}"

# Run the Server
eval ${MODIFIED_STARTUP}
