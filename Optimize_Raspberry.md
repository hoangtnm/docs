# Optimize Raspberry Pi 3 Model B


### 1. Connect a Reliable Power Supply

[Anker](https://www.anker.com/) and [Aukey](https://www.aukey.com/) are the recommended brands for power supply solutions

They provide `Adaptive Charging Technology` and an advanced multiple level protection system:

- [AUKEY AiPower Adaptive Charging Technology](https://www.aukeydirect.com/en/technologies-aukey#AiPower) gives all your USB powered devices exactly what they need with up to 2.4A.

- [Anker PowerIQ](https://www.anker.com/deals/poweriq) instantly identifies any connected device and adjusts voltage output for tailored, optimized charging speed.

- VoltageBoost™ is an Anker-exclusive technology that compensates for cable resistance by smoothing voltage output.


### 2. Use a High Performance microSD Card

Sandisk Ultra A1 and Sandisk Extreme V30 A1 are always the best candiates for performance purposes.

These microSD card are designed with `A1-rated` performance, which provides:

- Minimum Random Read of 1,500 IOPS (input/output operations per second)

- Minimum Random Write of 500 IOPS

- Minimum Sustained Sequential Write speed of 10MB/s

<p align="center">
  <img src="https://assets.hardwarezone.com/img/2017/06/P6290065.jpg">
</p>


### 3. Use ZRAM as Super Fast Storage

ZRAM uses the Raspberry Pi’s built in hardware for swap data, rather than relying on the microSD card.

As the entire volume of RAM on your Pi is rarely in use, it makes sense to utilize this resource.

[This video and script](https://youtu.be/IBNZLREqBxg) from NovaSpiritTech explains how to use ZRAM to improve performance on your Raspberry Pi

```
sudo wget -O /usr/bin/zram.sh https://raw.githubusercontent.com/novaspirit/rpi_zram/master/zram.sh
sudo chmod +x /usr/bin/zram.sh
sudo vim /etc/rc.local

# Here, find the exit 0 line, and in the line above, add
/usr/bin/zram.sh &
# When you reboot your Pi, you’ll be using efficient ZRAM swapping.
```


### 4. Remove Bloatware

```
sudo apt purge libreoffice* minecraft-pi sonic-pi
sudo apt clean
sudo apt autoremove
```


### 5. Set swapfile on Raspberry (When ZRAM is impossible)

```shell
sudo su -c 'echo "CONF_SWAPSIZE=2048" > /etc/dphys-swapfile'
sudo dphys-swapfile setup
sudo dphys-swapfile swapon
```
