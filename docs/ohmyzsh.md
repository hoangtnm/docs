# Configuring Oh My Zsh Framework <!-- omit in toc -->

## Contents <!-- omit in toc -->

- [Installation](#installation)
- [Using Oh My Zsh](#using-oh-my-zsh)
  - [Plugins](#plugins)
  - [Enabling Plugins](#enabling-plugins)
  - [Using Plugins](#using-plugins)
  - [Themes](#themes)
- [Advanced Topics](#advanced-topics)
  - [Installation Problems](#installation-problems)
  - [Custom Plugins and Themes](#custom-plugins-and-themes)

Oh My Zsh is a delightful, open source, community-driven framework for managing your Zsh configuration. It comes bundled with thousands of helpful functions, helpers, plugins, themes, and a few things that make you shout...

Once installed, your terminal shell will become the talk of the town or your money back! With each keystroke in your command prompt, you'll take advantage of the hundreds of powerful plugins and beautiful themes.

<p align="center">
  <img src="https://s3.amazonaws.com/ohmyzsh/oh-my-zsh-logo.png">
</p>

> While Oh My Zsh supports a wide range of OS such as macOS, Linux and BSD, this document only supports Ubuntu. In case you want to install it on another OS, you can refer https://github.com/ohmyzsh/ohmyzsh for more information.

## Installation

```bash
sudo apt install curl git zsh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"

# Configure it as default shell
chsh -s $(which zsh)
```

## Using Oh My Zsh

### Plugins

Oh My Zsh comes with a shitload of plugins to take advantage of. You can take a look in the [plugins](https://github.com/robbyrussell/oh-my-zsh/tree/master/plugins) directory and/or the [wiki](https://github.com/robbyrussell/oh-my-zsh/wiki/Plugins) to see what's currently available.

### Enabling Plugins

Once you spot a plugin (or several) that you'd like to use with Oh My Zsh, you'll need to enable them in the `.zshrc` file. You'll find the zshrc file in your `$HOME` directory. Open it with your favorite text editor and you'll see a spot to list all the plugins you want to load.

```bash
vim ~/.zshrc
```

For example, this might begin to look like this:

```
plugins=(
  docker
  bundler
  git
  python
)
```

### Using Plugins

Most plugins (should! we're working on this) include a **README**, which documents how to use them.

> Note that the plugins are separated by whitespace. Do not use commas between them.

### Themes

Once you find a theme that you'd like to use, you will need to edit the `~/.zshrc` file. You'll see an environment variable (all caps) in there that looks like:

```
ZSH_THEME="robbyrussell"
```

To use a different theme, simply change the value to match the name of your desired theme. For example:

```
ZSH_THEME="agnoster"
```

**Note**: many themes require installing the [Powerline Fonts](https://github.com/powerline/fonts) in order to render properly.

```bash
sudo apt install fonts-powerline
```

Open up a new terminal window and your prompt should look something like this:

![Agnoster theme](https://cloud.githubusercontent.com/assets/2618447/6316862/70f58fb6-ba03-11e4-82c9-c083bf9a6574.png)

In case you did not find a suitable theme for your needs, please have a look at the wiki for [more of them](https://github.com/robbyrussell/oh-my-zsh/wiki/External-themes).

To use the `agnoster` theme in Microsoft Visual Studio Code, we need to install [Fira Code](https://github.com/tonsky/FiraCode) font:

```bash
sudo apt install fonts-firacode
```

Configures the font in VS Code:

```json
"editor.fontFamily": "Fira Code",
"editor.fontLigatures": true,
"editor.fontSize": 15,
"debug.console.fontSize": 15,
"terminal.integrated.fontSize": 15
```

## Advanced Topics

### Installation Problems

If you have any hiccups installing, here are a few common fixes.

- You _might_ need to modify your `PATH` in `~/.zshrc` if you're not able to find some commands after switching to `oh-my-zsh`.
- If you installed manually or changed the install location, check the `ZSH` environment variable in `~/.zshrc`.

### Custom Plugins and Themes

If you want to override any of the default behaviors, just add a new file (ending in `.zsh`) in the `custom/` directory.

If you have many functions that go well together, you can put them as a `XYZ.plugin.zsh` file in the `custom/plugins/` directory and then enable this plugin.

If you would like to override the functionality of a plugin distributed with Oh My Zsh, create a plugin of the same name in the `custom/plugins/` directory and it will be loaded instead of the one in `plugins/`.
