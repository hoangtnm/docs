# Setup machine for Deep Learning

### 1. Hardware

- AMD Ryzen™ 3000 Series Processors
- 32 GB DDR4 Memory
- 500 GB SSD (NVMe)
- NVIDIA GeForce RTX 2080 Ti

### 2. OS & platform

- [Ubuntu 18.04.4 LTS](https://ubuntu.com/download/desktop)
- [Anaconda with Python 3](https://www.anaconda.com/distribution/)

### 3. NVIDIA Driver

It is recommended to create a new configuration file, for example, `/etc/modprobe.d/disable-nouveau.conf`, rather than editing one of the existing files, such as `/etc/modprobe.d/blacklist.conf`

```
blacklist nouveau
options nouveau modeset=0
```

Regenerate the kernel initramfs:

```sh
sudo update-initramfs -u
```

Install the latest driver:

```shell
sudo add-apt-repository ppa:graphics-drivers/ppa
sudo apt install nvidia-driver-440
sudo reboot
```

### 4. CUDA Toolkit 10.1

<!-- CUDA Toolkit 10.0 requires `gcc-7`, while default GCC version in Ubuntu 18.04 LTS is `gcc-7` and some other Deep Learning framework requires `gcc-6`. So we have to install `gcc-6` and create symlinks as below: -->

```sh
wget http://developer.download.nvidia.com/compute/cuda/10.1/Prod/local_installers/cuda_10.1.243_418.87.00_linux.run
sudo sh cuda_10.1.243_418.87.00_linux.run
echo 'export PATH=/usr/local/cuda-10.1/bin${PATH:+:${PATH}}' >> ~/.bashrc
echo 'export LD_LIBRARY_PATH=/usr/local/cuda-10.1/lib64:/usr/local-10.1/cuda/extras/CUPTI/lib64${LD_LIBRARY_PATH:+:${LD_LIBRARY_PATH}}' >> ~/.bashrc
source ~/.bashrc
```

To remember, the general rule is:

- `~/.bash_profile` is being activated just one time when you login (GUI or SSH)
- `~/.bash_aliases` is being activated every time when you open the terminal (window or tab)
  However this behavior can be changed by modifying `~/.bashrc`, `~/.profile`, or `/etc/bash.bashrc`, etc.

### 5. NVIDIA cuDNN

The NVIDIA CUDA® Deep Neural Network library (cuDNN) is a GPU-accelerated library of primitives for deep neural networks. cuDNN provides highly tuned implementations for standard routines such as forward and backward convolution, pooling, normalization, and activation layers

```sh
export CUDNN_VERSION=7.6.5.32

wget https://developer.download.nvidia.com/compute/machine-learning/repos/ubuntu1804/x86_64/nvidia-machine-learning-repo-ubuntu1804_1.0.0-1_amd64.deb
sudo dpkg -i nvidia-machine-learning-repo-ubuntu1804_1.0.0-1_amd64.deb
sudo apt-key adv --fetch-keys http://developer.download.nvidia.com/compute/machine-learning/repos/ubuntu1804/x86_64/7fa2af80.pub
sudo apt update && sudo apt install -y \
    libcudnn7=$CUDNN_VERSION-1+cuda10.1 \
    libcudnn7-dev=$CUDNN_VERSION-1+cuda10.1
sudo apt-mark hold libcudnn7 libcudnn7-dev
```

<!-- ### 6. Install NCCL 2.4.8

NCCL (pronounced "Nickel") is a stand-alone library of standard collective communication routines for GPUs, implementing all-reduce, all-gather, reduce, broadcast, and reduce-scatter. It has been optimized to achieve high bandwidth on platforms using PCIe, NVLink, NVswitch, as well as networking using InfiniBand Verbs or TCP/IP sockets. NCCL supports an arbitrary number of GPUs installed in a single node or across multiple nodes, and can be used in either single- or multi-process (e.g., MPI) applications.

```sh
export NCCL_VERSION=2.4.8

sudo apt install -y \
    libnccl2=$NCCL_VERSION-1+cuda10.1 \
    libnccl-dev=$NCCL_VERSION-1+cuda10.1
sudo apt-mark hold libnccl2 libnccl-dev
``` -->

### Tips and Tricks

#### 1. Increasing Swap Size on Ubuntu

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
sudo mkswap /swapfile
sudo swapon /swapfile
```

That’s it. You just increased the swap size in Ubuntu from 2 GB to 4 GB. You can check swap size using `swapon --show` command.