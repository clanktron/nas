FROM quay.io/kairos/core-ubuntu-22-lts:latest
# fix bug
RUN apt update -y && mkdir -p /var/cache/apt/archives/partial
# General productivity utilities
RUN apt install -y fish tmux neovim tree zoxide ripgrep fzf bat neofetch curl iperf speedtest-cli nmap iproute2 unzip
#  TODO (packages not managed by apt): yazi 
RUN echo /usr/bin/fish >> /etc/shells
# System utilities
RUN apt install -y openssh-server ffmpeg 
# OPTIONAL: intel-gpu-tools
# Docker
RUN apt install -y apt-transport-https ca-certificates software-properties-common && \
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg && \
echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | tee /etc/apt/sources.list.d/docker.list > /dev/null && \
apt update -y && apt-cache policy docker-ce && apt install -y docker-ce docker-buildx-plugin docker-compose-plugin
# NAS utilities
RUN apt install -y zfsutils-linux samba nfs-kernel-server nfs-common
# Network GUI (maybe)
# RUN apt install -y cockpit

# Import zfs pool (not at build time, the config file thing at startup)

RUN export VERSION="nas-0.1"
RUN envsubst '${VERSION}' </etc/os-release
