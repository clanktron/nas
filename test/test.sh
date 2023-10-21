#!/bin/sh
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

# test created kairos iso
HASH=$(git rev-parse HEAD)
DISK="kairos-test-$HASH.qcow2"
HOSTPORT=60020
ISO=../

info "Creating VM disk for test machine"
qemu-img create -f qcow2 "$DISK" 30G && \
    info "Created disk" || \
    error "Failed to create VM disk, exiting..." && exit 1

info "Starting VM, machine should boot from attached iso"
qemu-system-x86_64 \
    -m 4G \
    -smp 4 \
    -drive file="$DISK",format=qcow2,if=virtio \
    -cpu host \
    -machine type=q35,accel=hvf \
    -nic user,hostfwd=tcp::"$HOSTPORT"-:22 \
    -cdrom "$ISO" && \
    info "VM started, host will poweroff when installer is finished" || \
    error "Failed to start VM, exiting..." && exit 1
info "Installer is finished, VM powered off"
# now we wait for the ISO to finish installing :)
#
#
info "Starting VM again, machine should boot from disk now"
qemu-system-x86_64 \
    -m 4G \
    -smp 4 \
    -drive file="$DISK",format=qcow2,if=virtio \
    -cpu host \
    -machine type=q35,accel=hvf \
    -nic user,hostfwd=tcp::"$HOSTPORT"-:22 \
    -display none \
    -daemonize && \
    info "VM started, ssh should be listening on port $HOSTPORT" || \
    error "Failed to start VM, exiting..." && exit 1
