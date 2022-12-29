FROM nvidia/cuda:11.2.2-cudnn8-runtime-ubuntu20.04

ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update && apt-get install -y --no-install-recommends \
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
ARG PYTHON_VERSION=3.8
RUN wget -qO ~/miniconda.sh https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh \
    && chmod +x ~/miniconda.sh \
    && bash ~/miniconda.sh -b -p /opt/conda \
    && rm ~/miniconda.sh
RUN /opt/conda/bin/conda config \
    --set default_threads 4 \
    # --set channel_priority strict \
    && /opt/conda/bin/conda config \
    # --add channels conda-forge \
    --add channels pytorch \
    && /opt/conda/bin/conda install -y python=${PYTHON_VERSION} \
    && /opt/conda/bin/pip config set global.find-links \
    "https://download.pytorch.org/whl/cu113/torch_stable.html \
    https://release.colossalai.org \
    https://storage.googleapis.com/jax-releases/jax_releases.html" \
    && /opt/conda/bin/pip config set global.extra-index-url \
    "https://developer.download.nvidia.com/compute/redist" \
    && /opt/conda/bin/conda clean -ya
RUN /opt/conda/bin/pip install --no-cache-dir -U \
    albumentations \
    accelerate \
    black \
    torch~=1.12.1 \
    pytorch-lightning[extra]~=1.8.4 \
    torchvision \
    torchaudio \
    torchtext \
    torchmetrics~=0.10.0 \
    tokenizers \
    transformers[sentencepiece]~=4.25.1 \
    datasets \
    decord \
    deepspeed~=0.6.0 \
    fairscale \
    fiftyone \
    flax \
    git+https://github.com/kpu/kenlm.git \
    gluoncv \
    gradio \
    h5py \
    hydra-core \
    imutils \
    isort \
    jax[cuda11_cudnn805] \
    jiwer \
    jupyter~=1.0.0 \
    jupyterlab \
    jupyterlab-code-formatter \
    librosa \
    matplotlib \
    monai \
    nemo_toolkit[asr] \
    # git+https://github.com/NVIDIA/NeMo.git#egg=nemo_toolkit[asr,nlp,tts] \
    nvidia-dali-cuda110 \
    omegaconf \
    opencv-python-headless \
    pandas \
    phonemizer \
    pillow \
    plotly \
    pyctcdecode \
    scikit-image \
    scikit-learn \
    scipy \
    seaborn \
    sentencepiece \
    sox \
    tensorboard \
    tqdm