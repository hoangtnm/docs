# Set Up Vim for Programming <!-- omit in toc -->

## Contents <!-- omit in toc -->

- [Overview](#overview)
- [Installation](#installation)
- [Vundle Plugin Manager](#vundle-plugin-manager)
- [Key Mappings](#key-mappings)
- [References](#references)

## Overview

Vim is a highly configurable text editor built to make creating and changing any kind of text very efficient. This document will describe how to set up Vim as powerful environment for programming such as Python.

## Installation

```bash
sudo apt-get update && sudo apt-get install -y \
    git vim fonts-powerline
```

## Vundle Plugin Manager

[Vundle](https://github.com/VundleVim/Vundle.vim) is short for _Vim_ bundle
and is a [Vim](http://www.vim.org/) plugin manager.

```bash
git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim

cat <<EOF > ~/.vimrc
set nocompatible              " required
filetype off                  " required

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
Plugin 'zxqfl/tabnine-vim'

" All of your Plugins must be added before the following line
call vundle#end()            " required
filetype plugin indent on    " required

" Syntax highlighting
syntax enable
let python_highlight_all=1

" Hide .pyc files
let NERDTreeIgnore=['\.pyc$', '\~$'] "ignore files in NERDTree

" Line numbering
set number

" Show a visual line under the cursor's current line
set cursorline

" Show the matching part of the pair for [] {} and ()
set showmatch

" Split navigations
nnoremap <C-J> <C-W><C-J>   " move to the split below
nnoremap <C-K> <C-W><C-K>   " move to the split above
nnoremap <C-L> <C-W><C-L>   " move to the split to the right
nnoremap <C-H> <C-W><C-H>   " move to the split to the left

nnoremap <F9> :Black<CR>

" Enable folding
set foldmethod=indent
set foldlevel=99

" Enable folding with the spacebar
nnoremap <space> za

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

" Flagging Unnecessary Whitespace
" This will mark extra whitespace as bad and probably color it red.
au BufRead,BufNewFile *.py,*.pyw,*.c,*.h match BadWhitespace /\s\+$/

" UTF-8 Support
set encoding=utf-8

" System Clipboard - access system clipboard
set clipboard=unnamed
EOF

# Install plugins from CLI
vim +PluginInstall +qall
```

## Key Mappings

## References

[1] Real Python, “VIM and Python – A Match Made in Heaven.” https://realpython.com/vim-and-python-a-match-made-in-heaven/ (accessed Jan. 10, 2021).

[2] Rossi B. Jonas, “Understand Vim Mappings and Create Your Own Shortcuts!” https://medium.com/vim-drops/understand-vim-mappings-and-create-your-own-shortcuts-f52ee4a6b8ed (accessed Jan. 10, 2021).
