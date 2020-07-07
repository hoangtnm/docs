#!/usr/bin/env bash

#
# Setup sources
# 

apt-get update && apt-get install -y \
    curl gnupg2 lsb-release
curl -s https://raw.githubusercontent.com/ros/rosdistro/master/ros.asc | sudo apt-key add -
echo "deb [arch=$(dpkg --print-architecture)] http://packages.ros.org/ros2/ubuntu $(lsb_release -cs) main" > /etc/apt/sources.list.d/ros2-latest.list

#
# Install ROS 2 packages
#

apt-get update && apt-get install -y \
    ros-foxy-desktop python3-argcomplete

# echo Initializing rosdep
# sudo rosdep init
# rosdep update

#
# Environment setup
#

shell="$0"

echo "source /opt/ros/melodic/setup.${shell}" >> ~/."${shell}rc"

# echo "\n Dependencies for building packages \n"
# sudo apt-get install -y python-rosinstall python-rosinstall-generator python-wstool build-essential
