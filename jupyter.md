# Jupyter <!-- omit in toc -->

Project Jupyter exists to develop open-source software, open-standards, and services for interactive computing across dozens of programming languages.

## Contents <!-- omit in toc -->

- [Securing a notebook server](#securing-a-notebook-server)
  - [Prerequisite: A notebook configuration file](#prerequisite-a-notebook-configuration-file)
  - [Automatic Password setup](#automatic-password-setup)
  - [Using SSL for encrypted communication](#using-ssl-for-encrypted-communication)
  - [Running a public notebook server](#running-a-public-notebook-server)

<!-- ### JupyterLab -->

![](https://jupyter.org/assets/labpreview.png)

JupyterLab is a web-based interactive development environment for Jupyter notebooks, code, and data. JupyterLab is flexible: configure and arrange the user interface to support a wide range of workflows in data science, scientific computing, and machine learning. JupyterLab is extensible and modular: write plugins that add new components and integrate with existing ones.

## Securing a notebook server

### Prerequisite: A notebook configuration file

Check to see if you have a notebook configuration file, jupyter_notebook_config.py. The default location for this file is your Jupyter folder located in your home directory:

- Windows: `C:\Users\USERNAME\.jupyter\jupyter_notebook_config.py`
- OS X: `/Users/USERNAME/.jupyter/jupyter_notebook_config.py`
- Linux: `/home/USERNAME/.jupyter/jupyter_notebook_config.py`

If you don’t already have a Jupyter folder, or if your Jupyter folder doesn’t contain a notebook configuration file, run the following command:

```sh
jupyter notebook --generate-config
```

This command will create the Jupyter folder if necessary, and create notebook configuration file, `jupyter_notebook_config.py`, in this folder.

### Automatic Password setup

```sh
jupyter notebook password
# Enter password:  ****
# Verify password: ****
# > [NotebookPasswordApp] Wrote hashed password to /home/$USER/.jupyter/jupyter_notebook_config.json
```

### Using SSL for encrypted communication

When using a password, it is a good idea to also use SSL with a web certificate, so that your hashed password is not sent unencrypted by your browser.

You can start the notebook to communicate via a secure protocol mode by setting the certfile option to your self-signed certificate, i.e. `domain.crt`, with the command:

> More information about `openssl` can be found at: [OpenSSL Essentials](openssl.md)

```sh
jupyter lab --certfile=domain.crt --keyfile domain.key
```

### Running a public notebook server

If you want to access your notebook server remotely via a web browser, you can do so by running a public notebook server. For optimal security when running a public notebook server, you should first secure the server with a password and SSL/HTTPS as described in [Securing a notebook server](#securing-a-notebook-server).

Start by creating a certificate file and a hashed password, as explained in [Securing a notebook server](#securing-a-notebook-server).

In the `~/.jupyter` directory, edit the notebook config file, `jupyter_notebook_config.py`. By default, the notebook config file has all fields commented out. The minimum set of configuration options that you should uncomment and edit in `jupyter_notebook_config.py` is the following:

```
# Set options for certfile, ip, password, and toggle off
# browser auto-opening
c.NotebookApp.certfile = u'/absolute/path/to/your/certificate/domain.crt'
c.NotebookApp.keyfile = u'/absolute/path/to/your/certificate/domain.key'
# Set ip to '*' to bind on all interfaces (ips) for the public server
c.NotebookApp.ip = '*'
c.NotebookApp.open_browser = False

# It is a good idea to set a known, fixed port for server access
c.NotebookApp.port = 9999

# The directory to use for notebooks and kernels.
c.LabApp.notebook_dir = "/home/$USER"
```