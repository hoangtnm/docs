# Setup Caffe 1.0 in Ubuntu 18.04


### Requirements

- Ubuntu 18.04 ([refer](https://github.com/greenglobal/ggml-docs/blob/master/setup_ubuntu_1804_from_minimalcd.md))
- CUDA 9.0, cuDNN 7.0 ([refer](https://github.com/greenglobal/ggml-docs/blob/master/setup_machine_for_deep_learning.md))
- Python 3.6.5 (must be installed exactly as same as [this guideline](https://github.com/hoangtnm/TrainingServer-docs/blob/master/setup_python_3_dev_environment.md)


### Installation

```
sudo apt update && sudo apt upgrade
sudo apt install build-essential \
  libhdf5-serial-dev \
  libatlas-base-dev \
  libboost-all-dev \
  libprotobuf-dev \
  libleveldb-dev \
  libsnappy-dev \
  liblmdb-dev \
  libopencv-dev \
  libgflags-dev \
  libgoogle-glog-dev \
  protobuf-compiler \
  python-pip python-dev python-opencv
  
mkdir ~/worskpace
cd ~/workspace
curl https://bootstrap.pypa.io/get-pip.py -o get-pip.py
python3 get-pip.py
```

Move the cursor to the workspace, let's say `/home/YOURNAME/workspace`, clone `caffe` repo:

```
cd ~/workspace
git clone https://github.com/weiliu89/caffe.git
cd caffe
git checkout ssd
```

Then create Makefile.config and edit it with nano or vim.

```
cd caffe
cp Makefile.config.example Makefile.config
vim Makefile.config
```

### Modify Makefile.config

- uncomment `USE_CUDNN := 1` to enable cuDNN
- uncomment `CPU_ONLY := 1` for CPU only
- uncomment `OPENCV_VERSION := 3`
- uncomment `CUSTOM_CXX := g++`
- uncomment `CUDA_DIR := /usr/local/cuda` to enable CUDA
- ensure BLAS := atlas
- set `INCLUDE_DIRS := $(PYTHON_INCLUDE) /usr/local/include  /usr/include/hdf5/serial`
- set `LIBRARY_DIRS := $(PYTHON_LIB) /usr/local/lib  /usr/lib/x86_64-linux-gnu/hdf5/serial`
- Remove two first lines from CUDA_ARCH setting

```
CUDA_ARCH := -gencode arch=compute_30,code=sm_30 \ 
				-gencode arch=compute_35,code=sm_35 \
				-gencode arch=compute_50,code=sm_50 \
				-gencode arch=compute_52,code=sm_52 \
				-gencode arch=compute_60,code=sm_60 \
				-gencode arch=compute_61,code=sm_61 \
				-gencode arch=compute_61,code=compute_61
```

- Disable Python 2.7 by commenting:

```
# PYTHON_INCLUDE := /usr/include/python2.7 \
                 /usr/lib/python2.7/dist-packages/numpy/core/include
```

- Enable Python 3.6 by defining:

```
PYTHON_LIBRARIES := boost_python3 python3.6m
PYTHON_INCLUDE := /usr/local/include/python3.6m \
                  /usr/local/lib/python3.6/site-packages/numpy/core/include
 ```


### Verify & Build

Build Python API for `caffe`:

```
make all -j #threads
make test -j #threads && make runtest -j #threads
make pycaffe -j #threads
```

From `~/workspace/caffe` directory, export path to test:

```
export PYTHONPATH=`pwd`/python:$PYTHONPATH
# also add to .bash_profile
sudo bash -c 'echo "export PYTHONPATH=`pwd`/python:$PYTHONPATH" >> ~/.bash_profile'
```

Now, create virtual environment to work with `pycaffe`:

```
cd ~/workspace
python3 -m venv pycaffe-env
source pycaffe-env/bin/activate
(pycaffe-env) pip install numpy scikit-image google google-cloud-storage
```

### Test

```
(pycaffe-env) nano test.py
```

Paste the following content into test.py:

```
import caffe
print(caffe.__version__)
```
Ctrl + X, press Y then Enter to save file.

Run it:

```
(pycaffe-env) python test.py
```

If it works, you should got:

```
1.0.0-rc3
```
