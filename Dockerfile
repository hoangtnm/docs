FROM ubuntu:18.04

ENV LANG=C.UTF-8 LC_ALL=C.UTF-8

RUN apt update && apt install -y wget curl bzip2 ca-certificates \
    libglib2.0-0 libxext6 libsm6 libxrender1 python3-dev

# NVIDIA Base
RUN apt update && apt install -y --no-install-recommends gnupg2 curl ca-certificates && \
    curl -fsSL https://developer.download.nvidia.com/compute/cuda/repos/ubuntu1804/x86_64/7fa2af80.pub | apt-key add - && \
    echo "deb https://developer.download.nvidia.com/compute/cuda/repos/ubuntu1804/x86_64 /" > /etc/apt/sources.list.d/cuda.list && \
    echo "deb https://developer.download.nvidia.com/compute/machine-learning/repos/ubuntu1804/x86_64 /" > /etc/apt/sources.list.d/nvidia-ml.list

ENV NCCL_VERSION 2.4.8
ENV CUDA_VERSION 10.1.243
ENV CUDNN_VERSION 7.6.5.32

LABEL com.nvidia.cudnn.version="${CUDNN_VERSION}"

ENV CUDA_PKG_VERSION 10-1=$CUDA_VERSION-1
# For libraries in the cuda-compat-*
RUN apt update && apt install -y --no-install-recommends \
        cuda-cudart-$CUDA_PKG_VERSION \
        cuda-compat-10-0 \
        cuda-libraries-$CUDA_PKG_VERSION \
        cuda-libraries-dev-$CUDA_PKG_VERSION \
        cuda-nvml-dev-$CUDA_PKG_VERSION \
        cuda-nvtx-$CUDA_PKG_VERSION \
        cuda-minimal-build-$CUDA_PKG_VERSION \
        cuda-command-line-tools-$CUDA_PKG_VERSION \
        libcudnn7=$CUDNN_VERSION-1+cuda10.1 \
        libcudnn7-dev=$CUDNN_VERSION-1+cuda10.1 \
        libnccl2=$NCCL_VERSION-1+cuda10.1 \
        libnccl-dev=$NCCL_VERSION-1+cuda10.1 && \
    apt-mark hold \
        libcudnn7 libcudnn7-dev \
        libnccl2 libnccl-dev

ENV PATH /usr/local/nvidia/bin:/usr/local/cuda-10.1/bin:/opt/cmake-3.14.3/bin${PATH:+:${PATH}}
ENV LD_LIBRARY_PATH /usr/local/nvidia/lib:/usr/local/nvidia/lib64:/opt/OpenBLAS/lib${LD_LIBRARY_PATH:+:${LD_LIBRARY_PATH}}
ENV LIBRARY_PATH /usr/local/cuda-10.1/lib64/stubs${LIBRARY_PATH:+:${LIBRARY_PATH}}

# nvidia-container-runtime
ENV NVIDIA_VISIBLE_DEVICES all
ENV NVIDIA_DRIVER_CAPABILITIES compute,utility


# Install necessary packages
RUN wget https://bootstrap.pypa.io/get-pip.py && \
    python3 get-pip.py && \
    pip3 install tensorflow && \
    pip3 install torch torchvision


# # Install cmake
# WORKDIR /opt

# RUN echo "\nDownloading and building CMake...\n" && \
#     apt update && apt install -y qtbase5-dev libncurses5-dev && \
#     wget https://github.com/Kitware/CMake/releases/download/v3.14.3/cmake-3.14.3.tar.gz && \
#     tar xvzf cmake-3.14.3.tar.gz && cd /opt/cmake-3.14.3 && \
#     ./configure --qt-gui && \
#     ./bootstrap && make -j $(nproc) && make install -j $(nproc)


# # Install OpenBLAS
# WORKDIR /opt/OpenBLAS

# RUN echo "\nDownloading and building OpenBLAS...\n" && \
#     apt update && apt install -y build-essential cython git gcc g++ gfortran unzip libblas-dev liblapack-dev && \
#     git clone https://github.com/xianyi/OpenBLAS.git . && \
#     make FC=gfortran -j $(nproc) && \
#     make install && \
#     sh -c "echo '/opt/OpenBLAS/lib' > /etc/ld.so.conf.d/openblas.conf" && \
#     ldconfig && \
#     update-alternatives --install /usr/lib/libblas.so.3 libblas.so.3 /opt/OpenBLAS/lib/libopenblas.so.0 41 \
#         --slave /usr/lib/liblapack.so.3 liblapack.so.3 /opt/OpenBLAS/lib/libopenblas.so.0


# # Upgrade numpy
# WORKDIR /opt

# RUN pip3 uninstall -y numpy && \
#     pip3 install cython && \
#     wget https://github.com/numpy/numpy/archive/v1.16.3.zip -O numpy.zip && \
#     unzip numpy.zip && cd numpy-1.16.3 && \
#     echo '[openblas]' >> site.cfg && \
# 	echo 'libraries = openblas' >> site.cfg && \
# 	bash -c 'echo "library_dirs = /opt/OpenBLAS/lib" >> site.cfg' && \
#     bash -c 'echo "include_dirs = /opt/OpenBLAS/include" >> site.cfg' && \
#     python3 setup.py config && \
#     python3 setup.py build --fcompiler=gnu95 -j $(nproc) install --prefix=/usr/local


# # Install faiss
# WORKDIR /opt/faiss
        
# RUN echo "\nDownloading and building faiss...\n" && \
#     apt update && apt install -y gcc g++ gfortran make swig && \
#     git clone https://github.com/facebookresearch/faiss.git . && \
#     ./configure --prefix=/usr --libdir=/usr/lib64 --with-cuda=/usr/local/cuda && \
#     make -j $(nproc) && \
#     make install && \
#     make -C python && \
#     make -C python install

WORKDIR /app

CMD ["/bin/bash"]
