#!/bin/bash
cd /home/container

# Make internal Docker IP address available to processes.
export INTERNAL_IP=`ip route get 1 | awk '{print $NF;exit}'`

# Load Config Files
#[ ! -d /home/container/ConanSandbox/Saved/Config/WindowsServer ] && mkdir -p /home/container/ConanSandbox/Saved/Config/WindowsServer/
#[ ! -f /home/container/ConanSandbox/Saved/Config/WindowsServer/Engine.ini ] && wget http://raw.githubusercontent.com/lakilla21/testdocker/master/Engine.ini -P /home/container/ConanSandbox/Saved/Config/WindowsServer/

# Replace Startup Variables
MODIFIED_STARTUP="eval $(echo ${STARTUP} | sed -e 's/{{/${/g' -e 's/}}/}/g')"
echo ":/home/container$ ${MODIFIED_STARTUP}"

# Run the Server
${MODIFIED_STARTUP}
