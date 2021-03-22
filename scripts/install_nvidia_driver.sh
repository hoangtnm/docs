#!/usr/bin/env bash

set -e

echo 'Disabling Nouveau'
cat <<EOF > /etc/modprobe.d/disable-nouveau.conf
blacklist nouveau
options nouveau modeset=0
EOF

add-apt-repository ppa:graphics-drivers/ppa
apt-get update && apt-get install -y nvidia-driver-460

echo 'Regenerating the kernel initramfs'
update-initramfs -u
