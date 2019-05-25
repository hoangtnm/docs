FROM ubuntu:18.04


ENV LANG=C.UTF-8 LC_ALL=C.UTF-8
ENV PATH /opt/conda/bin:$PATH

RUN apt update --fix-missing && apt install -y wget curl bzip2 ca-certificates \
    libglib2.0-0 libxext6 libsm6 libxrender1 \
    git mercurial subversion systemd python3-dev mysql-server default-libmysqlclient-dev net-tools iputils-ping vim htop && \
    rm /usr/bin/python && ln -s /usr/bin/python3 /usr/bin/python && \
    systemctl enable mysql

RUN apt install -y curl grep sed dpkg && \
    TINI_VERSION=`curl https://github.com/krallin/tini/releases/latest | grep -o "/v.*\"" | sed 's:^..\(.*\).$:\1:'` && \
    curl -L "https://github.com/krallin/tini/releases/download/v${TINI_VERSION}/tini_${TINI_VERSION}.deb" > tini.deb && \
    dpkg -i tini.deb && \
    rm tini.deb && \
    apt clean


# Setup NVIDIA Base
RUN apt update && apt install -y --no-install-recommends gnupg2 curl ca-certificates && \
    curl -fsSL https://developer.download.nvidia.com/compute/cuda/repos/ubuntu1804/x86_64/7fa2af80.pub | apt-key add - && \
    echo "deb https://developer.download.nvidia.com/compute/cuda/repos/ubuntu1804/x86_64 /" > /etc/apt/sources.list.d/cuda.list && \
    echo "deb https://developer.download.nvidia.com/compute/machine-learning/repos/ubuntu1804/x86_64 /" > /etc/apt/sources.list.d/nvidia-ml.list

ENV NCCL_VERSION 2.4.7
ENV CUDA_VERSION 10.0.130
ENV CUDNN_VERSION 7.5.1.10

LABEL com.nvidia.cudnn.version="${CUDNN_VERSION}"

ENV CUDA_PKG_VERSION 10-0=$CUDA_VERSION-1
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
        libcudnn7=$CUDNN_VERSION-1+cuda10.0 \
        libcudnn7-dev=$CUDNN_VERSION-1+cuda10.0 \
        libnccl2=$NCCL_VERSION-1+cuda10.0 \
        libnccl-dev=$NCCL_VERSION-1+cuda10.0 && \
    apt-mark hold libcudnn7 libcudnn7-dev && \
    apt-mark hold libnccl2 libnccl-dev && \
    ln -s cuda-10.0 /usr/local/cuda && \
    rm -rf /var/lib/apt/lists/*

ENV PATH /usr/local/nvidia/bin:/usr/local/cuda/bin:/opt/cmake-3.14.3/bin${PATH:+:${PATH}}
ENV LD_LIBRARY_PATH /usr/local/nvidia/lib:/usr/local/nvidia/lib64:/opt/OpenBLAS/lib${LD_LIBRARY_PATH:+:${LD_LIBRARY_PATH}}
ENV LIBRARY_PATH /usr/local/cuda/lib64/stubs${LIBRARY_PATH:+:${LIBRARY_PATH}}

# nvidia-container-runtime
ENV NVIDIA_VISIBLE_DEVICES all
ENV NVIDIA_DRIVER_CAPABILITIES compute,utility


# Install necessary packages
RUN wget https://bootstrap.pypa.io/get-pip.py && \
    python3 get-pip.py && \
    pip3 install tensorflow-gpu && \
    pip3 install https://download.pytorch.org/whl/cu100/torch-1.1.0-cp36-cp36m-linux_x86_64.whl && \
    pip3 install torchvision


# Install cmake
WORKDIR /opt

RUN echo "\nDownloading and building CMake...\n" && \
    apt update && apt install -y qtbase5-dev libncurses5-dev && \
    wget https://github.com/Kitware/CMake/releases/download/v3.14.3/cmake-3.14.3.tar.gz && \
    tar xvzf cmake-3.14.3.tar.gz && cd /opt/cmake-3.14.3 && \
    ./configure --qt-gui && \
    ./bootstrap && make -j $(nproc) && make install -j $(nproc)


# Install OpenBLAS
WORKDIR /opt/OpenBLAS

RUN echo "\nDownloading and building OpenBLAS...\n" && \
    apt update && apt install -y build-essential cython git gcc g++ gfortran unzip libblas-dev liblapack-dev && \
    git clone https://github.com/xianyi/OpenBLAS.git . && \
    make FC=gfortran -j $(nproc) && \
    make install && \
    sh -c "echo '/opt/OpenBLAS/lib' > /etc/ld.so.conf.d/openblas.conf" && \
    ldconfig && \
    update-alternatives --install /usr/lib/libblas.so.3 libblas.so.3 /opt/OpenBLAS/lib/libopenblas.so.0 41 \
        --slave /usr/lib/liblapack.so.3 liblapack.so.3 /opt/OpenBLAS/lib/libopenblas.so.0


# Upgrade numpy
WORKDIR /opt

RUN pip3 uninstall -y numpy && \
    pip3 install cython && \
    wget https://github.com/numpy/numpy/archive/v1.16.3.zip -O numpy.zip && \
    unzip numpy.zip && cd numpy-1.16.3 && \
    echo '[openblas]' >> site.cfg && \
	echo 'libraries = openblas' >> site.cfg && \
	bash -c 'echo "library_dirs = /opt/OpenBLAS/lib" >> site.cfg' && \
    bash -c 'echo "include_dirs = /opt/OpenBLAS/include" >> site.cfg' && \
    python3 setup.py config && \
    python3 setup.py build --fcompiler=gnu95 -j $(nproc) install --prefix=/usr/local


# Install faiss
WORKDIR /opt/faiss
        
RUN echo "\nDownloading and building faiss...\n" && \
    apt update && apt install -y gcc g++ gfortran make swig && \
    git clone https://github.com/facebookresearch/faiss.git . && \
    ./configure --prefix=/usr --libdir=/usr/lib64 --with-cuda=/usr/local/cuda && \
    make -j $(nproc) && \
    make install && \
    make -C python && \
    make -C python install


# Install Caffe
ENV TZ=Asia/Bangkok
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

ENV CAFFE_ROOT=/opt/caffe
WORKDIR $CAFFE_ROOT

RUN echo "\nDownloading and building Caffe...\n" && \
    git clone https://github.com/CMU-Perceptual-Computing-Lab/caffe.git . && \
    apt install -y libopencv-dev libprotobuf-dev libleveldb-dev libsnappy-dev libhdf5-serial-dev protobuf-compiler \
        libhdf5-serial-dev libgflags-dev libgoogle-glog-dev liblmdb-dev libboost-all-dev && \
    cd python && for req in $(cat requirements.txt) pydot; do pip install $req; done && cd .. && \
    pip3 install protobuf setuptools && \
    cp Makefile.config.Ubuntu16_cuda8.example Makefile.config && \
    sed -i 's/#\ OPENCV_VERSION\ :=\ 3/OPENCV_VERSION\ :=\ 3/g' Makefile.config && \
    sed -i 's/#\ CUSTOM_CXX\ :=\ g++/CUSTOM_CXX\ :=\ g++/g' Makefile.config && \
    sed -i 's/BLAS\ :=\ atlas/BLAS\ :=\ open/g' Makefile.config && \
    sed -i 's/#\ BLAS_INCLUDE\ :=\ \/path\/to\/your\/blas/BLAS_INCLUDE\ :=\ \/opt\/OpenBLAS\/include/g' Makefile.config && \
    sed -i 's/#\ BLAS_LIB\ :=\ \/path\/to\/your\/blas/BLAS_LIB\ :=\ \/opt\/OpenBLAS\/lib/g' Makefile.config && \
    sed -i 's/PYTHON_INCLUDE\ := \/usr\/include\/python2.7/#PYTHON_INCLUDE\ :=\ \/usr\/include\/python2.7/g' Makefile.config && \
    sed -i 's/#\ PYTHON_LIBRARIES\ :=\ boost_python3\ python3.5m/PYTHON_LIBRARIES\ :=\ boost_python3\ python3.6m/g' Makefile.config && \
    sed -i 's/#\ PYTHON_INCLUDE\ :=\ \/usr\/include\/python3.5m/PYTHON_INCLUDE\ :=\ \/usr\/include\/python3.6m/g' Makefile.config && \
    sed -i 's/#\                 \/usr\/lib\/python3.5\/dist-packages\/numpy\/core\/include/\                 \/usr\/local\/lib\/python3.6\/dist-packages\/numpy-1.16.3-py3.6-linux-x86_64.egg\/numpy\/core\/include/g' Makefile.config && \
    make all -j $(nproc) && \
    make test -j $(nproc) && \
    make pycaffe -j $(nproc)

ENV PYCAFFE_ROOT $CAFFE_ROOT/python
ENV PYTHONPATH $PYCAFFE_ROOT${PYTHONPATH:+:${PYTHONPATH}}
ENV PATH $CAFFE_ROOT/build/tools:$PYCAFFE_ROOT:$PATH
RUN echo "$CAFFE_ROOT/build/lib" >> /etc/ld.so.conf.d/caffe.conf && ldconfig

WORKDIR /app

# # Install OpenPose
# WORKDIR /opt/openpose

# ENV OPENPOSE_CLONE_TAG v1.4.0

# RUN echo "\nInstalling dependencies...\n" && \
#     cp -ruax /opt/caffe/build/src/caffe/proto/ /opt/caffe/include/caffe && \
# 	apt install -y libprotobuf-dev protobuf-compiler pciutils \
#         libcanberra-gtk-module libopencv-dev libeigen3-dev doxygen && \
#     pip3 install protobuf opencv-contrib-python==3.4.5.20 opencv-python==3.4.5.20

# RUN echo "\nDownloading and building OpenPose...\n" && \
#     git clone -b $OPENPOSE_CLONE_TAG https://github.com/CMU-Perceptual-Computing-Lab/openpose.git . && \
#     mkdir build && cd build && \
#     cmake \
#       -DCMAKE_BUILD_TYPE="Release" \
#       -DBUILD_CAFFE=OFF \
#       -DBUILD_EXAMPLES=ON \
#       -DBUILD_DOCS=ON \
#       -DBUILD_SHARED_LIBS=ON \
#       -DDOWNLOAD_BODY_25_MODEL=ON \
#       -DDOWNLOAD_BODY_COCO_MODEL=ON \
#       -DDOWNLOAD_BODY_MPI_MODEL=ON \
#       -DDOWNLOAD_HAND_MODEL=ON \
#       -DWITH_3D_RENDERER:BOOL=OFF \
#       -DCaffe_INCLUDE_DIRS="/opt/caffe/include" \
#       -DCaffe_LIBS="/opt/caffe/build/lib/libcaffe.so" \
#       -DBUILD_PYTHON=ON ../ && \
#     make all -j $(nproc) && \
#     make install

# ENV PYTHONPATH /opt/openpose/build/python${PYTHONPATH:+:${PYTHONPATH}}


ENTRYPOINT [ "/usr/bin/tini", "--" ]
CMD ["/bin/bash"]
