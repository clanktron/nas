FROM kairos/core-ubuntu-22-lts:latest
# General productivity utilities
RUN apt install -y fish tmux neovim tree zoxide ripgrep fzf yazi bat neofetch curl iperf speedtest-cli nmap iproute2 unzip
# System utilities
RUN apt install -y  ffmpeg intel-gpu-tools
# TODO: docker: ca-certificates containerd docker-ce docker-ce-cli
# NAS utilities
RUN apt install -y zfsutils-linux samba nfs-kernel-server nfs-common openssh-server
# Network GUI (maybe)
# RUN apt install -y cockpit

# copy over sshd_config

# set fish to be default shell

# dotfiles installation

# Import zfs pool (not at build time, the config file thing at startup)
