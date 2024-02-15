ARG IMAGE=nvidia

FROM ubuntu:22.04 as base-ubuntu

RUN apt-get update && apt-get install -y --no-install-recommends \
    ca-certificates \
    wget \
    && wget https://developer.download.nvidia.com/compute/cuda/repos/ubuntu2204/x86_64/cuda-keyring_1.0-1_all.deb \
    && dpkg -i cuda-keyring_1.0-1_all.deb \
    && rm cuda-keyring_1.0-1_all.deb \
    && rm -rf /var/lib/apt/lists/*

FROM nvidia/cuda:12.1.1-cudnn8-devel-ubuntu20.04 as base-nvidia

FROM base-${IMAGE} as base-amd64

ENV DEBIAN_FRONTEND noninteractive
ENV NVIDIA_VISIBLE_DEVICES all
ENV NVIDIA_DRIVER_CAPABILITIES compute,utility

# ENV TZ="Asia/Ho_Chi_Minh"
# RUN apt-get update && apt-get install -y --no-install-recommends \
#     tzdata \
#     && dpkg-reconfigure tzdata \
#     && rm -rf /var/lib/apt/lists/*

RUN apt-get update && apt-get install -y --no-install-recommends \
    build-essential \
    cmake \
    curl \
    ffmpeg \
    git \
    git-lfs \
    htop \
    libboost-all-dev \
    libegl-mesa0 \
    libgl1-mesa-dri \
    libglapi-mesa \
    libglx-mesa0 \
    python3-dev \
    python3-pip \
    python3-opencv \
    vim \
    wget \
    zsh \
    && rm -rf /var/lib/apt/lists/*

ENV PATH /opt/conda/bin:$PATH
ARG PYTHON_VERSION=3.8
RUN wget -qO ~/miniconda.sh https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh \
    && chmod +x ~/miniconda.sh \
    && bash ~/miniconda.sh -b -p /opt/conda \
    && rm ~/miniconda.sh \
    && /opt/conda/bin/conda install -y python=${PYTHON_VERSION} \
    && /opt/conda/bin/conda clean -ya

COPY requirements_base.txt .
COPY requirements_dev.txt .
RUN python3 -m pip install --no-cache-dir \
    -r requirements_base.txt \
    -r requirements_dev.txt \
    && rm requirements_*.txt

ARG USERNAME=master
ARG USER_UID=1000
ARG USER_GID=$USER_UID

# Create the user
RUN groupadd --gid $USER_GID $USERNAME \
    && useradd --uid $USER_UID --gid $USER_GID -m $USERNAME \
    #
    # [Optional] Add sudo support. Omit if you don't need to install software after connecting.
    && apt-get update \
    && apt-get install -y sudo \
    && echo $USERNAME ALL=\(root\) NOPASSWD:ALL > /etc/sudoers.d/$USERNAME \
    && chmod 0440 /etc/sudoers.d/$USERNAME
USER $USERNAME
RUN cd /home/${USERNAME} \
    && wget https://github.com/robbyrussell/oh-my-zsh/raw/master/tools/install.sh -O - | zsh || true
