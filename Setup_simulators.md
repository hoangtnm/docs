# AirSim

## Installing the build tools and dependencies

```bash
sudo apt-get update
sudo apt-get install wget software-properties-common
sudo add-apt-repository ppa:ubuntu-toolchain-r/test

sudo apt update
sudo apt install build-essential clang-7 lld-7 g++-7 cmake ninja-build libvulkan1 python python-pip python-dev python3-dev python3-pip libpng-dev libtiff5-dev libjpeg-dev tzdata sed curl unzip autoconf libtool rsync
```

## Building Unreal Engine 4.18

    Unreal Engine repositories are set to private. In order to gain access you need to add your GitHub username when you sign up at [www.unrealengine.com](https://www.unrealengine.com/).

```bash
git clone --depth=1 -b 4.18 https://github.com/EpicGames/UnrealEngine.git ~/UnrealEngine_4.18
cd ~/UnrealEngine_4.18
./Setup.sh && ./GenerateProjectFiles.sh && make
```
