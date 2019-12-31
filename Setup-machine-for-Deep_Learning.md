# Setup machine for Deep Learning

### 1. Hardware

For studying, you can start with a small set as below:

-   AMD Ryzen™ 5 1600 CPU @ 3.20GHz
-   500 GB SSD
-   16 GB DDR4 DRAM
-   NVIDIA GeForce GTX 1070Ti

Of course, it also requires a case, power supply, keyboard, mouse and monitor. Total cost about $1500.

### 2. OS & platform

To install Ubuntu 18.04 and Python dev environment, please read these notes:

-   [Setup Ubuntu 18.04 from MinimalCD](https://github.com/greenglobal/ggml-docs/blob/master/setup_ubuntu_1804_from_minimalcd.md)
-   [Setup Python 3 dev environment](https://github.com/hoangtnm/TrainingServer-docs/blob/master/Setup_python_3_dev_environment.md)

### 3. NVIDIA driver

There is two available versions for NVIDIA graphic card’s driver: Nouveau driver and Nvidia driver. The first one is open source, by community. The last one is close source, by NVIDIA.

It is recommended to create a new configuration file, for example, `/etc/modprobe.d/disable-nouveau.conf`, rather than editing one of the existing files, such as `/etc/modprobe.d/blacklist.conf`

```
blacklist nouveau
options nouveau modeset=0
```

And install:

```shell
sudo add-apt-repository ppa:graphics-drivers/ppa 
sudo apt install nvidia-driver-440
sudo reboot
```

Recheck it using the above `cat` command or `nvidia-smi` for more detail.

### 4. Install CUDA Toolkit 10.0

CUDA Toolkit 10.0 requires `gcc-7`, while default GCC version in Ubuntu 18.04 LTS is `gcc-7` and some other Deep Learning framework requires `gcc-6`. So we have to install `gcc-6` and create symlinks as below:

```shell
cd ~/Downloads
sudo apt install gcc-6 g++-6
sudo ln -s /usr/bin/gcc-6 /usr/local/cuda/bin/gcc
sudo ln -s /usr/bin/g++-6 /usr/local/cuda/bin/g++

wget https://developer.nvidia.com/compute/cuda/10.0/Prod/local_installers/cuda_10.0.130_410.48_linux
mv cuda_10.0.130_410.48_linux cuda_10.0.130_410.48_linux.run
chmod +x cuda_10.0.130*
sudo ./cuda_10.0.130_410.48_linux.run --override
echo 'export PATH=/usr/local/cuda-10.0/bin${PATH:+:${PATH}}' >> ~/.bashrc
echo 'export LD_LIBRARY_PATH=/usr/local/cuda-10.0/lib64:/usr/local-10.0/cuda/extras/CUPTI/lib64${LD_LIBRARY_PATH:+:${LD_LIBRARY_PATH}}' >> ~/.bashrc
source ~/.bashrc
```

To remember, the general rule is:
- ```~/.bash_profile``` is being activated just one time when you login (GUI or SSH)
- ```~/.bash_aliases``` is being activated every time when you open the terminal (window or tab)
However this behavior can be changed by modifying ```~/.bashrc```, ```~/.profile```, or ```/etc/bash.bashrc```, etc.

### 5. Install cuDNN 7.5

The NVIDIA CUDA® Deep Neural Network library (cuDNN) is a GPU-accelerated library of primitives for deep neural networks. cuDNN provides highly tuned implementations for standard routines such as forward and backward convolution, pooling, normalization, and activation layers

```shell
curl https://developer.nvidia.com/compute/machine-learning/cudnn/secure/v7.5.0.56/prod/10.0_20190219/cudnn-10.0-linux-x64-v7.5.0.56.tgz
tar -xzvf cudnn-10.0-linux-x64-v7.5.0.56.tgz
sudo cp cuda/include/cudnn.h /usr/local/cuda/include
sudo cp cuda/lib64/libcudnn* /usr/local/cuda/lib64
sudo chmod a+r /usr/local/cuda/include/cudnn.h /usr/local/cuda/lib64/libcudnn*
```

### 6. Install NCCL 2.3.5

NCCL (pronounced "Nickel") is a stand-alone library of standard collective communication routines for GPUs, implementing all-reduce, all-gather, reduce, broadcast, and reduce-scatter. It has been optimized to achieve high bandwidth on platforms using PCIe, NVLink, NVswitch, as well as networking using InfiniBand Verbs or TCP/IP sockets. NCCL supports an arbitrary number of GPUs installed in a single node or across multiple nodes, and can be used in either single- or multi-process (e.g., MPI) applications.

For more information on NCCL usage, please refer to the [NCCL documentation](https://docs.nvidia.com/deeplearning/sdk/nccl-developer-guide/index.html).

```shell
curl https://developer.nvidia.com/compute/machine-learning/nccl/secure/v2.3/prod2/CUDA9.2/txz/nccl_2.3.5-2-cuda9.2_x86_64
tar -zxvf nccl_2.3.5-2+cuda9.2_x86_64.txz
sudo cp nccl_2.3.5-2+cuda9.2_x86_64 /usr/local/NCCL2
```

Create symbolic link for NCCL header file

```shell
sudo ln -s /usr/local/NCCL2/include/nccl.h /usr/include/nccl.h
```
