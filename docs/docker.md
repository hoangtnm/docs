# Set Up Docker Development Environment <!-- omit in toc -->

## Contents <!-- omit in toc -->

- [Install Docker Engine on Ubuntu](#install-docker-engine-on-ubuntu)
- [Post-installation steps for Linux](#post-installation-steps-for-linux)
  - [Manage Docker as a non-root user](#manage-docker-as-a-non-root-user)
  - [Configure Docker to start on boot](#configure-docker-to-start-on-boot)
  - [Daemon configuration file](#daemon-configuration-file)
- [NVIDIA Container Runtime for Docker](#nvidia-container-runtime-for-docker)
  - [Usage](#usage)
  - [NVIDIA Docker Wiki](#nvidia-docker-wiki)
    - [Official CUDA Docker Images](#official-cuda-docker-images)
  - [Default Runtime](#default-runtime)
  - [Environment variables (OCI spec)](#environment-variables-oci-spec)
- [References](#references)

## Install Docker Engine on Ubuntu

Docker Engine - Ubuntu (Community) is the best way to install the Docker platform on Ubuntu Linux environments. Simplify provisioning and setup of Docker and accelerate your time to value in building and deploying container based applications.

For more details or alternative installation procedures, including how to install `stable` builds, see: https://docs.docker.com/engine/installation/linux/docker-ce/ubuntu/

## Post-installation steps for Linux

### Manage Docker as a non-root user

The Docker daemon binds to a Unix socket instead of a TCP port. By default that Unix socket is owned by the user `root` and other users can only access it using `sudo`. The Docker daemon always runs as the `root` user.

If you don’t want to preface the `docker` command with `sudo`, create a Unix group called `docker` and add users to it. When the Docker daemon starts, it creates a Unix socket accessible by members of the `docker` group.

```bash
sudo groupadd docker
sudo usermod -aG docker $USER
```

Log out and log back in so that your group membership is re-evaluated. On Linux, you can also run the following command to activate the changes to groups:

```bash
newgrp docker
```

Verify that you can run `docker` commands without sudo.

```bash
docker run hello-world
```

### Configure Docker to start on boot

```
sudo systemctl enable docker
```

### Daemon configuration file

The default location of the configuration file on Linux is `/etc/docker/daemon.json`.

```json
{
  "data-root": "/path/to/persisted/data",
  "default-runtime": "nvidia",
  "runtimes": {
    "nvidia": {
      "path": "nvidia-container-runtime",
      "runtimeArgs": []
    }
  }
}
```

- `data-root`: Root directory of persistent Docker state (default `/var/lib/docker`).
- `default-runtime`: Default OCI runtime for containers (default `runc`).

Everytime the configuration file is updated, the following commands will need being executed:

```bash
sudo systemctl daemon-reload
sudo systemctl restart docker
```

## NVIDIA Container Runtime for Docker

The NVIDIA Container Toolkit allows users to build and run GPU accelerated Docker containers. The toolkit includes a container runtime [library](https://github.com/NVIDIA/libnvidia-container) and utilities to automatically configure containers to leverage NVIDIA GPUs. Full documentation and frequently asked questions are available on the [repository wiki](https://github.com/NVIDIA/nvidia-docker/wiki).

<p align="center">
    <img src="https://devblogs.nvidia.com/wp-content/uploads/2018/05/dgx-docker-768x728.png" width="50%" height="50%">
</p>

**Make sure you have installed the [NVIDIA driver](https://github.com/NVIDIA/nvidia-docker/wiki/Frequently-Asked-Questions#how-do-i-install-the-nvidia-driver) and Docker engine for your Linux distribution. Note that you do not need to install the CUDA toolkit on the host, but the driver needs to be installed**

For instructions on getting started with the NVIDIA Container Toolkit, refer to the [installation guide](https://docs.nvidia.com/datacenter/cloud-native/container-toolkit/install-guide.html#docker).

### Usage

```bash
#### Test nvidia-smi with the latest official CUDA image
docker run --gpus all nvidia/cuda:10.0-base nvidia-smi

# Start a GPU enabled container on two GPUs
docker run --gpus 2 nvidia/cuda:10.0-base nvidia-smi

# Starting a GPU enabled container on specific GPUs
docker run --gpus '"device=1,2"' nvidia/cuda:10.0-base nvidia-smi
docker run --gpus '"device=UUID-ABCDEF,1"' nvidia/cuda:10.0-base nvidia-smi
```

### NVIDIA Docker Wiki

This section is referenced from [nvidia-docker wiki](https://github.com/NVIDIA/nvidia-docker/wiki), which you can refer for the up-to-date information.

#### Official CUDA Docker Images

https://hub.docker.com/r/nvidia/cuda/

### Default Runtime

The default runtime used by the Docker Engine is [runc](https://github.com/opencontainers/runc), our runtime can become the default one by configuring the docker daemon with `--default-runtime=nvidia`. Doing so will remove the need to add the `--runtime=nvidia` argument to `docker run`. It is also the only way to have GPU access during `docker build`.

You can set `nvidia` as the default runtime, for example, by adding the following line to the `/etc/docker/daemon.json` configuration file as the first entry.

```json
"default-runtime": "nvidia",
```

The following is an example of how the added line appears in the JSON file. Do not remove any pre-existing content when making this change.

```json
{
  "default-runtime": "nvidia",
  "runtimes": {
    "nvidia": {
      "path": "nvidia-container-runtime",
      "runtimeArgs": []
    }
  }
}
```

You can then use `docker run` to run GPU-accelerated containers.

```
docker run ...
```

> If you build Docker images while `nvidia` is set as the default runtime, make sure the build scripts executed by the Dockerfile specify the GPU architectures that the container will need. Failure to do so may result in the container being optimized only for the GPU architecture on which it was built. Instructions for specifying the GPU architecture depend on the application and are beyond the scope of this document. Consult the specific application build process for guidance [1].

### Environment variables (OCI spec)

Each environment variable maps to an command-line argument for `nvidia-container-cli` from [libnvidia-container](https://github.com/NVIDIA/libnvidia-container).  
These variables are already set in our [official CUDA images](https://hub.docker.com/r/nvidia/cuda/).

## References

[1] N. Corporation. (). Upgrading to the nvidia container runtime for docker, [Online]. Available: https://docs.nvidia.com/dgx/nvidia-container-runtime-upgrade/index.html#using-nv-container-runtime. (accessed: 05.18.2020).
