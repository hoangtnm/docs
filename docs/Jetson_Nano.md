# Getting Started With Jetson Nano Developer Kit

## Enabling Desktop Sharing

Unfortunately the instructions helpfully left on the Jetson’s desktop on how to enable the installed VNC server from the command line don’t work, and going ahead and opening the Settings application on the desktop and clicking on `Desktop Sharing` also fails as the Settings app silently crashes. A problem that appears to be down to an incompatibility with the older Gnome desktop.

There are a number of ways you can approach this problem, the easiest route is a mix of command line and graphical fixes. The first thing you need to do is to edit the `org.gnome.Vino` schema to restore the missing enabled parameter.

```sh
sudo vim /usr/share/glib-2.0/schemas/org.gnome.Vino.gschema.xml
```

and go ahead and add the following key into the XML file.

```
<key name='enabled' type='b'>
    <summary>Enable remote access to the desktop</summary>
    <description>
    If true, allows remote access to the desktop via the RFB
    protocol. Users on remote machines may then connect to the
    desktop using a VNC viewer.
    </description>
    <default>false</default>
</key>
```

Then compile the Gnome schemas with the glib-compile-schemas command.

```sh
sudo glib-compile-schemas /usr/share/glib-2.0/schemas
```

This quick hack should stop the `Desktop Sharing` panel crashing, allowing you to open it. So go ahead and click on the `Settings` icon, and then the `Desktop Sharing` icon which is in the top row.

<p align=center>
    <img src=images/desktop_sharing.png>
</p>

Tick the `Allow other users to view your desktop` and also `Allow other users to control your desktop` check marks. Then make sure `You must confirm each access to this machine` is turned off. Finally tick the `Require the user to enter this password` check mark, and enter a password for the VNC session.

Close the `Settings` panel, then click on the green icon at the top left of your screen to open the `Search` panel. Type `startup applications` into the search box that appears at the top of the screen.

<p align=center>
    <img src=images/startup_applications.png>
</p>

Click on the application to open the `Startup Applications Preferences` panel. Here we can add VNC to the list of applications that are automatically started when you login to the computer.

<p align=center>
    <img src=images/edit_startup_programs.png>
</p>

Click Add at the right of the box, then type ‘Vino’ in the name box, and then in the command box enter `/usr/lib/vino/vino-server`. Finally you can add a comment, perhaps `VNC Server`. Click Save at the bottom right of the box, and then close the app.

Finally then open a Terminal and, somewhat regrettably, you’ll probably need to disable encryption of the VNC connection to get things working.

```sh
gsettings set org.gnome.Vino require-encryption false
gsettings set org.gnome.Vino prompt-enabled false
sudo reboot
```

You should now go ahead and reboot the board, and afterward the reboot, log back into your account. VNC should now be running and serving the desktop.
