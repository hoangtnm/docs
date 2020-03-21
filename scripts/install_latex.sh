#!/usr/bin/env bash

export LATEX_VERSION=2019
export CURR_DIR=$pwd

echo "Pre-installing: downloading, cleaning up" && \
wget https://mirror-hk.koddos.net/CTAN/systems/texlive/Images/texlive.iso && \
sudo rm -rf /usr/local/texlive/$LATEX_VERSION && \
rm -rf ~/.$LATEX_VERSION

echo "\nRunning the installer\n" && \
mount -t iso9660 -o ro,loop,noauto $CURR_DIR/texlive.iso /mnt && \
cd /mnt/ && \
./install-tl && \
echo "[... messages omitted ...]" && \
echo "Enter command: i" && \
echo "[... when done, see below for post-install ...]"

echo "Post-installing: setting PATH" && \
echo 'export PATH=/usr/local/texlive/2019/bin/x86_64-linux${PATH:+:${PATH}}' >> ~/.bashrc
if [[ -f ~/.zshrc ]]; then
	echo 'export PATH=/usr/local/texlive/2019/bin/x86_64-linux${PATH:+:${PATH}}' >> ~/.zshrc
fi
