# Running a jupyter notebook server

## Overview

The `Jupyter notebook` web application is based on a server-client structure.

The notebook server uses a [two-process kernel architecture](https://ipython.readthedocs.io/en/stable/overview.html#ipythonzmq) based on ZeroMQ, as well as Tornado for serving HTTP requests.

```bash
jupyter notebook --ip $IP_ADDRESS --port $PORT
```
