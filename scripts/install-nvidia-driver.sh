#!/usr/bin/env bash

echo 'blacklist nouveau\noptions nouveau modeset=0' >> /etc/modprobe.d/disable-nouveau.conf

sudo add-apt-repository ppa:graphics-drivers/ppa && \
sudo apt update && \
sudo apt install -y nvidia-driver-435
