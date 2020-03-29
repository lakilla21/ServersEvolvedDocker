# ----------------------------------
# Environment: ubuntu
# Minimum Panel Version: 0.7.X
# ----------------------------------
FROM        mono:5

LABEL       author="Michael Parker" maintainer="parker@pterodactyl.io"

RUN         useradd -d /home/container -m container \
            && apt update \
            && apt install -y gcc-6-base libgcc1 libc6 iproute2 unzip curl wget gettext-base
            && ufw disable

USER        container
ENV         USER=container HOME=/home/container
WORKDIR     /home/container

COPY        ./entrypoint.sh /entrypoint.sh
CMD ["/bin/bash", "/entrypoint.sh"]
