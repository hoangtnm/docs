# Configuring Deep Learning Development Environment <!-- omit in toc -->

## Contents <!-- omit in toc -->

- [Recommended System Requirements](#recommended-system-requirements)
- [Installation Guide](#installation-guide)
	- [NVIDIA GPU Driver](#nvidia-gpu-driver)
	- [NVIDIA CUDA Toolkit 10.1](#nvidia-cuda-toolkit-101)
	- [NVIDIA cuDNN](#nvidia-cudnn)
	- [NVIDIA NCCL](#nvidia-nccl)
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
sudo apt install nvidia-driver-440
sudo reboot
```

### NVIDIA CUDA Toolkit 10.1

```bash
CUDA='10.1'

sudo apt-get update && sudo apt-get install -y --no-install-recommends \
	gnupg2 curl ca-certificates

apt-key adv --fetch-keys http://developer.download.nvidia.com/compute/machine-learning/repos/ubuntu1804/x86_64/7fa2af80.pub
echo 'deb https://developer.download.nvidia.com/compute/cuda/repos/ubuntu1804/x86_64 /' > /etc/apt/sources.list.d/cuda.list

sudo apt-get update && sudo apt-get install -y --no-install-recommends \
	build-essential \
	cuda-compat-10-1 \
	libcublas10=10.2.1.243-1 \ 
	libcublas-dev=10.2.1.243-1 \
	cuda-nvrtc-${CUDA/./-} \
	cuda-nvrtc-dev-${CUDA/./-} \
	cuda-cudart-${CUDA/./-} \
	cuda-cudart-dev-${CUDA/./-} \
	cuda-cufft-dev-${CUDA/./-} \
	cuda-curand-dev-${CUDA/./-} \
	cuda-cusolver-dev-${CUDA/./-} \
	cuda-cusparse-dev-${CUDA/./-} \
	cuda-command-line-tools-${CUDA/./-} \
	cuda-nvml-dev-${CUDA/./-} \
	cuda-libraries-${CUDA/./-} \
	cuda-libraries-dev-${CUDA/./-} \
	cuda-minimal-build-${CUDA/./-} \
	cuda-nvtx-${CUDA/./-} \
	cuda-nvprof-${CUDA/./-} \
	cuda-npp-dev-${CUDA/./-} \
	libnccl2=${NCCL_VERSION}+cuda${CUDA} \
	libnccl-dev=${NCCL_VERSION}+cuda${CUDA} \
	libcudnn7=${CUDNN_VERSION}+cuda${CUDA} \
	&& apt-mark hold libcublas10 libcublas-dev

echo 'export PATH=/usr/local/cuda-10.1/bin${PATH:+:${PATH}}' >> ~/.bashrc
echo 'export LD_LIBRARY_PATH=/usr/local/cuda-10.1/lib64:/usr/local-10.1/cuda/extras/CUPTI/lib64${LD_LIBRARY_PATH:+:${LD_LIBRARY_PATH}}' >> ~/.bashrc
source ~/.bashrc
```

To remember, the general rule is:

- `~/.bash_profile` is being activated just one time when you login (GUI or SSH)
- `~/.bash_aliases` is being activated every time when you open the terminal (window or tab)

However this behavior can be changed by modifying `~/.bashrc`, `~/.profile`, or `/etc/bash.bashrc`, etc.

### NVIDIA cuDNN

The NVIDIA CUDA® Deep Neural Network library (cuDNN) is a GPU-accelerated library of primitives for deep neural networks. cuDNN provides highly tuned implementations for standard routines such as forward and backward convolution, pooling, normalization, and activation layers

```bash
CUDNN_VERSION='7.6.5.32'

echo 'deb https://developer.download.nvidia.com/compute/machine-learning/repos/ubuntu1804/x86_64 /' > /etc/apt/sources.list.d/nvidia-ml.list

sudo apt-get update && sudo apt-get install -y \
	libcudnn7=${CUDNN_VERSION}-1+cuda${CUDA} \
	libcudnn7-dev=${CUDNN_VERSION}-1+cuda${CUDA}
sudo apt-mark hold libcudnn7
```

### NVIDIA NCCL

The NVIDIA Collective Communications Library (NCCL) implements multi-GPU and multi-node collective communication primitives that are performance optimized for NVIDIA GPUs. NCCL provides routines such as all-gather, all-reduce, broadcast, reduce, reduce-scatter, that are optimized to achieve high bandwidth and low latency over PCIe and NVLink high-speed interconnect.

```bash
NCCL_VERSION='2.7.8'

sudo apt-get install -y \
	libnccl2=${NCCL_VERSION}-1+cuda${CUDA} \
	libnccl-dev=${NCCL_VERSION}-1+cuda${CUDA}
sudo apt-mark hold libnccl2
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
```

That’s it. You just increased the swap size in Ubuntu from 2 GB to 4 GB. You can check swap size using `swapon --show` command.

## References

[1] A. Rosebrock, _Deep Learning for Computer Vision with Python, Starter Bundle._ PyImageSearch, 2017.
