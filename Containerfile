FROM quay.io/kairos/core-ubuntu-22-lts:v2.4.1
ARG VERSION
# latest canonical updates
RUN apt update -y
# General productivity utilities
#  TODO (packages not managed by apt): yazi 
RUN apt install -y git-all fish tmux neovim tree zoxide ripgrep fzf bat neofetch curl unzip intel-gpu-tools mediainfo
RUN echo /usr/bin/fish >> /etc/shells
# Networking
RUN apt install -y iperf speedtest-cli nmap iproute2 ufw
# NAS utilities
RUN apt install -y zfsutils-linux samba nfs-kernel-server nfs-common
# System utilities
RUN apt install -y openssh-server ffmpeg 
# Docker
RUN apt install -y apt-transport-https ca-certificates software-properties-common \
&& curl -fsSL https://download.docker.com/linux/ubuntu/gpg | gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg \
&& echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | tee /etc/apt/sources.list.d/docker.list > /dev/null \
&& apt update -y \
&& apt-cache policy docker-ce \
&& apt install -y docker-ce docker-buildx-plugin docker-compose-plugin
# Tailscale
RUN curl -fsSL https://pkgs.tailscale.com/stable/ubuntu/jammy.noarmor.gpg | tee /usr/share/keyrings/tailscale-archive-keyring.gpg >/dev/null \
&& curl -fsSL https://pkgs.tailscale.com/stable/ubuntu/jammy.tailscale-keyring.list | tee /etc/apt/sources.list.d/tailscale.list \
&& apt update -y \
&& apt install -y tailscale
# Network GUI (maybe)
# RUN apt install -y cockpit
RUN export VERSION="nas-$VERSION"
RUN envsubst '${VERSION}' </etc/os-release
