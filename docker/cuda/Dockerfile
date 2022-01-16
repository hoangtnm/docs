# FROM nvidia/cuda:11.1.1-cudnn8-devel-ubuntu20.04
FROM nvidia/cuda:11.1.1-base-ubuntu20.04

ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update && apt-get install -y \
    build-essential \
    ca-certificates \
    ccache \
    cmake \
    curl \
    git \
    git-lfs \
    libcurl3-dev \
    libfreetype6-dev \
    libhdf5-serial-dev \
    libzmq3-dev \
    libjpeg-dev \
    libpng-dev \
    libopenjp2-7-dev \
    liblcms2-dev \
    libtiff-dev \
    libsndfile1 \
    ffmpeg \
    libz-dev \
    pkg-config \
    software-properties-common \
    sox \
    zlib1g-dev \
    wget \
    openmpi-bin \
    python3-dev \
    python3-opencv \
    && rm -rf /var/lib/apt/lists/*

ENV PATH /opt/conda/bin:$PATH
ARG PYTHON_VERSION=3.7
RUN wget -qO ~/miniconda.sh https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh \
    && chmod +x ~/miniconda.sh \
    && ~/miniconda.sh -b -p /opt/conda \
    && rm ~/miniconda.sh
RUN /opt/conda/bin/conda config \
    --set repodata_threads 4 \
    # --set channel_priority strict \
    && /opt/conda/bin/conda config \
    --add channels conda-forge \
    # --add channels nvidia \
    --add channels pytorch \
    && /opt/conda/bin/conda config \
    --append channels conda-forge \
RUN /opt/conda/bin/conda install -y \
    python=${PYTHON_VERSION} \
    pytorch=1.10 \
    pytorch-lightning \
    torchvision \
    torchaudio \
    torchtext \
    torchmetrics \
    tokenizers \
    transformers \
    tensorflow-gpu=2.6.2 \
    datasets \
    cudatoolkit=10.2 \
    h5py \
    hydra-core \
    jupyterlab \
    # librosa \
    matplotlib \
    omegaconf \
    onnx \
    pandas \
    pillow \
    # plotly \
    pynini \
    # pysoundfile \
    requests \
    scikit-image \
    scikit-learn \
    scipy \
    # seaborn \
    sentencepiece \
    # sox \
    # spacy \
    tensorboard \
    tqdm \
    unidecode \
    && /opt/conda/bin/conda clean -ya
RUN /opt/conda/bin/pip install --no-cache-dir --upgrade \
    --extra-index-url https://developer.download.nvidia.com/compute/redist \
    # git+https://github.com/NVIDIA/NeMo.git#egg=nemo_toolkit[asr,nlp,tts] \
    albumentations \
    deepspeed \
    fairscale \
    fiftyone \
    gluoncv \
    monai \
    nemo_toolkit \
    nvidia-dali-cuda110 \
    imutils \
    opencv-python-headless
