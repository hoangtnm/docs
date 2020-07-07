#!/usr/bin/env bash

set -e

LATEX_VERSION=2020
CURR_DIR="$(pwd)"

echo 'Pre-installing: downloading, cleaning up'
wget 'https://mirror-hk.koddos.net/CTAN/systems/texlive/Images/texlive.iso'
rm -rf "/usr/local/texlive/${LATEX_VERSION}" ~/.$LATEX_VERSION

echo 'Running the installer'
mount -t iso9660 -o ro,loop,noauto $CURR_DIR/texlive.iso /mnt
/mnt/install-tl

#
# Environment setup
#

shell="$0"

echo 'export PATH=/usr/local/texlive/2020/bin/x86_64-linux${PATH:+:${PATH}}' >> ~/."${shell}rc"
