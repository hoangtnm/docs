# Installing ZSH


### Zsh?

Oh-My-Zsh is a framework for Zsh, the Z shell.
- In order for Oh-My-Zsh to work, Zsh must be installed.
  * Please run zsh `--version` to confirm.
  * Expected result: `zsh 5.1.1` or more recent
- Additionally, Zsh should be set as your default shell


## Install and set up zsh as default

```
sudo apt-get install zsh
chsh -s $(which zsh)
```

## How to install zsh in many platforms


### macOS

Try `zsh --version` before installing it from Homebrew. If it's newer than 4.3.9 you might be OK. Preferably newer than or equal to `5.0`.

```
brew install zsh zsh-completions
```

### Ubuntu, Debian & derivatives

```
sudo apt install zsh
```
