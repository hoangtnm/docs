# Set swapfile on Raspberry

```shell
sudo su -c 'echo "CONF_SWAPSIZE=2048" > /etc/dphys-swapfile'
sudo dphys-swapfile setup
sudo dphys-swapfile swapon
```
