#! /bin/bash

echo "";
echo "Install JDK 8";
echo "";
sudo apt install curl openjdk-8-jdk

echo "";
echo "Add Bazel distribution URI as a package source";
echo "";
echo "deb [arch=amd64] http://storage.googleapis.com/bazel-apt stable jdk1.8" | sudo tee /etc/apt/sources.list.d/bazel.list
curl https://bazel.build/bazel-release.pub.gpg | sudo apt-key add -

echo "";
echo "Install and update Bazel":
echo "";
sudo apt update && sudo apt install bazel

echo "";
echo "The installation completed";
echo "";
