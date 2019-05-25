# Build TensorFlow from Source


### Requirements

- Ubuntu 18.04 ([refer](https://github.com/greenglobal/ggml-docs/blob/master/setup_ubuntu_1804_from_minimalcd.md))
- CUDA 10.0, cuDNN 7.5, NCCL2 ([refer](https://github.com/hoangtnm/TrainingServer-docs/blob/master/Building_from_source/install-cuda-10.sh))
- Python 3.6.8 (must be installed exactly as same as [this guideline](https://github.com/hoangtnm/TrainingServer-docs/blob/master/Setup_python_3_dev_environment.md))
- Protobuf 3.6.1 (must be installed exactly as same as [this guideline](https://github.com/hoangtnm/TrainingServer-docs/blob/master/Building_from_source/install-protobuf-from_source.sh))

### Clone the TensorFlow repository

Start the process of building TensorFlow by cloning a TensorFlow repository.
To clone the latest TensorFlow repository, issue the following command:

```shell
mkdir /home/$USER/workspace
cd /home/$USER/workspace
git clone https://github.com/tensorflow/tensorflow.git
cd tensorflow
git checkout r1.13
```

### Install Bazel

If bazel is not installed on your system, install it now by following ([these directions](https://bazel.build/versions/master/docs/install.html))

```bash
export BAZEL_VERSION = 0.21.0
sudo apt install pkg-config zip g++ zlib1g-dev unzip
wget https://github.com/bazelbuild/bazel/releases/download/$BAZEL_VERSION/bazel-$BAZEL_VERSION-installer-linux-x86_64.sh
chmod +x bazel-$BAZEL_VERSION-installer-linux-x86_64.sh
sudo ./bazel-$BAZEL_VERSION-installer-linux-x86_64.sh
```

Note: Bazel version must be 0.21.0

### Install TensorFlow Python dependencies

To install TensorFlow, you must install the following packages:
- `numpy`, which is a numerical processing package that TensorFlow requires.
- `dev`, which enables adding extensions to Python.
- `pip`, which enables you to install and manage certain Python packages.
- `wheel`, which enables you to manage Python compressed packages in the wheel (.whl) format.

To install these packages for Python 3.n, issue the following command:

```bash
sudo pip3 install six numpy==0.15.4 wheel mock google-cloud
sudo pip install keras_applications==1.0.6 keras_preprocessing==1.0.5 --no-deps
```

### Configure the installation

```shell
cd /home/$USER/workspace/tensorflow
./configure
Please specify the location of python. [Default is /usr/bin/python]: 


Found possible Python library paths:
  /usr/local/lib/python3.6/site-packages
Please input the desired Python library path to use.  Default is [/usr/local/lib/python3.6/site-packages]

Do you wish to build TensorFlow with XLA JIT support? [Y/n]: 
XLA JIT support will be enabled for TensorFlow.

Do you wish to build TensorFlow with OpenCL SYCL support? [y/N]: 
No OpenCL SYCL support will be enabled for TensorFlow.

Do you wish to build TensorFlow with ROCm support? [y/N]: 
No ROCm support will be enabled for TensorFlow.

Do you wish to build TensorFlow with CUDA support? [y/N]: y
CUDA support will be enabled for TensorFlow.

Please specify the CUDA SDK version you want to use. [Leave empty to default to CUDA 10.0]: 


Please specify the location where CUDA 10.0 toolkit is installed. Refer to README.md for more details. [Default is /usr/local/cuda]: 


Please specify the cuDNN version you want to use. [Leave empty to default to cuDNN 7]: 


Please specify the location where cuDNN 7 library is installed. Refer to README.md for more details. [Default is /usr/local/cuda]: 


Do you wish to build TensorFlow with TensorRT support? [y/N]: 
No TensorRT support will be enabled for TensorFlow.

Please specify the locally installed NCCL version you want to use. [Default is to use https://github.com/nvidia/nccl]: 


Please specify a list of comma-separated Cuda compute capabilities you want to build with.
You can find the compute capability of your device at: https://developer.nvidia.com/cuda-gpus.
Please note that each additional compute capability significantly increases your build time and binary size. [Default is: 5.0]: 6.1


Do you want to use clang as CUDA compiler? [y/N]: 
nvcc will be used as CUDA compiler.

Please specify which gcc should be used by nvcc as the host compiler. [Default is /usr/bin/gcc]: 


Do you wish to build TensorFlow with MPI support? [y/N]: 
No MPI support will be enabled for TensorFlow.

Please specify optimization flags to use during compilation when bazel option "--config=opt" is specified [Default is -march=native -Wno-sign-compare]: 


Would you like to interactively configure ./WORKSPACE for Android builds? [y/N]: 
Not configuring the WORKSPACE for Android builds.

Preconfigured Bazel build configs. You can use any of the below by adding "--config=<>" to your build command. See .bazelrc for more details.
	--config=mkl         	# Build with MKL support.
	--config=monolithic  	# Config for mostly static monolithic build.
	--config=gdr         	# Build with GDR support.
	--config=verbs       	# Build with libverbs support.
	--config=ngraph      	# Build with Intel nGraph support.
	--config=dynamic_kernels	# (Experimental) Build kernels into separate shared objects.
Preconfigured Bazel build configs to DISABLE default on features:
	--config=noaws       	# Disable AWS S3 filesystem support.
	--config=nogcp       	# Disable GCP support.
	--config=nohdfs      	# Disable HDFS support.
	--config=noignite    	# Disable Apacha Ignite support.
	--config=nokafka     	# Disable Apache Kafka support.
	--config=nonccl      	# Disable NVIDIA NCCL support.
Configuration finished
```

### Build the pip package

```shell
bazel build -c opt --copt=-mavx --copt=-mavx2 --copt=-mfma --copt=-mfpmath=both --copt=-msse4.2 --cxxopt="-D_GLIBCXX_USE_CXX11_ABI=0" --config=cuda //tensorflow/tools/pip_package:build_pip_package
```

***NOTE on gcc 5 or later:*** the binary pip packages available on the TensorFlow website are built with gcc 4, which uses the older ABI. To make your build compatible with the older ABI, you need to add ```--cxxopt="-D_GLIBCXX_USE_CXX11_ABI=0"``` to your ```bazel build``` command. ABI compatibility allows custom ops built against the TensorFlow pip package to continue to work against your built package.

***Tip:*** By default, building TensorFlow from sources consumes a lot of RAM. If RAM is an issue on your system, you may limit RAM usage by specifying ```--local_resources 2048,.5,1.0``` while invoking ```bazel```.

The ```bazel build``` command builds a script named ```build_pip_package```. Running this script as follows will build a ```.whl``` file within the ```/tmp/tensorflow_pkg``` directory:

```shell
bazel-bin/tensorflow/tools/pip_package/build_pip_package /tmp/tensorflow_pkg
```

### Install the pip package

Invoke ```pip install``` to install that pip package. The filename of the ```.whl``` file depends on your platform. For example, the following command will install the pip package:

```shell
sudo pip3 install /tmp/tensorflow_pkg/tensorflow-1.12-cp36-cp36m-linux_x86_64.whl
```

### Validate your installation

Start a terminal.

Change directory (```cd```) to any directory on your system other than the ```tensorflow``` subdirectory from which you invoked the ```configure``` command.

Invoke python:

```python
import tensorflow as tf
hello = tf.constant('Hello, TensorFlow!')
sess = tf.Session()
print(sess.run(hello))
```

If the system outputs the following, then you are ready to begin writing TensorFlow programs:

```
Hello, TensorFlow!
```
