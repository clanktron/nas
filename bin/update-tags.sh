#!/bin/sh
# update image tags in cloud config files
#
# text attributes
# bold=$(tput bold)
green=$(tput setaf 2)
orange=$(tput setaf 166)
red=$(tput setaf 1)
light_green=$(tput setaf 178)
light_orange=$(tput setaf 208)
light_red=$(tput setaf 196)
reset=$(tput sgr0)

info() {
    echo "${green}[ INFO ]${reset} ${light_green}$1${reset}"
}

warn() {
    echo "${orange}[ WARN ]${reset} ${light_orange}$1${reset}"
}

error() {
    echo "${red}[ ERROR ]${reset} ${light_red}$1${reset}"
}

TAG=$(git rev-parse HEAD)
IMAGE_NAME="${IMAGE_NAME:-quay.io/clanktron/nas}"
IMAGE="${IMAGE:-$IMAGE_NAME:$TAG}"

replaceTag() {
    FILE="$1"
    tmpfile=$(mktemp)
    info "Updating install image..."
    if yq eval ".install.image = \"$IMAGE\"" "$FILE" > "$tmpfile" ; then
        info "Install image successfully set to $IMAGE!"
    else
        error "Failed to update install image, exiting..." && exit 1
    fi
    cp "$tmpfile" "$FILE"
    rm "$tmpfile"
}

replaceTag ./cloud-config/base.yaml
