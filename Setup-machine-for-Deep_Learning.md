# Setup machine for Deep Learning

### 1. Hardware

For studying, you can start with a small set as below:

-   AMD Ryzen™ 5 1600 CPU @ 3.20GHz
-   500 GB hard drive (SSD)
-   16 GB RAM (DDR4)
-   nVidia GP104 [GeForce GTX 1070Ti 8GB]

Of course, it also requires a case, power supply, keyboard, mouse and monitor. Total cost about $1500.

### 2. OS & platform

To install Ubuntu 18.04 and Python dev environment, please read these notes:

-   [Setup Ubuntu 18.04 from MinimalCD](https://github.com/greenglobal/ggml-docs/blob/master/setup_ubuntu_1804_from_minimalcd.md)
-   [Setup Python 3 dev environment](https://github.com/hoangtnm/TrainingServer-docs/blob/master/Setup_python_3_dev_environment.md)

### 3. NVIDIA driver

There is two available versions for NVIDIA graphic card’s driver: Nouveau driver and Nvidia driver. The first one is open source, by community. The last one is close source, by NVIDIA.

Normally, Nvidia driver is default. For Ubuntu, it’s `nvidia-390`. We can check it with:

```shell
cat /proc/driver/nvidia/version
```

If it’s not there for some reason, just install it.

From GUI, you can choose it via Drivers Management tool. It will be downloaded and installed automatically.

![](https://cdn-images-1.medium.com/max/800/1*JrKer_82RJybSbiBFHLo8A.jpeg)

You can install Nvidia driver via terminal too. For this case, many experts suggest to add Nouveau to blacklist first:

sudo nano /etc/modprobe.d/blacklist.conf

Then paste the following lines into then save it:

```
blacklist vga16fb
blacklist nouveau
blacklist rivafb
blacklist nvidiafb
blacklist rivatv
```

And install:

```shell
sudo add-apt-repository ppa:graphics-drivers/ppa 
sudo apt update
sudo apt install nvidia-396 nvidia-396-dev
reboot
```

Recheck it using the above `cat` command or `nvidia-smi` for more detail.

### 4. Install CUDA Toolkit 9.2

IMHO, it’s always best practice to install pip modules into the virtual environments, and use TensorFlow from PyPI. This will provide a flexible solution. For the same reason, I didn’t recommend to use Anaconda.

CUDA v9.2 requires GCC 7, while default GCC version in Ubuntu 17.10 is GCC 7.2 and some other Deep Learning framework requires GCC 6. So we have to install GCC 6 and create symlinks as below:

```shell
cd ~/Downloads
sudo apt install gcc-6 g++-6
sudo ln -s /usr/bin/gcc-6 /usr/local/cuda/bin/gcc
sudo ln -s /usr/bin/g++-6 /usr/local/cuda/bin/g++

curl https://developer.nvidia.com/compute/cuda/9.2/Prod2/local_installers/cuda_9.2.148_396.37_linux
curl https://developer.nvidia.com/compute/cuda/9.2/Prod2/patches/1/cuda_9.2.148.1_linux
chmod +x cuda_9.2.148*
sudo ./cuda_9.2.148_396.37_linux.run --override
sudo ./cuda_9.2.148.1_linux.run
echo 'export PATH=/usr/local/cuda-9.2/bin${PATH:+:${PATH}}' >> ~/.bashrc
echo 'export LD_LIBRARY_PATH=/usr/local/cuda-9.2/lib64:/usr/local/cuda/extras/CUPTI/lib64:/usr/local/NCCL2:/opt/OpenBLAS/lib${LD_LIBRARY_PATH:+:${LD_LIBRARY_PATH}}' >> ~/.bashrc
source ~/.bashrc
```
To remember, the general rule is:
- ```~/.bash_profile``` is being activated just one time when you login (GUI or SSH)
- ```~/.bash_aliases``` is being activated every time when you open the terminal (window or tab)
However this behavior can be changed by modifying ```~/.bashrc```, ```~/.profile```, or ```/etc/bash.bashrc```, etc.

While compiling, it will ask several questions, answer as below:

```
Do you accept the previously read EULA?
accept/decline/quit: accept

You are attempting to install on an unsupported configuration. Do you wish to continue?
(y)es/(n)o [ default is no ]: y

Install NVIDIA Accelerated Graphics Driver for Linux-x86_64 384.81?
(y)es/(n)o/(q)uit: n

Install the CUDA 9.0 Toolkit?
(y)es/(n)o/(q)uit: y

Enter Toolkit Location
 [ default is /usr/local/cuda-9.0 ]: 

Do you want to install a symbolic link at /usr/local/cuda?
(y)es/(n)o/(q)uit: y

Install the CUDA 9.0 Samples?
(y)es/(n)o/(q)uit: y

Enter CUDA Samples Location
 [default location]:   
```

If nothing special happens, the process will end succefully.
Lastly, reboot the system.

### 5. Install cuDNN 7.3.1 for CUDA 9.2

The NVIDIA CUDA® Deep Neural Network library (cuDNN) is a GPU-accelerated library of primitives for deep neural networks. cuDNN provides highly tuned implementations for standard routines such as forward and backward convolution, pooling, normalization, and activation layers

```shell
curl https://developer.nvidia.com/compute/machine-learning/cudnn/secure/v7.3.1/prod/9.2_2018927/cudnn-9.2-linux-x64-v7.3.1.20
tar -xzvf cudnn-9.2-linux-x64-v7.3.1.20.tgz
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

Tests for NCCL are maintained separately at https://github.com/nvidia/nccl-tests.

```shell
git clone https://github.com/NVIDIA/nccl-tests.git
cd nccl-tests
make
./build/allreduce_perf -b 8 -e 256M -f 2 -g <ngpus>
```

Installation is now complete. You can now incorporate NCCL in your GPU-accelerated application.
