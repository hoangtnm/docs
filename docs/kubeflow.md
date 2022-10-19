# Kubeflow Manifests v1.6 Installation Guide <!-- omit in toc -->

> This method is for advanced users. The Kubeflow community will not support environment-specific issues. If you need support, please consider using a [packaged distribution](https://www.kubeflow.org/docs/started/installing-kubeflow/#packaged-distributions) of Kubeflow.

## Contents <!-- omit in toc -->

- [Overview](#overview)
- [Prerequisites](#prerequisites)
  - [NVIDIA Driver](#nvidia-driver)
  - [NVIDIA Container Runtime and Docker Engine](#nvidia-container-runtime-and-docker-engine)
    - [NVIDIA Container Runtime (Optional)](#nvidia-container-runtime-optional)
    - [Docker Engine](#docker-engine)
  - [Kustomize v3.2.0](#kustomize-v320)
- [Installing Kubernetes Using Kubeadm](#installing-kubernetes-using-kubeadm)
- [Installing Kubeflow Manifests](#installing-kubeflow-manifests)
  - [Install the `kubeadm` toolbox](#install-the-kubeadm-toolbox)
  - [Installing Calico networking and network policy](#installing-calico-networking-and-network-policy)
  - [Deploy Rook with Ceph as a Storage Backend using CSI](#deploy-rook-with-ceph-as-a-storage-backend-using-csi)
  - [Installing Kubeflow Manifests](#installing-kubeflow-manifests-1)
  - [Kubeflow Dashboard](#kubeflow-dashboard)
  - [On each of Kube node server](#on-each-of-kube-node-server)
- [NVIDIA GPU Operator for On-prem Cluster](#nvidia-gpu-operator-for-on-prem-cluster)
- [References](#references)

## Overview

## Prerequisites

- Ubuntu 20.04 LTS
- Check network adapters and [required ports](https://kubernetes.io/docs/reference/ports-and-protocols/)
- Disable swap on the nodes so that kubelet can work correctly
- Install a supported container runtime such as Docker, containerd or CRI-O

```bash
sudo apt update && sudo apt install -y \
    git \
    vim \
    htop \
    resolvconf \
    screen \
    zsh
wget https://github.com/robbyrussell/oh-my-zsh/raw/master/tools/install.sh -O - | zsh || true
chsh -s $(which zsh)

tee -a ~/.zshrc <<EOF
export LC_ALL=C.UTF-8
export LANG=C.UTF-8
EOF

sudo tee -a /etc/resolvconf/resolv.conf.d/head <<EOF
nameserver 8.8.8.8
nameserver 8.8.4.4
EOF
sudo resolvconf -u
```

### NVIDIA Driver

```bash
sudo apt-get update && sudo apt-get install -y nvidia-driver-515-server
sudo reboot
```

### NVIDIA Container Runtime and Docker Engine

#### NVIDIA Container Runtime (Optional)

By default, `NVIDIA GPU Operator` deploys the NVIDIA Container Toolkit (`nvidia-docker2` stack) as a container on the system.
In the following sections, the container runtime will be deloyed as a daemonset by the Operator, so this is **optional.**

```bash
distribution=$(. /etc/os-release;echo $ID$VERSION_ID) \
  && curl -fsSL https://nvidia.github.io/libnvidia-container/gpgkey | sudo gpg --dearmor -o /usr/share/keyrings/nvidia-container-toolkit-keyring.gpg \
  && curl -s -L https://nvidia.github.io/libnvidia-container/$distribution/libnvidia-container.list | \
    sed 's#deb https://#deb [signed-by=/usr/share/keyrings/nvidia-container-toolkit-keyring.gpg] https://#g' | \
    sudo tee /etc/apt/sources.list.d/nvidia-container-toolkit.list
sudo apt-get update && sudo apt-get install nvidia-container-runtime

sudo sed -i \
  -e "s/^#\(accept-nvidia-visible-devices-envvar-when-unprivileged\).*/\1 = false/" \
  -e "s/^#\(accept-nvidia-visible-devices-as-volume-mounts\).*/\1 = true/" \
  /etc/nvidia-container-runtime/config.toml
```

#### Docker Engine

##### Option 1 (recommended): Install Docker Engine with root privileges <!-- omit in toc -->

```bash
sudo apt-get remove docker docker-engine docker.io containerd runc
curl https://get.docker.com | sh \
  && sudo systemctl --now enable docker
sudo usermod -aG docker $USER
newgrp docker

sudo tee /etc/docker/daemon.json << EOF
{
  "exec-opts": ["native.cgroupdriver=systemd"],
  "log-driver": "json-file",
  "log-opts": {
    "max-size": "100m"
  },
  "storage-driver": "overlay2"
}
EOF
sudo systemctl restart docker
```

##### Option 2 (not tested): Run the Docker daemon as Rootless mode <!-- omit in toc -->

```bash
sudo apt-get remove docker docker-engine docker.io containerd runc
sudo apt-get install -y dbus-user-session uidmap
curl -fsSL https://get.docker.com/rootless | sh

systemctl --user enable docker
sudo loginctl enable-linger $(whoami)

tee ~/.config/docker/daemon.json << EOF
{
  "exec-opts": ["native.cgroupdriver=systemd"],
  "log-driver": "json-file",
  "log-opts": {
    "max-size": "100m"
  },
  "storage-driver": "overlay2"
}
EOF
systemctl --user restart docker
sudo sed -i 's/^#no-cgroups = false/no-cgroups = true/;' /etc/nvidia-container-runtime/config.toml
```

<!-- ### Microk8s

```bash
sudo snap install microk8s --classic --channel=1.22/stable
sudo snap alias microk8s.kubectl kubectl
sudo snap alias microk8s.kubectl k
sudo snap alias microk8s.helm3 helm3
sudo snap alias microk8s.helm3 helm

sudo usermod -aG microk8s $USER
newgrp microk8s
mkdir ~/.kube
microk8s config > ~/.kube/config
sudo chown -f -R $USER ~/.kube

microk8s enable dns storage ingress metallb:10.64.140.43-10.64.140.49
```
-->

### Kustomize v3.2.0

```bash
mkdir ~/bin
wget -O ~/bin/kustomize https://github.com/kubernetes-sigs/kustomize/releases/download/v3.2.0/kustomize_3.2.0_linux_amd64
chmod +x ~/bin/kustomize
shell=$(ps -o comm= $$)
tee -a ~/."${shell}rc" << EOF
export PATH=~/bin:\${PATH:+:\${PATH}}
EOF
source ~/."${shell}rc"
```

<!-- ## Installing Charmed Kubeflow v1.6

```bash
for snap in juju juju-wait juju-kubectl juju-bundle; do
    sudo snap install $snap --classic;
done
juju bootstrap microk8s
juju add-model kubeflow

# Track the progress by running: `watch -c juju status --color`
juju deploy kubeflow --trust --channel 1.6/stable

juju config dex-auth public-url=http://10.64.140.43.nip.io
juju config oidc-gatekeeper public-url=http://10.64.140.43.nip.io
juju config dex-auth static-username=admin
juju config dex-auth static-password=admin
```

## Uninstalling Kubeflow

```bash
juju destroy-model kubeflow --yes --destroy-storage --force
juju destroy-controller microk8s-localhost
juju destroy-controller my-controller
```
-->

## Installing Kubernetes Using Kubeadm

See details at [Installing Kubernetes Using Kubeadm](https://docs.nvidia.com/datacenter/cloud-native/kubernetes/install-k8s.html#option-2-installing-kubernetes-using-kubeadm) by NVIDIA.
A Kubernetes cluster is composed of `master` nodes and `worker` nodes. The `master` nodes run the `control plane components` of Kubernetes which allows your cluster to function properly. These components include the API Server (front-end to the `kubectl` CLI), `etcd` (stores the cluster state) and others.

With `kubeadm`, this document will walk through the steps for installing a **single node Kubernetes cluster** (where we untaint the control plane so it can run GPU pods), but the cluster can be scaled easily with additional nodes.

## Installing Kubeflow Manifests

```bash
HOST="$(hostname -f)"
HOST_IP=$(ip a | grep -o "192.168.[0-9]\{1,3\}\.[0-9]\{1,3\}" | head -n 1)
sudo tee -a /etc/hosts << EOF
${HOST_IP} control-k8s ${HOST}
EOF
```

### Install the `kubeadm` toolbox

```bash
curl -fsSL https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo gpg --dearmor -o /etc/apt/keyrings/kubernetes.gpg
echo "deb [signed-by=/etc/apt/keyrings/kubernetes.gpg] https://apt.kubernetes.io/ kubernetes-xenial main" | sudo tee /etc/apt/sources.list.d/kubernetes.list

export K8S_VERSION=1.22.15-00
sudo apt-get update && sudo apt-get install -y \
  kubelet=${K8S_VERSION} \
  kubeadm=${K8S_VERSION} \
  kubectl=${K8S_VERSION}
sudo apt-mark hold kubelet kubeadm kubectl
# source <(kubectl completion zsh)
# echo '[[ $commands[kubectl] ]] && source <(kubectl completion zsh)' >> ~/.zshrc

# Disable swap in order for the kubelet to work properly
sudo sed -i "s/^\(\/swap\)/# \1/" /etc/fstab
sudo swapoff -a

# Enable kernel modules, enabled by default
# sudo modprobe overlay
# sudo modprobe br_netfilter

# Allow proper network settings for K8s on all the servers
sudo tee /etc/sysctl.d/kubernetes.conf << EOF
net.bridge.bridge-nf-call-ip6tables = 1
net.bridge.bridge-nf-call-iptables = 1
net.ipv4.ip_forward = 1
EOF
sudo sysctl --system

# Check required ports
# https://kubernetes.io/docs/reference/ports-and-protocols
# nc 127.0.0.1 6443
```

### Installing Calico networking and network policy

Add-ons extend the functionality of Kubernetes. This [page](https://kubernetes.io/docs/concepts/cluster-administration/addons/) lists some of the available add-ons and links to their respective installation instructions:

- `Calico` is a networking and network policy provider. Calico supports a flexible set of networking options so you can choose the most efficient option for your situation, including `non-overlay` and `overlay` networks, with or without BGP. Calico uses the same engine to enforce network policy for hosts, pods, and (if using Istio & Envoy) applications at the service mesh layer.

```bash
# On the K8s master
HOST_IP=$(ip a | grep -o "192.168.[0-9]\{1,3\}\.[0-9]\{1,3\}" | head -n 1)
# Bootstrap a Kubernetes control-plane node
# For Calico network
kubeadm config images pull
sudo kubeadm init \
  --apiserver-advertise-address=${HOST_IP} \
  --upload-certs \
  --pod-network-cidr=192.168.0.0/16 \
  --control-plane-endpoint=control-k8s

mkdir -p $HOME/.kube
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config

kubectl create -f https://raw.githubusercontent.com/projectcalico/calico/v3.24.2/manifests/tigera-operator.yaml
kubectl create -f https://raw.githubusercontent.com/projectcalico/calico/v3.24.2/manifests/custom-resources.yaml
# Confirm that all of the pods are running
watch -c kubectl get pods -n calico-system
# Confirm that you now have a node in your cluster
kubectl get nodes -o wide
```

### Deploy Rook with Ceph as a Storage Backend using CSI

For a Test Deployment - A single node cluster or a single master and single worker cluster, each node in the cluster requires a mounted `unformatted volume`, and `LVM must be installed`, allow workloads on Masters: Enabled, CNI: Calico.
One of the following storage options must be available on the cluster nodes:

- Raw devices (no partitions or formatted filesystems)
- Raw partitions (no formatted filesystem)

This can be accomplished with:

```bash
# lsblk -f
# sudo fdisk /dev/sda
# d
# write
#
sudo wipefs -a /dev/sda
sudo partprobe
```

By default, your cluster will not schedule pods on the control-plane node for security reasons. To install Kubeflow we need to change this

```bash
kubectl taint nodes --all node-role.kubernetes.io/master-
# for node in $(kubectl get nodes --selector='node-role.kubernetes.io/master' | awk 'NR>1 {print $1}'); do
#   kubectl taint node $node node-role.kubernetes.io/master-;
# done
```

```bash
sudo apt-get update && sudo apt-get install -y lvm2
git clone -b v1.5.12 --depth 1 https://github.com/rook/rook.git \
  && cd rook/cluster/examples/kubernetes/ceph \
  && kubectl create -f crds.yaml -f common.yaml -f operator.yaml \
  && kubectl create -f cluster-test.yaml \
  && kubectl apply -f csi/rbd/storageclass-test.yaml \
  && popd
# git clone -b v1.10.3 --depth 1 https://github.com/rook/rook.git \
#   && cd rook/deploy/examples \
#   && kubectl create -f crds.yaml -f common.yaml -f operator.yaml \
#   && kubectl create -f cluster-test.yaml \
#   && kubectl apply -f csi/rbd/storageclass-test.yaml \
#   && popd

# watch -c kubectl get pods -n rook-ceph
# Deploy Rook with Ceph as default StorageClass
kubectl patch sc rook-ceph-block -p '{"metadata": {"annotations":{"storageclass.kubernetes.io/is-default-class":"true"}}}'
# Verify the chosen StorageClass is default
# kubectl get storageclass
```

### Installing Kubeflow Manifests

```bash
git clone -b v1.6.1 --depth 1 https://github.com/kubeflow/manifests.git
cd manifests
while ! kustomize build example | kubectl apply -f -; do
  echo "Retrying to apply resources";
  sleep 10;
done

kubectl get pods -n cert-manager
kubectl get pods -n istio-system
kubectl get pods -n auth
kubectl get pods -n knative-eventing
kubectl get pods -n knative-serving
kubectl get pods -n kubeflow
kubectl get pods -n kubeflow-user-example-com
```

### Kubeflow Dashboard

```bash
kubectl get services -n istio-system | grep gateway
# http://${HOST_IP}:30266
kubectl port-forward svc/istio-ingressgateway -n istio-system 8080:80
```

### On each of Kube node server

```bash
kubeadm token create --print-join-command
```

## NVIDIA GPU Operator for On-prem Cluster

| Item                          | Reference                                                                                                        |
| ----------------------------- | ---------------------------------------------------------------------------------------------------------------- |
| GPU Operator                  | https://github.com/NVIDIA/gpu-operator/releases                                                                  |
| GPU Operator Component Matrix | https://docs.nvidia.com/datacenter/cloud-native/gpu-operator/platform-support.html#gpu-operator-component-matrix |
| NVIDIA Container Toolkit      | https://catalog.ngc.nvidia.com/orgs/nvidia/teams/k8s/containers/container-toolkit/tags                           |

This addon enables NVIDIA GPU support on MicroK8s using the `NVIDIA GPU Operator`.
The GPU addon will install and configure the following components on the MicroK8s cluster:

- `nvidia-feature-discovery`: runs feature discovery on all cluster nodes.
- `nvidia-driver-daemonset`: builds and loads the NVIDIA drivers into the running kernel.
- `nvidia-container-toolkit-daemonset`: installs the `nvidia-container-runtime` binaries and configures the `nvidia` runtime on containerd accordingly.
- `nvidia-device-plugin-daemonset`: configures the `nvidia.com/gpu` kubelet device plugin. This is used to configure `resource capacity` and `limits` for the GPU nodes.
- `nvidia-operator-validator`: validates that the NVIDIA drivers, container runtime and the kubelet device plugin have been configured correctly.

```bash
sudo snap install helm --classic
helm repo add nvidia https://nvidia.github.io/gpu-operator \
  && helm repo update \
  && helm install \
  --version=v22.9.0 \
  --generate-name \
  --create-namespace \
  --namespace=gpu-operator-resources \
  nvidia/gpu-operator \
  --set driver.enabled=false \
  --set devicePlugin.env[0].name=DEVICE_LIST_STRATEGY \
  --set devicePlugin.env[0].value="volume-mounts" \
  --set toolkit.env[0].name=ACCEPT_NVIDIA_VISIBLE_DEVICES_ENVVAR_WHEN_UNPRIVILEGED \
  --set toolkit.env[0].value=false
# helm search repo nvidia -l
```

Verify that all components are deployed and configured correctly with:

```bash
kubectl get pod -n gpu-operator-resources
kubectl logs -n gpu-operator-resources -lapp=nvidia-operator-validator -c nvidia-operator-validator
```

To uninstall the operator:

```bash
helm delete -n gpu-operator-resources $(helm list -n gpu-operator-resources | grep gpu-operator-resources | awk '{print $1}')
```

## References

- [Setting up a Local MLOps dev environment](https://medium.com/mlearning-ai/setting-up-a-local-mlops-dev-environment-part-1-a8b468329819)
- [Enabling NVIDIA GPU Operator on MicroK8s](https://github.com/canonical/microk8s/blob/1.22/microk8s-resources/actions/enable.gpu.sh)
- [Requesting zero GPUs allocates all GPUs](https://github.com/NVIDIA/k8s-device-plugin/issues/61#issuecomment-977268909)
- [nvidia/gpu-operator exposes all GPUs in Kubefllow](https://github.com/NVIDIA/gpu-operator/issues/421)
- [With volume-mounts strategy, pod shouldn't fail when no permission to read NVIDIA_VISIBLE_DEVICES](https://github.com/NVIDIA/k8s-device-plugin/issues/203#issuecomment-723070789)
- [How to Deploy Rook with Ceph as a Storage Backend for your Kubernetes Cluster using CSI](https://platform9.com/learn/v1.0/tutorials/rook-using-ceph-csi)
