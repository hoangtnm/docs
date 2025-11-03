# Set Up Vim for Programming <!-- omit in toc -->

## Contents <!-- omit in toc -->

- [Overview](#overview)
  - [Vim Language](#vim-language)
    - [Verbs in Vim](#verbs-in-vim)
    - [Nouns in Vim](#nouns-in-vim)
  - [Keyboard Shortcuts](#keyboard-shortcuts)
- [Installation](#installation)
  - [Vim Editor](#vim-editor)
  - [Basic Vim Configurations](#basic-vim-configurations)
  - [Vundle Plugin Manager](#vundle-plugin-manager)
- [Key Mappings](#key-mappings)
- [References](#references)

## Overview

Vim is a highly configurable text editor built to make creating and changing any kind of text very efficient.
This document will describe how to set up Vim as a powerful environment for programming such as Python.

### Vim Language

Syntax of the language: `Verb + Noun`

`d` for delete, `w` for word
--> combine to `delete word`

#### Verbs in Vim

`Verb` is the operation you want to take on the text.

- `d` => Delete
- `c` => Change (delete and enter insert mode)
- `>` => Indent
- `v` => Visually select
- `y` => Yank (copy)

#### Nouns in Vim

Text objects:

- `iw` => inner word (works from anywhere in a word)
- `it` => inner tag (the contents of an HTML tag)
- i" => inner quotes
- ip => inner paragraph
- as => a sentence

Parameterized text objects

- `f`, `F` => "find" the next character (including the character)
- `t`, `T` => "find" the next character (not including the character)
- `/` => search (up to the next match)

### Keyboard Shortcuts

| Shortcut          | Description                                                  |
| ----------------- | ------------------------------------------------------------ |
| `u`               | undo the last operation                                      |
| `U`               | redo the last undo                                           |
| `Ctrl + r`        | redo changes which were undone                               |
| `h`               | move the cursor one character to the left                    |
| `j` or `Ctrl + J` | move the cursor down one line                                |
| `k` or `Ctrl + P` | move the cursor down one line                                |
| `l`               | move the cursor one character to the right                   |
| `0`               | move the cursor to the begining of the line                  |
| `^`               | move the cursor to the first non-empty character of the line |
| `$`               | move the cursor to the end of the line                       |
| `g`               | move to the begining of the file                             |
| `G`               | move to the end of the file                                  |
| -                 | -                                                            |
| `i`               | insert text before the cursor                                |
| `o`               | begin a new line below the cursor                            |
| `O`               | begin a new line above the cursor                            |

## Installation

### Vim Editor

```bash
sudo apt-get update && sudo apt-get install -y \
    git vim fonts-powerline
```

### Basic Vim Configurations

```bash
cat <<EOF > ~/.vimrc
au BufNewFile,BufRead *.py,*.*rc
    \ set tabstop=4 |
    \ set softtabstop=4 |
    \ set shiftwidth=4 |
    \ set textwidth=120 |
    \ set expandtab |
    \ set autoindent |
    \ set fileformat=unix

au BufNewFile,BufRead *.js,*.html,*.css
    \ set tabstop=2 |
    \ set softtabstop=2 |
    \ set shiftwidth=2
EOF
```

### Vundle Plugin Manager

[Vundle](https://github.com/VundleVim/Vundle.vim) is short for _Vim_ bundle
and is a [Vim](http://www.vim.org/) plugin manager. Vundle enables users to:

- keep track of and [configure](https://github.com/VundleVim/Vundle.vim/blob/v0.10.2/doc/vundle.txt#L126-L233) your plugins right in the `.vimrc`
- [install](https://github.com/VundleVim/Vundle.vim/blob/v0.10.2/doc/vundle.txt#L234-L254) configured plugins (a.k.a. scripts/bundle)
- [update](https://github.com/VundleVim/Vundle.vim/blob/v0.10.2/doc/vundle.txt#L255-L265) configured plugins
- [search](https://github.com/VundleVim/Vundle.vim/blob/v0.10.2/doc/vundle.txt#L266-L295) by name all available [Vim scripts](http://vim-scripts.org/vim/scripts.html)
- [clean](https://github.com/VundleVim/Vundle.vim/blob/v0.10.2/doc/vundle.txt#L303-L318) unused plugins up
- run the above actions in a _single keypress_ with [interactive mode](https://github.com/VundleVim/Vundle.vim/blob/v0.10.2/doc/vundle.txt#L319-L360)

```bash
git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim

cat <<EOF > ~/.vimrc
set nocompatible                        " required
filetype off                            " required

" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()

" let Vundle manage Vundle, required
Plugin 'gmarik/Vundle.vim'

" add all your plugins here
Plugin 'jtratner/vim-flavored-markdown'
Plugin 'suan/vim-instant-markdown'
Plugin 'nelstrom/vim-markdown-preview'
Plugin 'tmhedberg/SimpylFold'
Plugin 'vim-scripts/indentpython.vim'
Plugin 'python-mode/python-mode'
Plugin 'vim-syntastic/syntastic'
Plugin 'nvie/vim-flake8'
Plugin 'psf/black', {'branch': 'stable'}
Plugin 'scrooloose/nerdtree'
Plugin 'ctrlpvim/ctrlp.vim'
Plugin 'tpope/vim-fugitive'
Plugin 'altercation/vim-colors-solarized'
Plugin 'powerline/powerline'
Plugin 'codota/tabnine-vim'

" All of your Plugins must be added before the following line
call vundle#end()                       " required
filetype plugin indent on               " required

syntax enable                           " Syntax highlighting
let python_highlight_all=1
let NERDTreeIgnore=['\.pyc$', '\~$']    " Ignore files in NERDTree
set number                              " Line numbering
set cursorline
set showmatch               " Highlight matching brackets (), [], and {}
set encoding=utf-8          " UTF-8 Support
set clipboard=unnamed       " Use the clipboard register '*'

" Key mappings
nnoremap <C-J> <C-W><C-J>   " move to the split below
nnoremap <C-K> <C-W><C-K>   " move to the split above
nnoremap <C-L> <C-W><C-L>   " move to the split to the right
nnoremap <C-H> <C-W><C-H>   " move to the split to the left
nnoremap <A-L> :Black<CR>   " Format the entire file with Black formarter

" See details at
" https://github.com/preservim/nerdtree
nnoremap <leader>n :NERDTreeFocus<CR>
nnoremap <C-N> :NERDTree<CR>
nnoremap <C-T> :NERDTreeToggle<CR>
nnoremap <C-F> :NERDTreeFind<CR>

" Enable folding
set foldmethod=indent
set foldlevel=99
nnoremap <space> za         " Enable folding with the spacebar

au BufNewFile,BufRead *.py
    \ set tabstop=4         |
    \ set softtabstop=4     |
    \ set shiftwidth=4      |
    \ set textwidth=79      |
    \ set expandtab         |
    \ set autoindent        |
    \ set fileformat=unix

au BufNewFile,BufRead *.js, *.html, *.css
    \ set tabstop=2         |
    \ set softtabstop=2     |
    \ set shiftwidth=2

" Mark extra (unnecessary) whitespace as bad and probably color it red.
au BufRead,BufNewFile *.py,*.pyw,*.c,*.h match BadWhitespace /\s\+$/
EOF

# Install plugins from CLI
vim +PluginInstall +qall
```

## Key Mappings

## References

[1] Real Python, “VIM and Python – A Match Made in Heaven.” https://realpython.com/vim-and-python-a-match-made-in-heaven/ (accessed Jan. 10, 2021).

[2] Rossi B. Jonas, “Understand Vim Mappings and Create Your Own Shortcuts!” https://medium.com/vim-drops/understand-vim-mappings-and-create-your-own-shortcuts-f52ee4a6b8ed (accessed Jan. 10, 2021).

[3] C. Crowder, “VIM Keyboard Shortcuts Cheatsheet,” 2020. https://www.maketecheasier.com/cheatsheet/vim-keyboard-shortcuts/ (accessed Jan. 23, 2021).
