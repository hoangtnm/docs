# Create a MacOS installer


### Download MacOS

1. Download a macOS installer, such as macOS Mojave or macOS High Sierra.

```
To download macOS Mojave or High Sierra for this purpose, download from a Mac that is using macOS Sierra 10.12.5 or later, or El Capitan 10.11.6. Enterprise administrators, please download from Apple, not a locally hosted software-update server.
```

2. When the macOS installer opens, quit it without continuing installation.

3. Find the installer in your Applications folder as a single ”Install” file, such as Install macOS Mojave.

### Use the 'createinstallmedia' command in Terminal

1. After downloading the installer, connect the USB flash drive or other volume you're using for the bootable installer. Make sure that it has at least 12GB of available storage and is formatted as [Mac OS Extended](https://support.apple.com/en-vn/HT208496).

2. Open Terminal, which is in the Utilities folder of your Applications folder.

3. Type or paste one of the following commands in Terminal. These assume that the installer is still in your Applications folder, and MyVolume is the name of the USB flash drive or other volume you're using. If it has a different name, replace `MyVolume` accordingly.

```
sudo /Applications/Install\ macOS\ Mojave.app/Contents/Resources/createinstallmedia --volume /Volumes/MyVolume
```

4. Press Return after typing the command.

5. When prompted, type your administrator password and press Return again. Terminal doesn't show any characters as you type your password.

6. When prompted, type Y to confirm that you want to erase the volume, then press Return. Terminal shows the progress as the bootable installer is created.  

7. When Terminal says that it's done, the volume will have the same name as the installer you downloaded, such as Install macOS Mojave. You can now quit Terminal and eject the volume.

<p align="center">
  <img src="https://support.apple.com/library/content/dam/edam/applecare/images/en_US/macos/macos-high-sierra-terminal-create-bootable-installer.png" alt="MacOS">
</p>

### Use the bootable installer

After creating the bootable installer, follow these steps to use it.

1. Connect the bootable installer to a compatible Mac. 

2. Use Startup Manager or Startup Disk preferences to select the bootable installer as the startup disk, then start up from it. Your Mac will start up to macOS Recovery. 

3. Choose your language, if prompted.

4. A bootable installer doesn't download macOS from the Internet, but it does require the Internet to get information specific to your Mac model, such as firmware updates. If you need to connect to a Wi-Fi network, use the Wi-Fi menu  in the menu bar. 

5. Select Install macOS (or Install OS X) from the Utilities window, then click Continue and follow the onscreen instructions.
