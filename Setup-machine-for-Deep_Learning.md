# Setup machine for Deep Learning

### 1. Hardware

For studying, you can start with a small set as below:

-   AMD Ryzen™ 5 1600 CPU @ 3.20GHz
-   240 GB hard drive (SSD)
-   16 GB RAM (DDR4)
-   nVidia GP104 [GeForce GTX 1070Ti 8GB]

Of course, it also requires a case, power supply, keyboard, mouse and monitor. Total cost about $1500.

As our experience, GeForce GTX 1060 with 6GB can process from 1000 to 6000 images as well.  It takes about 3 to 18 hours to train Object Detection model using TensorFlow GPU, depending on the size of dataset, the algorithm and the neural network architecture you chosen. SSD MobileNet may be fastest.

### 2. OS & platform

To install Ubuntu 18.04 and Python dev environment, please read these notes:

-   [Setup Ubuntu 18.04 from MinimalCD](https://github.com/greenglobal/ggml-docs/blob/master/setup_ubuntu_1804_from_minimalcd.md)
-   [Setup Python 3 dev environment](https://github.com/hoangtnm/TrainingServer-docs/blob/master/setup_python_3_dev_environment.md)

### 3. NVIDIA driver

There is two available versions for NVIDIA graphic card’s driver: Nouveau driver and Nvidia driver. The first one is open source, by community. The last one is close source, by NVIDIA.

Normally, Nvidia driver is default. For Ubuntu, it’s `nvidia-384`. We can check it with:

```
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

```
sudo add-apt-repository ppa:graphics-drivers/ppa 
sudo apt update
sudo apt install nvidia-390 nvidia-390-dev
```

Recheck it using the above `cat` command or `nvidia-smi` for more detail.

### 4. Install CUDA Toolkit 9.2

IMHO, it’s always best practice to install pip modules into the virtual environments, and use TensorFlow from PyPI. This will provide a flexible solution. For the same reason, I didn’t recommend to use Anaconda.

CUDA v9.2 requires GCC 7, while default GCC version in Ubuntu 17.10 is GCC 7.2 and some other Deep Learning framework requires GCC 6. So we have to install GCC 6 and create symlinks as below:

```
cd ~/Downloads
sudo apt install gcc-6 g++-6
sudo ln -s /usr/bin/gcc-6 /usr/local/cuda/bin/gcc
sudo ln -s /usr/bin/g++-6 /usr/local/cuda/bin/g++

wget https://developer.nvidia.com/compute/cuda/9.2/Prod2/local_installers/cuda_9.2.148_396.37_linux
wget https://developer.nvidia.com/compute/cuda/9.2/Prod2/patches/1/cuda_9.2.148.1_linux
chmod +x cuda_9.2.148*
sudo ./cuda_9.2.148_396.37_linux.run --override
sudo ./cuda_9.2.148.1_linux.run
echo 'export PATH=/usr/local/cuda-9.2/bin${PATH:+:${PATH}}' >> ~/.bashrc
echo 'export LD_LIBRARY_PATH=/usr/local/cuda-9.2/lib64:/usr/local/cuda/extras/CUPTI/lib64${LD_LIBRARY_PATH:+:${LD_LIBRARY_PATH}}' >> ~/.bashrc
source ~/.bashrc
```
To remember, the general rule is:
- ```~/.bash_profile``` is being activated just one time when you login (GUI or SSH)
- ```~/.bash_aliases``` is being activated every time when you open the terminal (window or tab)
However this behavior can be changed by modifying ```~/.bashrc```, ```~/.profile```, or ```/etc/bash.bashrc```, etc.

While compiling, it will ask several questions, answer as below:

```
You are attempting to install on an unsupported configuration. Do you wish to continue?  
**y**  
Install NVIDIA Accelerated Graphics Driver for Linux-x86_64 384.81?  
**n**  
Install the CUDA 9.0 Toolkit?  
**y**  
Enter Toolkit Location  
[default location]  
Do you want to install a symbolic link at /usr/local/cuda?  
**y**  
Install the CUDA 9.0 Samples?  
**y**  
Enter CUDA Samples Location  
[default location]
```

If nothing special happens, the process will end succefully.
Lastly, reboot the system.

### 5. Install cuDNN 7.2.1 for CUDA 9.2

The NVIDIA CUDA® Deep Neural Network library (cuDNN) is a GPU-accelerated library of primitives for deep neural networks. cuDNN provides highly tuned implementations for standard routines such as forward and backward convolution, pooling, normalization, and activation layers

```
wget https://developer.nvidia.com/compute/machine-learning/cudnn/secure/v7.2.1/prod/9.2_20180806/cudnn-9.2-linux-x64-v7.2.1.38
tar -xzvf cudnn-9.2-linux-x64-v7.2.1.38.tgz
sudo cp cuda/include/cudnn.h /usr/local/cuda/include
sudo cp cuda/lib64/libcudnn* /usr/local/cuda/lib64
sudo chmod a+r /usr/local/cuda/include/cudnn.h /usr/local/cuda/lib64/libcudnn*
```

That's it. Now you can clone [greenglobal/tf-object-detection](https://github.com/greenglobal/tf-object-detection) to start training.

Older version of this note is shared at:

- [Setup a lightweight environment for deep learning](https://medium.com/@ndaidong/setup-a-simple-environment-for-deep-learning-dc05c81c4914)
