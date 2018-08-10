# Install TensorFlow from Sources


### Clone the TensorFlow repository

Start the process of building TensorFlow by cloning a TensorFlow repository.
To clone the latest TensorFlow repository, issue the following command:

```
mkdir ~/workspace
cd ~/workspace
git clone https://github.com/tensorflow/tensorflow.git
cd tensorflow
git checkout r1.9
```

### Install Bazel

If bazel is not installed on your system, install it now by following ([these directions](https://bazel.build/versions/master/docs/install.html))

### Install TensorFlow Python dependencies

To install TensorFlow, you must install the following packages:
- `numpy`, which is a numerical processing package that TensorFlow requires.
- `dev`, which enables adding extensions to Python.
- `pip`, which enables you to install and manage certain Python packages.
- `wheel`, which enables you to manage Python compressed packages in the wheel (.whl) format.

To install these packages for Python 3.n, issue the following command:

```
sudo apt-get install python3-numpy python3-dev
```

### Install CUDA Toolkit 9.2

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
sudo ./cuda_9.2.148_396.37_linux.run
sudo ./cuda_9.2.148.1_linux.run
echo 'export PATH=/usr/local/cuda-9.2/bin${PATH:+:${PATH}}' >> ~/.bashrc
echo 'export LD_LIBRARY_PATH=/usr/local/cuda-9.2/lib64:/usr/local/cuda/extras/CUPTI/lib64${LD_LIBRARY_PATH:+:${LD_LIBRARY_PATH}}' >> ~/.bashrc
source ~/.bashrc
```
To remember, the general rule is:
- ```~/.bash_profile``` is being activated just one time when you login (GUI or SSH)
- ```~/.bash_aliases``` is being activated every time when you open the terminal (window or tab)
However this behavior can be changed by modifying ```~/.bashrc```, ```~/.profile```, or ```/etc/bash.bashrc```, etc.

### Install cuDNN 7.2.1

The NVIDIA CUDA® Deep Neural Network library (cuDNN) is a GPU-accelerated library of primitives for deep neural networks. cuDNN provides highly tuned implementations for standard routines such as forward and backward convolution, pooling, normalization, and activation layers

```
wget https://developer.nvidia.com/compute/machine-learning/cudnn/secure/v7.2.1/prod/9.2_20180806/cudnn-9.2-linux-x64-v7.2.1.38
tar -xzvf cudnn-9.2-linux-x64-v7.2.1.38.tgz
sudo cp cuda/include/cudnn.h /usr/local/cuda/include
sudo cp cuda/lib64/libcudnn* /usr/local/cuda/lib64
sudo chmod a+r /usr/local/cuda/include/cudnn.h /usr/local/cuda/lib64/libcudnn*
```

### Configure the installation

```
cd ~/workspace/tensorflow
./configure
Please specify the location of python. [Default is /usr/bin/python]: 


Found possible Python library paths:
  /usr/local/lib/python3.6/site-packages
Please input the desired Python library path to use.  Default is [/usr/local/lib/python3.6/site-packages]

Do you wish to build TensorFlow with jemalloc as malloc support? [Y/n]: 
jemalloc as malloc support will be enabled for TensorFlow.

Do you wish to build TensorFlow with Google Cloud Platform support? [Y/n]: 
Google Cloud Platform support will be enabled for TensorFlow.

Do you wish to build TensorFlow with Hadoop File System support? [Y/n]: 
Hadoop File System support will be enabled for TensorFlow.

Do you wish to build TensorFlow with Amazon S3 File System support? [Y/n]: 
Amazon S3 File System support will be enabled for TensorFlow.

Do you wish to build TensorFlow with Apache Kafka Platform support? [Y/n]: 
Apache Kafka Platform support will be enabled for TensorFlow.

Do you wish to build TensorFlow with XLA JIT support? [y/N]: 
No XLA JIT support will be enabled for TensorFlow.

Do you wish to build TensorFlow with GDR support? [y/N]: 
No GDR support will be enabled for TensorFlow.

Do you wish to build TensorFlow with VERBS support? [y/N]: 
No VERBS support will be enabled for TensorFlow.

Do you wish to build TensorFlow with OpenCL SYCL support? [y/N]: 
No OpenCL SYCL support will be enabled for TensorFlow.

Do you wish to build TensorFlow with CUDA support? [y/N]: y
CUDA support will be enabled for TensorFlow.

Please specify the CUDA SDK version you want to use. [Leave empty to default to CUDA 9.0]: 9.2


Please specify the location where CUDA 9.2 toolkit is installed. Refer to README.md for more details. [Default is /usr/local/cuda]: 


Please specify the cuDNN version you want to use. [Leave empty to default to cuDNN 7.0]: 7.2.1   


Please specify the location where cuDNN 7 library is installed. Refer to README.md for more details. [Default is /usr/local/cuda]:


Do you wish to build TensorFlow with TensorRT support? [y/N]: 
No TensorRT support will be enabled for TensorFlow.

Please specify the NCCL version you want to use. [Leave empty to default to NCCL 1.3]: 2.2


Please specify the location where NCCL 2 library is installed. Refer to README.md for more details. [Default is /usr/local/cuda]:/usr/local/nccl_2.2.13-1+cuda9.2_x86_64


Please specify a list of comma-separated Cuda compute capabilities you want to build with.
You can find the compute capability of your device at: https://developer.nvidia.com/cuda-gpus.
Please note that each additional compute capability significantly increases your build time and binary size. [Default is: 6.1]


Do you want to use clang as CUDA compiler? [y/N]: 
nvcc will be used as CUDA compiler.

Please specify which gcc should be used by nvcc as the host compiler. [Default is /usr/bin/gcc]: 


Do you wish to build TensorFlow with MPI support? [y/N]: 
No MPI support will be enabled for TensorFlow.

Please specify optimization flags to use during compilation when bazel option "--config=opt" is specified [Default is -march=native]: 


Would you like to interactively configure ./WORKSPACE for Android builds? [y/N]: 
Not configuring the WORKSPACE for Android builds.

Preconfigured Bazel build configs. You can use any of the below by adding "--config=<>" to your build command. See tools/bazel.rc for more details.
	--config=mkl         	# Build with MKL support.
	--config=monolithic  	# Config for mostly static monolithic build.
Configuration finished
```

### Build the pip package

```
bazel build -c opt --copt=-mavx --copt=-mavx2 --copt=-mfma --copt=-mfpmath=both --copt=-msse4.2 --cxxopt="-D_GLIBCXX_USE_CXX11_ABI=0" --config=cuda //tensorflow/tools/pip_package:build_pip_package
```

***NOTE on gcc 5 or later:*** the binary pip packages available on the TensorFlow website are built with gcc 4, which uses the older ABI. To make your build compatible with the older ABI, you need to add ```--cxxopt="-D_GLIBCXX_USE_CXX11_ABI=0"``` to your ```bazel build``` command. ABI compatibility allows custom ops built against the TensorFlow pip package to continue to work against your built package.

***Tip:*** By default, building TensorFlow from sources consumes a lot of RAM. If RAM is an issue on your system, you may limit RAM usage by specifying ```--local_resources 2048,.5,1.0``` while invoking ```bazel```.

The ```bazel build``` command builds a script named ```build_pip_package```. Running this script as follows will build a ```.whl``` file within the ```/tmp/tensorflow_pkg``` directory:

```
bazel-bin/tensorflow/tools/pip_package/build_pip_package /tmp/tensorflow_pkg
```

### Install the pip package

Invoke ```pip install``` to install that pip package. The filename of the ```.whl``` file depends on your platform. For example, the following command will install the pip package:

```
sudo pip install /tmp/tensorflow_pkg/tensorflow-1.9.0-cp36-cp36m-linux_x86_64.whl
```

### Validate your installation

Start a terminal.

Change directory (```cd```) to any directory on your system other than the ```tensorflow``` subdirectory from which you invoked the ```configure``` command.

Invoke python:

```
python3
import tensorflow as tf
hello = tf.constant('Hello, TensorFlow!')
sess = tf.Session()
print(sess.run(hello))
```

If the system outputs the following, then you are ready to begin writing TensorFlow programs:

```
Hello, TensorFlow!
```
