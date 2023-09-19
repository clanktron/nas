FROM kairos/core-ubuntu-22-lts:latest
# General productivity utilities
RUN apt install -y fish tmux neovim tree zoxide ripgrep fzf yazi bat neofetch curl iperf speedtest-cli nmap iproute2 unzip
# System utilities
RUN apt install -y docker containerd docker-ce docker-ce-cli ffmpeg ca-certificates intel-gpu-tools
# NAS utilities
RUN apt install -y zfsutils-linux samba nfs-kernel-server nfs-common openssh-server
# GUI
RUN apt install -y cockpit

# Import zfs pool

# copy over sshd_config
