#!/usr/bin/env bash

echo 'blacklist nouveau\noptions nouveau modeset=0' >> /etc/modprobe.d/disable-nouveau.conf

sudo add-apt-repository ppa:graphics-drivers/ppa && \
sudo apt-get update && sudo apt-get install -y nvidia-driver-440
