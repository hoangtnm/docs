# Setup machine for Deep Learning

### 1. Hardware

For studying, you can start with a small set as below:

-   Intel(R) Core(TM) i5–7600 CPU @ 3.50GHz
-   240 GB hard drive (SSD)
-   8 GB RAM (DDR4)
-   nVidia GP106 [GeForce GTX 1060 6GB]

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
blacklist 
vga16fbblacklist 
nouveaublacklist 
rivafbblacklist 
nvidiafbblacklist 
rivatv
```

And install:

```
sudo add-apt-repository ppa:graphics-drivers/ppasudo apt updatesudo apt install nvidia-384 nvidia-384-dev
```

Recheck it using the above `cat` command or `nvidia-smi` for more detail.

### 4. CUDA v9.0

TensorFlow team just [released v1.7](https://github.com/tensorflow/tensorflow/releases/tag/v1.7.0) that has been [built with CUDA 9.0](https://github.com/tensorflow/tensorflow/issues/15656), so unless you have plan to build TensorFlow from source, you should not install CUDA v9.1 to avoid the unexpected issues.

IMHO, it’s always best practice to install pip modules into the virtual environments, and use TensorFlow from PyPI. This will provide a flexible solution. For the same reason, I didn’t recommend to use Anaconda.

CUDA v9.0 requires GCC 6, while default GCC version in Ubuntu 16.04 and newer is GCC 7.2. So we have to install GCC 6 and create symlinks as below:

```
sudo apt install gcc-6 g++-6sudo ln -s /usr/bin/gcc-6 /usr/local/cuda/bin/gccsudo ln -s /usr/bin/g++-6 /usr/local/cuda/bin/g++
```

Now `gcc` command is running as gcc-6, check it with:

```
gcc -v
```

Then, we stop x-server, download CUDA 9 and install it:

```
sudo service lightdm stop  
wget [https://developer.nvidia.com/compute/cuda/9.0/Prod/local_installers/cuda_9.0.176_384.81_linux-run](https://developer.nvidia.com/compute/cuda/9.0/Prod/local_installers/cuda_9.0.176_384.81_linux-run)  
mv cuda_9.0.176_384.81_linux-run cuda_9.0.176_384.81_linux.run  
chmod +x cuda_9.0.176_384.81_linux.run  
sudo ./cuda_9.0.176_384.81_linux.run --override --dkms -s
```

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

As [NVIDIA’s docs](http://docs.nvidia.com/cuda/cuda-installation-guide-linux/index.html#post-installation-actions), we may need to add these paths into `~/.bash_aliases`:

```
export PATH=/usr/local/cuda-9.0/bin${PATH:+:${PATH}}
export LD_LIBRARY_PATH=/usr/local/cuda-9.0/lib64${LD_LIBRARY_PATH:+:${LD_LIBRARY_PATH}}
```

Lastly, reboot the system.

### 5. cuDNN v7.0.5 for CUDA 9.0

CUDA 9.0 only plays with its appropriate cuDNN version, you can [download it here](https://developer.nvidia.com/cudnn) after joining [NVIDIA Developer Program](https://developer.nvidia.com/developer-program).

Choose the correct item from list as below:

![](https://cdn-images-1.medium.com/max/800/1*OHxg3vx5Xyui3GMoxiBepg.png)

Download it then run these commands:

```
tar -xzvf cudnn-9.0-linux-x64-v7.tgz  
sudo cp cuda/include/cudnn.h /usr/local/cuda/include  
sudo cp cuda/lib64/libcudnn* /usr/local/cuda/lib64  
sudo chmod a+r /usr/local/cuda/include/cudnn.h  
/usr/local/cuda/lib64/libcudnn*
```

That's it. Now you can clone [greenglobal/tf-object-detection](https://github.com/greenglobal/tf-object-detection) to start training.

Older version of this note is shared at:

- [Setup a lightweight environment for deep learning](https://medium.com/@ndaidong/setup-a-simple-environment-for-deep-learning-dc05c81c4914)
