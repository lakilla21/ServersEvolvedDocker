#!/bin/bash
cd /home/container

# Make internal Docker IP address available to processes.
export INTERNAL_IP=`ip route get 1 | awk '{print $NF;exit}'`

# Load Config Files
[ ! -d /home/container/ConanSandbox/Saved/Config/WindowsServer ] && mkdir -p /home/container/ConanSandbox/Saved/Config/WindowsServer/
[ ! -f /home/container/ConanSandbox/Saved/Config/WindowsServer/EngineInput.ini ] && wget http://raw.githubusercontent.com/lakilla21/ServersEvolvedDocker/Conan-Exiles/EngineInput.ini -P /home/container/ConanSandbox/Saved/Config/WindowsServer/
[ ! -f /home/container/ConanSandbox/Saved/Config/WindowsServer/GameInput.ini ] && wget http://raw.githubusercontent.com/lakilla21/ServersEvolvedDocker/Conan-Exiles/GameInput.ini -P /home/container/ConanSandbox/Saved/Config/WindowsServer/
[ ! -f /home/container/ConanSandbox/Saved/Config/WindowsServer/ServerSettingsInput.ini ] && wget http://raw.githubusercontent.com/lakilla21/ServersEvolvedDocker/Conan-Exiles/ServerSettingsInput.ini -P /home/container/ConanSandbox/Saved/Config/WindowsServer/

envsubst < ConanSandbox/Saved/Config/WindowsServer/EngineInput.ini > ConanSandbox/Saved/Config/WindowsServer/Engine.ini
envsubst < ConanSandbox/Saved/Config/WindowsServer/GameInput.ini > ConanSandbox/Saved/Config/WindowsServer/Game.ini
envsubst < ConanSandbox/Saved/Config/WindowsServer/ServerSettingsInput.ini > ConanSandbox/Saved/Config/WindowsServer/ServerSettings.ini

# Update Server
if [ ! -z ${SRCDS_APPID} ]; then
  ./steam/steamcmd.sh +@sSteamCmdForcePlatformType windows +login anonymous +force_install_dir /home/container +app_update ${SRCDS_APPID} +quit
fi

#Mod updates
cleanmodids=$(echo ${MODIDS} | tr -d ' ')
updatelist=""
if [ ! -z $cleanmodids ]; then
  #Conan Exiles
  if [[ ${SRCDS_APPID} == "443030" ]]; then
    printf "Updating Conan Exiles mods\n"
    for i in $(echo $cleanmodids | sed "s/,/ /g")
    do
      updatelist="$updatelist +workshop_download_item 440900 $i validate"
    done
    ./steam/steamcmd.sh +login anonymous +force_install_dir /home/container $updatelist +quit
    mkdir -p /home/container/ConanSandbox/Mods
    find /home/container/steamapps/workshop/content/440900 -iname "*.pak" -exec cp {} /home/container/ConanSandbox/Mods \;
    cd /home/container/ConanSandbox/Mods
    rm modlist.txt
    ls |grep "\.pak$" > modlist.txt
    cd /home/container
    printf "\n\nMods updated\n\n"
  fi
fi

# Replace Startup Variables
MODIFIED_STARTUP=`eval echo $(echo ${STARTUP} | sed -e 's/{{/${/g' -e 's/}}/}/g')`
echo ":/home/container$ ${MODIFIED_STARTUP}"

# Run the Server
${MODIFIED_STARTUP}
