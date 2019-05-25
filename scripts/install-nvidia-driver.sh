#! /bin/bash

echo $'blacklist nouveau\noptions nouveau modeset=0' >> /etc/modprobe.d/disable-nouveau.conf
# sudo dracut --force
# sudo grub2-mkconfig -o /boot/grub2/grub.cfg

sudo add-apt-repository ppa:graphics-drivers/ppa
sudo apt update
sudo apt install -y nvidia-driver-430
