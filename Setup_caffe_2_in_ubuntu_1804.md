# Setup Caffe 2 in Ubuntu 18.04


### Requirements

- Ubuntu 18.04 ([refer](https://github.com/greenglobal/ggml-docs/blob/master/setup_ubuntu_1804_from_minimalcd.md))
- CUDA 9.2, cuDNN 7.2 ([refer](https://github.com/hoangtnm/TrainingServer-docs/blob/master/Setup-machine-for-Deep_Learning.md))
- Python 3.6.5 (must be installed exactly as same as [this guideline](https://github.com/hoangtnm/TrainingServer-docs/blob/master/setup_python_3_dev_environment.md))

### Install Dependencies

```
sudo apt-get update
sudo apt-get install -y --no-install-recommends \
      build-essential \
      cmake \
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
      protobuf-compiler                          
pip install numpy protobuf
```

### Clone & Build

```
git clone https://github.com/pytorch/pytorch.git && cd pytorch
git submodule update --init --recursive
python setup.py install
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
