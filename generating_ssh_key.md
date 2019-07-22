# Generating a new SSH key and adding it to the ssh-agent

After you've checked for existing SSH keys, you can generate a new SSH key to use for authentication, then add it to the ssh-agent.

If you don't already have an SSH key, you must [generate a new SSH key](https://help.github.com/en/articles/generating-a-new-ssh-key-and-adding-it-to-the-ssh-agent#generating-a-new-ssh-key). If you're unsure whether you already have an SSH key, check for [existing keys](https://help.github.com/en/articles/checking-for-existing-ssh-keys).

If you don't want to reenter your passphrase every time you use your SSH key, you can [add your key to the SSH agent](https://help.github.com/en/articles/generating-a-new-ssh-key-and-adding-it-to-the-ssh-agent#adding-your-ssh-key-to-the-ssh-agent), which manages your SSH keys and remembers your passphrase.

## Generating a new SSH key

### 1. Open Terminal.

### 2. Paste the text below, substituting in your GitHub email address.

```sh
ssh-keygen -t rsa -b 4096 -C "your_email@example.com"
```

This creates a new ssh key, using the provided email as a label.

```sh
> Generating public/private rsa key pair.
```

### 3. When you're prompted to "Enter a file in which to save the key," press Enter. This accepts the default file location.

```sh
> Enter a file in which to save the key (/home/you/.ssh/id_rsa): [Press enter]
```

### 4. At the prompt, type a secure passphrase. For more information, see "Working with SSH key passphrases".

```sh
> Enter passphrase (empty for no passphrase): [Type a passphrase]
> Enter same passphrase again: [Type passphrase again]
```

## Automate SSH login with password

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

