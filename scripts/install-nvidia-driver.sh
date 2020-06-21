#!/usr/bin/env bash

echo
echo Disabling Nouveau
echo
cat <<EOF >> /etc/modprobe.d/disable-nouveau.conf
blacklist nouveau
options nouveau modeset=0
EOF

sudo add-apt-repository ppa:graphics-drivers/ppa
sudo apt-get update && sudo apt-get install -y nvidia-driver-440

echo
echo Regenerating the kernel initramfs
echo
sudo update-initramfs -u
