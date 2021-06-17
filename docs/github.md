# Connecting to GitHub with SSH

Using the SSH protocol, you can connect and authenticate to remote servers and services. With SSH keys, you can connect to GitHub without supplying your username or password at each visit.

## 1. Generating a new SSH key

### 1.1. Opening Terminal.

### 1.2. Pasting the text below, substituting in your GitHub email address.

```sh
ssh-keygen -t rsa -b 4096
```

This creates a new ssh key, using the provided email as a label.

```sh
> Generating public/private rsa key pair.
```

### 1.3. When you're prompted to "Enter a file in which to save the key," press Enter. This accepts the default file location.

```sh
> Enter a file in which to save the key (/home/you/.ssh/id_rsa): [Press enter]
```

### 1.4. At the prompt, type a secure passphrase. For more information, see "Working with SSH key passphrases".

```sh
> Enter passphrase (empty for no passphrase): [Type a passphrase]
> Enter same passphrase again: [Type passphrase again]
```

## 2. Adding a new SSH key to your GitHub account

Copy the SSH key to your clipboard.

```sh
sudo apt install xclip
xclip -sel clip < ~/.ssh/id_rsa.pub
```

Open [SSH and GPG keys](https://github.com/settings/keys), select `New SSH key` and complete any required steps.

## Automating SSH login with password

### 1. Generate a rsa keypair:

```sh
ssh-keygen
```

### 2. Copy it on the server with one simple command:

```sh
ssh-copy-id userid@hostname
```

### 3. You can now log in without password:

```sh
ssh userid@hostname
```
