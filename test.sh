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
TIME=$(date +%h-%m-%N)
DISK="kairos-test-$HASH-$TIME.qcow2"
HOSTPORT=60020
ISO=./nas-0.1.1.iso

cleanup() {
    rm "$DISK"
}

info "Creating VM disk for test machine"
if qemu-img create -f qcow2 "$DISK" 30G; then
    info "Created disk"
else
    error "Failed to create VM disk, exiting..."
    exit 1
fi
info "Starting VM, machine should boot from attached iso"
if qemu-system-x86_64 \
    -m 4G \
    -smp 4 \
    -drive file="$DISK",format=qcow2,if=virtio \
    -cpu host \
    -machine type=q35,accel=hvf \
    -nic user,hostfwd=tcp::"$HOSTPORT"-:22 -cdrom "$ISO"; then
    info "VM started, host will poweroff when installer is finished"
else
    error "Failed to start VM, exiting..."
    cleanup
    exit 1
fi
info "Installer is finished, VM powered off"

info "Starting VM again, machine should boot from disk now"
if qemu-system-x86_64 \
    -m 4G \
    -smp 4 \
    -drive file="$DISK",format=qcow2,if=virtio \
    -cpu host \
    -machine type=q35,accel=hvf \
    -nic user,hostfwd=tcp::"$HOSTPORT"-:22; then
    info "VM started, ssh should be listening on port $HOSTPORT"
else
    error "Failed to start VM, exiting..."
    cleanup
    exit 1
fi
cleanup

    # -display none \
    # -daemonize && \
