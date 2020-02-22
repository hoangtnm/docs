# AI Workstation Documents

This repo includes some documents and scripts for setting up an AI workstation powered by NVIDIA GPUs.

## Documents

- [Deep Learning Machine Set-up](Machine_Setup.md)
- [Python 3 Dev Set-up](Python3.md)
- [Oh My Zsh Framework](ohmyzsh/README.md)
- [NVIDIA CUDA with Docker](docker/README.md)
- [Connecting to GitHub with SSH](Github_SSH.md)
- [Performing GPU, CPU, and I/O stress testing on Linux](Benchmark.md)
- [Mounting NTFS Partitions](Partitions.md)
- [Getting Started With Jetson Nano Developer Kit](Jetson_Nano.md)
- [Installing Tensorflow from Sources](Build_tensorflow_from_source.md)

## Scripts

- [Installing NVIDIA Driver](scripts/install-nvidia-driver.sh)
- [Installing CUDA Toolkit 10.1](scripts/install-cuda-10.sh)
- [Installing Python 3](scripts/install-python3-from_source.sh)
- [Installing Protobuf](scripts/install-protobuf-from_source.sh)
- [Installing Intel MKL](scripts/install-intel-mkl-from_apt.sh)
- [Installing OpenBLAS](scripts/install-openblas-from_source.sh)
- [Installing Numpy from source](scripts/install-numpy-from_source.sh)
- [Installing Scipy from source](scripts/install-scipy-from_source.sh)
- [Installing Scikit-learn from source](scripts/install-sklearn-from_source.sh)
- [Installing Bazel](scripts/install-bazel.sh)
- [Installing TensorFlow from source](scripts/install-tensorflow-from_source.sh)

## Tips

### Exposing a Jupyter Notebook server

```sh
jupyter notebook --ip 0.0.0.0 --port $PORT
```