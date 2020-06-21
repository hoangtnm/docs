# Build Caffe from source

<p align="center">
  <img src="https://www.nvidia.com/content/dam/en-zz/Solutions/Data-Center/caffe/GPU-ReadyApp_Caffe_Social-Image_TW-LI_2048X1024.jpg" alt="Caffe Logo">
</p>

### Requirements

- [Ubuntu 20.04](https://ubuntu.com/desktop/developers)
- CUDA 10.1, cuDNN 7.6 ([refer](setup_guidance.md))
- Python 3.7.7 ([refer](python_devel.md))
- OpenBLAS ([refer](OpenBLAS.md))

### Installation

```bash
sudo apt-get update && sudo apt-get install -y \
	build-essential \
	libhdf5-serial-dev \
	libboost-all-dev \
    libprotobuf-dev \
	libleveldb-dev \
	libsnappy-dev \
	liblmdb-dev \
	libgflags-dev \
	libgoogle-glog-dev \
    protobuf-compiler \
	git
```

```bash
git clone -b ssd https://github.com/weiliu89/caffe.git && cd caffe
```

Then create Makefile.config and edit it with the following configs.

```bash
cp Makefile.config.example Makefile.config
vim Makefile.config
```

### Modify Makefile.config

- uncomment `USE_CUDNN := 1` to enable cuDNN
- uncomment `CPU_ONLY := 1` for CPU only
- uncomment `OPENCV_VERSION := 3`
- uncomment `CUSTOM_CXX := g++`
- uncomment `CUDA_DIR := /usr/local/cuda` to enable CUDA
- ensure BLAS := open
- set `INCLUDE_DIRS := $(PYTHON_INCLUDE) /usr/local/include /usr/include/hdf5/serial`
- set `LIBRARY_DIRS := $(PYTHON_LIB) /usr/local/lib /usr/lib/x86_64-linux-gnu/hdf5/serial`

```bash
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

- Enable Python 3.7 by defining:

```
PYTHON_LIBRARIES := boost_python3 python3.7m
PYTHON_INCLUDE := /usr/local/include/python3.7m \
                  /usr/local/lib/python3.7/site-packages/numpy/core/include
```

### Build

Build Python API for `caffe`:

```bash
make all -j $(nproc)
make test -j $(nproc) && make runtest -j $(nproc)
make pycaffe -j $(nproc)
```

From `~/workspace/caffe` directory, export path to test:

```bash
PYTHONPATH=`pwd`/python:$PYTHONPATH
echo export PYTHONPATH=$(pwd)/python:'$PYTHONPATH' >> ~/.bashrc
source ~/.bashrc
```

Now, install `pycaffe` in a virtual environment:

```bash
cd ~/workspace
python3 -m venv pycaffe-env
source pycaffe-env/bin/activate
(pycaffe-env) pip install numpy scikit-image google google-cloud-storage
```

### Verify

```bash
(pycaffe-env) $ python -c 'import caffe; print(caffe.__version__)'
1.0.0-rc3
```
