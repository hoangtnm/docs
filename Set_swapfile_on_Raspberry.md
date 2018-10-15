# Set swapfile on Raspberry

```shell
sudo su -c 'echo "CONF_SWAPSIZE=2048" > /etc/dphys-swapfile'
sudo dphys-swapfile setup
sudo dphys-swapfile swapon
```


### Use ZRAM as Super Fast Storage

ZRAM uses the Raspberry Pi’s built in hardware for swap data, rather than relying on the microSD card.

As the entire volume of RAM on your Pi is rarely in use, it makes sense to utilize this resource.

[This video and script](https://youtu.be/IBNZLREqBxg) from NovaSpiritTech explains how to use ZRAM to improve performance on your Raspberry Pi

```
sudo wget -O /usr/bin/zram.sh https://raw.githubusercontent.com/novaspirit/rpi_zram/master/zram.sh
sudo chmod +x /usr/bin/zram.sh
sudo vim /etc/rc.local

# Here, find the exit 0 line, and in the line above, add
/usr/bin/zram.sh &
# When you reboot your Pi, you’ll be using efficient ZRAM swapping rather than relying on spare (and slower) microSD card space.
``
