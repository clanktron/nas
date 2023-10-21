FROM quay.io/kairos/core-ubuntu-22-lts:v2.4.1
ARG VERSION
# latest canonical updates
RUN apt update -y
# install system packages
#  TODO (packages not managed by apt): yazi 
COPY ./packages.txt .
RUN xargs -a packages.txt apt install -y && rm packages.txt
# preferred shell
RUN echo /usr/bin/fish >> /etc/shells
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

RUN export VERSION="nas-$VERSION"
RUN envsubst '${VERSION}' </etc/os-release
