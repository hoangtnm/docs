# Set Up Deep Learning Development Environment <!-- omit in toc -->

## Contents <!-- omit in toc -->

- [Recommended System Requirements](#recommended-system-requirements)
- [Installation Guide](#installation-guide)
  - [NVIDIA GPU Driver](#nvidia-gpu-driver)
  - [NVIDIA CUDA Toolkit 11.2, cuDNN 8 and NCCL 2](#nvidia-cuda-toolkit-112-cudnn-8-and-nccl-2)
    - [Package Manger Installation (Recommended)](#package-manger-installation-recommended)
    - [Runfile Installation](#runfile-installation)
- [Libraries and Packages](#libraries-and-packages)
  - [Python and Anaconda Individual Edition](#python-and-anaconda-individual-edition)
  - [TensorFlow 2](#tensorflow-2)
  - [PyTorch](#pytorch)
- [Tips and Tricks](#tips-and-tricks)
  - [Increasing Swap Size on Ubuntu](#increasing-swap-size-on-ubuntu)
- [References](#references)

## Recommended System Requirements

- OS: [Ubuntu 20.04 LTS](https://ubuntu.com/download/desktop)
- Processor: [AMD Ryzen 5 3600X](https://www.amd.com/en/products/cpu/amd-ryzen-5-3600x)
- Memory: 32 GB RAM
- Graphics: [NVIDIA RTX 2080 Ti](https://www.nvidia.com/en-us/geforce/graphics-cards/rtx-2080-ti/)
- Storage: 500 GB (NVMe)

## Installation Guide

### NVIDIA GPU Driver

Since Ubuntu 20.04 LST, NVIDIA hardware has been supported out of the box, so you can safely skip directly to following contents if you are using this version of Ubuntu. Otherwise, a NVIDIA Driver must be installed so that everything can work properly.

It is recommended to create a new configuration file, for example, `/etc/modprobe.d/disable-nouveau.conf`, rather than editing one of the existing files, such as `/etc/modprobe.d/blacklist.conf`.

```
cat <<EOF > /etc/modprobe.d/disable-nouveau.conf
blacklist nouveau
options nouveau modeset=0
EOF
```

Regenerate the kernel initramfs:

```bash
sudo update-initramfs -u
```

Install the latest driver:

```bash
sudo add-apt-repository ppa:graphics-drivers/ppa
sudo apt install nvidia-driver-495
sudo reboot
```

### NVIDIA CUDA Toolkit 11.2, cuDNN 8 and NCCL 2

#### Package Manger Installation (Recommended)

```bash
CUDA_VERSION='11.2'
NVARCH=x86_64
NV_CUDA_REPO_URL=https://developer.download.nvidia.com/compute/cuda/repos/ubuntu2004/${NVARCH}

sudo apt-get update && sudo apt-get install -y --no-install-recommends \
	gnupg2 curl ca-certificates
# https://developer.nvidia.com/blog/updating-the-cuda-linux-gpg-repository-key
# apt-key adv --fetch-keys ${NV_CUDA_REPO_URL}/3bf863cc.pub
sudo apt-key adv --fetch-keys https://developer.download.nvidia.com/compute/cuda/repos/ubuntu2004/x86_64/3bf863cc.pub
sudo add-apt-repository "deb ${NV_CUDA_REPO_URL} /"

# Search for package versions
# apt list -a PACKAGE | grep ${CUDA_VERSION}
sudo apt-get update && sudo apt-get install -y \
  cuda-11-2 \
  libcudnn8=8.1\*cuda${CUDA_VERSION} \
  libcudnn8-dev=8.1\*cuda${CUDA_VERSION} \
  libnccl2=2.8\*cuda${CUDA_VERSION} \
  libnccl-dev=2.8\*cuda${CUDA_VERSION}
sudo apt-mark hold \
  cuda-11-2 \
  libcudnn8 \
  libcudnn8-dev \
  libnccl2 \
  libnccl-dev

shell=$(ps -o comm= $$)
tee -a ~/."${shell}rc" << EOF
export PATH=/usr/local/cuda-11.2/bin${PATH:+:${PATH}}
export LD_LIBRARY_PATH=/usr/local/cuda-11.2/lib64:/usr/local/cuda-11.2/extras/CUPTI/lib64${LD_LIBRARY_PATH:+:${LD_LIBRARY_PATH}}
EOF
source ~/."${shell}rc"
```

To remember, the general rule is:

- `~/.bash_profile` is being activated just one time when you login (GUI or SSH)

However this behavior can be changed by modifying `~/.bashrc`, `~/.profile`, or `/etc/bash.bashrc`, etc.

#### Runfile Installation

```bash
# Archive of CUDA, cuDNN Releases
# https://developer.nvidia.com/cuda-toolkit-archive
# https://developer.nvidia.com/rdp/cudnn-archive
#
# CUDA_VERSION=11.2.2
# https://developer.nvidia.com/cuda-${CUDA_VERSION}-download-archive?target_os=Linux&target_arch=x86_64&target_distro=Ubuntu&target_version=2004&target_type=runfilelocal
wget -O cuda_installer.run https://developer.download.nvidia.com/compute/cuda/11.2.2/local_installers/cuda_11.2.2_460.32.03_linux.run
sudo ./cuda_installer.run --silent --toolkit
```

## Libraries and Packages

In order to become a successful deep learning practitioner, we need the right set of tools and
packages. This section details the programming language along with the primary libraries we’ll be using for deep learning.

### Python and Anaconda Individual Edition

[Anaconda Individual Edition](https://www.anaconda.com/distribution/) is the world’s most popular Python distribution platform with over 20 million users worldwide. You can trust in our long-term commitment to supporting the Anaconda open-source ecosystem, the platform of choice for Python data science.

Furthermore, you can build and train machine learning models using the best Python packages built by the open-source community, including scikit-learn, TensorFlow, and PyTorch.

### TensorFlow 2

`tf.keras` is TensorFlow 2's high-level API for building and training deep learning models. It's used for fast prototyping, state-of-the-art research, and production, with three key advantages:

- User-friendly
- Modular and composable
- Easy to extend

### PyTorch

[PyTorch](https://pytorch.org/) is an open source machine learning framework that accelerates the path from research prototyping to production deployment.

## Tips and Tricks

### Increasing Swap Size on Ubuntu

Now, let’s see how to increase the swap file. First thing first, make sure that you have a swap file in your system.

```sh
swapon --show
```

It will show the current swap available. If you see the type file, it indicates that you are using a swap file.

```
swapon --show
NAME      TYPE SIZE USED PRIO
/swapfile file   2G   0B   -2
```

Let's begin:

```sh
sudo swapoff /swapfile
sudo fallocate -l 4G /swapfile
sudo chmod 600 /swapfile
sudo mkswap /swapfile
sudo swapon /swapfile
echo '/swapfile none swap sw 0 0' | tee -a /etc/fstab
```

That’s it. You just increased the swap size in Ubuntu from 2 GB to 4 GB. You can check swap size using `swapon --show` command.

## References

[1] A. Rosebrock, _Deep Learning for Computer Vision with Python, Starter Bundle._ PyImageSearch, 2017.
