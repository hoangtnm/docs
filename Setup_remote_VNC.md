# Run a Remote Desktop on Raspberry Pi with VNC


### What Is VNC?

VNC uses the remote frame buffer protocol to give you control of another computer:

- transmitting keyboard and mouse input to the remote computer

- sending output back across the network to your display.

This means that you can launch programs remotely on your Raspberry Pi, adjust settings in the Raspbian GUI and generally use the desktop environment much as you would with the Pi plugged into your monitor.

### Setting up your Raspberry Pi

```
sudo apt update 
sudo apt install realvnc-vnc-server 
```

Alternatively, run the command `sudo raspi-config`, navigate to **Interfacing Options > VNC** and select **Yes**.

### Getting connected to your Raspberry Pi

There are two ways to connect; you can use either or both. Please make sure you’ve downloaded our [VNC Viewer app](https://www.realvnc.com/en/connect/download/viewer/) to computers or devices you want to control from.

#### Establishing a direct connection
 
Direct connections are quick and simple providing you’re joined to the same private local network as your Raspberry Pi (for example, a wired or Wi-Fi network at home, school or in the office).

1. On your Raspberry Pi, discover its private IP address by double-clicking the VNC Server icon on the taskbar and examining the status dialog:

<p>
  <img src='https://www.realvnc.com/en/connect/_images/raspberry-pi-direct-address.png'>
</p>

2. On the device you will use to take control, run VNC Viewer and enter the IP address in the search bar:

<p>
  <img src='https://www.realvnc.com/en/connect/_images/raspberry-pi-direct-connect.png'>
</p>

#### Running directly rendered apps such as Minecraft remotely

VNC Server can remote the screen of Raspberry Pi apps that use a directly rendered overlay, such as Minecraft, the text console, the Pi camera module, and more.

<p>
  <img src='https://www.realvnc.com/en/connect/_images/raspberry-pi-minecraft.png'>
</p>

To turn this feature on, open the VNC Server dialog, navigate to **Menu > Options > Troubleshooting**, and select **Enable experimental direct capture mode**. On the device you will use to take control, run VNC Viewer and connect (if already connected, you’ll need to reconnect).

Direct screen capture is an experimental feature in VNC Server in Service mode only. If you’re connecting from a desktop computer and mouse movements seem erratic, try pressing F8 to open the VNC Viewer shortcut menu, and select **Relative Pointer Motion**.

If performance seems impaired, try:

On your Raspberry Pi, run sudo `raspi-config`, navigate to Advanced options > Memory Split, and ensure your GPU has at least 128MB.

#### Creating and remoting a virtual desktop

If your Raspberry Pi is headless (that is, not plugged into a monitor) or embedded in a robot, it’s unlikely to be running a graphical desktop.

VNC Server can run in Virtual Mode to create a resource-efficient virtual desktop on demand, giving you graphical remote access even when there is no actual desktop to remote. This virtual desktop exists only in your Raspberry Pi’s memory:

<p>
  <img src='https://www.realvnc.com/en/connect/_images/raspberry-pi-virtual.png'>
</p>

To do this:

1. On your Raspberry Pi, run the command `vncserver`. Make a note of the IP address/display number printed to the console, for example `192.167.5.149:1`.

2. On the device you will use to take control, enter this information in VNC Viewer.

#### Operating VNC Server at the command line

To start VNC Server now: `sudo systemctl start vncserver-x11-serviced.service`

To start VNC Server at next boot, and every subsequent boot: `sudo systemctl enable vncserver-x11-serviced.service`

To stop VNC Server: `sudo systemctl stop vncserver-x11-serviced.service`

To prevent VNC Server starting at boot: `sudo systemctl disable vncserver-x11-serviced.service`
