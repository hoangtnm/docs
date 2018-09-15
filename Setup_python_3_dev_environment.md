# Setup Python 3 dev environment

### 1. Install Python 3 and Pip 3

Always use Python 3 and Pip 3 unless it's impossible.

Python 2.7 is the last of the 2.x series. Its EOL is January 1st, 2020, and there will be no updates, not even source-only security patches, after that date.

To build Python 3 from source, you can run the following script line by line, or save the whole text as file, "install-python.sh" for example, so you can run it with `sh install-python.sh`.

```
#!/bin/bash
export PYTHON_VERSION=3.6.5
export PYTHON_DOWNLOAD_URL=https://www.python.org/ftp/python/$PYTHON_VERSION/Python-$PYTHON_VERSION.tgz
sudo apt update
sudo apt install --no-install-recommends -y \
  software-properties-common build-essential \
  libssl-dev libreadline-dev libbz2-dev libsqlite3-dev zlib1g-dev tk-dev \
  python-minimal
wget "$PYTHON_DOWNLOAD_URL" -O python.tar.tgz
tar -zxvf python.tar.tgz
cd Python-$PYTHON_VERSION
./configure --enable-shared --enable-optimizations --enable-loadable-sqlite-extensions
make -j `nproc`
sudo make install

sudo rm /usr/bin/python && sudo ln -s /usr/local/bin/python3 /usr/bin/python
```

By default , `pip` is being automatically installed along as Python. But maybe it isn't there for some reason. In this case, you can manually install `pip` using `get-pip`.

```
mkdir /home/$USER/workspace && cd /home/$USER/workspace
curl https://bootstrap.pypa.io/get-pip.py -o get-pip.py
python3 get-pip.py
```

### 2. Virtual environments

Using virtual environment is recommended to work with Python and Pip. Since Python 3, you can create virtual environment as below:

```
python3 -m venv /path/to/new/virtual/environment
```

Never install the packages directly! They will be stored as global packages and may cause issues with permission, module scope, version conflict, etc by some ways that make you confusing.

A good approach is group your packages by kind of project. For example you known while doing Machine Learning project you often work with `tensorflow`, `numpy`, `opencv-python`; while building web apps you often need `flask`, `requests`, `pymongo`. So you can create 2 different virtual environments for each of project type.

```
# go to your workspace
cd ~/workspace
# create environment for machine learning projects
python3 -m venv ml-env
source ml-env/bin/activate
(ml-env) pip install tensorflow numpy opencv-python
# leave this envronment
(ml-env) deactivate
# create environment for regular web projects
python3 -m venv web-env
source web-env/bin/activate
(web-env) pip install flask requests pymongo
# list the installed packages in this environment
(web-env) pip list
```

Now you have 2 separate environments:

```
~/workspace
   + ml-env
   + web-env
```

When you work with machine learning project, just activate `ml-env` environment. Everything is already there for you. Similar to web projects.

One more important rule: always keep the `requirements.txt` files somewhere to manage the list of needed packages more effectively.

Each of development environment should have its own `requirements.txt`. For example `ml-requirements.txt` that contains list of packages for Machine Learning projects:

```
# cat ml-requirements.txt
numpy>=1.14
opencv-python>=3.4
tensorflow-gpu>=1.8
```
That makes your life easier when you want to share your development environment to your teammate or recreate the same environment in another computer.

```
cd ~/another-workspace
python3 -m venv another-ml-env
souce another-ml-env/bin/activate
(another-ml-env) pip install -r ml-requirements.txt
(another-ml-env) pip list
```

When you publish a repository, you should provide `requirements.txt` at the root folder to help other who want to run your code create the virtual environment as same as yours.

For more understanding:

- [Python Virtual Environments – A Primer](https://realpython.com/python-virtual-environments-a-primer/)
- [Virtual Environments and Packages](https://docs.python.org/3/tutorial/venv.html)
- [venv - Creation of virtual environments](https://docs.python.org/3/library/venv.html)

### 3. Jupyter Notebook

Jupyter Notebook is useful tool for learning Python, sharing and collaborating with your teammate on the stuff.

You can install Jupyter as pip package, within your favorite virtual environment. Don't follow [its official tips](http://jupyter.org/install)!

```
source ~/workspace/ml-env/bin/activate
(ml-env) pip install jupyter
(ml-env) jupyter notebook --ip 0.0.0.0 --port 7963
```

More about `jupyter` command:

- [Running the Notebook](https://jupyter.readthedocs.io/en/latest/running.html).
