#!/usr/bin/env bash

set -e

VERSION='0.21.1'
DOWNLOAD_URL="https://github.com/scikit-learn/scikit-learn/archive/${VERSION}.zip"

echo 'Installing Scikit-learn'
python3 -m pip install pytest setuptools

wget -O sklearn.zip "${DOWNLOAD_URL}"
unzip sklearn.zip
cd "scikit-learn-${VERSION}"
python3 -m pip install --editable .
