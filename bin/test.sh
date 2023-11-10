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

cleanup() {
    rm "$DISK"
}

find_available_port() {
    start_port="$1"
    end_port="$2"
    for port in $(seq "$start_port" "$end_port"); do
        if ! nc -z localhost "$port"; then
            echo "$port"
            return
        fi
    done
    error "No available ports, exiting..."
    exit 1
}

# test created kairos iso
HASH=$(git rev-parse HEAD)
TIME=$(date +%h-%m-%N)
DISK="kairos-test-$HASH-$TIME.qcow2"
ISO=$PWD/iso/nas-0.1.1.iso
PORT_RANGE_START=60000
PORT_RANGE_END=60100
HOSTPORT=$(find_available_port "$PORT_RANGE_START" "$PORT_RANGE_END")

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
    -cdrom "$ISO"; then
    info "VM started, host will poweroff when installer is finished"
else
    error "Failed to start VM, exiting..."
    cleanup
    exit 1
fi
info "Installer is finished, VM powered off"

info "Starting VM again, machine should boot from disk now"
info "ssh should be listening on port $HOSTPORT after the system boots..."
if qemu-system-x86_64 \
    -m 4G \
    -smp 4 \
    -drive file="$DISK",format=qcow2,if=virtio \
    -cpu host \
    -machine type=q35,accel=hvf \
    -nic user,hostfwd=tcp::"$HOSTPORT"-:22; then
    info "VM shutdown successfully"
else
    error "Failed to start VM, exiting..."
    cleanup
    exit 1
fi
cleanup

    # -display none \
    # -daemonize && \
