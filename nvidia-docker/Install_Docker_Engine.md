# Install Docker Engine

### OS requirements

- Bionic 18.04 (LTS)

Older versions of Docker were called `docker`, `docker.io` or `docker-engine`. If these are installed, uninstall them:

```
$ sudo apt remove docker docker-engine docker.io
```

It’s OK if apt-get reports that none of these packages are installed.

### Set up Docker's repository

```
sudo apt update
sudo apt install \
    apt-transport-https \
    ca-certificates \
    curl \
    software-properties-common
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
```

Verify that you now have the key with the fingerprint `9DC8 5822 9FC7 DD38 854A E2D8 8D81 803C 0EBF CD88`

```
sudo apt-key fingerprint 0EBFCD88
```

Use the following command to set up the stable repository. You always need the stable repository, even if you want to install builds from the edge or test repositories as well. To add the edge or test repository, add the word edge or test (or both) after the word stable in the commands below.

```
sudo add-apt-repository \
   "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
   $(lsb_release -cs) \
   stable"
```


### Install Docker CE

```
sudo apt install docker-ce docker-ce-cli containerd.io
```

Verify that Docker CE is installed correctly by running the `hello-world` image.

```
sudo docker run hello-world
```


### Manage Docker as a non-root user

The Docker daemon binds to a Unix socket instead of a TCP port. By default that Unix socket is owned by the user root and other users can only access it using sudo. The Docker daemon always runs as the root user.

If you don’t want to preface the docker command with sudo, create a Unix group called docker and add users to it. When the Docker daemon starts, it creates a Unix socket accessible by members of the docker group.

```
sudo groupadd docker
sudo usermod -aG docker $USER
newgrp docker
```

Verify that you can run `docker` commands without sudo.

```
docker run hello-world
```

If you initially ran Docker CLI commands using `sudo` before adding your user to the `docker` group, you may see the following error, which indicates that your `~/.docker/` directory was created with incorrect permissions due to the `sudo` commands.

```
WARNING: Error loading config file: /home/user/.docker/config.json -
stat /home/user/.docker/config.json: permission denied
```

To fix this problem, either remove the `~/.docker/` directory (it is recreated automatically, but any custom settings are lost), or change its ownership and permissions using the following commands:

```
sudo chown "$USER":"$USER" /home/"$USER"/.docker -R
sudo chmod g+rwx "$HOME/.docker" -R
```

### Configure Docker to start on boot

```
sudo systemctl enable docker
sudo chkconfig docker on
```
