# Mounting Windows Partitions

### NTFS

The **ntfs-3g** driver is used in Linux-based systems to read from and write to NTFS partitions.

NTFS (New Technology File System) is a file system developed by Microsoft and used by Windows computers

The userspace ntfs-3g driver now allows Linux-based systems to read from and write to NTFS formatted partitions.


```shell
sudo apt install ntfs-3g
sudo mkdir /media/storage
```

### Configuring /etc/fstab

If you require one or more of your Windows partitions mounted automatically during bootup, it is necessary to add one line to the file **/etc/fstab** for each partition that is to be mounted.

Some reasons for mounting partitions by means of /etc/fstab, rather than relying on the file manager,

```
sudo cp /etc/fstab /etc/fstab.backup
```

Next, you need to find what the UUID of your storage partition is

```shell
sudo blkid
```

Enter your password, and you’ll see some output resembling this:

```
/dev/sda1: UUID=”23A87DBF64597DF1″ TYPE=”ntfs”
/dev/sda2: UUID=”2479675e-2898-48c7-849f-132bb6d8f150″ TYPE=”ext4″
/dev/sda5: UUID=”66E53AEC54455DB2″ LABEL=”storage” TYPE=”ntfs”
/dev/sda6: UUID=”05bbf608-87fa-4473-9774-cf4b2602d8d6″ TYPE=”swap”
```

Now open `/etc/fstab` in a text editor with root privileges. In Ubuntu:

```shell
sudo vim /etc/fstab
```

For a general-purpose read-write mount, add this line to the end of /etc/fstab:

```
UUID=66E53AEC54455DB2 /media/storage/    ntfs-3g        auto,user,rw 0 0
```

Now save your edited /etc/fstab and close the text editor.

The partition(s) you have configured will be mounted the next time you reboot, but to mount them now:

```shell
sudo mount -a
```

### Configure Your Subfolders (Linux)

Open up terminal and enter the following command:

```shell
gedit .config/user-dirs.dirs
```

You can edit this to your liking

In place of where you see “$HOME/Downloads” you would put in an absolute folder location, like “/media/storage/Downloads”

Go ahead and create those folders, or whatever folders you’d like to call them, and put the path down for each of these

Here’s what the finished edit should look like:
