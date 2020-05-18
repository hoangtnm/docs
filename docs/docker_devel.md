# Configuring Docker Development Environment <!-- omit in toc -->

## Contents <!-- omit in toc -->

- [Install Docker Engine on Ubuntu](#install-docker-engine-on-ubuntu)
- [Post-installation steps for Linux](#post-installation-steps-for-linux)
  - [Manage Docker as a non-root user](#manage-docker-as-a-non-root-user)
  - [Configure Docker to start on boot](#configure-docker-to-start-on-boot)
- [NVIDIA Container Runtime for Docker](#nvidia-container-runtime-for-docker)
  - [Quickstart](#quickstart)
  - [Usage](#usage)
  - [NVIDIA Docker Wiki](#nvidia-docker-wiki)
    - [Official CUDA Docker Images](#official-cuda-docker-images)
  - [Default Runtime](#default-runtime)
  - [Environment variables (OCI spec)](#environment-variables-oci-spec)
    - [`NVIDIA_VISIBLE_DEVICES`](#nvidia_visible_devices)
      - [Possible values](#possible-values)
    - [`NVIDIA_DRIVER_CAPABILITIES`](#nvidia_driver_capabilities)
      - [Possible values](#possible-values-1)
      - [Supported driver capabilities](#supported-driver-capabilities)
    - [`NVIDIA_REQUIRE_*`](#nvidia_require_)
      - [Supported constraints](#supported-constraints)
      - [Expressions](#expressions)
    - [`NVIDIA_DISABLE_REQUIRE`](#nvidia_disable_require)
    - [`NVIDIA_REQUIRE_CUDA`](#nvidia_require_cuda)
      - [Possible values](#possible-values-2)
    - [`CUDA_VERSION`](#cuda_version)
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

## NVIDIA Container Runtime for Docker

The NVIDIA Container Toolkit allows users to build and run GPU accelerated Docker containers. The toolkit includes a container runtime [library](https://github.com/NVIDIA/libnvidia-container) and utilities to automatically configure containers to leverage NVIDIA GPUs. Full documentation and frequently asked questions are available on the [repository wiki](https://github.com/NVIDIA/nvidia-docker/wiki).

<p align="center">
    <img src="https://devblogs.nvidia.com/wp-content/uploads/2018/05/dgx-docker-768x728.png" width="50%" height="50%">
</p>

### Quickstart

**Make sure you have installed the [NVIDIA driver](https://github.com/NVIDIA/nvidia-docker/wiki/Frequently-Asked-Questions#how-do-i-install-the-nvidia-driver) and Docker 19.03 for your Linux distribution. Note that you do not need to install the CUDA toolkit on the host, but the driver needs to be installed**

> **Note:** with the release of Docker 19.03, usage of nvidia-docker2 packages are deprecated since NVIDIA GPUs are now natively supported as devices in the Docker runtime.

**Please note that this native GPU support has not landed in docker-compose yet. Refer to [this issue](https://github.com/docker/compose/issues/6691) for discussion.**

```bash
# Add the package repositoriess
distribution=$(. /etc/os-release; echo $ID$VERSION_ID)
curl -s -L https://nvidia.github.io/nvidia-docker/gpgkey | sudo apt-key add -
curl -s -L https://nvidia.github.io/nvidia-docker/$distribution/nvidia-docker.list | sudo tee /etc/apt/sources.list.d/nvidia-docker.list

sudo apt update && sudo apt install -y nvidia-container-toolkit
sudo systemctl restart docker
```

### Usage

```bash
#### Test nvidia-smi with the latest official CUDA image
docker run --gpus all nvidia/cuda:10.0-base nvidia-smi

# Start a GPU enabled container on two GPUs
docker run --gpus 2 nvidia/cuda:10.0-base nvidia-smi

# Starting a GPU enabled container on specific GPUs
docker run --gpus '"device=1,2"' nvidia/cuda:10.0-base nvidia-smi
docker run --gpus '"device=UUID-ABCDEF,1"' nvidia/cuda:10.0-base nvidia-smi

# Specifying a capability (graphics, compute, ...) for my container
# Note this is rarely if ever used this way
docker run --gpus all,capabilities=utility nvidia/cuda:10.0-base nvidia-smi
```

### NVIDIA Docker Wiki

This section is referenced from [nvidia-docker wiki](https://github.com/NVIDIA/nvidia-docker/wiki), which you can refer for the up-to-date information.

#### Official CUDA Docker Images

https://hub.docker.com/r/nvidia/cuda/

#### Can I use the GPU during a container build (i.e. `docker build`)? <!-- omit in toc -->

Yes, as long as you [configure your Docker daemon](#default-runtime) to use the `nvidia` runtime as the default, you will be able to have build-time GPU support. However, be aware that this can render your images non-portable (see also [invalid device function](https://github.com/NVIDIA/nvidia-docker/wiki#what-is-causing-the-cuda-invalid-device-function-error)).

### Default Runtime

The default runtime used by the Docker Engine is [runc](https://github.com/opencontainers/runc), our runtime can become the default one by configuring the docker daemon with `--default-runtime=nvidia`. Doing so will remove the need to add the `--runtime=nvidia` argument to `docker run`. It is also the only way to have GPU access during `docker build`.

```bash
# Default OCI runtime for containers (default "runc")
# See details at
# https://docs.docker.com/engine/reference/commandline/dockerd/#docker-runtime-execution-options
# https://github.com/nvidia/nvidia-container-runtime#command-line
sudo dockerd --default-runtime nvidia
```

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

> If you build Docker images while `nvidia` is set as the default runtime, make sure the build scripts executed by the Dockerfile specify the GPU architectures that the container will need. Failure to do so may result in the container being optimized only for the GPU architecture on which it was built. Instructions for specifying the GPU architecture depend on the application and are beyond the scope of this document. Consult the specific application build process for guidance. [1]

### How do I link against driver APIs at build time (e.g. libcuda.so or libnvidia-ml.so)? <!-- omit in toc -->

Use the library stubs provided in `/usr/local/cuda/lib64/stubs/`. [Official images](https://hub.docker.com/r/nvidia/cuda/) already take care of setting [LIBRARY_PATH](https://gitlab.com/nvidia/container-images/cuda/blob/master/dist/ubuntu18.04/10.2/devel/Dockerfile#L15). However, do not set `LD_LIBRARY_PATH` to this folder, the stubs must not be used at runtime.

### Environment variables (OCI spec)

Each environment variable maps to an command-line argument for `nvidia-container-cli` from [libnvidia-container](https://github.com/NVIDIA/libnvidia-container).  
These variables are already set in our [official CUDA images](https://hub.docker.com/r/nvidia/cuda/).

#### `NVIDIA_VISIBLE_DEVICES`

This variable controls which GPUs will be made accessible inside the container.

##### Possible values

- `0,1,2`, `GPU-fef8089b` …: a comma-separated list of GPU UUID(s) or index(es).
- `all`: all GPUs will be accessible, this is the default value in our container images.
- `none`: no GPU will be accessible, but driver capabilities will be enabled.
- `void` or _empty_ or _unset_: `nvidia-container-runtime` will have the same behavior as `runc`.

#### `NVIDIA_DRIVER_CAPABILITIES`

This option controls which driver libraries/binaries will be mounted inside the container.

##### Possible values

- `compute,video`, `graphics,utility` …: a comma-separated list of driver features the container needs.
- `all`: enable all available driver capabilities.
- _empty_ or _unset_: use default driver capability: `utility`.

##### Supported driver capabilities

- `compute`: required for CUDA and OpenCL applications.
- `compat32`: required for running 32-bit applications.
- `graphics`: required for running OpenGL and Vulkan applications.
- `utility`: required for using `nvidia-smi` and NVML.
- `video`: required for using the Video Codec SDK.
- `display`: required for leveraging X11 display.

#### `NVIDIA_REQUIRE_*`

A logical expression to define constraints on the configurations supported by the container.

##### Supported constraints

- `cuda`: constraint on the CUDA driver version.
- `driver`: constraint on the driver version.
- `arch`: constraint on the compute architectures of the selected GPUs.
- `brand`: constraint on the brand of the selected GPUs (e.g. GeForce, Tesla, GRID).

##### Expressions

Multiple constraints can be expressed in a single environment variable: space-separated constraints are ORed, comma-separated constraints are ANDed.  
Multiple environment variables of the form `NVIDIA_REQUIRE_*` are ANDed together.

#### `NVIDIA_DISABLE_REQUIRE`

Single switch to disable all the constraints of the form `NVIDIA_REQUIRE_*`.

#### `NVIDIA_REQUIRE_CUDA`

The version of the CUDA toolkit used by the container. It is an instance of the generic `NVIDIA_REQUIRE_*` case and it is set by official CUDA images.
If the version of the NVIDIA driver is insufficient to run this version of CUDA, the container will not be started.

##### Possible values

- `cuda>=7.5`, `cuda>=8.0`, `cuda>=9.0` …: any valid CUDA version in the form `major.minor`.

#### `CUDA_VERSION`

Similar to `NVIDIA_REQUIRE_CUDA`, for legacy CUDA images.  
In addition, if `NVIDIA_REQUIRE_CUDA` is not set, `NVIDIA_VISIBLE_DEVICES` and `NVIDIA_DRIVER_CAPABILITIES` will default to `all`.

## References

[1] N. Corporation. (). Upgrading to the nvidia container runtime for docker, [Online]. Available: https://docs.nvidia.com/dgx/nvidia-container-runtime-upgrade/index.html#using- nv- container- runtime. (accessed: 05.18.2020).
