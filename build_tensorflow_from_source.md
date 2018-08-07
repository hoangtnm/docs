# Install TensorFlow from Sources


### Clone the TensorFlow repository

Start the process of building TensorFlow by cloning a TensorFlow repository.
To clone the latest TensorFlow repository, issue the following command:

```
git clone https://github.com/tensorflow/tensorflow
cd tensorflow
git checkout #Branch
```

### Install Bazel

If bazel is not installed on your system, install it now by following ([these directions]https://bazel.build/versions/master/docs/install.html)

### Install TensorFlow Python dependencies

To install TensorFlow, you must install the following packages:
- `numpy`, which is a numerical processing package that TensorFlow requires.
- `dev`, which enables adding extensions to Python.
- `pip`, which enables you to install and manage certain Python packages.
- `wheel`, which enables you to manage Python compressed packages in the wheel (.whl) format.

To install these packages for Python 3.n, issue the following command:

'''
sudo apt-get install python3-numpy [python3-dev python3-pip python3-wheel) - no need if building Python from source]
'''

### Optional: install TensorFlow for GPU prerequisites

If you are building TensorFlow without GPU support, skip this section.
The following NVIDIA hardware must be installed on your system:
- GPU card with CUDA Compute Capability 3.0 or higher. See ([NVIDIA documentation]https://developer.nvidia.com/cuda-gpus) for a list of supported GPU cards.
The following NVIDIA software must be installed on your system:
- `CUDA Toolkit`(>= 8.0). We recommend version 9.0. For details, see NVIDIA's documentation. Ensure that you append the relevant CUDA pathnames to the LD_LIBRARY_PATH environment variable as described in the NVIDIA documentation.
- `GPU drivers` supporting your version of the CUDA Toolkit.
- `DNN SDK` (>= 6.0). We recommend version 7.0. For details, see NVIDIA's documentation.
- `CUPTI` ships with the CUDA Toolkit, but you also need to append its path to the LD_LIBRARY_PATH environment variable:

```
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/usr/local/cuda/extras/CUPTI/lib64
```

### Configure the installation

```
cd tensorflow
./configure
Please specify the location of python. [Default is /usr/bin/python]: /usr/bin/python2.7
Found possible Python library paths:
  /usr/local/lib/python2.7/dist-packages
  /usr/lib/python2.7/dist-packages
Please input the desired Python library path to use.  Default is [/usr/lib/python2.7/dist-packages]

Using python library path: /usr/local/lib/python2.7/dist-packages
Please specify optimization flags to use during compilation when bazel option "--config=opt" is specified [Default is -march=native]:
Do you wish to use jemalloc as the malloc implementation? [Y/n]
jemalloc enabled
Do you wish to build TensorFlow with Google Cloud Platform support? [y/N]
No Google Cloud Platform support will be enabled for TensorFlow
Do you wish to build TensorFlow with Hadoop File System support? [y/N]
No Hadoop File System support will be enabled for TensorFlow
Do you wish to build TensorFlow with the XLA just-in-time compiler (experimental)? [y/N]
No XLA support will be enabled for TensorFlow
Do you wish to build TensorFlow with VERBS support? [y/N]
No VERBS support will be enabled for TensorFlow
Do you wish to build TensorFlow with OpenCL support? [y/N]
No OpenCL support will be enabled for TensorFlow
Do you wish to build TensorFlow with CUDA support? [y/N] Y
CUDA support will be enabled for TensorFlow
Do you want to use clang as CUDA compiler? [y/N]
nvcc will be used as CUDA compiler
Please specify the CUDA SDK version you want to use. [Leave empty to default to CUDA 9.0]: 9.0
Please specify the location where CUDA 9.0 toolkit is installed. Refer to README.md for more details. [Default is /usr/local/cuda]:
Please specify which gcc should be used by nvcc as the host compiler. [Default is /usr/bin/gcc]:
Please specify the cuDNN version you want to use. [Leave empty to default to cuDNN 7.0]: 7
Please specify the location where cuDNN 7 library is installed. Refer to README.md for more details. [Default is /usr/local/cuda]:
Please specify a list of comma-separated CUDA compute capabilities you want to build with.
You can find the compute capability of your device at: https://developer.nvidia.com/cuda-gpus.
Please note that each additional compute capability significantly increases your build time and binary size.

Do you wish to build TensorFlow with MPI support? [y/N]
MPI support will not be enabled for TensorFlow
Configuration finished
```
