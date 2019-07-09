#! /bin/bash

echo "\n Configuring your Ubuntu repositories \n"
sudo sh -c 'echo "deb http://packages.ros.org/ros/ubuntu $(lsb_release -sc) main" > /etc/apt/sources.list.d/ros-latest.list'
sudo apt-key adv --keyserver 'hkp://keyserver.ubuntu.com:80' --recv-key C1CF6E31E6BADE8868B172B4F42ED6FBAB17C654

echo "\n Installing ros-melodic-desktop-full \n"
sudo apt install ros-melodic-desktop-full

echo "\n Initializing rosdep \n"
sudo rosdep init
rosdep update

echo "\n Environment setup \n"
echo "source /opt/ros/melodic/setup.bash" >> ~/.bashrc
source ~/.bashrc

if [[ -f ~/.zshrc ]]; then
    echo "source /opt/ros/melodic/setup.zsh" >> ~/.zshrc
fi
