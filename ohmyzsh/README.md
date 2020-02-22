Oh My Zsh is an open source, community-driven framework for managing your [zsh](https://www.zsh.org/) configuration.

<p align="center">
  <img src="https://s3.amazonaws.com/ohmyzsh/oh-my-zsh-logo.png" alt="Oh My Zsh">
</p>

## How to install zsh in many platforms

### macOS

```
brew install zsh zsh-completions
```

### Ubuntu

```
sudo apt install zsh
```

### Set up zsh as default (Optional)

```
chsh -s $(which zsh)
```


### Basic Installation

Oh My Zsh is installed by running one of the following commands in your terminal. You can install this via the command-line with either `curl` or `wget`.

#### via curl

```sh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
```

#### via wget

```sh
sh -c "$(wget https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh -O -)"
```

## Using Oh My Zsh

### Plugins

Oh My Zsh comes with a shitload of plugins to take advantage of. You can take a look in the [plugins](https://github.com/robbyrussell/oh-my-zsh/tree/master/plugins) directory and/or the [wiki](https://github.com/robbyrussell/oh-my-zsh/wiki/Plugins) to see what's currently available.

### Enabling Plugins

Once you spot a plugin (or several) that you'd like to use with Oh My Zsh, you'll need to enable them in the `.zshrc` file. You'll find the zshrc file in your `$HOME` directory. Open it with your favorite text editor and you'll see a spot to list all the plugins you want to load.

```sh
vim ~/.zshrc
```

For example, this might begin to look like this:

```sh
plugins=(
  docker
  bundler
  git
  python
)
```

### Using Plugins

Most plugins (should! we're working on this) include a __README__, which documents how to use them.

### Themes

Once you find a theme that you'd like to use, you will need to edit the `~/.zshrc` file. You'll see an environment variable (all caps) in there that looks like:

```sh
ZSH_THEME="robbyrussell"
```

To use a different theme, simply change the value to match the name of your desired theme. For example:

```sh
ZSH_THEME="agnoster"
```

**Note**: many themes require installing the [Powerline Fonts](https://github.com/powerline/fonts) in order to render properly.

```sh
sudo apt install fonts-powerline
```

Open up a new terminal window and your prompt should look something like this:

![Agnoster theme](https://cloud.githubusercontent.com/assets/2618447/6316862/70f58fb6-ba03-11e4-82c9-c083bf9a6574.png)

In case you did not find a suitable theme for your needs, please have a look at the wiki for [more of them](https://github.com/robbyrussell/oh-my-zsh/wiki/External-themes).

To use the `agnoster` theme in Microsoft Visual Studio Code, we need to install [Fira Code](https://github.com/tonsky/FiraCode) font:

```sh
sudo apt install fonts-firacode
```

Setting the font in VS Code:

```
"editor.fontFamily": "Fira Code",
"editor.fontLigatures": true,
"editor.fontSize": 15,
"debug.console.fontSize": 15,
"terminal.integrated.fontSize": 15
```

## Advanced Topics

### Installation Problems

If you have any hiccups installing, here are a few common fixes.

* You _might_ need to modify your `PATH` in `~/.zshrc` if you're not able to find some commands after switching to `oh-my-zsh`.
* If you installed manually or changed the install location, check the `ZSH` environment variable in `~/.zshrc`.

### Custom Plugins and Themes

If you want to override any of the default behaviors, just add a new file (ending in `.zsh`) in the `custom/` directory.

If you have many functions that go well together, you can put them as a `XYZ.plugin.zsh` file in the `custom/plugins/` directory and then enable this plugin.

If you would like to override the functionality of a plugin distributed with Oh My Zsh, create a plugin of the same name in the `custom/plugins/` directory and it will be loaded instead of the one in `plugins/`.

## Uninstalling Oh My Zsh

Oh My Zsh isn't for everyone. We'll miss you, but we want to make this an easy breakup.

If you want to uninstall `oh-my-zsh`, just run `uninstall_oh_my_zsh` from the command-line. It will remove itself and revert your previous `bash` or `zsh` configuration.
