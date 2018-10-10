# Setup Caffe2 in Ubuntu 18.04


### Requirements

- Ubuntu 18.04 ([refer](https://github.com/greenglobal/ggml-docs/blob/master/setup_ubuntu_1804_from_minimalcd.md))
- CUDA 9.2, cuDNN 7.2 ([refer](https://github.com/hoangtnm/TrainingServer-docs/blob/master/Setup-machine-for-Deep_Learning.md))
- Python 2.7

### Make sure python2 and pip2 are being used as default

```
sudo rm /usr/bin/python && sudo ln -s /usr/bin/python2 /usr/bin/python
sudo rm /usr/bin/pip && sudo ln -s /usr/bin/pip2 /usr/bin/pip
```

### Install Dependencies

```
sudo apt-get install -y --no-install-recommends \
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
sudo pip2 install \
      future \
      numpy \
      protobuf \
      typing \
      enum \
      networkx \
      cython \
      graphviz \
      hypothesis \
      jupyter \
      matplotlib \
      pydot \
      python-nvd3 \
      pyyaml \
      requests \
      scikit-image \
      scipy
```

### Clone & Build

```
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
      -DUSE_SYSTEM_NCCL=ON \
      -DUSE_PROF=ON \
      -DUSE_NATIVE_ARCH=ON \
      -DUSE_NNPACK=OFF \
      -DUSE_ROCKSDB=OFF \
      -DPYTHON_LIBRARY=$(python -c "from distutils import sysconfig; print(sysconfig.get_python_lib())") \
      -DPYTHON_INCLUDE_DIR=$(python -c "from distutils import sysconfig; print(sysconfig.get_python_inc())") \
      -DCUDA_HOST_COMPILER=/usr/bin/gcc-5

sudo make install -j`nproc`
```

### Test the Caffe2 Installation

```
cd ~ && python -c 'from caffe2.python import core' 2>/dev/null && echo "Success" || echo "Failure"
```

If this fails, then get a better error message by running Python in your home directory and then running from caffe2.python import core inside Python.

If this fails with a message about not finding caffe2.python or not finding libcaffe2.so, please see this info on how Caffe2 installs in Python.

If you installed with GPU support, test that the GPU build was a success with this command (run from the top level pytorch directory). You will get a test output either way, but it will warn you at the top of the output if CPU was used instead of GPU, along with other errors such as missing libraries.

```
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

```
ssh -N -f -L localhost:8888:localhost:8889 -i "your-public-cert.pem" ubuntu@super-rad-GPU-instance.compute-1.amazonaws.com
```
