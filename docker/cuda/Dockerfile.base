# FROM ubuntu:22.04 as base
FROM nvidia/cuda:12.2.2-devel-ubuntu22.04 as base

FROM base as base-amd64

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
    vim \
    wget \
    python3-dev \
    python3-pip \
    python3-opencv \
    && rm -rf /var/lib/apt/lists/*

COPY requirements.txt .
RUN python3 -m pip install --no-cache-dir -r requirements.txt \
    && rm requirements.txt
