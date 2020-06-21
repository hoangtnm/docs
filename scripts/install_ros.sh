#!/usr/bin/env bash

echo
echo Setuping sources
echo
sudo apt-get update && sudo apt-get -y \
    install curl gnupg2 lsb-release
curl -s https://raw.githubusercontent.com/ros/rosdistro/master/ros.asc | sudo apt-key add -
sudo echo "deb [arch=$(dpkg --print-architecture)] http://packages.ros.org/ros2/ubuntu $(lsb_release -cs) main" > /etc/apt/sources.list.d/ros2-latest.list

echo
echo Installing ROS 2 packages
echo
sudo apt-get update && sudo apt-get install -y \
    ros-foxy-desktop python3-argcomplete

# echo Initializing rosdep
# sudo rosdep init
# rosdep update

echo Environment setup
echo 'source /opt/ros/melodic/setup.bash' >> ~/.bashrc

if [[ -f ~/.zshrc ]]; then
    echo 'source /opt/ros/melodic/setup.zsh' >> ~/.zshrc
fi

# echo "\n Dependencies for building packages \n"
# sudo apt-get install -y python-rosinstall python-rosinstall-generator python-wstool build-essential
