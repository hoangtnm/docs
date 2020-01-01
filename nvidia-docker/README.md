# NVIDIA Container Runtime for Docker

[![GitHub license](https://img.shields.io/badge/license-New%20BSD-blue.svg?style=flat-square)](https://raw.githubusercontent.com/NVIDIA/nvidia-docker/master/LICENSE)
[![Documentation](https://img.shields.io/badge/documentation-wiki-blue.svg?style=flat-square)](https://github.com/NVIDIA/nvidia-docker/wiki)
[![Package repository](https://img.shields.io/badge/packages-repository-b956e8.svg?style=flat-square)](https://nvidia.github.io/nvidia-docker)

NVIDIA-GPU-Docker          |NVIDIA-Docker architecture
:-------------------------:|:-------------------------:
![](https://cloud.githubusercontent.com/assets/3028125/12213714/5b208976-b632-11e5-8406-38d379ec46aa.png)  |  ![](https://devblogs.nvidia.com/wp-content/uploads/2018/05/dgx-docker-768x728.png)


The NVIDIA Container Runtime for Docker is an improved mechanism for allowing the Docker Engine to support NVIDIA GPUs used by GPU-accelerated containers. This new runtime replaces the Docker Engine Utility for NVIDIA GPUs. 


## 1. Documentation

The full documentation and frequently asked questions are available on the [repository wiki](https://github.com/NVIDIA/nvidia-docker/wiki).  

An introduction to the NVIDIA Container Runtime is also covered in our [blog post](https://devblogs.nvidia.com/gpu-containers-runtime/).


## 2. Quickstart

**Make sure you have installed the [NVIDIA driver](https://github.com/NVIDIA/nvidia-docker/wiki/Frequently-Asked-Questions#how-do-i-install-the-nvidia-driver) and a [supported version](https://github.com/NVIDIA/nvidia-docker/wiki/Frequently-Asked-Questions#which-docker-packages-are-supported) of [Docker](https://docs.docker.com/engine/installation/) for your distribution (see [prerequisites](https://github.com/NVIDIA/nvidia-docker/wiki/Installation-(version-2.0)#prerequisites)).**

**If you have a custom `/etc/docker/daemon.json`, the `nvidia-docker2` package might override it.**  

#### Ubuntu 18.04 LTS

```sh
# If you have nvidia-docker 1.0 installed: we need to remove it and all existing GPU containers
docker volume ls -q -f driver=nvidia-docker | xargs -r -I{} -n1 docker ps -q -a -f volume={} | xargs -r docker rm -f
sudo apt-get purge -y nvidia-docker

# Add the package repositories
curl -s -L https://nvidia.github.io/nvidia-docker/gpgkey | sudo apt-key add -
distribution=$(. /etc/os-release;echo $ID$VERSION_ID)
curl -s -L https://nvidia.github.io/nvidia-docker/$distribution/nvidia-docker.list | \
  sudo tee /etc/apt/sources.list.d/nvidia-docker.list
sudo apt update

# Install nvidia-docker2 and reload the Docker daemon configuration
sudo apt install -y nvidia-docker2
sudo pkill -SIGHUP dockerd

# Test nvidia-smi with the latest official CUDA image
docker run --runtime=nvidia --rm nvidia/cuda:9.0-base nvidia-smi
```

After updating to the NVIDIA Container Runtime for Docker, you can run GPU-accelerated containers in one of the following ways.

- Use `docker run` and specify `runtime=nvidia`
  
      docker run --runtime=nvidia ...

- Use `nvidia-docker run`

      nvidia-docker run ...


## 3. Default Runtime

The default runtime used by the Docker® Engine is [runc](https://github.com/opencontainers/runc), our runtime can become the default one by configuring the docker daemon with --default-runtime=nvidia. Doing so will remove the need to add the --runtime=nvidia argument to docker run. It is also the only way to have GPU access during docker build.

You can set `nvidia` as the default runtime, for example, by adding the following line to the `/etc/docker/daemon.json` configuration file as the first entry. 

```
"default-runtime": "nvidia",
```

The following is an example of how the added line appears in the JSON file. Do not remove any pre-existing content when making this change.

```
{
 "default-runtime": "nvidia",
  "runtimes": {
     "nvidia": {
         "path": "/usr/bin/nvidia-container-runtime",
         "runtimeArgs": []
     }
 },

}
```

You can then use `docker run` to run GPU-accelerated containers. 

```
docker run ...
```


## 4. Environment variables (OCI spec)

Each environment variable maps to an command-line argument for `nvidia-container-cli` from [libnvidia-container](https://github.com/NVIDIA/libnvidia-container).  
These variables are already set in our [official CUDA images](https://hub.docker.com/r/nvidia/cuda/).

### `NVIDIA_VISIBLE_DEVICES`
This variable controls which GPUs will be made accessible inside the container.  

#### Possible values
* `0,1,2`, `GPU-fef8089b` …: a comma-separated list of GPU UUID(s) or index(es).
* `all`: all GPUs will be accessible, this is the default value in our container images.
* `none`: no GPU will be accessible, but driver capabilities will be enabled.
* `void` or *empty* or *unset*: `nvidia-container-runtime` will have the same behavior as `runc`.

### `NVIDIA_DRIVER_CAPABILITIES`
This option controls which driver libraries/binaries will be mounted inside the container.

#### Possible values
* `compute,video`, `graphics,utility` …: a comma-separated list of driver features the container needs.
* `all`: enable all available driver capabilities.
* *empty* or *unset*: use default driver capability: `utility`.

#### Supported driver capabilities
* `compute`: required for CUDA and OpenCL applications.
* `compat32`: required for running 32-bit applications.
* `graphics`: required for running OpenGL and Vulkan applications.
* `utility`: required for using `nvidia-smi` and NVML.
* `video`: required for using the Video Codec SDK.
* `display`: required for leveraging X11 display.

### `NVIDIA_REQUIRE_*`
A logical expression to define constraints on the configurations supported by the container.  

#### Supported constraints
* `cuda`: constraint on the CUDA driver version.
* `driver`: constraint on the driver version.
* `arch`: constraint on the compute architectures of the selected GPUs.
* `brand`: constraint on the brand of the selected GPUs (e.g. GeForce, Tesla, GRID).

#### Expressions
Multiple constraints can be expressed in a single environment variable: space-separated constraints are ORed, comma-separated constraints are ANDed.  
Multiple environment variables of the form `NVIDIA_REQUIRE_*` are ANDed together.

### `NVIDIA_DISABLE_REQUIRE`
Single switch to disable all the constraints of the form `NVIDIA_REQUIRE_*`.

### `NVIDIA_REQUIRE_CUDA`

The version of the CUDA toolkit used by the container. It is an instance of the generic `NVIDIA_REQUIRE_*` case and it is set by official CUDA images.
If the version of the NVIDIA driver is insufficient to run this version of CUDA, the container will not be started.

#### Possible values
* `cuda>=7.5`, `cuda>=8.0`, `cuda>=9.0` …: any valid CUDA version in the form `major.minor`.

### `CUDA_VERSION`
Similar to `NVIDIA_REQUIRE_CUDA`, for legacy CUDA images.  
In addition, if `NVIDIA_REQUIRE_CUDA` is not set, `NVIDIA_VISIBLE_DEVICES` and `NVIDIA_DRIVER_CAPABILITIES` will default to `all`.
