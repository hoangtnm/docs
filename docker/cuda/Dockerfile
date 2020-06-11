FROM ubuntu:18.04

RUN apt-get update && apt-get install -y --no-install-recommends \
    gnupg2 curl ca-certificates \
    && curl -fsSL https://developer.download.nvidia.com/compute/cuda/repos/ubuntu1804/x86_64/7fa2af80.pub | apt-key add - \
    && echo "deb https://developer.download.nvidia.com/compute/cuda/repos/ubuntu1804/x86_64 /" > /etc/apt/sources.list.d/cuda.list \
    && echo "deb https://developer.download.nvidia.com/compute/machine-learning/repos/ubuntu1804/x86_64 /" > /etc/apt/sources.list.d/nvidia-ml.list \
    && apt-get purge --autoremove -y curl \
    && rm -rf /var/lib/apt/lists/*

ENV CUDA_VERSION 10.1.243
ENV CUDA_PKG_VERSION 10-1=$CUDA_VERSION-1

ENV CUDNN_VERSION 7.6.5.32
LABEL com.nvidia.cudnn.version="${CUDNN_VERSION}"

ENV NCCL_VERSION 2.4.8

RUN apt-get update && apt-get install -y --no-install-recommends \
    cuda-cudart-$CUDA_PKG_VERSION \
    cuda-compat-10-1 \
    cuda-nvml-dev-$CUDA_PKG_VERSION \
    cuda-command-line-tools-$CUDA_PKG_VERSION \
    cuda-libraries-dev-$CUDA_PKG_VERSION \
    cuda-minimal-build-$CUDA_PKG_VERSION \
    libcublas10=10.2.1.243-1 \
    libcublas-dev=10.2.1.243-1 \
    cuda-libraries-$CUDA_PKG_VERSION \
    cuda-nvtx-$CUDA_PKG_VERSION \
    libcudnn7=$CUDNN_VERSION-1+cuda10.1 \
    libcudnn7-dev=$CUDNN_VERSION-1+cuda10.1 \
    libnccl-dev=$NCCL_VERSION-1+cuda10.1 \
    libnccl2=$NCCL_VERSION-1+cuda10.1 \
    && apt-mark hold libcudnn7 libnccl2 \
    && ln -s cuda-10.1 /usr/local/cuda \
    && rm -rf /var/lib/apt/lists/*

ENV PATH /usr/local/nvidia/bin:/usr/local/cuda/bin:${PATH}
ENV LD_LIBRARY_PATH /usr/local/nvidia/lib:/usr/local/nvidia/lib64
ENV LIBRARY_PATH /usr/local/cuda/lib64/stubs

# nvidia-container-runtime
ENV NVIDIA_VISIBLE_DEVICES all
ENV NVIDIA_DRIVER_CAPABILITIES compute,utility
ENV NVIDIA_REQUIRE_CUDA "cuda>=10.1 brand=tesla,driver>=384,driver<385 brand=tesla,driver>=396,driver<397 brand=tesla,driver>=410,driver<411"
