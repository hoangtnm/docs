FROM nvidia/cuda:11.1.1-cudnn8-devel-ubuntu20.04

ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update && apt-get install -y \
    build-essential \
    ca-certificates \
    ccache \
    cmake \
    libcurl3-dev \
    libfreetype6-dev \
    libhdf5-serial-dev \
    libzmq3-dev \
    pkg-config \
    rsync \
    software-properties-common \
    unzip \
    zip \
    zlib1g-dev \
    curl \
    wget \
    git \
    git-lfs \
    vim \
    zsh \
    fonts-powerline \
    fonts-firacode \
    libjpeg-dev \
    libpng-dev \
    libopenjp2-7-dev \
    liblcms2-dev \
    libtiff-dev \
    libz-dev \
    openmpi-bin \
    python3-opencv \
    nvtop \
    && rm -rf /var/lib/apt/lists/*

ENV PATH /opt/conda/bin:$PATH
ARG PYTHON_VERSION=3.7
RUN wget -O ~/miniconda.sh https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh \
    && chmod +x ~/miniconda.sh \
    && ~/miniconda.sh -b -p /opt/conda \
    && rm ~/miniconda.sh \
    && /opt/conda/bin/conda config --set repodata_threads 2 \
    && /opt/conda/bin/conda config --add channels nvidia \
    && /opt/conda/bin/conda config --add channels pytorch \
    && /opt/conda/bin/conda config --append channels conda-forge
RUN /opt/conda/bin/conda install -y -c pytorch -c nvidia -c defaults -c conda-forge \
    python=${PYTHON_VERSION} \
    pytorch \
    pytorch-lightning\
    torchvision \
    torchmetrics \
    cudatoolkit \
    jupyterlab \
    matplotlib \
    scipy \
    scikit-learn \
    pandas \
    pillow \
    && /opt/conda/bin/conda clean -ya \
    && /opt/conda/bin/pip install opencv-python torchelastic lightning-bolts["extra"] \
    && /opt/conda/bin/pip install --extra-index-url https://developer.download.nvidia.com/compute/redist --upgrade nvidia-dali-cuda110
