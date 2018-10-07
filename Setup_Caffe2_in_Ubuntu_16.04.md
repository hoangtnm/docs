# Setup Caffe2 in Ubuntu 16.04


### Requirements

- Ubuntu 16.04 LTS
- CUDA 8.0, cuDNN 6.0 GA2, NCCL 2.3.5
- Python 2.7 as default

### Install Dependencies

```shell
sudo apt install -y --no-install-recommends \
      build-essential \
      cmake \
      git \
      libgoogle-glog-dev \
      libgflags-dev \
      libgtest-dev \
      libiomp-dev \
      libleveldb-dev \
      liblmdb-dev \
      libopencv-dev \
      libopenmpi-dev \
      libsnappy-dev \
      libprotobuf-dev \
      openmpi-bin \
      openmpi-doc \
      protobuf-compiler \
      python-dev \
      python-pip

sudo apt install python-setuptools
sudo pip2 install wheel
sudo pip2 install \
      future==0.16.0 \
      numpy==1.14.0 \
      protobuf==3.5.1 \
      enum34==1.1.6 \
      h5py==2.8.0 \
      networkx==2.0 \
      cython==0.28.5 \
      hypothesis==3.44.16 \
      matplotlib==2.1.1 \
      pyyaml==3.13 \
      opencv-python==3.4.3.18 \
      scikit-image==0.13.1 \
      scipy==0.19.1 \
      mock==2.0.0 \
      memory-profiler==0.54.0 \
      typing \
      graphviz \
      jupyter \
      pydot \
      python-nvd3 \
      requests
```

### Make sure python2 is being used as default

```shell
sudo rm /usr/bin/python && sudo ln -s /usr/bin/python2 /usr/bin/python
```

### Clone & Build

```shell
echo "export Caffe2_DIR=/home/$USER/workspace/pytorch/build" >> ~/.bashrc
echo "export PYTHONPATH=/usr/local:/home/$USER/workspace/pytorch/build" >> ~/.bashrc
echo "export LD_LIBRARY_PATH=/usr/local/lib:/home/$USER/workspace/pytorch/build/lib:$LD_LIBRARY_PATH" >> ~/.bashrc
source ~/.bashrc

cd /home/$USER/workspace
git clone https://github.com/pytorch/pytorch.git && cd pytorch
git submodule update --init --recursive
# Create a directory to put Caffe2's build files in
mkdir build && cd build

# Configure Caffe2's build
# This looks for packages on your machine and figures out which functionality
# to include in the Caffe2 installation. The output of this command is very
# useful in debugging.
cmake .. \
      -DBUILD_CUSTOM_PROTOBUF=OFF \
      -DCUDA_ARCH_NAME=Manual \
      -DCUDA_ARCH_BIN="35 52 60 61" \
      -DCUDA_ARCH_PTX="61" \
      -DCUDA_HOST_COMPILER=/usr/bin/gcc-5 \
      -DUSE_SYSTEM_NCCL=ON \
      -DUSE_PROF=ON \
      -DUSE_NATIVE_ARCH=ON \
      -DUSE_NNPACK=OFF \
      -DUSE_ROCKSDB=OFF \
      -DPYTHON_LIBRARY=$(python -c "from distutils import sysconfig; print(sysconfig.get_python_lib())") \
      -DPYTHON_INCLUDE_DIR=$(python -c "from distutils import sysconfig; print(sysconfig.get_python_inc())")


sudo make install -j`nproc`
```

### Test the Caffe2 Installation

```shell
cd ~ && python -c 'from caffe2.python import core' 2>/dev/null && echo "Success" || echo "Failure"
```

If this fails, then get a better error message by running Python in your home directory and then running from caffe2.python import core inside Python.

If this fails with a message about not finding caffe2.python or not finding libcaffe2.so, please see [this info](https://caffe2.ai/docs/faq.html#why-do-i-get-import-errors-in-python-when-i-try-to-use-caffe2) on how Caffe2 installs in Python.

If you installed with GPU support, test that the GPU build was a success with this command (run from the top level pytorch directory). You will get a test output either way, but it will warn you at the top of the output if CPU was used instead of GPU, along with other errors such as missing libraries.

```python
python caffe2/python/operator_test/activation_ops_test.py
```

### Setting Up Tutorials & Jupyter Server

If you’re running this all on a cloud computer, you probably won’t have a UI or way to view the IPython notebooks by default. Typically, you would launch them locally with ipython notebook and you would see a localhost:8888 webpage pop up with the directory of notebooks running. The following example will show you how to launch the Jupyter server and connect to remotely via an SSH tunnel.

First configure your cloud server to accept port 8889, or whatever you want, but change the port in the following commands. On AWS you accomplish this by adding a rule to your server’s security group allowing a TCP inbound on port 8889. Otherwise you would adjust iptables for this.

<p align="center">
      <img src="https://caffe2.ai/static/images/security-group-jupyter.png" alt="Jupyter Server">
</p> 

Next you launch the Juypter server.

```
jupyter notebook --no-browser --port=8889
```

Then create the SSH tunnel. This will pass the cloud server’s Jupyter instance to your localhost 8888 port for you to use locally. The example below is templated after how you would connect AWS, where `your-public-cert.pem` is your own public certificate and `ubuntu@super-rad-GPU-instance.compute-1.amazonaws.com` is your login to your cloud server. You can easily grab this on AWS by going to Instances > Connect and copy the part after ssh and swap that out in the command below.

```shell
ssh -N -f -L localhost:8888:localhost:8889 -i "your-public-cert.pem" ubuntu@super-rad-GPU-instance.compute-1.amazonaws.com
```


### Troubleshooting

#### Protobuf Errors

Caffe2 uses protobuf as its serialization format and requires version `3.2.0` or newer.
If your protobuf version is older, you can build protobuf from Caffe2 protobuf submodule and use that version instead.

To build Caffe2 protobuf submodule:

```shell
# CAFFE2=/path/to/caffe2
cd $CAFFE2/third_party/protobuf/cmake
mkdir -p build && cd build
cmake .. \
  -DCMAKE_INSTALL_PREFIX=$HOME/c2_tp_protobuf \
  -Dprotobuf_BUILD_TESTS=OFF \
  -DCMAKE_CXX_FLAGS="-fPIC"
make install -j`nproc`
```

To point Caffe2 CMake to the newly built protobuf:

```shell
cmake .. \
  # insert your Caffe2 CMake flags here
  -DPROTOBUF_PROTOC_EXECUTABLE=$HOME/c2_tp_protobuf/bin/protoc \
  -DPROTOBUF_INCLUDE_DIR=$HOME/c2_tp_protobuf/include \
  -DPROTOBUF_LIBRARY=$HOME/c2_tp_protobuf/lib64/libprotobuf.a
```

You may also experience problems with protobuf if you have both system and anaconda packages installed.
This could lead to problems as the versions could be mixed at compile time or at runtime.
This issue can also be overcome by following the commands from above.

#### Caffe2 Python Binaries

In case you experience issues with CMake being unable to find the required Python paths when
building Caffe2 Python binaries (e.g. in virtualenv), you can try pointing Caffe2 CMake to python
library and include dir by using:

```shell
cmake .. \
  # insert your Caffe2 CMake flags here
  -DPYTHON_LIBRARY=$(python -c "from distutils import sysconfig; print(sysconfig.get_python_lib())") \
  -DPYTHON_INCLUDE_DIR=$(python -c "from distutils import sysconfig; print(sysconfig.get_python_inc())")
```

#### Caffe2 with NNPACK Build

Detectron does not require Caffe2 built with NNPACK support. If you face NNPACK related issues during Caffe2 installation, you can safely disable NNPACK by setting the `-DUSE_NNPACK=OFF` CMake flag.

##### Caffe2 with OpenCV Build

Analogously to the NNPACK case above, you can disable OpenCV by setting the `-DUSE_OPENCV=OFF` CMake flag.

##### COCO API Undefined Symbol Error

If you encounter a COCO API import error due to an undefined symbol, as reported [here](https://github.com/cocodataset/cocoapi/issues/35),
make sure that your python versions are not getting mixed. For instance, this issue may arise if you have
[both system and conda numpy installed](https://stackoverflow.com/questions/36190757/numpy-undefined-symbol-pyfpe-jbuf).

#### CMake Cannot Find Caffe2

In case you experience issues with CMake being unable to find the Caffe2 package when building custom operators,
make sure you have run `make install` as part of your Caffe2 installation process.

#### How do I fix error messages that are Protobuf related?

Protobuf version mismatch is a common problem. Having different protobuf versions often leads to incompatible headers and libraries. **Upgrading to the latest protobuf is not the solution.** The version of Protobuf used during compile time must match the one used at runtime.

Run these commands to see which Protobuf version is currently visible on your machine.

```shell
which protoc
protoc --version
find $(dirname $(which protoc))/../lib -name 'libproto*'
```

Now find what Protobuf version your Caffe2 installation expects. First find your Caffe2 library, which can have several possible locations depending on your install environment. Then run the following command with `<your libcaffe2>` replaced with the location of your Caffe2 library.

For Linux: `ldd <your libcaffe2>` For macOS: `otool -L <your libcaffe2>`

You need the Protobuf versions to match.

For example, on a Mac you might find that your current visible Protobuf is:

```shell
$ which protoc
/usr/local/bin/protoc
$ protoc --version
libprotoc 3.5.1
$ otool -L /usr/local/lib/libprotobuf.dylib
/usr/local/lib/libprotobuf.dylib:
	/usr/local/opt/protobuf/lib/libprotobuf.15.dylib (compatibility version 16.0.0, current version 16.1.0)
	/usr/lib/libz.1.dylib (compatibility version 1.0.0, current version 1.2.11)
	/usr/lib/libc++.1.dylib (compatibility version 1.0.0, current version 400.9.0)
	/usr/lib/libSystem.B.dylib (compatibility version 1.0.0, current version 1252.0.0)
```

but that your Caffe2 installation expects

```shell
$ otool -L /usr/local/lib/libcaffe2.dylib
@rpath/libcaffe2.dylib (compatibility version 0.0.0, current version 0.0.0)
	@rpath/libprotobuf.14.dylib (compatibility version 15.0.0, current version 15.0.0)
	/usr/lib/libc++.1.dylib (compatibility version 1.0.0, current version 400.9.0)
	/usr/lib/libSystem.B.dylib (compatibility version 1.0.0, current version 1252.0.0)
```

This example would lead to Protobuf errors, as `libprotobuf.14.dylib` which Caffe2 expects is not the same as libprotobuf.15.dylib which exists on the machine. In this example, the Protobuf on the machine will have to be downgraded to 3.4.1.
